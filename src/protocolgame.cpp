// Copyright 2022 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "protocolgame.h"

#include "actions.h"
#include "ban.h"
#include "combat.h"
#include "condition.h"
#include "configmanager.h"
#include "depotchest.h"
#include "events.h"
#include "game.h"
#include "inbox.h"
#include "iologindata.h"
#include "iomarket.h"
#include "monster.h"
#include "npc.h"
#include "outfit.h"
#include "outputmessage.h"
#include "player.h"
#include "podium.h"
#include "scheduler.h"
#include "storeinbox.h"

extern ConfigManager g_config;
extern Actions actions;
extern CreatureEvents* g_creatureEvents;
extern Chat* g_chat;
extern Events* g_events;

namespace {

std::deque<std::pair<int64_t, uint32_t>> waitList; // (timeout, player guid)
auto priorityEnd = waitList.end();

auto findClient(uint32_t guid) {
	std::size_t slot = 1;
	for (auto it = waitList.begin(), end = waitList.end(); it != end; ++it, ++slot) {
		if (it->second == guid) {
			return std::make_pair(it, slot);
		}
	}
	return std::make_pair(waitList.end(), slot);
}

constexpr int64_t getWaitTime(std::size_t slot)
{
	if (slot < 5) {
		return 5;
	} else if (slot < 10) {
		return 10;
	} else if (slot < 20) {
		return 20;
	} else if (slot < 50) {
		return 60;
	} else {
		return 120;
	}
}

constexpr int64_t getTimeout(std::size_t slot)
{
	// timeout is set to 15 seconds longer than expected retry attempt
	return getWaitTime(slot) + 15;
}

std::size_t clientLogin(const Player& player)
{
	if (player.hasFlag(PlayerFlag_CanAlwaysLogin) || player.getAccountType() >= ACCOUNT_TYPE_GAMEMASTER) {
		return 0;
	}

	uint32_t maxPlayers = static_cast<uint32_t>(g_config.getNumber(ConfigManager::MAX_PLAYERS));
	if (maxPlayers == 0 || (waitList.empty() && g_game.getPlayersOnline() < maxPlayers)) {
		return 0;
	}

	int64_t time = OTSYS_TIME();

	auto it = waitList.begin();
	while (it != waitList.end()) {
		if ((it->first - time) <= 0) {
			it = waitList.erase(it);
		} else {
			++it;
		}
	}

	std::size_t slot;
	std::tie(it, slot) = findClient(player.getGUID());
	if (it != waitList.end()) {
		// If server has capacity for this client, let him in even though his current slot might be higher than 0.
		if ((g_game.getPlayersOnline() + slot) <= maxPlayers) {
			waitList.erase(it);
			return 0;
		}

		//let them wait a bit longer
		it->first = time + (getTimeout(slot) * 1000);
		return slot;
	}

	if (player.isPremium()) {
		priorityEnd = waitList.emplace(priorityEnd, time + (getTimeout(slot + 1) * 1000), player.getGUID());
		return std::distance(waitList.begin(), priorityEnd);
	}

	waitList.emplace_back(time + (getTimeout(waitList.size() + 1) * 1000), player.getGUID());
	return waitList.size();
}

}

void ProtocolGame::release()
{
	//dispatcher thread
	if (player && player->client == shared_from_this()) {
		player->client.reset();
		player->decrementReferenceCounter();
		player = nullptr;
	}

	OutputMessagePool::getInstance().removeProtocolFromAutosend(shared_from_this());
	Protocol::release();
}

void ProtocolGame::login(const std::string& name, uint32_t accountId, OperatingSystem_t operatingSystem)
{
	//dispatcher thread
	Player* foundPlayer = g_game.getPlayerByName(name);
	bool isLogin = !foundPlayer || g_config.getBoolean(ConfigManager::ALLOW_CLONES);

	if (isLogin) {
		player = new Player(getThis());
		player->setName(name);

		player->incrementReferenceCounter();
		player->setID();

		if (!IOLoginData::preloadPlayer(player, name)) {
			disconnectClient("Your character could not be loaded.");
			return;
		}

		if (IOBan::isPlayerNamelocked(player->getGUID())) {
			disconnectClient("Your character has been namelocked.");
			return;
		}

		if (g_game.getGameState() == GAME_STATE_CLOSING && !player->hasFlag(PlayerFlag_CanAlwaysLogin)) {
			disconnectClient("The game is just going down.\nPlease try again later.");
			return;
		}

		if (g_game.getGameState() == GAME_STATE_CLOSED && !player->hasFlag(PlayerFlag_CanAlwaysLogin)) {
			disconnectClient("Server is currently closed.\nPlease try again later.");
			return;
		}

		if (g_config.getBoolean(ConfigManager::ONE_PLAYER_ON_ACCOUNT) && player->getAccountType() < ACCOUNT_TYPE_GAMEMASTER && g_game.getPlayerByAccount(player->getAccount())) {
			disconnectClient("You may only login with one character\nof your account at the same time.");
			return;
		}

		if (!player->hasFlag(PlayerFlag_CannotBeBanned)) {
			BanInfo banInfo;
			if (IOBan::isAccountBanned(accountId, banInfo)) {
				if (banInfo.reason.empty()) {
					banInfo.reason = "(none)";
				}

				if (banInfo.expiresAt > 0) {
					disconnectClient(fmt::format("Your account has been banned until {:s} by {:s}.\n\nReason specified:\n{:s}", formatDateShort(banInfo.expiresAt), banInfo.bannedBy, banInfo.reason));
				} else {
					disconnectClient(fmt::format("Your account has been permanently banned by {:s}.\n\nReason specified:\n{:s}", banInfo.bannedBy, banInfo.reason));
				}
				return;
			}
		}

		if (std::size_t currentSlot = clientLogin(*player)) {
			uint8_t retryTime = getWaitTime(currentSlot);
			auto output = OutputMessagePool::getOutputMessage();
			output->addByte(0x16);
			output->addString(fmt::format("Too many players online.\nYou are at place {:d} on the waiting list.", currentSlot));
			output->addByte(retryTime);
			send(output);
#ifdef DEBUG_DISCONNECT
			console::print(CONSOLEMESSAGE_TYPE_INFO, "[DEBUG] Disconnected (code 14)");
#endif
			disconnect();
			return;
		}

		if (!IOLoginData::loadPlayerById(player, player->getGUID())) {
			disconnectClient("Your character could not be loaded.");
			return;
		}

		player->setOperatingSystem(operatingSystem);

		if (!g_game.placeCreature(player, player->getLoginPosition())) {
			if (!g_game.placeCreature(player, player->getTemplePosition(), false, true)) {
				disconnectClient("Temple position is wrong. Contact the administrator.");
				return;
			}
		}

		if (operatingSystem >= CLIENTOS_OTCLIENT_LINUX) {
			player->registerCreatureEvent("ExtendedOpcode");
		}

		// initialize account currencies
		addGameTask(([=, playerGUID = player->getGUID()]() { g_game.playerRegisterCurrencies(playerGUID); }));

		player->lastIP = player->getIP();
		player->lastLoginSaved = std::max<time_t>(time(nullptr), player->lastLoginSaved + 1);
		acceptPackets = true;

		lastName = name;
		lastAccountId = accountId;
		lastOperatingSystem = operatingSystem;

		// send blessings
		sendBlessings();

		// restore player channels
		player->restoreChannelIDs();

		// restore player party
		if (lastPartyId != 0) {
			addGameTask(([=, playerID = player->getID(), partyID = lastPartyId]() { g_game.restorePlayerParty(playerID, partyID); }));
		}

#ifdef DEBUG_DISCONNECT
		console::print(CONSOLEMESSAGE_TYPE_INFO, "[DEBUG] Connecting (code 36)");
#endif

		addGameTask(([=, playerID = player->getID()]() { g_game.playerConnect(playerID, isLogin); }));
	} else {
		if (eventConnect != 0 || !g_config.getBoolean(ConfigManager::REPLACE_KICK_ON_LOGIN)) {
			//Already trying to connect
			disconnectClient("You are already logged in.");
			return;
		}

		if (foundPlayer->client) {
#ifdef DEBUG_DISCONNECT
			console::print(CONSOLEMESSAGE_TYPE_INFO, "[DEBUG] Disconnected (code 12)");
#endif
			foundPlayer->disconnect();
			foundPlayer->isConnecting = true;

			eventConnect = g_scheduler.addEvent(createSchedulerTask(1000, ([=, thisPtr = getThis(), playerID = foundPlayer->getID()]() {
				thisPtr->connect(playerID, operatingSystem);
			})));
		} else {
			connect(foundPlayer->getID(), operatingSystem);
		}

		lastName = name;
		lastAccountId = accountId;
		lastOperatingSystem = operatingSystem;

		//send blessings
		sendBlessings();

#ifdef DEBUG_DISCONNECT
		console::print(CONSOLEMESSAGE_TYPE_INFO, "[DEBUG] Reconnected (code 35)");
#endif

		addGameTask(([=, playerID = foundPlayer->getID()]() { g_game.playerConnect(playerID, isLogin); }));
	}

	OutputMessagePool::getInstance().addProtocolToAutosend(shared_from_this());
}


void ProtocolGame::sendRelogCancel(const std::string& msg, bool isRelog)
{
	if (isRelog) {
		disconnectClient(msg);
		return;
	}

	player->sendCancelMessage(msg);
}

void ProtocolGame::fastRelog(const std::string& otherPlayerName)
{
	//dispatcher thread
	if (!player || player->isRemoved()) {
		return;
	}

	// get client type
	OperatingSystem_t operatingSystem = player->getOperatingSystem();

	// read requested player info
	bool isRelog = false;
	Player* otherPlayer = g_game.getPlayerByName(otherPlayerName);
	if (otherPlayer) {
		if (otherPlayer->isRemoved()) {
			player->sendCancelMessage("An error occured. Please try again later.");
			return;
		}

		if (player->getAccount() != otherPlayer->getAccount()) {
			player->sendCancelMessage("Your character could not be loaded.");
			return;
		}

		// handle relog to same character situation
		if (player->getID() == otherPlayer->getID()) {
			// send logout effect
			if (!player->isInGhostMode()) {
				g_game.addMagicEffect(player->getPosition(), CONST_ME_POFF);
			}

			// unlink player client
			player->client = nullptr;

			// logout
			g_game.removeCreature(player);
			otherPlayer = nullptr;
			isRelog = true;
		}
	}

	// handle login situation
	bool isLogin = !otherPlayer || g_config.getBoolean(ConfigManager::ALLOW_CLONES);
	if (isLogin) {
		otherPlayer = new Player(nullptr);
		otherPlayer->setName(otherPlayerName);

		otherPlayer->incrementReferenceCounter();
		otherPlayer->setID();

		if (isRelog) {
			// use a new object instead of removed one
			this->player = otherPlayer;
			otherPlayer->client = getThis();
		}

		// fetch base player info from the database
		if (!IOLoginData::preloadPlayer(otherPlayer, otherPlayerName)) {
			sendRelogCancel("Your character could not be loaded.", isRelog);
			return;
		}

		// check accounts
		if (player->getAccount() != otherPlayer->getAccount()) {
			player->sendCancelMessage("Your character could not be loaded.");
			return;
		}

		// check namelock
		if (IOBan::isPlayerNamelocked(otherPlayer->getGUID())) {
			sendRelogCancel("Your character has been namelocked.", isRelog);
			return;
		}

		// server closed
		if (!otherPlayer->hasFlag(PlayerFlag_CanAlwaysLogin)) {
			GameState_t gameState = g_game.getGameState();
			if (gameState == GAME_STATE_CLOSING) {
				sendRelogCancel("The game is just going down.\nPlease try again later.", isRelog);
				return;
			} else if (gameState == GAME_STATE_CLOSED) {
				sendRelogCancel("Server is currently closed.\nPlease try again later.", isRelog);
				return;
			}
		}

		// disconnect if banned
		if (!otherPlayer->hasFlag(PlayerFlag_CannotBeBanned)) {
			BanInfo banInfo;
			if (IOBan::isAccountBanned(otherPlayer->getAccount(), banInfo)) {
				if (banInfo.reason.empty()) {
					banInfo.reason = "(none)";
				}

				if (banInfo.expiresAt > 0) {
					disconnectClient(fmt::format("Your account has been banned until {:s} by {:s}.\n\nReason specified:\n{:s}", formatDateShort(banInfo.expiresAt), banInfo.bannedBy, banInfo.reason));
				} else {
					disconnectClient(fmt::format("Your account has been permanently banned by {:s}.\n\nReason specified:\n{:s}", banInfo.bannedBy, banInfo.reason));
				}

				if (!isRelog) {
					// send logout effect
					if (!player->isInGhostMode()) {
						g_game.addMagicEffect(player->getPosition(), CONST_ME_POFF);
					}

					// remove
					g_game.removeCreature(player);
				}

				return;
			}
		}
	}

	// handle same char relog situation
	bool sameClient = otherPlayer->client && (otherPlayer->client == getThis());
	if (!sameClient) {
		// logged from another place - check config value
		if (!g_config.getBoolean(ConfigManager::REPLACE_KICK_ON_LOGIN)) {
			player->sendCancelMessage("You are already logged in.");
			return;
		}

		// disconnect other client
#ifdef DEBUG_DISCONNECT
		console::print(CONSOLEMESSAGE_TYPE_INFO, "[DEBUG] Disconnected (code 13)");
#endif
		otherPlayer->disconnect();
	}

	// memorize player channels
	player->storeChannelIDs(true);

	// unlink player-specific channels
	player->sendClosePrivate(CHANNEL_PARTY);
	player->sendClosePrivate(CHANNEL_GUILD);
	player->sendClosePrivate(CHANNEL_GUILD_LEADER);

	// unlink party
	lastPartyId = 0;

	// logout (already done in relog situation)
	if (!isRelog) {
		// send logout effect
		if (!player->isInGhostMode()) {
			g_game.addMagicEffect(player->getPosition(), CONST_ME_POFF);
		}

		// unlink player client
		player->client = nullptr;

		// logout the current character
		g_game.removeCreature(player);
	}

	// make sure the camera will follow the player
	knownCreatureMap.clear();

	// copy client information
	otherPlayer->setOperatingSystem(operatingSystem);

	// set player ip
	otherPlayer->lastIP = getIP();

	// restore client communication
	otherPlayer->client = getThis();
	this->player = otherPlayer;

	if (isLogin) {
		// multiclient check
		if (g_config.getBoolean(ConfigManager::ONE_PLAYER_ON_ACCOUNT) && otherPlayer->getAccountType() < ACCOUNT_TYPE_GAMEMASTER && g_game.getPlayerByAccount(otherPlayer->getAccount())) {
			disconnectClient("You may only login with one character\nof your account at the same time.");
			return;
		}

		// fetch full player info
		if (!IOLoginData::loadPlayerById(otherPlayer, otherPlayer->getGUID())) {
			disconnectClient("Your character could not be loaded.");
			return;
		}

		// place player on the map
		if (!g_game.placeCreature(otherPlayer, otherPlayer->getLoginPosition())) {
			if (!g_game.placeCreature(otherPlayer, otherPlayer->getTemplePosition(), false, true)) {
				disconnectClient("Temple position is wrong. Contact the administrator.");
				return;
			}
		}

		// enable otc feature
		if (operatingSystem >= CLIENTOS_OTCLIENT_LINUX) {
			otherPlayer->registerCreatureEvent("ExtendedOpcode");
		}

		// initialize account currencies
		addGameTask(([=, playerGUID = otherPlayer->getGUID()]() { g_game.playerRegisterCurrencies(playerGUID); }));

		// update last login info
		otherPlayer->lastLoginSaved = std::max<time_t>(time(nullptr), otherPlayer->lastLoginSaved + 1);
	}

	// send player stats
	sendStats(); // hp, cap, level, xp rate, etc.
	sendSkills(); // skills and special skills
	player->sendIcons(); // active conditions

	// send client info
	sendClientFeatures(); // player speed, bug reports, store url, pvp mode, etc
	sendBasicData(); // premium account, vocation, known spells, prey system status, magic shield status
	sendItems(); // send carried items for action bars

	// send game screen
	sendMapDescription(player->getPosition());

	// send login effect
	if (isLogin && !player->isInGhostMode()) {
		g_game.addMagicEffect(player->getPosition(), CONST_ME_TELEPORT);
	}

	// send inventory
	for (int i = CONST_SLOT_FIRST; i <= CONST_SLOT_LAST; ++i) {
		sendInventoryItem(static_cast<slots_t>(i), player->getInventoryItem(static_cast<slots_t>(i)));
	}
	sendInventoryItem(CONST_SLOT_STORE_INBOX, player->getStoreInbox()->getItem());

	// player light level
	sendCreatureLight(dynamic_cast<const Creature*>(player));

	// vip list
	sendVIPEntries();

	// opened containers
	player->openSavedContainers();

	// remember last relog
	lastName = otherPlayerName;

	// update blessings
	sendBlessings();

	// restore player channels
	player->restoreChannelIDs();

	// restore player party (if applicable)
	if (lastPartyId != 0) {
		addGameTask(([=, playerID = player->getID(), partyID = lastPartyId]() { g_game.restorePlayerParty(playerID, partyID); }));
	}

	// event onConnect
	addGameTask(([=, playerID = otherPlayer->getID()]() { g_game.playerConnect(playerID, isLogin); }));
}

void ProtocolGame::connect(uint32_t playerId, OperatingSystem_t operatingSystem)
{
	eventConnect = 0;

	Player* foundPlayer = g_game.getPlayerByID(playerId);
	if (!foundPlayer || foundPlayer->client) {
		disconnectClient("You are already logged in.");
		return;
	}

	if (isConnectionExpired()) {
		//ProtocolGame::release() has been called at this point and the Connection object
		//no longer exists, so we return to prevent leakage of the Player.
		return;
	}

	player = foundPlayer;
	player->incrementReferenceCounter();

	g_chat->removeUserFromAllChannels(*player);
	player->clearModalWindows();
	player->setOperatingSystem(operatingSystem);
	player->isConnecting = false;
	player->client = getThis();

	// send player data
	sendAddCreature(player, player->getPosition(), 0);

	// update last login
	player->lastIP = player->getIP();
	player->lastLoginSaved = std::max<time_t>(time(nullptr), player->lastLoginSaved + 1);

	// reset idle events
	player->resetIdleTime(true);
	player->receivePing();

	acceptPackets = true;
}

void ProtocolGame::logout(bool displayEffect, bool forced, const std::string& message)
{
	//dispatcher thread
	if (!player) {
		return;
	}

	if (!player->isRemoved()) {
		if (!forced) {
			if (!player->isAccessPlayer()) {
				if (player->getTile()->hasFlag(TILESTATE_NOLOGOUT)) {
					player->sendCancelMessage(RETURNVALUE_YOUCANNOTLOGOUTHERE);
					return;
				}

				if (!player->getTile()->hasFlag(TILESTATE_PROTECTIONZONE) && player->hasCondition(CONDITION_INFIGHT)) {
					player->sendCancelMessage(RETURNVALUE_YOUMAYNOTLOGOUTDURINGAFIGHT);
					return;
				}
			}

			//scripting event - onLogout
			if (!g_creatureEvents->playerLogout(player)) {
				//Let the script handle the error message
				return;
			}
		}

		if (displayEffect && player->getHealth() > 0 && !player->isInGhostMode()) {
			g_game.addMagicEffect(player->getPosition(), CONST_ME_POFF);
		}
	}

	sendSessionEnd(SESSION_END_LOGOUT);
	if (!message.empty()) {
		disconnectClient(message);
	} else {
#ifdef DEBUG_DISCONNECT
		console::print(CONSOLEMESSAGE_TYPE_INFO, "[DEBUG] Disconnected (code 15)");
#endif
		disconnect();
	}

	g_game.removeCreature(player);
}

