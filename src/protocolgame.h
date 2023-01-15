// Copyright 2022 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#ifndef FS_PROTOCOLGAME_H
#define FS_PROTOCOLGAME_H

#include "chat.h"
#include "creature.h"
#include "definitions.h"
#include "protocol.h"
#include "tasks.h"

class Container;
class Game;
class NetworkMessage;
class Player;
class ProtocolGame;
class Quest;
class Tile;
class TrackedQuest;

enum SessionEndTypes_t : uint8_t {
	SESSION_END_LOGOUT = 0,
	SESSION_END_UNKNOWN = 1, // unknown, no difference from logout
	SESSION_END_FORCECLOSE = 2,
	SESSION_END_UNKNOWN2 = 3, // unknown, no difference from logout
	SESSION_END_UNKNOWN3 = 4 // unknown
};

using ProtocolGame_ptr = std::shared_ptr<ProtocolGame>;

extern Game g_game;

struct TextMessage
{
	MessageClasses type = MESSAGE_STATUS_DEFAULT;
	std::string text;
	Position position;
	uint16_t channelId;
	struct {
		int32_t value = 0;
		TextColor_t color;
	} primary, secondary;

	TextMessage() = default;
	TextMessage(MessageClasses type, std::string text) : type(type), text(std::move(text)) {}
};

class ProtocolGame final : public Protocol
{
	public:
		// static protocol information
		enum {server_sends_first = true};
		enum {protocol_identifier = 0}; // Not required as we send first
		enum {use_checksum = true};
		static const char* protocol_name() {
			return "gameworld protocol";
		}

		explicit ProtocolGame(Connection_ptr connection) : Protocol(connection) {}

		void login(const std::string& name, uint32_t accountId, OperatingSystem_t operatingSystem);
		void logout(bool displayEffect, bool forced, const std::string& message = std::string());
		void fastRelog(const std::string& otherPlayerName);
		void sendRelogCancel(const std::string& msg, bool isRelog);

		uint16_t getVersion() const {
			return version;
		}

	private:
		ProtocolGame_ptr getThis() {
			return std::static_pointer_cast<ProtocolGame>(shared_from_this());
		}
		void connect(uint32_t playerId, OperatingSystem_t operatingSystem);
		void disconnectClient(const std::string& message) const;
		void writeToOutputBuffer(const NetworkMessage& msg);

		void release() override;

		void checkCreatureAsKnown(uint32_t id, bool& known, uint32_t& removedKnown);

		bool canSee(int32_t x, int32_t y, int32_t z) const;
		bool canSee(const Creature*) const;
		bool canSee(const Position& pos) const;

		void parsePacket(NetworkMessage& msg) override;
		void onRecvFirstMessage(NetworkMessage& msg) override;
		void onConnect() override;

		// Parse methods

		// Bestiary
		void parseBestiaryCategory(NetworkMessage& msg);
		void parseBestiaryCreature(NetworkMessage& msg);

		// Channel tabs
		void parseChannelInvite(NetworkMessage& msg);
		void parseChannelExclude(NetworkMessage& msg);
		void parseOpenChannel(NetworkMessage& msg);
		void parseOpenPrivateChannel(NetworkMessage& msg);
		void parseCloseChannel(NetworkMessage& msg);
		void parseSaveGuildMotd(NetworkMessage& msg);

		// Containers
		void parseCloseContainer(NetworkMessage& msg);
		void parseUpArrowContainer(NetworkMessage& msg);
		void parseUpdateContainer(NetworkMessage& msg);
		void parseBrowseField(NetworkMessage& msg);
		void parseSeekInContainer(NetworkMessage& msg);

		// Exaltation forge
		void parseForgeAction(NetworkMessage& msg);
		void parseForgeBrowseHistory(NetworkMessage& msg);

		// Imbuing
		void parseImbuingApply(NetworkMessage& msg);
		void parseImbuementPanel(NetworkMessage& msg);

		// Items
		void parseEquipObject(NetworkMessage& msg);
		void parseThrow(NetworkMessage& msg);
		void parseUseItemEx(NetworkMessage& msg);
		void parseUseWithCreature(NetworkMessage& msg);
		void parseUseItem(NetworkMessage& msg);
		void parseWrapItem(NetworkMessage& msg);
		void parseRotateItem(NetworkMessage& msg);
		void parseInspectItem(NetworkMessage& msg);

