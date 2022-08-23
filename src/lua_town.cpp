// Copyright 2022 Xynera.net. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "luascript.h"

#include "game.h"
#include "town.h"

// Town
int LuaScriptInterface::luaTownCreate(lua_State* L)
{
	// Town(id or name)
	Town* town;
	if (isNumber(L, 2)) {
		town = g_game.map.towns.getTown(getNumber<uint32_t>(L, 2));
	} else if (isString(L, 2)) {
		town = g_game.map.towns.getTown(getString(L, 2));
	} else {
		town = nullptr;
	}

	if (town) {
		pushUserdata<Town>(L, town);
		setMetatable(L, -1, "Town");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaTownGetId(lua_State* L)
{
	// town:getId()
	Town* town = getUserdata<Town>(L, 1);
	if (town) {
		lua_pushnumber(L, town->getID());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaTownGetName(lua_State* L)
{
	// town:getName()
	Town* town = getUserdata<Town>(L, 1);
	if (town) {
		pushString(L, town->getName());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaTownGetTemplePosition(lua_State* L)
{
	// town:getTemplePosition()
	Town* town = getUserdata<Town>(L, 1);
	if (town) {
		pushPosition(L, town->getTemplePosition());
	} else {
		lua_pushnil(L);
	}
	return 1;
}