// Login to the game world request
void ProtocolGame::onRecvFirstMessage(NetworkMessage& msg)
{
	// Server is shutting down
	if (g_game.getGameState() == GAME_STATE_SHUTDOWN) {
#ifdef DEBUG_DISCONNECT
		console::print(CONSOLEMESSAGE_TYPE_INFO, "[DEBUG] Disconnected (code 16)");
#endif
		disconnect();
		return;
	}

	// Client type and OS used
	OperatingSystem_t operatingSystem = static_cast<OperatingSystem_t>(msg.get<uint16_t>());

	version = msg.get<uint16_t>(); // U16 client version
	msg.skipBytes(4); // U32 client version
	
	// String client version
	if (version >= 1240) {
		if (msg.getLength() - msg.getBufferPosition() > 132) {
			msg.getString();
		}
	}

	msg.skipBytes(3); // U16 dat revision, U8 preview state

	// Disconnect if RSA decrypt fails
	if (!Protocol::RSA_decrypt(msg)) {
#ifdef DEBUG_DISCONNECT
		console::print(CONSOLEMESSAGE_TYPE_INFO, "[DEBUG] Disconnected (code 17)");
#endif
		disconnect();
		return;
	}

	// Get XTEA key
	xtea::key key;
	key[0] = msg.get<uint32_t>();
	key[1] = msg.get<uint32_t>();
	key[2] = msg.get<uint32_t>();
	key[3] = msg.get<uint32_t>();
	enableXTEAEncryption();
	setXTEAKey(std::move(key));

	// Enable extended opcode feature for otclient
	if (operatingSystem >= CLIENTOS_OTCLIENT_LINUX) {
		NetworkMessage opcodeMessage;
		opcodeMessage.addByte(0x32);
		opcodeMessage.addByte(0x00);
		opcodeMessage.add<uint16_t>(0x00);
		writeToOutputBuffer(opcodeMessage);
	}

	// Change packet verifying mode for QT clients
	if (version >= 1111 && operatingSystem >= CLIENTOS_QT_LINUX && operatingSystem < CLIENTOS_OTCLIENT_LINUX) {
		setChecksumMode(CHECKSUM_SEQUENCE);
	}
	
	// Web login skips the character list request so we need to check the client version again
	if (version < CLIENT_VERSION_MIN || version > CLIENT_VERSION_MAX) {
		disconnectClient(fmt::format("Only clients with protocol {:s} allowed!", CLIENT_VERSION_STR));
		return;
	}
	
	msg.skipBytes(1); // Gamemaster flag

	std::string sessionKey = msg.getString();
	auto sessionArgs = explodeString(sessionKey, "\n", 4); // acc name or email, password, token, timestamp divided by 30
	if (sessionArgs.size() < 2) {
		disconnectClient("Malformed session key.");
		return;
	}

	if (operatingSystem == CLIENTOS_QT_LINUX) {
		msg.getString(); // OS name (?)
		msg.getString(); // OS version (?)
	}

	std::string& accountName = sessionArgs[0];
	std::string& password = sessionArgs[1];
	if (accountName.empty()) {
		disconnectClient("You must enter your account name.");
		return;
	}

	std::string token;
	uint32_t tokenTime = 0;

	// two-factor auth
	if (g_config.getBoolean(ConfigManager::TWO_FACTOR_AUTH)) {
		if (sessionArgs.size() < 4) {
			disconnectClient("Authentication failed. Incomplete session key.");
			return;
		}

		token = sessionArgs[2];

		try {
			tokenTime = std::stoul(sessionArgs[3]);
		} catch (const std::invalid_argument&) {
			disconnectClient("Malformed token packet.");
			return;
		} catch (const std::out_of_range&) {
			disconnectClient("Token time is too long.");
			return;
		}
	} else {
		tokenTime = std::floor(challengeTimestamp / 30);
	}

	std::string characterName = msg.getString();
	uint32_t timeStamp = msg.get<uint32_t>();
	uint8_t randNumber = msg.getByte();
	if (challengeTimestamp != timeStamp || challengeRandom != randNumber) {
#ifdef DEBUG_DISCONNECT
		console::print(CONSOLEMESSAGE_TYPE_INFO, "[DEBUG] Disconnected (code 18)");
#endif
		disconnect();
		return;
	}

	if (g_game.getGameState() == GAME_STATE_STARTUP) {
		disconnectClient("Gameworld is starting up. Please wait.");
		return;
	}

	if (g_game.getGameState() == GAME_STATE_MAINTAIN) {
		disconnectClient("Gameworld is under maintenance. Please re-connect in a while.");
		return;
	}

	BanInfo banInfo;
	if (IOBan::isIpBanned(getIP(), banInfo)) {
		if (banInfo.reason.empty()) {
			banInfo.reason = "(none)";
		}

		disconnectClient(fmt::format("Your IP has been banned until {:s} by {:s}.\n\nReason specified:\n{:s}", formatDateShort(banInfo.expiresAt), banInfo.bannedBy, banInfo.reason));
		return;
	}

	uint32_t accountId = IOLoginData::gameworldAuthentication(accountName, password, characterName, token, tokenTime);
	if (accountId == 0) {
		disconnectClient("Account name or password is not correct.");
		return;
	}

	addGameTask(([=, thisPtr = getThis(), characterName = std::move(characterName)]() { thisPtr->login(characterName, accountId, operatingSystem); }));
}

void ProtocolGame::onConnect()
{
	auto output = OutputMessagePool::getOutputMessage();
	static std::random_device rd;
	static std::ranlux24 generator(rd());
	static std::uniform_int_distribution<uint16_t> randNumber(0x00, 0xFF);

	// Skip checksum
	output->skipBytes(sizeof(uint32_t));

	// Packet length & type
	output->add<uint16_t>(0x0006);
	output->addByte(0x1F);

	// Add timestamp & random number
	challengeTimestamp = static_cast<uint32_t>(time(nullptr));
	output->add<uint32_t>(challengeTimestamp);

	challengeRandom = randNumber(generator);
	output->addByte(challengeRandom);

	// Go back and write checksum
	output->skipBytes(-12);
	output->add<uint32_t>(adlerChecksum(output->getOutputBuffer() + sizeof(uint32_t), 8));

	send(output);
}

void ProtocolGame::disconnectClient(const std::string& message) const
{
	auto output = OutputMessagePool::getOutputMessage();
	output->addByte(0x14);
	output->addString(message);
	send(output);
#ifdef DEBUG_DISCONNECT
	console::print(CONSOLEMESSAGE_TYPE_INFO, "[DEBUG] Disconnected (code 11)");
#endif
	disconnect();
}

void ProtocolGame::writeToOutputBuffer(const NetworkMessage& msg)
{
	auto out = getOutputBuffer(msg.getLength());
	out->append(msg);
}

/*
	SEND METHODS
		Invalid = 0x00,
		Invalid_1 = 0x01,
		Invalid_2 = 0x02,

		CreatureData = 0x03,
		SessionDumpStart = 0x04,

		Invalid_3 = 0x05,
		Invalid_4 = 0x06,
		Invalid_5 = 0x07,
		Invalid_6 = 0x08,
		Invalid_7 = 0x09,

		PendingStateEntered = 0x0A,
		ReadyForSecondaryConnection = 0x0B,

		Invalid_8 = 0x0C,
		Invalid_9 = 0x0D,
		Invalid_10 = 0x0E,

		WorldEntered = 0x0F,

		Invalid_11 = 0x10,
		Invalid_12 = 0x11,
		Invalid_13 = 0x12,
		Invalid_14 = 0x13,

		LoginError = 0x14,
		LoginAdvice = 0x15,
		LoginWait = 0x16,
		LoginSuccess = 0x17,
		LogoutSession = 0x18,
		StoreButtonIndicators = 0x19,

		Invalid_15 = 0x1A,
		Invalid_16 = 0x1B,
		Invalid_17 = 0x1C,

		Ping = 0x1D,
		PingBack = 0x1E,
		LoginChallenge = 0x1F,

		Invalid_18 = 0x20, // OTC opcode
		Invalid_19 = 0x21,
		Invalid_20 = 0x22,
		Invalid_21 = 0x23,
		Invalid_22 = 0x24,
		Invalid_23 = 0x25,
		Invalid_24 = 0x26,
		Invalid_25 = 0x27,

		Dead = 0x28, // death screen
		Stash = 0x29,
		//DepotTileState = 0x2A,
		SpecialContainersAvailable = 0x2A,
		PartyHuntAnalyser = 0x2B,
		//SpecialContainersAvailable = 0x2C,
		TeamFinderTeamLeader = 0x2C,
		TeamFinderTeamMember = 0x2D,

		// 0x2E - 0x58 - huge empty gap (assumed)

		Invalid_0x59 = 0x59,
		Invalid_0x5A = 0x5A,
		Invalid_0x5B = 0x5B,
		Invalid_0x5C = 0x5C,

		ImbuCooldowns = 0x5D,

		Undiscovered_0x5E = 0x5E,

		WheelOfDestinyUI = 0x5F,

		Undiscovered_ItemList = 0x60,

		BosstiaryData = 0x61,
		BosstiaryCyclopediaBossSlots = 0x62,

		// draw on game screen
		ClientCheck = 0x63,
		FullMap = 0x64,
		TopRow = 0x65,
		RightColumn = 0x66,
		BottomRow = 0x67,
		LeftColumn = 0x68,
		FieldData = 0x69,
		CreateOnMap = 0x6A,
		ChangeOnMap = 0x6B,
		DeleteOnMap = 0x6C,
		MoveCreature = 0x6D,

		// draw in container
		Container = 0x6E,
		CloseContainer = 0x6F,
		CreateInContainer = 0x70,
		ChangeInContainer = 0x71,
		DeleteInContainer = 0x72,

		BosstiaryCyclopediaKillsPanel = 0x73,
		FriendSystemData = 0x74,
		ScreenshotEvent = 0x75,
		InspectionList = 0x76,
		InspectionState = 0x77,
		SetInventory = 0x78,
		DeleteInventory = 0x79,
		NpcOffer = 0x7A,
		PlayerGoods = 0x7B,
		CloseNpcTrade = 0x7C,
		OwnOffer = 0x7D,
		CounterOffer = 0x7E,
		CloseTrade = 0x7F,
		CharacterTradeConfiguration = 0x80,
		ReportTextUI = 0x81,
		Ambiente = 0x82, // world light
		GraphicalEffects = 0x83, // sendMagicEffect, sendDistanceEffect, sounds
		RemoveGraphicalEffect = 0x84,
		MissileEffect = 0x85, // sound/music packet now
		ForgingBasicData = 0x86, // meta
		ExaltationForge = 0x87, // ui

		ExaltationForgeHistory = 0x89,
		CreatureUpdate = 0x8B,
		CreatureHealth = 0x8C,
		CreatureLight = 0x8D,
		CreatureOutfit = 0x8E,
		CreatureSpeed = 0x8F,
		//CreatureSkull = 0x90, (deprecated)
		ExaltationForgeExit = 0x90,
		CreatureParty = 0x91,
		CreatureUnpass = 0x92,
		CreatureMarks = 0x93,
		//CreaturePvpHelpers = 0x94,
		DepotSearchResults = 0x94,
		CreatureType = 0x95,
		EditText = 0x96,
		EditList = 0x97,
		ShowGameNews = 0x98,
		DepotSearchDetailList = 0x99,
		CloseDepotSearch = 0x9A,
		BlessingsDialog = 0x9B,
		Blessings = 0x9C,
		SwitchPreset = 0x9D,
		PremiumTrigger = 0x9E,
		PlayerDataBasic = 0x9F,
		PlayerDataCurrent = 0xA0,
		PlayerSkills = 0xA1,
		PlayerState = 0xA2,
		ClearTarget = 0xA3,
		SpellDelay = 0xA4,
		SpellGroupDelay = 0xA5,
		MultiUseDelay = 0xA6,
		SetTactics = 0xA7,
		SetStoreButtonDeeplink = 0xA8,
		RestingAreaState = 0xA9,
		Talk = 0xAA,
		Channels = 0xAB,
		OpenChannel = 0xAC,
		PrivateChannel = 0xAD,
		EditGuildMessage = 0xAE,
		ExperienceTracker = 0xAF,
		Highscores = 0xB1,
		OpenOwnChannel = 0xB2,
		CloseChannel = 0xB3,
		Message = 0xB4,
		SnapBack = 0xB5, // walkthrough walkback
		Wait = 0xB6,
		UnjustifiedPoints = 0xB7,
		PvpSituations = 0xB8,
		BestiaryTracker = 0xB9,
		PreyHuntingTaskBaseData = 0xBA,
		PreyHuntingTaskData = 0xBB,
		BossCooldowns = 0xBD,
		TopFloor = 0xBE,
		BottomFloor = 0xBF,
		UpdateLootContainers = 0xC0,
		PlayerDataTournament = 0xC1,
		CyclopediaHouseActionResult = 0xC3,
		TournamentInformation = 0xC4,
		TournamentLeaderboard = 0xC5,
		CyclopediaStaticHouseData = 0xC6,
		CyclopediaCurrentHouseData = 0xC7,
		Outfit = 0xC8,
		ExivaSuppressed = 0xC9,
		UpdateExivaOptions = 0xCA,
		TransactionDetails = 0xCB,
		ImpactTracking = 0xCC,
		MarketStatistics = 0xCD,
		ItemWasted = 0xCE,
		ItemLooted = 0xCF,
		TrackQuestflags = 0xD0,
		KillTracking = 0xD1,
		BuddyData = 0xD2,
		BuddyStatusChange = 0xD3,
		BuddyGroupData = 0xD4,
		MonsterCyclopedia = 0xD5,
		MonsterCyclopediaMonsters = 0xD6,
		MonsterCyclopediaRace = 0xD7,
		MonsterCyclopediaBonusEffects = 0xD8,
		MonsterCyclopediaNewDetails = 0xD9,
		CyclopediaCharacterInfo = 0xDA,
		HirelingNameChange = 0xDB,
		TutorialHint = 0xDC,
		//AutomapFlag = 0xDD,
		CyclopediaMapData = 0xDD,
		DailyRewardCollectionState = 0xDE,
		CreditBalance = 0xDF,
		IngameShopError = 0xE0,
		RequestPurchaseData = 0xE1,
		OpenRewardWall = 0xE2,
		CloseRewardWall = 0xE3,
		DailyRewardBasic = 0xE4,
		DailyRewardHistory = 0xE5,
		PreyFreeListRerollAvailability = 0xE6,
		PreyTimeLeft = 0xE7,
		PreyData = 0xE8,
		PreyPrices = 0xE9,
		OfferDescription = 0xEA,
		ImbuingDialogRefresh = 0xEB,
		CloseImbuingDialog = 0xEC,
		ShowMessageDialog = 0xED,
		RequestResourceBalance = 0xEE,
		WorldTime = 0xEF,
		QuestLog = 0xF0,
		QuestLine = 0xF1,
		UpdatingShopBalance = 0xF2,
		ChannelEvent = 0xF3,
		ObjectInfo = 0xF4,
		PlayerInventory = 0xF5,
		MarketEnter = 0xF6,
		MarketLeave = 0xF7,
		MarketDetail = 0xF8,
		MarketBrowse = 0xF9,
		ShowModalDialog = 0xFA,
		StoreCategories = 0xFB,
		StoreOffers = 0xFC,
		TransactionHistory = 0xFD,
		StoreSuccess = 0xFE
*/

void ProtocolGame::parsePacket(NetworkMessage& msg)
{
	if (!acceptPackets || g_game.getGameState() == GAME_STATE_SHUTDOWN || msg.getLength() == 0) {
		return;
	}

	uint8_t recvbyte = msg.getByte();

	//a dead player can not perform actions
	if (!player || player->isRemoved() || player->getHealth() <= 0) {
		// handle user afking on death screen
		if (OTSYS_TIME() > lastDeathTime) {
			sendSessionEnd(SESSION_END_LOGOUT);
#ifdef DEBUG_DISCONNECT
			console::print(CONSOLEMESSAGE_TYPE_INFO, "[DEBUG] Disconnected (code 19)");
#endif
			disconnect();
			return;
		}

		// "you are dead" window
		switch (recvbyte) {
			case 0x0F:
				// "ok" or "store" button
				addGameTask(([=, thisPtr = getThis(), characterName = std::move(lastName)]() { thisPtr->login(characterName, lastAccountId, lastOperatingSystem); }));
				break;
			case 0x14:
				// "cancel" (logout)
				sendSessionEnd(SESSION_END_LOGOUT);
#ifdef DEBUG_DISCONNECT
				console::print(CONSOLEMESSAGE_TYPE_INFO, "[DEBUG] Disconnected (code 20)");
#endif
				disconnect();
				break;
			case 0x1D:
				// ping check
				sendPingBack();
				break;
			default:
				break;
		}

		if (msg.isOverrun()) {
			disconnect();
		}

		return;
	}

	// cases commented as "(scripted)" are being handled by lua scripts
	switch (recvbyte) {
		// 0x00-0x09 (0-9) - empty
		// 0x0A - client introduction (parsed in onRecvFirstMessage)
		// 0x0B - login / characterlist (?)
		// 0x0C-0x0E (12-14) - empty
		case 0x0F: break; // login
		// 0x10-0x13 (16-19) - empty
		case 0x14: addGameTask([thisPtr = getThis()]() { thisPtr->logout(true, false); }); break;
		// 0x15-0x1B (21-27) - empty
		case 0x1C: break; // ping check
		case 0x1D: addGameTask([playerID = player->getID()]() { g_game.playerReceivePingBack(playerID); }); break;
		case 0x1E: addGameTask([playerID = player->getID()]() { g_game.playerReceivePing(playerID); }); break;
		//case 0x1F: break; // client performance logs (deprecated?)
		// 0x20-0x27 (32-39) - empty
		//case 0x28: break; // stash withdraw
		//case 0x29: break; // stash action
		//case 0x2A: break; // bestiary tracker
		//case 0x2A: break; // party hunt analyzer
		//case 0x2C: break; // team finder (leader)
		//case 0x2D: break; // team finder (member)
		// 0x2E-0x31 (46-49) - empty
		case 0x32: parseExtendedOpcode(msg); break; // otclient extended opcode
		// 0x33-0x5F (51-95) - empty
		case 0x60: parseImbuementPanel(msg); break;
		// 0x61-0x63 (97-99) - empty
		case 0x64: parseAutoWalk(msg); break;
		case 0x65: addGameTask([playerID = player->getID()]() { g_game.playerMove(playerID, DIRECTION_NORTH); }); break;
		case 0x66: addGameTask([playerID = player->getID()]() { g_game.playerMove(playerID, DIRECTION_EAST); }); break;
		case 0x67: addGameTask([playerID = player->getID()]() { g_game.playerMove(playerID, DIRECTION_SOUTH); }); break;
		case 0x68: addGameTask([playerID = player->getID()]() { g_game.playerMove(playerID, DIRECTION_WEST); }); break;
		case 0x69: addGameTask([playerID = player->getID()]() { g_game.playerStopAutoWalk(playerID); }); break;
		case 0x6A: addGameTask([playerID = player->getID()]() { g_game.playerMove(playerID, DIRECTION_NORTHEAST); }); break;
		case 0x6B: addGameTask([playerID = player->getID()]() { g_game.playerMove(playerID, DIRECTION_SOUTHEAST); }); break;
		case 0x6C: addGameTask([playerID = player->getID()]() { g_game.playerMove(playerID, DIRECTION_SOUTHWEST); }); break;
		case 0x6D: addGameTask([playerID = player->getID()]() { g_game.playerMove(playerID, DIRECTION_NORTHWEST); }); break;
		// 0x6E - empty
		case 0x6F: addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, ([playerID = player->getID()]() { g_game.playerTurn(playerID, DIRECTION_NORTH); })); break;
		case 0x70: addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, ([playerID = player->getID()]() { g_game.playerTurn(playerID, DIRECTION_EAST); })); break;
		case 0x71: addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, ([playerID = player->getID()]() { g_game.playerTurn(playerID, DIRECTION_SOUTH); })); break;
		case 0x72: addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, ([playerID = player->getID()]() { g_game.playerTurn(playerID, DIRECTION_WEST); })); break;
		case 0x73: parsePlayerMinimapQuery(msg); break; // ctrl+shift+left click on minimap
		// 0x74-0x75 - empty
		// case 0x76: break; // character trade ui
		case 0x77: parseEquipObject(msg); break;
		case 0x78: parseThrow(msg); break;
		case 0x79: parseLookInShop(msg); break;
		case 0x7A: parsePlayerPurchase(msg); break;
		case 0x7B: parsePlayerSale(msg); break;
		case 0x7C: addGameTask([playerID = player->getID()]() { g_game.playerCloseShop(playerID); }); break;
		case 0x7D: parseRequestTrade(msg); break;
		case 0x7E: parseLookInTrade(msg); break;
		case 0x7F: addGameTask([playerID = player->getID()]() { g_game.playerAcceptTrade(playerID); }); break;
		case 0x80: addGameTask([playerID = player->getID()]() { g_game.playerCloseTrade(playerID); }); break;
		// case 0x81: break; // friend system ui
		case 0x82: parseUseItem(msg); break;
		case 0x83: parseUseItemEx(msg); break;
		case 0x84: parseUseWithCreature(msg); break;
		case 0x85: parseRotateItem(msg); break;
		case 0x86: parseEditPodiumRequest(msg); break;
		case 0x87: parseCloseContainer(msg); break;
		case 0x88: parseUpArrowContainer(msg); break;
		case 0x89: parseTextWindow(msg); break;
		case 0x8A: parseHouseWindow(msg); break;
		case 0x8B: parseWrapItem(msg); break;
		case 0x8C: parseLookAt(msg); break;
		case 0x8D: parseLookInBattleList(msg); break;
		case 0x8E: /* join aggression */ break;
		case 0x8F: parseQuickLoot(msg); break; // loot corpse
		case 0x90: parseSelectLootContainer(msg);  break; // select loot container
		case 0x91: parseQuickLootList(msg); break; // loot list configuration
		//case 0x92: break; // depot search 1
		//case 0x93: break; // depot search 2
		//case 0x94: break; // depot search 3
		//case 0x95: break; // depot search (?)
		case 0x96: parseSay(msg); break;
		case 0x97: addGameTask(([playerID = player->getID()]() { g_game.playerRequestChannels(playerID); })); break;
		case 0x98: parseOpenChannel(msg); break;
		case 0x99: parseCloseChannel(msg); break;
		case 0x9A: parseOpenPrivateChannel(msg); break;
		case 0x9B: addGameTask(([=, playerID = player->getID()]() { g_game.playerEditGuildMotd(playerID); })); break;
		case 0x9C: parseSaveGuildMotd(msg); break;
		// 0x9D - empty
		case 0x9E: addGameTask([playerID = player->getID()]() { g_game.playerCloseNpcChannel(playerID); }); break;
		case 0xA0: parseFightModes(msg); break;
		case 0xA1: parseAttack(msg); break;
		case 0xA2: parseFollow(msg); break;
		case 0xA3: parseInviteToParty(msg); break;
		case 0xA4: parseJoinParty(msg); break;
		case 0xA5: parseRevokePartyInvite(msg); break;
		case 0xA6: parsePassPartyLeadership(msg); break;
		case 0xA7: addGameTask([playerID = player->getID()]() { g_game.playerLeaveParty(playerID); }); break;
		case 0xA8: parseEnableSharedPartyExperience(msg); break;
		// 0xA9 - disband party (?)
		case 0xAA: addGameTask([playerID = player->getID()]() { g_game.playerCreatePrivateChannel(playerID); }); break;
		case 0xAB: parseChannelInvite(msg); break;
		case 0xAC: parseChannelExclude(msg); break;
		//case 0xAD: break; // house auction ui
		//case 0xAE: break; // bosstiary ui
		//case 0xAF: break; // boss slots ui
		// 0xB0 - empty
		//case 0xB1: break; // request highscores
		// 0xB2-0xBD (178-189) - empty
		case 0xBE: addGameTask([playerID = player->getID()]() { g_game.playerCancelAttackAndFollow(playerID); }); break;
		case 0xBF: parseForgeAction(msg); break;
		case 0xC0: parseForgeBrowseHistory(msg); break;
		// 0xC1-0xC2 - empty
		// 0xC3 - tournament ui 1
		// 0xC4 - tournament ui 2
		// 0xC5 - empty
		// 0xC6 - tournament ui 3
		// 0xC7 - tournament ui 4
		// 0xC8 - tournament ui 5
		case 0xC9: /* update tile */ break;
		case 0xCA: parseUpdateContainer(msg); break;
		case 0xCB: parseBrowseField(msg); break;
		case 0xCC: parseSeekInContainer(msg); break;
		case 0xCD: parseInspectItem(msg); break;
		//case 0xCE: break; // allow everyone to inspect me (to do)
		//case 0xCF: break; // blessings UI
		case 0xD0: parseQuestTracker(msg); break;
		// 0xD1 - empty/unknown
		case 0xD2: parseRequestOutfit(msg); break;
		case 0xD3: parseSetOutfit(msg); break;
		case 0xD4: parseToggleMount(msg); break;
		case 0xD5: parseImbuingApply(msg); break; // apply imbu
		case 0xD6: addGameTask(([=, playerID = player->getID(), slotId = msg.getByte()]() { g_game.playerImbuingClear(playerID, slotId); })); break; // clear imbu
		case 0xD7: addGameTask([playerID = player->getID()]() { g_game.playerImbuingExit(playerID); }); break; // close ui
		//case 0xD8: break; // daily reward 1
		//case 0xD9: break; // daily reward 2
		//case 0xDA: break; // daily reward 3
		//case 0xDB: break; // world map (large) action
		case 0xDC: parseAddVip(msg); break;
		case 0xDD: parseRemoveVip(msg); break;
		case 0xDE: parseEditVip(msg); break;
		//case 0xDF: break; // vip group
		//case 0xE0: break; // game news(?)
		case 0xE1: addGameTask([playerID = player->getID()]() { g_game.playerInitBestiary(playerID); }); break;
		case 0xE2: parseBestiaryCategory(msg); break;
		case 0xE3: parseBestiaryCreature(msg); break;
		//case 0xE4: break; // buy charm
		case 0xE5: parseCyclopediaViewPlayerInfo(msg); break; // player stats
		case 0xE6: parseBugReport(msg); break;
		case 0xE7: /* thank you - reads u32 statementId */ break;
		case 0xE8: /* request store balance (?) */ break; /* 10.98: parseDebugAssert(msg); */
		case 0xE9: /* close store */ break;
		// 0xEA - store (?)
		// 0xEB - prey
		case 0xEC: parseNameChange(msg); break;
		case 0xED: /* request resource balance (handled server side) */ break;
		case 0xEE: addGameTask([playerID = player->getID()]() { g_game.playerSay(playerID, 0, TALKTYPE_SAY, "", "hi"); }); break;
		//case 0xEF: break; // request store coins transfer
		case 0xF0: g_dispatcher.addTask(createTask((DISPATCHER_TASK_EXPIRATION, ([playerID = player->getID()]() { g_game.playerShowQuestLog(playerID); })))); break;
		case 0xF1: parseQuestLine(msg); break;
		case 0xF2: parseRuleViolationReport(msg); break;
		case 0xF3: /* get object info (automatic request sent when item is on action bar) */ break;
		case 0xF4: parseMarketLeave(); break;
		case 0xF5: parseMarketBrowse(msg); break;
		case 0xF6: parseMarketCreateOffer(msg); break;
		case 0xF7: parseMarketCancelOffer(msg); break;
		case 0xF8: parseMarketAcceptOffer(msg); break;
		case 0xF9: parseModalWindowAnswer(msg); break;
		case 0xFA: /*open store */ break;
		case 0xFB: parseStoreBrowse(msg); break; // click on store categories
		case 0xFC: parseStoreBuy(msg); break; // click on store "buy" button
		case 0xFD: parseStoreHistoryBrowse(msg, recvbyte); break; // open store history
		case 0xFE: parseStoreHistoryBrowse(msg, recvbyte); break; // request store history page
		//0xFF - empty

		default:
			//std::cout << "[DEBUG]: Player " << player->getName() << " has sent an unknown packet header: 0x" << std::hex << static_cast<uint16_t>(recvbyte) << std::dec << "!" << std::endl;
			
