// Copyright 2022 Xynera.net. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "luascript.h"

#include "vocation.h"

extern Vocations g_vocations;

// Vocation
int LuaScriptInterface::luaVocationCreate(lua_State* L)
{
	// Vocation(id or name)
	uint32_t id;
	if (isNumber(L, 2)) {
		id = getNumber<uint32_t>(L, 2);
	} else {
		id = g_vocations.getVocationId(getString(L, 2));
	}

	Vocation* vocation = g_vocations.getVocation(id);
	if (vocation) {
		pushUserdata<Vocation>(L, vocation);
		setMetatable(L, -1, "Vocation");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationGetId(lua_State* L)
{
	// vocation:getId()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getId());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationGetClientId(lua_State* L)
{
	// vocation:getClientId()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getClientId());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationGetName(lua_State* L)
{
	// vocation:getName()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		pushString(L, vocation->getVocName());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationGetDescription(lua_State* L)
{
	// vocation:getDescription()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		pushString(L, vocation->getVocDescription());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationGetRequiredSkillTries(lua_State* L)
{
	// vocation:getRequiredSkillTries(skillType, skillLevel)
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		skills_t skillType = getNumber<skills_t>(L, 2);
		uint16_t skillLevel = getNumber<uint16_t>(L, 3);
		lua_pushnumber(L, vocation->getReqSkillTries(skillType, skillLevel));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationGetRequiredManaSpent(lua_State* L)
{
	// vocation:getRequiredManaSpent(magicLevel)
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		uint32_t magicLevel = getNumber<uint32_t>(L, 2);
		lua_pushnumber(L, vocation->getReqMana(magicLevel));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationGetCapacityGain(lua_State* L)
{
	// vocation:getCapacityGain()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getCapGain());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationGetHealthGain(lua_State* L)
{
	// vocation:getHealthGain()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getHPGain());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationGetHealthGainTicks(lua_State* L)
{
	// vocation:getHealthGainTicks()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getHealthGainTicks());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationGetHealthGainAmount(lua_State* L)
{
	// vocation:getHealthGainAmount()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getHealthGainAmount());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationGetManaGain(lua_State* L)
{
	// vocation:getManaGain()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getManaGain());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationGetManaGainTicks(lua_State* L)
{
	// vocation:getManaGainTicks()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getManaGainTicks());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationGetManaGainAmount(lua_State* L)
{
	// vocation:getManaGainAmount()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getManaGainAmount());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationGetMaxSoul(lua_State* L)
{
	// vocation:getMaxSoul()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getSoulMax());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationGetSoulGainTicks(lua_State* L)
{
	// vocation:getSoulGainTicks()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getSoulGainTicks());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationGetAttackSpeed(lua_State* L)
{
	// vocation:getAttackSpeed()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getAttackSpeed());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationGetBaseSpeed(lua_State* L)
{
	// vocation:getBaseSpeed()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getBaseSpeed());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationGetDemotion(lua_State* L)
{
	// vocation:getDemotion()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (!vocation) {
		lua_pushnil(L);
		return 1;
	}

	uint16_t fromId = vocation->getFromVocation();
	if (fromId == VOCATION_NONE) {
		lua_pushnil(L);
		return 1;
	}

	Vocation* demotedVocation = g_vocations.getVocation(fromId);
	if (demotedVocation && demotedVocation != vocation) {
		pushUserdata<Vocation>(L, demotedVocation);
		setMetatable(L, -1, "Vocation");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationGetPromotion(lua_State* L)
{
	// vocation:getPromotion()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (!vocation) {
		lua_pushnil(L);
		return 1;
	}

	uint16_t promotedId = g_vocations.getPromotedVocation(vocation->getId());
	if (promotedId == VOCATION_NONE) {
		lua_pushnil(L);
		return 1;
	}

	Vocation* promotedVocation = g_vocations.getVocation(promotedId);
	if (promotedVocation && promotedVocation != vocation) {
		pushUserdata<Vocation>(L, promotedVocation);
		setMetatable(L, -1, "Vocation");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationAllowsPvp(lua_State* L)
{
	// vocation:allowsPvp()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		pushBoolean(L, vocation->allowsPvp());
	} else {
		lua_pushnil(L);
	}
	return 1;
}
