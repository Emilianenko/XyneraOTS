// Copyright 2022 Xynera.net. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "luascript.h"

#include "script.h"
#include "weapons.h"

extern Scripts* g_scripts;
extern Weapons* g_weapons;

// Weapon
int LuaScriptInterface::luaCreateWeapon(lua_State* L)
{
	// Weapon(type)
	if (getScriptEnv()->getScriptInterface() != &g_scripts->getScriptInterface()) {
		reportErrorFunc(L, "Weapons can only be registered in the Scripts interface.");
		lua_pushnil(L);
		return 1;
	}

	WeaponType_t type = getNumber<WeaponType_t>(L, 2);
	switch (type) {
		case WEAPON_SWORD:
		case WEAPON_AXE:
		case WEAPON_CLUB:
		case WEAPON_FIST: {
			WeaponMelee* weapon = new WeaponMelee(getScriptEnv()->getScriptInterface());
			if (weapon) {
				pushUserdata<WeaponMelee>(L, weapon);
				setMetatable(L, -1, "Weapon");
				weapon->weaponType = type;
				weapon->fromLua = true;
			} else {
				lua_pushnil(L);
			}
			break;
		}
		case WEAPON_DISTANCE:
		case WEAPON_AMMO: {
			WeaponDistance* weapon = new WeaponDistance(getScriptEnv()->getScriptInterface());
			if (weapon) {
				pushUserdata<WeaponDistance>(L, weapon);
				setMetatable(L, -1, "Weapon");
				weapon->weaponType = type;
				weapon->fromLua = true;
			} else {
				lua_pushnil(L);
			}
			break;
		}
		case WEAPON_WAND: {
			WeaponWand* weapon = new WeaponWand(getScriptEnv()->getScriptInterface());
			if (weapon) {
				pushUserdata<WeaponWand>(L, weapon);
				setMetatable(L, -1, "Weapon");
				weapon->weaponType = type;
				weapon->fromLua = true;
			} else {
				lua_pushnil(L);
			}
			break;
		}
		default: {
			lua_pushnil(L);
			break;
		}
	}
	return 1;
}

