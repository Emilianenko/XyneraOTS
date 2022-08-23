// Copyright 2022 Xynera.net. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "luascript.h"

#include "spells.h"
#include "vocation.h"

extern Spells* g_spells;
extern Vocations g_vocations;

// Spells
int LuaScriptInterface::luaSpellCreate(lua_State* L)
{
	// Spell(words, name or id) to get an existing spell
	// Spell(type) ex: Spell(SPELL_INSTANT) or Spell(SPELL_RUNE) to create a new spell
	if (lua_gettop(L) == 1) {
		console::reportError("Spell::luaSpellCreate", "Missing parameter!");
		lua_pushnil(L);
		return 1;
	}

	SpellType_t spellType = SPELL_UNDEFINED;

	if (isNumber(L, 2)) {
		int32_t id = getNumber<int32_t>(L, 2);
		RuneSpell* rune = g_spells->getRuneSpell(id);

		if (rune) {
			pushUserdata<Spell>(L, rune);
			setMetatable(L, -1, "Spell");
			return 1;
		}

		spellType = static_cast<SpellType_t>(id);
	} else if (isString(L, 2)) {
		std::string arg = getString(L, 2);
		InstantSpell* instant = g_spells->getInstantSpellByName(arg);
		if (instant) {
			pushUserdata<Spell>(L, instant);
			setMetatable(L, -1, "Spell");
			return 1;
		}
		instant = g_spells->getInstantSpell(arg);
		if (instant) {
			pushUserdata<Spell>(L, instant);
			setMetatable(L, -1, "Spell");
			return 1;
		}
		RuneSpell* rune = g_spells->getRuneSpellByName(arg);
		if (rune) {
			pushUserdata<Spell>(L, rune);
			setMetatable(L, -1, "Spell");
			return 1;
		}

		std::string tmp = asLowerCaseString(arg);
		if (tmp == "instant") {
			spellType = SPELL_INSTANT;
		} else if (tmp == "rune") {
			spellType = SPELL_RUNE;
		}
	}

	if (spellType == SPELL_INSTANT) {
		InstantSpell* spell = new InstantSpell(getScriptEnv()->getScriptInterface());
		spell->fromLua = true;
		pushUserdata<Spell>(L, spell);
		setMetatable(L, -1, "Spell");
		spell->spellType = SPELL_INSTANT;
		return 1;
	} else if (spellType == SPELL_RUNE) {
		RuneSpell* spell = new RuneSpell(getScriptEnv()->getScriptInterface());
		spell->fromLua = true;
		pushUserdata<Spell>(L, spell);
		setMetatable(L, -1, "Spell");
		spell->spellType = SPELL_RUNE;
		return 1;
	}

	lua_pushnil(L);
	return 1;
}