#ifdef LUA_EXTENDED_PROTOCOL
			// redirecting all unknown headers to lua
			addGameTask([=, playerID = player->getID()]() { g_game.parseExtendedProtocol(playerID, recvbyte, new NetworkMessage(msg)); });
#endif
			break;
	}

	if (msg.isOverrun()) {
#ifdef DEV_MODE
		console::print(CONSOLEMESSAGE_TYPE_WARNING, fmt::format("Failed to parse {:#x} (client packet too short), disconnected. Sender: {:s} ({:s})", recvbyte, (player && !player->isRemoved()) ? player->getName() : "(invalid object)", convertIPToString(getIP()).c_str()));
#endif
#ifdef DEBUG_DISCONNECT
		console::print(CONSOLEMESSAGE_TYPE_INFO, "[DEBUG] Disconnected (code 21)");
#endif
		disconnect();
	}
}

void ProtocolGame::GetTileDescription(const Tile* tile, NetworkMessage& msg)
{
	int32_t count;
	Item* ground = tile->getGround();
	if (ground) {
		msg.addItem(ground);
		count = 1;
	} else {
		count = 0;
	}

	const TileItemVector* items = tile->getItemList();
	if (items) {
		for (auto it = items->getBeginTopItem(), end = items->getEndTopItem(); it != end; ++it) {
			msg.addItem(*it);

			if (++count == 10) {
				break;
			}
		}
	}

	const CreatureVector* creatures = tile->getCreatures();
	if (creatures) {
		for (auto it = creatures->rbegin(), end = creatures->rend(); it != end; ++it) {
			const Creature* creature = (*it);
			if (!player->canSeeCreature(creature)) {
				continue;
			}

			bool known;
			uint32_t removedKnown;
			checkCreatureAsKnown(creature->getID(), known, removedKnown);
			AddCreature(msg, creature, known, removedKnown);
			++count;
		}
	}

	if (items && count < 10) {
		for (auto it = items->getBeginDownItem(), end = items->getEndDownItem(); it != end; ++it) {
			msg.addItem(*it);

			if (++count == 10) {
				return;
			}
		}
	}
}

void ProtocolGame::GetMapDescription(int32_t x, int32_t y, int32_t z, int32_t width, int32_t height, NetworkMessage& msg)
{
	int32_t skip = -1;
	int32_t startz, endz, zstep;

	if (z > 7) {
		startz = z - 2;
		endz = std::min<int32_t>(MAP_MAX_LAYERS - 1, z + 2);
		zstep = 1;
	} else {
		startz = 7;
		endz = 0;
		zstep = -1;
	}

	for (int32_t nz = startz; nz != endz + zstep; nz += zstep) {
		GetFloorDescription(msg, x, y, nz, width, height, z - nz, skip);
	}

	if (skip >= 0) {
		msg.addByte(skip);
		msg.addByte(0xFF);
	}
}

void ProtocolGame::GetFloorDescription(NetworkMessage& msg, int32_t x, int32_t y, int32_t z, int32_t width, int32_t height, int32_t offset, int32_t& skip)
{
	for (int32_t nx = 0; nx < width; nx++) {
		for (int32_t ny = 0; ny < height; ny++) {
			Tile* tile = g_game.map.getTile(x + nx + offset, y + ny + offset, z);
			if (tile) {
				if (skip >= 0) {
					msg.addByte(skip);
					msg.addByte(0xFF);
				}

				skip = 0;
				GetTileDescription(tile, msg);
			} else if (skip == 0xFE) {
				msg.addByte(0xFF);
				msg.addByte(0xFF);
				skip = -1;
			} else {
				++skip;
			}
		}
	}
}

void ProtocolGame::checkCreatureAsKnown(uint32_t id, bool& known, uint32_t& removedKnown)
{
	int64_t now = OTSYS_TIME();
	bool elementExists = !(knownCreatureMap.find(id) == knownCreatureMap.end() || now > knownCreatureMap[id]);
	if (elementExists) {
		knownCreatureMap[id] = now + CLIENT_CACHE_DURATION; // extend duration
		known = true;
		return;
	}

	knownCreatureMap[id] = now + CLIENT_CACHE_DURATION;
	known = false;

	if (knownCreatureMap.size() > 1300) {
		// Look for a creature to remove
		for (auto it = knownCreatureMap.begin(), end = knownCreatureMap.end(); it != end; ++it) {
			Creature* creature = g_game.getCreatureByID(it->first);
			if (!canSee(creature)) {
				removedKnown = it->first;
				knownCreatureMap.erase(it);
				return;
			}
		}

		// Bad situation. Let's just remove anyone.
		auto it = knownCreatureMap.begin();
		if (it->first == id) {
			++it;
		}

		removedKnown = it->first;
		knownCreatureMap.erase(it);
	} else {
		removedKnown = 0;
	}
}

bool ProtocolGame::canSee(const Creature* c) const
{
	if (!c || !player || c->isRemoved()) {
		return false;
	}

	if (!player->canSeeCreature(c)) {
		return false;
	}

	return canSee(c->getPosition());
}

bool ProtocolGame::canSee(const Position& pos) const
{
	return canSee(pos.x, pos.y, pos.z);
}

bool ProtocolGame::canSee(int32_t x, int32_t y, int32_t z) const
{
	if (!player) {
		return false;
	}

	const Position& myPos = player->getPosition();
	if (myPos.z <= 7) {
		//we are on ground level or above (7 -> 0)
		//view is from 7 -> 0
		if (z > 7) {
			return false;
		}
	} else { // if (myPos.z >= 8) {
		//we are underground (8 -> 15)
		//view is +/- 2 from the floor we stand on
		if (std::abs(myPos.getZ() - z) > 2) {
			return false;
		}
	}

	//negative offset means that the action taken place is on a lower floor than ourself
	int32_t offsetz = myPos.getZ() - z;
	if ((x >= myPos.getX() - Map::maxClientViewportX + offsetz) && (x <= myPos.getX() + (Map::maxClientViewportX + 1) + offsetz) &&
		(y >= myPos.getY() - Map::maxClientViewportY + offsetz) && (y <= myPos.getY() + (Map::maxClientViewportY + 1) + offsetz)) {
		return true;
	}
	return false;
}

// Parse methods

void ProtocolGame::parseBestiaryCategory(NetworkMessage& msg)
{
	// 0 - request category (string)
	// 1 - request list (u16 size, u16 race ids)
	uint8_t mode = msg.getByte();
	std::string category;
	std::vector<uint16_t> raceList;

	if (mode == 0) {
		category = msg.getString();
	} else {
		// mode == 1
		uint16_t listSize = msg.get<uint16_t>();
		for (int i = 0; i < listSize; ++i) {
			raceList.push_back(msg.get<uint16_t>());
		}
	}

	addGameTask(([playerID = player->getID(), category = std::move(category), races = raceList]() { g_game.playerBrowseBestiary(playerID, category, races); }));
}

void ProtocolGame::parseBestiaryCreature(NetworkMessage& msg)
{
	addGameTask(([playerID = player->getID(), raceId = msg.get<uint16_t>()]() { g_game.playerRequestRaceInfo(playerID, raceId); }));
}

void ProtocolGame::parseChannelInvite(NetworkMessage& msg)
{
	std::string name = msg.getString();
	addGameTask(([playerID = player->getID(), name = std::move(name)]() { g_game.playerChannelInvite(playerID, name); }));
}

void ProtocolGame::parseChannelExclude(NetworkMessage& msg)
{
	std::string name = msg.getString();
	addGameTask(([=, playerID = player->getID(), name = std::move(name)]() { g_game.playerChannelExclude(playerID, name); }));
}

void ProtocolGame::parseOpenChannel(NetworkMessage& msg)
{
	uint16_t channelID = msg.get<uint16_t>();
	addGameTask(([=, playerID = player->getID()]() { g_game.playerOpenChannel(playerID, channelID); }));
}

void ProtocolGame::parseCloseChannel(NetworkMessage& msg)
{
	uint16_t channelID = msg.get<uint16_t>();
	if (channelID == CHANNEL_GUILD_LEADER) {
		channelID = CHANNEL_GUILD;
	}
	addGameTask(([=, playerID = player->getID()]() { g_game.playerCloseChannel(playerID, channelID); }));
}

void ProtocolGame::parseSaveGuildMotd(NetworkMessage& msg)
{
	std::string text = msg.getString();
	if (text.length() > 255) {
		return;
	}

	addGameTask(([=, playerID = player->getID(), text = std::move(text)]() { g_game.playerSaveGuildMotd(playerID, text); }));
}

void ProtocolGame::parseOpenPrivateChannel(NetworkMessage& msg)
{
	std::string receiver = msg.getString();
	addGameTask(([playerID = player->getID(), receiver = std::move(receiver)]() { g_game.playerOpenPrivateChannel(playerID, receiver); }));
}

void ProtocolGame::parseAutoWalk(NetworkMessage& msg)
{
	uint8_t numdirs = msg.getByte();
	if (numdirs == 0 || (msg.getBufferPosition() + numdirs) != (msg.getLength() + 8)) {
		return;
	}

	msg.skipBytes(numdirs);

	std::vector<Direction> path;
	path.reserve(numdirs);

	for (uint8_t i = 0; i < numdirs; ++i) {
		uint8_t rawdir = msg.getPreviousByte();
		switch (rawdir) {
			case 1: path.push_back(DIRECTION_EAST); break;
			case 2: path.push_back(DIRECTION_NORTHEAST); break;
			case 3: path.push_back(DIRECTION_NORTH); break;
			case 4: path.push_back(DIRECTION_NORTHWEST); break;
			case 5: path.push_back(DIRECTION_WEST); break;
			case 6: path.push_back(DIRECTION_SOUTHWEST); break;
			case 7: path.push_back(DIRECTION_SOUTH); break;
			case 8: path.push_back(DIRECTION_SOUTHEAST); break;
			default: break;
		}
	}

	if (path.empty()) {
		return;
	}

	player->setAfk(false);

	addGameTask(([playerID = player->getID(), path = std::move(path)]() { g_game.playerAutoWalk(playerID, path); }));
}

void ProtocolGame::parseRequestOutfit(NetworkMessage& msg)
{
	uint8_t requestType = msg.getByte();
	if (requestType == 2) {
		// edit hireling outfit
		addGameTask(([=, playerID = player->getID(), creatureID = msg.get<uint32_t>()]() { g_game.playerRequestOutfit(playerID, creatureID); }));
		return;
	}

	// set or try outfit
	uint16_t lookType = requestType == 3 ? msg.get<uint16_t>() : 0;
	uint16_t lookMount = requestType == 1 ? msg.get<uint16_t>() : 0;

	addGameTask(([=, playerID = player->getID()]() { g_game.playerRequestOutfit(playerID, 0, lookType, lookMount); }));
}

void ProtocolGame::parseSetOutfit(NetworkMessage& msg)
{
	uint8_t outfitType = msg.getByte();
	Outfit_t newOutfit;
	newOutfit.lookType = msg.get<uint16_t>();
	newOutfit.lookHead = msg.getByte();
	newOutfit.lookBody = msg.getByte();
	newOutfit.lookLegs = msg.getByte();
	newOutfit.lookFeet = msg.getByte();
	newOutfit.lookAddons = msg.getByte();

	// Set outfit window
	if (outfitType == 0) {
		newOutfit.lookMount = msg.get<uint16_t>();
		if (newOutfit.lookMount != 0) {
			newOutfit.lookMountHead = msg.getByte();
			newOutfit.lookMountBody = msg.getByte();
			newOutfit.lookMountLegs = msg.getByte();
			newOutfit.lookMountFeet = msg.getByte();
		} else {
			msg.skipBytes(4);

			// prevent mount color settings from resetting
			const Outfit_t& currentOutfit = player->getCurrentOutfit();
			newOutfit.lookMountHead = currentOutfit.lookMountHead;
			newOutfit.lookMountBody = currentOutfit.lookMountBody;
			newOutfit.lookMountLegs = currentOutfit.lookMountLegs;
			newOutfit.lookMountFeet = currentOutfit.lookMountFeet;
		}

		// apply the changes
		addGameTask(([=, playerID = player->getID(), lookFamiliar = msg.get<uint16_t>()]() { g_game.playerSelectFamiliar(playerID, lookFamiliar); }));
		addGameTask(([=, playerID = player->getID(), outfitRandomized = msg.getByte() == 0x01]() { g_game.playerChangeOutfit(playerID, newOutfit, outfitRandomized); }));

	// Customise hireling
	} else if (outfitType == 1) {
		addGameTask(([=, playerID = player->getID(), targetId = msg.get<uint32_t>(), outfit = newOutfit]() { g_game.playerDressOtherCreature(playerID, targetId, outfit); }));
	// Podium interaction
	} else if (outfitType == 2) {
		Position pos = msg.getPosition();
		uint16_t spriteId = msg.get<uint16_t>();
		uint8_t stackpos = msg.getByte();
		newOutfit.lookMount = msg.get<uint16_t>();
		newOutfit.lookMountHead = msg.getByte();
		newOutfit.lookMountBody = msg.getByte();
		newOutfit.lookMountLegs = msg.getByte();
		newOutfit.lookMountFeet = msg.getByte();
		Direction direction = static_cast<Direction>(msg.getByte());
		bool podiumVisible = msg.getByte() == 1;

		//apply to podium
		g_dispatcher.addTask(createTask((DISPATCHER_TASK_EXPIRATION, ([=, playerID = player->getID()]() {
			g_game.playerEditPodium(playerID, newOutfit, pos, stackpos, spriteId, podiumVisible, direction);
		}))));
	}
}

void ProtocolGame::parseEditPodiumRequest(NetworkMessage& msg)
{
	Position pos = msg.getPosition();
	uint16_t spriteId = msg.get<uint16_t>();
	uint8_t stackpos = msg.getByte();
	g_dispatcher.addTask(createTask((DISPATCHER_TASK_EXPIRATION, [=, playerID = player->getID()]() { g_game.playerRequestEditPodium(playerID, pos, stackpos, spriteId); })));
}

void ProtocolGame::parseToggleMount(NetworkMessage& msg)
{
	bool mount = msg.getByte() != 0;
	g_dispatcher.addTask(createTask(([=, playerID = player->getID()]() { g_game.playerToggleMount(playerID, mount); })));
}

void ProtocolGame::parseUseItem(NetworkMessage& msg)
{
	Position pos = msg.getPosition();
	uint16_t spriteId = msg.get<uint16_t>();
	uint8_t stackpos = msg.getByte();
	uint8_t index = msg.getByte();
	g_dispatcher.addTask(createTask((DISPATCHER_TASK_EXPIRATION, [=, playerID = player->getID()]() { g_game.playerUseItem(playerID, pos, stackpos, index, spriteId); })));
}

void ProtocolGame::parseUseItemEx(NetworkMessage& msg)
{
	Position fromPos = msg.getPosition();
	uint16_t fromSpriteId = msg.get<uint16_t>();
	uint8_t fromStackPos = msg.getByte();
	Position toPos = msg.getPosition();
	uint16_t toSpriteId = msg.get<uint16_t>();
	uint8_t toStackPos = msg.getByte();
	g_dispatcher.addTask(createTask((DISPATCHER_TASK_EXPIRATION, [=, playerID = player->getID()]() {
		g_game.playerUseItemEx(playerID, fromPos, fromStackPos, fromSpriteId, toPos, toStackPos, toSpriteId);
	})));
}

