// Copyright 2022 Xynera.net. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "luascript.h"

// os
int LuaScriptInterface::luaSystemTime(lua_State* L)
{
	// os.mtime()
	lua_pushnumber(L, OTSYS_TIME());
	return 1;
}