int LuaScriptInterface::luaWeaponAction(lua_State* L)
{
	// weapon:action(callback)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		std::string typeName = getString(L, 2);
		std::string tmpStr = asLowerCaseString(typeName);
		if (tmpStr == "removecount") {
			weapon->action = WEAPONACTION_REMOVECOUNT;
		} else if (tmpStr == "removecharge") {
			weapon->action = WEAPONACTION_REMOVECHARGE;
		} else if (tmpStr == "move") {
			weapon->action = WEAPONACTION_MOVE;
		} else {
			console::reportError("Weapon:action", "Invalid action \"" + typeName + "\"!");
			pushBoolean(L, false);
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaWeaponRegister(lua_State* L)
{
	// weapon:register()
	Weapon** weaponPtr = getRawUserdata<Weapon>(L, 1);
	if (!weaponPtr) {
		lua_pushnil(L);
		return 1;
	}

	if (auto* weapon = *weaponPtr) {
		if (weapon->weaponType == WEAPON_DISTANCE || weapon->weaponType == WEAPON_AMMO) {
			weapon = getUserdata<WeaponDistance>(L, 1);
		} else if (weapon->weaponType == WEAPON_WAND) {
			weapon = getUserdata<WeaponWand>(L, 1);
		} else {
			weapon = getUserdata<WeaponMelee>(L, 1);
		}

		uint16_t id = weapon->getID();
		ItemType& it = Item::items.getItemType(id);
		it.weaponType = weapon->weaponType;

		if (weapon->getWieldInfo() != 0) {
			it.wieldInfo = weapon->getWieldInfo();
			it.vocationString = weapon->getVocationString();
			it.minReqLevel = weapon->getReqLevel();
			it.minReqMagicLevel = weapon->getReqMagLv();
		}

		weapon->configureWeapon(it);
		pushBoolean(L, g_weapons->registerLuaEvent(weapon));
		*weaponPtr = nullptr; // Remove luascript reference
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaWeaponOnUseWeapon(lua_State* L)
{
	// weapon:onUseWeapon(callback)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		if (!weapon->loadCallback()) {
			pushBoolean(L, false);
			return 1;
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaWeaponUnproperly(lua_State* L)
{
	// weapon:wieldUnproperly(bool)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		weapon->setWieldUnproperly(getBoolean(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaWeaponLevel(lua_State* L)
{
	// weapon:level(lvl)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		weapon->setRequiredLevel(getNumber<uint32_t>(L, 2));
		weapon->setWieldInfo(WIELDINFO_LEVEL);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaWeaponMagicLevel(lua_State* L)
{
	// weapon:magicLevel(lvl)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		weapon->setRequiredMagLevel(getNumber<uint32_t>(L, 2));
		weapon->setWieldInfo(WIELDINFO_MAGLV);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaWeaponMana(lua_State* L)
{
	// weapon:mana(mana)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		weapon->setMana(getNumber<uint32_t>(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaWeaponManaPercent(lua_State* L)
{
	// weapon:manaPercent(percent)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		weapon->setManaPercent(getNumber<uint32_t>(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaWeaponHealth(lua_State* L)
{
	// weapon:health(health)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		weapon->setHealth(getNumber<int32_t>(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaWeaponHealthPercent(lua_State* L)
{
	// weapon:healthPercent(percent)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		weapon->setHealthPercent(getNumber<uint32_t>(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaWeaponSoul(lua_State* L)
{
	// weapon:soul(soul)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		weapon->setSoul(getNumber<uint32_t>(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaWeaponBreakChance(lua_State* L)
{
	// weapon:breakChance(percent)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		weapon->setBreakChance(getNumber<uint32_t>(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaWeaponWandDamage(lua_State* L)
{
	// weapon:damage(damage[min, max]) only use this if the weapon is a wand!
	WeaponWand* weapon = getUserdata<WeaponWand>(L, 1);
	if (weapon) {
		weapon->setMinChange(getNumber<uint32_t>(L, 2));
		if (lua_gettop(L) > 2) {
			weapon->setMaxChange(getNumber<uint32_t>(L, 3));
		} else {
			weapon->setMaxChange(getNumber<uint32_t>(L, 2));
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaWeaponElement(lua_State* L)
{
	// weapon:element(combatType)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		if (!getNumber<CombatType_t>(L, 2)) {
			std::string element = getString(L, 2);
			std::string tmpStrValue = asLowerCaseString(element);
			if (tmpStrValue == "earth") {
				weapon->params.combatType = COMBAT_EARTHDAMAGE;
			} else if (tmpStrValue == "ice") {
				weapon->params.combatType = COMBAT_ICEDAMAGE;
			} else if (tmpStrValue == "energy") {
				weapon->params.combatType = COMBAT_ENERGYDAMAGE;
			} else if (tmpStrValue == "fire") {
				weapon->params.combatType = COMBAT_FIREDAMAGE;
			} else if (tmpStrValue == "death") {
				weapon->params.combatType = COMBAT_DEATHDAMAGE;
			} else if (tmpStrValue == "holy") {
				weapon->params.combatType = COMBAT_HOLYDAMAGE;
			} else {
				console::reportWarning("Weapon:element", "Element type \"" + element + "\" does not exist!");
			}
		} else {
			weapon->params.combatType = getNumber<CombatType_t>(L, 2);
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaWeaponPremium(lua_State* L)
{
	// weapon:premium(bool)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		weapon->setNeedPremium(getBoolean(L, 2));
		weapon->setWieldInfo(WIELDINFO_PREMIUM);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaWeaponVocation(lua_State* L)
{
	// weapon:vocation(vocName[, showInDescription = false, lastVoc = false])
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		weapon->addVocWeaponMap(getString(L, 2));
		weapon->setWieldInfo(WIELDINFO_VOCREQ);
		std::string tmp;
		bool showInDescription = getBoolean(L, 3, false);
		bool lastVoc = getBoolean(L, 4, false);

		if (showInDescription) {
			if (weapon->getVocationString().empty()) {
				tmp = asLowerCaseString(getString(L, 2));
				tmp += "s";
				weapon->setVocationString(tmp);
			} else {
				tmp = weapon->getVocationString();
				if (lastVoc) {
					tmp += " and ";
				} else {
					tmp += ", ";
				}
				tmp += asLowerCaseString(getString(L, 2));
				tmp += "s";
				weapon->setVocationString(tmp);
			}
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaWeaponId(lua_State* L)
{
	// weapon:id(id)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		weapon->setID(getNumber<uint32_t>(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaWeaponAttack(lua_State* L)
{
	// weapon:attack(atk)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		uint16_t id = weapon->getID();
		ItemType& it = Item::items.getItemType(id);
		it.attack = getNumber<int32_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaWeaponDefense(lua_State* L)
{
	// weapon:defense(defense[, extraDefense])
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		uint16_t id = weapon->getID();
		ItemType& it = Item::items.getItemType(id);
		it.defense = getNumber<int32_t>(L, 2);
		if (lua_gettop(L) > 2) {
			it.extraDefense = getNumber<int32_t>(L, 3);
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaWeaponRange(lua_State* L)
{
	// weapon:range(range)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		uint16_t id = weapon->getID();
		ItemType& it = Item::items.getItemType(id);
		it.shootRange = getNumber<uint8_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaWeaponCharges(lua_State* L)
{
	// weapon:charges(charges[, showCharges = true])
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		bool showCharges = getBoolean(L, 3, true);
		uint16_t id = weapon->getID();
		ItemType& it = Item::items.getItemType(id);

		it.charges = getNumber<uint8_t>(L, 2);
		it.showCharges = showCharges;
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaWeaponDuration(lua_State* L)
{
	// weapon:duration(duration[, showDuration = true])
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		bool showDuration = getBoolean(L, 3, true);
		uint16_t id = weapon->getID();
		ItemType& it = Item::items.getItemType(id);

		it.decayTime = getNumber<uint32_t>(L, 2);
		it.showDuration = showDuration;
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaWeaponDecayTo(lua_State* L)
{
	// weapon:decayTo([itemid = 0])
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		uint16_t itemid = getNumber<uint16_t>(L, 2, 0);
		uint16_t id = weapon->getID();
		ItemType& it = Item::items.getItemType(id);

		it.decayTo = itemid;
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaWeaponTransformEquipTo(lua_State* L)
{
	// weapon:transformEquipTo(itemid)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		uint16_t id = weapon->getID();
		ItemType& it = Item::items.getItemType(id);
		it.transformEquipTo = getNumber<uint16_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaWeaponTransformDeEquipTo(lua_State* L)
{
	// weapon:transformDeEquipTo(itemid)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		uint16_t id = weapon->getID();
		ItemType& it = Item::items.getItemType(id);
		it.transformDeEquipTo = getNumber<uint16_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaWeaponShootType(lua_State* L)
{
	// weapon:shootType(type)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		uint16_t id = weapon->getID();
		ItemType& it = Item::items.getItemType(id);
		it.shootType = getNumber<ShootType_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaWeaponSlotType(lua_State* L)
{
	// weapon:slotType(slot)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		uint16_t id = weapon->getID();
		ItemType& it = Item::items.getItemType(id);
		std::string slot = getString(L, 2);

		if (slot == "two-handed") {
			it.slotPosition |= SLOTP_TWO_HAND;
		} else {
			it.slotPosition |= SLOTP_HAND;
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaWeaponAmmoType(lua_State* L)
{
	// weapon:ammoType(type)
	WeaponDistance* weapon = getUserdata<WeaponDistance>(L, 1);
	if (weapon) {
		uint16_t id = weapon->getID();
		ItemType& it = Item::items.getItemType(id);
		std::string type = getString(L, 2);

		if (type == "arrow") {
			it.ammoType = AMMO_ARROW;
		} else if (type == "bolt"){
			it.ammoType = AMMO_BOLT;
		} else {
			console::reportWarning("Weapon:ammoType", "Ammo type \"" + type + "\" does not exist!");
			lua_pushnil(L);
			return 1;
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaWeaponHitChance(lua_State* L)
{
	// weapon:hitChance(chance)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		uint16_t id = weapon->getID();
		ItemType& it = Item::items.getItemType(id);
		it.hitChance = getNumber<int8_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaWeaponMaxHitChance(lua_State* L)
{
	// weapon:maxHitChance(max)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		uint16_t id = weapon->getID();
		ItemType& it = Item::items.getItemType(id);
		it.maxHitChance = getNumber<int32_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaWeaponExtraElement(lua_State* L)
{
	// weapon:extraElement(atk, combatType)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		uint16_t id = weapon->getID();
		ItemType& it = Item::items.getItemType(id);
		it.abilities.get()->elementDamage = getNumber<uint16_t>(L, 2);

		if (!getNumber<CombatType_t>(L, 3)) {
			std::string element = getString(L, 3);
			std::string tmpStrValue = asLowerCaseString(element);
			if (tmpStrValue == "earth") {
				it.abilities.get()->elementType = COMBAT_EARTHDAMAGE;
			} else if (tmpStrValue == "ice") {
				it.abilities.get()->elementType = COMBAT_ICEDAMAGE;
			} else if (tmpStrValue == "energy") {
				it.abilities.get()->elementType = COMBAT_ENERGYDAMAGE;
			} else if (tmpStrValue == "fire") {
				it.abilities.get()->elementType = COMBAT_FIREDAMAGE;
			} else if (tmpStrValue == "death") {
				it.abilities.get()->elementType = COMBAT_DEATHDAMAGE;
			} else if (tmpStrValue == "holy") {
				it.abilities.get()->elementType = COMBAT_HOLYDAMAGE;
			} else {
				console::reportWarning("Weapon:extraElement", "Element type \"" + element + "\" does not exist!");
			}
		} else {
			it.abilities.get()->elementType = getNumber<CombatType_t>(L, 3);
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}