void ProtocolGame::parseUseWithCreature(NetworkMessage& msg)
{
	Position fromPos = msg.getPosition();
	uint16_t spriteId = msg.get<uint16_t>();
	uint8_t fromStackPos = msg.getByte();
	uint32_t creatureId = msg.get<uint32_t>();
	g_dispatcher.addTask(createTask((DISPATCHER_TASK_EXPIRATION, [=, playerID = player->getID()]() {
		g_game.playerUseWithCreature(playerID, fromPos, fromStackPos, creatureId, spriteId);
	})));
}

void ProtocolGame::parseCloseContainer(NetworkMessage& msg)
{
	uint8_t cid = msg.getByte();
	g_dispatcher.addTask(createTask(([=, playerID = player->getID()]() { g_game.playerCloseContainer(playerID, cid); })));
}

void ProtocolGame::parseUpArrowContainer(NetworkMessage& msg)
{
	uint8_t cid = msg.getByte();
	g_dispatcher.addTask(createTask(([=, playerID = player->getID()]() { g_game.playerMoveUpContainer(playerID, cid); })));
}

void ProtocolGame::parseUpdateContainer(NetworkMessage& msg)
{
	uint8_t cid = msg.getByte();
	g_dispatcher.addTask(createTask(([=, playerID = player->getID()]() { g_game.playerUpdateContainer(playerID, cid); })));
}

void ProtocolGame::parseThrow(NetworkMessage& msg)
{
	Position fromPos = msg.getPosition();
	uint16_t spriteId = msg.get<uint16_t>();
	uint8_t fromStackpos = msg.getByte();
	Position toPos = msg.getPosition();
	uint8_t count = msg.getByte();

	if (toPos != fromPos) {
		g_dispatcher.addTask(createTask(([=, playerID = player->getID()]() {
			g_game.playerMoveThing(playerID, fromPos, spriteId, fromStackpos, toPos, count);
		})));
	}
}

void ProtocolGame::parseLookAt(NetworkMessage& msg)
{
	Position pos = msg.getPosition();
	msg.skipBytes(2); // spriteId
	uint8_t stackpos = msg.getByte();
	g_dispatcher.addTask(createTask((DISPATCHER_TASK_EXPIRATION, [=, playerID = player->getID()]() { g_game.playerLookAt(playerID, pos, stackpos); })));
}

void ProtocolGame::parseLookInBattleList(NetworkMessage& msg)
{
	uint32_t creatureID = msg.get<uint32_t>();
	g_dispatcher.addTask(createTask((DISPATCHER_TASK_EXPIRATION, [=, playerID = player->getID()]() { g_game.playerLookInBattleList(playerID, creatureID); })));
}

void ProtocolGame::parseSay(NetworkMessage& msg)
{
	std::string receiver;
	uint16_t channelId;
	
	MessageClasses type = static_cast<MessageClasses>(msg.getByte());
	switch (type) {
		case TALKTYPE_PRIVATE_TO:
		case TALKTYPE_PRIVATE_RED_TO:
			receiver = msg.getString();
			channelId = 0;
			break;

		case TALKTYPE_CHANNEL_Y:
		case TALKTYPE_CHANNEL_R1:
			channelId = msg.get<uint16_t>();
			break;

		default:
			channelId = 0;
			break;
	}
	std::string text = msg.getString();
	if (text.length() > 255) {
		return;
	}

	if (channelId == CHANNEL_GUILD_LEADER) {
		channelId = CHANNEL_GUILD;
	}

	g_dispatcher.addTask(createTask(([=, playerID = player->getID(), receiver = std::move(receiver), text = std::move(text)]() {
		g_game.playerSay(playerID, channelId, type, receiver, text);
	})));
}

void ProtocolGame::parseFightModes(NetworkMessage& msg)
{
	uint8_t rawFightMode = msg.getByte(); // 1 - offensive, 2 - balanced, 3 - defensive
	uint8_t rawChaseMode = msg.getByte(); // 0 - stand while fighting, 1 - chase opponent
	uint8_t rawSecureMode = msg.getByte(); // 0 - can't attack unmarked, 1 - can attack unmarked
	// uint8_t rawPvpMode = msg.getByte(); // pvp mode introduced in 10.0

	fightMode_t fightMode;
	if (rawFightMode == 1) {
		fightMode = FIGHTMODE_ATTACK;
	} else if (rawFightMode == 2) {
		fightMode = FIGHTMODE_BALANCED;
	} else {
		fightMode = FIGHTMODE_DEFENSE;
	}

	g_dispatcher.addTask(createTask(([=, playerID = player->getID()]() { g_game.playerSetFightModes(playerID, fightMode, rawChaseMode != 0, rawSecureMode != 0); })));
}

void ProtocolGame::parseAttack(NetworkMessage& msg)
{
	uint32_t creatureID = msg.get<uint32_t>();
	// msg.get<uint32_t>(); creatureID (same as above)
	g_dispatcher.addTask(createTask(([=, playerID = player->getID()]() { g_game.playerSetAttackedCreature(playerID, creatureID); })));
}

void ProtocolGame::parseFollow(NetworkMessage& msg)
{
	uint32_t creatureID = msg.get<uint32_t>();
	// msg.get<uint32_t>(); creatureID (same as above)
	g_dispatcher.addTask(createTask(([=, playerID = player->getID()]() { g_game.playerFollowCreature(playerID, creatureID); })));
}

void ProtocolGame::parseEquipObject(NetworkMessage& msg)
{
	// action bar/hotkey equip
	uint16_t spriteId = msg.get<uint16_t>();
	const ItemType& it = Item::items.getItemIdByClientId(spriteId);
	if (it.id == 0) {
		return;
	}

	uint8_t tier = 0;
	if (it.classification > 0) {
		tier = msg.getByte();
	}

	g_dispatcher.addTask(createTask((DISPATCHER_TASK_EXPIRATION, [=, playerID = player->getID(), isTiered = it.classification > 0]() { g_game.playerEquipItem(playerID, spriteId, isTiered, tier); })));
}

void ProtocolGame::parseTextWindow(NetworkMessage& msg)
{
	uint32_t windowTextID = msg.get<uint32_t>();
	std::string newText = msg.getString();
	addGameTask(([playerID = player->getID(), windowTextID, newText = std::move(newText)]() { g_game.playerWriteItem(playerID, windowTextID, newText); }));
}

void ProtocolGame::parseHouseWindow(NetworkMessage& msg)
{
	uint8_t doorId = msg.getByte();
	uint32_t id = msg.get<uint32_t>();
	const std::string text = msg.getString();
	addGameTask(([=, playerID = player->getID()]() { g_game.playerUpdateHouseWindow(playerID, doorId, id, text); }));
}

void ProtocolGame::parseWrapItem(NetworkMessage& msg)
{
	Position pos = msg.getPosition();
	uint16_t spriteId = msg.get<uint16_t>();
	uint8_t stackpos = msg.getByte();
	g_dispatcher.addTask(createTask((DISPATCHER_TASK_EXPIRATION, ([=, playerID = player->getID()]() { g_game.playerWrapItem(playerID, pos, stackpos, spriteId); }))));
}

void ProtocolGame::parseQuickLoot(NetworkMessage& msg)
{
	Position pos = msg.getPosition();
	uint8_t stackpos = msg.getByte();
	uint16_t spriteId = msg.get<uint16_t>();

	g_dispatcher.addTask(createTask((DISPATCHER_TASK_EXPIRATION, ([=, playerID = player->getID()]() { g_game.playerQuickLoot(playerID, pos, stackpos, spriteId); }))));
}

void ProtocolGame::parseSelectLootContainer(NetworkMessage& msg)
{
	uint8_t mode = msg.getByte();
	uint8_t lootType = msg.getByte();

	// 0x00 - select loot container
	// 0x01 - unselect loot container
	// 0x02 - unused
	// 0x03 - toggle fallback to main container
	if (mode == 0x00) {		
		Position pos = msg.getPosition();
		msg.get<uint16_t>(); //spriteId
		msg.getByte(); //containerPos
		addGameTask(([=, playerID = player->getID()]() { g_game.playerSetLootContainer(playerID, pos, lootType); }));
		return;
	}

	addGameTask(([=, playerID = player->getID()]() { g_game.playerManageLootContainer(playerID, mode, lootType); }));
}

void ProtocolGame::parseQuickLootList(NetworkMessage& msg)
{
	uint8_t mode = msg.getByte(); // collect/skip listed
	std::vector<uint16_t> lootItems;

	uint16_t listSize = std::min<uint16_t>(msg.get<uint16_t>(), static_cast<uint16_t>(g_config.getNumber(ConfigManager::MAX_QUICK_LOOT_LIST_SIZE)));
	for (uint16_t i = 0; i < listSize; ++i) {
		lootItems.push_back(msg.get<uint16_t>());
	}

	g_dispatcher.addTask(createTask((DISPATCHER_TASK_EXPIRATION, ([=, playerID = player->getID()]() { g_game.playerConfigureQuickLoot(playerID, lootItems, mode == 0x01); }))));
}

void ProtocolGame::parseLookInShop(NetworkMessage& msg)
{
	uint16_t id = msg.get<uint16_t>();
	uint8_t count = msg.getByte();

	g_dispatcher.addTask(createTask((DISPATCHER_TASK_EXPIRATION, ([=, playerID = player->getID()]() { g_game.playerLookInShop(playerID, id, count); }))));
}

void ProtocolGame::parsePlayerPurchase(NetworkMessage& msg)
{
	uint16_t id = msg.get<uint16_t>();
	uint8_t subType = msg.getByte();
	uint16_t amount = msg.get<uint16_t>();
	bool ignoreCap = msg.getByte() != 0;
	bool inBackpacks = msg.getByte() != 0;
	g_dispatcher.addTask(createTask((DISPATCHER_TASK_EXPIRATION, ([=, playerID = player->getID()]() {
		g_game.playerPurchaseItem(playerID, id, subType, amount, ignoreCap, inBackpacks);
	}))));
}

void ProtocolGame::parsePlayerSale(NetworkMessage& msg)
{
	uint16_t id = msg.get<uint16_t>();
	uint8_t subType = msg.getByte();
	uint16_t amount = msg.get<uint16_t>();
	bool ignoreEquipped = msg.getByte() != 0;
	g_dispatcher.addTask(createTask((DISPATCHER_TASK_EXPIRATION, ([=, playerID = player->getID()]() { g_game.playerSellItem(playerID, id, subType, amount, ignoreEquipped); }))));
}

void ProtocolGame::parseRequestTrade(NetworkMessage& msg)
{
	Position pos = msg.getPosition();
	uint16_t spriteId = msg.get<uint16_t>();
	uint8_t stackpos = msg.getByte();
	uint32_t playerId = msg.get<uint32_t>();
	addGameTask(([=, playerID = player->getID()]() { g_game.playerRequestTrade(playerID, pos, stackpos, playerId, spriteId); }));
}

void ProtocolGame::parseLookInTrade(NetworkMessage& msg)
{
	bool counterOffer = (msg.getByte() == 0x01);
	uint8_t index = msg.getByte();
	g_dispatcher.addTask(createTask((DISPATCHER_TASK_EXPIRATION, ([=, playerID = player->getID()]() { g_game.playerLookInTrade(playerID, counterOffer, index); }))));
}

void ProtocolGame::parseAddVip(NetworkMessage& msg)
{
	std::string name = msg.getString();
	addGameTask(([playerID = player->getID(), name = std::move(name)]() { g_game.playerRequestAddVip(playerID, name); }));
}

void ProtocolGame::parseRemoveVip(NetworkMessage& msg)
{
	uint32_t guid = msg.get<uint32_t>();
	addGameTask(([=, playerID = player->getID()]() { g_game.playerRequestRemoveVip(playerID, guid); }));
}

void ProtocolGame::parseEditVip(NetworkMessage& msg)
{
	uint32_t guid = msg.get<uint32_t>();
	std::string description = msg.getString();
	uint32_t icon = std::min<uint32_t>(10, msg.get<uint32_t>()); // 10 is max icon in 9.63
	bool notify = msg.getByte() != 0;
	addGameTask(([=, playerID = player->getID(), description = std::move(description)]() { g_game.playerRequestEditVip(playerID, guid, description, icon, notify); }));
}

void ProtocolGame::parseRotateItem(NetworkMessage& msg)
{
	Position pos = msg.getPosition();
	uint16_t spriteId = msg.get<uint16_t>();
	uint8_t stackpos = msg.getByte();
	g_dispatcher.addTask(createTask((DISPATCHER_TASK_EXPIRATION, ([=, playerID = player->getID()]() { g_game.playerRotateItem(playerID, pos, stackpos, spriteId); }))));
}

void ProtocolGame::parseRuleViolationReport(NetworkMessage& msg)
{
	uint8_t reportType = msg.getByte();
	uint8_t reportReason = msg.getByte();
	std::string targetName = msg.getString();
	std::string comment = msg.getString();
	std::string translation;
	if (reportType == REPORT_TYPE_NAME) {
		translation = msg.getString();
	} else if (reportType == REPORT_TYPE_STATEMENT) {
		translation = msg.getString();
		msg.get<uint32_t>(); // statement id, used to get whatever player have said, we don't log that.
	}

	addGameTask(([=, playerID = player->getID(), targetName = std::move(targetName), comment = std::move(comment), translation = std::move(translation)]() {
		g_game.playerReportRuleViolation(playerID, targetName, reportType, reportReason, comment, translation);
	}));
}

void ProtocolGame::parseBugReport(NetworkMessage& msg)
{
	uint8_t category = msg.getByte();
	std::string message = msg.getString();

	Position position;
	if (category == BUG_CATEGORY_MAP) {
		position = msg.getPosition();
	}

	addGameTask(([=, playerID = player->getID(), message = std::move(message)]() { g_game.playerReportBug(playerID, message, position, category); }));
}

void ProtocolGame::parseDebugAssert(NetworkMessage& msg)
{
	// deprecated / protocol 1098

	if (debugAssertSent) {
		return;
	}

	debugAssertSent = true;

	std::string assertLine = msg.getString();
	std::string date = msg.getString();
	std::string description = msg.getString();
	std::string comment = msg.getString();
	addGameTask(([playerID = player->getID(), assertLine = std::move(assertLine), date = std::move(date), description = std::move(description), comment = std::move(comment)]() {
		g_game.playerDebugAssert(playerID, assertLine, date, description, comment);
	}));
}

void ProtocolGame::parseNameChange(NetworkMessage& msg)
{
	std::string desiredName = msg.getString();
	uint32_t target = msg.get<uint32_t>();
	// msg.get<uint32_t>(); // unknown

	addGameTask(([playerID = player->getID(), targetID = target, newName = std::move(desiredName)]() {
		g_game.playerEditName(playerID, targetID, newName);
	}));
}

void ProtocolGame::parseStoreBrowse(NetworkMessage& msg)
{
	GameStoreRequest request;
	request.actionType = msg.getByte();

	switch (request.actionType) {
		case STORE_REQUEST_WINDOWID:
			// ?
			request.primaryValue = msg.getByte();
			break;
		case STORE_REQUEST_CATEGORY:
			// category
			request.primaryText = msg.getString();
			request.secondaryText = msg.getString();
			break;
		case STORE_REQUEST_WINDOWID_2:
			// ?
			//request.primaryValue = msg.getByte();
			break;
		case STORE_REQUEST_OFFERID:
			// offer id
			request.offerId = msg.get<uint32_t>();
			break;
		case STORE_REQUEST_SEARCH:
			// search text
			request.primaryText = msg.getString();
			break;
		default:
			break;
	}

	if (request.actionType != STORE_REQUEST_HOME) {
		request.sortOrder = msg.getByte();
		request.secondaryValue = msg.getByte();
	}

	addGameTask(([=, playerID = player->getID()]() { g_game.playerBrowseStore(playerID, request); }));
}

void ProtocolGame::parseStoreBuy(NetworkMessage& msg)
{
	uint16_t offerId = msg.get<uint16_t>();
	msg.get<uint16_t>(); // 2x u8, unknown purpose, always 0
	uint8_t action = msg.get<uint8_t>(); // 0 - buy, 1-6 - confirm buy if service
	uint8_t type = 0;

	std::string name;
	std::string location;

	if (action > 0 && action < 6) {
		// 1 - new player name
		// 2 - new world name
		// 3 - new hireling name
		// 4 - new main character name
		// 5 - tournament server location name
		name = msg.getString();

		if (action == 3) {
			// hireling sex
			// 1 - male
			// 2 - female
			type = msg.get<uint8_t>();
		} else if (action == 5) {
			// vocationId
			type = msg.get<uint8_t>();

			// starting town name
			location = msg.getString();
		}
	}

	addGameTask(([=, playerID = player->getID()]() { g_game.playerBuyInStore(playerID, offerId, action, name, type, location); }));
}

void ProtocolGame::parseStoreHistoryBrowse(NetworkMessage& msg, uint8_t recvbyte)
{
	// packet structure:
	// 0xFD: u8 entries per page
	// 0xFE: u32 pageId, u8 entriesPerPage
	uint32_t pageId = recvbyte == 0xFE ? msg.get<uint32_t>() : 0;
	addGameTask(([=, playerID = player->getID()]() { g_game.playerBrowseStoreHistory(playerID, pageId, recvbyte == 0xFD); }));
}

void ProtocolGame::parseInviteToParty(NetworkMessage& msg)
{
	uint32_t targetID = msg.get<uint32_t>();
	addGameTask(([=, playerID = player->getID()]() { g_game.playerInviteToParty(playerID, targetID); }));
}

void ProtocolGame::parseJoinParty(NetworkMessage& msg)
{
	uint32_t targetID = msg.get<uint32_t>();
	addGameTask(([=, playerID = player->getID()]() { g_game.playerJoinParty(playerID, targetID); }));
}

void ProtocolGame::parseRevokePartyInvite(NetworkMessage& msg)
{
	uint32_t targetID = msg.get<uint32_t>();
	addGameTask(([=, playerID = player->getID()]() { g_game.playerRevokePartyInvitation(playerID, targetID); }));
}

void ProtocolGame::parsePassPartyLeadership(NetworkMessage& msg)
{
	uint32_t targetID = msg.get<uint32_t>();
	addGameTask(([=, playerID = player->getID()]() { g_game.playerPassPartyLeadership(playerID, targetID); }));
}

void ProtocolGame::parseEnableSharedPartyExperience(NetworkMessage& msg)
{
	bool sharedExpActive = msg.getByte() == 1;
	addGameTask(([=, playerID = player->getID()]() { g_game.playerEnableSharedPartyExperience(playerID, sharedExpActive); }));
}

void ProtocolGame::parseQuestLine(NetworkMessage& msg)
{
	uint16_t questID = msg.get<uint16_t>();
	addGameTask(([=, playerID = player->getID()]() { g_game.playerShowQuestLine(playerID, questID); }));
}

void ProtocolGame::parseQuestTracker(NetworkMessage& msg)
{
	uint8_t missions = msg.getByte();
	std::vector<uint16_t> missionIDs;
	missionIDs.reserve(missions);
	for (uint8_t i = 0; i < missions; i++) {
		missionIDs.push_back(msg.get<uint16_t>());
	}

	addGameTask(([playerID = player->getID(), missionIDs = std::move(missionIDs)]() { g_game.playerResetQuestTracker(playerID, missionIDs); }));
}

void ProtocolGame::parseMarketLeave()
{
	addGameTask(([playerID = player->getID()]() { g_game.playerLeaveMarket(playerID); }));
}

void ProtocolGame::parseMarketBrowse(NetworkMessage& msg)
{
	uint8_t browseId = msg.getByte();
	if (browseId == MARKETREQUEST_OWN_OFFERS) {
		addGameTask([playerID = player->getID()]() { g_game.playerBrowseMarketOwnOffers(playerID); });
	} else if (browseId == MARKETREQUEST_OWN_HISTORY) {
		addGameTask([playerID = player->getID()]() { g_game.playerBrowseMarketOwnHistory(playerID); });
	} else {
		uint16_t spriteId = msg.get<uint16_t>();
		uint8_t tier = 0;

		const ItemType& it = Item::items.getItemIdByClientId(spriteId);
		if (it.id == 0 || it.wareId == 0) {
			return;
		} else if (it.classification > 0) {
			tier = msg.getByte(); // item tier
		}
		
		addGameTask(([=, playerID = player->getID()]() { g_game.playerBrowseMarket(playerID, spriteId, tier); }));
	}
}

void ProtocolGame::parseMarketCreateOffer(NetworkMessage& msg)
{
	uint8_t type = msg.getByte();
	uint16_t spriteId = msg.get<uint16_t>();
	uint8_t tier = 0;

	const ItemType& it = Item::items.getItemIdByClientId(spriteId);
	if (it.id == 0 || it.wareId == 0) {
		return;
	} else if (it.classification > 0) {
		tier = msg.getByte(); // item tier
	}

	uint16_t amount = msg.get<uint16_t>();
	uint64_t price = msg.get<uint64_t>();
	bool anonymous = (msg.getByte() != 0);
	addGameTask(([=, playerID = player->getID()]() { g_game.playerCreateMarketOffer(playerID, type, spriteId, amount, tier, price, anonymous); }));
}

