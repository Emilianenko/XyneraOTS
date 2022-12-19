// Copyright 2022 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "events.h"
#include "item.h"
#include "monster.h"
#include "player.h"
#include "pugicast.h"
#include "tools.h"

Events::Events() :
	scriptInterface("Event Interface")
{
	scriptInterface.initState();
}

bool Events::load()
{
	std::string location = "Events::load";

	pugi::xml_document doc;
	pugi::xml_parse_result result = doc.load_file("data/events/events.xml");
	if (!result) {
		printXMLError(location, "data/events/events.xml", result);
		return false;
	}

	info = {};

	std::set<std::string> classes;
	for (auto eventNode : doc.child("events").children()) {
		if (!eventNode.attribute("enabled").as_bool()) {
			continue;
		}

		const std::string& className = eventNode.attribute("class").as_string();
		auto res = classes.insert(className);
		if (res.second) {
			const std::string& lowercase = asLowerCaseString(className);
			if (scriptInterface.loadFile("data/events/scripts/" + lowercase + ".lua") != 0) {
				console::reportFileError(location, lowercase, scriptInterface.getLastLuaError());
			}
		}

		const std::string& methodName = eventNode.attribute("method").as_string();
		const int32_t event = scriptInterface.getMetaEvent(className, methodName);
		if (className == "Creature") {
			if (methodName == "onChangeOutfit") {
				info.creatureOnChangeOutfit = event;
			} else if (methodName == "onAreaCombat") {
				info.creatureOnAreaCombat = event;
			} else if (methodName == "onTargetCombat") {
				info.creatureOnTargetCombat = event;
			} else if (methodName == "onHear") {
				info.creatureOnHear = event;
			} else if (methodName == "onAddCondition") {
				info.creatureOnAddCondition = event;
			} else {
				console::reportWarning(location, "Unknown creature method \"" + methodName + "\"!");
			}
		} else if (className == "Party") {
			if (methodName == "onJoin") {
				info.partyOnJoin = event;
			} else if (methodName == "onLeave") {
				info.partyOnLeave = event;
			} else if (methodName == "onDisband") {
				info.partyOnDisband = event;
			} else if (methodName == "onShareExperience") {
				info.partyOnShareExperience = event;
			} else {
				console::reportWarning(location, "Unknown party method \"" + methodName + "\"!");
			}
		} else if (className == "Player") {
			if (methodName == "onBrowseField") {
				info.playerOnBrowseField = event;
			} else if (methodName == "onLook") {
				info.playerOnLook = event;
			} else if (methodName == "onLookInBattleList") {
				info.playerOnLookInBattleList = event;
			} else if (methodName == "onLookInTrade") {
				info.playerOnLookInTrade = event;
			} else if (methodName == "onLookInShop") {
				info.playerOnLookInShop = event;
			} else if (methodName == "onLookInMarket") {
				info.playerOnLookInMarket = event;
			} else if (methodName == "onTradeRequest") {
				info.playerOnTradeRequest = event;
			} else if (methodName == "onTradeAccept") {
				info.playerOnTradeAccept = event;
			} else if (methodName == "onTradeCompleted") {
				info.playerOnTradeCompleted = event;
			} else if (methodName == "onPodiumRequest") {
				info.playerOnPodiumRequest = event;
			} else if (methodName == "onPodiumEdit") {
				info.playerOnPodiumEdit = event;
			} else if (methodName == "onMoveItem") {
				info.playerOnMoveItem = event;
			} else if (methodName == "onItemMoved") {
				info.playerOnItemMoved = event;
			} else if (methodName == "onMoveCreature") {
				info.playerOnMoveCreature = event;
			} else if (methodName == "onReportRuleViolation") {
				info.playerOnReportRuleViolation = event;
			} else if (methodName == "onReportBug") {
				info.playerOnReportBug = event;
			} else if (methodName == "onTurn") {
				info.playerOnTurn = event;
			} else if (methodName == "onGainExperience") {
				info.playerOnGainExperience = event;
			} else if (methodName == "onLoseExperience") {
				info.playerOnLoseExperience = event;
			} else if (methodName == "onGainSkillTries") {
				info.playerOnGainSkillTries = event;
			} else if (methodName == "onWrapItem") {
				info.playerOnWrapItem = event;
			} else if (methodName == "onQuickLoot") {
				info.playerOnQuickLoot = event;
			} else if (methodName == "onInspectItem") {
				info.playerOnInspectItem = event;
			} else if (methodName == "onInspectTradeItem") {
				info.playerOnInspectTradeItem = event;
			} else if (methodName == "onInspectNpcTradeItem") {
				info.playerOnInspectNpcTradeItem = event;
			} else if (methodName == "onInspectCyclopediaItem") {
				info.playerOnInspectCyclopediaItem = event;
			} else if (methodName == "onMinimapQuery") {
				info.playerOnMinimapQuery = event;
			} else if (methodName == "onInventoryUpdate") {
				info.playerOnInventoryUpdate = event;
			} else if (methodName == "onGuildMotdEdit") {
				info.playerOnGuildMotdEdit = event;
			} else if (methodName == "onSetLootList") {
				info.playerOnSetLootList = event;
			} else if (methodName == "onManageLootContainer") {
				info.playerOnManageLootContainer = event;
			} else if (methodName == "onFuseItems") {
				info.playerOnFuseItems = event;
			} else if (methodName == "onTransferTier") {
				info.playerOnTransferTier = event;
			} else if (methodName == "onForgeConversion") {
				info.playerOnForgeConversion = event;
			} else if (methodName == "onForgeHistoryBrowse") {
				info.playerOnForgeHistoryBrowse = event;
			} else if (methodName == "onRequestPlayerTab") {
				info.playerOnRequestPlayerTab = event;
			} else if (methodName == "onBestiaryInit") {
				info.playerOnBestiaryInit = event;
			} else if (methodName == "onBestiaryBrowse") {
				info.playerOnBestiaryBrowse = event;
			} else if (methodName == "onBestiaryRaceView") {
				info.playerOnBestiaryRaceView = event;
			} else if (methodName == "onFrameView") {
				info.playerOnFrameView = event;
			} else if (methodName == "onImbuementApply") {
				info.playerOnImbuementApply = event;
			} else if (methodName == "onImbuementClear") {
				info.playerOnImbuementClear = event;
			} else if (methodName == "onImbuementExit") {
				info.playerOnImbuementExit = event;
			} else if (methodName == "onDressOtherCreatureRequest") {
				info.playerOnDressOtherCreatureRequest = event;
			} else if (methodName == "onDressOtherCreature") {
				info.playerOnDressOtherCreature = event;
			} else if (methodName == "onUseCreature") {
				info.playerOnUseCreature = event;
			} else if (methodName == "onEditName") {
				info.playerOnEditName = event;
			} else if (methodName == "onStoreBrowse") {
				info.playerOnStoreBrowse = event;
			} else if (methodName == "onStoreBuy") {
				info.playerOnStoreBuy = event;
			} else if (methodName == "onStoreHistoryBrowse") {
				info.playerOnStoreHistoryBrowse = event;

			// network methods
			} else if (methodName == "onConnect") {
				info.playerOnConnect = event;
			} else if (methodName == "onExtendedProtocol") {
				info.playerOnExtendedProtocol = event;
			} else {
				console::reportWarning(location, "Unknown player method \"" + methodName + "\"!");
			}
		} else if (className == "Monster") {
			if (methodName == "onDropLoot") {
				info.monsterOnDropLoot = event;
			} else if (methodName == "onSpawn") {
				info.monsterOnSpawn = event;
			} else {
				console::reportWarning(location, "Unknown monster method \"" + methodName + "\"!");
			}
		} else {
			console::reportWarning(location, "Unknown class \"" + className + "\"!");
		}
	}
	return true;
}