		// Market
		void parseMarketLeave();
		void parseMarketBrowse(NetworkMessage& msg);
		void parseMarketCreateOffer(NetworkMessage& msg);
		void parseMarketCancelOffer(NetworkMessage& msg);
		void parseMarketAcceptOffer(NetworkMessage& msg);

		// Outfits
		void parseRequestOutfit(NetworkMessage& msg);
		void parseSetOutfit(NetworkMessage& msg);
		void parseToggleMount(NetworkMessage& msg);
		void parseEditPodiumRequest(NetworkMessage& msg);

		// Party
		void parseInviteToParty(NetworkMessage& msg);
		void parseJoinParty(NetworkMessage& msg);
		void parseRevokePartyInvite(NetworkMessage& msg);
		void parsePassPartyLeadership(NetworkMessage& msg);
		void parseEnableSharedPartyExperience(NetworkMessage& msg);

		// Quests
		void parseQuestLine(NetworkMessage& msg);
		void parseQuestTracker(NetworkMessage& msg);

		// Quick loot
		void parseQuickLoot(NetworkMessage& msg);
		void parseSelectLootContainer(NetworkMessage& msg);
		void parseQuickLootList(NetworkMessage& msg);

		// Reporting
		void parseBugReport(NetworkMessage& msg);
		void parseDebugAssert(NetworkMessage& msg);
		void parseRuleViolationReport(NetworkMessage& msg);

		// Store
		void parseNameChange(NetworkMessage& msg);
		void parseStoreBrowse(NetworkMessage& msg);
		void parseStoreBuy(NetworkMessage& msg);
		void parseStoreHistoryBrowse(NetworkMessage& msg, uint8_t recvbyte);

		// Trade (with players)
		void parseRequestTrade(NetworkMessage& msg);
		void parseLookInTrade(NetworkMessage& msg);

		// Trade (with NPC)
		void parseLookInShop(NetworkMessage& msg);
		void parsePlayerPurchase(NetworkMessage& msg);
		void parsePlayerSale(NetworkMessage& msg);

		// UI (other)
		void parseTextWindow(NetworkMessage& msg);
		void parseHouseWindow(NetworkMessage& msg);
		void parseModalWindowAnswer(NetworkMessage& msg);
		void parseCyclopediaViewPlayerInfo(NetworkMessage& msg);

		// VIP list
		void parseAddVip(NetworkMessage& msg);
		void parseRemoveVip(NetworkMessage& msg);
		void parseEditVip(NetworkMessage& msg);

		// other
		void parsePlayerMinimapQuery(NetworkMessage& msg);
		void parseSay(NetworkMessage& msg);
		void parseLookAt(NetworkMessage& msg);
		void parseLookInBattleList(NetworkMessage& msg);
		void parseFightModes(NetworkMessage& msg);
		void parseAttack(NetworkMessage& msg);
		void parseFollow(NetworkMessage& msg);
		void parseAutoWalk(NetworkMessage& msg);


		// Send functions
		void sendChannelMessage(const std::string& author, const std::string& text, MessageClasses type, uint16_t channel);
		void sendChannelEvent(uint16_t channelId, const std::string& playerName, ChannelEvent_t channelEvent);
		void sendClosePrivate(uint16_t channelId);
		void sendChannelsDialog();
		void sendChannel(uint16_t channelId, const std::string& channelName, const UsersMap* channelUsers, const InvitedMap* invitedUsers, bool ownChannel);
		void sendOpenPrivateChannel(const std::string& receiver);
		void sendToChannel(const Creature* creature, MessageClasses type, const std::string& text, uint16_t channelId);
		void sendPrivateMessage(const Player* speaker, MessageClasses type, const std::string& text);
		void sendNamedPrivateMessage(const std::string& speaker, MessageClasses type, const std::string& text);
		void sendIcons(uint32_t icons);
		void sendFYIBox(const std::string& message);
		void sendGuildMotdEditDialog(const std::string& currentMotd);

		void sendDistanceShoot(const Position& from, const Position& to, uint8_t type);
		void sendMagicEffect(const Position& pos, uint8_t type);
		void sendCreatureHealth(const Creature* creature);
		void sendSkills();
		void sendBlessings();
		void sendPing();
		void sendPingBack();
		void sendCreatureTurn(const Creature* creature, uint32_t stackPos);
		void sendCreatureSay(const Creature* creature, MessageClasses type, const std::string& text, const Position* pos = nullptr);

