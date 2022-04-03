// Copyright 2022 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "configmanager.h"
#include "databasemanager.h"
#include "databasetasks.h"
#include "game.h"
#include "iomarket.h"
#include "monsters.h"
#include "outfit.h"
#include "protocollogin.h"
#include "protocolold.h"
#include "protocolstatus.h"
#include "rsa.h"
#include "scheduler.h"
#include "script.h"
#include "scriptmanager.h"
#include "server.h"

#include <fstream>
#include <iomanip>

#if __has_include("gitmetadata.h")
	#include "gitmetadata.h"
#endif

DatabaseTasks g_databaseTasks;
Dispatcher g_dispatcher;
Scheduler g_scheduler;

Game g_game;
ConfigManager g_config;
Monsters g_monsters;
Vocations g_vocations;
extern Scripts* g_scripts;
RSA g_RSA;

std::mutex g_loaderLock;
std::condition_variable g_loaderSignal;
std::unique_lock<std::mutex> g_loaderUniqueLock(g_loaderLock);

void startupErrorMessage(const std::string& errorStr)
{
	console::print(CONSOLEMESSAGE_TYPE_ERROR, errorStr);
	g_loaderSignal.notify_all();
}

void mainLoader(int argc, char* argv[], ServiceManager* services);
bool argumentsHandler(const StringVector& args);

[[noreturn]] void badAllocationHandler()
{
	// Use functions that only use stack allocation
	puts("Allocation failed, server out of memory.\nDecrease the size of your map or compile in 64 bits mode.\n");
	getchar();
	exit(-1);
}

std::string getHorizontalLine()
{
	std::ostringstream s;
	s << std::setw(80) << std::setfill('-') << "" << std::endl << std::setfill(' ');
	return s.str();
}

int main(int argc, char* argv[])
{
	StringVector args = StringVector(argv, argv + argc);
	if(argc > 1 && !argumentsHandler(args)) {
		return 0;
	}

	// Setup bad allocation handler
	std::set_new_handler(badAllocationHandler);

	ServiceManager serviceManager;

	g_dispatcher.start();
	g_scheduler.start();

	g_dispatcher.addTask(createTask(std::bind(mainLoader, argc, argv, &serviceManager)));

	g_loaderSignal.wait(g_loaderUniqueLock);

	if (serviceManager.is_running()) {
		console::print(CONSOLEMESSAGE_TYPE_STARTUP_SPECIAL, g_config.getString(ConfigManager::SERVER_NAME) + " Server Online!");
		std::cout << getHorizontalLine() << std::flush;
		serviceManager.run();
	} else {
		console::print(CONSOLEMESSAGE_TYPE_ERROR, "No services running. The server is NOT online!");
		g_scheduler.shutdown();
		g_databaseTasks.shutdown();
		g_dispatcher.shutdown();
	}

	g_scheduler.join();
	g_databaseTasks.join();
	g_dispatcher.join();
	return 0;
}

void printServerVersion()
{
	std::ostringstream startupMsg;
	std::string hrLine = getHorizontalLine();
	startupMsg << hrLine;

#if defined(GIT_RETRIEVED_STATE) && GIT_RETRIEVED_STATE
	startupMsg << STATUS_SERVER_NAME << " - Version " << GIT_DESCRIBE << std::endl;
	startupMsg << "Git SHA1 " << GIT_SHORT_SHA1 << " dated " << GIT_COMMIT_DATE_ISO8601 << std::endl;
	#if GIT_IS_DIRTY
	startupMsg << "*** DIRTY - NOT OFFICIAL RELEASE ***" << std::endl;
	#endif
#else
	startupMsg << "- " << STATUS_SERVER_NAME << " - Version " << STATUS_SERVER_VERSION << std::endl;
#endif
	startupMsg << std::endl;

	startupMsg << "- " << "Compiled with " << BOOST_COMPILER << std::endl;
	startupMsg << "- " << "Compiled on " << __DATE__ << ' ' << __TIME__ << " for platform ";
#if defined(__amd64__) || defined(_M_X64)
	startupMsg << "x64" << std::endl;
#elif defined(__i386__) || defined(_M_IX86) || defined(_X86_)
	startupMsg << "x86" << std::endl;
#elif defined(__arm__)
	startupMsg << "ARM" << std::endl;
#else
	startupMsg << "unknown" << std::endl;
#endif
#if defined(LUAJIT_VERSION)
	startupMsg << "- " << "Linked with " << LUAJIT_VERSION << " for Lua support" << std::endl;
#else
	startupMsg << "- " << "Linked with " << LUA_RELEASE << " for Lua support" << std::endl;
#endif

	startupMsg << hrLine;
	startupMsg << "- " << "A fork of Mark Samman's server, developed by " << STATUS_SERVER_DEVELOPERS << "." << std::endl;
	startupMsg << hrLine;
	startupMsg << "- " << "The Forgotten Server Plus: https://github.com/Zbizu/forgottenserver" << std::endl;
	startupMsg << "- " << "Original Repository:       https://github.com/otland/forgottenserver" << std::endl;
	startupMsg << hrLine;
	std::cout << startupMsg.str() << std::flush;
}