// Monster
bool Events::eventMonsterOnSpawn(Monster* monster, const Position& position, bool startup, bool artificial)
{
	// Monster:onSpawn(position, startup, artificial)
	if (info.monsterOnSpawn == -1) {
		return true;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return false;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.monsterOnSpawn, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.monsterOnSpawn);

	// set monster ID earlier than usual so we can reference it in the script
	monster->setID();

	LuaScriptInterface::pushUserdata<Monster>(L, monster);
	LuaScriptInterface::setMetatable(L, -1, "Monster");
	LuaScriptInterface::pushPosition(L, position);
	LuaScriptInterface::pushBoolean(L, startup);
	LuaScriptInterface::pushBoolean(L, artificial);

	return scriptInterface.callFunction(4);
}

// Creature
bool Events::eventCreatureOnChangeOutfit(Creature* creature, const Outfit_t& outfit)
{
	// Creature:onChangeOutfit(outfit)
	if (info.creatureOnChangeOutfit == -1) {
		return true;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return false;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.creatureOnChangeOutfit, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.creatureOnChangeOutfit);

	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);

	LuaScriptInterface::pushOutfit(L, outfit);

	return scriptInterface.callFunction(2);
}

ReturnValue Events::eventCreatureOnAreaCombat(Creature* creature, Tile* tile, bool aggressive)
{
	// Creature:onAreaCombat(tile, aggressive)
	if (info.creatureOnAreaCombat == -1) {
		return RETURNVALUE_NOERROR;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return RETURNVALUE_NOTPOSSIBLE;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.creatureOnAreaCombat, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.creatureOnAreaCombat);

	if (creature) {
		LuaScriptInterface::pushUserdata<Creature>(L, creature);
		LuaScriptInterface::setCreatureMetatable(L, -1, creature);
	} else {
		lua_pushnil(L);
	}

	LuaScriptInterface::pushUserdata<Tile>(L, tile);
	LuaScriptInterface::setMetatable(L, -1, "Tile");

	LuaScriptInterface::pushBoolean(L, aggressive);

	ReturnValue returnValue;
	if (scriptInterface.protectedCall(L, 3, 1) != 0) {
		returnValue = RETURNVALUE_NOTPOSSIBLE;
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	} else {
		returnValue = LuaScriptInterface::getNumber<ReturnValue>(L, -1);
		lua_pop(L, 1);
	}

	scriptInterface.resetScriptEnv();
	return returnValue;
}

ReturnValue Events::eventCreatureOnTargetCombat(Creature* creature, Creature* target)
{
	// Creature:onTargetCombat(target)
	if (info.creatureOnTargetCombat == -1) {
		return RETURNVALUE_NOERROR;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return RETURNVALUE_NOTPOSSIBLE;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.creatureOnTargetCombat, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.creatureOnTargetCombat);

	if (creature) {
		LuaScriptInterface::pushUserdata<Creature>(L, creature);
		LuaScriptInterface::setCreatureMetatable(L, -1, creature);
	} else {
		lua_pushnil(L);
	}

	LuaScriptInterface::pushUserdata<Creature>(L, target);
	LuaScriptInterface::setCreatureMetatable(L, -1, target);

	ReturnValue returnValue;
	if (scriptInterface.protectedCall(L, 2, 1) != 0) {
		returnValue = RETURNVALUE_NOTPOSSIBLE;
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	} else {
		returnValue = LuaScriptInterface::getNumber<ReturnValue>(L, -1);
		lua_pop(L, 1);
	}

	scriptInterface.resetScriptEnv();
	return returnValue;
}

