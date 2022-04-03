// Copyright 2022 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "monsters.h"
#include "combat.h"
#include "configmanager.h"
#include "game.h"
#include "pugicast.h"
#include "spells.h"
#include "weapons.h"

extern Game g_game;
extern Spells* g_spells;
extern Monsters g_monsters;
extern ConfigManager g_config;

spellBlock_t::~spellBlock_t()
{
	if (combatSpell) {
		delete spell;
	}
}

void MonsterType::loadLoot(MonsterType* monsterType, LootBlock lootBlock)
{
	if (lootBlock.childLoot.empty()) {
		bool isContainer = Item::items[lootBlock.id].isContainer();
		if (isContainer) {
			for (LootBlock child : lootBlock.childLoot) {
				lootBlock.childLoot.push_back(child);
			}
		}
		monsterType->info.lootItems.push_back(lootBlock);
	} else {
		monsterType->info.lootItems.push_back(lootBlock);
	}
}

bool Monsters::loadFromXml(bool reloading /*= false*/)
{
	unloadedMonsters = {};
	pugi::xml_document doc;
	pugi::xml_parse_result result = doc.load_file("data/monster/monsters.xml");
	if (!result) {
		printXMLError("Monsters::loadFromXml", "data/monster/monsters.xml", result);
		return false;
	}

	loaded = true;

	for (auto monsterNode : doc.child("monsters").children()) {
		std::string name = asLowerCaseString(monsterNode.attribute("name").as_string());
		std::string file = "data/monster/" + std::string(monsterNode.attribute("file").as_string());
		unloadedMonsters.emplace(name, file);
	}

	bool forceLoad = g_config.getBoolean(ConfigManager::FORCE_MONSTERTYPE_LOAD);

	for (auto it : unloadedMonsters) {
		if ((forceLoad || reloading) && monsters.find(it.first) != monsters.end()) {
			loadMonster(it.second, it.first, reloading);
		}
	}

	return true;
}

bool Monsters::reload()
{
	loaded = false;

	scriptInterface.reset();

	return loadFromXml(true);
}

ConditionDamage* Monsters::getDamageCondition(ConditionType_t conditionType,
        int32_t maxDamage, int32_t minDamage, int32_t startDamage, uint32_t tickInterval)
{
	ConditionDamage* condition = static_cast<ConditionDamage*>(Condition::createCondition(CONDITIONID_COMBAT, conditionType, 0, 0));
	condition->setParam(CONDITION_PARAM_TICKINTERVAL, tickInterval);
	condition->setParam(CONDITION_PARAM_MINVALUE, minDamage);
	condition->setParam(CONDITION_PARAM_MAXVALUE, maxDamage);
	condition->setParam(CONDITION_PARAM_STARTVALUE, startDamage);
	condition->setParam(CONDITION_PARAM_DELAYED, 1);
	return condition;
}

