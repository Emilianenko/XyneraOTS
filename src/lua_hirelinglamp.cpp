// Copyright 2022 Xynera.net. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "luascript.h"

#include "hirelinglamp.h"

// HirelingLamp
int LuaScriptInterface::luaHirelingLampCreate(lua_State* L)
{
	// HirelingLamp(uid)
	uint32_t id = getNumber<uint32_t>(L, 2);

	Item* item = getScriptEnv()->getItemByUID(id);
	if (item && item->getHirelingLamp()) {
		pushUserdata(L, item);
		setMetatable(L, -1, "HirelingLamp");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int32_t LuaScriptInterface::luaHirelingLampName(lua_State* L)
{
	// get: hirelingLamp:hirelingName() set: hirelingLamp:hirelingName(name)
	HirelingLamp* hirelingLamp = getUserdata<HirelingLamp>(L, 1);
	if (hirelingLamp) {
		if (lua_gettop(L) == 1) {
			pushString(L, hirelingLamp->getHirelingName());
		} else {
			hirelingLamp->setHirelingName(getString(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaHirelingLampSex(lua_State* L)
{
	// get: hirelingLamp:sex() set: hirelingLamp:sex(sex)
	HirelingLamp* hirelingLamp = getUserdata<HirelingLamp>(L, 1);
	if (hirelingLamp) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, hirelingLamp->getSex());
		} else {
			hirelingLamp->setSex(getNumber<uint8_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaHirelingLampOutfit(lua_State* L)
{
	// get: hirelingLamp:outfit() set: hirelingLamp:outfit(outfit)
	HirelingLamp* hirelingLamp = getUserdata<HirelingLamp>(L, 1);
	if (hirelingLamp) {
		if (lua_gettop(L) == 1) {
			pushOutfit(L, hirelingLamp->getOutfit());
		} else {
			hirelingLamp->setOutfit(getOutfit(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaHirelingLampFlags(lua_State* L)
{
	// get: hirelingLamp:flags() set: hirelingLamp:flags(flags)
	HirelingLamp* hirelingLamp = getUserdata<HirelingLamp>(L, 1);
	if (hirelingLamp) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, hirelingLamp->getFlags());
		} else {
			hirelingLamp->setFlags(getNumber<int32_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaHirelingLampDirection(lua_State* L)
{
	// get: hirelingLamp:direction() set: hirelingLamp:direction(direction)
	HirelingLamp* hirelingLamp = getUserdata<HirelingLamp>(L, 1);
	if (hirelingLamp) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, hirelingLamp->getDirection());
		} else {
			hirelingLamp->setDirection(static_cast<Direction>(getNumber<uint8_t>(L, 2)));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaHirelingLampUnpacked(lua_State* L)
{
	// get: hirelingLamp:unpacked() set: hirelingLamp:unpacked(unpacked)
	HirelingLamp* hirelingLamp = getUserdata<HirelingLamp>(L, 1);
	if (hirelingLamp) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, hirelingLamp->isUnpacked());
		} else {
			hirelingLamp->setUnpacked(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}
