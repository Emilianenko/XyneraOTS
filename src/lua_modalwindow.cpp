// Copyright 2022 Xynera.net. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "luascript.h"

#include "player.h"

// ModalWindow
int LuaScriptInterface::luaModalWindowCreate(lua_State* L)
{
	// ModalWindow(id, title, message)
	const std::string& message = getString(L, 4);
	const std::string& title = getString(L, 3);
	uint32_t id = getNumber<uint32_t>(L, 2);

	pushUserdata<ModalWindow>(L, new ModalWindow(id, title, message));
	setMetatable(L, -1, "ModalWindow");
	return 1;
}

int LuaScriptInterface::luaModalWindowDelete(lua_State* L)
{
	ModalWindow** windowPtr = getRawUserdata<ModalWindow>(L, 1);
	if (windowPtr && *windowPtr) {
		delete *windowPtr;
		*windowPtr = nullptr;
	}
	return 0;
}

int LuaScriptInterface::luaModalWindowGetId(lua_State* L)
{
	// modalWindow:getId()
	ModalWindow* window = getUserdata<ModalWindow>(L, 1);
	if (window) {
		lua_pushnumber(L, window->id);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaModalWindowGetTitle(lua_State* L)
{
	// modalWindow:getTitle()
	ModalWindow* window = getUserdata<ModalWindow>(L, 1);
	if (window) {
		pushString(L, window->title);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaModalWindowGetMessage(lua_State* L)
{
	// modalWindow:getMessage()
	ModalWindow* window = getUserdata<ModalWindow>(L, 1);
	if (window) {
		pushString(L, window->message);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaModalWindowSetTitle(lua_State* L)
{
	// modalWindow:setTitle(text)
	const std::string& text = getString(L, 2);
	ModalWindow* window = getUserdata<ModalWindow>(L, 1);
	if (window) {
		window->title = text;
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaModalWindowSetMessage(lua_State* L)
{
	// modalWindow:setMessage(text)
	const std::string& text = getString(L, 2);
	ModalWindow* window = getUserdata<ModalWindow>(L, 1);
	if (window) {
		window->message = text;
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaModalWindowGetButtonCount(lua_State* L)
{
	// modalWindow:getButtonCount()
	ModalWindow* window = getUserdata<ModalWindow>(L, 1);
	if (window) {
		lua_pushnumber(L, window->buttons.size());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaModalWindowGetChoiceCount(lua_State* L)
{
	// modalWindow:getChoiceCount()
	ModalWindow* window = getUserdata<ModalWindow>(L, 1);
	if (window) {
		lua_pushnumber(L, window->choices.size());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaModalWindowAddButton(lua_State* L)
{
	// modalWindow:addButton(id, text)
	const std::string& text = getString(L, 3);
	uint8_t id = getNumber<uint8_t>(L, 2);
	ModalWindow* window = getUserdata<ModalWindow>(L, 1);
	if (window) {
		window->buttons.emplace_back(text, id);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaModalWindowAddChoice(lua_State* L)
{
	// modalWindow:addChoice(id, text)
	const std::string& text = getString(L, 3);
	uint8_t id = getNumber<uint8_t>(L, 2);
	ModalWindow* window = getUserdata<ModalWindow>(L, 1);
	if (window) {
		window->choices.emplace_back(text, id);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaModalWindowGetDefaultEnterButton(lua_State* L)
{
	// modalWindow:getDefaultEnterButton()
	ModalWindow* window = getUserdata<ModalWindow>(L, 1);
	if (window) {
		lua_pushnumber(L, window->defaultEnterButton);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaModalWindowSetDefaultEnterButton(lua_State* L)
{
	// modalWindow:setDefaultEnterButton(buttonId)
	ModalWindow* window = getUserdata<ModalWindow>(L, 1);
	if (window) {
		window->defaultEnterButton = getNumber<uint8_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaModalWindowGetDefaultEscapeButton(lua_State* L)
{
	// modalWindow:getDefaultEscapeButton()
	ModalWindow* window = getUserdata<ModalWindow>(L, 1);
	if (window) {
		lua_pushnumber(L, window->defaultEscapeButton);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaModalWindowSetDefaultEscapeButton(lua_State* L)
{
	// modalWindow:setDefaultEscapeButton(buttonId)
	ModalWindow* window = getUserdata<ModalWindow>(L, 1);
	if (window) {
		window->defaultEscapeButton = getNumber<uint8_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaModalWindowHasPriority(lua_State* L)
{
	// modalWindow:hasPriority()
	ModalWindow* window = getUserdata<ModalWindow>(L, 1);
	if (window) {
		pushBoolean(L, window->priority);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaModalWindowSetPriority(lua_State* L)
{
	// modalWindow:setPriority(priority)
	ModalWindow* window = getUserdata<ModalWindow>(L, 1);
	if (window) {
		window->priority = getBoolean(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaModalWindowSendToPlayer(lua_State* L)
{
	// modalWindow:sendToPlayer(player)
	Player* player = getPlayer(L, 2);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	ModalWindow* window = getUserdata<ModalWindow>(L, 1);
	if (window) {
		if (!player->hasModalWindowOpen(window->id)) {
			player->sendModalWindow(*window);
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}
