// Copyright 2022 Xynera.net. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "luascript.h"

#include "talkaction.h"
#include "script.h"

extern Scripts* g_scripts;
extern TalkActions* g_talkActions;

int LuaScriptInterface::luaCreateTalkaction(lua_State* L)
{
	// TalkAction(words)
	if (getScriptEnv()->getScriptInterface() != &g_scripts->getScriptInterface()) {
		reportErrorFunc(L, "TalkActions can only be registered in the Scripts interface.");
		lua_pushnil(L);
		return 1;
	}

	TalkAction* talk = new TalkAction(getScriptEnv()->getScriptInterface());
	if (talk) {
		for (int i = 2; i <= lua_gettop(L); i++) {
			talk->setWords(getString(L, i));
		}
		talk->fromLua = true;
		pushUserdata<TalkAction>(L, talk);
		setMetatable(L, -1, "TalkAction");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaTalkactionOnSay(lua_State* L)
{
	// talkAction:onSay(callback)
	TalkAction* talk = getUserdata<TalkAction>(L, 1);
	if (talk) {
		if (!talk->loadCallback()) {
			pushBoolean(L, false);
			return 1;
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaTalkactionRegister(lua_State* L)
{
	// talkAction:register()
	TalkAction* talk = getUserdata<TalkAction>(L, 1);
	if (talk) {
		if (!talk->isScripted()) {
			pushBoolean(L, false);
			return 1;
		}
		pushBoolean(L, g_talkActions->registerLuaEvent(talk));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaTalkactionSeparator(lua_State* L)
{
	// talkAction:separator(sep)
	TalkAction* talk = getUserdata<TalkAction>(L, 1);
	if (talk) {
		talk->setSeparator(getString(L, 2).c_str());
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaTalkactionAccess(lua_State* L)
{
	// talkAction:access(needAccess = false)
	TalkAction* talk = getUserdata<TalkAction>(L, 1);
	if (talk) {
		talk->setNeedAccess(getBoolean(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaTalkactionAccountType(lua_State* L)
{
	// talkAction:accountType(AccountType_t = ACCOUNT_TYPE_NORMAL)
	TalkAction* talk = getUserdata<TalkAction>(L, 1);
	if (talk) {
		talk->setRequiredAccountType(getNumber<AccountType_t>(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}
