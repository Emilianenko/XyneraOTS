// Copyright 2022 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "scriptmanager.h"

#include "actions.h"
#include "chat.h"
#include "events.h"
#include "globalevent.h"
#include "movement.h"
#include "script.h"
#include "spells.h"
#include "talkaction.h"
#include "weapons.h"

Actions* g_actions = nullptr;
CreatureEvents* g_creatureEvents = nullptr;
Chat* g_chat = nullptr;
Events* g_events = nullptr;
GlobalEvents* g_globalEvents = nullptr;
Spells* g_spells = nullptr;
TalkActions* g_talkActions = nullptr;
MoveEvents* g_moveEvents = nullptr;
Weapons* g_weapons = nullptr;
Scripts* g_scripts = nullptr;

extern LuaEnvironment g_luaEnvironment;

ScriptingManager::~ScriptingManager()
{
	delete g_events;
	delete g_weapons;
	delete g_spells;
	delete g_actions;
	delete g_talkActions;
	delete g_moveEvents;
	delete g_chat;
	delete g_creatureEvents;
	delete g_globalEvents;
	delete g_scripts;
}

bool ScriptingManager::loadScriptSystems()
{
	std::string location = "ScriptingManager::loadScriptSystems";
	if (g_luaEnvironment.loadFile("data/global.lua") == -1) {
		console::reportFileError(location, "data/global.lua");
	}

	g_scripts = new Scripts();
	if (!g_scripts->loadScripts("scripts/lib", true, false)) {
		console::reportFileError(location, "lua libs");
		return false;
	}

	g_chat = new Chat();

	g_weapons = new Weapons();
	if (!g_weapons->loadFromXml()) {
		console::reportFileError(location, "weapons");
		return false;
	}

	g_weapons->loadDefaults();

	g_spells = new Spells();
	if (!g_spells->loadFromXml()) {
		console::reportFileError(location, "spells");
		return false;
	}

	g_actions = new Actions();
	if (!g_actions->loadFromXml()) {
		console::reportFileError(location, "actions");
		return false;
	}

	g_talkActions = new TalkActions();
	if (!g_talkActions->loadFromXml()) {
		console::reportFileError(location, "talkactions");
		return false;
	}

	g_moveEvents = new MoveEvents();
	if (!g_moveEvents->loadFromXml()) {
		console::reportFileError(location, "moveevents");
		return false;
	}

	g_creatureEvents = new CreatureEvents();
	if (!g_creatureEvents->loadFromXml()) {
		console::reportFileError(location, "creatureevents");
		return false;
	}

	g_globalEvents = new GlobalEvents();
	if (!g_globalEvents->loadFromXml()) {
		console::reportFileError(location, "globalevents");
		return false;
	}

	g_events = new Events();
	if (!g_events->load()) {
		console::reportFileError(location, "events");
		return false;
	}

	return true;
}