void Events::eventCreatureOnHear(Creature* creature, Creature* speaker, const std::string& words, MessageClasses type)
{
	// Creature:onHear(speaker, words, type)
	if (info.creatureOnHear == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.creatureOnHear, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.creatureOnHear);

	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);

	LuaScriptInterface::pushUserdata<Creature>(L, speaker);
	LuaScriptInterface::setCreatureMetatable(L, -1, speaker);

	LuaScriptInterface::pushString(L, words);
	lua_pushnumber(L, type);

	scriptInterface.callVoidFunction(4);
}

ReturnValue Events::eventCreatureOnAddCondition(Creature* creature, Condition* condition, bool isForced)
{
	// Creature:onAddCondition(condition, isForced)
	if (info.creatureOnAddCondition == -1) {
		return RETURNVALUE_NOERROR;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return RETURNVALUE_NOTPOSSIBLE;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.creatureOnAddCondition, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.creatureOnAddCondition);

	if (creature) {
		LuaScriptInterface::pushUserdata<Creature>(L, creature);
		LuaScriptInterface::setCreatureMetatable(L, -1, creature);
	} else {
		lua_pushnil(L);
	}

	if (condition) {
		LuaScriptInterface::pushUserdata<Condition>(L, condition);
		LuaScriptInterface::setMetatable(L, -1, "Condition");
	} else {
		lua_pushnil(L);
	}

	lua_pushboolean(L, isForced);

	ReturnValue returnValue;
	if (scriptInterface.protectedCall(L, 3, 1) != 0) {
		returnValue = RETURNVALUE_NOTPOSSIBLE;
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	} else {
		returnValue = LuaScriptInterface::getNumber<ReturnValue>(L, -1);
		lua_pop(L, 1);
	}

	scriptInterface.resetScriptEnv();
	return returnValue;
}

// Party
bool Events::eventPartyOnJoin(Party* party, Player* player)
{
	// Party:onJoin(player)
	if (info.partyOnJoin == -1) {
		return true;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return false;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.partyOnJoin, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.partyOnJoin);

	LuaScriptInterface::pushUserdata<Party>(L, party);
	LuaScriptInterface::setMetatable(L, -1, "Party");

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	return scriptInterface.callFunction(2);
}

bool Events::eventPartyOnLeave(Party* party, Player* player)
{
	// Party:onLeave(player)
	if (info.partyOnLeave == -1) {
		return true;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return false;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.partyOnLeave, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.partyOnLeave);

	LuaScriptInterface::pushUserdata<Party>(L, party);
	LuaScriptInterface::setMetatable(L, -1, "Party");

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	return scriptInterface.callFunction(2);
}

bool Events::eventPartyOnDisband(Party* party)
{
	// Party:onDisband()
	if (info.partyOnDisband == -1) {
		return true;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return false;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.partyOnDisband, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.partyOnDisband);

	LuaScriptInterface::pushUserdata<Party>(L, party);
	LuaScriptInterface::setMetatable(L, -1, "Party");

	return scriptInterface.callFunction(1);
}

void Events::eventPartyOnShareExperience(Party* party, uint64_t& exp)
{
	// Party:onShareExperience(exp)
	if (info.partyOnShareExperience == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.partyOnShareExperience, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.partyOnShareExperience);

	LuaScriptInterface::pushUserdata<Party>(L, party);
	LuaScriptInterface::setMetatable(L, -1, "Party");

	lua_pushnumber(L, exp);

	if (scriptInterface.protectedCall(L, 2, 1) != 0) {
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	} else {
		exp = LuaScriptInterface::getNumber<uint64_t>(L, -1);
		lua_pop(L, 1);
	}

	scriptInterface.resetScriptEnv();
}

// Player
bool Events::eventPlayerOnBrowseField(Player* player, const Position& position)
{
	// Player:onBrowseField(position)
	if (info.playerOnBrowseField == -1) {
		return true;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return false;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnBrowseField, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnBrowseField);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushPosition(L, position);

	return scriptInterface.callFunction(2);
}

void Events::eventPlayerOnLook(Player* player, const Position& position, Thing* thing, uint8_t stackpos, int32_t lookDistance)
{
	// Player:onLook(thing, position, distance)
	if (info.playerOnLook == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnLook, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnLook);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	if (Creature* creature = thing->getCreature()) {
		LuaScriptInterface::pushUserdata<Creature>(L, creature);
		LuaScriptInterface::setCreatureMetatable(L, -1, creature);
	} else if (Item* item = thing->getItem()) {
		LuaScriptInterface::pushUserdata<Item>(L, item);
		LuaScriptInterface::setItemMetatable(L, -1, item);
	} else {
		lua_pushnil(L);
	}

	LuaScriptInterface::pushPosition(L, position, stackpos);
	lua_pushnumber(L, lookDistance);

	scriptInterface.callVoidFunction(4);
}

void Events::eventPlayerOnLookInBattleList(Player* player, Creature* creature, int32_t lookDistance)
{
	// Player:onLookInBattleList(creature, position, distance)
	if (info.playerOnLookInBattleList == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnLookInBattleList, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnLookInBattleList);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);

	lua_pushnumber(L, lookDistance);

	scriptInterface.callVoidFunction(3);
}

