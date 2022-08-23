// Copyright 2022 Xynera.net. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "luascript.h"

#include "baseevents.h"
#include "combat.h"
#include "configmanager.h"
#include "enums.h"
#include "game.h"
#include "protocolstatus.h"
#include "scheduler.h"

class AreaCombat;
class Combat;

extern Chat* g_chat;
extern Game g_game;
extern ConfigManager g_config;
extern LuaEnvironment g_luaEnvironment;

int LuaScriptInterface::luaDoPlayerAddItem(lua_State* L)
{
	//doPlayerAddItem(cid, itemid, <optional: default: 1> count/subtype, <optional: default: 1> canDropOnMap)
	//doPlayerAddItem(cid, itemid, <optional: default: 1> count, <optional: default: 1> canDropOnMap, <optional: default: 1>subtype)
	Player* player = getPlayer(L, 1);
	if (!player) {
		reportErrorFunc(L, getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	uint16_t itemId = getNumber<uint16_t>(L, 2);
	int32_t count = getNumber<int32_t>(L, 3, 1);
	bool canDropOnMap = getBoolean(L, 4, true);
	uint16_t subType = getNumber<uint16_t>(L, 5, 1);

	const ItemType& it = Item::items[itemId];
	int32_t itemCount;

	auto parameters = lua_gettop(L);
	if (parameters > 4) {
		//subtype already supplied, count then is the amount
		itemCount = std::max<int32_t>(1, count);
	} else if (it.hasSubType()) {
		if (it.stackable) {
			itemCount = static_cast<int32_t>(std::ceil(static_cast<float>(count) / 100));
		} else {
			itemCount = 1;
		}
		subType = count;
	} else {
		itemCount = std::max<int32_t>(1, count);
	}

	while (itemCount > 0) {
		uint16_t stackCount = subType;
		if (it.stackable && stackCount > 100) {
			stackCount = 100;
		}

		Item* newItem = Item::CreateItem(itemId, stackCount);
		if (!newItem) {
			reportErrorFunc(L, getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
			pushBoolean(L, false);
			return 1;
		}

		if (it.stackable) {
			subType -= stackCount;
		}

		ReturnValue ret = g_game.internalPlayerAddItem(player, newItem, canDropOnMap);
		if (ret != RETURNVALUE_NOERROR) {
			delete newItem;
			pushBoolean(L, false);
			return 1;
		}

		if (--itemCount == 0) {
			if (newItem->getParent()) {
				uint32_t uid = getScriptEnv()->addThing(newItem);
				lua_pushnumber(L, uid);
				return 1;
			} else {
				//stackable item stacked with existing object, newItem will be released
				pushBoolean(L, false);
				return 1;
			}
		}
	}

	pushBoolean(L, false);
	return 1;
}

int LuaScriptInterface::luaDebugPrint(lua_State* L)
{
	//debugPrint(text)
	reportErrorFunc(L, getString(L, -1));
	return 0;
}

int LuaScriptInterface::luaGetWorldTime(lua_State* L)
{
	//getWorldTime()
	int16_t time = g_game.getWorldTime();
	lua_pushnumber(L, time);
	return 1;
}

int LuaScriptInterface::luaGetWorldLight(lua_State* L)
{
	//getWorldLight()
	LightInfo lightInfo = g_game.getWorldLightInfo();
	lua_pushnumber(L, lightInfo.level);
	lua_pushnumber(L, lightInfo.color);
	return 2;
}

int LuaScriptInterface::luaSetWorldLight(lua_State* L)
{
	//setWorldLight(level, color)
	if (g_config.getBoolean(ConfigManager::DEFAULT_WORLD_LIGHT)) {
		pushBoolean(L, false);
		return 1;
	}

	LightInfo lightInfo;
	lightInfo.level = getNumber<uint8_t>(L, 1);
	lightInfo.color = getNumber<uint8_t>(L, 2);
	g_game.setWorldLightInfo(lightInfo);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaGetWorldUpTime(lua_State* L)
{
	//getWorldUpTime()
	uint64_t uptime = (OTSYS_TIME() - ProtocolStatus::start) / 1000;
	lua_pushnumber(L, uptime);
	return 1;
}

int LuaScriptInterface::luaGetSubTypeName(lua_State* L)
{
	// getSubTypeName(subType)
	int32_t subType = getNumber<int32_t>(L, 1);
	if (subType > 0) {
		pushString(L, Item::items[subType].name);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

bool LuaScriptInterface::getArea(lua_State* L, std::vector<uint32_t>& vec, uint32_t& rows)
{
	lua_pushnil(L);
	for (rows = 0; lua_next(L, -2) != 0; ++rows) {
		if (!isTable(L, -1)) {
			return false;
		}

		lua_pushnil(L);
		while (lua_next(L, -2) != 0) {
			if (!isNumber(L, -1)) {
				return false;
			}
			vec.push_back(getNumber<uint32_t>(L, -1));
			lua_pop(L, 1);
		}

		lua_pop(L, 1);
	}

	lua_pop(L, 1);
	return (rows != 0);
}

int LuaScriptInterface::luaCreateCombatArea(lua_State* L)
{
	//createCombatArea( {area}, <optional> {extArea} )
	ScriptEnvironment* env = getScriptEnv();
	if (env->getScriptId() != EVENT_ID_LOADING) {
		reportErrorFunc(L, "This function can only be used while loading the script.");
		pushBoolean(L, false);
		return 1;
	}

	uint32_t areaId = g_luaEnvironment.createAreaObject(env->getScriptInterface());
	AreaCombat* area = g_luaEnvironment.getAreaObject(areaId);

	int parameters = lua_gettop(L);
	if (parameters >= 2) {
		uint32_t rowsExtArea;
		std::vector<uint32_t> vecExtArea;
		if (!isTable(L, 2) || !getArea(L, vecExtArea, rowsExtArea)) {
			reportErrorFunc(L, "Invalid extended area table.");
			pushBoolean(L, false);
			return 1;
		}
		area->setupExtArea(vecExtArea, rowsExtArea);
	}

	uint32_t rowsArea = 0;
	std::vector<uint32_t> vecArea;
	if (!isTable(L, 1) || !getArea(L, vecArea, rowsArea)) {
		reportErrorFunc(L, "Invalid area table.");
		pushBoolean(L, false);
		return 1;
	}

	area->setupArea(vecArea, rowsArea);
	lua_pushnumber(L, areaId);
	return 1;
}

int LuaScriptInterface::luaDoAreaCombat(lua_State* L)
{
	//doAreaCombat(cid, type, pos, area, min, max, effect[, origin = ORIGIN_SPELL[, blockArmor = false[, blockShield = false[, ignoreResistances = false]]]])
	Creature* creature = getCreature(L, 1);
	if (!creature && (!isNumber(L, 1) || getNumber<uint32_t>(L, 1) != 0)) {
		reportErrorFunc(L, getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	uint32_t areaId = getNumber<uint32_t>(L, 4);
	const AreaCombat* area = g_luaEnvironment.getAreaObject(areaId);
	if (area || areaId == 0) {
		CombatType_t combatType = getNumber<CombatType_t>(L, 2);

		CombatParams params;
		params.combatType = combatType;
		params.impactEffect = getNumber<uint8_t>(L, 7);
		params.blockedByArmor = getBoolean(L, 8, false);
		params.blockedByShield = getBoolean(L, 9, false);
		params.ignoreResistances = getBoolean(L, 10, false);

		CombatDamage damage;
		damage.origin = getNumber<CombatOrigin>(L, 8, ORIGIN_SPELL);
		damage.primary.type = combatType;
		damage.primary.value = normal_random(getNumber<int32_t>(L, 6), getNumber<int32_t>(L, 5));

		Combat::doAreaCombat(creature, getPosition(L, 3), area, damage, params);
		pushBoolean(L, true);
	} else {
		reportErrorFunc(L, getErrorDesc(LUA_ERROR_AREA_NOT_FOUND));
		pushBoolean(L, false);
	}
	return 1;
}

int LuaScriptInterface::luaDoTargetCombat(lua_State* L)
{
	//doTargetCombat(cid, target, type, min, max, effect[, origin = ORIGIN_SPELL[, blockArmor = false[, blockShield = false[, ignoreResistances = false]]]])
	Creature* creature = getCreature(L, 1);
	if (!creature && (!isNumber(L, 1) || getNumber<uint32_t>(L, 1) != 0)) {
		reportErrorFunc(L, getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	Creature* target = getCreature(L, 2);
	if (!target) {
		reportErrorFunc(L, getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	CombatType_t combatType = getNumber<CombatType_t>(L, 3);

	CombatParams params;
	params.combatType = combatType;
	params.impactEffect = getNumber<uint8_t>(L, 6);
	params.blockedByArmor = getBoolean(L, 8, false);
	params.blockedByShield = getBoolean(L, 9, false);
	params.ignoreResistances = getBoolean(L, 10, false);

	CombatDamage damage;
	damage.origin = getNumber<CombatOrigin>(L, 7, ORIGIN_SPELL);
	damage.primary.type = combatType;
	damage.primary.value = normal_random(getNumber<int32_t>(L, 4), getNumber<int32_t>(L, 5));

	Combat::doTargetCombat(creature, target, damage, params);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaDoChallengeCreature(lua_State* L)
{
	//doChallengeCreature(cid, target[, force = false])
	Creature* creature = getCreature(L, 1);
	if (!creature) {
		reportErrorFunc(L, getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	Creature* target = getCreature(L, 2);
	if (!target) {
		reportErrorFunc(L, getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	target->challengeCreature(creature, getBoolean(L, 3, false));
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaIsValidUID(lua_State* L)
{
	//isValidUID(uid)
	pushBoolean(L, getScriptEnv()->getThingByUID(getNumber<uint32_t>(L, -1)) != nullptr);
	return 1;
}

int LuaScriptInterface::luaIsDepot(lua_State* L)
{
	//isDepot(uid)
	Container* container = getScriptEnv()->getContainerByUID(getNumber<uint32_t>(L, -1));
	pushBoolean(L, container && container->getDepotLocker());
	return 1;
}

int LuaScriptInterface::luaIsMoveable(lua_State* L)
{
	//isMoveable(uid)
	//isMovable(uid)
	Thing* thing = getScriptEnv()->getThingByUID(getNumber<uint32_t>(L, -1));
	pushBoolean(L, thing && thing->isPushable());
	return 1;
}

int LuaScriptInterface::luaDoAddContainerItem(lua_State* L)
{
	//doAddContainerItem(uid, itemid, <optional> count/subtype)
	uint32_t uid = getNumber<uint32_t>(L, 1);

	ScriptEnvironment* env = getScriptEnv();
	Container* container = env->getContainerByUID(uid);
	if (!container) {
		reportErrorFunc(L, getErrorDesc(LUA_ERROR_CONTAINER_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	uint16_t itemId = getNumber<uint16_t>(L, 2);
	const ItemType& it = Item::items[itemId];

	int32_t itemCount = 1;
	int32_t subType = 1;
	uint32_t count = getNumber<uint32_t>(L, 3, 1);

	if (it.hasSubType()) {
		if (it.stackable) {
			itemCount = static_cast<int32_t>(std::ceil(static_cast<float>(count) / 100));
		}

		subType = count;
	} else {
		itemCount = std::max<int32_t>(1, count);
	}

	while (itemCount > 0) {
		int32_t stackCount = std::min<int32_t>(100, subType);
		Item* newItem = Item::CreateItem(itemId, stackCount);
		if (!newItem) {
			reportErrorFunc(L, getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
			pushBoolean(L, false);
			return 1;
		}

		if (it.stackable) {
			subType -= stackCount;
		}

		ReturnValue ret = g_game.internalAddItem(container, newItem);
		if (ret != RETURNVALUE_NOERROR) {
			delete newItem;
			pushBoolean(L, false);
			return 1;
		}

		if (--itemCount == 0) {
			if (newItem->getParent()) {
				lua_pushnumber(L, env->addThing(newItem));
			} else {
				//stackable item stacked with existing object, newItem will be released
				pushBoolean(L, false);
			}
			return 1;
		}
	}

	pushBoolean(L, false);
	return 1;
}

int LuaScriptInterface::luaGetDepotId(lua_State* L)
{
	//getDepotId(uid)
	uint32_t uid = getNumber<uint32_t>(L, -1);

	Container* container = getScriptEnv()->getContainerByUID(uid);
	if (!container) {
		reportErrorFunc(L, getErrorDesc(LUA_ERROR_CONTAINER_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	DepotLocker* depotLocker = container->getDepotLocker();
	if (!depotLocker) {
		reportErrorFunc(L, "Depot not found");
		pushBoolean(L, false);
		return 1;
	}

	lua_pushnumber(L, depotLocker->getDepotId());
	return 1;
}

int LuaScriptInterface::luaAddEvent(lua_State* L)
{
	//addEvent(callback, delay, ...)
	int parameters = lua_gettop(L);
	if (parameters < 2) {
		reportErrorFunc(L, fmt::format("Not enough parameters: {:d}.", parameters));
		pushBoolean(L, false);
		return 1;
	}

	if (!isFunction(L, 1)) {
		reportErrorFunc(L, "callback parameter should be a function.");
		pushBoolean(L, false);
		return 1;
	}

	if (!isNumber(L, 2)) {
		reportErrorFunc(L, "delay parameter should be a number.");
		pushBoolean(L, false);
		return 1;
	}

	if (g_config.getBoolean(ConfigManager::WARN_UNSAFE_SCRIPTS) || g_config.getBoolean(ConfigManager::CONVERT_UNSAFE_SCRIPTS)) {
		std::vector<std::pair<int32_t, LuaDataType>> indexes;
		for (int i = 3; i <= parameters; ++i) {
			if (lua_getmetatable(L, i) == 0) {
				continue;
			}
			lua_rawgeti(L, -1, 't');

			LuaDataType type = getNumber<LuaDataType>(L, -1);
			if (type != LuaData_Unknown && type != LuaData_Tile) {
				indexes.push_back({i, type});
			}
			lua_pop(L, 2);
		}

		if (!indexes.empty()) {
			if (g_config.getBoolean(ConfigManager::WARN_UNSAFE_SCRIPTS)) {
				bool plural = indexes.size() > 1;

				std::string warningString = "Argument";
				if (plural) {
					warningString += 's';
				}

				for (const auto& entry : indexes) {
					if (entry == indexes.front()) {
						warningString += ' ';
					} else if (entry == indexes.back()) {
						warningString += " and ";
					} else {
						warningString += ", ";
					}
					warningString += '#';
					warningString += std::to_string(entry.first);
				}

				if (plural) {
					warningString += " are unsafe";
				} else {
					warningString += " is unsafe";
				}

				reportErrorFunc(L, warningString);
			}

			if (g_config.getBoolean(ConfigManager::CONVERT_UNSAFE_SCRIPTS)) {
				for (const auto& entry : indexes) {
					switch (entry.second) {
						case LuaData_Item:
						case LuaData_Container:
						case LuaData_Teleport:
						case LuaData_Podium: {
							lua_getglobal(L, "Item");
							lua_getfield(L, -1, "getUniqueId");
							break;
						}
						case LuaData_Player:
						case LuaData_Monster:
						case LuaData_Npc: {
							lua_getglobal(L, "Creature");
							lua_getfield(L, -1, "getId");
							break;
						}
						default:
							break;
					}
					lua_replace(L, -2);
					lua_pushvalue(L, entry.first);
					lua_call(L, 1, 1);
					lua_replace(L, entry.first);
				}
			}
		}
	}

	LuaTimerEventDesc eventDesc;
	eventDesc.parameters.reserve(parameters - 2); // safe to use -2 since we garanteed that there is at least two parameters
	for (int i = 0; i < parameters - 2; ++i) {
		eventDesc.parameters.push_back(luaL_ref(L, LUA_REGISTRYINDEX));
	}

	uint32_t delay = std::max<uint32_t>(100, getNumber<uint32_t>(L, 2));
	lua_pop(L, 1);

	eventDesc.function = luaL_ref(L, LUA_REGISTRYINDEX);
	eventDesc.scriptId = getScriptEnv()->getScriptId();

	auto& lastTimerEventId = g_luaEnvironment.lastEventTimerId;
	eventDesc.eventId = g_scheduler.addEvent(createSchedulerTask(delay, [=]() { g_luaEnvironment.executeTimerEvent(lastTimerEventId); }));

	g_luaEnvironment.timerEvents.emplace(lastTimerEventId, std::move(eventDesc));
	lua_pushnumber(L, lastTimerEventId++);
	return 1;
}

int LuaScriptInterface::luaStopEvent(lua_State* L)
{
	//stopEvent(eventid)
	uint32_t eventId = getNumber<uint32_t>(L, 1);

	auto& timerEvents = g_luaEnvironment.timerEvents;
	auto it = timerEvents.find(eventId);
	if (it == timerEvents.end()) {
		pushBoolean(L, false);
		return 1;
	}

	LuaTimerEventDesc timerEventDesc = std::move(it->second);
	timerEvents.erase(it);

	g_scheduler.stopEvent(timerEventDesc.eventId);
	luaL_unref(L, LUA_REGISTRYINDEX, timerEventDesc.function);

	for (auto parameter : timerEventDesc.parameters) {
		luaL_unref(L, LUA_REGISTRYINDEX, parameter);
	}

	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaSaveServer(lua_State* L)
{
	g_game.saveGameState();
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaCleanMap(lua_State* L)
{
	lua_pushnumber(L, g_game.map.clean());
	return 1;
}

int LuaScriptInterface::luaIsInWar(lua_State* L)
{
	//isInWar(cid, target)
	Player* player = getPlayer(L, 1);
	if (!player) {
		reportErrorFunc(L, getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	Player* targetPlayer = getPlayer(L, 2);
	if (!targetPlayer) {
		reportErrorFunc(L, getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	pushBoolean(L, player->isInWar(targetPlayer));
	return 1;
}

int LuaScriptInterface::luaGetWaypointPositionByName(lua_State* L)
{
	//getWaypointPositionByName(name)
	auto& waypoints = g_game.map.waypoints;

	auto it = waypoints.find(getString(L, -1));
	if (it != waypoints.end()) {
		pushPosition(L, it->second);
	} else {
		pushBoolean(L, false);
	}
	return 1;
}

int LuaScriptInterface::luaSendChannelMessage(lua_State* L)
{
	//sendChannelMessage(channelId, type, message)
	uint32_t channelId = getNumber<uint32_t>(L, 1);
	ChatChannel* channel = g_chat->getChannelById(channelId);
	if (!channel) {
		pushBoolean(L, false);
		return 1;
	}

	MessageClasses type = getNumber<MessageClasses>(L, 2);
	std::string message = getString(L, 3);
	channel->sendToAll(message, type);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaSendGuildChannelMessage(lua_State* L)
{
	//sendGuildChannelMessage(guildId, type, message)
	uint32_t guildId = getNumber<uint32_t>(L, 1);
	ChatChannel* channel = g_chat->getGuildChannelById(guildId);
	if (!channel) {
		pushBoolean(L, false);
		return 1;
	}

	MessageClasses type = getNumber<MessageClasses>(L, 2);
	std::string message = getString(L, 3);
	channel->sendToAll(message, type);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaRefreshConsole(lua_State* L)
{
	// refreshConsole()
	// fixes unresponsive terminal (linux and git bash)
	std::cout << std::flush;
	lua_pushnil(L);
	return 1;
}