void ProtocolGame::parseMarketCancelOffer(NetworkMessage& msg)
{
	uint32_t timestamp = msg.get<uint32_t>();
	uint16_t counter = msg.get<uint16_t>();
	addGameTask(([=, playerID = player->getID()]() { g_game.playerCancelMarketOffer(playerID, timestamp, counter); }));
}

void ProtocolGame::parseMarketAcceptOffer(NetworkMessage& msg)
{
	uint32_t timestamp = msg.get<uint32_t>();
	uint16_t counter = msg.get<uint16_t>();
	uint16_t amount = msg.get<uint16_t>();
	addGameTask(([=, playerID = player->getID()]() { g_game.playerAcceptMarketOffer(playerID, timestamp, counter, amount); }));
}

void ProtocolGame::parseForgeAction(NetworkMessage& msg)
{
	ForgeConversionTypes_t forgeAction = static_cast<ForgeConversionTypes_t>(msg.getByte());
	switch (forgeAction) {
		case FORGE_ACTION_FUSION:
			addGameTask(([=,
					playerID = player->getID(),
					fromSpriteId = msg.get<uint16_t>(),
					fromTier = msg.getByte(),
					toSpriteId = msg.get<uint16_t>(),
					successCore = msg.getByte() == 1,
					tierLossCore = msg.getByte() == 1
			]() { g_game.playerFuseItems(playerID, fromSpriteId, fromTier, toSpriteId, successCore, tierLossCore); }));
			break;
		case FORGE_ACTION_TRANSFER:
			addGameTask(([=,
				playerID = player->getID(),
				fromSpriteId = msg.get<uint16_t>(),
				fromTier = msg.getByte(),
				toSpriteId = msg.get<uint16_t>()
			]() { g_game.playerTransferTier(playerID, fromSpriteId, fromTier, toSpriteId); }));
			break;
		default:
			addGameTask(([=, playerID = player->getID()]() { g_game.playerConvertForgeResources(playerID, forgeAction); }));
			break;
	}
}

void ProtocolGame::parseForgeBrowseHistory(NetworkMessage& msg)
{
	addGameTask(([=, playerID = player->getID(), page = msg.getByte()]() { g_game.playerBrowseForgeHistory(playerID, page); }));
}

void ProtocolGame::parseModalWindowAnswer(NetworkMessage& msg)
{
	uint32_t id = msg.get<uint32_t>();
	uint8_t button = msg.getByte();
	uint8_t choice = msg.getByte();
	addGameTask(([=, playerID = player->getID()]() { g_game.playerAnswerModalWindow(playerID, id, button, choice); }));
}

void ProtocolGame::parseCyclopediaViewPlayerInfo(NetworkMessage& msg)
{
	uint32_t targetPlayerId = msg.get<uint32_t>();
	PlayerTabTypes_t infoType = static_cast<PlayerTabTypes_t>(msg.getByte());
	uint16_t entriesPerPage = 5;
	uint16_t currentPage = 0;

	// parse client preferences (page number / entries per page)
	if (infoType == PLAYERTAB_DEATHS || infoType == PLAYERTAB_PVPKILLS) {
		entriesPerPage = msg.get<uint16_t>();
		currentPage = msg.get<uint16_t>();
	}

	addGameTask(([=, playerID = player->getID()]() { g_game.playerViewPlayerTab(playerID, targetPlayerId, infoType, currentPage, entriesPerPage); }));
}

void ProtocolGame::parseBrowseField(NetworkMessage& msg)
{
	Position pos = msg.getPosition();
	addGameTask(([=, playerID = player->getID()]() { g_game.playerBrowseField(playerID, pos); }));
}

void ProtocolGame::parseSeekInContainer(NetworkMessage& msg)
{
	uint8_t containerId = msg.getByte();
	uint16_t index = msg.get<uint16_t>();
	addGameTask(([=, playerID = player->getID()]() { g_game.playerSeekInContainer(playerID, containerId, index); }));
}

void ProtocolGame::parseInspectItem(NetworkMessage& msg)
{
	InspectionTypes_t inspectionType = static_cast<InspectionTypes_t>(msg.getByte());

	switch (inspectionType) {
		case INSPECTION_ITEM_NORMAL:
			g_dispatcher.addTask(createTask((DISPATCHER_TASK_EXPIRATION, ([playerID = player->getID(), position = msg.getPosition()]() { g_game.playerInspectItem(playerID, position); }))));
			break;
		case INSPECTION_ITEM_PLAYERTRADE:
			g_dispatcher.addTask(createTask((DISPATCHER_TASK_EXPIRATION, ([playerID = player->getID(), isInspectingPartnerOffer = msg.getByte() == 1, index = msg.getByte()]() { g_game.playerInspectTradeItem(playerID, isInspectingPartnerOffer, index); }))));
			break;
		case INSPECTION_ITEM_NPCTRADE:
		case INSPECTION_ITEM_CYCLOPEDIA:
			g_dispatcher.addTask(createTask((DISPATCHER_TASK_EXPIRATION, ([playerID = player->getID(), spriteID = msg.get<uint16_t>(), isNpcTrade = inspectionType == INSPECTION_ITEM_NPCTRADE]() { g_game.playerInspectClientItem(playerID, spriteID, isNpcTrade); }))));
			break;
		default:
			break;
	}
}

void ProtocolGame::parsePlayerMinimapQuery(NetworkMessage& msg)
{
	addGameTask(([=, playerID = player->getID(), pos = msg.getPosition()]() { g_game.playerMinimapQuery(playerID, pos); }));
}

void ProtocolGame::parseImbuingApply(NetworkMessage& msg)
{
	uint8_t slotId = msg.getByte();
	uint8_t imbuId = msg.getByte();
	msg.skipBytes(3); // imbuId is u32, but we use one byte only
	bool luckProtection = msg.getByte() != 0;
	addGameTask(([=, playerID = player->getID()]() { g_game.playerImbuingApply(playerID, slotId, imbuId, luckProtection); }));
}

void ProtocolGame::parseImbuementPanel(NetworkMessage& msg)
{
	bool enabled = msg.getByte() != 0x00;
	addGameTask(([=, playerID = player->getID()]() { g_game.playerToggleImbuPanel(playerID, enabled); }));
}

