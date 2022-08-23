// Copyright 2022 Xynera.net. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "luascript.h"

#include "monsters.h"

extern Monsters g_monsters;

// MonsterSpell
int LuaScriptInterface::luaCreateMonsterSpell(lua_State* L)
{
	// MonsterSpell() will create a new Monster Spell
	MonsterSpell* spell = new MonsterSpell();
	if (spell) {
		pushUserdata<MonsterSpell>(L, spell);
		setMetatable(L, -1, "MonsterSpell");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaDeleteMonsterSpell(lua_State* L)
{
	// monsterSpell:delete() monsterSpell:__gc()
	MonsterSpell** monsterSpellPtr = getRawUserdata<MonsterSpell>(L, 1);
	if (monsterSpellPtr && *monsterSpellPtr) {
		delete *monsterSpellPtr;
		*monsterSpellPtr = nullptr;
	}
	return 0;
}

int LuaScriptInterface::luaMonsterSpellSetType(lua_State* L)
{
	// monsterSpell:setType(type)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->name = getString(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetScriptName(lua_State* L)
{
	// monsterSpell:setScriptName(name)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->scriptName = getString(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetChance(lua_State* L)
{
	// monsterSpell:setChance(chance)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->chance = getNumber<uint8_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetInterval(lua_State* L)
{
	// monsterSpell:setInterval(interval)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->interval = getNumber<uint16_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetRange(lua_State* L)
{
	// monsterSpell:setRange(range)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->range = getNumber<uint8_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetCombatValue(lua_State* L)
{
	// monsterSpell:setCombatValue(min, max)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->minCombatValue = getNumber<int32_t>(L, 2);
		spell->maxCombatValue = getNumber<int32_t>(L, 3);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetCombatType(lua_State* L)
{
	// monsterSpell:setCombatType(combatType_t)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->combatType = getNumber<CombatType_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetAttackValue(lua_State* L)
{
	// monsterSpell:setAttackValue(attack, skill)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->attack = getNumber<int32_t>(L, 2);
		spell->skill = getNumber<int32_t>(L, 3);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetNeedTarget(lua_State* L)
{
	// monsterSpell:setNeedTarget(bool)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->needTarget = getBoolean(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetNeedDirection(lua_State* L)
{
	// monsterSpell:setNeedDirection(bool)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->needDirection = getBoolean(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetCombatLength(lua_State* L)
{
	// monsterSpell:setCombatLength(length)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->length = getNumber<int32_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetCombatSpread(lua_State* L)
{
	// monsterSpell:setCombatSpread(spread)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->spread = getNumber<int32_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetCombatRadius(lua_State* L)
{
	// monsterSpell:setCombatRadius(radius)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->radius = getNumber<int32_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetCombatRing(lua_State* L)
{
	// monsterSpell:setCombatRing(ring)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->ring = getNumber<int32_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetConditionType(lua_State* L)
{
	// monsterSpell:setConditionType(type)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->conditionType = getNumber<ConditionType_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetConditionDamage(lua_State* L)
{
	// monsterSpell:setConditionDamage(min, max, start)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->conditionMinDamage = getNumber<int32_t>(L, 2);
		spell->conditionMaxDamage = getNumber<int32_t>(L, 3);
		spell->conditionStartDamage = getNumber<int32_t>(L, 4);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetConditionSpeedChange(lua_State* L)
{
	// monsterSpell:setConditionSpeedChange(minSpeed[, maxSpeed])
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->minSpeedChange = getNumber<int32_t>(L, 2);
		spell->maxSpeedChange = getNumber<int32_t>(L, 3, 0);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetConditionDuration(lua_State* L)
{
	// monsterSpell:setConditionDuration(duration)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->duration = getNumber<int32_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetConditionDrunkenness(lua_State* L)
{
	// monsterSpell:setConditionDrunkenness(drunkenness)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->drunkenness = getNumber<uint8_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetConditionTickInterval(lua_State* L)
{
	// monsterSpell:setConditionTickInterval(interval)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->tickInterval = getNumber<int32_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetCombatShootEffect(lua_State* L)
{
	// monsterSpell:setCombatShootEffect(effect)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->shoot = getNumber<ShootType_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetCombatEffect(lua_State* L)
{
	// monsterSpell:setCombatEffect(effect)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->effect = getNumber<MagicEffectClasses>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetOutfit(lua_State* L)
{
	// monsterSpell:setOutfit(outfit)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		if (isTable(L, 2)) {
			spell->outfit = getOutfit(L, 2);
		} else if (isNumber(L, 2)) {
			spell->outfit.lookTypeEx = getNumber<uint16_t>(L, 2);
		} else if (isString(L, 2)) {
			MonsterType* mType = g_monsters.getMonsterType(getString(L, 2));
			if (mType) {
				spell->outfit = mType->info.outfit;
			}
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}
