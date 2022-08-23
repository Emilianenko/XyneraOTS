// Copyright 2022 Xynera.net. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "luascript.h"

#include "game.h"

// Group
int LuaScriptInterface::luaGroupCreate(lua_State* L)
{
	// Group(id)
	uint32_t id = getNumber<uint32_t>(L, 2);

	Group* group = g_game.groups.getGroup(id);
	if (group) {
		pushUserdata<Group>(L, group);
		setMetatable(L, -1, "Group");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGroupGetId(lua_State* L)
{
	// group:getId()
	Group* group = getUserdata<Group>(L, 1);
	if (group) {
		lua_pushnumber(L, group->id);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGroupGetName(lua_State* L)
{
	// group:getName()
	Group* group = getUserdata<Group>(L, 1);
	if (group) {
		pushString(L, group->name);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGroupGetFlags(lua_State* L)
{
	// group:getFlags()
	Group* group = getUserdata<Group>(L, 1);
	if (group) {
		lua_pushnumber(L, group->flags);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGroupGetAccess(lua_State* L)
{
	// group:getAccess()
	Group* group = getUserdata<Group>(L, 1);
	if (group) {
		pushBoolean(L, group->access);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGroupGetMaxDepotItems(lua_State* L)
{
	// group:getMaxDepotItems()
	Group* group = getUserdata<Group>(L, 1);
	if (group) {
		lua_pushnumber(L, group->maxDepotItems);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGroupGetMaxVipEntries(lua_State* L)
{
	// group:getMaxVipEntries()
	Group* group = getUserdata<Group>(L, 1);
	if (group) {
		lua_pushnumber(L, group->maxVipEntries);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGroupHasFlag(lua_State* L)
{
	// group:hasFlag(flag)
	Group* group = getUserdata<Group>(L, 1);
	if (group) {
		PlayerFlags flag = getNumber<PlayerFlags>(L, 2);
		pushBoolean(L, (group->flags & flag) != 0);
	} else {
		lua_pushnil(L);
	}
	return 1;
}