void Events::eventPlayerOnLookInTrade(Player* player, Player* partner, Item* item, int32_t lookDistance)
{
	// Player:onLookInTrade(partner, item, distance)
	if (info.playerOnLookInTrade == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnLookInTrade, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnLookInTrade);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Player>(L, partner);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Item>(L, item);
	LuaScriptInterface::setItemMetatable(L, -1, item);

	lua_pushnumber(L, lookDistance);

	scriptInterface.callVoidFunction(4);
}

bool Events::eventPlayerOnLookInShop(Player* player, const ItemType* itemType, uint8_t count, Npc* npc)
{
	// Player:onLookInShop(itemType, count, npc)
	if (info.playerOnLookInShop == -1) {
		return true;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return false;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnLookInShop, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnLookInShop);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<const ItemType>(L, itemType);
	LuaScriptInterface::setMetatable(L, -1, "ItemType");

	lua_pushnumber(L, count);

	LuaScriptInterface::pushUserdata<Npc>(L, npc);
	LuaScriptInterface::setMetatable(L, -1, "Npc");

	return scriptInterface.callFunction(4);
}

bool Events::eventPlayerOnLookInMarket(Player* player, const ItemType* itemType, uint8_t tier)
{
	// Player:onLookInMarket(itemType, tier)
	if (info.playerOnLookInMarket == -1) {
		return true;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return false;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnLookInMarket, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnLookInMarket);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<const ItemType>(L, itemType);
	LuaScriptInterface::setMetatable(L, -1, "ItemType");

	lua_pushnumber(L, tier);

	return scriptInterface.callFunction(3);
}

ReturnValue Events::eventPlayerOnMoveItem(Player* player, Item* item, uint16_t count, const Position& fromPosition, const Position& toPosition, Cylinder* fromCylinder, Cylinder* toCylinder)
{
	// Player:onMoveItem(item, count, fromPosition, toPosition, fromCylinder, toCylinder)
	if (info.playerOnMoveItem == -1) {
		return RETURNVALUE_NOERROR;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return RETURNVALUE_NOTPOSSIBLE;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnMoveItem, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnMoveItem);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Item>(L, item);
	LuaScriptInterface::setItemMetatable(L, -1, item);

	lua_pushnumber(L, count);
	LuaScriptInterface::pushPosition(L, fromPosition);
	LuaScriptInterface::pushPosition(L, toPosition);

	LuaScriptInterface::pushCylinder(L, fromCylinder);
	LuaScriptInterface::pushCylinder(L, toCylinder);

	ReturnValue returnValue;
	if (scriptInterface.protectedCall(L, 7, 1) != 0) {
		returnValue = RETURNVALUE_NOTPOSSIBLE;
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	} else {
		returnValue = LuaScriptInterface::getNumber<ReturnValue>(L, -1);
		lua_pop(L, 1);
	}

	scriptInterface.resetScriptEnv();
	return returnValue;
}

void Events::eventPlayerOnItemMoved(Player* player, Item* item, uint16_t count, const Position& fromPosition, const Position& toPosition, Cylinder* fromCylinder, Cylinder* toCylinder)
{
	// Player:onItemMoved(item, count, fromPosition, toPosition, fromCylinder, toCylinder)
	if (info.playerOnItemMoved == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnItemMoved, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnItemMoved);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	if (item) {
		LuaScriptInterface::pushUserdata<Item>(L, item);
		LuaScriptInterface::setItemMetatable(L, -1, item);
	} else {
		lua_pushnil(L);
	}

	lua_pushnumber(L, count);
	LuaScriptInterface::pushPosition(L, fromPosition);
	LuaScriptInterface::pushPosition(L, toPosition);

	LuaScriptInterface::pushCylinder(L, fromCylinder);
	LuaScriptInterface::pushCylinder(L, toCylinder);

	scriptInterface.callVoidFunction(7);
}

bool Events::eventPlayerOnMoveCreature(Player* player, Creature* creature, const Position& fromPosition, const Position& toPosition)
{
	// Player:onMoveCreature(creature, fromPosition, toPosition)
	if (info.playerOnMoveCreature == -1) {
		return true;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return false;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnMoveCreature, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnMoveCreature);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);

	LuaScriptInterface::pushPosition(L, fromPosition);
	LuaScriptInterface::pushPosition(L, toPosition);

	return scriptInterface.callFunction(4);
}

void Events::eventPlayerOnReportRuleViolation(Player* player, const std::string& targetName, uint8_t reportType, uint8_t reportReason, const std::string& comment, const std::string& translation)
{
	// Player:onReportRuleViolation(targetName, reportType, reportReason, comment, translation)
	if (info.playerOnReportRuleViolation == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnReportRuleViolation, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnReportRuleViolation);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushString(L, targetName);

	lua_pushnumber(L, reportType);
	lua_pushnumber(L, reportReason);

	LuaScriptInterface::pushString(L, comment);
	LuaScriptInterface::pushString(L, translation);

	scriptInterface.callVoidFunction(6);
}

bool Events::eventPlayerOnReportBug(Player* player, const std::string& message, const Position& position, uint8_t category)
{
	// Player:onReportBug(message, position, category)
	if (info.playerOnReportBug == -1) {
		return true;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return false;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnReportBug, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnReportBug);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushString(L, message);
	LuaScriptInterface::pushPosition(L, position);
	lua_pushnumber(L, category);

	return scriptInterface.callFunction(4);
}

