// Copyright 2022 Xynera.net. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "luascript.h"

#include "rewardchest.h"

// RewardBag
int LuaScriptInterface::luaRewardBagCreate(lua_State* L)
{
	// RewardBag(uid)
	uint32_t id = getNumber<uint32_t>(L, 2);

	if (Item* rewardContainer = getScriptEnv()->getItemByUID(id)) {
		std::cout << "container" << std::endl;
		if (RewardBag* rewardBag = rewardContainer->getRewardBag()) {
			std::cout << "bag" << std::endl;
			pushUserdata(L, rewardBag);
			setMetatable(L, -1, "RewardBag");
			return 1;
		}
	}

	lua_pushnil(L);
	return 1;
}

int LuaScriptInterface::luaRewardBagRewardId(lua_State* L)
{
	// get: rewardBag:rewardId() set: rewardBag:rewardId(id)
	RewardBag* rewardBag = getUserdata<RewardBag>(L, 1);
	if (rewardBag) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, rewardBag->getRewardId());
		} else {
			rewardBag->setRewardId(getNumber<uint32_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}

	return 1;
}

int LuaScriptInterface::luaRewardBagCreatedAt(lua_State* L)
{
	// get: rewardBag:createdAt() set: rewardBag:createdAt(timestamp)
	// timestamp in seconds
	RewardBag* rewardBag = getUserdata<RewardBag>(L, 1);
	if (rewardBag) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, rewardBag->getCreationTime() / 1000);
		} else {
			rewardBag->setCreationTime(getNumber<int64_t>(L, 2) * 1000);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}

	return 1;
}
