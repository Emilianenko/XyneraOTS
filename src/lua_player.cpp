// Copyright 2022 Xynera.net. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "luascript.h"

#include "enums.h"
#include "depotchest.h"
#include "inbox.h"
#include "game.h"
#include "player.h"
#include "spectators.h"
#include "spells.h"
#include "storeinbox.h"
#include "iologindata.h"

extern Chat* g_chat;
extern CreatureEvents* g_creatureEvents;
extern Spells* g_spells;
extern Vocations g_vocations;

// Player
int LuaScriptInterface::luaPlayerCreate(lua_State* L)
{
	// Player(id or guid or name or userdata)
	Player* player;
	if (isNumber(L, 2)) {
		uint32_t id = getNumber<uint32_t>(L, 2);
		if (id >= CREATURE_ID_MIN && id <= Player::playerIDLimit) {
			player = g_game.getPlayerByID(id);
		} else {
			player = g_game.getPlayerByGUID(id);
		}
	} else if (isString(L, 2)) {
		ReturnValue ret = g_game.getPlayerByNameWildcard(getString(L, 2), player);
		if (ret != RETURNVALUE_NOERROR) {
			lua_pushnil(L);
			lua_pushnumber(L, ret);
			return 2;
		}
	} else if (isUserdata(L, 2)) {
		if (getUserdataType(L, 2) != LuaData_Player) {
			lua_pushnil(L);
			return 1;
		}
		player = getUserdata<Player>(L, 2);
	} else {
		player = nullptr;
	}

	if (player) {
		pushUserdata<Player>(L, player);
		setMetatable(L, -1, "Player");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerIsPlayer(lua_State* L)
{
	// player:isPlayer()
	pushBoolean(L, getUserdata<const Player>(L, 1) != nullptr);
	return 1;
}

int LuaScriptInterface::luaPlayerSetName(lua_State* L)
{
	// player:setName(newName)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	std::string name = getString(L, 2);
	if (name.empty()) {
		pushBoolean(L, false);
		return 1;
	}

	g_game.renamePlayer(player, name);

	// make sure new name will be sent when viewing the player again
	uint32_t cid = player->getID();
	for (auto& it : g_game.getPlayers()) {
		if (Player* onlinePlayer = it.second) {
			onlinePlayer->forgetCreatureID(cid);
		}
	}

	// update creature on screen
	player->refreshInClient();

	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerGetGuid(lua_State* L)
{
	// player:getGuid()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getGUID());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetIp(lua_State* L)
{
	// player:getIp()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getIP());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetAccountId(lua_State* L)
{
	// player:getAccountId()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getAccount());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetLastLoginSaved(lua_State* L)
{
	// player:getLastLoginSaved()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getLastLoginSaved());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetLastLogout(lua_State* L)
{
	// player:getLastLogout()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getLastLogout());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerFastRelog(lua_State* L)
{
	// player:fastRelog(otherCharName)
	Player* player = getUserdata<Player>(L, 1);
	const std::string& otherCharName = getString(L, 2);

	if (!player) {
		lua_pushnumber(L, RETURNVALUE_NOTPOSSIBLE);
	}

	// check logout conditions
	if (!player->isAccessPlayer()) {
		if (player->getTile()->hasFlag(TILESTATE_NOLOGOUT)) {
			lua_pushnumber(L, RETURNVALUE_YOUCANNOTLOGOUTHERE);
			return 1;
		}

		if (!player->getTile()->hasFlag(TILESTATE_PROTECTIONZONE) && player->hasCondition(CONDITION_INFIGHT)) {
			lua_pushnumber(L, RETURNVALUE_YOUMAYNOTLOGOUTDURINGAFIGHT);
			return 1;
		}
	}

	//scripting event - onLogout
	if (!g_creatureEvents->playerLogout(player)) {
		lua_pushnumber(L, RETURNVALUE_YOUCANNOTLOGOUTHERE);
		return 1;
	}

	player->fastRelog(otherCharName);
	lua_pushnumber(L, RETURNVALUE_NOERROR);
	return 1;
}

int LuaScriptInterface::luaPlayerGetAccountType(lua_State* L)
{
	// player:getAccountType()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getAccountType());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSetAccountType(lua_State* L)
{
	// player:setAccountType(accountType)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		player->accountType = getNumber<AccountType_t>(L, 2);
		IOLoginData::setAccountType(player->getAccount(), player->accountType);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetAccountResource(lua_State* L)
{
	// player:getAccountResource(resourceId)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		uint16_t resourceId = getNumber<uint16_t>(L, 2);
		if (resourceId <= ACCOUNTRESOURCE_LAST) {
			lua_pushnumber(L, player->getAccountResource(static_cast<AccountResourceTypes_t>(resourceId)));
		} else {
			lua_pushnil(L);
		}
	} else {
		lua_pushnil(L);
	}

	return 1;
}

int LuaScriptInterface::luaPlayerSetAccountResource(lua_State* L)
{
	// player:setAccountResource(resourceId, amount)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		uint16_t resourceId = getNumber<uint16_t>(L, 2);
		if (resourceId <= ACCOUNTRESOURCE_LAST) {
			player->setAccountResource(static_cast<AccountResourceTypes_t>(resourceId), getNumber<int32_t>(L, 3));
			lua_pushboolean(L, true);
		} else {
			lua_pushboolean(L, false);
		}
	} else {
		lua_pushboolean(L, false);
	}

	return 1;
}

int LuaScriptInterface::luaPlayerAddAccountResource(lua_State* L)
{
	// player:addAccountResource(resourceId, amount)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		uint16_t resourceId = getNumber<uint16_t>(L, 2);
		if (resourceId <= ACCOUNTRESOURCE_LAST) {
			player->addAccountResource(static_cast<AccountResourceTypes_t>(resourceId), getNumber<int32_t>(L, 3));
			lua_pushboolean(L, true);
		} else {
			lua_pushboolean(L, false);
		}
	} else {
		lua_pushboolean(L, false);
	}

	return 1;
}

int LuaScriptInterface::luaPlayerSaveAccountResource(lua_State* L)
{
	// player:saveAccountResource(resourceId)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		uint16_t resourceId = getNumber<uint16_t>(L, 2);
		if (resourceId <= ACCOUNTRESOURCE_LAST) {
			player->saveAccountResource(static_cast<AccountResourceTypes_t>(resourceId));
			lua_pushboolean(L, true);
		} else {
			lua_pushboolean(L, false);
		}
	} else {
		lua_pushboolean(L, false);
	}

	return 1;
}

int LuaScriptInterface::luaPlayerGetCapacity(lua_State* L)
{
	// player:getCapacity()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getCapacity());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSetCapacity(lua_State* L)
{
	// player:setCapacity(capacity)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		player->capacity = getNumber<uint32_t>(L, 2);
		player->sendStats();
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetBaseCapacity(lua_State* L)
{
	// player:getBaseCapacity()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getBaseCapacity());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetFreeCapacity(lua_State* L)
{
	// player:getFreeCapacity()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getFreeCapacity());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetDepotChest(lua_State* L)
{
	// player:getDepotChest(depotId[, autoCreate = false])
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint32_t depotId = getNumber<uint32_t>(L, 2);
	bool autoCreate = getBoolean(L, 3, false);
	DepotChest* depotChest = player->getDepotChest(depotId, autoCreate);
	if (depotChest) {
		pushUserdata<Item>(L, depotChest);
		setItemMetatable(L, -1, depotChest);
	} else {
		pushBoolean(L, false);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetRewardChest(lua_State* L)
{
	// player:getRewardChest()
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	RewardChest* rewardChest = &player->getRewardChest();
	if (rewardChest) {
		pushUserdata<Item>(L, rewardChest);
		setItemMetatable(L, -1, rewardChest);
	} else {
		pushBoolean(L, false);
	}

	return 1;
}

int LuaScriptInterface::luaPlayerGetRewardBagById(lua_State* L)
{
	// player:getRewardBagById(rewardId)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint32_t rewardId = getNumber<uint32_t>(L, 2);
	if (rewardId != 0) {
		if (RewardBag* rewardBag = player->getRewardBagById(rewardId)) {
			pushUserdata<RewardBag>(L, rewardBag);
			setItemMetatable(L, -1, rewardBag);
			return 1;
		}
	}

	lua_pushnil(L);
	return 1;
}

int LuaScriptInterface::luaPlayerGetRewardById(lua_State* L)
{
	// player:getRewardById(rewardId)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint32_t rewardId = getNumber<uint32_t>(L, 2);
	if (rewardId != 0) {
		if (RewardBag* rewardBag = player->getRewardById(rewardId)) {
			pushUserdata<RewardBag>(L, rewardBag);
			setItemMetatable(L, -1, rewardBag);
			return 1;
		}
	}

	lua_pushnil(L);
	return 1;
}

int LuaScriptInterface::luaPlayerGetInbox(lua_State* L)
{
	// player:getInbox()
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	Inbox* inbox = player->getInbox();
	if (inbox) {
		pushUserdata<Item>(L, inbox);
		setItemMetatable(L, -1, inbox);
	} else {
		pushBoolean(L, false);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetSkullTime(lua_State* L)
{
	// player:getSkullTime()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getSkullTicks());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSetSkullTime(lua_State* L)
{
	// player:setSkullTime(skullTime)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		player->setSkullTicks(getNumber<int64_t>(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetDeathPenalty(lua_State* L)
{
	// player:getDeathPenalty()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getLostPercent() * 100);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetExperience(lua_State* L)
{
	// player:getExperience()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getExperience());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerAddExperience(lua_State* L)
{
	// player:addExperience(experience[, sendText = false])
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		uint64_t experience = getNumber<uint64_t>(L, 2);
		bool sendText = getBoolean(L, 3, false);
		player->addExperience(nullptr, experience, sendText);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerRemoveExperience(lua_State* L)
{
	// player:removeExperience(experience[, sendText = false])
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		uint64_t experience = getNumber<uint64_t>(L, 2);
		bool sendText = getBoolean(L, 3, false);
		player->removeExperience(experience, sendText);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetLevel(lua_State* L)
{
	// player:getLevel()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getLevel());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetMagicLevel(lua_State* L)
{
	// player:getMagicLevel()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getMagicLevel());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetBaseMagicLevel(lua_State* L)
{
	// player:getBaseMagicLevel()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getBaseMagicLevel());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetMana(lua_State* L)
{
	// player:getMana()
	const Player* player = getUserdata<const Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getMana());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerAddMana(lua_State* L)
{
	// player:addMana(manaChange[, animationOnLoss = false])
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	int32_t manaChange = getNumber<int32_t>(L, 2);
	bool animationOnLoss = getBoolean(L, 3, false);
	if (!animationOnLoss && manaChange < 0) {
		player->changeMana(manaChange);
	} else {
		CombatDamage damage;
		damage.primary.value = manaChange;
		damage.origin = ORIGIN_NONE;
		g_game.combatChangeMana(nullptr, player, damage);
	}
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerGetMaxMana(lua_State* L)
{
	// player:getMaxMana()
	const Player* player = getUserdata<const Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getMaxMana());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSetMaxMana(lua_State* L)
{
	// player:setMaxMana(maxMana)
	Player* player = getPlayer(L, 1);
	if (player) {
		player->manaMax = getNumber<int32_t>(L, 2);
		player->mana = std::min<int32_t>(player->mana, player->manaMax);
		player->sendStats();
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetManaSpent(lua_State* L)
{
	// player:getManaSpent()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getSpentMana());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerAddManaSpent(lua_State* L)
{
	// player:addManaSpent(amount)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		player->addManaSpent(getNumber<uint64_t>(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerRemoveManaSpent(lua_State* L)
{
	// player:removeManaSpent(amount[, notify = true])
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		player->removeManaSpent(getNumber<uint64_t>(L, 2), getBoolean(L, 3, true));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetBaseMaxHealth(lua_State* L)
{
	// player:getBaseMaxHealth()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->healthMax);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetBaseMaxMana(lua_State* L)
{
	// player:getBaseMaxMana()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->manaMax);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetVibrancy(lua_State* L)
{
	// player:getVibrancy()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->varStats[STAT_VIBRANCY]);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetSkillLevel(lua_State* L)
{
	// player:getSkillLevel(skillType)
	skills_t skillType = getNumber<skills_t>(L, 2);
	Player* player = getUserdata<Player>(L, 1);
	if (player && skillType <= SKILL_LAST) {
		lua_pushnumber(L, player->skills[skillType].level);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetEffectiveSkillLevel(lua_State* L)
{
	// player:getEffectiveSkillLevel(skillType)
	skills_t skillType = getNumber<skills_t>(L, 2);
	Player* player = getUserdata<Player>(L, 1);
	if (player && skillType <= SKILL_LAST) {
		lua_pushnumber(L, player->getSkillLevel(skillType));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetSkillPercent(lua_State* L)
{
	// player:getSkillPercent(skillType)
	skills_t skillType = getNumber<skills_t>(L, 2);
	Player* player = getUserdata<Player>(L, 1);
	if (player && skillType <= SKILL_LAST) {
		lua_pushnumber(L, player->skills[skillType].percent);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetSkillTries(lua_State* L)
{
	// player:getSkillTries(skillType)
	skills_t skillType = getNumber<skills_t>(L, 2);
	Player* player = getUserdata<Player>(L, 1);
	if (player && skillType <= SKILL_LAST) {
		lua_pushnumber(L, player->skills[skillType].tries);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerAddSkillTries(lua_State* L)
{
	// player:addSkillTries(skillType, tries)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		skills_t skillType = getNumber<skills_t>(L, 2);
		uint64_t tries = getNumber<uint64_t>(L, 3);
		player->addSkillAdvance(skillType, tries);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerRemoveSkillTries(lua_State* L)
{
	// player:removeSkillTries(skillType, tries[, notify = true])
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		skills_t skillType = getNumber<skills_t>(L, 2);
		uint64_t tries = getNumber<uint64_t>(L, 3);
		player->removeSkillTries(skillType, tries, getBoolean(L, 4, true));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetSpecialSkill(lua_State* L)
{
	// player:getSpecialSkill(specialSkillType)
	SpecialSkills_t specialSkillType = getNumber<SpecialSkills_t>(L, 2);
	Player* player = getUserdata<Player>(L, 1);
	if (player && specialSkillType <= SPECIALSKILL_LAST) {
		lua_pushnumber(L, player->getSpecialSkill(specialSkillType));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerAddSpecialSkill(lua_State* L)
{
	// player:addSpecialSkill(specialSkillType, value)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	SpecialSkills_t specialSkillType = getNumber<SpecialSkills_t>(L, 2);
	if (specialSkillType > SPECIALSKILL_LAST) {
		lua_pushnil(L);
		return 1;
	}

	player->setVarSpecialSkill(specialSkillType, getNumber<int32_t>(L, 3));
	player->sendSkills();
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerAddOfflineTrainingTime(lua_State* L)
{
	// player:addOfflineTrainingTime(time)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		int32_t time = getNumber<int32_t>(L, 2);
		player->addOfflineTrainingTime(time);
		player->sendStats();
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetOfflineTrainingTime(lua_State* L)
{
	// player:getOfflineTrainingTime()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getOfflineTrainingTime());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerRemoveOfflineTrainingTime(lua_State* L)
{
	// player:removeOfflineTrainingTime(time)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		int32_t time = getNumber<int32_t>(L, 2);
		player->removeOfflineTrainingTime(time);
		player->sendStats();
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerAddOfflineTrainingTries(lua_State* L)
{
	// player:addOfflineTrainingTries(skillType, tries)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		skills_t skillType = getNumber<skills_t>(L, 2);
		uint64_t tries = getNumber<uint64_t>(L, 3);
		pushBoolean(L, player->addOfflineTrainingTries(skillType, tries));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetOfflineTrainingSkill(lua_State* L)
{
	// player:getOfflineTrainingSkill()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getOfflineTrainingSkill());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSetOfflineTrainingSkill(lua_State* L)
{
	// player:setOfflineTrainingSkill(skillId)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		uint32_t skillId = getNumber<int32_t>(L, 2);
		player->setOfflineTrainingSkill(skillId);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetItemCount(lua_State* L)
{
	// player:getItemCount(itemId[, subType = -1[, hasTier = false[, tier = 0]]])
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint16_t itemId;
	if (isNumber(L, 2)) {
		itemId = getNumber<uint16_t>(L, 2);
	} else {
		itemId = Item::items.getItemIdByName(getString(L, 2));
		if (itemId == 0) {
			lua_pushnil(L);
			return 1;
		}
	}

	int32_t subType = getNumber<int32_t>(L, 3, -1);
	bool hasTier = getBoolean(L, 4);
	uint8_t tier = getNumber<uint8_t>(L, 5, 0);

	lua_pushnumber(L, player->getItemTypeCount(itemId, subType, hasTier, tier));
	return 1;
}

int LuaScriptInterface::luaPlayerGetItemById(lua_State* L)
{
	// player:getItemById(itemId, deepSearch[, subType = -1])
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint16_t itemId;
	if (isNumber(L, 2)) {
		itemId = getNumber<uint16_t>(L, 2);
	} else {
		itemId = Item::items.getItemIdByName(getString(L, 2));
		if (itemId == 0) {
			lua_pushnil(L);
			return 1;
		}
	}
	bool deepSearch = getBoolean(L, 3);
	int32_t subType = getNumber<int32_t>(L, 4, -1);

	Item* item = g_game.findItemOfType(player, itemId, deepSearch, subType);
	if (item) {
		pushUserdata<Item>(L, item);
		setItemMetatable(L, -1, item);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetVocation(lua_State* L)
{
	// player:getVocation()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		pushUserdata<Vocation>(L, player->getVocation());
		setMetatable(L, -1, "Vocation");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSetVocation(lua_State* L)
{
	// player:setVocation(id or name or userdata)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	Vocation* vocation;
	if (isNumber(L, 2)) {
		vocation = g_vocations.getVocation(getNumber<uint16_t>(L, 2));
	} else if (isString(L, 2)) {
		vocation = g_vocations.getVocation(g_vocations.getVocationId(getString(L, 2)));
	} else if (isUserdata(L, 2)) {
		vocation = getUserdata<Vocation>(L, 2);
	} else {
		vocation = nullptr;
	}

	if (!vocation) {
		pushBoolean(L, false);
		return 1;
	}

	player->setVocation(vocation->getId());
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerGetSex(lua_State* L)
{
	// player:getSex()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getSex());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSetSex(lua_State* L)
{
	// player:setSex(newSex)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		PlayerSex_t newSex = getNumber<PlayerSex_t>(L, 2);
		player->setSex(newSex);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetTown(lua_State* L)
{
	// player:getTown()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		pushUserdata<Town>(L, player->getTown());
		setMetatable(L, -1, "Town");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSetTown(lua_State* L)
{
	// player:setTown(town)
	Town* town = getUserdata<Town>(L, 2);
	if (!town) {
		pushBoolean(L, false);
		return 1;
	}

	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		player->setTown(town);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetGuild(lua_State* L)
{
	// player:getGuild()
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	Guild* guild = player->getGuild();
	if (!guild) {
		lua_pushnil(L);
		return 1;
	}

	pushUserdata<Guild>(L, guild);
	setMetatable(L, -1, "Guild");
	return 1;
}

int LuaScriptInterface::luaPlayerSetGuild(lua_State* L)
{
	// player:setGuild(guild)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	player->setGuild(getUserdata<Guild>(L, 2));
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerGetGuildLevel(lua_State* L)
{
	// player:getGuildLevel()
	Player* player = getUserdata<Player>(L, 1);
	if (player && player->getGuild()) {
		lua_pushnumber(L, player->getGuildRank()->level);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSetGuildLevel(lua_State* L)
{
	// player:setGuildLevel(level)
	uint8_t level = getNumber<uint8_t>(L, 2);
	Player* player = getUserdata<Player>(L, 1);
	if (!player || !player->getGuild()) {
		lua_pushnil(L);
		return 1;
	}

	GuildRank_ptr rank = player->getGuild()->getRankByLevel(level);
	if (!rank) {
		pushBoolean(L, false);
	} else {
		player->setGuildRank(rank);
		pushBoolean(L, true);
	}

	return 1;
}

int LuaScriptInterface::luaPlayerGetGuildNick(lua_State* L)
{
	// player:getGuildNick()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		pushString(L, player->getGuildNick());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSetGuildNick(lua_State* L)
{
	// player:setGuildNick(nick)
	const std::string& nick = getString(L, 2);
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		player->setGuildNick(nick);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetGroup(lua_State* L)
{
	// player:getGroup()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		pushUserdata<Group>(L, player->getGroup());
		setMetatable(L, -1, "Group");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSetGroup(lua_State* L)
{
	// player:setGroup(group)
	Group* group = getUserdata<Group>(L, 2);
	if (!group) {
		pushBoolean(L, false);
		return 1;
	}

	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		player->setGroup(group);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetStamina(lua_State* L)
{
	// player:getStamina()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getStaminaMinutes());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSetStamina(lua_State* L)
{
	// player:setStamina(stamina)
	uint16_t stamina = getNumber<uint16_t>(L, 2);
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		player->staminaMinutes = std::min<uint16_t>(2520, stamina);
		player->sendStats();
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetSoul(lua_State* L)
{
	// player:getSoul()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getSoul());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerAddSoul(lua_State* L)
{
	// player:addSoul(soulChange)
	int32_t soulChange = getNumber<int32_t>(L, 2);
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		player->changeSoul(soulChange);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetMaxSoul(lua_State* L)
{
	// player:getMaxSoul()
	Player* player = getUserdata<Player>(L, 1);
	if (player && player->vocation) {
		lua_pushnumber(L, player->vocation->getSoulMax());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetBankBalance(lua_State* L)
{
	// player:getBankBalance()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getBankBalance());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSetBankBalance(lua_State* L)
{
	// player:setBankBalance(bankBalance)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	int64_t balance = getNumber<int64_t>(L, 2);
	if (balance < 0) {
		reportErrorFunc(L, "Invalid bank balance value.");
		lua_pushnil(L);
		return 1;
	}

	player->setBankBalance(balance);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerSendResourceBalance(lua_State* L)
{
	// player:sendResourceBalance(resourceId, amount)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		pushBoolean(L, false);
		return 1;
	}

	if (!isNumber(L, 2) || !isNumber(L, 3)) {
		pushBoolean(L, false);
		return 1;
	}
	
	ResourceTypes_t resourceType = getNumber<ResourceTypes_t>(L, 2);
	uint64_t amount = getNumber<uint64_t>(L, 3);

	player->sendResourceBalance(resourceType, amount);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerSendStoreBalance(lua_State* L)
{
	// player:sendStoreBalance()
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	player->sendStoreBalance();
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerGetStorageValue(lua_State* L)
{
	// player:getStorageValue(key)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint32_t key = getNumber<uint32_t>(L, 2);
	int32_t value;
	if (player->getStorageValue(key, value)) {
		lua_pushnumber(L, value);
	} else {
		lua_pushnumber(L, -1);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSetStorageValue(lua_State* L)
{
	// player:setStorageValue(key, value)
	int32_t value = getNumber<int32_t>(L, 3);
	uint32_t key = getNumber<uint32_t>(L, 2);
	Player* player = getUserdata<Player>(L, 1);
	if (IS_IN_KEYRANGE(key, RESERVED_RANGE)) {
		reportErrorFunc(L, fmt::format("Accessing reserved range: {:d}", key));
		pushBoolean(L, false);
		return 1;
	}

	if (player) {
		player->addStorageValue(key, value);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerAddItem(lua_State* L)
{
	// player:addItem(itemId[, count = 1[, canDropOnMap = true[, subType = 1[, slot = CONST_SLOT_WHEREEVER]]]])
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		pushBoolean(L, false);
		return 1;
	}

	uint16_t itemId;
	if (isNumber(L, 2)) {
		itemId = getNumber<uint16_t>(L, 2);
	} else {
		itemId = Item::items.getItemIdByName(getString(L, 2));
		if (itemId == 0) {
			lua_pushnil(L);
			return 1;
		}
	}

	int32_t count = getNumber<int32_t>(L, 3, 1);
	int32_t subType = getNumber<int32_t>(L, 5, 1);

	const ItemType& it = Item::items[itemId];

	int32_t itemCount = 1;
	int parameters = lua_gettop(L);
	if (parameters >= 5 && !it.stackable) {
		itemCount = std::max<int32_t>(1, count);
	} else if (it.hasSubType()) {
		if (it.stackable) {
			itemCount = std::ceil(count / 100.f);
		}

		subType = count;
	} else {
		itemCount = std::max<int32_t>(1, count);
	}

	bool hasTable = itemCount > 1;
	if (hasTable) {
		lua_newtable(L);
	} else if (itemCount == 0) {
		lua_pushnil(L);
		return 1;
	}

	bool canDropOnMap = getBoolean(L, 4, true);
	slots_t slot = getNumber<slots_t>(L, 6, CONST_SLOT_WHEREEVER);
	for (int32_t i = 1; i <= itemCount; ++i) {
		int32_t stackCount = subType;
		if (it.stackable) {
			stackCount = std::min<int32_t>(stackCount, 100);
			subType -= stackCount;
		}

		Item* item = Item::CreateItem(itemId, stackCount);
		if (!item) {
			if (!hasTable) {
				lua_pushnil(L);
			}
			return 1;
		}

		ReturnValue ret = g_game.internalPlayerAddItem(player, item, canDropOnMap, slot);
		if (ret != RETURNVALUE_NOERROR) {
			delete item;
			if (!hasTable) {
				lua_pushnil(L);
			}
			return 1;
		}

		if (hasTable) {
			lua_pushnumber(L, i);
			pushUserdata<Item>(L, item);
			setItemMetatable(L, -1, item);
			lua_settable(L, -3);
		} else {
			pushUserdata<Item>(L, item);
			setItemMetatable(L, -1, item);
		}
	}
	return 1;
}

int LuaScriptInterface::luaPlayerAddItemEx(lua_State* L)
{
	// player:addItemEx(item[, canDropOnMap = false[, index = INDEX_WHEREEVER[, flags = 0]]])
	// player:addItemEx(item[, canDropOnMap = true[, slot = CONST_SLOT_WHEREEVER]])
	Item* item = getUserdata<Item>(L, 2);
	if (!item) {
		reportErrorFunc(L, getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	if (item->getParent() != VirtualCylinder::virtualCylinder) {
		reportErrorFunc(L, "Item already has a parent");
		pushBoolean(L, false);
		return 1;
	}

	bool canDropOnMap = getBoolean(L, 3, false);
	ReturnValue returnValue;
	if (canDropOnMap) {
		slots_t slot = getNumber<slots_t>(L, 4, CONST_SLOT_WHEREEVER);
		returnValue = g_game.internalPlayerAddItem(player, item, true, slot);
	} else {
		int32_t index = getNumber<int32_t>(L, 4, INDEX_WHEREEVER);
		uint32_t flags = getNumber<uint32_t>(L, 5, 0);
		returnValue = g_game.internalAddItem(player, item, index, flags);
	}

	if (returnValue == RETURNVALUE_NOERROR) {
		ScriptEnvironment::removeTempItem(item);
	}
	lua_pushnumber(L, returnValue);
	return 1;
}

int LuaScriptInterface::luaPlayerRemoveItem(lua_State* L)
{
	// player:removeItem(itemId, count[, subType = -1[, ignoreEquipped = false[, skipTiered = false]]])
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint16_t itemId;
	if (isNumber(L, 2)) {
		itemId = getNumber<uint16_t>(L, 2);
	} else {
		itemId = Item::items.getItemIdByName(getString(L, 2));
		if (itemId == 0) {
			lua_pushnil(L);
			return 1;
		}
	}

	uint32_t count = getNumber<uint32_t>(L, 3);
	int32_t subType = getNumber<int32_t>(L, 4, -1);
	bool ignoreEquipped = getBoolean(L, 5, false);
	bool skipTiered = getBoolean(L, 6, false);
	pushBoolean(L, player->removeItemOfType(itemId, count, subType, ignoreEquipped, skipTiered));
	return 1;
}

int LuaScriptInterface::luaPlayerSendSupplyUsed(lua_State* L)
{
	// player:sendSupplyUsed(item)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		reportErrorFunc(L, getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	Item* item = getUserdata<Item>(L, 2);
	if (!item) {
		reportErrorFunc(L, getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	player->sendSupplyUsed(item->getClientID());
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerGetMoney(lua_State* L)
{
	// player:getMoney()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getMoney());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerAddMoney(lua_State* L)
{
	// player:addMoney(money)
	uint64_t money = getNumber<uint64_t>(L, 2);
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		g_game.addMoney(player, money);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerRemoveMoney(lua_State* L)
{
	// player:removeMoney(money)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		uint64_t money = getNumber<uint64_t>(L, 2);
		pushBoolean(L, g_game.removeMoney(player, money));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerShowTextDialog(lua_State* L)
{
	// player:showTextDialog(id or name or userdata[, text[, canWrite[, length]]])
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	int32_t length = getNumber<int32_t>(L, 5, -1);
	bool canWrite = getBoolean(L, 4, false);
	std::string text;

	int parameters = lua_gettop(L);
	if (parameters >= 3) {
		text = getString(L, 3);
	}

	Item* item;
	if (isNumber(L, 2)) {
		item = Item::CreateItem(getNumber<uint16_t>(L, 2));
	} else if (isString(L, 2)) {
		item = Item::CreateItem(Item::items.getItemIdByName(getString(L, 2)));
	} else if (isUserdata(L, 2)) {
		if (getUserdataType(L, 2) != LuaData_Item) {
			pushBoolean(L, false);
			return 1;
		}

		item = getUserdata<Item>(L, 2);
	} else {
		item = nullptr;
	}

	if (!item) {
		reportErrorFunc(L, getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	if (length < 0) {
		length = Item::items[item->getID()].maxTextLen;
	}

	if (!text.empty()) {
		item->setText(text);
		length = std::max<int32_t>(text.size(), length);
	}

	item->setParent(player);
	player->windowTextId++;
	player->writeItem = item;
	player->maxWriteLen = length;
	player->sendTextWindow(item, length, canWrite);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerSendTextMessage(lua_State* L)
{
	// player:sendTextMessage(type, text[, position, primaryValue = 0, primaryColor = TEXTCOLOR_NONE[, secondaryValue = 0, secondaryColor = TEXTCOLOR_NONE]])
	// player:sendTextMessage(type, text, channelId)

	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	int parameters = lua_gettop(L);

	TextMessage message(getNumber<MessageClasses>(L, 2), getString(L, 3));
	if (parameters == 4) {
		uint16_t channelId = getNumber<uint16_t>(L, 4);
		ChatChannel* channel = g_chat->getChannel(*player, channelId);
		if (!channel || !channel->hasUser(*player)) {
			pushBoolean(L, false);
			return 1;
		}
		message.channelId = channelId;
	} else {
		if (parameters >= 6) {
			message.position = getPosition(L, 4);
			message.primary.value = getNumber<int32_t>(L, 5);
			message.primary.color = getNumber<TextColor_t>(L, 6);
		}

		if (parameters >= 8) {
			message.secondary.value = getNumber<int32_t>(L, 7);
			message.secondary.color = getNumber<TextColor_t>(L, 8);
		}
	}

	if (message.type != MESSAGE_STATUS_CONSOLE_BLUE) {
		player->sendTextMessage(message);
	} else {
		player->sendNamedPrivateMessage(std::string(""), TALKTYPE_PRIVATE_FROM, message.text);
	}
	pushBoolean(L, true);

	return 1;
}

int LuaScriptInterface::luaPlayerSendChannelMessage(lua_State* L)
{
	// player:sendChannelMessage(author, text, type, channelId)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint16_t channelId = getNumber<uint16_t>(L, 5);
	MessageClasses type = getNumber<MessageClasses>(L, 4);
	const std::string& text = getString(L, 3);
	const std::string& author = getString(L, 2);
	player->sendChannelMessage(author, text, type, channelId);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerSendPrivateMessage(lua_State* L)
{
	// player:sendPrivateMessage(speaker, text[, type])
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const std::string& text = getString(L, 3);
	MessageClasses type = getNumber<MessageClasses>(L, 4, TALKTYPE_PRIVATE_FROM);

	const Player* speaker = getUserdata<const Player>(L, 2);
	if (!speaker) {
		const std::string& speakerStr = getString(L, 2);
		player->sendNamedPrivateMessage(speakerStr, type, text);
		pushBoolean(L, true);
		return 1;
	}

	player->sendPrivateMessage(speaker, type, text);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerChannelSay(lua_State* L)
{
	// player:channelSay(speaker, type, text, channelId)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	Creature* speaker = getCreature(L, 2);
	MessageClasses type = getNumber<MessageClasses>(L, 3);
	const std::string& text = getString(L, 4);
	uint16_t channelId = getNumber<uint16_t>(L, 5);
	player->sendToChannel(speaker, type, text, channelId);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerOpenChannel(lua_State* L)
{
	// player:openChannel(channelId)
	uint16_t channelId = getNumber<uint16_t>(L, 2);
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		g_game.playerOpenChannel(player->getID(), channelId);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetSlotItem(lua_State* L)
{
	// player:getSlotItem(slot)
	const Player* player = getUserdata<const Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint32_t slot = getNumber<uint32_t>(L, 2);
	Thing* thing = player->getThing(slot);
	if (!thing) {
		lua_pushnil(L);
		return 1;
	}

	Item* item = thing->getItem();
	if (item) {
		pushUserdata<Item>(L, item);
		setItemMetatable(L, -1, item);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetParty(lua_State* L)
{
	// player:getParty()
	const Player* player = getUserdata<const Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	Party* party = player->getParty();
	if (party) {
		pushUserdata<Party>(L, party);
		setMetatable(L, -1, "Party");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerAddOutfit(lua_State* L)
{
	// player:addOutfit(lookType)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		player->addOutfit(getNumber<uint16_t>(L, 2), 0);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerAddOutfitAddon(lua_State* L)
{
	// player:addOutfitAddon(lookType, addon)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		uint16_t lookType = getNumber<uint16_t>(L, 2);
		uint8_t addon = getNumber<uint8_t>(L, 3);
		player->addOutfit(lookType, addon);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerRemoveOutfit(lua_State* L)
{
	// player:removeOutfit(lookType)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		uint16_t lookType = getNumber<uint16_t>(L, 2);
		pushBoolean(L, player->removeOutfit(lookType));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerRemoveOutfitAddon(lua_State* L)
{
	// player:removeOutfitAddon(lookType, addon)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		uint16_t lookType = getNumber<uint16_t>(L, 2);
		uint8_t addon = getNumber<uint8_t>(L, 3);
		pushBoolean(L, player->removeOutfitAddon(lookType, addon));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerHasOutfit(lua_State* L)
{
	// player:hasOutfit(lookType[, addon = 0])
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		uint16_t lookType = getNumber<uint16_t>(L, 2);
		uint8_t addon = getNumber<uint8_t>(L, 3, 0);
		pushBoolean(L, player->hasOutfit(lookType, addon));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerCanWearOutfit(lua_State* L)
{
	// player:canWearOutfit(lookType[, addon = 0])
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		uint16_t lookType = getNumber<uint16_t>(L, 2);
		uint8_t addon = getNumber<uint8_t>(L, 3, 0);
		pushBoolean(L, player->canWear(lookType, addon));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSendOutfitWindow(lua_State* L)
{
	// player:sendOutfitWindow()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		player->sendOutfitWindow();
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSendEditPodium(lua_State* L)
{
	// player:sendEditPodium(item)
	Player* player = getUserdata<Player>(L, 1);
	Item* item = getUserdata<Item>(L, 2);
	if (player && item) {
		player->sendPodiumWindow(item);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerAddMount(lua_State* L) {
	// player:addMount(mountId or mountName)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint8_t mountId;
	if (isNumber(L, 2)) {
		mountId = getNumber<uint8_t>(L, 2);
	} else {
		Mount* mount = g_game.mounts.getMountByName(getString(L, 2));
		if (!mount) {
			lua_pushnil(L);
			return 1;
		}
		mountId = mount->id;
	}
	pushBoolean(L, player->tameMount(mountId));
	return 1;
}

int LuaScriptInterface::luaPlayerRemoveMount(lua_State* L) {
	// player:removeMount(mountId or mountName)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint8_t mountId;
	if (isNumber(L, 2)) {
		mountId = getNumber<uint8_t>(L, 2);
	} else {
		Mount* mount = g_game.mounts.getMountByName(getString(L, 2));
		if (!mount) {
			lua_pushnil(L);
			return 1;
		}
		mountId = mount->id;
	}
	pushBoolean(L, player->untameMount(mountId));
	return 1;
}

int LuaScriptInterface::luaPlayerHasMount(lua_State* L) {
	// player:hasMount(mountId or mountName)
	const Player* player = getUserdata<const Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	Mount* mount = nullptr;
	if (isNumber(L, 2)) {
		mount = g_game.mounts.getMountByID(getNumber<uint8_t>(L, 2));
	} else {
		mount = g_game.mounts.getMountByName(getString(L, 2));
	}

	if (mount) {
		pushBoolean(L, player->hasMount(mount));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerHasRandomizedMount(lua_State* L)
{
	// player:hasRandomizedMount()
	const Player* player = getUserdata<const Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	pushBoolean(L, player->hasRandomizedMount());
	return 1;
}

int LuaScriptInterface::luaPlayerSetRandomizedMount(lua_State* L)
{
	// player:setRandomizedMount(mode)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		pushBoolean(L, false);
		return 1;
	}

	player->setRandomizedMount(getBoolean(L, 2));
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerAddFamiliar(lua_State* L)
{
	// player:addFamiliar(server id or familiar name)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint8_t familiarId;
	if (isNumber(L, 2)) {
		familiarId = getNumber<uint8_t>(L, 2);
	} else {
		Familiar* familiar = g_game.familiars.getFamiliarByName(getString(L, 2));
		if (!familiar) {
			lua_pushnil(L);
			return 1;
		}
		familiarId = familiar->id;
	}
	pushBoolean(L, player->addFamiliar(familiarId));
	return 1;
}

int LuaScriptInterface::luaPlayerRemoveFamiliar(lua_State* L) {
	// player:removeFamiliar(server id or familiar name)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint8_t familiarId;
	if (isNumber(L, 2)) {
		familiarId = getNumber<uint8_t>(L, 2);
	} else {
		Familiar* familiar = g_game.familiars.getFamiliarByName(getString(L, 2));
		if (!familiar) {
			lua_pushnil(L);
			return 1;
		}
		familiarId = familiar->id;
	}
	pushBoolean(L, player->removeFamiliar(familiarId));
	return 1;
}

int LuaScriptInterface::luaPlayerHasFamiliar(lua_State* L) {
	// player:hasFamiliar(server id or familiar name)
	const Player* player = getUserdata<const Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	Familiar* familiar = nullptr;
	if (isNumber(L, 2)) {
		familiar = g_game.familiars.getFamiliarByID(getNumber<uint8_t>(L, 2));
	} else {
		familiar = g_game.familiars.getFamiliarByName(getString(L, 2));
	}

	if (familiar) {
		pushBoolean(L, player->hasFamiliar(familiar));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerCanUseFamiliar(lua_State* L) {
	// player:canUseFamiliar(server id or familiar name)
	const Player* player = getUserdata<const Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	Familiar* familiar = nullptr;
	if (isNumber(L, 2)) {
		familiar = g_game.familiars.getFamiliarByID(getNumber<uint8_t>(L, 2));
	} else {
		familiar = g_game.familiars.getFamiliarByName(getString(L, 2));
	}

	if (familiar) {
		pushBoolean(L, player->canUseFamiliar(familiar));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetCurrentFamiliar(lua_State* L) {
	// player:getCurrentFamiliar()
	const Player* player = getUserdata<const Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	lua_pushnumber(L, player->getCurrentFamiliar());
	return 1;
}

int LuaScriptInterface::luaPlayerSetCurrentFamiliar(lua_State* L) {
	// player:setCurrentFamiliar(server id or familiar name)
	const Player* player = getUserdata<const Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	//pushBoolean(L, false);

	return 1;
}

int LuaScriptInterface::luaPlayerGetPremiumEndsAt(lua_State* L)
{
	// player:getPremiumEndsAt()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->premiumEndsAt);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSetPremiumEndsAt(lua_State* L)
{
	// player:setPremiumEndsAt(timestamp)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	time_t timestamp = getNumber<time_t>(L, 2);

	player->setPremiumTime(timestamp);
	IOLoginData::updatePremiumTime(player->getAccount(), timestamp);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerHasBlessing(lua_State* L)
{
	// player:hasBlessing(blessing)
	uint8_t blessing = getNumber<uint8_t>(L, 2) - 1;
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		pushBoolean(L, player->hasBlessing(blessing));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerAddBlessing(lua_State* L)
{
	// player:addBlessing(blessing)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint8_t blessing = getNumber<uint8_t>(L, 2) - 1;
	if (player->hasBlessing(blessing)) {
		pushBoolean(L, false);
		return 1;
	}

	player->addBlessing(blessing);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerRemoveBlessing(lua_State* L)
{
	// player:removeBlessing(blessing)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint8_t blessing = getNumber<uint8_t>(L, 2) - 1;
	if (!player->hasBlessing(blessing)) {
		pushBoolean(L, false);
		return 1;
	}

	player->removeBlessing(blessing);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerCanLearnSpell(lua_State* L)
{
	// player:canLearnSpell(spellName)
	const Player* player = getUserdata<const Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const std::string& spellName = getString(L, 2);
	InstantSpell* spell = g_spells->getInstantSpellByName(spellName);
	if (!spell) {
		reportErrorFunc(L, "Spell \"" + spellName + "\" not found");
		pushBoolean(L, false);
		return 1;
	}

	if (player->hasFlag(PlayerFlag_IgnoreSpellCheck)) {
		pushBoolean(L, true);
		return 1;
	}

	const auto& vocMap = spell->getVocMap();
	if (vocMap.count(player->getVocationId()) == 0) {
		pushBoolean(L, false);
	} else if (player->getLevel() < spell->getLevel()) {
		pushBoolean(L, false);
	} else if (player->getMagicLevel() < spell->getMagicLevel()) {
		pushBoolean(L, false);
	} else {
		pushBoolean(L, true);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerLearnSpell(lua_State* L)
{
	// player:learnSpell(spellName)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		const std::string& spellName = getString(L, 2);
		player->learnInstantSpell(spellName);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerForgetSpell(lua_State* L)
{
	// player:forgetSpell(spellName)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		const std::string& spellName = getString(L, 2);
		player->forgetInstantSpell(spellName);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerHasLearnedSpell(lua_State* L)
{
	// player:hasLearnedSpell(spellName)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		const std::string& spellName = getString(L, 2);
		pushBoolean(L, player->hasLearnedInstantSpell(spellName));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSetLootContainer(lua_State* L)
{
	// player:setLootContainer(category, lootContainerId)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	LootTypes_t lootCategory = getNumber<LootTypes_t>(L, 2);
	int32_t lootContainerId = getNumber<int32_t>(L, 3);
	if (lootCategory > LOOT_TYPE_NONE && lootCategory <= LOOT_TYPE_LAST) {
		player->setLootContainer(lootCategory, lootContainerId);
		pushBoolean(L, true);
	} else {
		pushBoolean(L, false);
	}
	
	return 1;
}

int LuaScriptInterface::luaPlayerGetLootContainer(lua_State* L)
{
	// player:getLootContainer(category)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	LootTypes_t lootCategory = getNumber<LootTypes_t>(L, 2);
	if (lootCategory > LOOT_TYPE_NONE && lootCategory <= LOOT_TYPE_LAST) {
		lua_pushnumber(L, player->getLootContainer(lootCategory));
	} else {
		lua_pushnil(L);
	}

	return 1;
}

int LuaScriptInterface::luaPlayerGetLootContainerFlags(lua_State* L)
{
	// player:getLootContainerFlags(lootContainerId)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	int32_t lootContainerId = getNumber<int32_t>(L, 2);
	if (lootContainerId == 0) {
		lua_pushnil(L);
		return 1;
	}

	lua_pushnumber(L, player->getLootContainerFlags(lootContainerId));
	return 1;
}

int LuaScriptInterface::luaPlayerSendTutorial(lua_State* L)
{
	// player:sendTutorial(tutorialId)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		uint8_t tutorialId = getNumber<uint8_t>(L, 2);
		player->sendTutorial(tutorialId);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerAddMapMark(lua_State* L)
{
	// player:addMapMark(position, type, description)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		const Position& position = getPosition(L, 2);
		uint8_t type = getNumber<uint8_t>(L, 3);
		const std::string& description = getString(L, 4);
		player->sendAddMarker(position, type, description);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSave(lua_State* L)
{
	// player:save()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		player->loginPosition = player->getPosition();
		pushBoolean(L, IOLoginData::savePlayer(player));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerPopupFYI(lua_State* L)
{
	// player:popupFYI(message)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		const std::string& message = getString(L, 2);
		player->sendFYIBox(message);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerIsPzLocked(lua_State* L)
{
	// player:isPzLocked()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		pushBoolean(L, player->isPzLocked());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetClient(lua_State* L)
{
	// player:getClient()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_createtable(L, 0, 2);
		setField(L, "version", player->getProtocolVersion());
		setField(L, "os", player->getOperatingSystem());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetHouse(lua_State* L)
{
	// player:getHouse()
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	House* house = g_game.map.houses.getHouseByPlayerId(player->getGUID());
	if (house) {
		pushUserdata<House>(L, house);
		setMetatable(L, -1, "House");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSendHouseWindow(lua_State* L)
{
	// player:sendHouseWindow(house, listId)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	House* house = getUserdata<House>(L, 2);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	uint32_t listId = getNumber<uint32_t>(L, 3);
	player->sendHouseWindow(house, listId);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerSetEditHouse(lua_State* L)
{
	// player:setEditHouse(house, listId)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	House* house = getUserdata<House>(L, 2);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	uint32_t listId = getNumber<uint32_t>(L, 3);
	player->setEditHouse(house, listId);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerSetGhostMode(lua_State* L)
{
	// player:setGhostMode(enabled[, magicEffect = CONST_ME_TELEPORT])
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	bool enabled = getBoolean(L, 2);
	if (player->isInGhostMode() == enabled) {
		pushBoolean(L, true);
		return 1;
	}

	MagicEffectClasses magicEffect = getNumber<MagicEffectClasses>(L, 3, CONST_ME_TELEPORT);

	player->switchGhostMode();

	Tile* tile = player->getTile();
	const Position& position = player->getPosition();
	const bool isInvisible = player->isInvisible();

	SpectatorVec spectators;
	g_game.map.getSpectators(spectators, position, true, true);
	for (Creature* spectator : spectators) {
		Player* tmpPlayer = spectator->getPlayer();
		if (tmpPlayer != player && !tmpPlayer->isAccessPlayer()) {
			if (enabled) {
				tmpPlayer->sendRemoveTileCreature(player, position, tile->getClientIndexOfCreature(tmpPlayer, player));
			} else {
				tmpPlayer->sendCreatureAppear(player, position, magicEffect);
			}
		} else {
			if (isInvisible) {
				continue;
			}

			tmpPlayer->sendCreatureChangeVisible(player, !enabled);
		}
	}

	if (player->isInGhostMode()) {
		for (const auto& it : g_game.getPlayers()) {
			if (!it.second->isAccessPlayer()) {
				it.second->notifyStatusChange(player, VIPSTATUS_OFFLINE);
			}
		}
		IOLoginData::updateOnlineStatus(player->getGUID(), false);
	} else {
		for (const auto& it : g_game.getPlayers()) {
			if (!it.second->isAccessPlayer()) {
				it.second->notifyStatusChange(player, VIPSTATUS_ONLINE);
			}
		}
		IOLoginData::updateOnlineStatus(player->getGUID(), true);
	}
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerGetContainerId(lua_State* L)
{
	// player:getContainerId(container)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	Container* container = getUserdata<Container>(L, 2);
	if (container) {
		lua_pushnumber(L, player->getContainerID(container));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetContainerById(lua_State* L)
{
	// player:getContainerById(id)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	Container* container = player->getContainerByID(getNumber<uint8_t>(L, 2));
	if (container) {
		pushUserdata<Container>(L, container);
		setMetatable(L, -1, "Container");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetContainerIndex(lua_State* L)
{
	// player:getContainerIndex(id)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getContainerIndex(getNumber<uint8_t>(L, 2)));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetOpenContainers(lua_State* L)
{
	// player:getOpenContainers()
	// returns windowId and userdata of opened containers
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		const auto& openContainers = player->getOpenContainers();

		lua_createtable(L, openContainers.size(), 0);
		for (auto const& containerInfo : openContainers) {
			pushUserdata<Container>(L, containerInfo.second.container);
			setMetatable(L, -1, "Container");
			lua_rawseti(L, -2, containerInfo.first);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}


int LuaScriptInterface::luaPlayerGetInstantSpells(lua_State* L)
{
	// player:getInstantSpells()
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	std::vector<const InstantSpell*> spells;
	for (auto& spell : g_spells->getInstantSpells()) {
		if (spell.second.canCast(player)) {
			spells.push_back(&spell.second);
		}
	}

	lua_createtable(L, spells.size(), 0);

	int index = 0;
	for (auto spell : spells) {
		pushInstantSpell(L, *spell);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerCanCast(lua_State* L)
{
	// player:canCast(spell)
	Player* player = getUserdata<Player>(L, 1);
	InstantSpell* spell = getUserdata<InstantSpell>(L, 2);
	if (player && spell) {
		pushBoolean(L, spell->canCast(player));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerHasChaseMode(lua_State* L)
{
	// player:hasChaseMode()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		pushBoolean(L, player->chaseMode);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerHasSecureMode(lua_State* L)
{
	// player:hasSecureMode()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		pushBoolean(L, player->secureMode);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetFightMode(lua_State* L)
{
	// player:getFightMode()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->fightMode);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetStoreInbox(lua_State* L)
{
	// player:getStoreInbox()
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	Container* storeInbox = player->getStoreInbox();
	if (!storeInbox) {
		lua_pushnil(L);
		return 1;
	}

	pushUserdata<Container>(L, storeInbox);
	setMetatable(L, -1, "Container");
	return 1;
}

int LuaScriptInterface::luaPlayerIsNearDepotBox(lua_State* L)
{
	// player:isNearDepotBox()
	const Player* const player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	pushBoolean(L, player->isNearDepotBox());
	return 1;
}

int LuaScriptInterface::luaPlayerGetTrainingDummy(lua_State* L)
{
	// player:getTrainingDummy()
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	Item* dummy = player->getTrainingDummy();
	if (!dummy) {
		lua_pushnil(L);
		return 1;
	}

	pushUserdata<Item>(L, dummy);
	setMetatable(L, -1, "Item");
	return 1;
}

int LuaScriptInterface::luaPlayerGetIdleTime(lua_State* L)
{
	// player:getIdleTime()
	const Player* const player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	lua_pushnumber(L, player->getIdleTime());
	return 1;
}

int LuaScriptInterface::luaPlayerIsIgnoringFriction(lua_State* L)
{
	// player:isIgnoringFriction()
	const Player* player = getUserdata<const Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	pushBoolean(L, player->isIgnoringFriction());
	return 1;
}

int LuaScriptInterface::luaPlayerSetIgnoreFriction(lua_State* L)
{
	// player:setIgnoreFriction(mode)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		pushBoolean(L, false);
		return 1;
	}

	player->setIgnoreFriction(getBoolean(L, 2));
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerStartTraining(lua_State* L)
{
	// player:startTraining(weapon, dummy)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		pushBoolean(L, false);
		return 1;
	}

	Item* weapon = getUserdata<Item>(L, 2);
	if (!weapon) {
		pushBoolean(L, false);
		return 1;
	}

	Item* dummy = getUserdata<Item>(L, 3);
	if (!dummy) {
		pushBoolean(L, false);
		return 1;
	}

	player->startTraining(weapon, dummy);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerImbuementsReload(lua_State* L)
{
	// helper for reloading imbuements
	// equip: false - unequips all imbuements, true - equips all imbuements
	// player:imbuementsReload(equip)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		pushBoolean(L, false);
		return 1;
	}

	bool equip = getBoolean(L, 2);
	for (int32_t slotId = CONST_SLOT_FIRST; slotId <= CONST_SLOT_LAST; ++slotId) {
		slots_t slot = static_cast<slots_t>(slotId);
		Item* item = player->getInventoryItem(slot);
		if (item) {
			player->toggleImbuements(item, equip, true);
		}
	}

	if (equip) {
		player->sendStats();
		player->sendSkills();
	}

	pushBoolean(L, true);
	return 1;
}