bool Events::eventPlayerOnTurn(Player* player, Direction direction)
{
	// Player:onTurn(direction)
	if (info.playerOnTurn == -1) {
		return true;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return false;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnTurn, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnTurn);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	lua_pushnumber(L, direction);

	return scriptInterface.callFunction(2);
}

bool Events::eventPlayerOnTradeRequest(Player* player, Player* target, Item* item)
{
	// Player:onTradeRequest(target, item)
	if (info.playerOnTradeRequest == -1) {
		return true;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return false;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnTradeRequest, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnTradeRequest);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Player>(L, target);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Item>(L, item);
	LuaScriptInterface::setItemMetatable(L, -1, item);

	return scriptInterface.callFunction(3);
}

bool Events::eventPlayerOnTradeAccept(Player* player, Player* target, Item* item, Item* targetItem)
{
	// Player:onTradeAccept(target, item, targetItem)
	if (info.playerOnTradeAccept == -1) {
		return true;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return false;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnTradeAccept, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnTradeAccept);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Player>(L, target);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Item>(L, item);
	LuaScriptInterface::setItemMetatable(L, -1, item);

	LuaScriptInterface::pushUserdata<Item>(L, targetItem);
	LuaScriptInterface::setItemMetatable(L, -1, targetItem);

	return scriptInterface.callFunction(4);
}

void Events::eventPlayerOnTradeCompleted(Player* player, Player* target, Item* item, Item* targetItem, bool isSuccess)
{
	// Player:onTradeCompleted(target, item, targetItem, isSuccess)
	if (info.playerOnTradeCompleted == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnTradeCompleted, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnTradeCompleted);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Player>(L, target);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Item>(L, item);
	LuaScriptInterface::setItemMetatable(L, -1, item);

	LuaScriptInterface::pushUserdata<Item>(L, targetItem);
	LuaScriptInterface::setItemMetatable(L, -1, targetItem);

	LuaScriptInterface::pushBoolean(L, isSuccess);

	return scriptInterface.callVoidFunction(5);
}

void Events::eventPlayerOnPodiumRequest(Player* player, Item* item)
{
	// Player:onPodiumRequest(item)
	if (info.playerOnPodiumRequest == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnPodiumRequest, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnPodiumRequest);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Item>(L, item);
	LuaScriptInterface::setItemMetatable(L, -1, item);

	scriptInterface.callFunction(2);
}

void Events::eventPlayerOnPodiumEdit(Player* player, Item* item, const Outfit_t& outfit, bool podiumVisible, Direction direction)
{
	// Player:onPodiumEdit(item, outfit, direction, isVisible)
	if (info.playerOnPodiumEdit == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnPodiumEdit, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnPodiumEdit);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Item>(L, item);
	LuaScriptInterface::setItemMetatable(L, -1, item);

	LuaScriptInterface::pushOutfit(L, outfit);

	lua_pushnumber(L, direction);
	lua_pushboolean(L, podiumVisible);

	scriptInterface.callFunction(5);
}

void Events::eventPlayerOnGainExperience(Player* player, Creature* source, uint64_t& exp, uint64_t rawExp)
{
	// Player:onGainExperience(source, exp, rawExp)
	// rawExp gives the original exp which is not multiplied
	if (info.playerOnGainExperience == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnGainExperience, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnGainExperience);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	if (source) {
		LuaScriptInterface::pushUserdata<Creature>(L, source);
		LuaScriptInterface::setCreatureMetatable(L, -1, source);
	} else {
		lua_pushnil(L);
	}

	lua_pushnumber(L, exp);
	lua_pushnumber(L, rawExp);

	if (scriptInterface.protectedCall(L, 4, 1) != 0) {
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	} else {
		exp = LuaScriptInterface::getNumber<uint64_t>(L, -1);
		lua_pop(L, 1);
	}

	scriptInterface.resetScriptEnv();
}

void Events::eventPlayerOnLoseExperience(Player* player, uint64_t& exp)
{
	// Player:onLoseExperience(exp)
	if (info.playerOnLoseExperience == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnLoseExperience, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnLoseExperience);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	lua_pushnumber(L, exp);

	if (scriptInterface.protectedCall(L, 2, 1) != 0) {
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	} else {
		exp = LuaScriptInterface::getNumber<uint64_t>(L, -1);
		lua_pop(L, 1);
	}

	scriptInterface.resetScriptEnv();
}

void Events::eventPlayerOnGainSkillTries(Player* player, skills_t skill, uint64_t& tries)
{
	// Player:onGainSkillTries(skill, tries)
	if (info.playerOnGainSkillTries == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnGainSkillTries, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnGainSkillTries);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	lua_pushnumber(L, skill);
	lua_pushnumber(L, tries);

	if (scriptInterface.protectedCall(L, 3, 1) != 0) {
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	} else {
		tries = LuaScriptInterface::getNumber<uint64_t>(L, -1);
		lua_pop(L, 1);
	}

	scriptInterface.resetScriptEnv();
}

void Events::eventPlayerOnWrapItem(Player* player, Item* item)
{
	// Player:onWrapItem(item)
	if (info.playerOnWrapItem == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnWrapItem, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnWrapItem);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Item>(L, item);
	LuaScriptInterface::setItemMetatable(L, -1, item);

	scriptInterface.callVoidFunction(2);
}

