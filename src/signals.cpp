// Copyright 2022 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "signals.h"

#include "actions.h"
#include "configmanager.h"
#include "databasetasks.h"
#include "events.h"
#include "game.h"
#include "globalevent.h"
#include "monsters.h"
#include "mounts.h"
#include "movement.h"
#include "npc.h"
#include "quests.h"
#include "raids.h"
#include "scheduler.h"
#include "spells.h"
#include "talkaction.h"
#include "tasks.h"
#include "weapons.h"

#include <csignal>

extern Scheduler g_scheduler;
extern DatabaseTasks g_databaseTasks;
extern Dispatcher g_dispatcher;

extern ConfigManager g_config;
extern Actions* g_actions;
extern Monsters g_monsters;
extern TalkActions* g_talkActions;
extern MoveEvents* g_moveEvents;
extern Spells* g_spells;
extern Weapons* g_weapons;
extern Game g_game;
extern CreatureEvents* g_creatureEvents;
extern GlobalEvents* g_globalEvents;
extern Events* g_events;
extern Chat* g_chat;
extern LuaEnvironment g_luaEnvironment;

namespace {

#ifndef _WIN32

void sigusr1Handler()
{
	//Dispatcher thread
	console::print(CONSOLEMESSAGE_TYPE_INFO, "SIGUSR1 received, saving the game state...");
	g_game.saveGameState();
}

void sighupHandler()
{
	//Dispatcher thread
	console::print(CONSOLEMESSAGE_TYPE_INFO, "SIGHUP received, reloading config files...");

	g_actions->reload();
	console::print(CONSOLEMESSAGE_TYPE_INFO, "Reloaded actions.");

	g_config.reload();
	console::print(CONSOLEMESSAGE_TYPE_INFO, "Reloaded config.");

	g_creatureEvents->reload();
	console::print(CONSOLEMESSAGE_TYPE_INFO, "Reloaded creaturescripts.");

	g_moveEvents->reload();
	console::print(CONSOLEMESSAGE_TYPE_INFO, "Reloaded movements.");

	Npcs::reload();
	console::print(CONSOLEMESSAGE_TYPE_INFO, "Reloaded NPCs.");

	g_game.raids.reload();
	g_game.raids.startup();
	console::print(CONSOLEMESSAGE_TYPE_INFO, "Reloaded raids.");

	g_monsters.reload();
	console::print(CONSOLEMESSAGE_TYPE_INFO, "Reloaded monsters.");

	g_spells->reload();
	console::print(CONSOLEMESSAGE_TYPE_INFO, "Reloaded spells.");

	g_talkActions->reload();
	console::print(CONSOLEMESSAGE_TYPE_INFO, "Reloaded talkactions.");

	Item::items.reload();
	console::print(CONSOLEMESSAGE_TYPE_INFO, "Reloaded items.");

	g_weapons->reload();
	g_weapons->loadDefaults();
	console::print(CONSOLEMESSAGE_TYPE_INFO, "Reloaded weapons.");

	g_game.quests.reload();
	console::print(CONSOLEMESSAGE_TYPE_INFO, "Reloaded quests.");

	g_game.mounts.reload();
	console::print(CONSOLEMESSAGE_TYPE_INFO, "Reloaded mounts.");

	g_game.familiars.reload();
	console::print(CONSOLEMESSAGE_TYPE_INFO, "Reloaded familiars.");

	g_globalEvents->reload();
	console::print(CONSOLEMESSAGE_TYPE_INFO, "Reloaded globalevents.");

	g_events->load();
	console::print(CONSOLEMESSAGE_TYPE_INFO, "Reloaded events.");

	g_chat->load();
	console::print(CONSOLEMESSAGE_TYPE_INFO, "Reloaded chatchannels.");

	g_luaEnvironment.loadFile("data/global.lua");
	console::print(CONSOLEMESSAGE_TYPE_INFO, "Reloaded global.lua.");

	lua_gc(g_luaEnvironment.getLuaState(), LUA_GCCOLLECT, 0);
}

#else

void sigbreakHandler()
{
	//Dispatcher thread
	console::print(CONSOLEMESSAGE_TYPE_INFO, "SIGBREAK received, shutting game server down...");
	g_game.setGameState(GAME_STATE_SHUTDOWN);
}

#endif

void sigtermHandler()
{
	//Dispatcher thread
	console::print(CONSOLEMESSAGE_TYPE_INFO, "SIGTERM received, shutting game server down...");
	g_game.setGameState(GAME_STATE_SHUTDOWN);
}

void sigintHandler()
{
	//Dispatcher thread
	console::print(CONSOLEMESSAGE_TYPE_INFO, "SIGINT received, shutting game server down...");
	g_game.setGameState(GAME_STATE_SHUTDOWN);
}

// On Windows this function does not need to be signal-safe,
// as it is called in a new thread.
// https://github.com/otland/forgottenserver/pull/2473
void dispatchSignalHandler(int signal)
{
	switch(signal) {
		case SIGINT: //Shuts the server down
			g_dispatcher.addTask(createTask(sigintHandler));
			break;
		case SIGTERM: //Shuts the server down
			g_dispatcher.addTask(createTask(sigtermHandler));
			break;
#ifndef _WIN32
		case SIGHUP: //Reload config/data
			g_dispatcher.addTask(createTask(sighupHandler));
			break;
		case SIGUSR1: //Saves game state
			g_dispatcher.addTask(createTask(sigusr1Handler));
			break;
#else
		case SIGBREAK: //Shuts the server down
			g_dispatcher.addTask(createTask(sigbreakHandler));
			// hold the thread until other threads end
			g_scheduler.join();
			g_databaseTasks.join();
			g_dispatcher.join();
			break;
#endif
		default:
			break;
	}
}

}

Signals::Signals(boost::asio::io_service& service): set(service)
{
	set.add(SIGINT);
	set.add(SIGTERM);
#ifndef _WIN32
	set.add(SIGUSR1);
	set.add(SIGHUP);
#else
	// This must be a blocking call as Windows calls it in a new thread and terminates
	// the process when the handler returns (or after 5 seconds, whichever is earlier).
	// On Windows it is called in a new thread.
	signal(SIGBREAK, dispatchSignalHandler);
#endif

	asyncWait();
}

void Signals::asyncWait()
{
	set.async_wait([this](const boost::system::error_code& err, int signal) {
		if (err) {
			std::cerr << "Signal handling error: "  << err.message() << std::endl;
			return;
		}
		dispatchSignalHandler(signal);
		asyncWait();
	});
}
