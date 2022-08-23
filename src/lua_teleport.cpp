// Copyright 2022 Xynera.net. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "luascript.h"

#include "item.h"
#include "teleport.h"

// Teleport
int LuaScriptInterface::luaTeleportCreate(lua_State* L)
{
	// Teleport(uid)
	uint32_t id = getNumber<uint32_t>(L, 2);

	Item* item = getScriptEnv()->getItemByUID(id);
	if (item && item->getTeleport()) {
		pushUserdata(L, item);
		setMetatable(L, -1, "Teleport");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaTeleportGetDestination(lua_State* L)
{
	// teleport:getDestination()
	Teleport* teleport = getUserdata<Teleport>(L, 1);
	if (teleport) {
		pushPosition(L, teleport->getDestPos());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaTeleportSetDestination(lua_State* L)
{
	// teleport:setDestination(position)
	Teleport* teleport = getUserdata<Teleport>(L, 1);
	if (teleport) {
		teleport->setDestPos(getPosition(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}