void Events::eventPlayerOnQuickLoot(Player* player, const Position& position, uint8_t stackPos, uint16_t spriteId)
{
	// Player:onQuickLoot(position, stackPos, spriteId)
	if (info.playerOnQuickLoot == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnQuickLoot, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnQuickLoot);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushPosition(L, position);
	lua_pushnumber(L, stackPos);
	lua_pushnumber(L, spriteId);

	scriptInterface.callVoidFunction(4);
}

void Events::eventPlayerOnInspectItem(Player* player, Item* item)
{
	// Player:onInspectItem(item)
	if (info.playerOnInspectItem == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnInspectItem, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnInspectItem);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Item>(L, item);
	LuaScriptInterface::setItemMetatable(L, -1, item);

	scriptInterface.callVoidFunction(2);
}

void Events::eventPlayerOnInspectTradeItem(Player* player, Player* tradePartner, Item* item)
{
	// Player:onInspectTradeItem(tradePartner, item)
	if (info.playerOnInspectTradeItem == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnInspectTradeItem, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnInspectTradeItem);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Player>(L, tradePartner);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Item>(L, item);
	LuaScriptInterface::setItemMetatable(L, -1, item);

	scriptInterface.callVoidFunction(3);
}

void Events::eventPlayerOnInspectNpcTradeItem(Player* player, Npc* npc, uint16_t itemId)
{
	// Player:onInspectNpcTradeItem(npc, itemId)
	if (info.playerOnInspectNpcTradeItem == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnInspectNpcTradeItem, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnInspectNpcTradeItem);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Npc>(L, npc);
	LuaScriptInterface::setMetatable(L, -1, "Npc");

	lua_pushnumber(L, itemId);

	scriptInterface.callVoidFunction(3);
}

void Events::eventPlayerOnInspectCyclopediaItem(Player* player, uint16_t itemId)
{
	// Player:onInspectCyclopediaItem(itemId)
	if (info.playerOnInspectCyclopediaItem == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnInspectCyclopediaItem, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnInspectCyclopediaItem);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	lua_pushnumber(L, itemId);

	scriptInterface.callVoidFunction(2);
}

void Events::eventPlayerOnMinimapQuery(Player* player, const Position& position)
{
	// Player:onMinimapQuery(position)
	if (info.playerOnMinimapQuery == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnMinimapQuery, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnMinimapQuery);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushPosition(L, position);

	scriptInterface.callVoidFunction(2);
}

void Events::eventPlayerOnInventoryUpdate(Player* player, Item* item, slots_t slot, bool equip)
{
	// Player:onInventoryUpdate(item, slot, equip)
	if (info.playerOnInventoryUpdate == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		std::cout << "[Error - Events::eventPlayerOnInventoryUpdate] Call stack overflow" << std::endl;
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnInventoryUpdate, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnInventoryUpdate);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	if (item) {
		LuaScriptInterface::pushUserdata<Item>(L, item);
		LuaScriptInterface::setItemMetatable(L, -1, item);
	} else {
		lua_pushnil(L);
	}

	lua_pushnumber(L, slot);
	LuaScriptInterface::pushBoolean(L, equip);

	scriptInterface.callVoidFunction(4);
}

const std::string Events::eventPlayerOnGuildMotdEdit(Player* player, const std::string& message)
{
	// Player:onGuildMotdEdit(message)
	if (info.playerOnGuildMotdEdit == -1) {
		return message;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return message;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnGuildMotdEdit, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnGuildMotdEdit);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushString(L, message);

	if (scriptInterface.protectedCall(L, 2, 1) != 0) {
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	} else {
		const std::string motd = LuaScriptInterface::getString(L, 1);
		lua_pop(L, 1);
		return motd;
	}

	return message;
}

void Events::eventPlayerOnSetLootList(Player* player, const std::vector<uint16_t>& lootList, bool isSkipMode)
{
	// Player:onSetLootList(lootList, isSkipMode)
	if (info.playerOnSetLootList == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnSetLootList, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnSetLootList);

	// player
	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	// lootList
	lua_createtable(L, lootList.size(), 0);
	int index = 0;
	for (auto itemId : lootList) {
		lua_pushnumber(L, itemId);
		lua_rawseti(L, -2, ++index);
	}

	// isSkipMode
	lua_pushboolean(L, isSkipMode);

	scriptInterface.callVoidFunction(3);
}

void Events::eventPlayerOnManageLootContainer(Player* player, Item* item, uint8_t modePrimary, uint8_t modeSecondary)
{
	// Player:onManageLootContainer(item, modePrimary, modeSecondary)
	if (info.playerOnManageLootContainer == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnManageLootContainer, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnManageLootContainer);

	// player
	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	// item
	if (item) {
		if (Container* container = item->getContainer()) {
			LuaScriptInterface::pushUserdata<Container>(L, container);
			LuaScriptInterface::setMetatable(L, -1, "Container");
		} else {
			LuaScriptInterface::pushUserdata<Item>(L, item);
			LuaScriptInterface::setMetatable(L, -1, "Item");
		}
	} else {
		lua_pushnil(L);
	}

	// modePrimary
	lua_pushnumber(L, modePrimary);

	// modeSecondary
	lua_pushnumber(L, modeSecondary);

	scriptInterface.callVoidFunction(4);
}

