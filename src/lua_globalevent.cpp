// Copyright 2022 Xynera.net. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "luascript.h"

#include "globalevent.h"
#include "script.h"

extern GlobalEvents* g_globalEvents;
extern Scripts* g_scripts;

int LuaScriptInterface::luaCreateGlobalEvent(lua_State* L)
{
	// GlobalEvent(eventName)
	if (getScriptEnv()->getScriptInterface() != &g_scripts->getScriptInterface()) {
		reportErrorFunc(L, "GlobalEvents can only be registered in the Scripts interface.");
		lua_pushnil(L);
		return 1;
	}

	GlobalEvent* global = new GlobalEvent(getScriptEnv()->getScriptInterface());
	if (global) {
		global->setName(getString(L, 2));
		global->setEventType(GLOBALEVENT_NONE);
		global->fromLua = true;
		pushUserdata<GlobalEvent>(L, global);
		setMetatable(L, -1, "GlobalEvent");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGlobalEventType(lua_State* L)
{
	// globalevent:type(callback)
	GlobalEvent* global = getUserdata<GlobalEvent>(L, 1);
	if (global) {
		std::string typeName = getString(L, 2);
		std::string tmpStr = asLowerCaseString(typeName);
		if (tmpStr == "startup") {
			global->setEventType(GLOBALEVENT_STARTUP);
		} else if (tmpStr == "shutdown") {
			global->setEventType(GLOBALEVENT_SHUTDOWN);
		} else if (tmpStr == "record") {
			global->setEventType(GLOBALEVENT_RECORD);
		} else {
			console::reportError("GlobalEvent:type", "Invalid event type \"" + typeName + "\"!");
			pushBoolean(L, false);
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGlobalEventRegister(lua_State* L)
{
	// globalevent:register()
	GlobalEvent* globalevent = getUserdata<GlobalEvent>(L, 1);
	if (globalevent) {
		if (!globalevent->isScripted()) {
			pushBoolean(L, false);
			return 1;
		}
		
		if (globalevent->getEventType() == GLOBALEVENT_NONE && globalevent->getInterval() == 0) {
			console::reportError("GlobalEvent:register", "Missing interval for globalevent \"" + globalevent->getName() + "\"!");
			pushBoolean(L, false);
			return 1;
		}
		
		pushBoolean(L, g_globalEvents->registerLuaEvent(globalevent));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGlobalEventOnCallback(lua_State* L)
{
	// globalevent:onThink / record / etc. (callback)
	GlobalEvent* globalevent = getUserdata<GlobalEvent>(L, 1);
	if (globalevent) {
		if (!globalevent->loadCallback()) {
			pushBoolean(L, false);
			return 1;
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGlobalEventTime(lua_State* L)
{
	// globalevent:time(time)
	GlobalEvent* globalevent = getUserdata<GlobalEvent>(L, 1);
	if (globalevent) {
		std::string timer = getString(L, 2);
		std::vector<int32_t> params = vectorAtoi(explodeString(timer, ":"));

		int32_t hour = params.front();
		if (hour < 0 || hour > 23) {
			console::reportError("GlobalEvent:time", fmt::format("Invalid hour \"{:s}\" for globalevent with name \"{:s}\"!", timer, globalevent->getName()));
			pushBoolean(L, false);
			return 1;
		}

		globalevent->setInterval(hour << 16);

		int32_t min = 0;
		int32_t sec = 0;
		if (params.size() > 1) {
			min = params[1];
			if (min < 0 || min > 59) {
				console::reportError("GlobalEvent:time", fmt::format("Invalid minute \"{:s}\" for globalevent with name \"{:s}\"!", timer, globalevent->getName()));
				pushBoolean(L, false);
				return 1;
			}

			if (params.size() > 2) {
				sec = params[2];
				if (sec < 0 || sec > 59) {
					console::reportError("GlobalEvent:time", fmt::format("Invalid second \"{:s}\" for globalevent with name \"{:s}\"!", timer, globalevent->getName()));
					pushBoolean(L, false);
					return 1;
				}
			}
		}

		time_t current_time = time(nullptr);
		tm* timeinfo = localtime(&current_time);
		timeinfo->tm_hour = hour;
		timeinfo->tm_min = min;
		timeinfo->tm_sec = sec;

		time_t difference = static_cast<time_t>(difftime(mktime(timeinfo), current_time));
		if (difference < 0) {
			difference += 86400;
		}

		globalevent->setNextExecution(current_time + difference);
		globalevent->setEventType(GLOBALEVENT_TIMER);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGlobalEventInterval(lua_State* L)
{
	// globalevent:interval(interval)
	GlobalEvent* globalevent = getUserdata<GlobalEvent>(L, 1);
	if (globalevent) {
		globalevent->setInterval(getNumber<uint32_t>(L, 2));
		globalevent->setNextExecution(OTSYS_TIME() + getNumber<uint32_t>(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}
