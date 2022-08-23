// Copyright 2022 Xynera.net. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "luascript.h"

#include "iomarket.h"
#include "item.h"
#include "items.h"

// ItemType
int LuaScriptInterface::luaItemTypeCreate(lua_State* L)
{
	// ItemType(id or name)
	uint32_t id;
	if (isNumber(L, 2)) {
		id = getNumber<uint32_t>(L, 2);
	} else if (isString(L, 2)) {
		id = Item::items.getItemIdByName(getString(L, 2));
	} else {
		lua_pushnil(L);
		return 1;
	}

	const ItemType& itemType = Item::items[id];
	pushUserdata<const ItemType>(L, &itemType);
	setMetatable(L, -1, "ItemType");
	return 1;
}

int LuaScriptInterface::luaItemTypeIsCorpse(lua_State* L)
{
	// itemType:isCorpse()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->corpseType != RACE_NONE);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeIsDoor(lua_State* L)
{
	// itemType:isDoor()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->isDoor());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeIsContainer(lua_State* L)
{
	// itemType:isContainer()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->isContainer());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeIsFluidContainer(lua_State* L)
{
	// itemType:isFluidContainer()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->isFluidContainer());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeIsMovable(lua_State* L)
{
	// itemType:isMovable()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->moveable);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeIsRune(lua_State* L)
{
	// itemType:isRune()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->isRune());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeIsStackable(lua_State* L)
{
	// itemType:isStackable()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->stackable);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeIsReadable(lua_State* L)
{
	// itemType:isReadable()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->canReadText);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeIsWritable(lua_State* L)
{
	// itemType:isWritable()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->canWriteText);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeIsBlocking(lua_State* L)
{
	// itemType:isBlocking()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->blockProjectile || itemType->blockSolid);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeIsGroundTile(lua_State* L)
{
	// itemType:isGroundTile()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->isGroundTile());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeIsMagicField(lua_State* L)
{
	// itemType:isMagicField()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->isMagicField());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeIsUseable(lua_State* L)
{
	// itemType:isUseable()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->isUseable());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeIsPickupable(lua_State* L)
{
	// itemType:isPickupable()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->isPickupable());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetType(lua_State* L)
{
	// itemType:getType()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->type);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetGroup(lua_State* L)
{
	// itemType:getGroup()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->group);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetId(lua_State* L)
{
	// itemType:getId()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->id);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetClientId(lua_State* L)
{
	// itemType:getClientId()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->clientId);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetRotateId(lua_State* L)
{
	// itemType:getRotateId()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType && itemType->rotatable) {
		lua_pushnumber(L, itemType->rotateTo);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetWareId(lua_State* L)
{
	// itemType:getWareId()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->wareId);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetName(lua_State* L)
{
	// itemType:getName()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushString(L, itemType->name);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetPluralName(lua_State* L)
{
	// itemType:getPluralName()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushString(L, itemType->getPluralName());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetArticle(lua_State* L)
{
	// itemType:getArticle()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushString(L, itemType->article);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetDescription(lua_State* L)
{
	// itemType:getDescription()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushString(L, itemType->description);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetSlotPosition(lua_State *L)
{
	// itemType:getSlotPosition()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->slotPosition);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetCharges(lua_State* L)
{
	// itemType:getCharges()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->charges);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetFluidSource(lua_State* L)
{
	// itemType:getFluidSource()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->fluidSource);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetCapacity(lua_State* L)
{
	// itemType:getCapacity()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->maxItems);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetWeight(lua_State* L)
{
	// itemType:getWeight([count = 1])
	uint16_t count = getNumber<uint16_t>(L, 2, 1);

	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (!itemType) {
		lua_pushnil(L);
		return 1;
	}

	uint64_t weight = static_cast<uint64_t>(itemType->weight) * std::max<int32_t>(1, count);
	lua_pushnumber(L, weight);
	return 1;
}

int LuaScriptInterface::luaItemTypeGetWorth(lua_State* L)
{
	// itemType:getWorth()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (!itemType) {
		lua_pushnil(L);
		return 1;
	}

	lua_pushnumber(L, itemType->worth);
	return 1;
}

int LuaScriptInterface::luaItemTypeGetHitChance(lua_State* L)
{
	// itemType:getHitChance()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->hitChance);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetShootRange(lua_State* L)
{
	// itemType:getShootRange()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->shootRange);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetAttack(lua_State* L)
{
	// itemType:getAttack()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->attack);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetAttackSpeed(lua_State* L)
{
	// itemType:getAttackSpeed()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->attackSpeed);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetDefense(lua_State* L)
{
	// itemType:getDefense()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->defense);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetExtraDefense(lua_State* L)
{
	// itemType:getExtraDefense()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->extraDefense);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetArmor(lua_State* L)
{
	// itemType:getArmor()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->armor);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetWeaponType(lua_State* L)
{
	// itemType:getWeaponType()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->weaponType);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetAmmoType(lua_State* L)
{
	// itemType:getAmmoType()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->ammoType);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetCorpseType(lua_State* L)
{
	// itemType:getCorpseType()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->corpseType);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetClassification(lua_State* L)
{
	// itemType:getClassification()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->classification);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetAbilities(lua_State* L)
{
	// itemType:getAbilities()
	ItemType* itemType = getUserdata<ItemType>(L, 1);
	if (itemType) {
		Abilities& abilities = itemType->getAbilities();
		lua_createtable(L, 6, 12);
		setField(L, "healthGain", abilities.healthGain);
		setField(L, "healthTicks", abilities.healthTicks);
		setField(L, "manaGain", abilities.manaGain);
		setField(L, "manaTicks", abilities.manaTicks);
		setField(L, "conditionImmunities", abilities.conditionImmunities);
		setField(L, "conditionSuppressions", abilities.conditionSuppressions);
		setField(L, "speed", abilities.speed);
		setField(L, "elementDamage", abilities.elementDamage);
		setField(L, "elementType", abilities.elementType);

		lua_pushboolean(L, abilities.manaShield);
		lua_setfield(L, -2, "manaShield");
		lua_pushboolean(L, abilities.invisible);
		lua_setfield(L, -2, "invisible");
		lua_pushboolean(L, abilities.regeneration);
		lua_setfield(L, -2, "regeneration");

		// Stats
		lua_createtable(L, 0, STAT_LAST + 1);
		for (int32_t i = STAT_FIRST; i <= STAT_LAST; i++) {
			lua_pushnumber(L, abilities.stats[i]);
			lua_rawseti(L, -2, i + 1);
		}
		lua_setfield(L, -2, "stats");

		// Stats percent
		lua_createtable(L, 0, STAT_LAST + 1);
		for (int32_t i = STAT_FIRST; i <= STAT_LAST; i++) {
			lua_pushnumber(L, abilities.statsPercent[i]);
			lua_rawseti(L, -2, i + 1);
		}
		lua_setfield(L, -2, "statsPercent");

		// Skills
		lua_createtable(L, 0, SKILL_LAST + 1);
		for (int32_t i = SKILL_FIRST; i <= SKILL_LAST; i++) {
			lua_pushnumber(L, abilities.skills[i]);
			lua_rawseti(L, -2, i + 1);
		}
		lua_setfield(L, -2, "skills");

		// Special skills
		lua_createtable(L, 0, SPECIALSKILL_LAST + 1);
		for (int32_t i = SPECIALSKILL_FIRST; i <= SPECIALSKILL_LAST; i++) {
			lua_pushnumber(L, abilities.specialSkills[i]);
			lua_rawseti(L, -2, i + 1);
		}
		lua_setfield(L, -2, "specialSkills");

		// Specialized magic level
		lua_createtable(L, 0, COMBAT_COUNT);
		for (int32_t i = 0; i < COMBAT_COUNT; i++) {
			lua_pushnumber(L, abilities.specialMagicLevelSkill[i]);
			lua_rawseti(L, -2, i + 1);
		}
		lua_setfield(L, -2, "specialMagicLevel");

		// Field absorb percent
		lua_createtable(L, 0, COMBAT_COUNT);
		for (int32_t i = 0; i < COMBAT_COUNT; i++) {
			lua_pushnumber(L, abilities.fieldAbsorbPercent[i]);
			lua_rawseti(L, -2, i + 1);
		}
		lua_setfield(L, -2, "fieldAbsorbPercent");

		// Absorb percent
		lua_createtable(L, 0, COMBAT_COUNT);
		for (int32_t i = 0; i < COMBAT_COUNT; i++) {
			lua_pushnumber(L, abilities.absorbPercent[i]);
			lua_rawseti(L, -2, i + 1);
		}
		lua_setfield(L, -2, "absorbPercent");

		// Damage boost percent
		lua_createtable(L, 0, COMBAT_COUNT);
		for (int32_t i = 0; i < COMBAT_COUNT; i++) {
			lua_pushnumber(L, abilities.boostPercent[i]);
			lua_rawseti(L, -2, i + 1);
		}
		lua_setfield(L, -2, "boostPercent");

		//// Reflect
		// chance
		lua_createtable(L, 0, COMBAT_COUNT);
		for (int32_t i = 0; i < COMBAT_COUNT; i++) {
			lua_pushnumber(L, abilities.reflect[i].chance);
			lua_rawseti(L, -2, i + 1);
		}
		lua_setfield(L, -2, "reflectChance");

		// percent
		lua_createtable(L, 0, COMBAT_COUNT);
		for (int32_t i = 0; i < COMBAT_COUNT; i++) {
			lua_pushnumber(L, abilities.reflect[i].percent);
			lua_rawseti(L, -2, i + 1);
		}
		lua_setfield(L, -2, "reflectPercent");
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeHasShowAttributes(lua_State* L)
{
	// itemType:hasShowAttributes()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->showAttributes);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeHasShowCount(lua_State* L)
{
	// itemType:hasShowCount()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->showCount);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeHasShowCharges(lua_State* L)
{
	// itemType:hasShowCharges()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->showCharges);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeHasShowDuration(lua_State* L)
{
	// itemType:hasShowDuration()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->showDuration);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeHasAllowDistRead(lua_State* L)
{
	// itemType:hasAllowDistRead()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->allowDistRead);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetWieldInfo(lua_State* L)
{
	// itemType:getWieldInfo()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushinteger(L, itemType->wieldInfo);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetDuration(lua_State* L)
{
	// itemType:getDuration()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushinteger(L, itemType->decayTime);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetLevelDoor(lua_State* L)
{
	// itemType:getLevelDoor()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushinteger(L, itemType->levelDoor);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetRuneSpellName(lua_State* L)
{
	// itemType:getRuneSpellName()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType && itemType->isRune()) {
		pushString(L, itemType->runeSpellName);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetVocationString(lua_State* L)
{
	// itemType:getVocationString()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushString(L, itemType->vocationString);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetMinReqLevel(lua_State* L)
{
	// itemType:getMinReqLevel()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushinteger(L, itemType->minReqLevel);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetMinReqMagicLevel(lua_State* L)
{
	// itemType:getMinReqMagicLevel()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushinteger(L, itemType->minReqMagicLevel);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetMarketBuyStatistics(lua_State* L)
{
	// itemType:getMarketBuyStatistics(tier)
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	uint8_t tier = getNumber<uint8_t>(L, 2);

	if (itemType) {
		MarketStatistics* statistics = IOMarket::getInstance().getPurchaseStatistics(itemType->id, tier);
		if (statistics) {
			lua_createtable(L, 4, 0);
			setField(L, "numTransactions", statistics->numTransactions);
			setField(L, "totalPrice", statistics->totalPrice);
			setField(L, "highestPrice", statistics->highestPrice);
			setField(L, "lowestPrice", statistics->lowestPrice);
		} else {
			lua_pushnil(L);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetMarketSellStatistics(lua_State* L)
{
	// itemType:getMarketSellStatistics(tier)
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	uint8_t tier = getNumber<uint8_t>(L, 2);

	if (itemType) {
		MarketStatistics* statistics = IOMarket::getInstance().getSaleStatistics(itemType->id, tier);
		if (statistics) {
			lua_createtable(L, 4, 0);
			setField(L, "numTransactions", statistics->numTransactions);
			setField(L, "totalPrice", statistics->totalPrice);
			setField(L, "highestPrice", statistics->highestPrice);
			setField(L, "lowestPrice", statistics->lowestPrice);
		} else {
			lua_pushnil(L);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetElementType(lua_State* L)
{
	// itemType:getElementType()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (!itemType) {
		lua_pushnil(L);
		return 1;
	}

	auto& abilities = itemType->abilities;
	if (abilities) {
		lua_pushnumber(L, abilities->elementType);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetElementDamage(lua_State* L)
{
	// itemType:getElementDamage()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (!itemType) {
		lua_pushnil(L);
		return 1;
	}

	auto& abilities = itemType->abilities;
	if (abilities) {
		lua_pushnumber(L, abilities->elementDamage);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetTransformEquipId(lua_State* L)
{
	// itemType:getTransformEquipId()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->transformEquipTo);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetTransformDeEquipId(lua_State* L)
{
	// itemType:getTransformDeEquipId()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->transformDeEquipTo);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetDestroyId(lua_State* L)
{
	// itemType:getDestroyId()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->destroyTo);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetDecayId(lua_State* L)
{
	// itemType:getDecayId()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->decayTo);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetRequiredLevel(lua_State* L)
{
	// itemType:getRequiredLevel()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->minReqLevel);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeHasSubType(lua_State* L)
{
	// itemType:hasSubType()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->hasSubType());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeIsStoreItem(lua_State* L)
{
	// itemType:isStoreItem()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->storeItem);
	} else {
		lua_pushnil(L);
	}
	return 1;
}