int LuaScriptInterface::luaSpellOnCastSpell(lua_State* L)
{
	// spell:onCastSpell(callback)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (spell->spellType == SPELL_INSTANT) {
			InstantSpell* instant = dynamic_cast<InstantSpell*>(getUserdata<Spell>(L, 1));
			if (!instant->loadCallback()) {
				pushBoolean(L, false);
				return 1;
			}
			instant->scripted = true;
			pushBoolean(L, true);
		} else if (spell->spellType == SPELL_RUNE) {
			RuneSpell* rune = dynamic_cast<RuneSpell*>(getUserdata<Spell>(L, 1));
			if (!rune->loadCallback()) {
				pushBoolean(L, false);
				return 1;
			}
			rune->scripted = true;
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellRegister(lua_State* L)
{
	// spell:register()
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (spell->spellType == SPELL_INSTANT) {
			InstantSpell* instant = dynamic_cast<InstantSpell*>(getUserdata<Spell>(L, 1));
			if (!instant->isScripted()) {
				pushBoolean(L, false);
				return 1;
			}
			pushBoolean(L, g_spells->registerInstantLuaEvent(instant));
		} else if (spell->spellType == SPELL_RUNE) {
			RuneSpell* rune = dynamic_cast<RuneSpell*>(getUserdata<Spell>(L, 1));
			if (rune->getMagicLevel() != 0 || rune->getLevel() != 0) {
				//Change information in the ItemType to get accurate description
				ItemType& iType = Item::items.getItemType(rune->getRuneItemId());
				iType.name = rune->getName();
				iType.runeMagLevel = rune->getMagicLevel();
				iType.runeLevel = rune->getLevel();
				iType.charges = rune->getCharges();
			}
			if (!rune->isScripted()) {
				pushBoolean(L, false);
				return 1;
			}
			pushBoolean(L, g_spells->registerRuneLuaEvent(rune));
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellName(lua_State* L)
{
	// spell:name(name)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			pushString(L, spell->getName());
		} else {
			spell->setName(getString(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellId(lua_State* L)
{
	// spell:id(id)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getId());
		} else {
			spell->setId(getNumber<uint8_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellGroup(lua_State* L)
{
	// spell:group(primaryGroup[, secondaryGroup])
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		const std::string location = "Spell:group";

		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getGroup());
			lua_pushnumber(L, spell->getSecondaryGroup());
			return 2;
		} else if (lua_gettop(L) == 2) {
			SpellGroup_t group = getNumber<SpellGroup_t>(L, 2);
			if (group) {
				spell->setGroup(group);
				pushBoolean(L, true);
			} else if (isString(L, 2)) {
				group = stringToSpellGroup(getString(L, 2));
				if (group != SPELLGROUP_NONE) {
					spell->setGroup(group);
				} else {
					console::reportWarning(location, "Unknown spell group \"" + getString(L, 2) + "\"!");
					pushBoolean(L, false);
					return 1;
				}
				pushBoolean(L, true);
			} else {
				console::reportWarning(location, "Unknown spell group \"" + getString(L, 2) + "\"!");
				pushBoolean(L, false);
				return 1;
			}
		} else {
			SpellGroup_t primaryGroup = getNumber<SpellGroup_t>(L, 2);
			SpellGroup_t secondaryGroup = getNumber<SpellGroup_t>(L, 2);
			if (primaryGroup && secondaryGroup) {
				spell->setGroup(primaryGroup);
				spell->setSecondaryGroup(secondaryGroup);
				pushBoolean(L, true);
			} else if (isString(L, 2) && isString(L, 3)) {
				primaryGroup = stringToSpellGroup(getString(L, 2));
				if (primaryGroup != SPELLGROUP_NONE) {
					spell->setGroup(primaryGroup);
				} else {
					console::reportWarning(location, "Unknown primary spell group \"" + getString(L, 2) + "\"!");
					pushBoolean(L, false);
					return 1;
				}
				secondaryGroup = stringToSpellGroup(getString(L, 3));
				if (secondaryGroup != SPELLGROUP_NONE) {
					spell->setSecondaryGroup(secondaryGroup);
				} else {
					console::reportWarning(location, "Unknown secondary spell group \"" + getString(L, 3) + "\"!");
					pushBoolean(L, false);
					return 1;
				}
				pushBoolean(L, true);
			} else {
				console::reportWarning(location, "Unknown spell group \"" + getString(L, 2) + "\" or secondary spell group \"" + getString(L, 3) + "\"!");
				pushBoolean(L, false);
				return 1;
			}
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellCooldown(lua_State* L)
{
	// spell:cooldown(cooldown)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getCooldown());
		} else {
			spell->setCooldown(getNumber<uint32_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellGroupCooldown(lua_State* L)
{
	// spell:groupCooldown(primaryGroupCd[, secondaryGroupCd])
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getGroupCooldown());
			lua_pushnumber(L, spell->getSecondaryCooldown());
			return 2;
		} else if (lua_gettop(L) == 2) {
			spell->setGroupCooldown(getNumber<uint32_t>(L, 2));
			pushBoolean(L, true);
		} else {
			spell->setGroupCooldown(getNumber<uint32_t>(L, 2));
			spell->setSecondaryCooldown(getNumber<uint32_t>(L, 3));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellLevel(lua_State* L)
{
	// spell:level(lvl)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getLevel());
		} else {
			spell->setLevel(getNumber<uint32_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellMagicLevel(lua_State* L)
{
	// spell:magicLevel(lvl)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getMagicLevel());
		} else {
			spell->setMagicLevel(getNumber<uint32_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellMana(lua_State* L)
{
	// spell:mana(mana)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getMana());
		} else {
			spell->setMana(getNumber<uint32_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellManaPercent(lua_State* L)
{
	// spell:manaPercent(percent)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getManaPercent());
		} else {
			spell->setManaPercent(getNumber<uint32_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellSoul(lua_State* L)
{
	// spell:soul(soul)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getSoulCost());
		} else {
			spell->setSoulCost(getNumber<uint32_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellRange(lua_State* L)
{
	// spell:range(range)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getRange());
		} else {
			spell->setRange(getNumber<int32_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellPremium(lua_State* L)
{
	// spell:isPremium(bool)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->isPremium());
		} else {
			spell->setPremium(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellEnabled(lua_State* L)
{
	// spell:isEnabled(bool)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->isEnabled());
		} else {
			spell->setEnabled(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellNeedTarget(lua_State* L)
{
	// spell:needTarget(bool)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getNeedTarget());
		} else {
			spell->setNeedTarget(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellNeedWeapon(lua_State* L)
{
	// spell:needWeapon(bool)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getNeedWeapon());
		} else {
			spell->setNeedWeapon(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellNeedLearn(lua_State* L)
{
	// spell:needLearn(bool)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getNeedLearn());
		} else {
			spell->setNeedLearn(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellSelfTarget(lua_State* L)
{
	// spell:isSelfTarget(bool)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getSelfTarget());
		} else {
			spell->setSelfTarget(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellBlocking(lua_State* L)
{
	// spell:isBlocking(blockingSolid, blockingCreature)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getBlockingSolid());
			pushBoolean(L, spell->getBlockingCreature());
			return 2;
		} else {
			spell->setBlockingSolid(getBoolean(L, 2));
			spell->setBlockingCreature(getBoolean(L, 3));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellAggressive(lua_State* L)
{
	// spell:isAggressive(bool)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getAggressive());
		} else {
			spell->setAggressive(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellPzLock(lua_State* L)
{
	// spell:isPzLock(bool)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getPzLock());
		} else {
			spell->setPzLock(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellVocation(lua_State* L)
{
	// spell:vocation(vocation)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (!spell) {
		lua_pushnil(L);
		return 1;
	}

	if (lua_gettop(L) == 1) {
		lua_createtable(L, 0, 0);
		int i = 0;
		for (auto& voc : spell->getVocMap()) {
			std::string name = g_vocations.getVocation(voc.first)->getVocName();
			pushString(L, name);
			lua_rawseti(L, -2, ++i);
		}
	} else {
		int parameters = lua_gettop(L) - 1; // - 1 because self is a parameter aswell, which we want to skip ofc
		for (int i = 0; i < parameters; ++i) {
			std::vector<std::string> vocList = explodeString(getString(L, 2 + i), ";");
			spell->addVocMap(g_vocations.getVocationId(vocList[0]), vocList.size() > 1 ? booleanString(vocList[1]) : false);
		}
		pushBoolean(L, true);
	}
	return 1;
}

// only for InstantSpells
int LuaScriptInterface::luaSpellWords(lua_State* L)
{
	// spell:words(words[, separator = ""])
	InstantSpell* spell = dynamic_cast<InstantSpell*>(getUserdata<Spell>(L, 1));
	if (spell) {
		// if spell != SPELL_INSTANT, it means that this actually is no InstantSpell, so we return nil
		if (spell->spellType != SPELL_INSTANT) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			pushString(L, spell->getWords());
			pushString(L, spell->getSeparator());
			return 2;
		} else {
			std::string sep = "";
			if (lua_gettop(L) == 3) {
				sep = getString(L, 3);
			}
			spell->setWords(getString(L, 2));
			spell->setSeparator(sep);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for InstantSpells
int LuaScriptInterface::luaSpellNeedDirection(lua_State* L)
{
	// spell:needDirection(bool)
	InstantSpell* spell = dynamic_cast<InstantSpell*>(getUserdata<Spell>(L, 1));
	if (spell) {
		// if spell != SPELL_INSTANT, it means that this actually is no InstantSpell, so we return nil
		if (spell->spellType != SPELL_INSTANT) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getNeedDirection());
		} else {
			spell->setNeedDirection(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for InstantSpells
int LuaScriptInterface::luaSpellHasParams(lua_State* L)
{
	// spell:hasParams(bool)
	InstantSpell* spell = dynamic_cast<InstantSpell*>(getUserdata<Spell>(L, 1));
	if (spell) {
		// if spell != SPELL_INSTANT, it means that this actually is no InstantSpell, so we return nil
		if (spell->spellType != SPELL_INSTANT) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getHasParam());
		} else {
			spell->setHasParam(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for InstantSpells
int LuaScriptInterface::luaSpellHasPlayerNameParam(lua_State* L)
{
	// spell:hasPlayerNameParam(bool)
	InstantSpell* spell = dynamic_cast<InstantSpell*>(getUserdata<Spell>(L, 1));
	if (spell) {
		// if spell != SPELL_INSTANT, it means that this actually is no InstantSpell, so we return nil
		if (spell->spellType != SPELL_INSTANT) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getHasPlayerNameParam());
		} else {
			spell->setHasPlayerNameParam(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for InstantSpells
int LuaScriptInterface::luaSpellNeedCasterTargetOrDirection(lua_State* L)
{
	// spell:needCasterTargetOrDirection(bool)
	InstantSpell* spell = dynamic_cast<InstantSpell*>(getUserdata<Spell>(L, 1));
	if (spell) {
		// if spell != SPELL_INSTANT, it means that this actually is no InstantSpell, so we return nil
		if (spell->spellType != SPELL_INSTANT) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getNeedCasterTargetOrDirection());
		} else {
			spell->setNeedCasterTargetOrDirection(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for InstantSpells
int LuaScriptInterface::luaSpellIsBlockingWalls(lua_State* L)
{
	// spell:blockWalls(bool)
	InstantSpell* spell = dynamic_cast<InstantSpell*>(getUserdata<Spell>(L, 1));
	if (spell) {
		// if spell != SPELL_INSTANT, it means that this actually is no InstantSpell, so we return nil
		if (spell->spellType != SPELL_INSTANT) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getBlockWalls());
		} else {
			spell->setBlockWalls(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for RuneSpells
int LuaScriptInterface::luaSpellRuneLevel(lua_State* L)
{
	// spell:runeLevel(level)
	RuneSpell* spell = dynamic_cast<RuneSpell*>(getUserdata<Spell>(L, 1));
	int32_t level = getNumber<int32_t>(L, 2);
	if (spell) {
		// if spell != SPELL_RUNE, it means that this actually is no RuneSpell, so we return nil
		if (spell->spellType != SPELL_RUNE) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getLevel());
		} else {
			spell->setLevel(level);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for RuneSpells
int LuaScriptInterface::luaSpellRuneMagicLevel(lua_State* L)
{
	// spell:runeMagicLevel(magLevel)
	RuneSpell* spell = dynamic_cast<RuneSpell*>(getUserdata<Spell>(L, 1));
	int32_t magLevel = getNumber<int32_t>(L, 2);
	if (spell) {
		// if spell != SPELL_RUNE, it means that this actually is no RuneSpell, so we return nil
		if (spell->spellType != SPELL_RUNE) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getMagicLevel());
		} else {
			spell->setMagicLevel(magLevel);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for RuneSpells
int LuaScriptInterface::luaSpellRuneId(lua_State* L)
{
	// spell:runeId(id)
	RuneSpell* rune = dynamic_cast<RuneSpell*>(getUserdata<Spell>(L, 1));
	if (rune) {
		// if spell != SPELL_RUNE, it means that this actually is no RuneSpell, so we return nil
		if (rune->spellType != SPELL_RUNE) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, rune->getRuneItemId());
		} else {
			rune->setRuneItemId(getNumber<uint16_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for RuneSpells
int LuaScriptInterface::luaSpellCharges(lua_State* L)
{
	// spell:charges(charges)
	RuneSpell* spell = dynamic_cast<RuneSpell*>(getUserdata<Spell>(L, 1));
	if (spell) {
		// if spell != SPELL_RUNE, it means that this actually is no RuneSpell, so we return nil
		if (spell->spellType != SPELL_RUNE) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getCharges());
		} else {
			spell->setCharges(getNumber<uint32_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for RuneSpells
int LuaScriptInterface::luaSpellAllowFarUse(lua_State* L)
{
	// spell:allowFarUse(bool)
	RuneSpell* spell = dynamic_cast<RuneSpell*>(getUserdata<Spell>(L, 1));
	if (spell) {
		// if spell != SPELL_RUNE, it means that this actually is no RuneSpell, so we return nil
		if (spell->spellType != SPELL_RUNE) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getAllowFarUse());
		} else {
			spell->setAllowFarUse(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for RuneSpells
int LuaScriptInterface::luaSpellBlockWalls(lua_State* L)
{
	// spell:blockWalls(bool)
	RuneSpell* spell = dynamic_cast<RuneSpell*>(getUserdata<Spell>(L, 1));
	if (spell) {
		// if spell != SPELL_RUNE, it means that this actually is no RuneSpell, so we return nil
		if (spell->spellType != SPELL_RUNE) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getCheckLineOfSight());
		} else {
			spell->setCheckLineOfSight(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for RuneSpells
int LuaScriptInterface::luaSpellCheckFloor(lua_State* L)
{
	// spell:checkFloor(bool)
	RuneSpell* spell = dynamic_cast<RuneSpell*>(getUserdata<Spell>(L, 1));
	if (spell) {
		// if spell != SPELL_RUNE, it means that this actually is no RuneSpell, so we return nil
		if (spell->spellType != SPELL_RUNE) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getCheckFloor());
		} else {
			spell->setCheckFloor(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}