void Events::eventPlayerOnFuseItems(Player* player, const ItemType* fromItemType, uint8_t fromTier, const ItemType* toItemType, bool successCore, bool tierLossCore)
{
	// Player:onFuseItems(fromItemType, fromTier, toItemType, successCore, tierLossCore)
	if (info.playerOnFuseItems == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnFuseItems, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnFuseItems);

	// player
	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	// fromItemType
	LuaScriptInterface::pushUserdata<const ItemType>(L, fromItemType);
	LuaScriptInterface::setMetatable(L, -1, "ItemType");

	// fromTier
	lua_pushnumber(L, fromTier);

	// toItemType
	LuaScriptInterface::pushUserdata<const ItemType>(L, toItemType);
	LuaScriptInterface::setMetatable(L, -1, "ItemType");

	// successCore
	lua_pushboolean(L, successCore);

	// tierLossCore
	lua_pushboolean(L, tierLossCore);

	scriptInterface.callVoidFunction(6);
}

void Events::eventPlayerOnTransferTier(Player* player, const ItemType* fromItemType, uint8_t fromTier, const ItemType* toItemType)
{
	// Player:onTransferTier(fromItemType, fromTier, toItemType)
	if (info.playerOnTransferTier == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnTransferTier, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnTransferTier);

	// player
	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	// fromItemType
	LuaScriptInterface::pushUserdata<const ItemType>(L, fromItemType);
	LuaScriptInterface::setMetatable(L, -1, "ItemType");

	// fromTier
	lua_pushnumber(L, fromTier);

	// toItemType
	LuaScriptInterface::pushUserdata<const ItemType>(L, toItemType);
	LuaScriptInterface::setMetatable(L, -1, "ItemType");

	scriptInterface.callVoidFunction(4);
}

void Events::eventPlayerOnForgeConversion(Player* player, ForgeConversionTypes_t conversionType)
{
	// Player:onForgeConversion(conversionType)
	if (info.playerOnForgeConversion == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnForgeConversion, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnForgeConversion);

	// player
	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	// conversionType
	lua_pushnumber(L, conversionType);

	scriptInterface.callVoidFunction(2);
}

void Events::eventPlayerOnForgeHistoryBrowse(Player* player, uint8_t page)
{
	// Player:onForgeHistoryBrowse(page)
	if (info.playerOnForgeHistoryBrowse == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnForgeHistoryBrowse, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnForgeHistoryBrowse);

	// player
	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	// conversionType
	lua_pushnumber(L, page);

	scriptInterface.callVoidFunction(2);
}

void Events::eventPlayerOnRequestPlayerTab(Player* player, Player* targetPlayer, PlayerTabTypes_t infoType, uint16_t currentPage, uint16_t entriesPerPage)
{
	// Player:onRequestPlayerTab(target, infoType, currentPage, entriesPerPage)
	if (info.playerOnRequestPlayerTab == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnRequestPlayerTab, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnRequestPlayerTab);

	// player
	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	// target
	LuaScriptInterface::pushUserdata<Player>(L, targetPlayer);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	// infoType
	lua_pushnumber(L, infoType);

	// currentPage
	lua_pushnumber(L, currentPage);

	// entriesPerPage
	lua_pushnumber(L, entriesPerPage);

	scriptInterface.callVoidFunction(5);
}

void Events::eventPlayerOnBestiaryInit(Player* player)
{
	// Player:onBestiaryInit()
	if (info.playerOnBestiaryInit == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnBestiaryInit, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnBestiaryInit);

	// player
	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	scriptInterface.callVoidFunction(1);
}

void Events::eventPlayerOnBestiaryBrowse(Player* player, const std::string& category, std::vector<uint16_t> raceList)
{
	// Player:onBestiaryBrowse(category, raceList)
	if (info.playerOnBestiaryBrowse == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnBestiaryBrowse, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnBestiaryBrowse);

	// player
	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	// category
	lua_pushstring(L, category.c_str());

	// raceList
	lua_createtable(L, raceList.size(), 0);
	int index = 0;
	for (auto raceId : raceList) {
		lua_pushnumber(L, raceId);
		lua_rawseti(L, -2, ++index);
	}

	scriptInterface.callVoidFunction(3);
}

void Events::eventPlayerOnBestiaryRaceView(Player* player, uint16_t raceId)
{
	// Player:onBestiaryRaceView(category, raceId)
	if (info.playerOnBestiaryRaceView == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnBestiaryRaceView, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnBestiaryRaceView);

	// player
	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	// raceId
	lua_pushnumber(L, raceId);

	scriptInterface.callVoidFunction(2);
}

uint8_t Events::eventPlayerOnFrameView(Player* player, const Creature* target)
{
	uint8_t frameColor = 0xFF;

	// Player:onFrameView(targetId)
	if (info.playerOnFrameView == -1) {
		return frameColor;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return frameColor;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnFrameView, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnFrameView);

	// player
	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	// target
	lua_pushnumber(L, target->getID());

	if (scriptInterface.protectedCall(L, 2, 1) != 0) {
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	} else {
		frameColor = LuaScriptInterface::getNumber<uint8_t>(L, -1);
		lua_pop(L, 1);
	}

	scriptInterface.resetScriptEnv();
	return frameColor;
}

void Events::eventPlayerOnImbuementApply(Player* player, uint8_t slotId, uint8_t imbuId, bool luckProtection)
{
	// Player:onImbuementApply(slotId, imbuId, luckProtection)
	if (info.playerOnImbuementApply == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnImbuementApply, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnImbuementApply);

	// player
	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	// slotId
	lua_pushnumber(L, slotId);

	// imbuId
	lua_pushnumber(L, imbuId);

	// luckProtection
	lua_pushboolean(L, luckProtection);

	scriptInterface.callVoidFunction(4);
}

