// Copyright 2022 Xynera.net. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "luascript.h"

#include "configmanager.h"
#include "events.h"
#include "iologindata.h"
#include "monster.h"
#include "game.h"
#include "item.h"
#include "npc.h"
#include "outfit.h"
#include "script.h"
#include "spectators.h"
#include "spells.h"

extern ConfigManager g_config;
extern Events* g_events;
extern Monsters g_monsters;
extern Scripts* g_scripts;
extern Spells* g_spells;
extern Vocations g_vocations;

extern LuaEnvironment g_luaEnvironment;

// Game
int LuaScriptInterface::luaGameGetSpectators(lua_State* L)
{
	// Game.getSpectators(position[, multifloor = false[, onlyPlayer = false[, minRangeX = 0[, maxRangeX = 0[, minRangeY = 0[, maxRangeY = 0]]]]]])
	const Position& position = getPosition(L, 1);
	bool multifloor = getBoolean(L, 2, false);
	bool onlyPlayers = getBoolean(L, 3, false);
	int32_t minRangeX = getNumber<int32_t>(L, 4, 0);
	int32_t maxRangeX = getNumber<int32_t>(L, 5, 0);
	int32_t minRangeY = getNumber<int32_t>(L, 6, 0);
	int32_t maxRangeY = getNumber<int32_t>(L, 7, 0);

	SpectatorVec spectators;
	g_game.map.getSpectators(spectators, position, multifloor, onlyPlayers, minRangeX, maxRangeX, minRangeY, maxRangeY);

	lua_createtable(L, spectators.size(), 0);

	int index = 0;
	for (Creature* creature : spectators) {
		pushUserdata<Creature>(L, creature);
		setCreatureMetatable(L, -1, creature);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaGameGetPlayers(lua_State* L)
{
	// Game.getPlayers()
	lua_createtable(L, g_game.getPlayersOnline(), 0);

	int index = 0;
	for (const auto& playerEntry : g_game.getPlayers()) {
		pushUserdata<Player>(L, playerEntry.second);
		setMetatable(L, -1, "Player");
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaGameGetMonsterIds(lua_State* L)
{
	// Game.getMonsterIds()
	lua_createtable(L, g_game.getMonstersOnline(), 0);

	int index = 0;
	for (const auto& monsterEntry : g_game.getMonsters()) {
		lua_pushnumber(L, monsterEntry.second->getID());
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaGameLoadMap(lua_State* L)
{
	// Game.loadMap(path)
	const std::string& path = getString(L, 1);
	g_dispatcher.addTask(createTask([path]() {
		try {
			g_game.loadMap(path);
		}
		catch (const std::exception& e) {
			// FIXME: Should only catch some exceptions
			console::reportFileError("LuaScriptInterface::luaGameLoadMap", "map", e.what());
		}
		}));
	return 0;
}

int LuaScriptInterface::luaGameGetExperienceStage(lua_State* L)
{
	// Game.getExperienceStage(level)
	uint32_t level = getNumber<uint32_t>(L, 1);
	lua_pushnumber(L, g_config.getExperienceStage(level));
	return 1;
}

int LuaScriptInterface::luaGameGetExperienceStages(lua_State* L)
{
	// Game.getExperienceStages()
	const ExperienceStages expStages = g_config.getExperienceStages();

	int index = 0;
	lua_createtable(L, expStages.size(), 0);
	for (auto const& value : expStages) {
		lua_createtable(L, 0, 3);

		setField(L, "minlevel", std::get<0>(value));
		setField(L, "maxlevel", std::get<1>(value));
		setField(L, "multiplier", std::get<2>(value));
		lua_rawseti(L, -2, ++index);
	}

	return 1;
}

int LuaScriptInterface::luaGameGetExperienceForLevel(lua_State* L)
{
	// Game.getExperienceForLevel(level)
	const uint32_t level = getNumber<uint32_t>(L, 1);
	if (level == 0) {
		lua_pushnumber(L, 0);
	} else {
		lua_pushnumber(L, Player::getExpForLevel(level));
	}
	return 1;
}

int LuaScriptInterface::luaGameGetMonsterCount(lua_State* L)
{
	// Game.getMonsterCount()
	lua_pushnumber(L, g_game.getMonstersOnline());
	return 1;
}

int LuaScriptInterface::luaGameGetPlayerCount(lua_State* L)
{
	// Game.getPlayerCount()
	lua_pushnumber(L, g_game.getPlayersOnline());
	return 1;
}

int LuaScriptInterface::luaGameGetNpcCount(lua_State* L)
{
	// Game.getNpcCount()
	lua_pushnumber(L, g_game.getNpcsOnline());
	return 1;
}

int LuaScriptInterface::luaGameGetDepotBoxCount(lua_State* L)
{
	// Game.getDepotBoxCount()
	lua_pushnumber(L, getDepotBoxCount());
	return 1;
}

int LuaScriptInterface::luaGameGetMonsterTypes(lua_State* L)
{
	// Game.getMonsterTypes()
	auto& type = g_monsters.monsters;
	lua_createtable(L, type.size(), 0);

	for (auto& mType : type) {
		pushUserdata<MonsterType>(L, &mType.second);
		setMetatable(L, -1, "MonsterType");
		lua_setfield(L, -2, mType.first.c_str());
	}
	return 1;
}

int LuaScriptInterface::luaGameGetMountIdByLookType(lua_State* L)
{
	// Game.getMountIdByLookType(lookType)
	Mount* mount = nullptr;
	if (isNumber(L, 1)) {
		mount = g_game.mounts.getMountByClientID(getNumber<uint16_t>(L, 1));
	}

	if (mount) {
		lua_pushnumber(L, mount->id);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGameGetItemTypeByClientId(lua_State* L)
{
	// Game.getItemTypeByClientId(clientId)
	uint16_t spriteId = getNumber<uint16_t>(L, 1);
	const ItemType& itemType = Item::items.getItemIdByClientId(spriteId);
	if (itemType.id != 0) {
		pushUserdata<const ItemType>(L, &itemType);
		setMetatable(L, -1, "ItemType");
	} else {
		lua_pushnil(L);
	}

	return 1;
}

int LuaScriptInterface::luaGameGetCurrencyItems(lua_State* L)
{
	// Game.getCurrencyItems()
	const auto& currencyItems = Item::items.currencyItems;
	size_t size = currencyItems.size();
	lua_createtable(L, size, 0);

	for (const auto& it : currencyItems) {
		const ItemType& itemType = Item::items[it.second];
		pushUserdata<const ItemType>(L, &itemType);
		setMetatable(L, -1, "ItemType");
		lua_rawseti(L, -2, size--);
	}
	return 1;
}

int LuaScriptInterface::luaGameGetTowns(lua_State* L)
{
	// Game.getTowns()
	const auto& towns = g_game.map.towns.getTowns();
	lua_createtable(L, towns.size(), 0);

	int index = 0;
	for (auto townEntry : towns) {
		pushUserdata<Town>(L, townEntry.second);
		setMetatable(L, -1, "Town");
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaGameGetHouses(lua_State* L)
{
	// Game.getHouses()
	const auto& houses = g_game.map.houses.getHouses();
	lua_createtable(L, houses.size(), 0);

	int index = 0;
	for (auto houseEntry : houses) {
		pushUserdata<House>(L, houseEntry.second);
		setMetatable(L, -1, "House");
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaGameGetOutfits(lua_State* L)
{
	// Game.getOutfits(playerSex)
	if (!isNumber(L, 1)) {
		lua_pushnil(L);
		return 1;
	}

	PlayerSex_t playerSex = getNumber<PlayerSex_t>(L, 1);
	if (playerSex > PLAYERSEX_LAST) {
		lua_pushnil(L);
		return 1;
	}

	const auto& outfits = Outfits::getInstance().getOutfits(playerSex);
	lua_createtable(L, outfits.size(), 0);

	int index = 0;
	for (auto& outfit : outfits) {
		pushOutfit(L, &outfit);
		lua_rawseti(L, -2, ++index);
	}

	return 1;
}

int LuaScriptInterface::luaGameGetMounts(lua_State* L)
{
	// Game.getMounts()
	const auto& mounts = g_game.mounts.getMounts();
	lua_createtable(L, mounts.size(), 0);

	int index = 0;
	for (auto& mount : mounts) {
		pushMount(L, &mount);
		lua_rawseti(L, -2, ++index);
	}

	return 1;
}

int LuaScriptInterface::luaGameGetFamiliars(lua_State* L)
{
	// Game.getFamiliars()
	const auto& familiars = g_game.familiars.getFamiliars();
	lua_createtable(L, familiars.size(), 0);

	int index = 0;
	for (auto& familiar : familiars) {
		pushFamiliar(L, &familiar);
		lua_rawseti(L, -2, ++index);
	}

	return 1;
}

int LuaScriptInterface::luaGameGetFamiliarById(lua_State* L)
{
	// Game.getFamiliarById(id)
	uint8_t familiarId = getNumber<uint8_t>(L, 1);
	Familiar* familiar = g_game.familiars.getFamiliarByID(familiarId);
	if (familiar) {
		pushFamiliar(L, familiar);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGameGetInstantSpells(lua_State* L)
{
	// Game.getInstantSpells()
	std::vector<const InstantSpell*> spells;
	for (auto& spell : g_spells->getInstantSpells()) {
		spells.push_back(&spell.second);
	}

	lua_createtable(L, spells.size(), 0);

	int index = 0;
	for (auto spell : spells) {
		pushInstantSpell(L, *spell);
		lua_rawseti(L, -2, ++index);
	}

	return 1;
}

int LuaScriptInterface::luaGameGetRuneSpells(lua_State* L)
{
	// Game.getRuneSpells()
	std::vector<const RuneSpell*> spells;
	for (auto& spell : g_spells->getRuneSpells()) {
		spells.push_back(&spell.second);
	}

	lua_createtable(L, spells.size(), 0);

	int index = 0;
	for (auto spell : spells) {
		pushRuneSpell(L, *spell);
		lua_rawseti(L, -2, ++index);
	}

	return 1;
}

int LuaScriptInterface::luaGameGetVocations(lua_State* L)
{
	// Game.getVocations()
	auto& vocMap = g_vocations.getVocations();
	lua_createtable(L, vocMap.size(), 0);

	int index = 0;
	for (auto& vocEntry : vocMap) {
		pushUserdata<Vocation>(L, &vocEntry.second);
		setMetatable(L, -1, "Vocation");
		lua_rawseti(L, -2, index++); //lets index from 0 for key parity with voc id
	}

	return 1;
}

int LuaScriptInterface::luaGameGetGameState(lua_State* L)
{
	// Game.getGameState()
	lua_pushnumber(L, g_game.getGameState());
	return 1;
}

int LuaScriptInterface::luaGameSetGameState(lua_State* L)
{
	// Game.setGameState(state)
	GameState_t state = getNumber<GameState_t>(L, 1);
	g_game.setGameState(state);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaGameGetWorldType(lua_State* L)
{
	// Game.getWorldType()
	lua_pushnumber(L, g_game.getWorldType());
	return 1;
}

int LuaScriptInterface::luaGameSetWorldType(lua_State* L)
{
	// Game.setWorldType(type)
	WorldType_t type = getNumber<WorldType_t>(L, 1);
	g_game.setWorldType(type);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaGameGetReturnMessage(lua_State* L)
{
	// Game.getReturnMessage(value)
	ReturnValue value = getNumber<ReturnValue>(L, 1);
	pushString(L, getReturnMessage(value));
	return 1;
}

int LuaScriptInterface::luaGameGetItemAttributeByName(lua_State* L)
{
	// Game.getItemAttributeByName(name)
	lua_pushnumber(L, stringToItemAttribute(getString(L, 1)));
	return 1;
}

int LuaScriptInterface::luaGameCreateItem(lua_State* L)
{
	// Game.createItem(itemId[, count[, position]])
	uint16_t count = getNumber<uint16_t>(L, 2, 1);
	uint16_t id;
	if (isNumber(L, 1)) {
		id = getNumber<uint16_t>(L, 1);
	} else {
		id = Item::items.getItemIdByName(getString(L, 1));
		if (id == 0) {
			lua_pushnil(L);
			return 1;
		}
	}

	const ItemType& it = Item::items[id];
	if (it.stackable) {
		count = std::min<uint16_t>(count, 100);
	}

	Item* item = Item::CreateItem(id, count);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	if (lua_gettop(L) >= 3) {
		const Position& position = getPosition(L, 3);
		Tile* tile = g_game.map.getTile(position);
		if (!tile) {
			delete item;
			lua_pushnil(L);
			return 1;
		}

		g_game.internalAddItem(tile, item, INDEX_WHEREEVER, FLAG_NOLIMIT);
	} else {
		getScriptEnv()->addTempItem(item);
		item->setParent(VirtualCylinder::virtualCylinder);
	}

	pushUserdata<Item>(L, item);
	setItemMetatable(L, -1, item);
	return 1;
}

int LuaScriptInterface::luaGameCreateContainer(lua_State* L)
{
	// Game.createContainer(itemId, size[, position])
	uint16_t size = getNumber<uint16_t>(L, 2);
	uint16_t id;
	if (isNumber(L, 1)) {
		id = getNumber<uint16_t>(L, 1);
	} else {
		id = Item::items.getItemIdByName(getString(L, 1));
		if (id == 0) {
			lua_pushnil(L);
			return 1;
		}
	}

	Container* container = Item::CreateItemAsContainer(id, size);
	if (!container) {
		lua_pushnil(L);
		return 1;
	}

	if (lua_gettop(L) >= 3) {
		const Position& position = getPosition(L, 3);
		Tile* tile = g_game.map.getTile(position);
		if (!tile) {
			delete container;
			lua_pushnil(L);
			return 1;
		}

		g_game.internalAddItem(tile, container, INDEX_WHEREEVER, FLAG_NOLIMIT);
	} else {
		getScriptEnv()->addTempItem(container);
		container->setParent(VirtualCylinder::virtualCylinder);
	}

	pushUserdata<Container>(L, container);
	setMetatable(L, -1, "Container");
	return 1;
}

int LuaScriptInterface::luaGameCreateMonster(lua_State* L)
{
	// Game.createMonster(monsterName, position[, extended = false[, force = false[, magicEffect = CONST_ME_TELEPORT]]])
	Monster* monster = Monster::createMonster(getString(L, 1));
	if (!monster) {
		lua_pushnil(L);
		return 1;
	}

	const Position& position = getPosition(L, 2);
	bool extended = getBoolean(L, 3, false);
	bool force = getBoolean(L, 4, false);
	MagicEffectClasses magicEffect = getNumber<MagicEffectClasses>(L, 5, CONST_ME_TELEPORT);

	if (g_events->eventMonsterOnSpawn(monster, position, false, true) || force) {
		if (g_game.placeCreature(monster, position, extended, force, magicEffect)) {
			pushUserdata<Monster>(L, monster);
			setMetatable(L, -1, "Monster");
		} else {
			delete monster;
			lua_pushboolean(L, false);
		}
	} else {
		delete monster;
		lua_pushboolean(L, false);
	}
	return 1;
}

int LuaScriptInterface::luaGameCreateNpc(lua_State* L)
{
	// Game.createNpc(npcName, position[, extended = false[, force = false[, magicEffect = CONST_ME_TELEPORT]]])
	Npc* npc = Npc::createNpc(getString(L, 1));
	if (!npc) {
		lua_pushnil(L);
		return 1;
	}

	const Position& position = getPosition(L, 2);
	bool extended = getBoolean(L, 3, false);
	bool force = getBoolean(L, 4, false);
	MagicEffectClasses magicEffect = getNumber<MagicEffectClasses>(L, 5, CONST_ME_TELEPORT);

	if (g_game.placeCreature(npc, position, extended, force, magicEffect)) {
		pushUserdata<Npc>(L, npc);
		setMetatable(L, -1, "Npc");
	} else {
		delete npc;
		lua_pushboolean(L, false);
	}
	return 1;
}

int LuaScriptInterface::luaGameCreateTile(lua_State* L)
{
	// Game.createTile(x, y, z[, isDynamic = false])
	// Game.createTile(position[, isDynamic = false])
	Position position;
	bool isDynamic;
	if (isTable(L, 1)) {
		position = getPosition(L, 1);
		isDynamic = getBoolean(L, 2, false);
	} else {
		position.x = getNumber<uint16_t>(L, 1);
		position.y = getNumber<uint16_t>(L, 2);
		position.z = getNumber<uint16_t>(L, 3);
		isDynamic = getBoolean(L, 4, false);
	}

	Tile* tile = g_game.map.getTile(position);
	if (!tile) {
		if (isDynamic) {
			tile = new DynamicTile(position.x, position.y, position.z);
		} else {
			tile = new StaticTile(position.x, position.y, position.z);
		}

		g_game.map.setTile(position, tile);
	}

	pushUserdata(L, tile);
	setMetatable(L, -1, "Tile");
	return 1;
}

int LuaScriptInterface::luaGameCreateMonsterType(lua_State* L)
{
	// Game.createMonsterType(name)
	if (getScriptEnv()->getScriptInterface() != &g_scripts->getScriptInterface()) {
		reportErrorFunc(L, "MonsterTypes can only be registered in the Scripts interface.");
		lua_pushnil(L);
		return 1;
	}

	const std::string& name = getString(L, 1);
	if (name.length() == 0) {
		lua_pushnil(L);
		return 1;
	}

	MonsterType* monsterType = g_monsters.getMonsterType(name, false);
	if (!monsterType) {
		monsterType = &g_monsters.monsters[asLowerCaseString(name)];
		monsterType->name = name;
		monsterType->nameDescription = "a " + name;
	} else {
		monsterType->info.lootItems.clear();
		monsterType->info.attackSpells.clear();
		monsterType->info.defenseSpells.clear();
		monsterType->info.scripts.clear();
		monsterType->info.thinkEvent = -1;
		monsterType->info.creatureAppearEvent = -1;
		monsterType->info.creatureDisappearEvent = -1;
		monsterType->info.creatureMoveEvent = -1;
		monsterType->info.creatureSayEvent = -1;
	}

	pushUserdata<MonsterType>(L, monsterType);
	setMetatable(L, -1, "MonsterType");
	return 1;
}

int LuaScriptInterface::luaGameStartRaid(lua_State* L)
{
	// Game.startRaid(raidName)
	const std::string& raidName = getString(L, 1);

	Raid* raid = g_game.raids.getRaidByName(raidName);
	if (!raid || !raid->isLoaded()) {
		lua_pushnumber(L, RETURNVALUE_NOSUCHRAIDEXISTS);
		return 1;
	}

	if (g_game.raids.getRunning()) {
		lua_pushnumber(L, RETURNVALUE_ANOTHERRAIDISALREADYEXECUTING);
		return 1;
	}

	g_game.raids.setRunning(raid);
	raid->startRaid();
	lua_pushnumber(L, RETURNVALUE_NOERROR);
	return 1;
}

int LuaScriptInterface::luaGameGetClientVersion(lua_State* L)
{
	// Game.getClientVersion()
	lua_createtable(L, 0, 3);
	setField(L, "min", CLIENT_VERSION_MIN);
	setField(L, "max", CLIENT_VERSION_MAX);
	setField(L, "string", CLIENT_VERSION_STR);
	return 1;
}

int LuaScriptInterface::luaGameReload(lua_State* L)
{
	// Game.reload(reloadType)
	ReloadTypes_t reloadType = getNumber<ReloadTypes_t>(L, 1);
	if (reloadType == RELOAD_TYPE_GLOBAL) {
		pushBoolean(L, g_luaEnvironment.loadFile("data/global.lua") == 0);
		pushBoolean(L, g_scripts->loadScripts("scripts/lib", true, true));
	} else {
		if (reloadType == RELOAD_TYPE_ALL) {
			g_luaEnvironment.loadFile("data/global.lua");
			g_scripts->loadScripts("scripts/lib", true, true);
		}
		pushBoolean(L, g_game.reload(reloadType));
	}
	lua_gc(g_luaEnvironment.getLuaState(), LUA_GCCOLLECT, 0);
	return 1;
}

int LuaScriptInterface::luaGameGetAccountStorageValue(lua_State* L)
{
	// Game.getAccountStorageValue(accountId, key)
	uint32_t accountId = getNumber<uint32_t>(L, 1);
	uint32_t key = getNumber<uint32_t>(L, 2);

	lua_pushnumber(L, g_game.getAccountStorageValue(accountId, key));

	return 1;
}

int LuaScriptInterface::luaGameSetAccountStorageValue(lua_State* L)
{
	// Game.setAccountStorageValue(accountId, key, value)
	uint32_t accountId = getNumber<uint32_t>(L, 1);
	uint32_t key = getNumber<uint32_t>(L, 2);
	int32_t value = getNumber<int32_t>(L, 3);

	g_game.setAccountStorageValue(accountId, key, value);
	lua_pushboolean(L, true);

	return 1;
}

int LuaScriptInterface::luaGameSaveAccountStorageValues(lua_State* L)
{
	// Game.saveAccountStorageValues()
	lua_pushboolean(L, g_game.saveAccountStorageValues());

	return 1;
}

int LuaScriptInterface::luaGameSendConsoleMessage(lua_State* L)
{
	// Game.sendConsoleMessage(type, text)
	uint16_t msgType = getNumber<uint16_t>(L, 1);
	const std::string& text = getString(L, 2);

	if (msgType < CONSOLEMESSAGE_TYPE_LAST) {
		console::print(static_cast<ConsoleMessageType>(msgType), text);
		lua_pushboolean(L, true);
	} else {
		lua_pushboolean(L, false);
	}

	return 1;
}

int LuaScriptInterface::luaGameGetLastConsoleMessage(lua_State* L)
{
	// Game.getLastConsoleMessage()
	lua_pushstring(L, console::getLastMessage().c_str());
	return 1;
}

int LuaScriptInterface::luaGameGetConsoleHistory(lua_State* L)
{
	// Game.getConsoleHistory()
	console::Cache history = console::getHistory();
	lua_createtable(L, history.size(), 0);
	int index = 0;
	for (const auto& consoleEntry : history) {
		lua_createtable(L, 0, 2);
		setField(L, "message", consoleEntry.first);
		setField(L, "type", consoleEntry.second);
		lua_rawseti(L, -2, ++index);
	}

	return 1;
}

int LuaScriptInterface::luaGamePlayerHirelingFeatures(lua_State* L)
{
	// get: Game.playerHirelingFeatures(playerGuid)
	// set: Game.playerHirelingFeatures(playerGuid, values)
	if (lua_gettop(L) > 0) {
		uint32_t playerGuid = getNumber<uint32_t>(L, 1);
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, g_game.getHirelingFeatures(playerGuid));
		} else {
			g_game.setHirelingFeatures(playerGuid, getNumber<int32_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGameAddRewardByPlayerId(lua_State* L)
{
	// Game.addRewardByPlayerId(playerId, item)

	// validate player id
	uint32_t playerId = getNumber<uint32_t>(L, 1);
	if (playerId <= PLAYER_ID_MIN || playerId >= PLAYER_ID_MAX) {
		// invalid creature id
		pushBoolean(L, false);
		return 1;
	}

	// validate the item
	Item* item = getUserdata<Item>(L, 2);
	if (!item) {
		// item was not passed
		lua_pushnil(L);
		return 1;
	}

	// check if player is online
	Player* player = g_game.getPlayerByID(playerId);

	// cant convert to guid when allow clones is on
	if (g_config.getBoolean(ConfigManager::ALLOW_CLONES)) {
		pushBoolean(L, false);
		return 1;
	}

	// player is offline, search the database by guid
	if (!player) {
		Player tmpPlayer(nullptr);
		if (!IOLoginData::loadPlayerById(&tmpPlayer, playerId - PLAYER_ID_MIN)) {
			// failed to load the player
			// (eg. hit boss, logged out and got deleted from the database before reward distrubition)
			pushBoolean(L, false);
			return 1;
		}

		// copy addItemEx behaviour
		if (item->getParent() != VirtualCylinder::virtualCylinder) {
			reportErrorFunc(L, "Item already has a parent");
			lua_pushnil(L);
			return 1;
		}

		bool added = g_game.internalAddItem(&tmpPlayer.getRewardChest(), item, INDEX_WHEREEVER, FLAG_NOLIMIT | FLAG_IGNORENOTPICKUPABLE) == RETURNVALUE_NOERROR;
		if (added) {
			ScriptEnvironment::removeTempItem(item);
			IOLoginData::savePlayer(&tmpPlayer);
		}

		pushBoolean(L, added);
		return 1;
	}

	// player is online, copy addItemEx behaviour
	if (item->getParent() != VirtualCylinder::virtualCylinder) {
		reportErrorFunc(L, "Item already has a parent");
		lua_pushnil(L);
		return 1;
	}

	bool added = g_game.internalAddItem(&player->getRewardChest(), item, INDEX_WHEREEVER, FLAG_NOLIMIT | FLAG_IGNORENOTPICKUPABLE) == RETURNVALUE_NOERROR;
	if (added) {
		ScriptEnvironment::removeTempItem(item);
	}

	pushBoolean(L, added);
	return 1;
}

int LuaScriptInterface::luaGameGetNextRewardId(lua_State* L)
{
	// Game.getNextRewardId()
	lua_pushnumber(L, RewardBag::generateRewardId());
	return 1;
}

int LuaScriptInterface::luaGameIsDevMode(lua_State* L)
{
	// Game.isDevMode()
#ifdef DEV_MODE
	lua_pushboolean(L, true);
#else
	lua_pushboolean(L, false);
#endif
	return 1;
}
