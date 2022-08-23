// Copyright 2022 Xynera.net. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "luascript.h"

#include "combat.h"
#include "creature.h"
#include "game.h"
#include "luavariant.h"

extern LuaEnvironment g_luaEnvironment;

// Combat
int LuaScriptInterface::luaCombatCreate(lua_State* L)
{
	// Combat()
	pushSharedPtr(L, g_luaEnvironment.createCombatObject(getScriptEnv()->getScriptInterface()));
	setMetatable(L, -1, "Combat");
	return 1;
}

int LuaScriptInterface::luaCombatDelete(lua_State* L)
{
	Combat_ptr& combat = getSharedPtr<Combat>(L, 1);
	if (combat) {
		combat.reset();
	}
	return 0;
}

int LuaScriptInterface::luaCombatSetParameter(lua_State* L)
{
	// combat:setParameter(key, value)
	const Combat_ptr& combat = getSharedPtr<Combat>(L, 1);
	if (!combat) {
		reportErrorFunc(L, getErrorDesc(LUA_ERROR_COMBAT_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	CombatParam_t key = getNumber<CombatParam_t>(L, 2);
	uint32_t value;
	if (isBoolean(L, 3)) {
		value = getBoolean(L, 3) ? 1 : 0;
	} else {
		value = getNumber<uint32_t>(L, 3);
	}
	combat->setParam(key, value);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaCombatGetParameter(lua_State* L)
{
	// combat:getParameter(key)
	Combat* combat = getUserdata<Combat>(L, 1);
	if (!combat) {
		lua_pushnil(L);
		return 1;
	}

	int32_t value = combat->getParam(getNumber<CombatParam_t>(L, 2));
	if (value == std::numeric_limits<int32_t>().max()) {
		lua_pushnil(L);
		return 1;
	}

	lua_pushnumber(L, value);
	return 1;
}

int LuaScriptInterface::luaCombatSetFormula(lua_State* L)
{
	// combat:setFormula(type, mina, minb, maxa, maxb)
	const Combat_ptr& combat = getSharedPtr<Combat>(L, 1);
	if (!combat) {
		reportErrorFunc(L, getErrorDesc(LUA_ERROR_COMBAT_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	formulaType_t type = getNumber<formulaType_t>(L, 2);
	double mina = getNumber<double>(L, 3);
	double minb = getNumber<double>(L, 4);
	double maxa = getNumber<double>(L, 5);
	double maxb = getNumber<double>(L, 6);
	combat->setPlayerCombatValues(type, mina, minb, maxa, maxb);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaCombatSetArea(lua_State* L)
{
	// combat:setArea(area)
	if (getScriptEnv()->getScriptId() != EVENT_ID_LOADING) {
		reportErrorFunc(L, "This function can only be used while loading the script.");
		lua_pushnil(L);
		return 1;
	}

	const AreaCombat* area = g_luaEnvironment.getAreaObject(getNumber<uint32_t>(L, 2));
	if (!area) {
		reportErrorFunc(L, getErrorDesc(LUA_ERROR_AREA_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	const Combat_ptr& combat = getSharedPtr<Combat>(L, 1);
	if (!combat) {
		reportErrorFunc(L, getErrorDesc(LUA_ERROR_COMBAT_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	combat->setArea(new AreaCombat(*area));
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaCombatAddCondition(lua_State* L)
{
	// combat:addCondition(condition)
	const Combat_ptr& combat = getSharedPtr<Combat>(L, 1);
	if (!combat) {
		reportErrorFunc(L, getErrorDesc(LUA_ERROR_COMBAT_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	Condition* condition = getUserdata<Condition>(L, 2);
	if (condition) {
		combat->addCondition(condition->clone());
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCombatClearConditions(lua_State* L)
{
	// combat:clearConditions()
	const Combat_ptr& combat = getSharedPtr<Combat>(L, 1);
	if (!combat) {
		reportErrorFunc(L, getErrorDesc(LUA_ERROR_COMBAT_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	combat->clearConditions();
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaCombatSetCallback(lua_State* L)
{
	// combat:setCallback(key, function)
	const Combat_ptr& combat = getSharedPtr<Combat>(L, 1);
	if (!combat) {
		reportErrorFunc(L, getErrorDesc(LUA_ERROR_COMBAT_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	CallBackParam_t key = getNumber<CallBackParam_t>(L, 2);
	if (!combat->setCallback(key)) {
		lua_pushnil(L);
		return 1;
	}

	CallBack* callback = combat->getCallback(key);
	if (!callback) {
		lua_pushnil(L);
		return 1;
	}

	const std::string& function = getString(L, 3);
	pushBoolean(L, callback->loadCallBack(getScriptEnv()->getScriptInterface(), function));
	return 1;
}

int LuaScriptInterface::luaCombatSetOrigin(lua_State* L)
{
	// combat:setOrigin(origin)
	const Combat_ptr& combat = getSharedPtr<Combat>(L, 1);
	if (!combat) {
		reportErrorFunc(L, getErrorDesc(LUA_ERROR_COMBAT_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	combat->setOrigin(getNumber<CombatOrigin>(L, 2));
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaCombatExecute(lua_State* L)
{
	// combat:execute(creature, variant)
	const Combat_ptr& combat = getSharedPtr<Combat>(L, 1);
	if (!combat) {
		reportErrorFunc(L, getErrorDesc(LUA_ERROR_COMBAT_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	if (isUserdata(L, 2)) {
		LuaDataType type = getUserdataType(L, 2);
		if (type != LuaData_Player && type != LuaData_Monster && type != LuaData_Npc) {
			pushBoolean(L, false);
			return 1;
		}
	}

	Creature* creature = getCreature(L, 2);

	const LuaVariant& variant = getVariant(L, 3);
	switch (variant.type()) {
		case VARIANT_NUMBER: {
			Creature* target = g_game.getCreatureByID(variant.getNumber());
			if (!target) {
				pushBoolean(L, false);
				return 1;
			}

			if (combat->hasArea()) {
				combat->doCombat(creature, target->getPosition());
			} else {
				combat->doCombat(creature, target);
			}
			break;
		}

		case VARIANT_POSITION: {
			combat->doCombat(creature, variant.getPosition());
			break;
		}

		case VARIANT_TARGETPOSITION: {
			if (combat->hasArea()) {
				combat->doCombat(creature, variant.getTargetPosition());
			} else {
				combat->postCombatEffects(creature, variant.getTargetPosition());
				g_game.addMagicEffect(variant.getTargetPosition(), CONST_ME_POFF);
			}
			break;
		}

		case VARIANT_STRING: {
			Player* target = g_game.getPlayerByName(variant.getString());
			if (!target) {
				pushBoolean(L, false);
				return 1;
			}

			combat->doCombat(creature, target);
			break;
		}

		case VARIANT_NONE: {
			reportErrorFunc(L, getErrorDesc(LUA_ERROR_VARIANT_NOT_FOUND));
			pushBoolean(L, false);
			return 1;
		}

		default: {
			break;
		}
	}

	pushBoolean(L, true);
	return 1;
}
