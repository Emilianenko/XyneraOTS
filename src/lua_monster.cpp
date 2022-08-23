// Copyright 2022 Xynera.net. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "luascript.h"

#include "game.h"
#include "monster.h"

// Monster
int LuaScriptInterface::luaMonsterCreate(lua_State* L)
{
	// Monster(id or userdata)
	Monster* monster;
	if (isNumber(L, 2)) {
		monster = g_game.getMonsterByID(getNumber<uint32_t>(L, 2));
	} else if (isUserdata(L, 2)) {
		if (getUserdataType(L, 2) != LuaData_Monster) {
			lua_pushnil(L);
			return 1;
		}
		monster = getUserdata<Monster>(L, 2);
	} else {
		monster = nullptr;
	}

	if (monster) {
		pushUserdata<Monster>(L, monster);
		setMetatable(L, -1, "Monster");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterIsMonster(lua_State* L)
{
	// monster:isMonster()
	pushBoolean(L, getUserdata<const Monster>(L, 1) != nullptr);
	return 1;
}

int LuaScriptInterface::luaMonsterGetType(lua_State* L)
{
	// monster:getType()
	const Monster* monster = getUserdata<const Monster>(L, 1);
	if (monster) {
		pushUserdata<MonsterType>(L, monster->mType);
		setMetatable(L, -1, "MonsterType");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterRename(lua_State* L)
{
	// monster:rename(name[, nameDescription])
	Monster* monster = getUserdata<Monster>(L, 1);
	if (!monster) {
		lua_pushnil(L);
		return 1;
	}

	monster->setName(getString(L, 2));
	if (lua_gettop(L) >= 3) {
		monster->setNameDescription(getString(L, 3));
	}

	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaMonsterGetSpawnPosition(lua_State* L)
{
	// monster:getSpawnPosition()
	const Monster* monster = getUserdata<const Monster>(L, 1);
	if (monster) {
		pushPosition(L, monster->getMasterPos());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterIsInSpawnRange(lua_State* L)
{
	// monster:isInSpawnRange([position])
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		pushBoolean(L, monster->isInSpawnRange(lua_gettop(L) >= 2 ? getPosition(L, 2) : monster->getPosition()));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterIsIdle(lua_State* L)
{
	// monster:isIdle()
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		pushBoolean(L, monster->getIdleStatus());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSetIdle(lua_State* L)
{
	// monster:setIdle(idle)
	Monster* monster = getUserdata<Monster>(L, 1);
	if (!monster) {
		lua_pushnil(L);
		return 1;
	}

	monster->setIdle(getBoolean(L, 2));
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaMonsterIsFamiliar(lua_State* L)
{
	// monster:isFamiliar()
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		pushBoolean(L, monster->isFamiliar());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSetFamiliar(lua_State* L)
{
	// monster:setFamiliar(familiarStatus)
	Monster* monster = getUserdata<Monster>(L, 1);
	if (!monster) {
		lua_pushnil(L);
		return 1;
	}

	monster->setFamiliar(getBoolean(L, 2));
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaMonsterIsTarget(lua_State* L)
{
	// monster:isTarget(creature)
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		const Creature* creature = getCreature(L, 2);
		if (!creature) {
			reportErrorFunc(L, getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
			pushBoolean(L, false);
			return 1;
		}

		pushBoolean(L, monster->isTarget(creature));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterIsOpponent(lua_State* L)
{
	// monster:isOpponent(creature)
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		const Creature* creature = getCreature(L, 2);
		if (!creature) {
			reportErrorFunc(L, getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
			pushBoolean(L, false);
			return 1;
		}

		pushBoolean(L, monster->isOpponent(creature));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterIsFriend(lua_State* L)
{
	// monster:isFriend(creature)
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		const Creature* creature = getCreature(L, 2);
		if (!creature) {
			reportErrorFunc(L, getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
			pushBoolean(L, false);
			return 1;
		}

		pushBoolean(L, monster->isFriend(creature));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterAddFriend(lua_State* L)
{
	// monster:addFriend(creature)
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		Creature* creature = getCreature(L, 2);
		if (!creature) {
			reportErrorFunc(L, getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
			pushBoolean(L, false);
			return 1;
		}

		monster->addFriend(creature);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterRemoveFriend(lua_State* L)
{
	// monster:removeFriend(creature)
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		Creature* creature = getCreature(L, 2);
		if (!creature) {
			reportErrorFunc(L, getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
			pushBoolean(L, false);
			return 1;
		}

		monster->removeFriend(creature);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterGetFriendList(lua_State* L)
{
	// monster:getFriendList()
	Monster* monster = getUserdata<Monster>(L, 1);
	if (!monster) {
		lua_pushnil(L);
		return 1;
	}

	const auto& friendList = monster->getFriendList();
	lua_createtable(L, friendList.size(), 0);

	int index = 0;
	for (Creature* creature : friendList) {
		pushUserdata<Creature>(L, creature);
		setCreatureMetatable(L, -1, creature);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterGetFriendCount(lua_State* L)
{
	// monster:getFriendCount()
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		lua_pushnumber(L, monster->getFriendList().size());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterAddTarget(lua_State* L)
{
	// monster:addTarget(creature[, pushFront = false])
	Monster* monster = getUserdata<Monster>(L, 1);
	if (!monster) {
		lua_pushnil(L);
		return 1;
	}

	Creature* creature = getCreature(L, 2);
	if (!creature) {
		reportErrorFunc(L, getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	bool pushFront = getBoolean(L, 3, false);
	monster->addTarget(creature, pushFront);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaMonsterRemoveTarget(lua_State* L)
{
	// monster:removeTarget(creature)
	Monster* monster = getUserdata<Monster>(L, 1);
	if (!monster) {
		lua_pushnil(L);
		return 1;
	}

	Creature* creature = getCreature(L, 2);
	if (!creature) {
		reportErrorFunc(L, getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	monster->removeTarget(creature);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaMonsterGetTargetList(lua_State* L)
{
	// monster:getTargetList()
	Monster* monster = getUserdata<Monster>(L, 1);
	if (!monster) {
		lua_pushnil(L);
		return 1;
	}

	const auto& targetList = monster->getTargetList();
	lua_createtable(L, targetList.size(), 0);

	int index = 0;
	for (Creature* creature : targetList) {
		pushUserdata<Creature>(L, creature);
		setCreatureMetatable(L, -1, creature);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterGetTargetCount(lua_State* L)
{
	// monster:getTargetCount()
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		lua_pushnumber(L, monster->getTargetList().size());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSelectTarget(lua_State* L)
{
	// monster:selectTarget(creature)
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		Creature* creature = getCreature(L, 2);
		if (!creature) {
			reportErrorFunc(L, getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
			pushBoolean(L, false);
			return 1;
		}

		pushBoolean(L, monster->selectTarget(creature));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSearchTarget(lua_State* L)
{
	// monster:searchTarget([searchType = TARGETSEARCH_DEFAULT])
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		TargetSearchType_t searchType = getNumber<TargetSearchType_t>(L, 2, TARGETSEARCH_DEFAULT);
		pushBoolean(L, monster->searchTarget(searchType));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterIsWalkingToSpawn(lua_State* L)
{
	// monster:isWalkingToSpawn()
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		pushBoolean(L, monster->isWalkingToSpawn());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterWalkToSpawn(lua_State* L)
{
	// monster:walkToSpawn()
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		pushBoolean(L, monster->walkToSpawn());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterHasIcon(lua_State* L)
{
	// monster:hasMonsterIcon(iconId)
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		MonsterIcon_t iconId = getNumber<MonsterIcon_t>(L, 2);
		if (iconId < MONSTER_ICON_LAST) {
			pushBoolean(L, monster->hasMonsterIcon(iconId));
			return 1;
		}		
	}

	lua_pushnil(L);
	return 1;
}

int LuaScriptInterface::luaMonsterGetIconValue(lua_State* L)
{
	// monster:getMonsterIconValue(iconId)
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		MonsterIcon_t iconId = getNumber<MonsterIcon_t>(L, 2);
		if (iconId < MONSTER_ICON_LAST) {
			lua_pushnumber(L, monster->getMonsterIconValue(iconId));
			return 1;
		}
	}

	lua_pushnil(L);
	return 1;
}

int LuaScriptInterface::luaMonsterSetIconValue(lua_State* L)
{
	// monster:setMonsterIconValue(iconId, value)
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		MonsterIcon_t iconId = getNumber<MonsterIcon_t>(L, 2);
		if (iconId < MONSTER_ICON_LAST) {
			uint16_t value = getNumber<uint16_t>(L, 3);
			lua_pushnumber(L, monster->setMonsterIconValue(iconId, value));
			return 1;
		}
	}

	lua_pushnil(L);
	return 1;
}

int LuaScriptInterface::luaMonsterRemoveIcon(lua_State* L)
{
	// monster:removeMonsterIcon(iconId)
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		MonsterIcon_t iconId = getNumber<MonsterIcon_t>(L, 2);
		if (iconId < MONSTER_ICON_LAST) {
			pushBoolean(L, monster->removeMonsterIcon(iconId));
			return 1;
		}
	}

	lua_pushnil(L);
	return 1;
}