void Events::eventPlayerOnImbuementClear(Player* player, uint8_t slotId)
{
	// Player:onImbuementClear(slotId)
	if (info.playerOnImbuementClear == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnImbuementClear, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnImbuementClear);

	// player
	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	lua_pushnumber(L, slotId);

	scriptInterface.callVoidFunction(2);
}

void Events::eventPlayerOnImbuementExit(Player* player)
{
	// Player:onImbuementExit()
	if (info.playerOnImbuementExit == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnImbuementExit, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnImbuementExit);

	// player
	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	scriptInterface.callVoidFunction(1);
}

void Events::eventPlayerOnDressOtherCreatureRequest(Player* player, Creature* target)
{
	// Player:onDressOtherCreatureRequest(target)
	if (info.playerOnDressOtherCreatureRequest == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnDressOtherCreatureRequest, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnDressOtherCreatureRequest);

	// player
	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	// target
	LuaScriptInterface::pushUserdata<Creature>(L, target);
	LuaScriptInterface::setMetatable(L, -1, "Creature");

	scriptInterface.callVoidFunction(2);
}

void Events::eventPlayerOnDressOtherCreature(Player* player, Creature* target, const Outfit_t& outfit)
{
	// Player:onDressOtherCreature(target)
	if (info.playerOnDressOtherCreature == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnDressOtherCreature, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnDressOtherCreature);

	// player
	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	// target
	LuaScriptInterface::pushUserdata<Creature>(L, target);
	LuaScriptInterface::setMetatable(L, -1, "Creature");

	// outfit
	LuaScriptInterface::pushOutfit(L, outfit);

	scriptInterface.callVoidFunction(3);
}

void Events::eventPlayerOnUseCreature(Player* player, Creature* target)
{
	// Player:onUseCreature(target)
	if (info.playerOnUseCreature == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnUseCreature, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnUseCreature);

	// player
	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	// target
	LuaScriptInterface::pushUserdata<Creature>(L, target);
	LuaScriptInterface::setMetatable(L, -1, "Creature");

	scriptInterface.callVoidFunction(2);
}

void Events::eventPlayerOnEditName(Player* player, Creature* target, const std::string& name)
{
	// Player:onEditName(target, newName)
	if (info.playerOnEditName == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnEditName, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnEditName);

	// player
	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	// target
	LuaScriptInterface::pushUserdata<Creature>(L, target);
	LuaScriptInterface::setMetatable(L, -1, "Creature");

	// newName
	LuaScriptInterface::pushString(L, name);

	scriptInterface.callVoidFunction(3);
}

void Events::eventPlayerOnStoreBrowse(Player* player, GameStoreRequest& request)
{
	// Player:onStoreBrowse(request)
	if (info.playerOnStoreBrowse == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnStoreBrowse, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnStoreBrowse);

	// player
	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	// request
	LuaScriptInterface::pushStoreRequest(L, request);

	scriptInterface.callVoidFunction(2);
}

void Events::eventPlayerOnStoreBuy(Player* player, uint16_t offerId, uint8_t action, const std::string& name, uint8_t type, const std::string& location)
{
	// Player:onStoreBuy(offerId, action, name, type, location)
	if (info.playerOnStoreBuy == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnStoreBuy, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnStoreBuy);

	// player
	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	// offerId
	lua_pushnumber(L, offerId);

	// action
	lua_pushnumber(L, action);

	// name
	lua_pushstring(L, name.c_str());

	// type
	lua_pushnumber(L, type);

	// location
	lua_pushstring(L, location.c_str());

	scriptInterface.callVoidFunction(6);
}

void Events::eventPlayerOnStoreHistoryBrowse(Player* player, uint32_t pageId, bool isInit)
{
	// Player:onStoreHistoryBrowse(pageId, isInit)
	if (info.playerOnStoreHistoryBrowse == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnStoreHistoryBrowse, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnStoreHistoryBrowse);

	// player
	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	// pageId
	lua_pushnumber(L, pageId);

	// isInit
	lua_pushboolean(L, isInit);

	scriptInterface.callVoidFunction(3);
}

void Events::eventPlayerOnConnect(Player* player, bool isLogin)
{
	// Player:onConnect(isLogin)
	if (info.playerOnConnect == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnConnect, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnConnect);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	lua_pushboolean(L, isLogin);
	scriptInterface.callVoidFunction(2);
}

#ifdef LUA_EXTENDED_PROTOCOL
void Events::eventPlayerOnExtendedProtocol(Player* player, uint8_t recvbyte, std::unique_ptr<NetworkMessage> message)
{
	// Player:onExtendedProtocol(recvbyte, msg)
	if (info.playerOnExtendedProtocol == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.playerOnExtendedProtocol, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnExtendedProtocol);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	lua_pushnumber(L, recvbyte);

	LuaScriptInterface::pushUserdata<NetworkMessage>(L, message.release());
	LuaScriptInterface::setMetatable(L, -1, "NetworkMessage");

	scriptInterface.callVoidFunction(3);
}
#endif

void Events::eventMonsterOnDropLoot(Monster* monster, Container* corpse)
{
	// Monster:onDropLoot(corpse)
	if (info.monsterOnDropLoot == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		reportOverflow();
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(info.monsterOnDropLoot, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.monsterOnDropLoot);

	LuaScriptInterface::pushUserdata<Monster>(L, monster);
	LuaScriptInterface::setMetatable(L, -1, "Monster");

	LuaScriptInterface::pushUserdata<Container>(L, corpse);
	LuaScriptInterface::setMetatable(L, -1, "Container");

	return scriptInterface.callVoidFunction(2);
}