bool Monsters::deserializeSpell(const pugi::xml_node& node, spellBlock_t& sb, const std::string& description)
{
	std::string name;
	std::string scriptName;
	bool isScripted;

	pugi::xml_attribute attr;
	if ((attr = node.attribute("script"))) {
		scriptName = attr.as_string();
		isScripted = true;
	} else if ((attr = node.attribute("name"))) {
		name = attr.as_string();
		isScripted = false;
	} else {
		return false;
	}

	const std::string location = "Monsters::deserializeSpell";

	if ((attr = node.attribute("speed")) || (attr = node.attribute("interval"))) {
		sb.speed = std::max<int32_t>(1, pugi::cast<int32_t>(attr.value()));
	}

	if ((attr = node.attribute("chance"))) {
		uint32_t chance = pugi::cast<uint32_t>(attr.value());
		if (chance > 100) {
			chance = 100;
			console::reportWarning(location, description + " - Chance value out of bounds for spell: \"" + name + "\"!");
		}
		sb.chance = chance;
	} else if (asLowerCaseString(name) != "melee") {
		console::reportWarning(location, description + " - Missing chance value on non-melee spell: \"" + name + "\"!");
	}

	if ((attr = node.attribute("range"))) {
		uint32_t range = pugi::cast<uint32_t>(attr.value());
		if (range > (Map::maxViewportX * 2)) {
			range = Map::maxViewportX * 2;
		}
		sb.range = range;
	}

	if ((attr = node.attribute("min"))) {
		sb.minCombatValue = pugi::cast<int32_t>(attr.value());
	}

	if ((attr = node.attribute("max"))) {
		sb.maxCombatValue = pugi::cast<int32_t>(attr.value());

		//normalize values
		if (std::abs(sb.minCombatValue) > std::abs(sb.maxCombatValue)) {
			int32_t value = sb.maxCombatValue;
			sb.maxCombatValue = sb.minCombatValue;
			sb.minCombatValue = value;
		}
	}

	if (auto spell = g_spells->getSpellByName(name)) {
		sb.spell = spell;
		return true;
	}

	CombatSpell* combatSpell = nullptr;
	bool needTarget = false;
	bool needDirection = false;

	if (isScripted) {
		if ((attr = node.attribute("direction"))) {
			needDirection = attr.as_bool();
		}

		if ((attr = node.attribute("target"))) {
			needTarget = attr.as_bool();
		}

		std::unique_ptr<CombatSpell> combatSpellPtr(new CombatSpell(nullptr, needTarget, needDirection));
		if (!combatSpellPtr->loadScript("data/" + g_spells->getScriptBaseName() + "/scripts/" + scriptName)) {
			return false;
		}

		if (!combatSpellPtr->loadScriptCombat()) {
			return false;
		}

		combatSpell = combatSpellPtr.release();
		combatSpell->getCombat()->setPlayerCombatValues(COMBAT_FORMULA_DAMAGE, sb.minCombatValue, 0, sb.maxCombatValue, 0);
	} else {
		Combat_ptr combat = std::make_shared<Combat>();
		if ((attr = node.attribute("length"))) {
			int32_t length = pugi::cast<int32_t>(attr.value());
			if (length > 0) {
				int32_t spread = 3;

				//need direction spell
				if ((attr = node.attribute("spread"))) {
					spread = std::max<int32_t>(0, pugi::cast<int32_t>(attr.value()));
				}

				AreaCombat* area = new AreaCombat();
				area->setupArea(length, spread);
				combat->setArea(area);

				needDirection = true;
			}
		}

		if ((attr = node.attribute("radius"))) {
			int32_t radius = pugi::cast<int32_t>(attr.value());

			//target spell
			if ((attr = node.attribute("target"))) {
				needTarget = attr.as_bool();
			}

			AreaCombat* area = new AreaCombat();
			area->setupArea(radius);
			combat->setArea(area);
		}

		if ((attr = node.attribute("ring"))) {
			int32_t ring = pugi::cast<int32_t>(attr.value());

			//target spell
			if ((attr = node.attribute("target"))) {
				needTarget = attr.as_bool();
			}

			AreaCombat* area = new AreaCombat();
			area->setupAreaRing(ring);
			combat->setArea(area);
		}

		std::string tmpName = asLowerCaseString(name);

		if (tmpName == "melee") {
			sb.isMelee = true;

			pugi::xml_attribute attackAttribute, skillAttribute;
			if ((attackAttribute = node.attribute("attack")) && (skillAttribute = node.attribute("skill"))) {
				sb.minCombatValue = 0;
				sb.maxCombatValue = -Weapons::getMaxMeleeDamage(pugi::cast<int32_t>(skillAttribute.value()), pugi::cast<int32_t>(attackAttribute.value()));
			}

			ConditionType_t conditionType = CONDITION_NONE;
			int32_t minDamage = 0;
			int32_t maxDamage = 0;
			uint32_t tickInterval = 2000;

			if ((attr = node.attribute("fire"))) {
				conditionType = CONDITION_FIRE;

				minDamage = pugi::cast<int32_t>(attr.value());
				maxDamage = minDamage;
				tickInterval = 9000;
			} else if ((attr = node.attribute("poison"))) {
				conditionType = CONDITION_POISON;

				minDamage = pugi::cast<int32_t>(attr.value());
				maxDamage = minDamage;
				tickInterval = 4000;
			} else if ((attr = node.attribute("energy"))) {
				conditionType = CONDITION_ENERGY;

				minDamage = pugi::cast<int32_t>(attr.value());
				maxDamage = minDamage;
				tickInterval = 10000;
			} else if ((attr = node.attribute("drown"))) {
				conditionType = CONDITION_DROWN;

				minDamage = pugi::cast<int32_t>(attr.value());
				maxDamage = minDamage;
				tickInterval = 5000;
			} else if ((attr = node.attribute("freeze"))) {
				conditionType = CONDITION_FREEZING;

				minDamage = pugi::cast<int32_t>(attr.value());
				maxDamage = minDamage;
				tickInterval = 8000;
			} else if ((attr = node.attribute("dazzle"))) {
				conditionType = CONDITION_DAZZLED;

				minDamage = pugi::cast<int32_t>(attr.value());
				maxDamage = minDamage;
				tickInterval = 10000;
			} else if ((attr = node.attribute("curse"))) {
				conditionType = CONDITION_CURSED;

				minDamage = pugi::cast<int32_t>(attr.value());
				maxDamage = minDamage;
				tickInterval = 4000;
			} else if ((attr = node.attribute("bleed")) || (attr = node.attribute("physical"))) {
				conditionType = CONDITION_BLEEDING;
				tickInterval = 4000;
			}

			if ((attr = node.attribute("tick"))) {
				int32_t value = pugi::cast<int32_t>(attr.value());
				if (value > 0) {
					tickInterval = value;
				}
			}

			if (conditionType != CONDITION_NONE) {
				Condition* condition = getDamageCondition(conditionType, maxDamage, minDamage, 0, tickInterval);
				combat->addCondition(condition);
			}

			sb.range = 1;
			combat->setParam(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE);
			combat->setParam(COMBAT_PARAM_BLOCKARMOR, 1);
			combat->setParam(COMBAT_PARAM_BLOCKSHIELD, 1);
			combat->setOrigin(ORIGIN_MELEE);
		} else if (tmpName == "physical") {
			combat->setParam(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE);
			combat->setParam(COMBAT_PARAM_BLOCKARMOR, 1);
			combat->setOrigin(ORIGIN_RANGED);
		} else if (tmpName == "bleed") {
			combat->setParam(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE);
		} else if (tmpName == "poison" || tmpName == "earth") {
			combat->setParam(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE);
		} else if (tmpName == "fire") {
			combat->setParam(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE);
		} else if (tmpName == "energy") {
			combat->setParam(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE);
		} else if (tmpName == "drown") {
			combat->setParam(COMBAT_PARAM_TYPE, COMBAT_DROWNDAMAGE);
		} else if (tmpName == "ice") {
			combat->setParam(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE);
		} else if (tmpName == "holy") {
			combat->setParam(COMBAT_PARAM_TYPE, COMBAT_HOLYDAMAGE);
		} else if (tmpName == "death") {
			combat->setParam(COMBAT_PARAM_TYPE, COMBAT_DEATHDAMAGE);
		} else if (tmpName == "lifedrain") {
			combat->setParam(COMBAT_PARAM_TYPE, COMBAT_LIFEDRAIN);
		} else if (tmpName == "manadrain") {
			combat->setParam(COMBAT_PARAM_TYPE, COMBAT_MANADRAIN);
		} else if (tmpName == "healing") {
			combat->setParam(COMBAT_PARAM_TYPE, COMBAT_HEALING);
			combat->setParam(COMBAT_PARAM_AGGRESSIVE, 0);
		} else if (tmpName == "speed") {
			int32_t minSpeedChange = 0;
			int32_t maxSpeedChange = 0;
			int32_t duration = 10000;

			if ((attr = node.attribute("duration"))) {
				duration = pugi::cast<int32_t>(attr.value());
			}

			if ((attr = node.attribute("speedchange"))) {
				minSpeedChange = pugi::cast<int32_t>(attr.value());
			} else if ((attr = node.attribute("minspeedchange"))) {
				minSpeedChange = pugi::cast<int32_t>(attr.value());

				if ((attr = node.attribute("maxspeedchange"))) {
					maxSpeedChange = pugi::cast<int32_t>(attr.value());
				}

				if (minSpeedChange == 0) {
					console::reportError(location, description + " - Missing speedchange/minspeedchange value!");
					return false;
				}

				if (maxSpeedChange == 0) {
					maxSpeedChange = minSpeedChange; // static speedchange value
				}
			}

			if (minSpeedChange < -1000) {

				console::reportWarning(location, description + " - Unable to set speed debuff to value stronger than -1000 (100%)!");
				minSpeedChange = -1000;
			}

			ConditionType_t conditionType;
			if (minSpeedChange >= 0) {
				conditionType = CONDITION_HASTE;
				combat->setParam(COMBAT_PARAM_AGGRESSIVE, 0);
			} else {
				conditionType = CONDITION_PARALYZE;
			}

			ConditionSpeed* condition = static_cast<ConditionSpeed*>(Condition::createCondition(CONDITIONID_COMBAT, conditionType, duration, 0));
			condition->setFormulaVars(minSpeedChange / 1000.0, 0, maxSpeedChange / 1000.0, 0);
			combat->addCondition(condition);
		} else if (tmpName == "outfit") {
			int32_t duration = 10000;

			if ((attr = node.attribute("duration"))) {
				duration = pugi::cast<int32_t>(attr.value());
			}

			if ((attr = node.attribute("monster"))) {
				MonsterType* mType = g_monsters.getMonsterType(attr.as_string());
				if (mType) {
					ConditionOutfit* condition = static_cast<ConditionOutfit*>(Condition::createCondition(CONDITIONID_COMBAT, CONDITION_OUTFIT, duration, 0));
					condition->setOutfit(mType->info.outfit);
					combat->setParam(COMBAT_PARAM_AGGRESSIVE, 0);
					combat->addCondition(condition);
				}
			} else if ((attr = node.attribute("item"))) {
				Outfit_t outfit;
				outfit.lookTypeEx = pugi::cast<uint16_t>(attr.value());

				ConditionOutfit* condition = static_cast<ConditionOutfit*>(Condition::createCondition(CONDITIONID_COMBAT, CONDITION_OUTFIT, duration, 0));
				condition->setOutfit(outfit);
				combat->setParam(COMBAT_PARAM_AGGRESSIVE, 0);
				combat->addCondition(condition);
			}
		} else if (tmpName == "invisible") {
			int32_t duration = 10000;

			if ((attr = node.attribute("duration"))) {
				duration = pugi::cast<int32_t>(attr.value());
			}

			Condition* condition = Condition::createCondition(CONDITIONID_COMBAT, CONDITION_INVISIBLE, duration, 0);
			combat->setParam(COMBAT_PARAM_AGGRESSIVE, 0);
			combat->addCondition(condition);
		} else if (tmpName == "drunk") {
			int32_t duration = 10000;
			uint8_t drunkenness = 25;

			if ((attr = node.attribute("duration"))) {
				duration = pugi::cast<int32_t>(attr.value());
			}

			if ((attr = node.attribute("drunkenness"))) {
				drunkenness = pugi::cast<uint8_t>(attr.value());
			}

			Condition* condition = Condition::createCondition(CONDITIONID_COMBAT, CONDITION_DRUNK, duration, drunkenness);
			combat->addCondition(condition);
		} else if (tmpName == "firefield") {
			combat->setParam(COMBAT_PARAM_CREATEITEM, ITEM_FIREFIELD_PVP_FULL);
		} else if (tmpName == "poisonfield") {
			combat->setParam(COMBAT_PARAM_CREATEITEM, ITEM_POISONFIELD_PVP);
		} else if (tmpName == "energyfield") {
			combat->setParam(COMBAT_PARAM_CREATEITEM, ITEM_ENERGYFIELD_PVP);
		} else if (tmpName == "firecondition" || tmpName == "energycondition" ||
				   tmpName == "earthcondition" || tmpName == "poisoncondition" ||
				   tmpName == "icecondition" || tmpName == "freezecondition" ||
				   tmpName == "deathcondition" || tmpName == "cursecondition" ||
				   tmpName == "holycondition" || tmpName == "dazzlecondition" ||
				   tmpName == "drowncondition" || tmpName == "bleedcondition" ||
				   tmpName == "physicalcondition") {
			ConditionType_t conditionType = CONDITION_NONE;
			uint32_t tickInterval = 2000;

			if (tmpName == "firecondition") {
				conditionType = CONDITION_FIRE;
				tickInterval = 10000;
			} else if (tmpName == "poisoncondition" || tmpName == "earthcondition") {
				conditionType = CONDITION_POISON;
				tickInterval = 4000;
			} else if (tmpName == "energycondition") {
				conditionType = CONDITION_ENERGY;
				tickInterval = 10000;
			} else if (tmpName == "drowncondition") {
				conditionType = CONDITION_DROWN;
				tickInterval = 5000;
			} else if (tmpName == "freezecondition" || tmpName == "icecondition") {
				conditionType = CONDITION_FREEZING;
				tickInterval = 10000;
			} else if (tmpName == "cursecondition" || tmpName == "deathcondition") {
				conditionType = CONDITION_CURSED;
				tickInterval = 4000;
			} else if (tmpName == "dazzlecondition" || tmpName == "holycondition") {
				conditionType = CONDITION_DAZZLED;
				tickInterval = 10000;
			} else if (tmpName == "physicalcondition" || tmpName == "bleedcondition") {
				conditionType = CONDITION_BLEEDING;
				tickInterval = 4000;
			}

			if ((attr = node.attribute("tick"))) {
				int32_t value = pugi::cast<int32_t>(attr.value());
				if (value > 0) {
					tickInterval = value;
				}
			}

			int32_t minDamage = std::abs(sb.minCombatValue);
			int32_t maxDamage = std::abs(sb.maxCombatValue);
			int32_t startDamage = 0;

			if ((attr = node.attribute("start"))) {
				int32_t value = std::abs(pugi::cast<int32_t>(attr.value()));
				if (value <= minDamage) {
					startDamage = value;
				}
			}

			Condition* condition = getDamageCondition(conditionType, maxDamage, minDamage, startDamage, tickInterval);
			combat->addCondition(condition);
		} else if (tmpName == "strength") {
			//
		} else if (tmpName == "effect") {
			//
		} else {
			console::reportError(location, description + " - Unknown spell name \"" + name + "\"!");
			return false;
		}

		combat->setPlayerCombatValues(COMBAT_FORMULA_DAMAGE, sb.minCombatValue, 0, sb.maxCombatValue, 0);
		combatSpell = new CombatSpell(combat, needTarget, needDirection);

		for (auto attributeNode : node.children()) {
			if ((attr = attributeNode.attribute("key"))) {
				const char* value = attr.value();
				if (caseInsensitiveEqual(value, "shooteffect")) {
					if ((attr = attributeNode.attribute("value"))) {
						ShootType_t shoot = getShootType(asLowerCaseString(attr.as_string()));
						if (shoot != CONST_ANI_NONE) {
							combat->setParam(COMBAT_PARAM_DISTANCEEFFECT, shoot);
						} else {
							console::reportWarning(location, fmt::format("{:s} - Unknown shootEffect \"{:s}\"!", description, attr.as_string()));
						}
					}
				} else if (caseInsensitiveEqual(value, "areaeffect")) {
					if ((attr = attributeNode.attribute("value"))) {
						MagicEffectClasses effect = getMagicEffect(asLowerCaseString(attr.as_string()));
						if (effect != CONST_ME_NONE) {
							combat->setParam(COMBAT_PARAM_EFFECT, effect);
						} else {
							console::reportWarning(location, fmt::format("{:s} - Unknown areaEffect \"{:s}\"!", description, attr.as_string()));
						}
					}
				} else {
					console::reportWarning(location, fmt::format("{:s} - Effect type \"{:s}\" does not exist!", description, attr.as_string()));
				}
			}
		}
	}

	sb.spell = combatSpell;
	if (combatSpell) {
		sb.combatSpell = true;
	}
	return true;
}

