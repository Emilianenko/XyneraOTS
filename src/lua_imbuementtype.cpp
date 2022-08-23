// Copyright 2022 Xynera.net. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "luascript.h"

#include "imbuing.h"

extern Imbuements g_imbuements;

// ImbuementType
int LuaScriptInterface::luaImbuementTypeCreate(lua_State* L)
{
	// ImbuementType(id)
	ImbuementType* imbuementType = g_imbuements.getImbuementType(getNumber<uint8_t>(L, 2));
	if (imbuementType) {
		pushUserdata<ImbuementType>(L, imbuementType);
		setMetatable(L, -1, "ImbuementType");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaImbuementTypeName(lua_State* L)
{
	// get: imbuementType:name() set: imbuementType:name(name)
	ImbuementType* imbuementType = getUserdata<ImbuementType>(L, 1);
	if (imbuementType) {
		if (lua_gettop(L) == 1) {
			pushString(L, imbuementType->getName());
		} else {
			imbuementType->setName(getString(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaImbuementTypeDescription(lua_State* L)
{
	// get: imbuementType:description() set: imbuementType:description(description)
	ImbuementType* imbuementType = getUserdata<ImbuementType>(L, 1);
	if (imbuementType) {
		if (lua_gettop(L) == 1) {
			pushString(L, imbuementType->getDescription());
		} else {
			imbuementType->setDescription(getString(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaImbuementTypeType(lua_State* L)
{
	// get: imbuementType:type() set: imbuementType:type(type)
	ImbuementType* imbuementType = getUserdata<ImbuementType>(L, 1);
	if (imbuementType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, imbuementType->getType());
		} else {
			imbuementType->setType(getNumber<int8_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaImbuementTypeIconId(lua_State* L)
{
	// get: imbuementType:icon() set: imbuementType:icon(icon)
	ImbuementType* imbuementType = getUserdata<ImbuementType>(L, 1);
	if (imbuementType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, imbuementType->getIconId());
		} else {
			imbuementType->setIconId(getNumber<int8_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaImbuementTypePrimaryValue(lua_State* L)
{
	// get: imbuementType:primaryValue() set: imbuementType:primaryValue(primaryValue)
	ImbuementType* imbuementType = getUserdata<ImbuementType>(L, 1);
	if (imbuementType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, imbuementType->getPrimaryValue());
		} else {
			imbuementType->setPrimaryValue(getNumber<int32_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaImbuementTypeSecondaryValue(lua_State* L)
{
	// get: imbuementType:secondaryValue() set: imbuementType:secondaryValue(secondaryValue)
	ImbuementType* imbuementType = getUserdata<ImbuementType>(L, 1);
	if (imbuementType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, imbuementType->getSecondaryValue());
		} else {
			imbuementType->setSecondaryValue(getNumber<int32_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaImbuementTypeDuration(lua_State* L)
{
	// get: imbuementType:duration() set: imbuementType:duration(duration)
	ImbuementType* imbuementType = getUserdata<ImbuementType>(L, 1);
	if (imbuementType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, imbuementType->getDuration());
		} else {
			imbuementType->setDuration(getNumber<int32_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaImbuementTypeOutOfCombat(lua_State* L)
{
	// get: imbuementType:outOfCombat() set: imbuementType:outOfCombat(outOfCombat)
	ImbuementType* imbuementType = getUserdata<ImbuementType>(L, 1);
	if (imbuementType) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, imbuementType->isOutOfCombat());
		} else {
			imbuementType->setOutOfCombat(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}