		void sendQuestLog();
		void sendQuestLine(const Quest* quest);
		void sendQuestTracker();
		void sendUpdateQuestTracker(const TrackedQuest& trackedQuest);

		void sendCancelWalk();
		void sendChangeSpeed(const Creature* creature, uint32_t speed);
		void sendCancelTarget();
		void sendCreatureOutfit(const Creature* creature, const Outfit_t& outfit);
		void sendStats();
		void sendExperienceTracker(int64_t rawExp, int64_t finalExp);
		void sendClientFeatures();
		void sendBasicData();
		void sendTextMessage(const TextMessage& message);
		void sendReLoginWindow(uint8_t unfairFightReduction);

		void sendTutorial(uint8_t tutorialId);
		void sendAddMarker(const Position& pos, uint8_t markType, const std::string& desc);

		void sendCreatureWalkthrough(const Creature* creature, bool walkthrough);
		void sendCreatureShield(const Creature* creature);
		void sendCreatureSkull(const Creature* creature);

		void sendShop(Npc* npc, const ShopInfoList& itemList);
		void sendCloseShop();
		void sendSaleItemList(const std::list<ShopInfo>& shop);
		void sendResourceBalance(const ResourceTypes_t resourceType, uint64_t amount);
		void sendStoreBalance();
		void sendMarketEnter();
		void sendMarketLeave();
		void sendMarketBrowseItem(uint16_t itemId, const MarketOfferList& buyOffers, const MarketOfferList& sellOffers, uint8_t tier);
		void sendMarketAcceptOffer(const MarketOfferEx& offer);
		void sendMarketBrowseOwnOffers(const MarketOfferList& buyOffers, const MarketOfferList& sellOffers);
		void sendMarketCancelOffer(const MarketOfferEx& offer);
		void sendMarketBrowseOwnHistory(const HistoryMarketOfferList& buyOffers, const HistoryMarketOfferList& sellOffers);
		void sendTradeItemRequest(const std::string& traderName, const Item* item, bool ack);
		void sendCloseTrade();

		void sendTextWindow(uint32_t windowTextId, Item* item, uint16_t maxlen, bool canWrite);
		void sendTextWindow(uint32_t windowTextId, uint32_t itemId, const std::string& text);
		void sendHouseWindow(uint32_t windowTextId, const std::string& text);

		void sendOutfitWindow(uint16_t tryOutfitType = 0, uint16_t tryMountType = 0);
		void sendPodiumWindow(const Item* item);

		void sendUpdatedVIPStatus(uint32_t guid, VipStatus_t newStatus);
		void sendVIP(uint32_t guid, const std::string& name, const std::string& description, uint32_t icon, bool notify, VipStatus_t status);
		void sendVIPEntries();

		void sendPendingStateEntered();
		void sendEnterWorld();

		void sendFightModes();

		void sendCreatureLight(const Creature* creature);
		void sendWorldLight(LightInfo lightInfo);
		void sendWorldTime();

		void sendCreatureSquare(const Creature* creature, SquareColor_t color);

		void sendSpellCooldown(uint8_t spellId, uint32_t time);
		void sendSpellGroupCooldown(SpellGroup_t groupId, uint32_t time);
		void sendUseItemCooldown(uint32_t time);
		void sendSupplyUsed(const uint16_t clientId);
		void sendImbuementsPanel(const std::map<slots_t, Item*> itemsToSend);

		//tiles
		void sendMapDescription(const Position& pos);

		void sendAddTileItem(const Position& pos, uint32_t stackpos, const Item* item);
		void sendUpdateTileItem(const Position& pos, uint32_t stackpos, const Item* item);
		void sendRemoveTileThing(const Position& pos, uint32_t stackpos);
		void forgetCreatureID(uint32_t creatureId) {
			knownCreatureMap.erase(creatureId);
		}
		void sendUpdateTileCreature(const Position& pos, uint32_t stackpos, const Creature* creature);
		void sendRemoveTileCreature(const Creature* creature, const Position& pos, uint32_t stackpos);
		void sendUpdateTile(const Tile* tile, const Position& pos);
		void sendUpdateCreatureIcons(const Creature* creature);