bool Monsters::deserializeSpell(MonsterSpell* spell, spellBlock_t& sb, const std::string& description)
{
	if (!spell->scriptName.empty()) {
		spell->isScripted = true;
	} else if (!spell->name.empty()) {
		spell->isScripted = false;
	} else {
		return false;
	}

	const std::string location = "Monsters::deserializeSpell";

	sb.speed = spell->interval;

	if (spell->chance > 100) {
		sb.chance = 100;
	} else {
		sb.chance = spell->chance;
	}

	if (spell->range > (Map::maxViewportX * 2)) {
		spell->range = Map::maxViewportX * 2;
	}
	sb.range = spell->range;

	sb.minCombatValue = spell->minCombatValue;
	sb.maxCombatValue = spell->maxCombatValue;
	if (std::abs(sb.minCombatValue) > std::abs(sb.maxCombatValue)) {
		int32_t value = sb.maxCombatValue;
		sb.maxCombatValue = sb.minCombatValue;
		sb.minCombatValue = value;
	}

	sb.spell = g_spells->getSpellByName(spell->name);
	if (sb.spell) {
		return true;
	}

	CombatSpell* combatSpell = nullptr;

	if (spell->isScripted) {
		std::unique_ptr<CombatSpell> combatSpellPtr(new CombatSpell(nullptr, spell->needTarget, spell->needDirection));
		if (!combatSpellPtr->loadScript("data/" + g_spells->getScriptBaseName() + "/scripts/" + spell->scriptName)) {
			console::reportFileError(location, "data/" + g_spells->getScriptBaseName() + "/scripts/" + spell->scriptName);
			return false;
		}

		if (!combatSpellPtr->loadScriptCombat()) {
			return false;
		}

		combatSpell = combatSpellPtr.release();
		combatSpell->getCombat()->setPlayerCombatValues(COMBAT_FORMULA_DAMAGE, sb.minCombatValue, 0, sb.maxCombatValue, 0);
	} else {
		Combat_ptr combat = std::make_shared<Combat>();
		sb.combatSpell = true;

		if (spell->length > 0) {
			spell->spread = std::max<int32_t>(0, spell->spread);

			AreaCombat* area = new AreaCombat();
			area->setupArea(spell->length, spell->spread);
			combat->setArea(area);

			spell->needDirection = true;
		}

		if (spell->radius > 0) {
			AreaCombat* area = new AreaCombat();
			area->setupArea(spell->radius);
			combat->setArea(area);
		}

		if (spell->ring > 0) {
			AreaCombat* area = new AreaCombat();
			area->setupAreaRing(spell->ring);
			combat->setArea(area);
		}

		if (spell->conditionType != CONDITION_NONE) {
			ConditionType_t conditionType = spell->conditionType;

			uint32_t tickInterval = 2000;
			if (spell->tickInterval != 0) {
				tickInterval = spell->tickInterval;
			}

			int32_t conMinDamage = std::abs(spell->conditionMinDamage);
			int32_t conMaxDamage = std::abs(spell->conditionMaxDamage);
			int32_t startDamage = std::abs(spell->conditionStartDamage);

			Condition* condition = getDamageCondition(conditionType, conMaxDamage, conMinDamage, startDamage, tickInterval);
			combat->addCondition(condition);
		}

		std::string tmpName = asLowerCaseString(spell->name);

		if (tmpName == "melee") {
			sb.isMelee = true;

			if (spell->attack > 0 && spell->skill > 0) {
				sb.minCombatValue = 0;
				sb.maxCombatValue = -Weapons::getMaxMeleeDamage(spell->skill, spell->attack);
			}

			sb.range = 1;
			combat->setParam(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE);
			combat->setParam(COMBAT_PARAM_BLOCKARMOR, 1);
			combat->setParam(COMBAT_PARAM_BLOCKSHIELD, 1);
			combat->setOrigin(ORIGIN_MELEE);
		} else if (tmpName == "combat") {
			if (spell->combatType == COMBAT_UNDEFINEDDAMAGE) {
				console::reportWarning(location, description + " - spell has undefined damage!");
				combat->setParam(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE);
			}

			if (spell->combatType == COMBAT_PHYSICALDAMAGE) {
				combat->setParam(COMBAT_PARAM_BLOCKARMOR, 1);
				combat->setOrigin(ORIGIN_RANGED);
			} else if (spell->combatType == COMBAT_HEALING) {
				combat->setParam(COMBAT_PARAM_AGGRESSIVE, 0);
			}
			combat->setParam(COMBAT_PARAM_TYPE, spell->combatType);
		} else if (tmpName == "speed") {
			int32_t minSpeedChange = 0;
			int32_t maxSpeedChange = 0;
			int32_t duration = 10000;

			if (spell->duration != 0) {
				duration = spell->duration;
			}

			if (spell->minSpeedChange != 0) {
				minSpeedChange = spell->minSpeedChange;
			} else {
				console::reportError(location, description + " - missing speedchange/minspeedchange value!");
				delete spell;
				return false;
			}

			if (minSpeedChange < -1000) {
				console::reportWarning(location, description + " - Unable to set speed debuff to value stronger than -1000 (100%)!");
				minSpeedChange = -1000;
			}

			if (spell->maxSpeedChange != 0) {
				maxSpeedChange = spell->maxSpeedChange;
			} else {
				maxSpeedChange = minSpeedChange; // static speedchange value
			}

			ConditionType_t conditionType;
			if (minSpeedChange >= 0) {
				conditionType = CONDITION_HASTE;
				combat->setParam(COMBAT_PARAM_AGGRESSIVE, 0);
			} else {
				conditionType = CONDITION_PARALYZE;
			}

			ConditionSpeed* condition = static_cast<ConditionSpeed*>(Condition::createCondition(CONDITIONID_COMBAT, conditionType, duration, 0));
			condition->setFormulaVars(minSpeedChange / 1000.0, 0, maxSpeedChange / 1000.0, 0);
			combat->addCondition(condition);
		} else if (tmpName == "outfit") {
			int32_t duration = 10000;

			if (spell->duration != 0) {
				duration = spell->duration;
			}

			ConditionOutfit* condition = static_cast<ConditionOutfit*>(Condition::createCondition(CONDITIONID_COMBAT, CONDITION_OUTFIT, duration, 0));
			condition->setOutfit(spell->outfit);
			combat->setParam(COMBAT_PARAM_AGGRESSIVE, 0);
			combat->addCondition(condition);
		} else if (tmpName == "invisible") {
			int32_t duration = 10000;

			if (spell->duration != 0) {
				duration = spell->duration;
			}

			Condition* condition = Condition::createCondition(CONDITIONID_COMBAT, CONDITION_INVISIBLE, duration, 0);
			combat->setParam(COMBAT_PARAM_AGGRESSIVE, 0);
			combat->addCondition(condition);
		} else if (tmpName == "drunk") {
			int32_t duration = 10000;
			uint8_t drunkenness = 25;

			if (spell->duration != 0) {
				duration = spell->duration;
			}

			if (spell->drunkenness != 0) {
				drunkenness = spell->drunkenness;
			}

			Condition* condition = Condition::createCondition(CONDITIONID_COMBAT, CONDITION_DRUNK, duration, drunkenness);
			combat->addCondition(condition);
		} else if (tmpName == "firefield") {
			combat->setParam(COMBAT_PARAM_CREATEITEM, ITEM_FIREFIELD_PVP_FULL);
		} else if (tmpName == "poisonfield") {
			combat->setParam(COMBAT_PARAM_CREATEITEM, ITEM_POISONFIELD_PVP);
		} else if (tmpName == "energyfield") {
			combat->setParam(COMBAT_PARAM_CREATEITEM, ITEM_ENERGYFIELD_PVP);
		} else if (tmpName == "condition") {
			if (spell->conditionType == CONDITION_NONE) {
				console::reportError(location, description + " - Condition not set for spell \"" + spell->name + "\"!");
			}
		} else if (tmpName == "strength") {
			//
		} else if (tmpName == "effect") {
			//
		} else {
			console::reportError(location, description + " - Unknown spell name \"" + spell->name + "\"!");
		}

		if (spell->needTarget) {
			if (spell->shoot != CONST_ANI_NONE) {
				combat->setParam(COMBAT_PARAM_DISTANCEEFFECT, spell->shoot);
			}
		}

		if (spell->effect != CONST_ME_NONE) {
			combat->setParam(COMBAT_PARAM_EFFECT, spell->effect);
		}

		combat->setPlayerCombatValues(COMBAT_FORMULA_DAMAGE, sb.minCombatValue, 0, sb.maxCombatValue, 0);
		combatSpell = new CombatSpell(combat, spell->needTarget, spell->needDirection);
	}

	sb.spell = combatSpell;
	if (combatSpell) {
		sb.combatSpell = true;
	}
	return true;
}