// Send methods
void ProtocolGame::sendOpenPrivateChannel(const std::string& receiver)
{
	NetworkMessage msg;
	msg.addByte(0xAD);
	msg.addString(receiver);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendChannelEvent(uint16_t channelId, const std::string& playerName, ChannelEvent_t channelEvent)
{
	NetworkMessage msg;
	msg.addByte(0xF3);
	msg.add<uint16_t>(channelId);
	msg.addString(playerName);
	msg.addByte(channelEvent);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureOutfit(const Creature* creature, const Outfit_t& outfit)
{
	if (!canSee(creature)) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x8E);
	msg.add<uint32_t>(creature->getID());
	AddOutfit(msg, outfit);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureLight(const Creature* creature)
{
	if (!canSee(creature)) {
		return;
	}

	NetworkMessage msg;
	AddCreatureLight(msg, creature);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendWorldLight(LightInfo lightInfo)
{
	NetworkMessage msg;
	AddWorldLight(msg, lightInfo);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendWorldTime()
{
	int16_t time = g_game.getWorldTime();
	NetworkMessage msg;
	msg.addByte(0xEF);
	msg.addByte(time / 60); // hour
	msg.addByte(time % 60); // min
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureWalkthrough(const Creature* creature, bool walkthrough)
{
	if (!canSee(creature)) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x92);
	msg.add<uint32_t>(creature->getID());
	msg.addByte(walkthrough ? 0x00 : 0x01);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureShield(const Creature* creature)
{
	if (!canSee(creature)) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x91);
	msg.add<uint32_t>(creature->getID());
	msg.addByte(player->getPartyShield(creature));
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureSkull(const Creature* creature)
{
	if (g_game.getWorldType() != WORLD_TYPE_PVP) {
		return;
	}

	if (!canSee(creature)) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x90);
	msg.add<uint32_t>(creature->getID());
	msg.addByte(player->getSkullClient(creature));
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureSquare(const Creature* creature, SquareColor_t color)
{
	if (!canSee(creature)) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x93);
	msg.add<uint32_t>(creature->getID());
	msg.addByte(0x01);
	msg.addByte(color);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendTutorial(uint8_t tutorialId)
{
	NetworkMessage msg;
	msg.addByte(0xDC);
	msg.addByte(tutorialId);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendAddMarker(const Position& pos, uint8_t markType, const std::string& desc)
{
	NetworkMessage msg;
	msg.addByte(0xDD);
	msg.addByte(0x00); // unknown
	msg.addPosition(pos);
	msg.addByte(markType);
	msg.addString(desc);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendReLoginWindow(uint8_t unfairFightReduction)
{
	NetworkMessage msg;
	msg.addByte(0x28);
	msg.addByte(0x00);
	msg.addByte(unfairFightReduction);
	msg.addByte(0x00); // can use death redemption (bool)
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendStats()
{
	NetworkMessage msg;
	AddPlayerStats(msg);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendExperienceTracker(int64_t rawExp, int64_t finalExp)
{
	NetworkMessage msg;
	msg.addByte(0xAF);
	msg.add<int64_t>(rawExp);
	msg.add<int64_t>(finalExp);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendClientFeatures()
{
	NetworkMessage msg;
	msg.addByte(0x17);

	msg.add<uint32_t>(player->getID());
	msg.add<uint16_t>(50); // beat duration

	// variables for client-sided step duration
	// see Creature::getStepDuration() for server-sided equivalent
	/*
	msg.addDouble(Creature::speedA, 3);
	msg.addDouble(Creature::speedB, 3);
	msg.addDouble(Creature::speedC, 3);
	*/
	msg.addByte(0x03);
	msg.add<uint32_t>(0x800D150F);
	msg.addByte(0x03);
	msg.add<uint32_t>(0x8003FCA9);
	msg.addByte(0x03);
	msg.add<uint32_t>(0x7FB6D57E);

	// can report bugs?
	msg.addByte(player->getAccountType() >= ACCOUNT_TYPE_TUTOR ? 0x01 : 0x00);

	msg.addByte(0x00); // can change pvp framing option
	msg.addByte(0x00); // expert mode button enabled

	msg.addString(g_config.getString(ConfigManager::STORE_IMAGES_URL)); // store images url
	msg.add<uint16_t>(25); // premium coin package size

	msg.addByte(0x00); // exiva button enabled (bool)
	msg.addByte(0x00); // Tournament button (bool)

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendBasicData()
{
	NetworkMessage msg;
	msg.addByte(0x9F);
	if (player->isPremium()) {
		msg.addByte(1);
		msg.add<uint32_t>(g_config.getBoolean(ConfigManager::FREE_PREMIUM) ? 0 : player->premiumEndsAt);
	} else {
		msg.addByte(0);
		msg.add<uint32_t>(0);
	}
	msg.addByte(player->getVocation()->getClientId());
	msg.addByte(0x01); // has reached mainland (bool)

	// unlock spells on action bar
	msg.add<uint16_t>(0xFF);
	for (uint8_t spellId = 0x00; spellId < 0xFF; spellId++) {
		// u16 since 13.10 (skill wheel)
		msg.add<uint16_t>(spellId);
	}

	msg.addByte(0x00); // is magic shield active (bool)
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendTextMessage(const TextMessage& message)
{
	NetworkMessage msg;
	msg.addByte(0xB4);
	msg.addByte(message.type);
	switch (message.type) {
		case MESSAGE_DAMAGE_DEALT:
		case MESSAGE_DAMAGE_RECEIVED:
		case MESSAGE_DAMAGE_OTHERS: {
			msg.addPosition(message.position);
			msg.add<uint32_t>(message.secondary.value);
			msg.addByte(message.secondary.color);
			msg.add<uint32_t>(message.primary.value);
			msg.addByte(message.primary.color);
			break;
		}
		case MESSAGE_HEALED:
		case MESSAGE_HEALED_OTHERS:
		case MESSAGE_EXPERIENCE:
		case MESSAGE_EXPERIENCE_OTHERS:
		case MESSAGE_MANA:
		case MESSAGE_MANA_OTHERS:
		{
			msg.addPosition(message.position);
			msg.add<uint32_t>(message.primary.value);
			msg.addByte(message.primary.color);
			break;
		}
		case MESSAGE_CHANNEL_MANAGEMENT:
		case MESSAGE_GUILD:
		case MESSAGE_PARTY_MANAGEMENT:
		case MESSAGE_PARTY:
			msg.add<uint16_t>(message.channelId);
			break;
		default: {
			break;
		}
	}
	msg.addString(message.text);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendClosePrivate(uint16_t channelId)
{
	NetworkMessage msg;
	msg.addByte(0xB3);
	msg.add<uint16_t>(channelId);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendChannelsDialog()
{
	NetworkMessage msg;
	msg.addByte(0xAB);

	const ChannelList& list = g_chat->getChannelList(*player);
	msg.addByte(list.size());
	for (ChatChannel* channel : list) {
		msg.add<uint16_t>(channel->getId());
		msg.addString(channel->getName());
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendChannel(uint16_t channelId, const std::string& channelName, const UsersMap* channelUsers, const InvitedMap* invitedUsers, bool ownChannel)
{
	NetworkMessage msg;
	if (ownChannel) {
		msg.addByte(0xB2);
	} else {
		msg.addByte(0xAC);
	}

	msg.add<uint16_t>(channelId);
	msg.addString(channelName);

	if (channelUsers) {
		msg.add<uint16_t>(channelUsers->size());
		for (const auto& it : *channelUsers) {
			msg.addString(it.second->getName());
		}
	} else {
		msg.add<uint16_t>(0x00);
	}

	if (invitedUsers) {
		msg.add<uint16_t>(invitedUsers->size());
		for (const auto& it : *invitedUsers) {
			msg.addString(it.second->getName());
		}
	} else {
		msg.add<uint16_t>(0x00);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendChannelMessage(const std::string& author, const std::string& text, MessageClasses type, uint16_t channel)
{
	NetworkMessage msg;
	msg.addByte(0xAA);
	msg.add<uint32_t>(0x00);
	msg.addString(author);
	msg.add<uint16_t>(0x00);
	msg.addByte(type);
	msg.add<uint16_t>(channel);
	msg.addString(text);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendIcons(uint32_t icons)
{
	NetworkMessage msg;
	msg.addByte(0xA2);
	msg.add<uint32_t>(icons);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendContainer(uint8_t cid, const Container* container, bool hasParent, uint16_t firstIndex)
{
	NetworkMessage msg;
	msg.addByte(0x6E);
	msg.addByte(cid);

	if (container->getID() == ITEM_BROWSEFIELD) {
		msg.addItem(ITEM_BAG, 1);
		msg.addString("Browse Field");
	} else {
		msg.addItem(container);
		msg.addString(container->getName());
	}

	msg.addByte(container->capacity());
	msg.addByte(hasParent ? 0x01 : 0x00);
	msg.addByte(0x00); // show search icon (boolean)
	msg.addByte((container->isUnlocked() && Item::items.getItemType(container->getID()).corpseType == RACE_NONE) ? 0x01 : 0x00); // Drag and drop
	msg.addByte(container->hasPagination() ? 0x01 : 0x00); // Pagination

	uint32_t containerSize = container->size();
	msg.add<uint16_t>(containerSize);
	msg.add<uint16_t>(firstIndex);
	if (firstIndex < containerSize) {
		uint8_t itemsToSend = std::min<uint32_t>(std::min<uint32_t>(container->capacity(), containerSize - firstIndex), std::numeric_limits<uint8_t>::max());
		msg.addByte(itemsToSend);
		for (auto it = container->getItemList().begin() + firstIndex, end = it + itemsToSend; it != end; ++it) {
			msg.addItem(*it);
		}
	} else {
		msg.addByte(0x00);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendEmptyContainer(uint8_t cid)
{
	NetworkMessage msg;
	msg.addByte(0x6E);

	msg.addByte(cid);

	msg.addItem(ITEM_BAG, 1);
	msg.addString("Placeholder");

	msg.addByte(8);
	msg.addByte(0x00);
	msg.addByte(0x00);
	msg.addByte(0x01);
	msg.addByte(0x00);
	msg.add<uint16_t>(0);
	msg.add<uint16_t>(0);
	msg.addByte(0x00);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendShop(Npc* npc, const ShopInfoList& itemList)
{
	NetworkMessage msg;
	msg.addByte(0x7A);
	msg.addString(npc->getName());

	// currency displayed in trade window (currently only gold supported)
	// if item other than gold coin is sent, the shop window takes information
	// about currency amount from player items packet (the one that updates action bars)
	msg.add<uint16_t>(Item::items[ITEM_GOLD_COIN].clientId);
	msg.addString(""); // doesn't show anywhere, could be used in otclient for currency name

	uint16_t itemsToSend = std::min<size_t>(itemList.size(), std::numeric_limits<uint16_t>::max());
	msg.add<uint16_t>(itemsToSend);

	uint16_t i = 0;
	for (auto it = itemList.begin(); i < itemsToSend; ++it, ++i) {
		AddShopItem(msg, *it);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCloseShop()
{
	NetworkMessage msg;
	msg.addByte(0x7C);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendSaleItemList(const std::list<ShopInfo>& shop)
{
	uint64_t playerBank = player->getBankBalance();
	uint64_t playerMoney = player->getMoney();
	sendResourceBalance(RESOURCE_BANK_BALANCE, playerBank);
	sendResourceBalance(RESOURCE_GOLD_EQUIPPED, playerMoney);

	NetworkMessage msg;
	msg.addByte(0x7B);
	//msg.add<uint64_t>(playerBank + playerMoney); // deprecated in QT client. to do: remove from OTC

	std::map<uint16_t, uint32_t> saleMap;

	if (shop.size() <= 5) {
		// For very small shops it's not worth it to create the complete map
		for (const ShopInfo& shopInfo : shop) {
			if (shopInfo.sellPrice == 0) {
				continue;
			}

			int8_t subtype = -1;

			const ItemType& itemType = Item::items[shopInfo.itemId];
			if (itemType.hasSubType() && !itemType.stackable && itemType.charges == 0) {
				subtype = (!itemType.isFluidContainer() && shopInfo.subType == 0 ? -1 : shopInfo.subType);
			}

			uint32_t count = player->getItemTypeCount(shopInfo.itemId, subtype, true, 0);
			if (count > 0) {
				saleMap[shopInfo.itemId] = count;
			}
		}
	} else {
		// Large shop, it's better to get a cached map of all item counts and use it
		// We need a temporary map since the finished map should only contain items
		// available in the shop
		TieredItemsCountMap tempSaleMap;
		player->getAllItemTypeCount(tempSaleMap, true);

		// We must still check manually for the special items that require subtype matches
		// (That is, fluids such as potions etc., actually these items are very few since
		// health potions now use their own ID)
		for (const ShopInfo& shopInfo : shop) {
			if (shopInfo.sellPrice == 0) {
				continue;
			}

			int8_t subtype = -1;

			const ItemType& itemType = Item::items[shopInfo.itemId];
			if (itemType.hasSubType() && !itemType.stackable && itemType.charges == 0) {
				subtype = (!itemType.isFluidContainer() && shopInfo.subType == 0 ? -1 : shopInfo.subType);
			}

			if (subtype != -1) {
				uint32_t count;
				if (itemType.isFluidContainer() || itemType.isSplash()) {
					count = player->getItemTypeCount(shopInfo.itemId, subtype, true, 0); // This shop item requires extra checks
				} else {
					count = subtype;
				}

				if (count > 0) {
					saleMap[shopInfo.itemId] = count;
				}
			} else {
				TieredItemsCountMap::const_iterator findIt = tempSaleMap.find({shopInfo.itemId, 0});
				if (findIt != tempSaleMap.end() && findIt->second > 0) {
					saleMap[shopInfo.itemId] = findIt->second;
				}
			}
		}
	}

	uint8_t itemsToSend = std::min<size_t>(saleMap.size(), std::numeric_limits<uint8_t>::max());
	msg.addByte(itemsToSend);

	uint8_t i = 0;
	for (std::map<uint16_t, uint32_t>::const_iterator it = saleMap.begin(); i < itemsToSend; ++it, ++i) {
		msg.addItemId(it->first);
		msg.add<uint16_t>(std::min<uint32_t>(it->second, std::numeric_limits<uint16_t>::max()));
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendResourceBalance(const ResourceTypes_t resourceType, uint64_t amount)
{
	NetworkMessage msg;
	msg.addByte(0xEE);
	msg.addByte(resourceType);
	if (resourceType == RESOURCE_CHARM_POINTS) {
		msg.add<uint32_t>(amount);
	} else {
		// fix overflow in forge UI
		switch(resourceType) {
			case RESOURCE_FORGE_DUST:
				amount = std::min<uint64_t>(std::numeric_limits<uint8_t>::max(), amount);
				break;
			case RESOURCE_FORGE_SLIVERS:
			case RESOURCE_FORGE_CORES:
				amount = std::min<uint64_t>(std::numeric_limits<uint16_t>::max(), amount);
				break;
			default:
				break;
		}

		msg.add<uint64_t>(amount);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendStoreBalance()
{
	// dispatcher thread only

	// sync coins from the database
	player->updateStoreCoins();

	// send balance
	NetworkMessage msg;

	// header
	msg.addByte(0xDF);
	msg.addByte(0x01);

	// resources
	int32_t storeCoins = player->getAccountResource(ACCOUNTRESOURCE_STORE_COINS);
	msg.add<int32_t>(storeCoins + player->getAccountResource(ACCOUNTRESOURCE_STORE_COINS_NONTRANSFERABLE)); // total store coins (transferable + non-t)
	msg.add<int32_t>(storeCoins); // transferable store coins
	msg.add<int32_t>(player->getAccountResource(ACCOUNTRESOURCE_STORE_COINS_RESERVED)); // reserved auction coins
	msg.add<int32_t>(player->getAccountResource(ACCOUNTRESOURCE_TOURNAMENT_COINS)); // tournament coins
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMarketEnter()
{
	NetworkMessage msg;
	msg.addByte(0xF6);
	msg.addByte(std::min<uint32_t>(IOMarket::getPlayerOfferCount(player->getGUID()), std::numeric_limits<uint8_t>::max()));

	player->setInMarket(true);
	TieredItemsCountMap depotItems;
	std::forward_list<Container*> containerList{ player->getInbox() };

	for (const auto& chest : player->depotChests) {
		if (!chest.second->empty()) {
			containerList.push_front(chest.second);
		}
	}

	do {
		Container* container = containerList.front();
		containerList.pop_front();

		for (Item* item : container->getItemList()) {
			Container* c = item->getContainer();
			if (c && !c->empty()) {
				containerList.push_front(c);
				continue;
			}

			const ItemType& itemType = Item::items[item->getID()];
			if (itemType.wareId == 0) {
				continue;
			}

			// store coins (item) are not marketable
			if (itemType.id == ITEM_STORE_COIN) {
				continue;
			}

			if (c && (!itemType.isContainer() || c->capacity() != itemType.maxItems)) {
				continue;
			}

			if (!item->hasMarketAttributes()) {
				continue;
			}

			depotItems[{itemType.id, item->getTier()}] += Item::countByType(item, -1);
		}
	} while (!containerList.empty());

	if (uint32_t playerStoreBalance = std::max<int32_t>(0, player->getAccountResource(ACCOUNTRESOURCE_STORE_COINS))) {
		// add store coins to market list
		depotItems[{ITEM_STORE_COIN, 0}] += playerStoreBalance;
	}

	uint16_t itemsToSend = std::min<size_t>(depotItems.size(), std::numeric_limits<uint16_t>::max());
	uint16_t i = 0;

	msg.add<uint16_t>(itemsToSend);
	for (auto it = depotItems.begin(); i < itemsToSend; ++it, ++i) {
		const ItemType& itemType = Item::items[it->first.first];
		const ItemType& wareItemType = Item::items.getItemIdByClientId(itemType.wareId);
		bool displayWareItem = wareItemType.clientId != 0;
		uint8_t classification = displayWareItem ? wareItemType.classification : itemType.classification;

		msg.add<uint16_t>(displayWareItem ? itemType.wareId : itemType.clientId);
		if (classification > 0) {
			msg.addByte(it->first.second);
		}
		msg.add<uint16_t>(std::min<uint32_t>(0xFFFF, it->second));
	}
	writeToOutputBuffer(msg);

	sendResourceBalance(RESOURCE_BANK_BALANCE, player->getBankBalance());
	sendResourceBalance(RESOURCE_GOLD_EQUIPPED, player->getMoney());
	sendStoreBalance();
}

void ProtocolGame::sendMarketLeave()
{
	NetworkMessage msg;
	msg.addByte(0xF7);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMarketBrowseItem(uint16_t itemId, const MarketOfferList& buyOffers, const MarketOfferList& sellOffers, uint8_t tier)
{
	sendStoreBalance();

	NetworkMessage msg;
	msg.addByte(0xF9);
	msg.addByte(MARKETREQUEST_ITEM);
	msg.addItemId(itemId);

	if (Item::items[itemId].classification > 0) {
		msg.addByte(tier); // item tier
	}

	msg.add<uint32_t>(buyOffers.size());
	for (const MarketOffer& offer : buyOffers) {
		msg.add<uint32_t>(offer.timestamp);
		msg.add<uint16_t>(offer.counter);
		msg.add<uint16_t>(offer.amount);
		msg.add<uint64_t>(offer.price);
		msg.addString(offer.playerName);
	}

	msg.add<uint32_t>(sellOffers.size());
	for (const MarketOffer& offer : sellOffers) {
		msg.add<uint32_t>(offer.timestamp);
		msg.add<uint16_t>(offer.counter);
		msg.add<uint16_t>(offer.amount);
		msg.add<uint64_t>(offer.price);
		msg.addString(offer.playerName);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMarketAcceptOffer(const MarketOfferEx& offer)
{
	NetworkMessage msg;
	msg.addByte(0xF9);
	msg.addByte(MARKETREQUEST_ITEM);
	msg.addItemId(offer.itemId);
	if (Item::items[offer.itemId].classification > 0) {
		msg.addByte(offer.tier);
	}

	if (offer.type == MARKETACTION_BUY) {
		msg.add<uint32_t>(0x01);
		msg.add<uint32_t>(offer.timestamp);
		msg.add<uint16_t>(offer.counter);
		msg.add<uint16_t>(offer.amount);
		msg.add<uint64_t>(offer.price);
		msg.addString(offer.playerName);
		msg.add<uint32_t>(0x00);
	} else {
		msg.add<uint32_t>(0x00);
		msg.add<uint32_t>(0x01);
		msg.add<uint32_t>(offer.timestamp);
		msg.add<uint16_t>(offer.counter);
		msg.add<uint16_t>(offer.amount);
		msg.add<uint64_t>(offer.price);
		msg.addString(offer.playerName);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMarketBrowseOwnOffers(const MarketOfferList& buyOffers, const MarketOfferList& sellOffers)
{
	NetworkMessage msg;
	msg.addByte(0xF9);
	msg.addByte(MARKETREQUEST_OWN_OFFERS);

	msg.add<uint32_t>(buyOffers.size());
	for (const MarketOffer& offer : buyOffers) {
		msg.add<uint32_t>(offer.timestamp);
		msg.add<uint16_t>(offer.counter);
		msg.addItemId(offer.itemId);
		if (Item::items[offer.itemId].classification > 0) {
			msg.addByte(offer.tier);
		}
		msg.add<uint16_t>(offer.amount);
		msg.add<uint64_t>(offer.price);
	}

	msg.add<uint32_t>(sellOffers.size());
	for (const MarketOffer& offer : sellOffers) {
		msg.add<uint32_t>(offer.timestamp);
		msg.add<uint16_t>(offer.counter);
		msg.addItemId(offer.itemId);
		if (Item::items[offer.itemId].classification > 0) {
			msg.addByte(offer.tier);
		}
		msg.add<uint16_t>(offer.amount);
		msg.add<uint64_t>(offer.price);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMarketCancelOffer(const MarketOfferEx& offer)
{
	NetworkMessage msg;
	msg.addByte(0xF9);
	msg.addByte(MARKETREQUEST_OWN_OFFERS);

	if (offer.type == MARKETACTION_BUY) {
		msg.add<uint32_t>(0x01);
		msg.add<uint32_t>(offer.timestamp);
		msg.add<uint16_t>(offer.counter);
		msg.addItemId(offer.itemId);
		if (Item::items[offer.itemId].classification > 0) {
			msg.addByte(offer.tier);
		}
		msg.add<uint16_t>(offer.amount);
		msg.add<uint64_t>(offer.price);
		msg.add<uint32_t>(0x00);
	} else {
		msg.add<uint32_t>(0x00);
		msg.add<uint32_t>(0x01);
		msg.add<uint32_t>(offer.timestamp);
		msg.add<uint16_t>(offer.counter);
		msg.addItemId(offer.itemId);
		if (Item::items[offer.itemId].classification > 0) {
			msg.addByte(offer.tier);
		}
		msg.add<uint16_t>(offer.amount);
		msg.add<uint64_t>(offer.price);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMarketBrowseOwnHistory(const HistoryMarketOfferList& buyOffers, const HistoryMarketOfferList& sellOffers)
{
	uint32_t i = 0;
	std::map<uint32_t, uint16_t> counterMap;
	uint32_t buyOffersToSend = std::min<uint32_t>(buyOffers.size(), 810 + std::max<int32_t>(0, 810 - sellOffers.size()));
	uint32_t sellOffersToSend = std::min<uint32_t>(sellOffers.size(), 810 + std::max<int32_t>(0, 810 - buyOffers.size()));

	NetworkMessage msg;
	msg.addByte(0xF9);
	msg.addByte(MARKETREQUEST_OWN_HISTORY);

	msg.add<uint32_t>(buyOffersToSend);
	for (auto it = buyOffers.begin(); i < buyOffersToSend; ++it, ++i) {
		msg.add<uint32_t>(it->timestamp);
		msg.add<uint16_t>(counterMap[it->timestamp]++);
		msg.addItemId(it->itemId);
		if (Item::items[it->itemId].classification > 0) {
			msg.addByte(it->tier);
		}
		msg.add<uint16_t>(it->amount);
		msg.add<uint64_t>(it->price);
		msg.addByte(it->state);
	}

	counterMap.clear();
	i = 0;

	msg.add<uint32_t>(sellOffersToSend);
	for (auto it = sellOffers.begin(); i < sellOffersToSend; ++it, ++i) {
		msg.add<uint32_t>(it->timestamp);
		msg.add<uint16_t>(counterMap[it->timestamp]++);
		msg.addItemId(it->itemId);
		if (Item::items[it->itemId].classification > 0) {
			msg.addByte(it->tier);
		}
		msg.add<uint16_t>(it->amount);
		msg.add<uint64_t>(it->price);
		msg.addByte(it->state);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendQuestLog()
{
	NetworkMessage msg;
	msg.addByte(0xF0);
	msg.add<uint16_t>(g_game.quests.getQuestsCount(player));

	for (const Quest& quest : g_game.quests.getQuests()) {
		if (quest.isStarted(player)) {
			msg.add<uint16_t>(quest.getID());
			msg.addString(quest.getName());
			msg.addByte(quest.isCompleted(player));
		}
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendQuestLine(const Quest* quest)
{
	NetworkMessage msg;
	msg.addByte(0xF1);
	msg.add<uint16_t>(quest->getID());
	msg.addByte(quest->getMissionsCount(player));

	for (const Mission& mission : quest->getMissions()) {
		if (mission.isStarted(player)) {
			msg.add<uint16_t>(mission.getID());
			msg.addString(mission.getName(player));
			msg.addString(mission.getDescription(player));
		}
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendQuestTracker()
{
	NetworkMessage msg;
	msg.addByte(0xD0);
	msg.addByte(1);
	size_t trackeds = player->trackedQuests.size();
	msg.addByte(player->getMaxTrackedQuests() - trackeds);
	msg.addByte(trackeds);

	for (const TrackedQuest& trackedQuest : player->trackedQuests) {
		const Quest* quest = g_game.quests.getQuestByID(trackedQuest.getQuestId());
		const Mission* mission = quest->getMissionById(trackedQuest.getMissionId());
		msg.add<uint16_t>(trackedQuest.getMissionId());
		msg.addString(quest->getName());
		msg.addString(mission->getName(player));
		msg.addString(mission->getDescription(player));
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendUpdateQuestTracker(const TrackedQuest& trackedQuest)
{
	NetworkMessage msg;
	msg.addByte(0xD0);
	msg.addByte(0);

	const Quest* quest = g_game.quests.getQuestByID(trackedQuest.getQuestId());
	const Mission* mission = quest->getMissionById(trackedQuest.getMissionId());
	msg.add<uint16_t>(trackedQuest.getMissionId());
	msg.addString(mission->getName(player));
	msg.addString(mission->getDescription(player));

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendTradeItemRequest(const std::string& traderName, const Item* item, bool ack)
{
	NetworkMessage msg;

	if (ack) {
		msg.addByte(0x7D);
	} else {
		msg.addByte(0x7E);
	}

	msg.addString(traderName);

	if (const Container* tradeContainer = item->getContainer()) {
		std::list<const Container*> listContainer {tradeContainer};
		std::list<const Item*> itemList {tradeContainer};
		while (!listContainer.empty()) {
			const Container* container = listContainer.front();
			listContainer.pop_front();

			for (Item* containerItem : container->getItemList()) {
				Container* tmpContainer = containerItem->getContainer();
				if (tmpContainer) {
					listContainer.push_back(tmpContainer);
				}
				itemList.push_back(containerItem);
			}
		}

		msg.addByte(itemList.size());
		for (const Item* listItem : itemList) {
			msg.addItem(listItem);
		}
	} else {
		msg.addByte(0x01);
		msg.addItem(item);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCloseTrade()
{
	NetworkMessage msg;
	msg.addByte(0x7F);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCloseContainer(uint8_t cid)
{
	NetworkMessage msg;
	msg.addByte(0x6F);
	msg.addByte(cid);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureTurn(const Creature* creature, uint32_t stackPos)
{
	if (!canSee(creature)) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x6B);
	if (stackPos >= 10) {
		msg.add<uint16_t>(0xFFFF);
		msg.add<uint32_t>(creature->getID());
	} else {
		msg.addPosition(creature->getPosition());
		msg.addByte(stackPos);
	}

	msg.add<uint16_t>(0x63);
	msg.add<uint32_t>(creature->getID());
	msg.addByte(creature->getDirection());
	msg.addByte(player->canWalkthroughEx(creature) ? 0x00 : 0x01);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureSay(const Creature* creature, MessageClasses type, const std::string& text, const Position* pos/* = nullptr*/)
{
	NetworkMessage msg;
	msg.addByte(0xAA);

	static uint32_t statementId = 0;
	msg.add<uint32_t>(++statementId);

	msg.addString(creature->getName());
	msg.addByte(0x00); // "(Traded)" suffix after player name

	//Add level only for players
	if (const Player* speaker = creature->getPlayer()) {
		msg.add<uint16_t>(std::min<uint32_t>(speaker->getLevel(), std::numeric_limits<uint16_t>::max()));
	} else {
		msg.add<uint16_t>(0x00);
	}

	msg.addByte(type);
	if (pos) {
		msg.addPosition(*pos);
	} else {
		msg.addPosition(creature->getPosition());
	}

	msg.addString(text);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendToChannel(const Creature* creature, MessageClasses type, const std::string& text, uint16_t channelId)
{
	NetworkMessage msg;
	msg.addByte(0xAA);

	static uint32_t statementId = 0;
	msg.add<uint32_t>(++statementId);
	if (!creature) {
		msg.add<uint32_t>(0x00);
		msg.addByte(0x00); // "(Traded)" suffix after player name
	} else {
		msg.addString(creature->getName());
		msg.addByte(0x00); // "(Traded)" suffix after player name

		//Add level only for players
		if (const Player* speaker = creature->getPlayer()) {
			msg.add<uint16_t>(std::min<uint32_t>(speaker->getLevel(), std::numeric_limits<uint16_t>::max()));
		} else {
			msg.add<uint16_t>(0x00);
		}
	}

	msg.addByte(type);
	msg.add<uint16_t>(channelId);
	msg.addString(text);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPrivateMessage(const Player* speaker, MessageClasses type, const std::string& text)
{
	NetworkMessage msg;
	msg.addByte(0xAA);
	static uint32_t statementId = 0;
	msg.add<uint32_t>(++statementId);
	if (speaker) {
		msg.addString(speaker->getName());
		msg.addByte(0x00); // "(Traded)" suffix after player name
		msg.add<uint16_t>(std::min<uint32_t>(speaker->getLevel(), std::numeric_limits<uint16_t>::max()));
	} else {
		msg.add<uint32_t>(0x00);
		msg.addByte(0x00); // "(Traded)" suffix after player name
	}
	msg.addByte(type);
	msg.addString(text);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendNamedPrivateMessage(const std::string& speaker, MessageClasses type, const std::string& text)
{
	NetworkMessage msg;
	msg.addByte(0xAA);
	static uint32_t statementId = 0;
	msg.add<uint32_t>(++statementId);
	msg.addString(speaker);
	msg.addByte(0x00); // "(Traded)" suffix after player name
	msg.add<uint16_t>(0);
	msg.addByte(type);
	msg.addString(text);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCancelTarget()
{
	NetworkMessage msg;
	msg.addByte(0xA3);
	msg.add<uint32_t>(0x00);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendChangeSpeed(const Creature* creature, uint32_t speed)
{
	NetworkMessage msg;
	msg.addByte(0x8F);
	msg.add<uint32_t>(creature->getID());
	msg.add<uint16_t>(creature->getBaseSpeed() / 2);
	msg.add<uint16_t>(speed / 2);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCancelWalk()
{
	NetworkMessage msg;
	msg.addByte(0xB5);
	msg.addByte(player->getDirection());
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendSkills()
{
	NetworkMessage msg;
	AddPlayerSkills(msg);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendBlessings()
{
	if (!player) {
		return;
	}

	// client blessings:
	/*
		1 - adventurer (glowing slots + info in bless panel)
		2 - twist of fate
		3 - wisdom
		4 - spark
		5 - fire
		6 - spirit
		7 - embrace
		8 - heart
		9 - blood
		10-16 - (nothing happens)
	*/
	NetworkMessage msg;
	uint8_t blessCount = 0;
	uint16_t clientBlessings = 0;

	bool hasToF = false;

	for (int i = 0; i < 8; i++) {
		if (i == 5) {
			// move original 5 blessings to proper positions
			clientBlessings = clientBlessings << 2;
		}

		if (player->hasBlessing(i)) {
			if (i < 5) {
				// classic blessing
				clientBlessings |= 1 << i;
			} else if (i == 5) {
				// twist of fate
				clientBlessings |= 1 << 1;
				hasToF = true;
			} else {
				// mountain blessings
				clientBlessings |= ((1 << i) << 1);
			}

			if (i != 5) {
				++blessCount;
			}
		}
	}

	msg.addByte(0x9C);
	msg.add<uint16_t>(clientBlessings);
	msg.addByte((blessCount >= 7 && hasToF) ? 3 : ((blessCount >= 5) ? 2 : 1)); // 1 = Disabled | 2 = normal | 3 = green

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPing()
{
	NetworkMessage msg;
	msg.addByte(0x1D);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPingBack()
{
	NetworkMessage msg;
	msg.addByte(0x1E);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendDistanceShoot(const Position& from, const Position& to, uint8_t type)
{
	NetworkMessage msg;
	msg.addByte(0x83);
	msg.addPosition(from);
	msg.addByte(MAGIC_EFFECTS_CREATE_DISTANCEEFFECT);
	msg.addByte(type);
	msg.addByte(static_cast<uint8_t>(static_cast<int8_t>(static_cast<int32_t>(to.x) - static_cast<int32_t>(from.x))));
	msg.addByte(static_cast<uint8_t>(static_cast<int8_t>(static_cast<int32_t>(to.y) - static_cast<int32_t>(from.y))));
	msg.addByte(MAGIC_EFFECTS_END_LOOP);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMagicEffect(const Position& pos, uint8_t type)
{
	if (!canSee(pos)) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x83);
	msg.addPosition(pos);
	msg.addByte(MAGIC_EFFECTS_CREATE_EFFECT);
	msg.addByte(type);
	msg.addByte(MAGIC_EFFECTS_END_LOOP);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureHealth(const Creature* creature)
{
	NetworkMessage msg;
	msg.addByte(0x8C);
	msg.add<uint32_t>(creature->getID());

	if (creature->isHealthHidden()) {
		msg.addByte(0x00);
	} else {
		msg.addByte(std::ceil((static_cast<double>(creature->getHealth()) / std::max<int32_t>(creature->getMaxHealth(), 1)) * 100));
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendFYIBox(const std::string& message)
{
	NetworkMessage msg;
	msg.addByte(0x15);
	msg.addString(message);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendGuildMotdEditDialog(const std::string& currentMotd)
{
	NetworkMessage msg;
	msg.addByte(0xAE);
	msg.addString(currentMotd);
	writeToOutputBuffer(msg);
}

//tile
void ProtocolGame::sendMapDescription(const Position& pos)
{
	NetworkMessage msg;
	msg.addByte(0x64);
	msg.addPosition(player->getPosition());
	GetMapDescription(pos.x - Map::maxClientViewportX, pos.y - Map::maxClientViewportY, pos.z, (Map::maxClientViewportX * 2) + 2, (Map::maxClientViewportY * 2) + 2, msg);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendAddTileItem(const Position& pos, uint32_t stackpos, const Item* item)
{
	if (!canSee(pos)) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x6A);
	msg.addPosition(pos);
	msg.addByte(stackpos);
	msg.addItem(item);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendUpdateTileItem(const Position& pos, uint32_t stackpos, const Item* item)
{
	if (!canSee(pos)) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x6B);
	msg.addPosition(pos);
	msg.addByte(stackpos);
	msg.addItem(item);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendRemoveTileThing(const Position& pos, uint32_t stackpos)
{
	if (!canSee(pos)) {
		return;
	}

	NetworkMessage msg;
	RemoveTileThing(msg, pos, stackpos);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendUpdateTileCreature(const Position& pos, uint32_t stackpos, const Creature* creature)
{
	if (!canSee(pos)) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x6B);
	msg.addPosition(pos);
	msg.addByte(stackpos);

	// send creature as "new" (known: false, cache id to overwrite: creature id)
	AddCreature(msg, creature, false, creature->getID());

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendUpdateCreatureIcons(const Creature* creature)
{
	if (!canSee(creature->getPosition())) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x8B);
	msg.add<uint32_t>(creature->getID());
	msg.addByte(14); // event player icons

	AddCreatureIcons(msg, creature);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendRemoveTileCreature(const Creature* creature, const Position& pos, uint32_t stackpos)
{
	if (stackpos < 10) {
		if (!canSee(pos)) {
			return;
		}

		NetworkMessage msg;
		RemoveTileThing(msg, pos, stackpos);
		writeToOutputBuffer(msg);
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x6C);
	msg.add<uint16_t>(0xFFFF);
	msg.add<uint32_t>(creature->getID());
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendUpdateTile(const Tile* tile, const Position& pos)
{
	if (!canSee(pos)) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x69);
	msg.addPosition(pos);

	if (tile) {
		GetTileDescription(tile, msg);
		msg.addByte(0x00);
		msg.addByte(0xFF);
	} else {
		msg.addByte(0x01);
		msg.addByte(0xFF);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPendingStateEntered()
{
	NetworkMessage msg;
	msg.addByte(0x0A);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendEnterWorld()
{
	NetworkMessage msg;
	msg.addByte(0x0F);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendFightModes()
{
	NetworkMessage msg;
	msg.addByte(0xA7);
	msg.addByte(player->fightMode);
	msg.addByte(player->chaseMode);
	msg.addByte(player->secureMode);
	msg.addByte(PVP_MODE_DOVE);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendAddCreature(const Creature* creature, const Position& pos, int32_t stackpos, MagicEffectClasses magicEffect/*= CONST_ME_NONE*/)
{
	if (!canSee(pos)) {
		return;
	}

	if (creature != player) {
		// stack pos is always real index now, so it can exceed the limit
		// if stack pos exceeds the limit, we need to refresh the tile instead
		// 1. this is a rare case, and is only triggered by forcing summon in a position
		// 2. since no stackpos will be send to the client about that creature, removing
		//    it must be done with its id if its stackpos remains >= 10. this is done to
		//    add creatures to battle list instead of rendering on screen
		if (stackpos >= 10) {
			// @todo: should we avoid this check?
			if (const Tile* tile = creature->getTile()) {
				sendUpdateTile(tile, pos);
			}
		} else {
			// if stackpos is -1, the client will automatically detect it
			NetworkMessage msg;
			msg.addByte(0x6A);
			msg.addPosition(pos);
			msg.addByte(stackpos);

			bool known;
			uint32_t removedKnown;
			checkCreatureAsKnown(creature->getID(), known, removedKnown);
			AddCreature(msg, creature, known, removedKnown);
			writeToOutputBuffer(msg);
		}

		if (magicEffect != CONST_ME_NONE) {
			sendMagicEffect(pos, magicEffect);
		}
		return;
	}

	// send active conditions
	player->sendIcons();

	// send client info
	sendClientFeatures(); // player speed, bug reports, store url, pvp mode, etc
	sendBasicData(); // premium account, vocation, known spells, prey system status, magic shield status

	// enter world and send game screen
	sendPendingStateEntered();
	sendEnterWorld();
	sendMapDescription(pos);

	// send player stats
	sendStats(); // hp, cap, level, xp rate, etc.
	sendSkills(); // skills and special skills

	// send equipment
	for (int i = CONST_SLOT_FIRST; i <= CONST_SLOT_LAST; ++i) {
		sendInventoryItem(static_cast<slots_t>(i), player->getInventoryItem(static_cast<slots_t>(i)));
	}

	// send store inbox
	sendInventoryItem(CONST_SLOT_STORE_INBOX, player->getStoreInbox()->getItem());

	// send action bar items
	sendItems();

	// send login effect
	if (magicEffect != CONST_ME_NONE) {
		sendMagicEffect(pos, magicEffect);
	}

	// gameworld time of the day
	sendWorldLight(g_game.getWorldLightInfo());
	sendWorldTime();

	// player light level
	sendCreatureLight(creature);

	// player vip list
	sendVIPEntries();
	
	// opened containers
	player->openSavedContainers();
}

void ProtocolGame::sendMoveCreature(const Creature* creature, const Position& newPos, int32_t newStackPos, const Position& oldPos, int32_t oldStackPos, bool teleport)
{
	if (creature == player) {
		if (teleport) {
			sendRemoveTileCreature(creature, oldPos, oldStackPos);
			sendMapDescription(newPos);
		} else {
			NetworkMessage msg;
			if (oldPos.z == 7 && newPos.z >= 8) {
				RemoveTileCreature(msg, creature, oldPos, oldStackPos);
			} else {
				msg.addByte(0x6D);
				if (oldStackPos < 10) {
					msg.addPosition(oldPos);
					msg.addByte(oldStackPos);
				} else {
					msg.add<uint16_t>(0xFFFF);
					msg.add<uint32_t>(creature->getID());
				}
				msg.addPosition(newPos);
			}

			if (newPos.z > oldPos.z) {
				MoveDownCreature(msg, creature, newPos, oldPos);
			} else if (newPos.z < oldPos.z) {
				MoveUpCreature(msg, creature, newPos, oldPos);
			}

			if (oldPos.y > newPos.y) { // north, for old x
				msg.addByte(0x65);
				GetMapDescription(oldPos.x - Map::maxClientViewportX, newPos.y - Map::maxClientViewportY, newPos.z, (Map::maxClientViewportX * 2) + 2, 1, msg);
			} else if (oldPos.y < newPos.y) { // south, for old x
				msg.addByte(0x67);
				GetMapDescription(oldPos.x - Map::maxClientViewportX, newPos.y + (Map::maxClientViewportY + 1), newPos.z, (Map::maxClientViewportX * 2) + 2, 1, msg);
			}

			if (oldPos.x < newPos.x) { // east, [with new y]
				msg.addByte(0x66);
				GetMapDescription(newPos.x + (Map::maxClientViewportX + 1), newPos.y - Map::maxClientViewportY, newPos.z, 1, (Map::maxClientViewportY * 2) + 2, msg);
			} else if (oldPos.x > newPos.x) { // west, [with new y]
				msg.addByte(0x68);
				GetMapDescription(newPos.x - Map::maxClientViewportX, newPos.y - Map::maxClientViewportY, newPos.z, 1, (Map::maxClientViewportY * 2) + 2, msg);
			}
			writeToOutputBuffer(msg);
		}
	} else if (canSee(oldPos) && canSee(creature->getPosition())) {
		if (teleport || (oldPos.z == 7 && newPos.z >= 8)) {
			sendRemoveTileCreature(creature, oldPos, oldStackPos);
			sendAddCreature(creature, newPos, newStackPos);
			sendUpdateTileCreature(newPos, newStackPos, creature);
		} else {
			NetworkMessage msg;
			msg.addByte(0x6D);
			if (oldStackPos < 10) {
				msg.addPosition(oldPos);
				msg.addByte(oldStackPos);
			} else {
				msg.add<uint16_t>(0xFFFF);
				msg.add<uint32_t>(creature->getID());
			}
			msg.addPosition(creature->getPosition());
			writeToOutputBuffer(msg);
		}
	} else if (canSee(oldPos)) {
		sendRemoveTileCreature(creature, oldPos, oldStackPos);
	} else if (canSee(creature->getPosition())) {
		sendAddCreature(creature, newPos, newStackPos);
	}
}

void ProtocolGame::sendInventoryItem(slots_t slot, const Item* item)
{
	NetworkMessage msg;
	if (item) {
		msg.addByte(0x78);
		msg.addByte(slot);
		msg.addItem(item);
	} else {
		msg.addByte(0x79);
		msg.addByte(slot);
	}
	writeToOutputBuffer(msg);
}

// to do: make it lightweight, update each time player gets/loses an item
void ProtocolGame::sendItems()
{
	NetworkMessage msg;
	msg.addByte(0xF5);

	// find all items carried by character (itemId, amount)
	TieredItemsCountMap inventory;
	player->getAllItemTypeCount(inventory);

	msg.add<uint16_t>(inventory.size() + 11);
	for (uint16_t i = 1; i <= 11; i++) {
		msg.add<uint16_t>(i); // slotId
		msg.addByte(0); // always 0
		msg.add<uint16_t>(1); // always 1
	}

	for (const auto& item : inventory) {
		msg.add<uint16_t>(Item::items[item.first.first].clientId); // item clientId
		msg.addByte(item.first.second); // tier
		msg.add<uint16_t>(std::min<int32_t>(item.second, std::numeric_limits<uint16_t>::max())); // count
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendAddContainerItem(uint8_t cid, uint16_t slot, const Item* item)
{
	NetworkMessage msg;
	msg.addByte(0x70);
	msg.addByte(cid);
	msg.add<uint16_t>(slot);
	msg.addItem(item);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendUpdateContainerItem(uint8_t cid, uint16_t slot, const Item* item)
{
	NetworkMessage msg;
	msg.addByte(0x71);
	msg.addByte(cid);
	msg.add<uint16_t>(slot);
	msg.addItem(item);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendRemoveContainerItem(uint8_t cid, uint16_t slot, const Item* lastItem)
{
	NetworkMessage msg;
	msg.addByte(0x72);
	msg.addByte(cid);
	msg.add<uint16_t>(slot);
	if (lastItem) {
		msg.addItem(lastItem);
	} else {
		msg.add<uint16_t>(0x00);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendTextWindow(uint32_t windowTextId, Item* item, uint16_t maxlen, bool canWrite)
{
	NetworkMessage msg;
	msg.addByte(0x96);
	msg.add<uint32_t>(windowTextId);
	msg.addItem(item);

	if (canWrite) {
		msg.add<uint16_t>(maxlen);
		msg.addString(item->getText());
	} else {
		const std::string& text = item->getText();
		msg.add<uint16_t>(text.size());
		msg.addString(text);
	}

	const std::string& writer = item->getWriter();
	if (!writer.empty()) {
		msg.addString(writer);
	} else {
		msg.add<uint16_t>(0x00);
	}

	msg.addByte(0x00); // "(traded)" suffix after player name (bool)

	time_t writtenDate = item->getDate();
	if (writtenDate != 0) {
		msg.addString(formatDateShort(writtenDate));
	} else {
		msg.add<uint16_t>(0x00);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendTextWindow(uint32_t windowTextId, uint32_t itemId, const std::string& text)
{
	NetworkMessage msg;
	msg.addByte(0x96);
	msg.add<uint32_t>(windowTextId);
	msg.addItem(itemId, 1);
	msg.add<uint16_t>(text.size());
	msg.addString(text);
	msg.add<uint16_t>(0x00); // writer name
	msg.addByte(0x00); // "(traded)" byte
	msg.add<uint16_t>(0x00); // date
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendHouseWindow(uint32_t windowTextId, const std::string& text)
{
	NetworkMessage msg;
	msg.addByte(0x97);
	msg.addByte(0x00);
	msg.add<uint32_t>(windowTextId);
	msg.addString(text);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendOutfitWindow(uint16_t tryOutfitType, uint16_t tryMountType)
{
	// get player outfits
	const auto& outfits = Outfits::getInstance().getOutfits(player->getSex());
	if (outfits.size() == 0) {
		return;
	}

	// get current outfit info
	Outfit_t currentOutfit = player->getDefaultOutfit();

	// default outfit unavailable
	if (currentOutfit.lookType == 0) {
		Outfit_t newOutfit;
		newOutfit.lookType = outfits.front().lookType;
		currentOutfit = newOutfit;
	}

	// determine window mode
	uint8_t windowMode = 0;

	// "try outfit" window override
	if (tryOutfitType != 0) {
		currentOutfit.lookType = tryOutfitType;
		currentOutfit.lookAddons = 3;
		windowMode = 1;
	}

	// QT client fix for unmountable looktypes
	if (player->getOperatingSystem() < CLIENTOS_OTCLIENT_LINUX) {
		if (!Outfits::getInstance().getOutfitByLookType(player->getSex(), currentOutfit.lookType)) {
			currentOutfit.lookType = outfits.front().lookType;
		}
	}

	// get current mount info
	const Mount* currentMount = g_game.mounts.getMountByID(player->getCurrentMount());
	if (currentMount) {
		currentOutfit.lookMount = currentMount->clientId;
	}
	bool mounted = currentOutfit.lookMount != 0;

	// "try mount" window override
	if (tryMountType != 0) {
		currentOutfit.lookMount = tryMountType;
		mounted = true;
		if (windowMode == 0) {
			windowMode = 2;
		}
	}

	// start building the response
	NetworkMessage msg;
	msg.addByte(0xC8);
	AddOutfit(msg, currentOutfit);

	// mount color bytes are required here regardless of having one
	if (currentOutfit.lookMount == 0) {
		msg.addByte(currentOutfit.lookMountHead);
		msg.addByte(currentOutfit.lookMountBody);
		msg.addByte(currentOutfit.lookMountLegs);
		msg.addByte(currentOutfit.lookMountFeet);
	}

	// get available familiars
	std::vector<const Familiar*> familiars;
	for (const Familiar& familiar : g_game.familiars.getFamiliars()) {
		if (player->canUseFamiliar(&familiar)) {
			familiars.push_back(&familiar);
		}
	}
	
	// add current familiar
	if (familiars.size() > 0) {
		const Familiar* currentFamiliar = g_game.familiars.getFamiliarByID(player->getCurrentFamiliar());
		if (currentFamiliar && player->canUseFamiliar(currentFamiliar)) {
			msg.add<uint16_t>(currentFamiliar->clientId);
		} else {
			currentFamiliar = familiars.front();
			msg.add<uint16_t>(currentFamiliar->clientId);
		}
	} else {
		msg.add<uint16_t>(0);
	}

	AddPlayerOutfits(msg);
	AddPlayerMounts(msg);
	AddPlayerFamiliars(msg);

	// outfit window mode
	// 0 - player outfit
	// 1 - try outfit (doesnt take randomized mount byte)
	// 2 - try mount (same as try outfit, different window title)
	// 3 - hireling (handled in lua)
	// 4 - try hireling dress (takes 3 bytes after window mode)
	// 5 - podium (handled by method below)
	msg.addByte(windowMode);
	msg.addByte(mounted ? 0x01 : 0x00);
	if (windowMode == 0) {
		msg.addByte(player->hasRandomizedMount() ? 0x01 : 0x00); // randomize mount (bool)
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPodiumWindow(const Item* item)
{
	if (!item) {
		return;
	}

	const Podium* podium = item->getPodium();
	if (!podium) {
		return;
	}

	const Tile* tile = item->getTile();
	if (!tile) {
		return;
	}

	int32_t stackpos = tile->getThingIndex(item);

	// read podium outfit
	Outfit_t podiumOutfit = podium->getOutfit();
	Outfit_t playerOutfit = player->getDefaultOutfit();
	bool isEmpty = podiumOutfit.lookType == 0 && podiumOutfit.lookMount == 0;

	if (podiumOutfit.lookType == 0) {
		// copy player outfit
		podiumOutfit.lookType = playerOutfit.lookType;
		podiumOutfit.lookHead = playerOutfit.lookHead;
		podiumOutfit.lookBody = playerOutfit.lookBody;
		podiumOutfit.lookLegs = playerOutfit.lookLegs;
		podiumOutfit.lookFeet = playerOutfit.lookFeet;
		podiumOutfit.lookAddons = playerOutfit.lookAddons;
	}

	if (podiumOutfit.lookMount == 0) {
		// copy player mount
		podiumOutfit.lookMount = playerOutfit.lookMount;
		podiumOutfit.lookMountHead = playerOutfit.lookMountHead;
		podiumOutfit.lookMountBody = playerOutfit.lookMountBody;
		podiumOutfit.lookMountLegs = playerOutfit.lookMountLegs;
		podiumOutfit.lookMountFeet = playerOutfit.lookMountFeet;
	}

	// fetch player outfits
	const auto& outfits = Outfits::getInstance().getOutfits(player->getSex());
	if (outfits.size() == 0) {
		player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return;
	}

	// select first outfit available when the one from podium is not unlocked
	if (!player->canWear(podiumOutfit.lookType, 0)) {
		podiumOutfit.lookType = outfits.front().lookType;
	}

	// packet header
	NetworkMessage msg;
	msg.addByte(0xC8);

	// current outfit
	msg.add<uint16_t>(podiumOutfit.lookType);
	msg.addByte(podiumOutfit.lookHead);
	msg.addByte(podiumOutfit.lookBody);
	msg.addByte(podiumOutfit.lookLegs);
	msg.addByte(podiumOutfit.lookFeet);
	msg.addByte(podiumOutfit.lookAddons);

	// current mount
	msg.add<uint16_t>(podiumOutfit.lookMount);
	msg.addByte(podiumOutfit.lookMountHead);
	msg.addByte(podiumOutfit.lookMountBody);
	msg.addByte(podiumOutfit.lookMountLegs);
	msg.addByte(podiumOutfit.lookMountFeet);

	// current familiar (not used in podium mode)
	msg.add<uint16_t>(0);

	AddPlayerOutfits(msg);
	AddPlayerMounts(msg);

	// available familiars (not used in podium mode)
	msg.add<uint16_t>(0);

	msg.addByte(0x05); // "set outfit" window mode (5 = podium)
	msg.addByte((isEmpty && playerOutfit.lookMount != 0) || podium->hasFlag(PODIUM_SHOW_MOUNT) ? 0x01 : 0x00); // "mount" checkbox
	msg.add<uint16_t>(0); // unknown
	msg.addPosition(item->getPosition());
	msg.add<uint16_t>(item->getClientID());
	msg.addByte(stackpos);

	msg.addByte(podium->hasFlag(PODIUM_SHOW_PLATFORM) ? 0x01 : 0x00); // is platform visible
	msg.addByte(0x01); // "outfit" checkbox, ignored by the client
	msg.addByte(podium->getDirection()); // outfit direction
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendUpdatedVIPStatus(uint32_t guid, VipStatus_t newStatus)
{
	NetworkMessage msg;
	msg.addByte(0xD3);
	msg.add<uint32_t>(guid);
	msg.addByte(newStatus);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendVIP(uint32_t guid, const std::string& name, const std::string& description, uint32_t icon, bool notify, VipStatus_t status)
{
	NetworkMessage msg;
	msg.addByte(0xD2);
	msg.add<uint32_t>(guid);
	msg.addString(name);
	msg.addString(description);
	msg.add<uint32_t>(std::min<uint32_t>(10, icon));
	msg.addByte(notify ? 0x01 : 0x00);
	msg.addByte(status);
	msg.addByte(0x00); // vipGroups (placeholder)
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendVIPEntries()
{
	const std::forward_list<VIPEntry>& vipEntries = IOLoginData::getVIPEntries(player->getAccount());

	for (const VIPEntry& entry : vipEntries) {
		VipStatus_t vipStatus = VIPSTATUS_ONLINE;

		Player* vipPlayer = g_game.getPlayerByGUID(entry.guid);

		if (!vipPlayer || !player->canSeeCreature(vipPlayer)) {
			vipStatus = VIPSTATUS_OFFLINE;
		} else if (vipPlayer && vipPlayer->isAfk()) {
			vipStatus = VIPSTATUS_TRAINING;
		}

		sendVIP(entry.guid, entry.name, entry.description, entry.icon, entry.notify, vipStatus);
	}
}

void ProtocolGame::sendSpellCooldown(uint8_t spellId, uint32_t time)
{
	NetworkMessage msg;
	msg.addByte(0xA4);
	msg.add<uint16_t>(static_cast<uint16_t>(spellId));
	msg.add<uint32_t>(time);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendSpellGroupCooldown(SpellGroup_t groupId, uint32_t time)
{
	NetworkMessage msg;
	msg.addByte(0xA5);
	msg.addByte(groupId);
	msg.add<uint32_t>(time);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendUseItemCooldown(uint32_t time)
{
	NetworkMessage msg;
	msg.addByte(0xA6);
	msg.add<uint32_t>(time);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendSupplyUsed(const uint16_t clientId)
{
	NetworkMessage msg;
	msg.addByte(0xCE);
	msg.add<uint16_t>(clientId);

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendImbuementsPanel(const std::map<slots_t, Item*> itemsToSend)
{
	if (!player || player->isRemoved()) {
		return;
	}

	NetworkMessage msg;
	msg.addByte(0x5D);
	msg.addByte(itemsToSend.size());
	for (const auto& it : itemsToSend) {
		msg.addByte(it.first);
		msg.addItem(it.second);

		ItemImbuInfo_t imbuInfo = it.second->getStaticImbuements(player->hasCondition(CONDITION_INFIGHT) && player->getZone() != ZONE_PROTECTION);

		msg.addByte(imbuInfo.slotCount);
		for (uint8_t slotId = 0; slotId < imbuInfo.slotCount; ++slotId) {
			bool found = false;
			for (const auto& imbuData : imbuInfo.imbuements) {
				if (!found && slotId == imbuData.slotId) {
					// occupied slot
					msg.addByte(0x01);
					msg.addString(imbuData.name);
					msg.add<uint16_t>(imbuData.iconId);
					msg.add<int32_t>(imbuData.duration);
					msg.addByte(imbuData.isDecaying ? 0x01 : 0x00);
					found = true;
				}
			}

			if (!found) {
				// empty slot
				msg.addByte(0x00);
			}
		}
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendModalWindow(const ModalWindow& modalWindow)
{
	NetworkMessage msg;
	msg.addByte(0xFA);

	msg.add<uint32_t>(modalWindow.id);
	msg.addString(modalWindow.title);
	msg.addString(modalWindow.message);

	msg.addByte(modalWindow.buttons.size());
	for (const auto& it : modalWindow.buttons) {
		msg.addString(it.first);
		msg.addByte(it.second);
	}

	msg.addByte(modalWindow.choices.size());
	for (const auto& it : modalWindow.choices) {
		msg.addString(it.first);
		msg.addByte(it.second);
	}

	msg.addByte(modalWindow.defaultEnterButton);
	msg.addByte(modalWindow.defaultEscapeButton);
	msg.addByte(modalWindow.priority ? 0x01 : 0x00);

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendSessionEnd(SessionEndTypes_t reason)
{
	auto output = OutputMessagePool::getOutputMessage();
	output->addByte(0x18);
	output->addByte(reason);
	send(output);
}

////////////// Add common messages
void ProtocolGame::AddCreature(NetworkMessage& msg, const Creature* creature, bool known, uint32_t remove)
{
	CreatureType_t creatureType = creature->isHealthHidden() ? CREATURETYPE_HIDDEN : creature->getType();

	// fix monster skull display in QT client
	if (player->getOperatingSystem() < CLIENTOS_OTCLIENT_LINUX) {
		if (creatureType != CREATURETYPE_HIDDEN && creature->getSkullClient(creature) != SKULL_NONE) {
			creatureType = CREATURETYPE_PLAYER;
		}
	}

	const Player* otherPlayer = creature->getPlayer();
	const Player* masterPlayer = nullptr;
	uint32_t masterId = 0;

	if (creatureType == CREATURETYPE_MONSTER) {
		const Creature* master = creature->getMaster();
		if (master) {
			masterPlayer = master->getPlayer();
			if (masterPlayer) {
				masterId = master->getID();
				creatureType = CREATURETYPE_SUMMON_OWN;
			}
		}
	}

	// override display mode
	CreatureDisplayModes_t displayMode = creature->getDisplayMode();
	if (displayMode != CREATURE_DISPLAY_MODE_NONE) {
		creatureType = static_cast<CreatureType_t>(displayMode - 1);
	}
	
	if (known) {
		msg.add<uint16_t>(0x62);
		msg.add<uint32_t>(creature->getID());
	} else {
		msg.add<uint16_t>(0x61);
		msg.add<uint32_t>(remove);
		msg.add<uint32_t>(creature->getID());
		msg.addByte(creatureType);
		if (creatureType == CREATURETYPE_SUMMON_OWN) {
			msg.add<uint32_t>(masterId);
		}

		const std::string& displayName = creature->getDisplayName();
		msg.addString(!displayName.empty() ? displayName : (creature->isHealthHidden() ? "" : creature->getName()));
	}

	if (creature->isHealthHidden()) {
		msg.addByte(0x00);
	} else {
		msg.addByte(std::ceil((static_cast<double>(creature->getHealth()) / std::max<int32_t>(creature->getMaxHealth(), 1)) * 100));
	}

	msg.addByte(creature->getDirection());

	if (!creature->isInGhostMode() && !creature->isInvisible()) {
		const Outfit_t& outfit = creature->getCurrentOutfit();
		AddOutfit(msg, outfit);
	} else {
		static Outfit_t outfit;
		AddOutfit(msg, outfit);
	}

	LightInfo lightInfo = creature->getCreatureLight();
	msg.addByte(player->isAccessPlayer() ? 0xFF : lightInfo.level);
	msg.addByte(lightInfo.color);

	msg.add<uint16_t>(creature->getStepSpeed() / 2);

	AddCreatureIcons(msg, creature);

	msg.addByte(player->getSkullClient(creature));
	msg.addByte(player->getPartyShield(creature));

	if (!known) {
		msg.addByte(player->getGuildEmblem(otherPlayer));
	}

	// Creature type and summon emblem
	msg.addByte(creatureType);
	if (creatureType == CREATURETYPE_SUMMON_OWN) {
		msg.add<uint32_t>(masterId);
	}

	// Player vocation info
	if (creatureType == CREATURETYPE_PLAYER) {
		msg.addByte(otherPlayer ? otherPlayer->getVocation()->getClientId() : 0x00);
	}

	msg.addByte(creature->getSpeechBubble());

	// (experimental) frame colors
	msg.addByte(g_events->eventPlayerOnFrameView(player, creature));

	msg.addByte(0x00); // inspection type (flags)
	msg.addByte(player->canWalkthroughEx(creature) ? 0x00 : 0x01);
}

void ProtocolGame::AddCreatureIcons(NetworkMessage& msg, const Creature* creature)
{
	size_t iconCount = 0;
	const Monster* monster = creature->getMonster();
	if (monster) {
		iconCount += monster->getMonsterIconCount();
	}

	iconCount += creature->getCreatureIconCount();

	// icon count
	msg.addByte(iconCount);

	// monster icons
	if (monster) {
		for (const auto& icon : monster->getMonsterIcons()) {
			msg.addByte(icon.first);
			msg.addByte(1);
			msg.add<uint16_t>(icon.second);
		}
	}

	// creature icons
	for (const auto& icon : creature->getCreatureIcons()) {
		msg.addByte(icon.first);
		msg.addByte(0);
		msg.add<uint16_t>(icon.second);
	}
}

void ProtocolGame::AddPlayerStats(NetworkMessage& msg)
{
	msg.addByte(0xA0);

	msg.add<uint32_t>(static_cast<uint32_t>(player->getHealth()));
	msg.add<uint32_t>(static_cast<uint32_t>(player->getMaxHealth()));

	msg.add<uint32_t>(player->hasFlag(PlayerFlag_HasInfiniteCapacity) ? 1000000 : player->getFreeCapacity());
	msg.add<uint64_t>(player->getExperience());

	msg.add<uint16_t>(std::min<uint32_t>(player->getLevel(), std::numeric_limits<uint16_t>::max()));
	msg.addByte(player->getLevelPercent());

	uint16_t stamina = player->getStaminaMinutes();
	uint32_t xpRate = std::min<uint32_t>(100 * g_config.getExperienceStage(player->getLevel()), 0xFFFF);
	msg.add<uint16_t>(static_cast<uint16_t>(xpRate)); // base xp gain rate
	msg.add<uint16_t>(0); // low level bonus
	msg.add<uint16_t>(0); // xp boost
	msg.add<uint16_t>(stamina > 2340 ? 150 : stamina < 840 ? 50 : 100); // stamina multiplier (100 = x1.0)

	msg.add<uint32_t>(static_cast<uint32_t>(player->getMana()));
	msg.add<uint32_t>(static_cast<uint32_t>(player->getMaxMana()));

	msg.addByte(player->getSoul());
	msg.add<uint16_t>(player->getStaminaMinutes());
	msg.add<uint16_t>(player->getBaseSpeed() / 2);

	Condition* condition = player->getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT);
	msg.add<uint16_t>(condition ? condition->getTicks() / 1000 : 0x00);

	msg.add<uint16_t>(player->getOfflineTrainingTime() / 60 / 1000);

	msg.add<uint16_t>(0); // xp boost time (seconds)
	msg.addByte(!player->isAccessPlayer()); // show xp boost button in skill window

	msg.add<uint32_t>(0);  // remaining mana shield
	msg.add<uint32_t>(0);  // total mana shield
}

void ProtocolGame::AddPlayerSkills(NetworkMessage& msg)
{
	msg.addByte(0xA1);
	// magic level
	msg.add<uint16_t>(player->getMagicLevel());
	msg.add<uint16_t>(player->getBaseMagicLevel());
	msg.add<uint16_t>(player->getBaseMagicLevel()); // base + loyalty bonus
	msg.add<uint16_t>(player->getMagicLevelPercent() * 100);

	// skills
	for (uint8_t i = SKILL_FIRST; i <= SKILL_LAST; ++i) {
		msg.add<uint16_t>(std::min<int32_t>(player->getSkillLevel(i), std::numeric_limits<uint16_t>::max()));
		msg.add<uint16_t>(player->getBaseSkill(i));
		msg.add<uint16_t>(player->getBaseSkill(i)); // base + loyalty bonus
		msg.add<uint16_t>(player->getSkillPercent(i) * 100);
	}

	// crit, leech
	for (uint8_t i = SPECIALSKILL_LEECH_FIRST; i <= SPECIALSKILL_LEECH_LAST; ++i) {
		int32_t skillAmount = std::max<int32_t>(0, std::min<int32_t>(std::numeric_limits<uint16_t>::max(), player->varSpecialSkills[i]));
		if (i != SPECIALSKILL_LIFELEECHAMOUNT && i != SPECIALSKILL_MANALEECHAMOUNT) {
			skillAmount = std::min<int32_t>(skillAmount, 100);
		} else {
			skillAmount *= 100;
		}

		msg.add<uint16_t>(skillAmount); // base + bonus special skill
		msg.add<uint16_t>(0); // base special skill
	}

	// get element magic levels in client-friendly format
	std::array<int16_t, COMBAT_COUNT> specMLs = {0};
	uint8_t realCount = 0;
	for (uint16_t elementId = 0; elementId < COMBAT_COUNT; ++elementId) {
		uint16_t specMagLevel = player->specialMagicLevelSkill[elementId];
		if (specMagLevel != 0) {
			specMLs[Combat::GetClientCombatByType(static_cast<CombatType_t>(1 << elementId))] = specMagLevel;
			++realCount;
		}
	}
		
	// element magic levels
	msg.addByte(realCount);
	for (uint16_t elementId = 0; elementId < COMBAT_COUNT; ++elementId) {
		if (specMLs[elementId] != 0) {
			msg.addByte(elementId);
			msg.add<int16_t>(specMLs[elementId]); // base special skill
		}
	}

	// tier bonuses
	for (uint8_t i = SPECIALSKILL_FORGE_FIRST; i <= SPECIALSKILL_FORGE_LAST; ++i) {
		int32_t skillAmount = std::max<int32_t>(0, std::min<int32_t>(std::numeric_limits<uint16_t>::max(), player->varSpecialSkills[i]));
		skillAmount = std::min<int32_t>(skillAmount, 10000);

		msg.add<uint16_t>(skillAmount); // base + bonus special skill
		msg.add<uint16_t>(0); // base special skill
	}

	// cap
	if (!player->hasFlag(PlayerFlag_HasInfiniteCapacity)) {
		msg.add<uint32_t>(player->getCapacity());
		msg.add<uint32_t>(player->getBaseCapacity());
	} else {
		msg.add<uint32_t>(1000000);
		msg.add<uint32_t>(1000000);
	}
}

void ProtocolGame::AddOutfit(NetworkMessage& msg, const Outfit_t& outfit)
{
	// outfit
	msg.add<uint16_t>(outfit.lookType);
	if (outfit.lookType != 0) {
		msg.addByte(outfit.lookHead);
		msg.addByte(outfit.lookBody);
		msg.addByte(outfit.lookLegs);
		msg.addByte(outfit.lookFeet);
		msg.addByte(outfit.lookAddons);
	} else {
		msg.addItemId(outfit.lookTypeEx);
	}

	// mount
	msg.add<uint16_t>(outfit.lookMount);
	if (outfit.lookMount != 0) {
		msg.addByte(outfit.lookMountHead);
		msg.addByte(outfit.lookMountBody);
		msg.addByte(outfit.lookMountLegs);
		msg.addByte(outfit.lookMountFeet);
	}
}

void ProtocolGame::AddWorldLight(NetworkMessage& msg, LightInfo lightInfo)
{
	msg.addByte(0x82);
	msg.addByte((player->isAccessPlayer() ? 0xFF : lightInfo.level));
	msg.addByte(lightInfo.color);
}

void ProtocolGame::AddCreatureLight(NetworkMessage& msg, const Creature* creature)
{
	LightInfo lightInfo = creature->getCreatureLight();

	msg.addByte(0x8D);
	msg.add<uint32_t>(creature->getID());
	msg.addByte((player->isAccessPlayer() ? 0xFF : lightInfo.level));
	msg.addByte(lightInfo.color);
}

//tile
void ProtocolGame::RemoveTileThing(NetworkMessage& msg, const Position& pos, uint32_t stackpos)
{
	if (stackpos >= 10) {
		return;
	}

	msg.addByte(0x6C);
	msg.addPosition(pos);
	msg.addByte(stackpos);
}

void ProtocolGame::RemoveTileCreature(NetworkMessage& msg, const Creature* creature, const Position& pos, uint32_t stackpos)
{
	if (stackpos < 10) {
		RemoveTileThing(msg, pos, stackpos);
		return;
	}

	msg.addByte(0x6C);
	msg.add<uint16_t>(0xFFFF);
	msg.add<uint32_t>(creature->getID());
}

void ProtocolGame::MoveUpCreature(NetworkMessage& msg, const Creature* creature, const Position& newPos, const Position& oldPos)
{
	if (creature != player) {
		return;
	}

	//floor change up
	msg.addByte(0xBE);

	//going to surface
	if (newPos.z == 7) {
		int32_t skip = -1;

		// floor 7 and 6 already set
		for (int i = 5; i >= 0; --i) {
			GetFloorDescription(msg, oldPos.x - Map::maxClientViewportX, oldPos.y - Map::maxClientViewportY, i, (Map::maxClientViewportX * 2) + 2, (Map::maxClientViewportY * 2) + 2, 8 - i, skip);
		}
		if (skip >= 0) {
			msg.addByte(skip);
			msg.addByte(0xFF);
		}
	}
	//underground, going one floor up (still underground)
	else if (newPos.z > 7) {
		int32_t skip = -1;
		GetFloorDescription(msg, oldPos.x - Map::maxClientViewportX, oldPos.y - Map::maxClientViewportY, oldPos.getZ() - 3, (Map::maxClientViewportX * 2) + 2, (Map::maxClientViewportY * 2) + 2, 3, skip);

		if (skip >= 0) {
			msg.addByte(skip);
			msg.addByte(0xFF);
		}
	}

	//moving up a floor up makes us out of sync
	//west
	msg.addByte(0x68);
	GetMapDescription(oldPos.x - Map::maxClientViewportX, oldPos.y - (Map::maxClientViewportY - 1), newPos.z, 1, (Map::maxClientViewportY * 2) + 2, msg);

	//north
	msg.addByte(0x65);
	GetMapDescription(oldPos.x - Map::maxClientViewportX, oldPos.y - Map::maxClientViewportY, newPos.z, (Map::maxClientViewportX * 2) + 2, 1, msg);
}

void ProtocolGame::MoveDownCreature(NetworkMessage& msg, const Creature* creature, const Position& newPos, const Position& oldPos)
{
	if (creature != player) {
		return;
	}

	//floor change down
	msg.addByte(0xBF);

	//going from surface to underground
	if (newPos.z == 8) {
		int32_t skip = -1;

		for (int i = 0; i < 3; ++i) {
			GetFloorDescription(msg, oldPos.x - Map::maxClientViewportX, oldPos.y - Map::maxClientViewportY, newPos.z + i, (Map::maxClientViewportX * 2) + 2, (Map::maxClientViewportY * 2) + 2, -i - 1, skip);
		}
		if (skip >= 0) {
			msg.addByte(skip);
			msg.addByte(0xFF);
		}
	}
	//going further down
	else if (newPos.z > oldPos.z && newPos.z > 8 && newPos.z < 14) {
		int32_t skip = -1;
		GetFloorDescription(msg, oldPos.x - Map::maxClientViewportX, oldPos.y - Map::maxClientViewportY, newPos.z + 2, (Map::maxClientViewportX * 2) + 2, (Map::maxClientViewportY * 2) + 2, -3, skip);

		if (skip >= 0) {
			msg.addByte(skip);
			msg.addByte(0xFF);
		}
	}

	//moving down a floor makes us out of sync
	//east
	msg.addByte(0x66);
	GetMapDescription(oldPos.x + (Map::maxClientViewportX + 1), oldPos.y - (Map::maxClientViewportY + 1), newPos.z, 1, (Map::maxClientViewportY * 2) + 2, msg);

	//south
	msg.addByte(0x67);
	GetMapDescription(oldPos.x - Map::maxClientViewportX, oldPos.y + (Map::maxClientViewportY + 1), newPos.z, (Map::maxClientViewportX * 2) + 2, 1, msg);
}

void ProtocolGame::AddShopItem(NetworkMessage& msg, const ShopInfo& item)
{
	const ItemType& it = Item::items[item.itemId];
	msg.add<uint16_t>(it.clientId);

	if (it.isSplash() || it.isFluidContainer()) {
		msg.addByte(serverFluidToClient(item.subType));
	} else {
		msg.addByte(0x00);
	}

	msg.addString(item.realName);
	msg.add<uint32_t>(it.weight);
	msg.add<uint32_t>(item.buyPrice);
	msg.add<uint32_t>(item.sellPrice);
}

void ProtocolGame::AddPlayerOutfits(NetworkMessage& msg)
{
	// get player outfits
	const auto& outfits = Outfits::getInstance().getOutfits(player->getSex());
	if (outfits.size() == 0) {
		msg.add<uint16_t>(0);
		return;
	}
	
	// add GM outfit
	std::vector<ProtocolOutfit> protocolOutfits;
	if (player->isAccessPlayer()) {
		static const std::string gamemasterOutfitName = "Gamemaster";
		protocolOutfits.emplace_back(gamemasterOutfitName, 75, 0, OUTFIT_TOOLTIP_NONE, 0);
	}

	// get other available outfits
	protocolOutfits.reserve(outfits.size());
	for (const Outfit& outfit : outfits) {
		uint8_t addons;
		if (!player->getOutfitAddons(outfit, addons)) {
			if (outfit.offerId != 0) {
				protocolOutfits.emplace_back(outfit.name, outfit.lookType, 3, OUTFIT_TOOLTIP_STORE, outfit.offerId);
			} else if (outfit.tooltip != OUTFIT_TOOLTIP_NONE) {
				protocolOutfits.emplace_back(outfit.name, outfit.lookType, 3, outfit.tooltip, 0);
			}
			continue;
		}

		protocolOutfits.emplace_back(outfit.name, outfit.lookType, addons, OUTFIT_TOOLTIP_NONE, 0);
	}

	// add available outfits
	msg.add<uint16_t>(protocolOutfits.size());
	for (const ProtocolOutfit& outfit : protocolOutfits) {
		msg.add<uint16_t>(outfit.lookType);
		msg.addString(outfit.name);
		msg.addByte(outfit.addons);
		msg.addByte(outfit.tooltip);
		if (outfit.tooltip == OUTFIT_TOOLTIP_STORE) {
			msg.add<uint32_t>(outfit.offerId);
		}
	}
}

void ProtocolGame::AddPlayerMounts(NetworkMessage& msg)
{
	// get available mounts
	std::vector<const Mount*> mounts;
	std::vector<const Mount*> storeMounts;
	for (const Mount& mount : g_game.mounts.getMounts()) {
		if (player->hasMount(&mount)) {
			mounts.push_back(&mount);
		} else if(mount.offerId != 0) {
			storeMounts.push_back(&mount);
		}
	}

	// add available mounts
	msg.add<uint16_t>(mounts.size() + storeMounts.size());
	for (const Mount* mount : mounts) {
		msg.add<uint16_t>(mount->clientId);
		msg.addString(mount->name);
		msg.addByte(0x00); // mode: 0x00 - available, 0x01 store (requires U32 store offerId)
	}

	// add store mounts
	for (const Mount* mount : storeMounts) {
		msg.add<uint16_t>(mount->clientId);
		msg.addString(mount->name);
		msg.addByte(0x01);
		msg.add<uint32_t>(mount->offerId);
	}
}

void ProtocolGame::AddPlayerFamiliars(NetworkMessage& msg)
{
	// get available familiars
	std::vector<const Familiar*> familiars;
	for (const Familiar& familiar : g_game.familiars.getFamiliars()) {
		if (player->canUseFamiliar(&familiar)) {
			familiars.push_back(&familiar);
		}
	}
	
	// add available familiars
	msg.add<uint16_t>(familiars.size());
	for (const Familiar* familiar : familiars) {
		msg.add<uint16_t>(familiar->clientId);
		msg.addString(familiar->name);
		msg.addByte(0x00); // mode: 0x00 - available, 0x01 store (requires U32 store offerId)
	}
}

void ProtocolGame::parseExtendedOpcode(NetworkMessage& msg)
{
	uint8_t opcode = msg.getByte();
	std::string buffer = msg.getString();

	// process additional opcodes via lua script event
	addGameTask(([=, playerID = player->getID(), buffer = std::move(buffer)]() { g_game.parsePlayerExtendedOpcode(playerID, opcode, buffer); }));
}