void mainLoader(int, char*[], ServiceManager* services)
{
	//dispatcher thread
	g_game.setGameState(GAME_STATE_STARTUP);

	srand(static_cast<unsigned int>(OTSYS_TIME()));
#ifdef _WIN32
	SetConsoleTitle(STATUS_SERVER_NAME);

	// fixes a problem with escape characters not being processed in Windows consoles
	HANDLE hOut = GetStdHandle(STD_OUTPUT_HANDLE);
	DWORD dwMode = 0;
	GetConsoleMode(hOut, &dwMode);
	dwMode |= ENABLE_VIRTUAL_TERMINAL_PROCESSING;
	SetConsoleMode(hOut, dwMode);
#endif

	//// SERVER STARTUP
	// The Forgotten Server (version)
	printServerVersion();

	// Loading config.lua ...
	const std::string& configFile = g_config.getString(ConfigManager::CONFIG_FILE);
	const std::string& distFile = configFile + ".dist";
	console::print(CONSOLEMESSAGE_TYPE_STARTUP, "Loading " + configFile + " ... ", false);

	// load config.lua or generate one from config.lua.dist file
	std::ifstream c_test("./" + configFile);
	if (!c_test.is_open()) {
		std::ifstream config_lua_dist("./" + distFile);

		// config file not found, inform about generating it
		console::printResult(CONSOLE_LOADING_PENDING);
		console::print(CONSOLEMESSAGE_TYPE_INFO, "Copying " + distFile + " to " + configFile + " ... ", false);

		if (config_lua_dist.is_open()) {

			std::ofstream config_lua(configFile);
			config_lua << config_lua_dist.rdbuf();
			config_lua.close();
			config_lua_dist.close();

			// confirm success
			console::printResult(CONSOLE_LOADING_OK);
			console::print(CONSOLEMESSAGE_TYPE_STARTUP, "Loading " + configFile + " ... ", false);
		} else {
			// access denied / file not found
			console::printResult(CONSOLE_LOADING_ERROR);
			console::reportFileError("", distFile);
			return;
		}
	} else {
		c_test.close();
	}

	// config.lua existence confirmed, load it
	if (!g_config.load()) {
		console::reportFileError("", configFile);
		return;
	}

#ifdef _WIN32
	const std::string& defaultPriority = g_config.getString(ConfigManager::DEFAULT_PRIORITY);
	if (caseInsensitiveEqual(defaultPriority, "high")) {
		SetPriorityClass(GetCurrentProcess(), HIGH_PRIORITY_CLASS);
	} else if (caseInsensitiveEqual(defaultPriority, "above-normal")) {
		SetPriorityClass(GetCurrentProcess(), ABOVE_NORMAL_PRIORITY_CLASS);
	}
#endif


	// set RSA key
	console::print(CONSOLEMESSAGE_TYPE_STARTUP, "Loading RSA key ... ", false);
	try {
		g_RSA.loadPEM("key.pem");
	} catch(const std::exception& e) {
		console::printResult(CONSOLE_LOADING_ERROR);
		startupErrorMessage(e.what());
		return;
	}
	console::printResult(CONSOLE_LOADING_OK);


	// connect to the database
	console::print(CONSOLEMESSAGE_TYPE_STARTUP, "Establishing database connection ... ", false);

	if (!Database::getInstance().connect()) {
		// normally this line is executed in startupErrorMessage
		// in this situation the error is being sent from connect method
		// so no message is needed
		g_loaderSignal.notify_all();
		return;
	}

	console::printResultText("MySQL " + std::string(Database::getClientVersion()));

	// run database manager

	// check if database exists
	console::print(CONSOLEMESSAGE_TYPE_STARTUP, "Checking database setup ... ", false);
	if (!DatabaseManager::isDatabaseSetup()) {
		console::printResult(CONSOLE_LOADING_ERROR);
		startupErrorMessage("The database you have specified in config.lua is empty, please import the schema.sql to your database.");
		return;
	}
	console::printResult(CONSOLE_LOADING_OK);

	// start database tasks
	g_databaseTasks.start();

	// run database migrations if necessary
	// Checking database migrations...
	DatabaseManager::updateDatabase();

	// optimize tables
	if (g_config.getBoolean(ConfigManager::OPTIMIZE_DATABASE)) {
		console::print(CONSOLEMESSAGE_TYPE_STARTUP, "Optimizing database tables ... ", false);
		if (!DatabaseManager::optimizeTables()) {
			console::printResult(CONSOLE_LOADING_OK);
			console::print(CONSOLEMESSAGE_TYPE_INFO, "No tables were optimized.");
		} else {
			console::printResult(CONSOLE_LOADING_OK);
		}
	}

	// load vocations
	console::print(CONSOLEMESSAGE_TYPE_STARTUP, "Loading vocations ... ", false);
	if (!g_vocations.loadFromXml()) {
		startupErrorMessage("Unable to load vocations!");
		return;
	}

	// load cosmetics
	console::print(CONSOLEMESSAGE_TYPE_STARTUP, "Loading outfits ... ", false);
	if (!Outfits::getInstance().loadFromXml()) {
		startupErrorMessage("Unable to load outfits!");
		return;
	}

	console::print(CONSOLEMESSAGE_TYPE_STARTUP, "Loading mounts ... ", false);
	if (!g_game.mounts.loadFromXml()) {
		startupErrorMessage("Unable to load mounts!");
		return;
	}

	console::print(CONSOLEMESSAGE_TYPE_STARTUP, "Loading familiars ... ", false);
	if (!g_game.familiars.loadFromXml()) {
		startupErrorMessage("Unable to load familiars!");
		return;
	}

	// load item data
	console::print(CONSOLEMESSAGE_TYPE_STARTUP, "Loading items ... ", false);
	if (!Item::items.loadFromOtb("data/items/items.otb")) {
		startupErrorMessage("Unable to load items.otb!");
		return;
	}

	if (!Item::items.loadFromXml()) {
		startupErrorMessage("Unable to load items.xml!");
		return;
	}

	// load lua scripts
	console::print(CONSOLEMESSAGE_TYPE_STARTUP, "Loading script systems ... ", false);
	
#if defined(LUAJIT_VERSION)
	console::printResultText(LUAJIT_VERSION);
#else
	console::printResultText(LUA_RELEASE);
#endif

	if (!ScriptingManager::getInstance().loadScriptSystems()) {
		startupErrorMessage("Failed to load script systems");
		return;
	}

	if (!g_scripts->loadScripts("scripts", false, false)) {
		startupErrorMessage("Failed to load lua scripts");
		return;
	}

	// load monsters
	//console::print(CONSOLEMESSAGE_TYPE_STARTUP, "Loading monsters ... ");
	if (!g_monsters.loadFromXml()) {
		startupErrorMessage("Unable to load monsters!");
		return;
	}

	if (!g_scripts->loadScripts("monster", false, false)) {
		startupErrorMessage("Failed to load lua monsters");
		return;
	}

	// load world type
	console::print(CONSOLEMESSAGE_TYPE_STARTUP, "Configuring world type ... ", false);
	std::string worldType = asLowerCaseString(g_config.getString(ConfigManager::WORLD_TYPE));
	if (worldType == "pvp") {
		g_game.setWorldType(WORLD_TYPE_PVP);
	} else if (worldType == "no-pvp") {
		g_game.setWorldType(WORLD_TYPE_NO_PVP);
	} else if (worldType == "pvp-enforced") {
		g_game.setWorldType(WORLD_TYPE_PVP_ENFORCED);
	} else {
		console::printResult(CONSOLE_LOADING_ERROR);
		startupErrorMessage(fmt::format("Unknown world type: {:s}, valid world types are: pvp, no-pvp and pvp-enforced.", g_config.getString(ConfigManager::WORLD_TYPE)));
		return;
	}

	console::printPVPType(worldType);

	// load map
	console::print(CONSOLEMESSAGE_TYPE_STARTUP, "Loading world map...");
	console::print(CONSOLEMESSAGE_TYPE_STARTUP, "");


	const std::string& worldName = g_config.getString(ConfigManager::MAP_NAME);
	console::printWorldInfo("Filename", worldName + ".otbm");

	if (!g_game.loadMainMap(worldName)) {
		startupErrorMessage("Failed to load map");
		return;
	}

	console::printWorldInfo("Houses", std::to_string(g_game.map.houses.size()));

	console::print(CONSOLEMESSAGE_TYPE_STARTUP, "");

	console::printWorldInfo("Monsters", std::to_string(g_game.map.spawns.getMonsterCount()));
	console::printWorldInfo("NPCs", std::to_string(g_game.map.spawns.getNpcCount()));
	console::printWorldInfo("Spawns", std::to_string(g_game.map.spawns.size()));

	// bind service ports
	g_game.setGameState(GAME_STATE_INIT);

	console::print(CONSOLEMESSAGE_TYPE_STARTUP, "");
	//console::print(CONSOLEMESSAGE_TYPE_STARTUP, "Binding ports ...");

	uint16_t loginPort = static_cast<uint16_t>(g_config.getNumber(ConfigManager::LOGIN_PORT));
	uint16_t gamePort = static_cast<uint16_t>(g_config.getNumber(ConfigManager::GAME_PORT));
	uint16_t statusPort = static_cast<uint16_t>(g_config.getNumber(ConfigManager::STATUS_PORT));

	// Game client protocols
	services->add<ProtocolGame>(gamePort);
	services->add<ProtocolLogin>(loginPort);

	// OT protocols
	services->add<ProtocolStatus>(statusPort);

	// Legacy login protocol
	services->add<ProtocolOld>(loginPort);

	console::printLoginPorts(loginPort, gamePort, statusPort);
	//console::print(CONSOLEMESSAGE_TYPE_STARTUP, "Initializing gamestate ...");

	RentPeriod_t rentPeriod;
	std::string strRentPeriod = asLowerCaseString(g_config.getString(ConfigManager::HOUSE_RENT_PERIOD));

	if (strRentPeriod == "yearly") {
		rentPeriod = RENTPERIOD_YEARLY;
	} else if (strRentPeriod == "weekly") {
		rentPeriod = RENTPERIOD_WEEKLY;
	} else if (strRentPeriod == "monthly") {
		rentPeriod = RENTPERIOD_MONTHLY;
	} else if (strRentPeriod == "daily") {
		rentPeriod = RENTPERIOD_DAILY;
	} else {
		rentPeriod = RENTPERIOD_NEVER;
	}

	g_game.map.houses.payHouses(rentPeriod);

	IOMarket::checkExpiredOffers();
	IOMarket::getInstance().updateStatistics();

#ifndef _WIN32
	if (getuid() == 0 || geteuid() == 0) {
		console::print(CONSOLEMESSAGE_TYPE_WARNING, "Server is running with root permissions. Running as a normal user recommended.");
	}
#endif

	g_game.start(services);
	g_game.setGameState(GAME_STATE_NORMAL);
	g_loaderSignal.notify_all();
}

bool argumentsHandler(const StringVector& args)
{
	for (const auto& arg : args) {
		if (arg == "--help") {
			std::clog << "Usage:\n"
			"\n"
			"\t--config=$1\t\tAlternate configuration file path.\n"
			"\t--ip=$1\t\t\tIP address of the server.\n"
			"\t\t\t\tShould be equal to the global IP.\n"
			"\t--login-port=$1\tPort for login server to listen on.\n"
			"\t--game-port=$1\tPort for game server to listen on.\n";
			return false;
		} else if (arg == "--version") {
			printServerVersion();
			return false;
		}

		StringVector tmp = explodeString(arg, "=");

		if (tmp[0] == "--config")
			g_config.setString(ConfigManager::CONFIG_FILE, tmp[1]);
		else if (tmp[0] == "--ip")
			g_config.setString(ConfigManager::IP, tmp[1]);
		else if (tmp[0] == "--login-port")
			g_config.setNumber(ConfigManager::LOGIN_PORT, std::stoi(tmp[1]));
		else if (tmp[0] == "--game-port")
			g_config.setNumber(ConfigManager::GAME_PORT, std::stoi(tmp[1]));
	}

	return true;
}