MonsterType* Monsters::loadMonster(const std::string& file, const std::string& monsterName, bool reloading /*= false*/)
{
	MonsterType* mType = nullptr;

	const std::string location = "Monsters::loadMonster";

	pugi::xml_document doc;
	pugi::xml_parse_result result = doc.load_file(file.c_str());
	if (!result) {
		printXMLError(location, file, result);
		return nullptr;
	}

	pugi::xml_node monsterNode = doc.child("monster");
	if (!monsterNode) {
		console::reportError(location, "Missing monster node in \"" + file + "\"!");
		return nullptr;
	}

	pugi::xml_attribute attr;
	if (!(attr = monsterNode.attribute("name"))) {
		console::reportError(location, "Missing name in \"" + file + "\"!");
		return nullptr;
	}

	if (reloading) {
		auto it = monsters.find(asLowerCaseString(monsterName));
		if (it != monsters.end()) {
			mType = &it->second;
			mType->info = {};
		}
	}

	if (!mType) {
		mType = &monsters[asLowerCaseString(monsterName)];
	}

	mType->name = attr.as_string();

	if ((attr = monsterNode.attribute("nameDescription"))) {
		mType->nameDescription = attr.as_string();
	} else {
		mType->nameDescription = "a " + asLowerCaseString(mType->name);
	}

	if ((attr = monsterNode.attribute("race"))) {
		std::string tmpStrValue = asLowerCaseString(attr.as_string());
		uint16_t tmpInt = pugi::cast<uint16_t>(attr.value());
		if (tmpStrValue == "venom" || tmpInt == 1) {
			mType->info.race = RACE_VENOM;
		} else if (tmpStrValue == "blood" || tmpInt == 2) {
			mType->info.race = RACE_BLOOD;
		} else if (tmpStrValue == "undead" || tmpInt == 3) {
			mType->info.race = RACE_UNDEAD;
		} else if (tmpStrValue == "fire" || tmpInt == 4) {
			mType->info.race = RACE_FIRE;
		} else if (tmpStrValue == "energy" || tmpInt == 5) {
			mType->info.race = RACE_ENERGY;
		} else if (tmpStrValue == "ink" || tmpInt == 6) {
			mType->info.race = RACE_INK;
		} else {
			console::reportWarning(location, fmt::format("Unknown race type \"{:s}\"!", attr.as_string()));
		}
	}

	if ((attr = monsterNode.attribute("experience"))) {
		mType->info.experience = pugi::cast<uint64_t>(attr.value());
	}

	if ((attr = monsterNode.attribute("speed"))) {
		mType->info.baseSpeed = pugi::cast<int32_t>(attr.value());
	}

	if ((attr = monsterNode.attribute("manacost"))) {
		mType->info.manaCost = pugi::cast<uint32_t>(attr.value());
	}

	if ((attr = monsterNode.attribute("skull"))) {
		mType->info.skull = getSkullType(asLowerCaseString(attr.as_string()));
	}

	if ((attr = monsterNode.attribute("script"))) {
		if (!scriptInterface) {
			scriptInterface.reset(new LuaScriptInterface("Monster Interface"));
			scriptInterface->initState();
		}

		std::string script = attr.as_string();
		if (scriptInterface->loadFile("data/monster/scripts/" + script) == 0) {
			mType->info.scriptInterface = scriptInterface.get();
			mType->info.creatureAppearEvent = scriptInterface->getEvent("onCreatureAppear");
			mType->info.creatureDisappearEvent = scriptInterface->getEvent("onCreatureDisappear");
			mType->info.creatureMoveEvent = scriptInterface->getEvent("onCreatureMove");
			mType->info.creatureSayEvent = scriptInterface->getEvent("onCreatureSay");
			mType->info.thinkEvent = scriptInterface->getEvent("onThink");
		} else {
			console::reportFileError("Monsters::loadMonster", script, scriptInterface->getLastLuaError());
		}
	}

	pugi::xml_node node;
	if ((node = monsterNode.child("health"))) {
		if ((attr = node.attribute("now"))) {
			mType->info.health = pugi::cast<int32_t>(attr.value());
		} else {
			console::reportError(location, "missing healthnow (" + file + ")!");
		}

		if ((attr = node.attribute("max"))) {
			mType->info.healthMax = pugi::cast<int32_t>(attr.value());
		} else {
			console::reportError(location, "missing healthmax (" + file + ")!");
		}

		if (mType->info.health > mType->info.healthMax) {
			mType->info.health = mType->info.healthMax;
			console::reportWarning(location, "Health now is greater than health max (" + file + ")!");
		}
	}

	if ((node = monsterNode.child("flags"))) {
		for (auto flagNode : node.children()) {
			attr = flagNode.first_attribute();
			const char* attrName = attr.name();
			if (caseInsensitiveEqual(attrName, "summonable")) {
				mType->info.isSummonable = attr.as_bool();
			} else if (caseInsensitiveEqual(attrName, "attackable")) {
				mType->info.isAttackable = attr.as_bool();
			} else if (caseInsensitiveEqual(attrName, "hostile")) {
				mType->info.isHostile = attr.as_bool();
			} else if (caseInsensitiveEqual(attrName, "ignorespawnblock")) {
				mType->info.isIgnoringSpawnBlock = attr.as_bool();
			} else if (caseInsensitiveEqual(attrName, "illusionable")) {
				mType->info.isIllusionable = attr.as_bool();
			} else if (caseInsensitiveEqual(attrName, "challengeable")) {
				mType->info.isChallengeable = attr.as_bool();
			} else if (caseInsensitiveEqual(attrName, "convinceable")) {
				mType->info.isConvinceable = attr.as_bool();
			} else if (caseInsensitiveEqual(attrName, "pushable")) {
				mType->info.pushable = attr.as_bool();
			} else if (caseInsensitiveEqual(attrName, "isboss")) {
				mType->info.isBoss = attr.as_bool();
			} else if (caseInsensitiveEqual(attrName, "canpushitems")) {
				mType->info.canPushItems = attr.as_bool();
			} else if (caseInsensitiveEqual(attrName, "canpushcreatures")) {
				mType->info.canPushCreatures = attr.as_bool();
			} else if (caseInsensitiveEqual(attrName, "staticattack")) {
				uint32_t staticAttack = pugi::cast<uint32_t>(attr.value());
				if (staticAttack > 100) {
					console::reportWarning(location, "staticattack greater than 100! (" + file + ")");
					staticAttack = 100;
				}

				mType->info.staticAttackChance = staticAttack;
			} else if (caseInsensitiveEqual(attrName, "lightlevel")) {
				mType->info.light.level = pugi::cast<uint16_t>(attr.value());
			} else if (caseInsensitiveEqual(attrName, "lightcolor")) {
				mType->info.light.color = pugi::cast<uint16_t>(attr.value());
			} else if (caseInsensitiveEqual(attrName, "targetdistance")) {
				int32_t targetDistance = pugi::cast<int32_t>(attr.value());
				if (targetDistance < 1) {
					targetDistance = 1;
					console::reportWarning(location, "targetdistance lesser than 1! (" + file + ")");
				}
				mType->info.targetDistance = targetDistance;
			} else if (caseInsensitiveEqual(attrName, "runonhealth")) {
				mType->info.runAwayHealth = pugi::cast<int32_t>(attr.value());
			} else if (caseInsensitiveEqual(attrName, "hidehealth")) {
				mType->info.hiddenHealth = attr.as_bool();
			} else if (caseInsensitiveEqual(attrName, "canwalkonenergy")) {
				mType->info.canWalkOnEnergy = attr.as_bool();
			} else if (caseInsensitiveEqual(attrName, "canwalkonfire")) {
				mType->info.canWalkOnFire = attr.as_bool();
			} else if (caseInsensitiveEqual(attrName, "canwalkonpoison")) {
				mType->info.canWalkOnPoison = attr.as_bool();
			} else {
				console::reportWarning(location, "Unknown flag attribute \"" + std::string(attrName) + "\"! (" + file + ")");
			}
		}

		// if a monster can push creatures,
		// it should not be pushable.
		if (mType->info.canPushCreatures) {
			mType->info.pushable = false;
		}
	}
	if (mType->info.manaCost == 0 && (mType->info.isSummonable || mType->info.isConvinceable)) {
		console::reportWarning(location, "manaCost missing or zero on monster with summonable and/or convinceable flags! (" + file + ")");
	}

	if ((node = monsterNode.child("targetchange"))) {
		if ((attr = node.attribute("speed")) || (attr = node.attribute("interval"))) {
			mType->info.changeTargetSpeed = pugi::cast<uint32_t>(attr.value());
		} else {
			console::reportWarning(location, "Missing targetchange speed! (" + file + ")");
		}

		if ((attr = node.attribute("chance"))) {
			int32_t chance = pugi::cast<int32_t>(attr.value());
			if (chance > 100) {
				chance = 100;
				console::reportWarning(location, "targetchange chance value out of bounds! (" + file + ")");
			}
			mType->info.changeTargetChance = chance;
		} else {
			console::reportWarning(location, "Missing targetchange information! (" + file + ")");
		}
	}

	if ((node = monsterNode.child("look"))) {
		if ((attr = node.attribute("type"))) {
			mType->info.outfit.lookType = pugi::cast<uint16_t>(attr.value());

			if ((attr = node.attribute("head"))) {
				mType->info.outfit.lookHead = pugi::cast<uint16_t>(attr.value());
			}

			if ((attr = node.attribute("body"))) {
				mType->info.outfit.lookBody = pugi::cast<uint16_t>(attr.value());
			}

			if ((attr = node.attribute("legs"))) {
				mType->info.outfit.lookLegs = pugi::cast<uint16_t>(attr.value());
			}

			if ((attr = node.attribute("feet"))) {
				mType->info.outfit.lookFeet = pugi::cast<uint16_t>(attr.value());
			}

			if ((attr = node.attribute("addons"))) {
				mType->info.outfit.lookAddons = pugi::cast<uint16_t>(attr.value());
			}
		} else if ((attr = node.attribute("typeex"))) {
			mType->info.outfit.lookTypeEx = pugi::cast<uint16_t>(attr.value());
		} else {
			console::reportWarning(location, "Missing look type/typeex! (" + file + ")");
		}

		if ((attr = node.attribute("mount"))) {
			mType->info.outfit.lookMount = pugi::cast<uint16_t>(attr.value());
		}

		if ((attr = node.attribute("corpse"))) {
			mType->info.lookcorpse = pugi::cast<uint16_t>(attr.value());
		}
	}

	if ((node = monsterNode.child("attacks"))) {
		for (auto attackNode : node.children()) {
			spellBlock_t sb;
			if (deserializeSpell(attackNode, sb, monsterName)) {
				mType->info.attackSpells.emplace_back(std::move(sb));
			} else {
				console::reportWarning(location, "Failed to load attack! (" + file + ")");
			}
		}
	}

	if ((node = monsterNode.child("defenses"))) {
		if ((attr = node.attribute("defense"))) {
			mType->info.defense = pugi::cast<int32_t>(attr.value());
		}

		if ((attr = node.attribute("armor"))) {
			mType->info.armor = pugi::cast<int32_t>(attr.value());
		}

		for (auto defenseNode : node.children()) {
			spellBlock_t sb;
			if (deserializeSpell(defenseNode, sb, monsterName)) {
				mType->info.defenseSpells.emplace_back(std::move(sb));
			} else {
				console::reportWarning(location, "Failed to load defense! (" + file + ")");
			}
		}
	}

	if ((node = monsterNode.child("immunities"))) {
		for (auto immunityNode : node.children()) {
			if ((attr = immunityNode.attribute("name"))) {
				std::string tmpStrValue = asLowerCaseString(attr.as_string());
				if (tmpStrValue == "physical") {
					mType->info.damageImmunities |= COMBAT_PHYSICALDAMAGE;
					mType->info.conditionImmunities |= CONDITION_BLEEDING;
				} else if (tmpStrValue == "energy") {
					mType->info.damageImmunities |= COMBAT_ENERGYDAMAGE;
					mType->info.conditionImmunities |= CONDITION_ENERGY;
				} else if (tmpStrValue == "fire") {
					mType->info.damageImmunities |= COMBAT_FIREDAMAGE;
					mType->info.conditionImmunities |= CONDITION_FIRE;
				} else if (tmpStrValue == "poison" ||
							tmpStrValue == "earth") {
					mType->info.damageImmunities |= COMBAT_EARTHDAMAGE;
					mType->info.conditionImmunities |= CONDITION_POISON;
				} else if (tmpStrValue == "drown") {
					mType->info.damageImmunities |= COMBAT_DROWNDAMAGE;
					mType->info.conditionImmunities |= CONDITION_DROWN;
				} else if (tmpStrValue == "ice") {
					mType->info.damageImmunities |= COMBAT_ICEDAMAGE;
					mType->info.conditionImmunities |= CONDITION_FREEZING;
				} else if (tmpStrValue == "holy") {
					mType->info.damageImmunities |= COMBAT_HOLYDAMAGE;
					mType->info.conditionImmunities |= CONDITION_DAZZLED;
				} else if (tmpStrValue == "death") {
					mType->info.damageImmunities |= COMBAT_DEATHDAMAGE;
					mType->info.conditionImmunities |= CONDITION_CURSED;
				} else if (tmpStrValue == "lifedrain") {
					mType->info.damageImmunities |= COMBAT_LIFEDRAIN;
				} else if (tmpStrValue == "manadrain") {
					mType->info.damageImmunities |= COMBAT_MANADRAIN;
				} else if (tmpStrValue == "paralyze") {
					mType->info.conditionImmunities |= CONDITION_PARALYZE;
				} else if (tmpStrValue == "outfit") {
					mType->info.conditionImmunities |= CONDITION_OUTFIT;
				} else if (tmpStrValue == "drunk") {
					mType->info.conditionImmunities |= CONDITION_DRUNK;
				} else if (tmpStrValue == "invisible" || tmpStrValue == "invisibility") {
					mType->info.conditionImmunities |= CONDITION_INVISIBLE;
				} else if (tmpStrValue == "bleed") {
					mType->info.conditionImmunities |= CONDITION_BLEEDING;
				} else {
					console::reportWarning(location, fmt::format("Unknown immunity name \"{:s}\"! ({:s})", attr.as_string(), file));
				}
			} else if ((attr = immunityNode.attribute("physical"))) {
				if (attr.as_bool()) {
					mType->info.damageImmunities |= COMBAT_PHYSICALDAMAGE;
					mType->info.conditionImmunities |= CONDITION_BLEEDING;
				}
			} else if ((attr = immunityNode.attribute("energy"))) {
				if (attr.as_bool()) {
					mType->info.damageImmunities |= COMBAT_ENERGYDAMAGE;
					mType->info.conditionImmunities |= CONDITION_ENERGY;
				}
			} else if ((attr = immunityNode.attribute("fire"))) {
				if (attr.as_bool()) {
					mType->info.damageImmunities |= COMBAT_FIREDAMAGE;
					mType->info.conditionImmunities |= CONDITION_FIRE;
				}
			} else if ((attr = immunityNode.attribute("poison")) || (attr = immunityNode.attribute("earth"))) {
				if (attr.as_bool()) {
					mType->info.damageImmunities |= COMBAT_EARTHDAMAGE;
					mType->info.conditionImmunities |= CONDITION_POISON;
				}
			} else if ((attr = immunityNode.attribute("drown"))) {
				if (attr.as_bool()) {
					mType->info.damageImmunities |= COMBAT_DROWNDAMAGE;
					mType->info.conditionImmunities |= CONDITION_DROWN;
				}
			} else if ((attr = immunityNode.attribute("ice"))) {
				if (attr.as_bool()) {
					mType->info.damageImmunities |= COMBAT_ICEDAMAGE;
					mType->info.conditionImmunities |= CONDITION_FREEZING;
				}
			} else if ((attr = immunityNode.attribute("holy"))) {
				if (attr.as_bool()) {
					mType->info.damageImmunities |= COMBAT_HOLYDAMAGE;
					mType->info.conditionImmunities |= CONDITION_DAZZLED;
				}
			} else if ((attr = immunityNode.attribute("death"))) {
				if (attr.as_bool()) {
					mType->info.damageImmunities |= COMBAT_DEATHDAMAGE;
					mType->info.conditionImmunities |= CONDITION_CURSED;
				}
			} else if ((attr = immunityNode.attribute("lifedrain"))) {
				if (attr.as_bool()) {
					mType->info.damageImmunities |= COMBAT_LIFEDRAIN;
				}
			} else if ((attr = immunityNode.attribute("manadrain"))) {
				if (attr.as_bool()) {
					mType->info.damageImmunities |= COMBAT_MANADRAIN;
				}
			} else if ((attr = immunityNode.attribute("paralyze"))) {
				if (attr.as_bool()) {
					mType->info.conditionImmunities |= CONDITION_PARALYZE;
				}
			} else if ((attr = immunityNode.attribute("outfit"))) {
				if (attr.as_bool()) {
					mType->info.conditionImmunities |= CONDITION_OUTFIT;
				}
			} else if ((attr = immunityNode.attribute("bleed"))) {
				if (attr.as_bool()) {
					mType->info.conditionImmunities |= CONDITION_BLEEDING;
				}
			} else if ((attr = immunityNode.attribute("drunk"))) {
				if (attr.as_bool()) {
					mType->info.conditionImmunities |= CONDITION_DRUNK;
				}
			} else if ((attr = immunityNode.attribute("invisible")) || (attr = immunityNode.attribute("invisibility"))) {
				if (attr.as_bool()) {
					mType->info.conditionImmunities |= CONDITION_INVISIBLE;
				}
			} else {
				console::reportWarning(location, "Unknown immunity type! (" + file + ")");
			}
		}
	}

	if ((node = monsterNode.child("voices"))) {
		if ((attr = node.attribute("speed")) || (attr = node.attribute("interval"))) {
			mType->info.yellSpeedTicks = pugi::cast<uint32_t>(attr.value());
		} else {
			console::reportWarning(location, "Missing voices speed! (" + file + ")");
		}

		if ((attr = node.attribute("chance"))) {
			uint32_t chance = pugi::cast<uint32_t>(attr.value());
			if (chance > 100) {
				chance = 100;
				console::reportWarning(location, "Yell chance value out of bounds! (" + file + ")");
			}
			mType->info.yellChance = chance;
		} else {
			console::reportWarning(location, "Missing voice chance! (" + file + ")");
		}

		for (auto voiceNode : node.children()) {
			voiceBlock_t vb;
			if ((attr = voiceNode.attribute("sentence"))) {
				vb.text = attr.as_string();
			} else {
				console::reportWarning(location, "Missing voice sentence! (" + file + ")");
			}

			if ((attr = voiceNode.attribute("yell"))) {
				vb.yellText = attr.as_bool();
			} else {
				vb.yellText = false;
			}
			mType->info.voiceVector.emplace_back(vb);
		}
	}

	if ((node = monsterNode.child("loot"))) {
		for (auto lootNode : node.children()) {
			LootBlock lootBlock;
			if (loadLootItem(lootNode, lootBlock)) {
				mType->info.lootItems.emplace_back(std::move(lootBlock));
			} else {
				console::reportWarning(location, "Unable to load loot! (" + file + ")");
			}
		}
	}

	if ((node = monsterNode.child("elements"))) {
		for (auto elementNode : node.children()) {
			if ((attr = elementNode.attribute("physicalPercent"))) {
				mType->info.elementMap[COMBAT_PHYSICALDAMAGE] = pugi::cast<int32_t>(attr.value());
				if (mType->info.damageImmunities & COMBAT_PHYSICALDAMAGE) {
					console::reportWarning(location, "Element \"physical\": monster already immune! (" + file + ")");
				}
			} else if ((attr = elementNode.attribute("icePercent"))) {
				mType->info.elementMap[COMBAT_ICEDAMAGE] = pugi::cast<int32_t>(attr.value());
				if (mType->info.damageImmunities & COMBAT_ICEDAMAGE) {
					console::reportWarning(location, "Element \"ice\": monster already immune! (" + file + ")");
				}
			} else if ((attr = elementNode.attribute("poisonPercent")) || (attr = elementNode.attribute("earthPercent"))) {
				mType->info.elementMap[COMBAT_EARTHDAMAGE] = pugi::cast<int32_t>(attr.value());
				if (mType->info.damageImmunities & COMBAT_EARTHDAMAGE) {
					console::reportWarning(location, "Element \"earth\": monster already immune! (" + file + ")");
				}
			} else if ((attr = elementNode.attribute("firePercent"))) {
				mType->info.elementMap[COMBAT_FIREDAMAGE] = pugi::cast<int32_t>(attr.value());
				if (mType->info.damageImmunities & COMBAT_FIREDAMAGE) {
					console::reportWarning(location, "Element \"fire\": monster already immune! (" + file + ")");
				}
			} else if ((attr = elementNode.attribute("energyPercent"))) {
				mType->info.elementMap[COMBAT_ENERGYDAMAGE] = pugi::cast<int32_t>(attr.value());
				if (mType->info.damageImmunities & COMBAT_ENERGYDAMAGE) {
					console::reportWarning(location, "Element \"energy\": monster already immune! (" + file + ")");
				}
			} else if ((attr = elementNode.attribute("holyPercent"))) {
				mType->info.elementMap[COMBAT_HOLYDAMAGE] = pugi::cast<int32_t>(attr.value());
				if (mType->info.damageImmunities & COMBAT_HOLYDAMAGE) {
					console::reportWarning(location, "Element \"holy\": monster already immune! (" + file + ")");
				}
			} else if ((attr = elementNode.attribute("deathPercent"))) {
				mType->info.elementMap[COMBAT_DEATHDAMAGE] = pugi::cast<int32_t>(attr.value());
				if (mType->info.damageImmunities & COMBAT_DEATHDAMAGE) {
					console::reportWarning(location, "Element \"death\": monster already immune! (" + file + ")");
				}
			} else if ((attr = elementNode.attribute("drownPercent"))) {
				mType->info.elementMap[COMBAT_DROWNDAMAGE] = pugi::cast<int32_t>(attr.value());
				if (mType->info.damageImmunities & COMBAT_DROWNDAMAGE) {
					console::reportWarning(location, "Element \"drown\": monster already immune! (" + file + ")");
				}
			} else if ((attr = elementNode.attribute("lifedrainPercent"))) {
				mType->info.elementMap[COMBAT_LIFEDRAIN] = pugi::cast<int32_t>(attr.value());
				if (mType->info.damageImmunities & COMBAT_LIFEDRAIN) {
					console::reportWarning(location, "Element \"lifedrain\": monster already immune! (" + file + ")");
				}
			} else if ((attr = elementNode.attribute("manadrainPercent"))) {
				mType->info.elementMap[COMBAT_MANADRAIN] = pugi::cast<int32_t>(attr.value());
				if (mType->info.damageImmunities & COMBAT_MANADRAIN) {
					console::reportWarning(location, "Element \"manadrain\": monster already immune! (" + file + ")");
				}
			} else {
				console::reportWarning(location, "Unknown element percent! (" + file + ")");
			}
		}
	}

	if ((node = monsterNode.child("summons"))) {
		if ((attr = node.attribute("maxSummons"))) {
			mType->info.maxSummons = std::min<uint32_t>(pugi::cast<uint32_t>(attr.value()), 100);
		} else {
			console::reportWarning(location, "Summons: missing maxSummons! (" + file + ")");
		}

		for (auto summonNode : node.children()) {
			int32_t chance = 100;
			int32_t speed = 1000;
			int32_t max = mType->info.maxSummons;
			bool force = false;

			if ((attr = summonNode.attribute("speed")) || (attr = summonNode.attribute("interval"))) {
				speed = std::max<int32_t>(1, pugi::cast<int32_t>(attr.value()));
			}

			if ((attr = summonNode.attribute("chance"))) {
				chance = pugi::cast<int32_t>(attr.value());
				if (chance > 100) {
					chance = 100;
					console::reportWarning(location, "Summon chance value out of bounds! (" + file + ")");
				}
			}

			if ((attr = summonNode.attribute("max"))) {
				max = pugi::cast<uint32_t>(attr.value());
			}

			if ((attr = summonNode.attribute("force"))) {
				force = attr.as_bool();
			}

			if ((attr = summonNode.attribute("name"))) {
				summonBlock_t sb;
				sb.name = attr.as_string();
				sb.speed = speed;
				sb.chance = chance;
				sb.max = max;
				sb.force = force;
				mType->info.summons.emplace_back(sb);
			} else {
				console::reportWarning(location, "Missing summon name! (" + file + ")");
			}
		}
	}

	if ((node = monsterNode.child("script"))) {
		for (auto eventNode : node.children()) {
			if ((attr = eventNode.attribute("name"))) {
				mType->info.scripts.emplace_back(attr.as_string());
			} else {
				console::reportWarning(location, "Missing name for script event! (" + file + ")");
			}
		}
	}

	mType->info.summons.shrink_to_fit();
	mType->info.lootItems.shrink_to_fit();
	mType->info.attackSpells.shrink_to_fit();
	mType->info.defenseSpells.shrink_to_fit();
	mType->info.voiceVector.shrink_to_fit();
	mType->info.scripts.shrink_to_fit();
	return mType;
}