		void sendAddCreature(const Creature* creature, const Position& pos, int32_t stackpos, MagicEffectClasses magicEffect = CONST_ME_NONE);
		void sendMoveCreature(const Creature* creature, const Position& newPos, int32_t newStackPos,
		                      const Position& oldPos, int32_t oldStackPos, bool teleport);

		//containers
		void sendAddContainerItem(uint8_t cid, uint16_t slot, const Item* item);
		void sendUpdateContainerItem(uint8_t cid, uint16_t slot, const Item* item);
		void sendRemoveContainerItem(uint8_t cid, uint16_t slot, const Item* lastItem);

		void sendContainer(uint8_t cid, const Container* container, bool hasParent, uint16_t firstIndex);
		void sendEmptyContainer(uint8_t cid);
		void sendCloseContainer(uint8_t cid);

		//inventory
		void sendInventoryItem(slots_t slot, const Item* item);
		void sendItems();

		//messages
		void sendModalWindow(const ModalWindow& modalWindow);

		//session end
		void sendSessionEnd(SessionEndTypes_t reason);

		//Help functions

		// translate a tile to client-readable format
		void GetTileDescription(const Tile* tile, NetworkMessage& msg);

		// translate a floor to client-readable format
		void GetFloorDescription(NetworkMessage& msg, int32_t x, int32_t y, int32_t z,
		                         int32_t width, int32_t height, int32_t offset, int32_t& skip);

		// translate a map area to client-readable format
		void GetMapDescription(int32_t x, int32_t y, int32_t z,
		                       int32_t width, int32_t height, NetworkMessage& msg);

		void AddCreature(NetworkMessage& msg, const Creature* creature, bool known, uint32_t remove);
		void AddCreatureIcons(NetworkMessage& msg, const Creature* creature);
		void AddPlayerStats(NetworkMessage& msg);
		void AddOutfit(NetworkMessage& msg, const Outfit_t& outfit);
		void AddPlayerSkills(NetworkMessage& msg);
		void AddWorldLight(NetworkMessage& msg, LightInfo lightInfo);
		void AddCreatureLight(NetworkMessage& msg, const Creature* creature);

		//tiles
		static void RemoveTileThing(NetworkMessage& msg, const Position& pos, uint32_t stackpos);
		static void RemoveTileCreature(NetworkMessage& msg, const Creature* creature, const Position& pos, uint32_t stackpos);

		void MoveUpCreature(NetworkMessage& msg, const Creature* creature, const Position& newPos, const Position& oldPos);
		void MoveDownCreature(NetworkMessage& msg, const Creature* creature, const Position& newPos, const Position& oldPos);

		//shop
		void AddShopItem(NetworkMessage& msg, const ShopInfo& item);

		//outfit window
		void AddPlayerOutfits(NetworkMessage& msg);
		void AddPlayerMounts(NetworkMessage& msg);
		void AddPlayerFamiliars(NetworkMessage& msg);

		//otclient
		void parseExtendedOpcode(NetworkMessage& msg);

		friend class Player;

		// Helpers so we don't need to bind every time
		template <typename Callable>
		void addNewGameTask(Callable&& function, const std::string& function_str, const std::string& extra_info) {
			g_dispatcher.addTask(createNewTask(std::forward<Callable>(function), function_str, extra_info));
		}

		template <typename Callable>
		void addNewGameTaskTimed(uint32_t delay, Callable&& function, const std::string& function_str, const std::string& extra_info) {
			g_dispatcher.addTask(createNewTask(delay, std::forward<Callable>(function), function_str, extra_info));
		}

		std::unordered_map<uint32_t, int64_t> knownCreatureMap;
		Player* player = nullptr;

		uint32_t eventConnect = 0;
		uint32_t challengeTimestamp = 0;
		uint16_t version = CLIENT_VERSION_MIN;

		uint8_t challengeRandom = 0;

		bool debugAssertSent = false;
		bool acceptPackets = false;

		// player data which is still needed after player object destruction
		std::vector<uint32_t> savedChannels;
		uint32_t lastPartyId = 0;
		std::string lastName;
		uint32_t lastAccountId = 0;
		OperatingSystem_t lastOperatingSystem = CLIENTOS_NONE;
		int64_t lastDeathTime = 0;
};

#endif
