// Copyright 2022 Xynera.net. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "luascript.h"

#include "game.h"
#include "podium.h"

// Podium
int LuaScriptInterface::luaPodiumCreate(lua_State* L)
{
	// Podium(uid)
	uint32_t id = getNumber<uint32_t>(L, 2);

	Item* item = getScriptEnv()->getItemByUID(id);
	if (item && item->getPodium()) {
		pushUserdata(L, item);
		setMetatable(L, -1, "Podium");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPodiumGetOutfit(lua_State* L)
{
	// podium:getOutfit()
	const Podium* podium = getUserdata<const Podium>(L, 1);
	if (podium) {
		pushOutfit(L, podium->getOutfit());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPodiumSetOutfit(lua_State* L)
{
	// podium:setOutfit(outfit)
	Podium* podium = getUserdata<Podium>(L, 1);
	if (podium) {
		podium->setOutfit(getOutfit(L, 2));
		g_game.updatePodium(podium);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPodiumHasFlag(lua_State* L)
{
	// podium:hasFlag(flag)
	Podium* podium = getUserdata<Podium>(L, 1);
	if (podium) {
		PodiumFlags flag = getNumber<PodiumFlags>(L, 2);
		pushBoolean(L, podium->hasFlag(flag));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPodiumSetFlag(lua_State* L)
{
	// podium:setFlag(flag, value)
	uint8_t value = getBoolean(L, 3);
	PodiumFlags flag = getNumber<PodiumFlags>(L, 2);
	Podium* podium = getUserdata<Podium>(L, 1);

	if (podium) {
		podium->setFlagValue(flag, value);
		g_game.updatePodium(podium);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPodiumGetDirection(lua_State* L)
{
	// podium:getDirection()
	const Podium* podium = getUserdata<const Podium>(L, 1);
	if (podium) {
		lua_pushnumber(L, podium->getDirection());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPodiumSetDirection(lua_State* L)
{
	// podium:setDirection(direction)
	Podium* podium = getUserdata<Podium>(L, 1);
	if (podium) {
		podium->setDirection(getNumber<Direction>(L, 2));
		g_game.updatePodium(podium);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}