bool MonsterType::loadCallback(LuaScriptInterface* scriptInterface)
{
	int32_t id = scriptInterface->getEvent();
	if (id == -1) {
		console::reportWarning("MonsterType::loadCallback", "Event not found!");
		return false;
	}

	info.scriptInterface = scriptInterface;
	if (info.eventType == MONSTERS_EVENT_THINK) {
		info.thinkEvent = id;
	} else if (info.eventType == MONSTERS_EVENT_APPEAR) {
		info.creatureAppearEvent = id;
	} else if (info.eventType == MONSTERS_EVENT_DISAPPEAR) {
		info.creatureDisappearEvent = id;
	} else if (info.eventType == MONSTERS_EVENT_MOVE) {
		info.creatureMoveEvent = id;
	} else if (info.eventType == MONSTERS_EVENT_SAY) {
		info.creatureSayEvent = id;
	}
	return true;
}

bool Monsters::loadLootItem(const pugi::xml_node& node, LootBlock& lootBlock)
{
	pugi::xml_attribute attr;
	if ((attr = node.attribute("id"))) {
		int32_t id = pugi::cast<int32_t>(attr.value());
		const ItemType& it = Item::items.getItemType(id);

		if (it.name.empty()) {
			console::reportWarning("Monsters::loadLootItem", fmt::format("Unknown loot item id {:d}!", id));
			return false;
		}

		lootBlock.id = id;

	} else if ((attr = node.attribute("name"))) {
		auto name = attr.as_string();
		auto ids = Item::items.nameToItems.equal_range(asLowerCaseString(name));

		if (ids.first == Item::items.nameToItems.cend()) {
			console::reportWarning("Monsters::loadLootItem", fmt::format("Unknown loot item \"{:s}\"!", name));
			return false;
		}

		uint32_t id = ids.first->second;

		if (std::next(ids.first) != ids.second) {
			console::reportWarning("Monsters::loadLootItem", fmt::format("Non-unique loot item \"{:s}\"!", name));
			return false;
		}

		lootBlock.id = id;
	}

	if (lootBlock.id == 0) {
		return false;
	}

	if ((attr = node.attribute("countmax"))) {
		int32_t lootCountMax = pugi::cast<int32_t>(attr.value());
		lootBlock.countmax = std::max<int32_t>(1, lootCountMax);
	} else {
		lootBlock.countmax = 1;
	}

	if ((attr = node.attribute("chance")) || (attr = node.attribute("chance1"))) {
		int32_t lootChance = pugi::cast<int32_t>(attr.value());
		if (lootChance > static_cast<int32_t>(MAX_LOOTCHANCE)) {
			console::reportWarning("Monsters::loadLootItem", fmt::format("Loot chance out of bounds! (max: {:d})!", MAX_LOOTCHANCE));
		}
		lootBlock.chance = std::min<int32_t>(MAX_LOOTCHANCE, lootChance);
	} else {
		lootBlock.chance = MAX_LOOTCHANCE;
	}

	if (Item::items[lootBlock.id].isContainer()) {
		loadLootContainer(node, lootBlock);
	}

	//optional
	if ((attr = node.attribute("subtype"))) {
		lootBlock.subType = pugi::cast<int32_t>(attr.value());
	} else {
		uint32_t charges = Item::items[lootBlock.id].charges;
		if (charges != 0) {
			lootBlock.subType = charges;
		}
	}

	if ((attr = node.attribute("actionId"))) {
		lootBlock.actionId = pugi::cast<int32_t>(attr.value());
	}

	if ((attr = node.attribute("text"))) {
		lootBlock.text = attr.as_string();
	}
	return true;
}

void Monsters::loadLootContainer(const pugi::xml_node& node, LootBlock& lBlock)
{
	// NOTE: <inside> attribute was left for backwards compatibility with pre 1.x TFS versions.
	// Please don't use it, if you don't have to.
	for (auto subNode : node.child("inside") ? node.child("inside").children() : node.children()) {
		LootBlock lootBlock;
		if (loadLootItem(subNode, lootBlock)) {
			lBlock.childLoot.emplace_back(std::move(lootBlock));
		}
	}
}

MonsterType* Monsters::getMonsterType(const std::string& name, bool loadFromFile /*= true */)
{
	std::string lowerCaseName = asLowerCaseString(name);

	auto it = monsters.find(lowerCaseName);
	if (it == monsters.end()) {
		if (!loadFromFile) {
			return nullptr;
		}

		auto it2 = unloadedMonsters.find(lowerCaseName);
		if (it2 == unloadedMonsters.end()) {
			return nullptr;
		}

		return loadMonster(it2->second, name);
	}
	return &it->second;
}
