// Copyright 2022 Xynera.net. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "luascript.h"

#include "game.h"
#include "npc.h"

extern Game g_game;

// Npc
int LuaScriptInterface::luaNpcCreate(lua_State* L)
{
	// Npc([id or name or userdata])
	Npc* npc;
	if (lua_gettop(L) >= 2) {
		if (isNumber(L, 2)) {
			npc = g_game.getNpcByID(getNumber<uint32_t>(L, 2));
		} else if (isString(L, 2)) {
			npc = g_game.getNpcByName(getString(L, 2));
		} else if (isUserdata(L, 2)) {
			if (getUserdataType(L, 2) != LuaData_Npc) {
				lua_pushnil(L);
				return 1;
			}
			npc = getUserdata<Npc>(L, 2);
		} else {
			npc = nullptr;
		}
	} else {
		npc = getScriptEnv()->getNpc();
	}

	if (npc) {
		pushUserdata<Npc>(L, npc);
		setMetatable(L, -1, "Npc");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNpcIsNpc(lua_State* L)
{
	// npc:isNpc()
	pushBoolean(L, getUserdata<const Npc>(L, 1) != nullptr);
	return 1;
}

int LuaScriptInterface::luaNpcSetName(lua_State* L)
{
	// npc:setName(newName)
	Npc* npc = getUserdata<Npc>(L, 1);
	if (!npc) {
		lua_pushnil(L);
		return 1;
	}

	std::string name = getString(L, 2);
	if (name.empty()) {
		name = npc->getDefaultName();
	}

	npc->setName(name);

	// make sure new name will be sent when viewing npc again
	for (auto& it : g_game.getPlayers()) {
		if (Player* player = it.second) {
			player->forgetCreatureID(npc->getID());
		}
	}

	// update creature on screen
	npc->refreshInClient();

	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaNpcSetMasterPos(lua_State* L)
{
	// npc:setMasterPos(pos[, radius])
	Npc* npc = getUserdata<Npc>(L, 1);
	if (!npc) {
		lua_pushnil(L);
		return 1;
	}

	const Position& pos = getPosition(L, 2);
	int32_t radius = getNumber<int32_t>(L, 3, 1);
	npc->setMasterPos(pos, radius);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaNpcGetMasterPos(lua_State* L)
{
	// npc:getMasterPos()
	Npc* npc = getUserdata<Npc>(L, 1);
	if (!npc) {
		lua_pushnil(L);
		return 1;
	}

	const Position& pos = npc->getMasterPos();
	pushPosition(L, pos);
	return 1;
}

int LuaScriptInterface::luaNpcSetOwnerGUID(lua_State* L)
{
	// npc:setOwnerGUID(guid)
	Npc* npc = getUserdata<Npc>(L, 1);
	if (!npc) {
		lua_pushnil(L);
		return 1;
	}

	uint32_t ownerId = getNumber<uint32_t>(L, 2);
	npc->setOwner(ownerId);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaNpcGetOwnerGUID(lua_State* L)
{
	// npc:getOwnerGUID(guid)
	Npc* npc = getUserdata<Npc>(L, 1);
	if (!npc) {
		lua_pushnil(L);
		return 1;
	}
	
	lua_pushnumber(L, npc->getOwner());
	return 1;
}

int LuaScriptInterface::luaNpcGetSex(lua_State* L)
{
	// npc:getSex()
	Npc* npc = getUserdata<Npc>(L, 1);
	if (npc) {
		lua_pushnumber(L, npc->getSex());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNpcSetSex(lua_State* L)
{
	// npc:setSex(newSex)
	Npc* npc = getUserdata<Npc>(L, 1);
	if (npc) {
		PlayerSex_t newSex = getNumber<PlayerSex_t>(L, 2);
		npc->setSex(newSex);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}
