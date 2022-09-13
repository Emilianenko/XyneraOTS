// Copyright 2022 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "luascript.h"

#include "combat.h"
#include "configmanager.h"
#include "game.h"
#include "luavariant.h"
#include "monster.h"
#include "monsters.h"
#include "npc.h"
#include "outfit.h"
#include "podium.h"
#include "spells.h"
#include "script.h"
#include "teleport.h"

#include <boost/range/adaptor/reversed.hpp>

extern ConfigManager g_config;
extern Spells* g_spells;
extern Scripts* g_scripts;

class AreaCombat;
class Combat;

ScriptEnvironment::DBResultMap ScriptEnvironment::tempResults;
uint32_t ScriptEnvironment::lastResultId = 0;
int32_t LuaScriptInterface::runningEventId = EVENT_ID_USER;
std::map<int32_t, std::string> LuaScriptInterface::cacheFiles;

LuaEnvironment g_luaEnvironment;

std::multimap<ScriptEnvironment*, Item*> ScriptEnvironment::tempItems;

ScriptEnvironment::ScriptEnvironment()
{
	resetEnv();
}

ScriptEnvironment::~ScriptEnvironment()
{
	resetEnv();
}

void ScriptEnvironment::resetEnv()
{
	scriptId = 0;
	callbackId = 0;
	timerEvent = false;
	interface = nullptr;
	localMap.clear();
	tempResults.clear();

	auto pair = tempItems.equal_range(this);
	auto it = pair.first;
	while (it != pair.second) {
		Item* item = it->second;
		if (item && item->getParent() == VirtualCylinder::virtualCylinder) {
			g_game.ReleaseItem(item);
		}
		it = tempItems.erase(it);
	}
}

bool ScriptEnvironment::setCallbackId(int32_t callbackId, LuaScriptInterface* scriptInterface)
{
	if (this->callbackId != 0) {
		//nested callbacks are not allowed
		if (interface) {
			reportErrorFunc(interface->getLuaState(), "Nested callbacks!");
		}
		return false;
	}

	this->callbackId = callbackId;
	interface = scriptInterface;
	return true;
}

void ScriptEnvironment::getEventInfo(int32_t& scriptId, LuaScriptInterface*& scriptInterface, int32_t& callbackId, bool& timerEvent) const
{
	scriptId = this->scriptId;
	scriptInterface = interface;
	callbackId = this->callbackId;
	timerEvent = this->timerEvent;
}

uint32_t ScriptEnvironment::addThing(Thing* thing)
{
	if (!thing || thing->isRemoved()) {
		return 0;
	}

	Creature* creature = thing->getCreature();
	if (creature) {
		return creature->getID();
	}

	Item* item = thing->getItem();
	if (item && item->hasAttribute(ITEM_ATTRIBUTE_UNIQUEID)) {
		return item->getUniqueId();
	}

	for (const auto& it : localMap) {
		if (it.second == item) {
			return it.first;
		}
	}

	localMap[++lastUID] = item;
	return lastUID;
}

void ScriptEnvironment::insertItem(uint32_t uid, Item* item)
{
	auto result = localMap.emplace(uid, item);
	if (!result.second) {
		console::reportError("Lua Script", fmt::format("Thing uid {:d} is already taken! (item id: {:d})", uid, item->getID()));
	}
}

Thing* ScriptEnvironment::getThingByUID(uint32_t uid)
{
	if (uid >= CREATURE_ID_MIN) {
		return g_game.getCreatureByID(uid);
	}

	if (uid <= std::numeric_limits<uint16_t>::max()) {
		Item* item = g_game.getUniqueItem(uid);
		if (item && !item->isRemoved()) {
			return item;
		}
		return nullptr;
	}

	auto it = localMap.find(uid);
	if (it != localMap.end()) {
		Item* item = it->second;
		if (!item->isRemoved()) {
			return item;
		}
	}
	return nullptr;
}

Item* ScriptEnvironment::getItemByUID(uint32_t uid)
{
	Thing* thing = getThingByUID(uid);
	if (!thing) {
		return nullptr;
	}
	return thing->getItem();
}

Container* ScriptEnvironment::getContainerByUID(uint32_t uid)
{
	Item* item = getItemByUID(uid);
	if (!item) {
		return nullptr;
	}
	return item->getContainer();
}

void ScriptEnvironment::removeItemByUID(uint32_t uid)
{
	if (uid <= std::numeric_limits<uint16_t>::max()) {
		g_game.removeUniqueItem(uid);
		return;
	}

	auto it = localMap.find(uid);
	if (it != localMap.end()) {
		localMap.erase(it);
	}
}

void ScriptEnvironment::addTempItem(Item* item)
{
	tempItems.emplace(this, item);
}

void ScriptEnvironment::removeTempItem(Item* item)
{
	for (auto it = tempItems.begin(), end = tempItems.end(); it != end; ++it) {
		if (it->second == item) {
			tempItems.erase(it);
			break;
		}
	}
}

uint32_t ScriptEnvironment::addResult(DBResult_ptr res)
{
	tempResults[++lastResultId] = res;
	return lastResultId;
}

bool ScriptEnvironment::removeResult(uint32_t id)
{
	auto it = tempResults.find(id);
	if (it == tempResults.end()) {
		return false;
	}

	tempResults.erase(it);
	return true;
}

DBResult_ptr ScriptEnvironment::getResultByID(uint32_t id)
{
	auto it = tempResults.find(id);
	if (it == tempResults.end()) {
		return nullptr;
	}
	return it->second;
}

std::string LuaScriptInterface::getErrorDesc(ErrorCode_t code)
{
	switch (code) {
		case LUA_ERROR_PLAYER_NOT_FOUND: return "Player not found";
		case LUA_ERROR_CREATURE_NOT_FOUND: return "Creature not found";
		case LUA_ERROR_ITEM_NOT_FOUND: return "Item not found";
		case LUA_ERROR_THING_NOT_FOUND: return "Thing not found";
		case LUA_ERROR_TILE_NOT_FOUND: return "Tile not found";
		case LUA_ERROR_HOUSE_NOT_FOUND: return "House not found";
		case LUA_ERROR_COMBAT_NOT_FOUND: return "Combat not found";
		case LUA_ERROR_CONDITION_NOT_FOUND: return "Condition not found";
		case LUA_ERROR_AREA_NOT_FOUND: return "Area not found";
		case LUA_ERROR_CONTAINER_NOT_FOUND: return "Container not found";
		case LUA_ERROR_VARIANT_NOT_FOUND: return "Variant not found";
		case LUA_ERROR_VARIANT_UNKNOWN: return "Unknown variant type";
		case LUA_ERROR_SPELL_NOT_FOUND: return "Spell not found";
		default: return "Bad error code";
	}
}

ScriptEnvironment LuaScriptInterface::scriptEnv[16];
int32_t LuaScriptInterface::scriptEnvIndex = -1;

LuaScriptInterface::LuaScriptInterface(std::string interfaceName) : interfaceName(std::move(interfaceName))
{
	if (!g_luaEnvironment.getLuaState()) {
		g_luaEnvironment.initState();
	}
}

LuaScriptInterface::~LuaScriptInterface()
{
	closeState();
}

bool LuaScriptInterface::reInitState()
{
	g_luaEnvironment.clearCombatObjects(this);
	g_luaEnvironment.clearAreaObjects(this);

	closeState();
	return initState();
}

/// Same as lua_pcall, but adds stack trace to error strings in called function.
int LuaScriptInterface::protectedCall(lua_State* L, int nargs, int nresults)
{
#ifdef STATS_ENABLED
	int32_t scriptId;
	int32_t callbackId;
	bool timerEvent;
	LuaScriptInterface* scriptInterface;
	std::chrono::high_resolution_clock::time_point time_point = std::chrono::high_resolution_clock::now();
	getScriptEnv()->getEventInfo(scriptId, scriptInterface, callbackId, timerEvent);
#endif

	int error_index = lua_gettop(L) - nargs;
	lua_pushcfunction(L, luaErrorHandler);
	lua_insert(L, error_index);

	int ret = lua_pcall(L, nargs, nresults, error_index);
	lua_remove(L, error_index);

#ifdef STATS_ENABLED
	uint64_t ns = std::chrono::duration_cast<std::chrono::nanoseconds>(std::chrono::high_resolution_clock::now() - time_point).count();
	auto it = cacheFiles.find(scriptId);
	if (it != cacheFiles.end())
		g_stats.addLuaStats(new Stat(ns, it->second, ""));
#endif

	return ret;
}

int32_t LuaScriptInterface::loadFile(const std::string& file, Npc* npc /* = nullptr*/)
{
	//loads file as a chunk at stack top
	int ret = luaL_loadfile(luaState, file.c_str());
	if (ret != 0) {
		lastLuaError = popString(luaState);
		return -1;
	}

	//check that it is loaded as a function
	if (!isFunction(luaState, -1)) {
		lua_pop(luaState, 1);
		return -1;
	}

	loadingFile = file;

	if (!reserveScriptEnv()) {
		lua_pop(luaState, 1);
		return -1;
	}

	ScriptEnvironment* env = getScriptEnv();
	env->setScriptId(EVENT_ID_LOADING, this);
	env->setNpc(npc);

	//execute it
	ret = protectedCall(luaState, 0, 0);
	if (ret != 0) {
		reportError(nullptr, popString(luaState));
		resetScriptEnv();
		return -1;
	}

	resetScriptEnv();
	return 0;
}

int32_t LuaScriptInterface::getEvent(const std::string& eventName)
{
	//get our events table
	lua_rawgeti(luaState, LUA_REGISTRYINDEX, eventTableRef);
	if (!isTable(luaState, -1)) {
		lua_pop(luaState, 1);
		return -1;
	}

	//get current event function pointer
	lua_getglobal(luaState, eventName.c_str());
	if (!isFunction(luaState, -1)) {
		lua_pop(luaState, 2);
		return -1;
	}

	//save in our events table
	lua_pushvalue(luaState, -1);
	lua_rawseti(luaState, -3, runningEventId);
	lua_pop(luaState, 2);

	//reset global value of this event
	lua_pushnil(luaState);
	lua_setglobal(luaState, eventName.c_str());

	cacheFiles[runningEventId] = loadingFile + ":" + eventName;
	return runningEventId++;
}

int32_t LuaScriptInterface::getEvent()
{
	//check if function is on the stack
	if (!isFunction(luaState, -1)) {
		return -1;
	}

	//get our events table
	lua_rawgeti(luaState, LUA_REGISTRYINDEX, eventTableRef);
	if (!isTable(luaState, -1)) {
		lua_pop(luaState, 1);
		return -1;
	}

	//save in our events table
	lua_pushvalue(luaState, -2);
	lua_rawseti(luaState, -2, runningEventId);
	lua_pop(luaState, 2);

	cacheFiles[runningEventId] = loadingFile + ":callback";
	return runningEventId++;
}

int32_t LuaScriptInterface::getMetaEvent(const std::string& globalName, const std::string& eventName)
{
	//get our events table
	lua_rawgeti(luaState, LUA_REGISTRYINDEX, eventTableRef);
	if (!isTable(luaState, -1)) {
		lua_pop(luaState, 1);
		return -1;
	}

	//get current event function pointer
	lua_getglobal(luaState, globalName.c_str());
	lua_getfield(luaState, -1, eventName.c_str());
	if (!isFunction(luaState, -1)) {
		lua_pop(luaState, 3);
		return -1;
	}

	//save in our events table
	lua_pushvalue(luaState, -1);
	lua_rawseti(luaState, -4, runningEventId);
	lua_pop(luaState, 1);

	//reset global value of this event
	lua_pushnil(luaState);
	lua_setfield(luaState, -2, eventName.c_str());
	lua_pop(luaState, 2);

	cacheFiles[runningEventId] = loadingFile + ":" + globalName + "@" + eventName;
	return runningEventId++;
}

const std::string& LuaScriptInterface::getFileById(int32_t scriptId)
{
	if (scriptId == EVENT_ID_LOADING) {
		return loadingFile;
	}

	auto it = cacheFiles.find(scriptId);
	if (it == cacheFiles.end()) {
		static const std::string& unk = "(Unknown scriptfile)";
		return unk;
	}
	return it->second;
}

std::string LuaScriptInterface::getStackTrace(lua_State* L, const std::string& error_desc)
{
	lua_getglobal(L, "debug");
	if (!isTable(L, -1)) {
		lua_pop(L, 1);
		return error_desc;
	}

	lua_getfield(L, -1, "traceback");
	if (!isFunction(L, -1)) {
		lua_pop(L, 2);
		return error_desc;
	}

	lua_replace(L, -2);
	pushString(L, error_desc);
	lua_call(L, 1, 1);
	return popString(L);
}

void LuaScriptInterface::reportError(const char* function, const std::string& error_desc, lua_State* L /*= nullptr*/, bool stack_trace /*= false*/)
{
	int32_t scriptId;
	int32_t callbackId;
	bool timerEvent;
	LuaScriptInterface* scriptInterface;
	getScriptEnv()->getEventInfo(scriptId, scriptInterface, callbackId, timerEvent);

	std::ostringstream errMsg;
	std::string location;

	if (scriptInterface) {
		location = "Lua Script - " + scriptInterface->getInterfaceName();

		if (timerEvent) {
			errMsg << "in a timer event called from: " << std::endl;
		}

		if (callbackId) {
			errMsg << "in callback: " << scriptInterface->getFileById(callbackId) << std::endl;
		}

		errMsg << scriptInterface->getFileById(scriptId) << std::endl;
	} else {
		location = "Lua Script";
	}

	if (function) {
		errMsg << function << "(). ";
	}

	if (L && stack_trace) {
		errMsg << getStackTrace(L, error_desc) << std::endl;
	} else {
		errMsg << error_desc << std::endl;
	}

	console::reportError(location, errMsg.str());
}

bool LuaScriptInterface::pushFunction(int32_t functionId)
{
	lua_rawgeti(luaState, LUA_REGISTRYINDEX, eventTableRef);
	if (!isTable(luaState, -1)) {
		return false;
	}

	lua_rawgeti(luaState, -1, functionId);
	lua_replace(luaState, -2);
	return isFunction(luaState, -1);
}

bool LuaScriptInterface::initState()
{
	luaState = g_luaEnvironment.getLuaState();
	if (!luaState) {
		return false;
	}

	lua_newtable(luaState);
	eventTableRef = luaL_ref(luaState, LUA_REGISTRYINDEX);
	//runningEventId = EVENT_ID_USER;
	return true;
}

bool LuaScriptInterface::closeState()
{
	if (!g_luaEnvironment.getLuaState() || !luaState) {
		return false;
	}

	//cacheFiles.clear();
	if (eventTableRef != -1) {
		luaL_unref(luaState, LUA_REGISTRYINDEX, eventTableRef);
		eventTableRef = -1;
	}

	luaState = nullptr;
	return true;
}

int LuaScriptInterface::luaErrorHandler(lua_State* L)
{
	const std::string& errorMessage = popString(L);
	pushString(L, LuaScriptInterface::getStackTrace(L, errorMessage));
	return 1;
}

bool LuaScriptInterface::callFunction(int params)
{
	bool result = false;
	int size = lua_gettop(luaState);
	if (protectedCall(luaState, params, 1) != 0) {
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::getString(luaState, -1));
	} else {
		result = LuaScriptInterface::getBoolean(luaState, -1);
	}

	lua_pop(luaState, 1);
	if ((lua_gettop(luaState) + params + 1) != size) {
		LuaScriptInterface::reportError(nullptr, "Stack size changed!");
	}

	resetScriptEnv();
	return result;
}

void LuaScriptInterface::callVoidFunction(int params)
{
	int size = lua_gettop(luaState);
	if (protectedCall(luaState, params, 0) != 0) {
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(luaState));
	}

	if ((lua_gettop(luaState) + params + 1) != size) {
		LuaScriptInterface::reportError(nullptr, "Stack size changed!");
	}

	resetScriptEnv();
}

void LuaScriptInterface::pushVariant(lua_State* L, const LuaVariant& var)
{
	lua_createtable(L, 0, 2);
	setField(L, "type", var.type());
	switch (var.type()) {
		case VARIANT_NUMBER:
			setField(L, "number", var.getNumber());
			break;
		case VARIANT_STRING:
			setField(L, "string", var.getString());
			break;
		case VARIANT_TARGETPOSITION:
			pushPosition(L, var.getTargetPosition());
			lua_setfield(L, -2, "pos");
			break;
		case VARIANT_POSITION: {
			pushPosition(L, var.getPosition());
			lua_setfield(L, -2, "pos");
			break;
		}
		default:
			break;
	}
	setMetatable(L, -1, "Variant");
}

void LuaScriptInterface::pushThing(lua_State* L, Thing* thing)
{
	if (!thing) {
		lua_createtable(L, 0, 4);
		setField(L, "uid", 0);
		setField(L, "itemid", 0);
		setField(L, "actionid", 0);
		setField(L, "type", 0);
		return;
	}

	if (Item* item = thing->getItem()) {
		pushUserdata<Item>(L, item);
		setItemMetatable(L, -1, item);
	} else if (Creature* creature = thing->getCreature()) {
		pushUserdata<Creature>(L, creature);
		setCreatureMetatable(L, -1, creature);
	} else {
		lua_pushnil(L);
	}
}

void LuaScriptInterface::pushCylinder(lua_State* L, Cylinder* cylinder)
{
	if (Creature* creature = cylinder->getCreature()) {
		pushUserdata<Creature>(L, creature);
		setCreatureMetatable(L, -1, creature);
	} else if (Item* parentItem = cylinder->getItem()) {
		pushUserdata<Item>(L, parentItem);
		setItemMetatable(L, -1, parentItem);
	} else if (Tile* tile = cylinder->getTile()) {
		pushUserdata<Tile>(L, tile);
		setMetatable(L, -1, "Tile");
	} else if (cylinder == VirtualCylinder::virtualCylinder) {
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
}

void LuaScriptInterface::pushString(lua_State* L, const std::string& value)
{
	lua_pushlstring(L, value.c_str(), value.length());
}

void LuaScriptInterface::pushCallback(lua_State* L, int32_t callback)
{
	lua_rawgeti(L, LUA_REGISTRYINDEX, callback);
}

std::string LuaScriptInterface::popString(lua_State* L)
{
	if (lua_gettop(L) == 0) {
		return std::string();
	}

	std::string str(getString(L, -1));
	lua_pop(L, 1);
	return str;
}

int32_t LuaScriptInterface::popCallback(lua_State* L)
{
	return luaL_ref(L, LUA_REGISTRYINDEX);
}

// Metatables
void LuaScriptInterface::setMetatable(lua_State* L, int32_t index, const std::string& name)
{
	luaL_getmetatable(L, name.c_str());
	lua_setmetatable(L, index - 1);
}

void LuaScriptInterface::setWeakMetatable(lua_State* L, int32_t index, const std::string& name)
{
	static std::set<std::string> weakObjectTypes;
	const std::string& weakName = name + "_weak";

	auto result = weakObjectTypes.emplace(name);
	if (result.second) {
		luaL_getmetatable(L, name.c_str());
		int childMetatable = lua_gettop(L);

		luaL_newmetatable(L, weakName.c_str());
		int metatable = lua_gettop(L);

		static const std::vector<std::string> methodKeys = {"__index", "__metatable", "__eq"};
		for (const std::string& metaKey : methodKeys) {
			lua_getfield(L, childMetatable, metaKey.c_str());
			lua_setfield(L, metatable, metaKey.c_str());
		}

		static const std::vector<int> methodIndexes = {'h', 'p', 't'};
		for (int metaIndex : methodIndexes) {
			lua_rawgeti(L, childMetatable, metaIndex);
			lua_rawseti(L, metatable, metaIndex);
		}

		lua_pushnil(L);
		lua_setfield(L, metatable, "__gc");

		lua_remove(L, childMetatable);
	} else {
		luaL_getmetatable(L, weakName.c_str());
	}
	lua_setmetatable(L, index - 1);
}

void LuaScriptInterface::setItemMetatable(lua_State* L, int32_t index, const Item* item)
{
	if (item->getRewardBag()) {
		luaL_getmetatable(L, "RewardBag");
	} else if (item->getContainer()) {
		luaL_getmetatable(L, "Container");
	} else if (item->getTeleport()) {
		luaL_getmetatable(L, "Teleport");
	} else if (item->getPodium()) {
		luaL_getmetatable(L, "Podium");
	} else {
		luaL_getmetatable(L, "Item");
	}
	lua_setmetatable(L, index - 1);
}

void LuaScriptInterface::setCreatureMetatable(lua_State* L, int32_t index, const Creature* creature)
{
	if (creature->getPlayer()) {
		luaL_getmetatable(L, "Player");
	} else if (creature->getMonster()) {
		luaL_getmetatable(L, "Monster");
	} else {
		luaL_getmetatable(L, "Npc");
	}
	lua_setmetatable(L, index - 1);
}

// Get
std::string LuaScriptInterface::getString(lua_State* L, int32_t arg)
{
	size_t len;
	const char* c_str = lua_tolstring(L, arg, &len);
	if (!c_str || len == 0) {
		return std::string();
	}
	return std::string(c_str, len);
}

Position LuaScriptInterface::getPosition(lua_State* L, int32_t arg, int32_t& stackpos)
{
	Position position;
	position.x = getField<uint16_t>(L, arg, "x");
	position.y = getField<uint16_t>(L, arg, "y");
	position.z = getField<uint8_t>(L, arg, "z");

	lua_getfield(L, arg, "stackpos");
	if (lua_isnil(L, -1) == 1) {
		stackpos = 0;
	} else {
		stackpos = getNumber<int32_t>(L, -1);
	}

	lua_pop(L, 4);
	return position;
}

Position LuaScriptInterface::getPosition(lua_State* L, int32_t arg)
{
	Position position;
	position.x = getField<uint16_t>(L, arg, "x");
	position.y = getField<uint16_t>(L, arg, "y");
	position.z = getField<uint8_t>(L, arg, "z");

	lua_pop(L, 3);
	return position;
}

Outfit_t LuaScriptInterface::getOutfit(lua_State* L, int32_t arg)
{
	Outfit_t outfit;

	outfit.lookType = getField<uint16_t>(L, arg, "lookType");
	outfit.lookTypeEx = getField<uint16_t>(L, arg, "lookTypeEx");

	outfit.lookHead = getField<uint8_t>(L, arg, "lookHead");
	outfit.lookBody = getField<uint8_t>(L, arg, "lookBody");
	outfit.lookLegs = getField<uint8_t>(L, arg, "lookLegs");
	outfit.lookFeet = getField<uint8_t>(L, arg, "lookFeet");
	outfit.lookAddons = getField<uint8_t>(L, arg, "lookAddons");

	outfit.lookMount = getField<uint16_t>(L, arg, "lookMount");
	outfit.lookMountHead = getField<uint8_t>(L, arg, "lookMountHead");
	outfit.lookMountBody = getField<uint8_t>(L, arg, "lookMountBody");
	outfit.lookMountLegs = getField<uint8_t>(L, arg, "lookMountLegs");
	outfit.lookMountFeet = getField<uint8_t>(L, arg, "lookMountFeet");

	lua_pop(L, 12);
	return outfit;
}

Outfit LuaScriptInterface::getOutfitClass(lua_State* L, int32_t arg)
{
	uint16_t lookType = getField<uint16_t>(L, arg, "lookType");
	const std::string& name = getFieldString(L, arg, "name");
	bool premium = getField<uint8_t>(L, arg, "premium") == 1;
	bool unlocked = getField<uint8_t>(L, arg, "unlocked") == 1;
	lua_pop(L, 4);
	return Outfit(name, lookType, premium, unlocked);
}

LuaVariant LuaScriptInterface::getVariant(lua_State* L, int32_t arg)
{
	LuaVariant var;
	switch (LuaScriptInterface::getField<LuaVariantType_t>(L, arg, "type")) {
		case VARIANT_NUMBER: {
			var.setNumber(LuaScriptInterface::getField<uint32_t>(L, arg, "number"));
			lua_pop(L, 2);
			break;
		}

		case VARIANT_STRING: {
			var.setString(LuaScriptInterface::getFieldString(L, arg, "string"));
			lua_pop(L, 2);
			break;
		}

		case VARIANT_POSITION:
			lua_getfield(L, arg, "pos");
			var.setPosition(LuaScriptInterface::getPosition(L, lua_gettop(L)));
			lua_pop(L, 2);
			break;

		case VARIANT_TARGETPOSITION: {
			lua_getfield(L, arg, "pos");
			var.setTargetPosition(LuaScriptInterface::getPosition(L, lua_gettop(L)));
			lua_pop(L, 2);
			break;
		}

		default: {
			var = {};
			lua_pop(L, 1);
			break;
		}
	}
	return var;
}

InstantSpell* LuaScriptInterface::getInstantSpell(lua_State* L, int32_t arg)
{
	InstantSpell* spell = g_spells->getInstantSpellByName(getFieldString(L, arg, "name"));
	lua_pop(L, 1);
	return spell;
}

Reflect LuaScriptInterface::getReflect(lua_State* L, int32_t arg)
{
	uint16_t percent = getField<uint16_t>(L, arg, "percent");
	uint16_t chance = getField<uint16_t>(L, arg, "chance");
	lua_pop(L, 2);
	return Reflect(percent, chance);
}

Thing* LuaScriptInterface::getThing(lua_State* L, int32_t arg)
{
	Thing* thing;
	if (lua_getmetatable(L, arg) != 0) {
		lua_rawgeti(L, -1, 't');
		switch(getNumber<uint32_t>(L, -1)) {
			case LuaData_Item:
				thing = getUserdata<Item>(L, arg);
				break;
			case LuaData_RewardBag:
				thing = getUserdata<RewardBag>(L, arg);
				break;
			case LuaData_Container:
				thing = getUserdata<Container>(L, arg);
				break;
			case LuaData_Teleport:
				thing = getUserdata<Teleport>(L, arg);
				break;
			case LuaData_Podium:
				thing = getUserdata<Podium>(L, arg);
				break;
			case LuaData_Player:
				thing = getUserdata<Player>(L, arg);
				break;
			case LuaData_Monster:
				thing = getUserdata<Monster>(L, arg);
				break;
			case LuaData_Npc:
				thing = getUserdata<Npc>(L, arg);
				break;
			default:
				thing = nullptr;
				break;
		}
		lua_pop(L, 2);
	} else {
		thing = getScriptEnv()->getThingByUID(getNumber<uint32_t>(L, arg));
	}
	return thing;
}

Creature* LuaScriptInterface::getCreature(lua_State* L, int32_t arg)
{
	if (isUserdata(L, arg)) {
		return getUserdata<Creature>(L, arg);
	}
	return g_game.getCreatureByID(getNumber<uint32_t>(L, arg));
}

Player* LuaScriptInterface::getPlayer(lua_State* L, int32_t arg)
{
	if (isUserdata(L, arg)) {
		return getUserdata<Player>(L, arg);
	}
	return g_game.getPlayerByID(getNumber<uint32_t>(L, arg));
}

std::string LuaScriptInterface::getFieldString(lua_State* L, int32_t arg, const std::string& key)
{
	lua_getfield(L, arg, key.c_str());
	return getString(L, -1);
}

LuaDataType LuaScriptInterface::getUserdataType(lua_State* L, int32_t arg)
{
	if (lua_getmetatable(L, arg) == 0) {
		return LuaData_Unknown;
	}
	lua_rawgeti(L, -1, 't');

	LuaDataType type = getNumber<LuaDataType>(L, -1);
	lua_pop(L, 2);

	return type;
}

// Push
void LuaScriptInterface::pushBoolean(lua_State* L, bool value)
{
	lua_pushboolean(L, value ? 1 : 0);
}

void LuaScriptInterface::pushCombatDamage(lua_State* L, const CombatDamage& damage)
{
	lua_pushnumber(L, damage.primary.value);
	lua_pushnumber(L, damage.primary.type);
	lua_pushnumber(L, damage.secondary.value);
	lua_pushnumber(L, damage.secondary.type);
	lua_pushnumber(L, damage.origin);
}

void LuaScriptInterface::pushInstantSpell(lua_State* L, const InstantSpell& spell)
{
	lua_createtable(L, 0, 7);

	setField(L, "name", spell.getName());
	setField(L, "words", spell.getWords());
	setField(L, "level", spell.getLevel());
	setField(L, "mlevel", spell.getMagicLevel());
	setField(L, "mana", spell.getMana());
	setField(L, "manapercent", spell.getManaPercent());
	setField(L, "params", spell.getHasParam());

	setMetatable(L, -1, "Spell");
}

void LuaScriptInterface::pushRuneSpell(lua_State* L, const RuneSpell& spell)
{
	lua_createtable(L, 0, 6);
	setField(L, "id", spell.getId());
	setField(L, "name", spell.getName());
	setField(L, "level", spell.getLevel());
	setField(L, "mlevel", spell.getMagicLevel());
	setField(L, "mana", spell.getMana());
	setField(L, "manapercent", spell.getManaPercent());

	setMetatable(L, -1, "Spell");
}

void LuaScriptInterface::pushPosition(lua_State* L, const Position& position, int32_t stackpos/* = 0*/)
{
	lua_createtable(L, 0, 4);

	setField(L, "x", position.x);
	setField(L, "y", position.y);
	setField(L, "z", position.z);
	setField(L, "stackpos", stackpos);

	setMetatable(L, -1, "Position");
}

void LuaScriptInterface::pushOutfit(lua_State* L, const Outfit_t& outfit)
{
	lua_createtable(L, 0, 12);
	setField(L, "lookType", outfit.lookType);
	setField(L, "lookTypeEx", outfit.lookTypeEx);
	setField(L, "lookHead", outfit.lookHead);
	setField(L, "lookBody", outfit.lookBody);
	setField(L, "lookLegs", outfit.lookLegs);
	setField(L, "lookFeet", outfit.lookFeet);
	setField(L, "lookAddons", outfit.lookAddons);
	setField(L, "lookMount", outfit.lookMount);
	setField(L, "lookMountHead", outfit.lookMountHead);
	setField(L, "lookMountBody", outfit.lookMountBody);
	setField(L, "lookMountLegs", outfit.lookMountLegs);
	setField(L, "lookMountFeet", outfit.lookMountFeet);
}

void LuaScriptInterface::pushOutfit(lua_State* L, const Outfit* outfit)
{
	lua_createtable(L, 0, 4);
	setField(L, "lookType", outfit->lookType);
	setField(L, "name", outfit->name);
	setField(L, "premium", outfit->premium);
	setField(L, "unlocked", outfit->unlocked);
	setMetatable(L, -1, "Outfit");
}

void LuaScriptInterface::pushMount(lua_State* L, const Mount* mount)
{
	lua_createtable(L, 0, 5);
	setField(L, "name", mount->name);
	setField(L, "speed", mount->speed);
	setField(L, "clientId", mount->clientId);
	setField(L, "id", mount->id);
	setField(L, "premium", mount->premium);
}

void LuaScriptInterface::pushFamiliar(lua_State* L, const Familiar* familiar)
{
	lua_createtable(L, 0, 6);
	setField(L, "name", familiar->name);
	setField(L, "id", familiar->id);
	setField(L, "clientId", familiar->clientId);
	setField(L, "premium", familiar->premium);
	setField(L, "unlocked", familiar->unlocked);
	
	// Vocations
	lua_createtable(L, 0, familiar->vocations.size() + 1);
	for (int32_t i = 0; i < familiar->vocations.size(); i++) {
		lua_pushnumber(L, familiar->vocations[i]);
		lua_rawseti(L, -2, i + 1);
	}
	lua_setfield(L, -2, "vocations");
}

void LuaScriptInterface::pushLoot(lua_State* L, const std::vector<LootBlock>& lootList)
{
	lua_createtable(L, lootList.size(), 0);

	int index = 0;
	for (const auto& lootBlock : lootList) {
		lua_createtable(L, 0, 8);

		setField(L, "itemId", lootBlock.id);
		setField(L, "chance", lootBlock.chance);
		setField(L, "subType", lootBlock.subType);
		setField(L, "maxCount", lootBlock.countmax);
		setField(L, "actionId", lootBlock.actionId);
		setField(L, "text", lootBlock.text);
		setField(L, "top", lootBlock.top);

		pushLoot(L, lootBlock.childLoot);
		lua_setfield(L, -2, "childLoot");

		lua_rawseti(L, -2, ++index);
	}
}

void LuaScriptInterface::pushReflect(lua_State* L, const Reflect& reflect)
{
	lua_createtable(L, 0, 2);
	setField(L, "percent", reflect.percent);
	setField(L, "chance", reflect.chance);
}

#define registerEnum(value) { std::string enumName = #value; registerGlobalVariable(enumName.substr(enumName.find_last_of(':') + 1), value); }
#define registerEnumIn(tableName, value) { std::string enumName = #value; registerVariable(tableName, enumName.substr(enumName.find_last_of(':') + 1), value); }

void LuaScriptInterface::registerFunctions()
{
	//doPlayerAddItem(uid, itemid, <optional: default: 1> count/subtype)
	//doPlayerAddItem(cid, itemid, <optional: default: 1> count, <optional: default: 1> canDropOnMap, <optional: default: 1>subtype)
	//Returns uid of the created item
	lua_register(luaState, "doPlayerAddItem", LuaScriptInterface::luaDoPlayerAddItem);

	//isValidUID(uid)
	lua_register(luaState, "isValidUID", LuaScriptInterface::luaIsValidUID);

	//isDepot(uid)
	lua_register(luaState, "isDepot", LuaScriptInterface::luaIsDepot);

	//isMovable(uid)
	lua_register(luaState, "isMovable", LuaScriptInterface::luaIsMoveable);

	//doAddContainerItem(uid, itemid, <optional> count/subtype)
	lua_register(luaState, "doAddContainerItem", LuaScriptInterface::luaDoAddContainerItem);

	//getDepotId(uid)
	lua_register(luaState, "getDepotId", LuaScriptInterface::luaGetDepotId);

	//getWorldTime()
	lua_register(luaState, "getWorldTime", LuaScriptInterface::luaGetWorldTime);

	//getWorldLight()
	lua_register(luaState, "getWorldLight", LuaScriptInterface::luaGetWorldLight);

	//setWorldLight(level, color)
	lua_register(luaState, "setWorldLight", LuaScriptInterface::luaSetWorldLight);

	//getWorldUpTime()
	lua_register(luaState, "getWorldUpTime", LuaScriptInterface::luaGetWorldUpTime);

	// getSubTypeName(subType)
	lua_register(luaState, "getSubTypeName", LuaScriptInterface::luaGetSubTypeName);

	//createCombatArea( {area}, <optional> {extArea} )
	lua_register(luaState, "createCombatArea", LuaScriptInterface::luaCreateCombatArea);

	//doAreaCombat(cid, type, pos, area, min, max, effect[, origin = ORIGIN_SPELL[, blockArmor = false[, blockShield = false[, ignoreResistances = false]]]])
	lua_register(luaState, "doAreaCombat", LuaScriptInterface::luaDoAreaCombat);

	//doTargetCombat(cid, target, type, min, max, effect[, origin = ORIGIN_SPELL[, blockArmor = false[, blockShield = false[, ignoreResistances = false]]]])
	lua_register(luaState, "doTargetCombat", LuaScriptInterface::luaDoTargetCombat);

	//doChallengeCreature(cid, target[, force = false])
	lua_register(luaState, "doChallengeCreature", LuaScriptInterface::luaDoChallengeCreature);

	//addEvent(callback, delay, ...)
	lua_register(luaState, "addEvent", LuaScriptInterface::luaAddEvent);

	//stopEvent(eventid)
	lua_register(luaState, "stopEvent", LuaScriptInterface::luaStopEvent);

	//saveServer()
	lua_register(luaState, "saveServer", LuaScriptInterface::luaSaveServer);

	//cleanMap()
	lua_register(luaState, "cleanMap", LuaScriptInterface::luaCleanMap);

	//debugPrint(text)
	lua_register(luaState, "debugPrint", LuaScriptInterface::luaDebugPrint);

	//isInWar(cid, target)
	lua_register(luaState, "isInWar", LuaScriptInterface::luaIsInWar);

	//getWaypointPosition(name)
	lua_register(luaState, "getWaypointPositionByName", LuaScriptInterface::luaGetWaypointPositionByName);

	//sendChannelMessage(channelId, type, message)
	lua_register(luaState, "sendChannelMessage", LuaScriptInterface::luaSendChannelMessage);

	//sendGuildChannelMessage(guildId, type, message)
	lua_register(luaState, "sendGuildChannelMessage", LuaScriptInterface::luaSendGuildChannelMessage);

	//isScriptsInterface()
	lua_register(luaState, "isScriptsInterface", LuaScriptInterface::luaIsScriptsInterface);

	//refreshConsole()
	lua_register(luaState, "refreshConsole", LuaScriptInterface::luaRefreshConsole);

#ifndef LUAJIT_VERSION
	//bit operations for Lua, based on bitlib project release 24
	//bit.bnot, bit.band, bit.bor, bit.bxor, bit.lshift, bit.rshift
	luaL_register(luaState, "bit", LuaScriptInterface::luaBitReg);
	lua_pop(luaState, 1);
#endif

	//configManager table
	luaL_register(luaState, "configManager", LuaScriptInterface::luaConfigManagerTable);
	lua_pop(luaState, 1);

	//db table
	luaL_register(luaState, "db", LuaScriptInterface::luaDatabaseTable);
	lua_pop(luaState, 1);

	//result table
	luaL_register(luaState, "result", LuaScriptInterface::luaResultTable);
	lua_pop(luaState, 1);

	/* New functions */
	//registerClass(className, baseClass, newFunction)
	//registerTable(tableName)
	//registerMethod(className, functionName, function)
	//registerMetaMethod(className, functionName, function)
	//registerGlobalMethod(functionName, function)
	//registerVariable(tableName, name, value)
	//registerGlobalVariable(name, value)
	//registerEnum(value)
	//registerEnumIn(tableName, value)

	// Enums
	registerEnum(ACCOUNT_TYPE_NORMAL)
	registerEnum(ACCOUNT_TYPE_TUTOR)
	registerEnum(ACCOUNT_TYPE_SENIORTUTOR)
	registerEnum(ACCOUNT_TYPE_GAMEMASTER)
	registerEnum(ACCOUNT_TYPE_COMMUNITYMANAGER)
	registerEnum(ACCOUNT_TYPE_GOD)

	registerEnum(AMMO_NONE)
	registerEnum(AMMO_BOLT)
	registerEnum(AMMO_ARROW)
	registerEnum(AMMO_SPEAR)
	registerEnum(AMMO_THROWINGSTAR)
	registerEnum(AMMO_THROWINGKNIFE)
	registerEnum(AMMO_STONE)
	registerEnum(AMMO_SNOWBALL)

	registerEnum(BUG_CATEGORY_MAP)
	registerEnum(BUG_CATEGORY_TYPO)
	registerEnum(BUG_CATEGORY_TECHNICAL)
	registerEnum(BUG_CATEGORY_OTHER)

	registerEnum(CALLBACK_PARAM_LEVELMAGICVALUE)
	registerEnum(CALLBACK_PARAM_SKILLVALUE)
	registerEnum(CALLBACK_PARAM_TARGETTILE)
	registerEnum(CALLBACK_PARAM_TARGETCREATURE)

	registerEnum(COMBAT_FORMULA_UNDEFINED)
	registerEnum(COMBAT_FORMULA_LEVELMAGIC)
	registerEnum(COMBAT_FORMULA_SKILL)
	registerEnum(COMBAT_FORMULA_DAMAGE)

	registerEnum(CONSOLEMESSAGE_TYPE_INFO)
	registerEnum(CONSOLEMESSAGE_TYPE_STARTUP)
	registerEnum(CONSOLEMESSAGE_TYPE_STARTUP_SPECIAL)
	registerEnum(CONSOLEMESSAGE_TYPE_WARNING)
	registerEnum(CONSOLEMESSAGE_TYPE_ERROR)
	registerEnum(CONSOLEMESSAGE_TYPE_BROADCAST)

	registerEnum(DIRECTION_NORTH)
	registerEnum(DIRECTION_EAST)
	registerEnum(DIRECTION_SOUTH)
	registerEnum(DIRECTION_WEST)
	registerEnum(DIRECTION_SOUTHWEST)
	registerEnum(DIRECTION_SOUTHEAST)
	registerEnum(DIRECTION_NORTHWEST)
	registerEnum(DIRECTION_NORTHEAST)

	registerEnum(COMBAT_NONE)
	registerEnum(COMBAT_PHYSICALDAMAGE)
	registerEnum(COMBAT_ENERGYDAMAGE)
	registerEnum(COMBAT_EARTHDAMAGE)
	registerEnum(COMBAT_FIREDAMAGE)
	registerEnum(COMBAT_UNDEFINEDDAMAGE)
	registerEnum(COMBAT_LIFEDRAIN)
	registerEnum(COMBAT_MANADRAIN)
	registerEnum(COMBAT_HEALING)
	registerEnum(COMBAT_DROWNDAMAGE)
	registerEnum(COMBAT_ICEDAMAGE)
	registerEnum(COMBAT_HOLYDAMAGE)
	registerEnum(COMBAT_DEATHDAMAGE)

	registerEnum(COMBAT_PARAM_TYPE)
	registerEnum(COMBAT_PARAM_EFFECT)
	registerEnum(COMBAT_PARAM_DISTANCEEFFECT)
	registerEnum(COMBAT_PARAM_BLOCKSHIELD)
	registerEnum(COMBAT_PARAM_BLOCKARMOR)
	registerEnum(COMBAT_PARAM_TARGETCASTERORTOPMOST)
	registerEnum(COMBAT_PARAM_CREATEITEM)
	registerEnum(COMBAT_PARAM_AGGRESSIVE)
	registerEnum(COMBAT_PARAM_DISPEL)
	registerEnum(COMBAT_PARAM_USECHARGES)

	registerEnum(CONDITION_NONE)
	registerEnum(CONDITION_POISON)
	registerEnum(CONDITION_FIRE)
	registerEnum(CONDITION_ENERGY)
	registerEnum(CONDITION_BLEEDING)
	registerEnum(CONDITION_HASTE)
	registerEnum(CONDITION_PARALYZE)
	registerEnum(CONDITION_OUTFIT)
	registerEnum(CONDITION_INVISIBLE)
	registerEnum(CONDITION_LIGHT)
	registerEnum(CONDITION_MANASHIELD)
	registerEnum(CONDITION_INFIGHT)
	registerEnum(CONDITION_DRUNK)
	registerEnum(CONDITION_EXHAUST_WEAPON)
	registerEnum(CONDITION_REGENERATION)
	registerEnum(CONDITION_SOUL)
	registerEnum(CONDITION_DROWN)
	registerEnum(CONDITION_MUTED)
	registerEnum(CONDITION_CHANNELMUTEDTICKS)
	registerEnum(CONDITION_YELLTICKS)
	registerEnum(CONDITION_ATTRIBUTES)
	registerEnum(CONDITION_FREEZING)
	registerEnum(CONDITION_DAZZLED)
	registerEnum(CONDITION_CURSED)
	registerEnum(CONDITION_EXHAUST_COMBAT)
	registerEnum(CONDITION_EXHAUST_HEAL)
	registerEnum(CONDITION_PACIFIED)
	registerEnum(CONDITION_SPELLCOOLDOWN)
	registerEnum(CONDITION_SPELLGROUPCOOLDOWN)

	registerEnum(CONDITIONID_DEFAULT)
	registerEnum(CONDITIONID_COMBAT)
	registerEnum(CONDITIONID_HEAD)
	registerEnum(CONDITIONID_NECKLACE)
	registerEnum(CONDITIONID_BACKPACK)
	registerEnum(CONDITIONID_ARMOR)
	registerEnum(CONDITIONID_RIGHT)
	registerEnum(CONDITIONID_LEFT)
	registerEnum(CONDITIONID_LEGS)
	registerEnum(CONDITIONID_FEET)
	registerEnum(CONDITIONID_RING)
	registerEnum(CONDITIONID_AMMO)

	registerEnum(CONDITION_PARAM_OWNER)
	registerEnum(CONDITION_PARAM_TICKS)
	registerEnum(CONDITION_PARAM_DRUNKENNESS)
	registerEnum(CONDITION_PARAM_HEALTHGAIN)
	registerEnum(CONDITION_PARAM_HEALTHTICKS)
	registerEnum(CONDITION_PARAM_MANAGAIN)
	registerEnum(CONDITION_PARAM_MANATICKS)
	registerEnum(CONDITION_PARAM_DELAYED)
	registerEnum(CONDITION_PARAM_SPEED)
	registerEnum(CONDITION_PARAM_LIGHT_LEVEL)
	registerEnum(CONDITION_PARAM_LIGHT_COLOR)
	registerEnum(CONDITION_PARAM_SOULGAIN)
	registerEnum(CONDITION_PARAM_SOULTICKS)
	registerEnum(CONDITION_PARAM_MINVALUE)
	registerEnum(CONDITION_PARAM_MAXVALUE)
	registerEnum(CONDITION_PARAM_STARTVALUE)
	registerEnum(CONDITION_PARAM_TICKINTERVAL)
	registerEnum(CONDITION_PARAM_FORCEUPDATE)
	registerEnum(CONDITION_PARAM_SKILL_MELEE)
	registerEnum(CONDITION_PARAM_SKILL_FIST)
	registerEnum(CONDITION_PARAM_SKILL_CLUB)
	registerEnum(CONDITION_PARAM_SKILL_SWORD)
	registerEnum(CONDITION_PARAM_SKILL_AXE)
	registerEnum(CONDITION_PARAM_SKILL_DISTANCE)
	registerEnum(CONDITION_PARAM_SKILL_SHIELD)
	registerEnum(CONDITION_PARAM_SKILL_FISHING)
	registerEnum(CONDITION_PARAM_STAT_MAXHITPOINTS)
	registerEnum(CONDITION_PARAM_STAT_MAXHITPOINTSPERCENT)
	registerEnum(CONDITION_PARAM_STAT_MAXMANAPOINTS)
	registerEnum(CONDITION_PARAM_STAT_MAXMANAPOINTSPERCENT)
	registerEnum(CONDITION_PARAM_STAT_MAGICPOINTS)
	registerEnum(CONDITION_PARAM_STAT_MAGICPOINTSPERCENT)
	registerEnum(CONDITION_PARAM_STAT_CAPACITY)
	registerEnum(CONDITION_PARAM_STAT_CAPACITYPERCENT)
	registerEnum(CONDITION_PARAM_PERIODICDAMAGE)
	registerEnum(CONDITION_PARAM_STAT_VIBRANCY)
	registerEnum(CONDITION_PARAM_SKILL_MELEEPERCENT)
	registerEnum(CONDITION_PARAM_SKILL_FISTPERCENT)
	registerEnum(CONDITION_PARAM_SKILL_CLUBPERCENT)
	registerEnum(CONDITION_PARAM_SKILL_SWORDPERCENT)
	registerEnum(CONDITION_PARAM_SKILL_AXEPERCENT)
	registerEnum(CONDITION_PARAM_SKILL_DISTANCEPERCENT)
	registerEnum(CONDITION_PARAM_SKILL_SHIELDPERCENT)
	registerEnum(CONDITION_PARAM_SKILL_FISHINGPERCENT)
	registerEnum(CONDITION_PARAM_BUFF_SPELL)
	registerEnum(CONDITION_PARAM_SUBID)
	registerEnum(CONDITION_PARAM_FIELD)
	registerEnum(CONDITION_PARAM_DISABLE_DEFENSE)
	registerEnum(CONDITION_PARAM_SPECIALSKILL_CRITICALHITCHANCE)
	registerEnum(CONDITION_PARAM_SPECIALSKILL_CRITICALHITAMOUNT)
	registerEnum(CONDITION_PARAM_SPECIALSKILL_LIFELEECHCHANCE)
	registerEnum(CONDITION_PARAM_SPECIALSKILL_LIFELEECHAMOUNT)
	registerEnum(CONDITION_PARAM_SPECIALSKILL_MANALEECHCHANCE)
	registerEnum(CONDITION_PARAM_SPECIALSKILL_MANALEECHAMOUNT)
	registerEnum(CONDITION_PARAM_SPECIALSKILL_ONSLAUGHT)
	registerEnum(CONDITION_PARAM_SPECIALSKILL_RUSE)
	registerEnum(CONDITION_PARAM_SPECIALSKILL_MOMENTUM)
	registerEnum(CONDITION_PARAM_AGGRESSIVE)
	registerEnum(CONDITION_PARAM_ICONS)

	registerEnum(ICON_POISON)
	registerEnum(ICON_BURN)
	registerEnum(ICON_ENERGY)
	registerEnum(ICON_DRUNK)
	registerEnum(ICON_MANASHIELD)
	registerEnum(ICON_PARALYZE)
	registerEnum(ICON_HASTE)
	registerEnum(ICON_SWORDS)
	registerEnum(ICON_DROWNING)
	registerEnum(ICON_FREEZING)
	registerEnum(ICON_DAZZLED)
	registerEnum(ICON_CURSED)
	registerEnum(ICON_PARTY_BUFF)
	registerEnum(ICON_REDSWORDS)
	registerEnum(ICON_PIGEON)
	registerEnum(ICON_BLEEDING)
	registerEnum(ICON_LESSERHEX)
	registerEnum(ICON_INTENSEHEX)
	registerEnum(ICON_GREATERHEX)
	registerEnum(ICON_ROOT)
	registerEnum(ICON_FEAR)
	registerEnum(ICON_GOSHNAR1)
	registerEnum(ICON_GOSHNAR2)
	registerEnum(ICON_GOSHNAR3)
	registerEnum(ICON_GOSHNAR4)
	registerEnum(ICON_GOSHNAR5)
	registerEnum(ICON_MANASHIELD_BREAKABLE)

	registerEnum(CONST_ME_NONE)
	registerEnum(CONST_ME_DRAWBLOOD)
	registerEnum(CONST_ME_LOSEENERGY)
	registerEnum(CONST_ME_POFF)
	registerEnum(CONST_ME_BLOCKHIT)
	registerEnum(CONST_ME_EXPLOSIONAREA)
	registerEnum(CONST_ME_EXPLOSIONHIT)
	registerEnum(CONST_ME_FIREAREA)
	registerEnum(CONST_ME_YELLOW_RINGS)
	registerEnum(CONST_ME_GREEN_RINGS)
	registerEnum(CONST_ME_HITAREA)
	registerEnum(CONST_ME_TELEPORT)
	registerEnum(CONST_ME_ENERGYHIT)
	registerEnum(CONST_ME_MAGIC_BLUE)
	registerEnum(CONST_ME_MAGIC_RED)
	registerEnum(CONST_ME_MAGIC_GREEN)
	registerEnum(CONST_ME_HITBYFIRE)
	registerEnum(CONST_ME_HITBYPOISON)
	registerEnum(CONST_ME_MORTAREA)
	registerEnum(CONST_ME_SOUND_GREEN)
	registerEnum(CONST_ME_SOUND_RED)
	registerEnum(CONST_ME_POISONAREA)
	registerEnum(CONST_ME_SOUND_YELLOW)
	registerEnum(CONST_ME_SOUND_PURPLE)
	registerEnum(CONST_ME_SOUND_BLUE)
	registerEnum(CONST_ME_SOUND_WHITE)
	registerEnum(CONST_ME_BUBBLES)
	registerEnum(CONST_ME_CRAPS)
	registerEnum(CONST_ME_GIFT_WRAPS)
	registerEnum(CONST_ME_FIREWORK_YELLOW)
	registerEnum(CONST_ME_FIREWORK_RED)
	registerEnum(CONST_ME_FIREWORK_BLUE)
	registerEnum(CONST_ME_STUN)
	registerEnum(CONST_ME_SLEEP)
	registerEnum(CONST_ME_WATERCREATURE)
	registerEnum(CONST_ME_GROUNDSHAKER)
	registerEnum(CONST_ME_HEARTS)
	registerEnum(CONST_ME_FIREATTACK)
	registerEnum(CONST_ME_ENERGYAREA)
	registerEnum(CONST_ME_SMALLCLOUDS)
	registerEnum(CONST_ME_HOLYDAMAGE)
	registerEnum(CONST_ME_BIGCLOUDS)
	registerEnum(CONST_ME_ICEAREA)
	registerEnum(CONST_ME_ICETORNADO)
	registerEnum(CONST_ME_ICEATTACK)
	registerEnum(CONST_ME_STONES)
	registerEnum(CONST_ME_SMALLPLANTS)
	registerEnum(CONST_ME_CARNIPHILA)
	registerEnum(CONST_ME_PURPLEENERGY)
	registerEnum(CONST_ME_YELLOWENERGY)
	registerEnum(CONST_ME_HOLYAREA)
	registerEnum(CONST_ME_BIGPLANTS)
	registerEnum(CONST_ME_CAKE)
	registerEnum(CONST_ME_GIANTICE)
	registerEnum(CONST_ME_WATERSPLASH)
	registerEnum(CONST_ME_PLANTATTACK)
	registerEnum(CONST_ME_TUTORIALARROW)
	registerEnum(CONST_ME_TUTORIALSQUARE)
	registerEnum(CONST_ME_MIRRORHORIZONTAL)
	registerEnum(CONST_ME_MIRRORVERTICAL)
	registerEnum(CONST_ME_SKULLHORIZONTAL)
	registerEnum(CONST_ME_SKULLVERTICAL)
	registerEnum(CONST_ME_ASSASSIN)
	registerEnum(CONST_ME_STEPSHORIZONTAL)
	registerEnum(CONST_ME_BLOODYSTEPS)
	registerEnum(CONST_ME_STEPSVERTICAL)
	registerEnum(CONST_ME_YALAHARIGHOST)
	registerEnum(CONST_ME_BATS)
	registerEnum(CONST_ME_SMOKE)
	registerEnum(CONST_ME_INSECTS)
	registerEnum(CONST_ME_DRAGONHEAD)
	registerEnum(CONST_ME_ORCSHAMAN)
	registerEnum(CONST_ME_ORCSHAMAN_FIRE)
	registerEnum(CONST_ME_THUNDER)
	registerEnum(CONST_ME_FERUMBRAS)
	registerEnum(CONST_ME_CONFETTI_HORIZONTAL)
	registerEnum(CONST_ME_CONFETTI_VERTICAL)
	registerEnum(CONST_ME_BLACKSMOKE)
	registerEnum(CONST_ME_REDSMOKE)
	registerEnum(CONST_ME_YELLOWSMOKE)
	registerEnum(CONST_ME_GREENSMOKE)
	registerEnum(CONST_ME_PURPLESMOKE)
	registerEnum(CONST_ME_EARLY_THUNDER)
	registerEnum(CONST_ME_RAGIAZ_BONECAPSULE)
	registerEnum(CONST_ME_CRITICAL_DAMAGE)
	registerEnum(CONST_ME_PLUNGING_FISH)
	registerEnum(CONST_ME_PLUNGING_FISH)
	registerEnum(CONST_ME_BLUECHAIN)
	registerEnum(CONST_ME_ORANGECHAIN)
	registerEnum(CONST_ME_GREENCHAIN)
	registerEnum(CONST_ME_PURPLECHAIN)
	registerEnum(CONST_ME_GREYCHAIN)
	registerEnum(CONST_ME_YELLOWCHAIN)
	registerEnum(CONST_ME_MAGIC_YELLOW)
	registerEnum(CONST_ME_FAEEXPLOSION)
	registerEnum(CONST_ME_FAECOMING)
	registerEnum(CONST_ME_FAEGOING)
	registerEnum(CONST_ME_BIGCLOUDS_THICK)
	registerEnum(CONST_ME_STONES_THICK)
	registerEnum(CONST_ME_GHOST_BLUE)
	registerEnum(CONST_ME_POINTOFINTEREST)
	registerEnum(CONST_ME_SCROLL)
	registerEnum(CONST_ME_PINKSPARK)
	registerEnum(CONST_ME_FIREWORK_GREEN)
	registerEnum(CONST_ME_FIREWORK_ORANGE)
	registerEnum(CONST_ME_FIREWORK_PURPLE)
	registerEnum(CONST_ME_FIREWORK_TURQUOISE)
	registerEnum(CONST_ME_CUBECOMPLETE)
	registerEnum(CONST_ME_INKSPLASH)
	registerEnum(CONST_ME_MAGIC_RAINBOW)
	registerEnum(CONST_ME_THAIAN)
	registerEnum(CONST_ME_THAIANGHOST)
	registerEnum(CONST_ME_GHOSTSMOKE)
	registerEnum(CONST_ME_CREATEBLOCK)
	registerEnum(CONST_ME_STONEBLOCK)
	registerEnum(CONST_ME_ROOTS)
	registerEnum(CONST_ME_GHOSTLYSCRATCH)
	registerEnum(CONST_ME_GHOSTLYBITE)
	registerEnum(CONST_ME_BIGSCRATCHING)
	registerEnum(CONST_ME_SLASH)
	registerEnum(CONST_ME_BITE)
	registerEnum(CONST_ME_CHIVALRIOUSCHALLENGE)
	registerEnum(CONST_ME_DIVINEDAZZLE)
	registerEnum(CONST_ME_ELECTRICALSPARK)
	registerEnum(CONST_ME_TELEPORT_PURPLE)
	registerEnum(CONST_ME_TELEPORT_RED)
	registerEnum(CONST_ME_TELEPORT_ORANGE)
	registerEnum(CONST_ME_TELEPORT_GREY)
	registerEnum(CONST_ME_TELEPORT_LIGHTBLUE)
	registerEnum(CONST_ME_FATAL)
	registerEnum(CONST_ME_DODGE)
	registerEnum(CONST_ME_HOURGLASS)
	registerEnum(CONST_ME_FIREWORK_STAR)
	registerEnum(CONST_ME_FIREWORK_CIRCLE)
	registerEnum(CONST_ME_FERUMBRAS_1)
	registerEnum(CONST_ME_GAZHARAGOTH)
	registerEnum(CONST_ME_MAD_MAGE)
	registerEnum(CONST_ME_HORESTIS)
	registerEnum(CONST_ME_DEVOVORGA)
	registerEnum(CONST_ME_FERUMBRAS_2)
	registerEnum(CONST_ME_FOAM)

	registerEnum(CONST_ANI_NONE)
	registerEnum(CONST_ANI_SPEAR)
	registerEnum(CONST_ANI_BOLT)
	registerEnum(CONST_ANI_ARROW)
	registerEnum(CONST_ANI_FIRE)
	registerEnum(CONST_ANI_ENERGY)
	registerEnum(CONST_ANI_POISONARROW)
	registerEnum(CONST_ANI_BURSTARROW)
	registerEnum(CONST_ANI_THROWINGSTAR)
	registerEnum(CONST_ANI_THROWINGKNIFE)
	registerEnum(CONST_ANI_SMALLSTONE)
	registerEnum(CONST_ANI_DEATH)
	registerEnum(CONST_ANI_LARGEROCK)
	registerEnum(CONST_ANI_SNOWBALL)
	registerEnum(CONST_ANI_POWERBOLT)
	registerEnum(CONST_ANI_POISON)
	registerEnum(CONST_ANI_INFERNALBOLT)
	registerEnum(CONST_ANI_HUNTINGSPEAR)
	registerEnum(CONST_ANI_ENCHANTEDSPEAR)
	registerEnum(CONST_ANI_REDSTAR)
	registerEnum(CONST_ANI_GREENSTAR)
	registerEnum(CONST_ANI_ROYALSPEAR)
	registerEnum(CONST_ANI_SNIPERARROW)
	registerEnum(CONST_ANI_ONYXARROW)
	registerEnum(CONST_ANI_PIERCINGBOLT)
	registerEnum(CONST_ANI_WHIRLWINDSWORD)
	registerEnum(CONST_ANI_WHIRLWINDAXE)
	registerEnum(CONST_ANI_WHIRLWINDCLUB)
	registerEnum(CONST_ANI_ETHEREALSPEAR)
	registerEnum(CONST_ANI_ICE)
	registerEnum(CONST_ANI_EARTH)
	registerEnum(CONST_ANI_HOLY)
	registerEnum(CONST_ANI_SUDDENDEATH)
	registerEnum(CONST_ANI_FLASHARROW)
	registerEnum(CONST_ANI_FLAMMINGARROW)
	registerEnum(CONST_ANI_SHIVERARROW)
	registerEnum(CONST_ANI_ENERGYBALL)
	registerEnum(CONST_ANI_SMALLICE)
	registerEnum(CONST_ANI_SMALLHOLY)
	registerEnum(CONST_ANI_SMALLEARTH)
	registerEnum(CONST_ANI_EARTHARROW)
	registerEnum(CONST_ANI_EXPLOSION)
	registerEnum(CONST_ANI_CAKE)
	registerEnum(CONST_ANI_TARSALARROW)
	registerEnum(CONST_ANI_VORTEXBOLT)
	registerEnum(CONST_ANI_PRISMATICBOLT)
	registerEnum(CONST_ANI_CRYSTALLINEARROW)
	registerEnum(CONST_ANI_DRILLBOLT)
	registerEnum(CONST_ANI_ENVENOMEDARROW)
	registerEnum(CONST_ANI_GLOOTHSPEAR)
	registerEnum(CONST_ANI_SIMPLEARROW)
	registerEnum(CONST_ANI_LEAFSTAR)
	registerEnum(CONST_ANI_DIAMONDARROW)
	registerEnum(CONST_ANI_SPECTRALBOLT)
	registerEnum(CONST_ANI_ROYALSTAR)
	registerEnum(CONST_ANI_WEAPONTYPE)

	registerEnum(CREATURE_ICON_NONE)
	registerEnum(CREATURE_ICON_CROSS_WHITE)
	registerEnum(CREATURE_ICON_CROSS_WHITE_RED)
	registerEnum(CREATURE_ICON_ORB_RED)
	registerEnum(CREATURE_ICON_ORB_GREEN)
	registerEnum(CREATURE_ICON_ORB_RED_GREEN)
	registerEnum(CREATURE_ICON_GEM_GREEN)
	registerEnum(CREATURE_ICON_GEM_YELLOW)
	registerEnum(CREATURE_ICON_GEM_BLUE)
	registerEnum(CREATURE_ICON_GEM_PURPLE)
	registerEnum(CREATURE_ICON_GEM_RED)
	registerEnum(CREATURE_ICON_PIGEON)
	registerEnum(CREATURE_ICON_ENERGY)
	registerEnum(CREATURE_ICON_POISON)
	registerEnum(CREATURE_ICON_WATER)
	registerEnum(CREATURE_ICON_FIRE)
	registerEnum(CREATURE_ICON_ICE)
	registerEnum(CREATURE_ICON_ARROW_UP)
	registerEnum(CREATURE_ICON_ARROW_DOWN)
	registerEnum(CREATURE_ICON_WARNING)
	registerEnum(CREATURE_ICON_QUESTION)
	registerEnum(CREATURE_ICON_CROSS_RED)

	registerEnum(MONSTER_ICON_NONE)
	registerEnum(MONSTER_ICON_VULNERABLE)
	registerEnum(MONSTER_ICON_WEAKENED)
	registerEnum(MONSTER_ICON_MELEE)
	registerEnum(MONSTER_ICON_INFLUENCED)
	registerEnum(MONSTER_ICON_FIENDISH)

	registerEnum(HOUSE_NOT_INVITED)
	registerEnum(HOUSE_GUEST)
	registerEnum(HOUSE_SUBOWNER)
	registerEnum(HOUSE_OWNER)

	registerEnum(CONST_PROP_BLOCKSOLID)
	registerEnum(CONST_PROP_HASHEIGHT)
	registerEnum(CONST_PROP_BLOCKPROJECTILE)
	registerEnum(CONST_PROP_BLOCKPATH)
	registerEnum(CONST_PROP_ISVERTICAL)
	registerEnum(CONST_PROP_ISHORIZONTAL)
	registerEnum(CONST_PROP_MOVEABLE)
	registerEnum(CONST_PROP_IMMOVABLEBLOCKSOLID)
	registerEnum(CONST_PROP_IMMOVABLEBLOCKPATH)
	registerEnum(CONST_PROP_IMMOVABLENOFIELDBLOCKPATH)
	registerEnum(CONST_PROP_NOFIELDBLOCKPATH)
	registerEnum(CONST_PROP_SUPPORTHANGABLE)

	registerEnum(CONST_SLOT_HEAD)
	registerEnum(CONST_SLOT_NECKLACE)
	registerEnum(CONST_SLOT_BACKPACK)
	registerEnum(CONST_SLOT_ARMOR)
	registerEnum(CONST_SLOT_RIGHT)
	registerEnum(CONST_SLOT_LEFT)
	registerEnum(CONST_SLOT_LEGS)
	registerEnum(CONST_SLOT_FEET)
	registerEnum(CONST_SLOT_RING)
	registerEnum(CONST_SLOT_AMMO)
	registerEnum(CONST_SLOT_STORE_INBOX)
	registerEnum(CONST_SLOT_FIRST)
	registerEnum(CONST_SLOT_LAST)

	registerEnum(CREATURE_EVENT_NONE)
	registerEnum(CREATURE_EVENT_LOGIN)
	registerEnum(CREATURE_EVENT_LOGOUT)
	registerEnum(CREATURE_EVENT_THINK)
	registerEnum(CREATURE_EVENT_PREPAREDEATH)
	registerEnum(CREATURE_EVENT_DEATH)
	registerEnum(CREATURE_EVENT_KILL)
	registerEnum(CREATURE_EVENT_ADVANCE)
	registerEnum(CREATURE_EVENT_MODALWINDOW)
	registerEnum(CREATURE_EVENT_TEXTEDIT)
	registerEnum(CREATURE_EVENT_HEALTHCHANGE)
	registerEnum(CREATURE_EVENT_MANACHANGE)
	registerEnum(CREATURE_EVENT_EXTENDED_OPCODE)

	registerEnum(CREATURE_ID_MIN)
	registerEnum(CREATURE_ID_MAX)

	registerEnum(PLAYER_ID_MIN)
	registerEnum(PLAYER_ID_MAX)

	registerEnum(GAME_STATE_STARTUP)
	registerEnum(GAME_STATE_INIT)
	registerEnum(GAME_STATE_NORMAL)
	registerEnum(GAME_STATE_CLOSED)
	registerEnum(GAME_STATE_SHUTDOWN)
	registerEnum(GAME_STATE_CLOSING)
	registerEnum(GAME_STATE_MAINTAIN)

	registerEnum(MESSAGE_STATUS_CONSOLE_BLUE)
	registerEnum(MESSAGE_CHANNEL_MANAGEMENT)
	registerEnum(MESSAGE_STATUS_DEFAULT)
	registerEnum(MESSAGE_STATUS_WARNING)
	registerEnum(MESSAGE_EVENT_ADVANCE)
	registerEnum(MESSAGE_STATUS_WARNING2)
	registerEnum(MESSAGE_STATUS_SMALL)
	registerEnum(MESSAGE_INFO_DESCR)
	registerEnum(MESSAGE_DAMAGE_DEALT)
	registerEnum(MESSAGE_DAMAGE_RECEIVED)
	registerEnum(MESSAGE_HEALED)
	registerEnum(MESSAGE_EXPERIENCE)
	registerEnum(MESSAGE_DAMAGE_OTHERS)
	registerEnum(MESSAGE_HEALED_OTHERS)
	registerEnum(MESSAGE_EXPERIENCE_OTHERS)
	registerEnum(MESSAGE_EVENT_DEFAULT)
	registerEnum(MESSAGE_LOOT)
	registerEnum(MESSAGE_TRADE)
	registerEnum(MESSAGE_GUILD)
	registerEnum(MESSAGE_PARTY_MANAGEMENT)
	registerEnum(MESSAGE_PARTY)
	registerEnum(MESSAGE_REPORT)
	registerEnum(MESSAGE_HOTKEY_PRESSED)
	registerEnum(MESSAGE_MARKET)
	registerEnum(MESSAGE_MANA)
	registerEnum(MESSAGE_BEYOND_LAST)
	registerEnum(MESSAGE_TOURNAMENT_INFO)
	registerEnum(MESSAGE_ATTENTION)
	registerEnum(MESSAGE_MANA2)
	registerEnum(MESSAGE_BOOSTED_CREATURE)
	registerEnum(MESSAGE_OFFLINE_TRAINING)
	registerEnum(MESSAGE_TRANSACTION)

	registerEnum(CREATURETYPE_PLAYER)
	registerEnum(CREATURETYPE_MONSTER)
	registerEnum(CREATURETYPE_NPC)
	registerEnum(CREATURETYPE_SUMMON_OWN)
	registerEnum(CREATURETYPE_SUMMON_OTHERS)

	registerEnum(CREATURE_DISPLAY_MODE_NONE)
	registerEnum(CREATURE_DISPLAY_MODE_PLAYER)
	registerEnum(CREATURE_DISPLAY_MODE_MONSTER)
	registerEnum(CREATURE_DISPLAY_MODE_NPC)
	registerEnum(CREATURE_DISPLAY_MODE_SUMMON)
	registerEnum(CREATURE_DISPLAY_MODE_SUMMON_OTHER)
	registerEnum(CREATURE_DISPLAY_MODE_HIDDEN)

	registerEnum(CLIENTOS_LINUX)
	registerEnum(CLIENTOS_WINDOWS)
	registerEnum(CLIENTOS_FLASH)
	registerEnum(CLIENTOS_OTCLIENT_LINUX)
	registerEnum(CLIENTOS_OTCLIENT_WINDOWS)
	registerEnum(CLIENTOS_OTCLIENT_MAC)

	registerEnum(FIGHTMODE_ATTACK)
	registerEnum(FIGHTMODE_BALANCED)
	registerEnum(FIGHTMODE_DEFENSE)

	registerEnum(ITEM_ATTRIBUTE_NONE)
	registerEnum(ITEM_ATTRIBUTE_ACTIONID)
	registerEnum(ITEM_ATTRIBUTE_UNIQUEID)
	registerEnum(ITEM_ATTRIBUTE_DESCRIPTION)
	registerEnum(ITEM_ATTRIBUTE_TEXT)
	registerEnum(ITEM_ATTRIBUTE_DATE)
	registerEnum(ITEM_ATTRIBUTE_WRITER)
	registerEnum(ITEM_ATTRIBUTE_NAME)
	registerEnum(ITEM_ATTRIBUTE_ARTICLE)
	registerEnum(ITEM_ATTRIBUTE_PLURALNAME)
	registerEnum(ITEM_ATTRIBUTE_WEIGHT)
	registerEnum(ITEM_ATTRIBUTE_ATTACK)
	registerEnum(ITEM_ATTRIBUTE_DEFENSE)
	registerEnum(ITEM_ATTRIBUTE_EXTRADEFENSE)
	registerEnum(ITEM_ATTRIBUTE_ARMOR)
	registerEnum(ITEM_ATTRIBUTE_HITCHANCE)
	registerEnum(ITEM_ATTRIBUTE_SHOOTRANGE)
	registerEnum(ITEM_ATTRIBUTE_OWNER)
	registerEnum(ITEM_ATTRIBUTE_DURATION)
	registerEnum(ITEM_ATTRIBUTE_DECAYSTATE)
	registerEnum(ITEM_ATTRIBUTE_CORPSEOWNER)
	registerEnum(ITEM_ATTRIBUTE_CHARGES)
	registerEnum(ITEM_ATTRIBUTE_FLUIDTYPE)
	registerEnum(ITEM_ATTRIBUTE_DOORID)
	registerEnum(ITEM_ATTRIBUTE_DECAYTO)
	registerEnum(ITEM_ATTRIBUTE_WRAPID)
	registerEnum(ITEM_ATTRIBUTE_STOREITEM)
	registerEnum(ITEM_ATTRIBUTE_ATTACK_SPEED)
	registerEnum(ITEM_ATTRIBUTE_OPENCONTAINER)
	registerEnum(ITEM_ATTRIBUTE_TIER)

	registerEnum(ITEM_TYPE_DEPOT)
	registerEnum(ITEM_TYPE_MAILBOX)
	registerEnum(ITEM_TYPE_TRASHHOLDER)
	registerEnum(ITEM_TYPE_CONTAINER)
	registerEnum(ITEM_TYPE_DOOR)
	registerEnum(ITEM_TYPE_MAGICFIELD)
	registerEnum(ITEM_TYPE_TELEPORT)
	registerEnum(ITEM_TYPE_BED)
	registerEnum(ITEM_TYPE_KEY)
	registerEnum(ITEM_TYPE_RUNE)
	registerEnum(ITEM_TYPE_PODIUM)
	registerEnum(ITEM_TYPE_HIRELINGLAMP)
	registerEnum(ITEM_TYPE_REWARDCHEST)
	registerEnum(ITEM_TYPE_REWARDBAG)

	registerEnum(ITEM_GROUP_GROUND)
	registerEnum(ITEM_GROUP_CONTAINER)
	registerEnum(ITEM_GROUP_WEAPON)
	registerEnum(ITEM_GROUP_AMMUNITION)
	registerEnum(ITEM_GROUP_ARMOR)
	registerEnum(ITEM_GROUP_CHARGES)
	registerEnum(ITEM_GROUP_TELEPORT)
	registerEnum(ITEM_GROUP_MAGICFIELD)
	registerEnum(ITEM_GROUP_WRITEABLE)
	registerEnum(ITEM_GROUP_KEY)
	registerEnum(ITEM_GROUP_SPLASH)
	registerEnum(ITEM_GROUP_FLUID)
	registerEnum(ITEM_GROUP_DOOR)
	registerEnum(ITEM_GROUP_DEPRECATED)
	registerEnum(ITEM_GROUP_PODIUM)

	registerEnum(ITEM_BROWSEFIELD)

	registerEnum(ITEM_FIREFIELD_PVP_FULL)
	registerEnum(ITEM_FIREFIELD_PVP_MEDIUM)
	registerEnum(ITEM_FIREFIELD_PVP_SMALL)
	registerEnum(ITEM_FIREFIELD_PERSISTENT_FULL)
	registerEnum(ITEM_FIREFIELD_PERSISTENT_MEDIUM)
	registerEnum(ITEM_FIREFIELD_PERSISTENT_SMALL)
	registerEnum(ITEM_FIREFIELD_NOPVP)
	registerEnum(ITEM_POISONFIELD_PVP)
	registerEnum(ITEM_POISONFIELD_PERSISTENT)
	registerEnum(ITEM_POISONFIELD_NOPVP)
	registerEnum(ITEM_ENERGYFIELD_PVP)
	registerEnum(ITEM_ENERGYFIELD_PERSISTENT)
	registerEnum(ITEM_ENERGYFIELD_NOPVP)
	registerEnum(ITEM_MAGICWALL)
	registerEnum(ITEM_MAGICWALL_PERSISTENT)
	registerEnum(ITEM_MAGICWALL_SAFE)
	registerEnum(ITEM_WILDGROWTH)
	registerEnum(ITEM_WILDGROWTH_PERSISTENT)
	registerEnum(ITEM_WILDGROWTH_SAFE)

	registerEnum(ITEM_BAG)
	registerEnum(ITEM_SHOPPING_BAG)

	registerEnum(ITEM_GOLD_COIN)
	registerEnum(ITEM_PLATINUM_COIN)
	registerEnum(ITEM_CRYSTAL_COIN)
	registerEnum(ITEM_GOLD_POUCH)
	registerEnum(ITEM_STORE_COIN)

	registerEnum(ITEM_DEPOT)
	registerEnum(ITEM_LOCKER)
	registerEnum(ITEM_INBOX)
	registerEnum(ITEM_MARKET)
	registerEnum(ITEM_STORE_INBOX)
	registerEnum(ITEM_REWARD_CHEST)
	registerEnum(ITEM_REWARD_BAG)
	registerEnum(ITEM_FORGE_SMALL)
	registerEnum(ITEM_DEPOT_BOX_I)
	registerEnum(ITEM_DEPOT_BOX_II)
	registerEnum(ITEM_DEPOT_BOX_III)
	registerEnum(ITEM_DEPOT_BOX_IV)
	registerEnum(ITEM_DEPOT_BOX_V)
	registerEnum(ITEM_DEPOT_BOX_VI)
	registerEnum(ITEM_DEPOT_BOX_VII)
	registerEnum(ITEM_DEPOT_BOX_VIII)
	registerEnum(ITEM_DEPOT_BOX_IX)
	registerEnum(ITEM_DEPOT_BOX_X)
	registerEnum(ITEM_DEPOT_BOX_XI)
	registerEnum(ITEM_DEPOT_BOX_XII)
	registerEnum(ITEM_DEPOT_BOX_XIII)
	registerEnum(ITEM_DEPOT_BOX_XIV)
	registerEnum(ITEM_DEPOT_BOX_XV)
	registerEnum(ITEM_DEPOT_BOX_XVI)
	registerEnum(ITEM_DEPOT_BOX_XVII)
	registerEnum(ITEM_DEPOT_BOX_XVIII)
	registerEnum(ITEM_DEPOT_BOX_XIX)
	registerEnum(ITEM_DEPOT_BOX_XX)

	registerEnum(ITEM_MALE_CORPSE)
	registerEnum(ITEM_FEMALE_CORPSE)

	registerEnum(ITEM_FULLSPLASH)
	registerEnum(ITEM_SMALLSPLASH)

	registerEnum(ITEM_PARCEL)
	registerEnum(ITEM_LETTER)
	registerEnum(ITEM_LETTER_STAMPED)
	registerEnum(ITEM_LABEL)

	registerEnum(ITEM_AMULETOFLOSS)
	registerEnum(ITEM_DECORATION_KIT)
	registerEnum(ITEM_HIRELING_LAMP)
	
	registerEnum(ITEM_DOCUMENT_RO)

	registerEnum(WIELDINFO_NONE)
	registerEnum(WIELDINFO_LEVEL)
	registerEnum(WIELDINFO_MAGLV)
	registerEnum(WIELDINFO_VOCREQ)
	registerEnum(WIELDINFO_PREMIUM)

	registerEnum(PlayerFlag_CannotUseCombat)
	registerEnum(PlayerFlag_CannotAttackPlayer)
	registerEnum(PlayerFlag_CannotAttackMonster)
	registerEnum(PlayerFlag_CannotBeAttacked)
	registerEnum(PlayerFlag_CanConvinceAll)
	registerEnum(PlayerFlag_CanSummonAll)
	registerEnum(PlayerFlag_CanIllusionAll)
	registerEnum(PlayerFlag_CanSenseInvisibility)
	registerEnum(PlayerFlag_IgnoredByMonsters)
	registerEnum(PlayerFlag_NotGainInFight)
	registerEnum(PlayerFlag_HasInfiniteMana)
	registerEnum(PlayerFlag_HasInfiniteSoul)
	registerEnum(PlayerFlag_HasNoExhaustion)
	registerEnum(PlayerFlag_CannotUseSpells)
	registerEnum(PlayerFlag_CannotPickupItem)
	registerEnum(PlayerFlag_CanAlwaysLogin)
	registerEnum(PlayerFlag_CanBroadcast)
	registerEnum(PlayerFlag_CanEditHouses)
	registerEnum(PlayerFlag_CannotBeBanned)
	registerEnum(PlayerFlag_CannotBePushed)
	registerEnum(PlayerFlag_HasInfiniteCapacity)
	registerEnum(PlayerFlag_CanPushAllCreatures)
	registerEnum(PlayerFlag_CanTalkRedPrivate)
	registerEnum(PlayerFlag_CanTalkRedChannel)
	registerEnum(PlayerFlag_TalkOrangeHelpChannel)
	registerEnum(PlayerFlag_NotGainExperience)
	registerEnum(PlayerFlag_NotGainMana)
	registerEnum(PlayerFlag_NotGainHealth)
	registerEnum(PlayerFlag_NotGainSkill)
	registerEnum(PlayerFlag_SetMaxSpeed)
	registerEnum(PlayerFlag_SpecialVIP)
	registerEnum(PlayerFlag_NotGenerateLoot)
	registerEnum(PlayerFlag_CanTalkRedChannelAnonymous)
	registerEnum(PlayerFlag_IgnoreProtectionZone)
	registerEnum(PlayerFlag_IgnoreSpellCheck)
	registerEnum(PlayerFlag_IgnoreWeaponCheck)
	registerEnum(PlayerFlag_CannotBeMuted)
	registerEnum(PlayerFlag_IsAlwaysPremium)
	registerEnum(PlayerFlag_IgnoreYellCheck)
	registerEnum(PlayerFlag_IgnoreSendPrivateCheck)

	registerEnum(PODIUM_SHOW_PLATFORM)
	registerEnum(PODIUM_SHOW_OUTFIT)
	registerEnum(PODIUM_SHOW_MOUNT)

	registerEnum(PLAYERSEX_FEMALE)
	registerEnum(PLAYERSEX_MALE)

	registerEnum(REPORT_REASON_NAMEINAPPROPRIATE)
	registerEnum(REPORT_REASON_NAMEPOORFORMATTED)
	registerEnum(REPORT_REASON_NAMEADVERTISING)
	registerEnum(REPORT_REASON_NAMEUNFITTING)
	registerEnum(REPORT_REASON_NAMERULEVIOLATION)
	registerEnum(REPORT_REASON_INSULTINGSTATEMENT)
	registerEnum(REPORT_REASON_SPAMMING)
	registerEnum(REPORT_REASON_ADVERTISINGSTATEMENT)
	registerEnum(REPORT_REASON_UNFITTINGSTATEMENT)
	registerEnum(REPORT_REASON_LANGUAGESTATEMENT)
	registerEnum(REPORT_REASON_DISCLOSURE)
	registerEnum(REPORT_REASON_RULEVIOLATION)
	registerEnum(REPORT_REASON_STATEMENT_BUGABUSE)
	registerEnum(REPORT_REASON_UNOFFICIALSOFTWARE)
	registerEnum(REPORT_REASON_PRETENDING)
	registerEnum(REPORT_REASON_HARASSINGOWNERS)
	registerEnum(REPORT_REASON_FALSEINFO)
	registerEnum(REPORT_REASON_ACCOUNTSHARING)
	registerEnum(REPORT_REASON_STEALINGDATA)
	registerEnum(REPORT_REASON_SERVICEATTACKING)
	registerEnum(REPORT_REASON_SERVICEAGREEMENT)

	registerEnum(REPORT_TYPE_NAME)
	registerEnum(REPORT_TYPE_STATEMENT)
	registerEnum(REPORT_TYPE_BOT)

	registerEnum(VOCATION_NONE)

	registerEnum(SKILL_FIST)
	registerEnum(SKILL_CLUB)
	registerEnum(SKILL_SWORD)
	registerEnum(SKILL_AXE)
	registerEnum(SKILL_DISTANCE)
	registerEnum(SKILL_SHIELD)
	registerEnum(SKILL_FISHING)
	registerEnum(SKILL_MAGLEVEL)
	registerEnum(SKILL_LEVEL)

	registerEnum(SPECIALSKILL_CRITICALHITCHANCE)
	registerEnum(SPECIALSKILL_CRITICALHITAMOUNT)
	registerEnum(SPECIALSKILL_LIFELEECHCHANCE)
	registerEnum(SPECIALSKILL_LIFELEECHAMOUNT)
	registerEnum(SPECIALSKILL_MANALEECHCHANCE)
	registerEnum(SPECIALSKILL_MANALEECHAMOUNT)
	registerEnum(SPECIALSKILL_ONSLAUGHT)
	registerEnum(SPECIALSKILL_RUSE)
	registerEnum(SPECIALSKILL_MOMENTUM)

	registerEnum(STAT_MAXHITPOINTS)
	registerEnum(STAT_MAXMANAPOINTS)
	registerEnum(STAT_SOULPOINTS)
	registerEnum(STAT_MAGICPOINTS)
	registerEnum(STAT_CAPACITY)
	registerEnum(STAT_VIBRANCY)

	registerEnum(SKULL_NONE)
	registerEnum(SKULL_YELLOW)
	registerEnum(SKULL_GREEN)
	registerEnum(SKULL_WHITE)
	registerEnum(SKULL_RED)
	registerEnum(SKULL_BLACK)
	registerEnum(SKULL_ORANGE)

	registerEnum(FLUID_NONE)
	registerEnum(FLUID_WATER)
	registerEnum(FLUID_BLOOD)
	registerEnum(FLUID_BEER)
	registerEnum(FLUID_SLIME)
	registerEnum(FLUID_LEMONADE)
	registerEnum(FLUID_MILK)
	registerEnum(FLUID_MANA)
	registerEnum(FLUID_LIFE)
	registerEnum(FLUID_OIL)
	registerEnum(FLUID_URINE)
	registerEnum(FLUID_COCONUTMILK)
	registerEnum(FLUID_WINE)
	registerEnum(FLUID_MUD)
	registerEnum(FLUID_FRUITJUICE)
	registerEnum(FLUID_LAVA)
	registerEnum(FLUID_RUM)
	registerEnum(FLUID_SWAMP)
	registerEnum(FLUID_TEA)
	registerEnum(FLUID_MEAD)

	registerEnum(TALKTYPE_SAY)
	registerEnum(TALKTYPE_WHISPER)
	registerEnum(TALKTYPE_YELL)
	registerEnum(TALKTYPE_PRIVATE_FROM)
	registerEnum(TALKTYPE_PRIVATE_TO)
	registerEnum(TALKTYPE_CHANNEL_Y)
	registerEnum(TALKTYPE_CHANNEL_O)
	registerEnum(TALKTYPE_SPELL)
	registerEnum(TALKTYPE_PRIVATE_NP)
	registerEnum(TALKTYPE_PRIVATE_NP_CONSOLE)
	registerEnum(TALKTYPE_PRIVATE_PN)
	registerEnum(TALKTYPE_BROADCAST)
	registerEnum(TALKTYPE_CHANNEL_R1)
	registerEnum(TALKTYPE_PRIVATE_RED_FROM)
	registerEnum(TALKTYPE_PRIVATE_RED_TO)
	registerEnum(TALKTYPE_MONSTER_SAY)
	registerEnum(TALKTYPE_MONSTER_YELL)
	registerEnum(TALKTYPE_POTION)

	registerEnum(TEXTCOLOR_BLACK)
	registerEnum(TEXTCOLOR_BLUE)
	registerEnum(TEXTCOLOR_LIGHTGREEN)
	registerEnum(TEXTCOLOR_LIGHTBLUE)
	registerEnum(TEXTCOLOR_MAYABLUE)
	registerEnum(TEXTCOLOR_DARKRED)
	registerEnum(TEXTCOLOR_LIGHTGREY)
	registerEnum(TEXTCOLOR_DARKGREY)
	registerEnum(TEXTCOLOR_SKYBLUE)
	registerEnum(TEXTCOLOR_PURPLE)
	registerEnum(TEXTCOLOR_ELECTRICPURPLE)
	registerEnum(TEXTCOLOR_RED)
	registerEnum(TEXTCOLOR_PASTELRED)
	registerEnum(TEXTCOLOR_ORANGE)
	registerEnum(TEXTCOLOR_YELLOW)
	registerEnum(TEXTCOLOR_WHITE_EXP)
	registerEnum(TEXTCOLOR_NONE)

	registerEnum(TILESTATE_NONE)
	registerEnum(TILESTATE_PROTECTIONZONE)
	registerEnum(TILESTATE_NOPVPZONE)
	registerEnum(TILESTATE_NOLOGOUT)
	registerEnum(TILESTATE_PVPZONE)
	registerEnum(TILESTATE_FLOORCHANGE)
	registerEnum(TILESTATE_FLOORCHANGE_DOWN)
	registerEnum(TILESTATE_FLOORCHANGE_NORTH)
	registerEnum(TILESTATE_FLOORCHANGE_SOUTH)
	registerEnum(TILESTATE_FLOORCHANGE_EAST)
	registerEnum(TILESTATE_FLOORCHANGE_WEST)
	registerEnum(TILESTATE_TELEPORT)
	registerEnum(TILESTATE_MAGICFIELD)
	registerEnum(TILESTATE_MAILBOX)
	registerEnum(TILESTATE_TRASHHOLDER)
	registerEnum(TILESTATE_BED)
	registerEnum(TILESTATE_DEPOT)
	registerEnum(TILESTATE_BLOCKSOLID)
	registerEnum(TILESTATE_BLOCKPATH)
	registerEnum(TILESTATE_IMMOVABLEBLOCKSOLID)
	registerEnum(TILESTATE_IMMOVABLEBLOCKPATH)
	registerEnum(TILESTATE_IMMOVABLENOFIELDBLOCKPATH)
	registerEnum(TILESTATE_NOFIELDBLOCKPATH)
	registerEnum(TILESTATE_FLOORCHANGE_SOUTH_ALT)
	registerEnum(TILESTATE_FLOORCHANGE_EAST_ALT)
	registerEnum(TILESTATE_SUPPORTS_HANGABLE)

	registerEnum(WEAPON_NONE)
	registerEnum(WEAPON_SWORD)
	registerEnum(WEAPON_CLUB)
	registerEnum(WEAPON_AXE)
	registerEnum(WEAPON_SHIELD)
	registerEnum(WEAPON_DISTANCE)
	registerEnum(WEAPON_WAND)
	registerEnum(WEAPON_FIST)
	registerEnum(WEAPON_AMMO)
	registerEnum(WEAPON_QUIVER)

	registerEnum(WORLD_TYPE_NO_PVP)
	registerEnum(WORLD_TYPE_PVP)
	registerEnum(WORLD_TYPE_PVP_ENFORCED)

	// Use with container:addItem, container:addItemEx and possibly other functions.
	registerEnum(FLAG_NOLIMIT)
	registerEnum(FLAG_IGNOREBLOCKITEM)
	registerEnum(FLAG_IGNOREBLOCKCREATURE)
	registerEnum(FLAG_CHILDISOWNER)
	registerEnum(FLAG_PATHFINDING)
	registerEnum(FLAG_IGNOREFIELDDAMAGE)
	registerEnum(FLAG_IGNORENOTMOVEABLE)
	registerEnum(FLAG_IGNORENOTPICKUPABLE)
	registerEnum(FLAG_IGNOREAUTOSTACK)
	registerEnum(FLAG_IGNORESTOREATTR)

	// Use with itemType:getSlotPosition
	registerEnum(SLOTP_WHEREEVER)
	registerEnum(SLOTP_HEAD)
	registerEnum(SLOTP_NECKLACE)
	registerEnum(SLOTP_BACKPACK)
	registerEnum(SLOTP_ARMOR)
	registerEnum(SLOTP_RIGHT)
	registerEnum(SLOTP_LEFT)
	registerEnum(SLOTP_LEGS)
	registerEnum(SLOTP_FEET)
	registerEnum(SLOTP_RING)
	registerEnum(SLOTP_AMMO)
	registerEnum(SLOTP_DEPOT)
	registerEnum(SLOTP_TWO_HAND)

	// Use with combat functions
	registerEnum(ORIGIN_NONE)
	registerEnum(ORIGIN_CONDITION)
	registerEnum(ORIGIN_SPELL)
	registerEnum(ORIGIN_MELEE)
	registerEnum(ORIGIN_RANGED)
	registerEnum(ORIGIN_WAND)
	registerEnum(ORIGIN_REFLECT)
	registerEnum(ORIGIN_CONVERTED)

	// Use with house:getAccessList, house:setAccessList
	registerEnum(GUEST_LIST)
	registerEnum(SUBOWNER_LIST)

	// Use with npc:setSpeechBubble
	registerEnum(SPEECHBUBBLE_NONE)
	registerEnum(SPEECHBUBBLE_NORMAL)
	registerEnum(SPEECHBUBBLE_TRADE)
	registerEnum(SPEECHBUBBLE_QUEST)
	registerEnum(SPEECHBUBBLE_COMPASS)
	registerEnum(SPEECHBUBBLE_NORMAL2)
	registerEnum(SPEECHBUBBLE_NORMAL3)
	registerEnum(SPEECHBUBBLE_HIRELING)

	// Use with player:addMapMark
	registerEnum(MAPMARK_TICK)
	registerEnum(MAPMARK_QUESTION)
	registerEnum(MAPMARK_EXCLAMATION)
	registerEnum(MAPMARK_STAR)
	registerEnum(MAPMARK_CROSS)
	registerEnum(MAPMARK_TEMPLE)
	registerEnum(MAPMARK_KISS)
	registerEnum(MAPMARK_SHOVEL)
	registerEnum(MAPMARK_SWORD)
	registerEnum(MAPMARK_FLAG)
	registerEnum(MAPMARK_LOCK)
	registerEnum(MAPMARK_BAG)
	registerEnum(MAPMARK_SKULL)
	registerEnum(MAPMARK_DOLLAR)
	registerEnum(MAPMARK_REDNORTH)
	registerEnum(MAPMARK_REDSOUTH)
	registerEnum(MAPMARK_REDEAST)
	registerEnum(MAPMARK_REDWEST)
	registerEnum(MAPMARK_GREENNORTH)
	registerEnum(MAPMARK_GREENSOUTH)

	// Use with Game.getReturnMessage
	registerEnum(RETURNVALUE_NOERROR)
	registerEnum(RETURNVALUE_NOTPOSSIBLE)
	registerEnum(RETURNVALUE_NOTENOUGHROOM)
	registerEnum(RETURNVALUE_PLAYERISPZLOCKED)
	registerEnum(RETURNVALUE_PLAYERISNOTINVITED)
	registerEnum(RETURNVALUE_CANNOTTHROW)
	registerEnum(RETURNVALUE_THEREISNOWAY)
	registerEnum(RETURNVALUE_DESTINATIONOUTOFREACH)
	registerEnum(RETURNVALUE_CREATUREBLOCK)
	registerEnum(RETURNVALUE_NOTMOVEABLE)
	registerEnum(RETURNVALUE_DROPTWOHANDEDITEM)
	registerEnum(RETURNVALUE_BOTHHANDSNEEDTOBEFREE)
	registerEnum(RETURNVALUE_CANONLYUSEONEWEAPON)
	registerEnum(RETURNVALUE_NEEDEXCHANGE)
	registerEnum(RETURNVALUE_CANNOTBEDRESSED)
	registerEnum(RETURNVALUE_PUTTHISOBJECTINYOURHAND)
	registerEnum(RETURNVALUE_PUTTHISOBJECTINBOTHHANDS)
	registerEnum(RETURNVALUE_TOOFARAWAY)
	registerEnum(RETURNVALUE_FIRSTGODOWNSTAIRS)
	registerEnum(RETURNVALUE_FIRSTGOUPSTAIRS)
	registerEnum(RETURNVALUE_CONTAINERNOTENOUGHROOM)
	registerEnum(RETURNVALUE_NOTENOUGHCAPACITY)
	registerEnum(RETURNVALUE_CANNOTPICKUP)
	registerEnum(RETURNVALUE_THISISIMPOSSIBLE)
	registerEnum(RETURNVALUE_DEPOTISFULL)
	registerEnum(RETURNVALUE_CREATUREDOESNOTEXIST)
	registerEnum(RETURNVALUE_CANNOTUSETHISOBJECT)
	registerEnum(RETURNVALUE_PLAYERWITHTHISNAMEISNOTONLINE)
	registerEnum(RETURNVALUE_NOTREQUIREDLEVELTOUSERUNE)
	registerEnum(RETURNVALUE_YOUAREALREADYTRADING)
	registerEnum(RETURNVALUE_THISPLAYERISALREADYTRADING)
	registerEnum(RETURNVALUE_YOUMAYNOTLOGOUTDURINGAFIGHT)
	registerEnum(RETURNVALUE_DIRECTPLAYERSHOOT)
	registerEnum(RETURNVALUE_NOTENOUGHLEVEL)
	registerEnum(RETURNVALUE_NOTENOUGHMAGICLEVEL)
	registerEnum(RETURNVALUE_NOTENOUGHMANA)
	registerEnum(RETURNVALUE_NOTENOUGHSOUL)
	registerEnum(RETURNVALUE_YOUAREEXHAUSTED)
	registerEnum(RETURNVALUE_YOUCANNOTUSEOBJECTSTHATFAST)
	registerEnum(RETURNVALUE_PLAYERISNOTREACHABLE)
	registerEnum(RETURNVALUE_CANONLYUSETHISRUNEONCREATURES)
	registerEnum(RETURNVALUE_ACTIONNOTPERMITTEDINPROTECTIONZONE)
	registerEnum(RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER)
	registerEnum(RETURNVALUE_YOUMAYNOTATTACKAPERSONINPROTECTIONZONE)
	registerEnum(RETURNVALUE_YOUMAYNOTATTACKAPERSONWHILEINPROTECTIONZONE)
	registerEnum(RETURNVALUE_YOUMAYNOTATTACKTHISCREATURE)
	registerEnum(RETURNVALUE_YOUCANONLYUSEITONCREATURES)
	registerEnum(RETURNVALUE_CREATUREISNOTREACHABLE)
	registerEnum(RETURNVALUE_TURNSECUREMODETOATTACKUNMARKEDPLAYERS)
	registerEnum(RETURNVALUE_YOUNEEDPREMIUMACCOUNT)
	registerEnum(RETURNVALUE_YOUNEEDTOLEARNTHISSPELL)
	registerEnum(RETURNVALUE_YOURVOCATIONCANNOTUSETHISSPELL)
	registerEnum(RETURNVALUE_YOUNEEDAWEAPONTOUSETHISSPELL)
	registerEnum(RETURNVALUE_PLAYERISPZLOCKEDLEAVEPVPZONE)
	registerEnum(RETURNVALUE_PLAYERISPZLOCKEDENTERPVPZONE)
	registerEnum(RETURNVALUE_ACTIONNOTPERMITTEDINANOPVPZONE)
	registerEnum(RETURNVALUE_YOUCANNOTLOGOUTHERE)
	registerEnum(RETURNVALUE_YOUNEEDAMAGICITEMTOCASTSPELL)
	registerEnum(RETURNVALUE_CANNOTCONJUREITEMHERE)
	registerEnum(RETURNVALUE_YOUNEEDTOSPLITYOURSPEARS)
	registerEnum(RETURNVALUE_NAMEISTOOAMBIGUOUS)
	registerEnum(RETURNVALUE_CANONLYUSEONESHIELD)
	registerEnum(RETURNVALUE_NOPARTYMEMBERSINRANGE)
	registerEnum(RETURNVALUE_YOUARENOTTHEOWNER)
	registerEnum(RETURNVALUE_NOSUCHRAIDEXISTS)
	registerEnum(RETURNVALUE_ANOTHERRAIDISALREADYEXECUTING)
	registerEnum(RETURNVALUE_TRADEPLAYERFARAWAY)
	registerEnum(RETURNVALUE_YOUDONTOWNTHISHOUSE)
	registerEnum(RETURNVALUE_TRADEPLAYERALREADYOWNSAHOUSE)
	registerEnum(RETURNVALUE_TRADEPLAYERHIGHESTBIDDER)
	registerEnum(RETURNVALUE_YOUCANNOTTRADETHISHOUSE)
	registerEnum(RETURNVALUE_YOUDONTHAVEREQUIREDPROFESSION)
	registerEnum(RETURNVALUE_CANNOTMOVEITEMISNOTSTOREITEM)
	registerEnum(RETURNVALUE_ITEMCANNOTBEMOVEDTHERE)
	registerEnum(RETURNVALUE_YOUCANNOTUSETHISBED)
	registerEnum(RETURNVALUE_YOUCANONLYUNWRAPINOWNHOUSE)
	registerEnum(RETURNVALUE_SCRIPT)

	registerEnum(RELOAD_TYPE_ALL)
	registerEnum(RELOAD_TYPE_ACTIONS)
	registerEnum(RELOAD_TYPE_CHAT)
	registerEnum(RELOAD_TYPE_CONFIG)
	registerEnum(RELOAD_TYPE_CREATURESCRIPTS)
	registerEnum(RELOAD_TYPE_EVENTS)
	registerEnum(RELOAD_TYPE_GLOBAL)
	registerEnum(RELOAD_TYPE_GLOBALEVENTS)
	registerEnum(RELOAD_TYPE_ITEMS)
	registerEnum(RELOAD_TYPE_MONSTERS)
	registerEnum(RELOAD_TYPE_MOUNTS)
	registerEnum(RELOAD_TYPE_MOVEMENTS)
	registerEnum(RELOAD_TYPE_NPCS)
	registerEnum(RELOAD_TYPE_QUESTS)
	registerEnum(RELOAD_TYPE_RAIDS)
	registerEnum(RELOAD_TYPE_SCRIPTS)
	registerEnum(RELOAD_TYPE_SPELLS)
	registerEnum(RELOAD_TYPE_TALKACTIONS)
	registerEnum(RELOAD_TYPE_WEAPONS)

	registerEnum(LOOT_TYPE_NONE)
	registerEnum(LOOT_TYPE_ARMOR)
	registerEnum(LOOT_TYPE_AMULET)
	registerEnum(LOOT_TYPE_BOOTS)
	registerEnum(LOOT_TYPE_CONTAINER)
	registerEnum(LOOT_TYPE_DECORATION)
	registerEnum(LOOT_TYPE_FOOD)
	registerEnum(LOOT_TYPE_HELMET)
	registerEnum(LOOT_TYPE_LEGS)
	registerEnum(LOOT_TYPE_OTHER)
	registerEnum(LOOT_TYPE_POTION)
	registerEnum(LOOT_TYPE_RING)
	registerEnum(LOOT_TYPE_RUNE)
	registerEnum(LOOT_TYPE_SHIELD)
	registerEnum(LOOT_TYPE_TOOL)
	registerEnum(LOOT_TYPE_VALUABLE)
	registerEnum(LOOT_TYPE_AMMO)
	registerEnum(LOOT_TYPE_AXE)
	registerEnum(LOOT_TYPE_CLUB)
	registerEnum(LOOT_TYPE_DISTANCE)
	registerEnum(LOOT_TYPE_SWORD)
	registerEnum(LOOT_TYPE_WAND)
	registerEnum(LOOT_TYPE_CREATURE_PRODUCT)
	registerEnum(LOOT_TYPE_QUIVER)
	registerEnum(LOOT_TYPE_STASH)
	registerEnum(LOOT_TYPE_GOLD)
	registerEnum(LOOT_TYPE_UNASSIGNED)
	registerEnum(LOOT_TYPE_LAST)

	registerEnum(ACCOUNTRESOURCE_STORE_COINS)
	registerEnum(ACCOUNTRESOURCE_STORE_COINS_NONTRANSFERABLE)
	registerEnum(ACCOUNTRESOURCE_STORE_COINS_RESERVED)
	registerEnum(ACCOUNTRESOURCE_TOURNAMENT_COINS)

	registerEnum(RESOURCE_BANK_BALANCE)
	registerEnum(RESOURCE_GOLD_EQUIPPED)
	registerEnum(RESOURCE_PREY_WILDCARDS)
	registerEnum(RESOURCE_DAILYREWARD_STREAK)
	registerEnum(RESOURCE_DAILYREWARD_JOKERS)
	registerEnum(RESOURCE_CHARM_POINTS)
	registerEnum(RESOURCE_TOURNAMENT_COINS)
	registerEnum(RESOURCE_FORGE_DUST)
	registerEnum(RESOURCE_FORGE_SLIVERS)
	registerEnum(RESOURCE_FORGE_CORES)

	registerEnum(ZONE_PROTECTION)
	registerEnum(ZONE_NOPVP)
	registerEnum(ZONE_PVP)
	registerEnum(ZONE_NOLOGOUT)
	registerEnum(ZONE_NORMAL)

	registerEnum(MAX_LOOTCHANCE)

	registerEnum(SPELL_INSTANT)
	registerEnum(SPELL_RUNE)

	registerEnum(SPELLGROUP_NONE)
	registerEnum(SPELLGROUP_ATTACK)
	registerEnum(SPELLGROUP_HEALING)
	registerEnum(SPELLGROUP_SUPPORT)
	registerEnum(SPELLGROUP_SPECIAL)
	registerEnum(SPELLGROUP_CONJURE)
	registerEnum(SPELLGROUP_CRIPPLING)
	registerEnum(SPELLGROUP_FOCUS)
	registerEnum(SPELLGROUP_ULTIMATE)

	registerEnum(MONSTERS_EVENT_THINK)
	registerEnum(MONSTERS_EVENT_APPEAR)
	registerEnum(MONSTERS_EVENT_DISAPPEAR)
	registerEnum(MONSTERS_EVENT_MOVE)
	registerEnum(MONSTERS_EVENT_SAY)

	registerEnum(DECAYING_FALSE)
	registerEnum(DECAYING_TRUE)
	registerEnum(DECAYING_PENDING)

	registerEnum(FORGE_ACTION_FUSION)
	registerEnum(FORGE_ACTION_TRANSFER)
	registerEnum(FORGE_ACTION_DUSTTOSLIVERS)
	registerEnum(FORGE_ACTION_SLIVERSTOCORES)
	registerEnum(FORGE_ACTION_INCREASELIMIT)

	registerEnum(INSPECTION_ITEM_NORMAL)
	registerEnum(INSPECTION_ITEM_NPCTRADE)
	registerEnum(INSPECTION_ITEM_PLAYERTRADE)
	registerEnum(INSPECTION_ITEM_CYCLOPEDIA)

	registerEnum(PLAYERTAB_BASEINFORMATION)
	registerEnum(PLAYERTAB_GENERAL)
	registerEnum(PLAYERTAB_COMBAT)
	registerEnum(PLAYERTAB_DEATHS)
	registerEnum(PLAYERTAB_PVPKILLS)
	registerEnum(PLAYERTAB_ACHIEVEMENTS)
	registerEnum(PLAYERTAB_INVENTORY)
	registerEnum(PLAYERTAB_COSMETICS)
	registerEnum(PLAYERTAB_STORE)
	registerEnum(PLAYERTAB_INSPECTION)
	registerEnum(PLAYERTAB_BADGES)
	registerEnum(PLAYERTAB_TITLES)

	// Imbuements system
	registerEnum(IMBUEMENT_NONE)
	registerEnum(IMBUEMENT_CRIT_1)
	registerEnum(IMBUEMENT_CRIT_2)
	registerEnum(IMBUEMENT_CRIT_3)
	registerEnum(IMBUEMENT_DAMAGE_DEATH_1)
	registerEnum(IMBUEMENT_DAMAGE_DEATH_2)
	registerEnum(IMBUEMENT_DAMAGE_DEATH_3)
	registerEnum(IMBUEMENT_DAMAGE_EARTH_1)
	registerEnum(IMBUEMENT_DAMAGE_EARTH_2)
	registerEnum(IMBUEMENT_DAMAGE_EARTH_3)
	registerEnum(IMBUEMENT_DAMAGE_ENERGY_1)
	registerEnum(IMBUEMENT_DAMAGE_ENERGY_2)
	registerEnum(IMBUEMENT_DAMAGE_ENERGY_3)
	registerEnum(IMBUEMENT_DAMAGE_FIRE_1)
	registerEnum(IMBUEMENT_DAMAGE_FIRE_2)
	registerEnum(IMBUEMENT_DAMAGE_FIRE_3)
	registerEnum(IMBUEMENT_DAMAGE_HOLY_1)
	registerEnum(IMBUEMENT_DAMAGE_HOLY_2)
	registerEnum(IMBUEMENT_DAMAGE_HOLY_3)
	registerEnum(IMBUEMENT_DAMAGE_ICE_1)
	registerEnum(IMBUEMENT_DAMAGE_ICE_2)
	registerEnum(IMBUEMENT_DAMAGE_ICE_3)
	registerEnum(IMBUEMENT_DAMAGE_PHYSICAL_1)
	registerEnum(IMBUEMENT_DAMAGE_PHYSICAL_2)
	registerEnum(IMBUEMENT_DAMAGE_PHYSICAL_3)
	registerEnum(IMBUEMENT_PROTECTION_DEATH_1)
	registerEnum(IMBUEMENT_PROTECTION_DEATH_2)
	registerEnum(IMBUEMENT_PROTECTION_DEATH_3)
	registerEnum(IMBUEMENT_PROTECTION_EARTH_1)
	registerEnum(IMBUEMENT_PROTECTION_EARTH_2)
	registerEnum(IMBUEMENT_PROTECTION_EARTH_3)
	registerEnum(IMBUEMENT_PROTECTION_ENERGY_1)
	registerEnum(IMBUEMENT_PROTECTION_ENERGY_2)
	registerEnum(IMBUEMENT_PROTECTION_ENERGY_3)
	registerEnum(IMBUEMENT_PROTECTION_FIRE_1)
	registerEnum(IMBUEMENT_PROTECTION_FIRE_2)
	registerEnum(IMBUEMENT_PROTECTION_FIRE_3)
	registerEnum(IMBUEMENT_PROTECTION_HOLY_1)
	registerEnum(IMBUEMENT_PROTECTION_HOLY_2)
	registerEnum(IMBUEMENT_PROTECTION_HOLY_3)
	registerEnum(IMBUEMENT_PROTECTION_ICE_1)
	registerEnum(IMBUEMENT_PROTECTION_ICE_2)
	registerEnum(IMBUEMENT_PROTECTION_ICE_3)
	registerEnum(IMBUEMENT_PROTECTION_PHYSICAL_1)
	registerEnum(IMBUEMENT_PROTECTION_PHYSICAL_2)
	registerEnum(IMBUEMENT_PROTECTION_PHYSICAL_3)
	registerEnum(IMBUEMENT_LEECH_LIFE_1)
	registerEnum(IMBUEMENT_LEECH_LIFE_2)
	registerEnum(IMBUEMENT_LEECH_LIFE_3)
	registerEnum(IMBUEMENT_LEECH_MANA_1)
	registerEnum(IMBUEMENT_LEECH_MANA_2)
	registerEnum(IMBUEMENT_LEECH_MANA_3)
	registerEnum(IMBUEMENT_BOOST_AXE_1)
	registerEnum(IMBUEMENT_BOOST_AXE_2)
	registerEnum(IMBUEMENT_BOOST_AXE_3)
	registerEnum(IMBUEMENT_BOOST_CLUB_1)
	registerEnum(IMBUEMENT_BOOST_CLUB_2)
	registerEnum(IMBUEMENT_BOOST_CLUB_3)
	registerEnum(IMBUEMENT_BOOST_DISTANCE_1)
	registerEnum(IMBUEMENT_BOOST_DISTANCE_2)
	registerEnum(IMBUEMENT_BOOST_DISTANCE_3)
	registerEnum(IMBUEMENT_BOOST_FIST_1)
	registerEnum(IMBUEMENT_BOOST_FIST_2)
	registerEnum(IMBUEMENT_BOOST_FIST_3)
	registerEnum(IMBUEMENT_BOOST_MAGIC_1)
	registerEnum(IMBUEMENT_BOOST_MAGIC_2)
	registerEnum(IMBUEMENT_BOOST_MAGIC_3)
	registerEnum(IMBUEMENT_BOOST_SHIELD_1)
	registerEnum(IMBUEMENT_BOOST_SHIELD_2)
	registerEnum(IMBUEMENT_BOOST_SHIELD_3)
	registerEnum(IMBUEMENT_BOOST_SWORD_1)
	registerEnum(IMBUEMENT_BOOST_SWORD_2)
	registerEnum(IMBUEMENT_BOOST_SWORD_3)
	registerEnum(IMBUEMENT_BOOST_SPEED_1)
	registerEnum(IMBUEMENT_BOOST_SPEED_2)
	registerEnum(IMBUEMENT_BOOST_SPEED_3)
	registerEnum(IMBUEMENT_BOOST_CAPACITY_1)
	registerEnum(IMBUEMENT_BOOST_CAPACITY_2)
	registerEnum(IMBUEMENT_BOOST_CAPACITY_3)
	registerEnum(IMBUEMENT_DEFLECT_PARALYZE_1)
	registerEnum(IMBUEMENT_DEFLECT_PARALYZE_2)
	registerEnum(IMBUEMENT_DEFLECT_PARALYZE_3)
	registerEnum(IMBUEMENT_ERROR)

	registerEnum(IMBUING_TYPE_NONE)
	registerEnum(IMBUING_TYPE_CRIT)
	registerEnum(IMBUING_TYPE_LEECH_MANA)
	registerEnum(IMBUING_TYPE_LEECH_HP)
	registerEnum(IMBUING_TYPE_DAMAGE)
	registerEnum(IMBUING_TYPE_PROTECTION)
	registerEnum(IMBUING_TYPE_SKILLBOOST)
	registerEnum(IMBUING_TYPE_SPEED)
	registerEnum(IMBUING_TYPE_CAPACITY)
	registerEnum(IMBUING_TYPE_DEFLECT_PARALYZE)
	registerEnum(IMBUING_TYPE_SCRIPT)

	// _G
	registerGlobalVariable("INDEX_WHEREEVER", INDEX_WHEREEVER);
	registerGlobalBoolean("VIRTUAL_PARENT", true);

	registerGlobalMethod("isType", LuaScriptInterface::luaIsType);
	registerGlobalMethod("rawgetmetatable", LuaScriptInterface::luaRawGetMetatable);

	// configKeys
	registerTable("configKeys");

	// boolean keys
	registerEnumIn("configKeys", ConfigManager::ALLOW_CHANGEOUTFIT)
	registerEnumIn("configKeys", ConfigManager::ONE_PLAYER_ON_ACCOUNT)
	registerEnumIn("configKeys", ConfigManager::AIMBOT_HOTKEY_ENABLED)
	registerEnumIn("configKeys", ConfigManager::REMOVE_RUNE_CHARGES)
	registerEnumIn("configKeys", ConfigManager::REMOVE_WEAPON_AMMO)
	registerEnumIn("configKeys", ConfigManager::REMOVE_WEAPON_CHARGES)
	registerEnumIn("configKeys", ConfigManager::REMOVE_POTION_CHARGES)
	registerEnumIn("configKeys", ConfigManager::EXPERIENCE_FROM_PLAYERS)
	registerEnumIn("configKeys", ConfigManager::FREE_PREMIUM)
	registerEnumIn("configKeys", ConfigManager::REPLACE_KICK_ON_LOGIN)
	registerEnumIn("configKeys", ConfigManager::ALLOW_CLONES)
	registerEnumIn("configKeys", ConfigManager::BIND_ONLY_GLOBAL_ADDRESS)
	registerEnumIn("configKeys", ConfigManager::OPTIMIZE_DATABASE)
	registerEnumIn("configKeys", ConfigManager::MARKET_PREMIUM)
	registerEnumIn("configKeys", ConfigManager::EMOTE_SPELLS)
	registerEnumIn("configKeys", ConfigManager::STAMINA_SYSTEM)
	registerEnumIn("configKeys", ConfigManager::WARN_UNSAFE_SCRIPTS)
	registerEnumIn("configKeys", ConfigManager::CONVERT_UNSAFE_SCRIPTS)
	registerEnumIn("configKeys", ConfigManager::CLASSIC_EQUIPMENT_SLOTS)
	registerEnumIn("configKeys", ConfigManager::CLASSIC_ATTACK_SPEED)
	registerEnumIn("configKeys", ConfigManager::SERVER_SAVE_NOTIFY_MESSAGE)
	registerEnumIn("configKeys", ConfigManager::SERVER_SAVE_NOTIFY_DURATION)
	registerEnumIn("configKeys", ConfigManager::SERVER_SAVE_CLEAN_MAP)
	registerEnumIn("configKeys", ConfigManager::SERVER_SAVE_CLOSE)
	registerEnumIn("configKeys", ConfigManager::SERVER_SAVE_SHUTDOWN)
	registerEnumIn("configKeys", ConfigManager::ONLINE_OFFLINE_CHARLIST)

	// string keys
	registerEnumIn("configKeys", ConfigManager::MAP_NAME)
	registerEnumIn("configKeys", ConfigManager::HOUSE_RENT_PERIOD)
	registerEnumIn("configKeys", ConfigManager::SERVER_NAME)
	registerEnumIn("configKeys", ConfigManager::OWNER_NAME)
	registerEnumIn("configKeys", ConfigManager::OWNER_EMAIL)
	registerEnumIn("configKeys", ConfigManager::URL)
	registerEnumIn("configKeys", ConfigManager::LOCATION)
	registerEnumIn("configKeys", ConfigManager::IP)
	registerEnumIn("configKeys", ConfigManager::MOTD)
	registerEnumIn("configKeys", ConfigManager::WORLD_TYPE)
	registerEnumIn("configKeys", ConfigManager::MYSQL_HOST)
	registerEnumIn("configKeys", ConfigManager::MYSQL_USER)
	registerEnumIn("configKeys", ConfigManager::MYSQL_PASS)
	registerEnumIn("configKeys", ConfigManager::MYSQL_DB)
	registerEnumIn("configKeys", ConfigManager::MYSQL_SOCK)
	registerEnumIn("configKeys", ConfigManager::DEFAULT_PRIORITY)
	registerEnumIn("configKeys", ConfigManager::MAP_AUTHOR)

	// integer keys
	registerEnumIn("configKeys", ConfigManager::SQL_PORT)
	registerEnumIn("configKeys", ConfigManager::MAX_PLAYERS)
	registerEnumIn("configKeys", ConfigManager::PZ_LOCKED)
	registerEnumIn("configKeys", ConfigManager::DEFAULT_DESPAWNRANGE)
	registerEnumIn("configKeys", ConfigManager::DEFAULT_DESPAWNRADIUS)
	registerEnumIn("configKeys", ConfigManager::DEFAULT_WALKTOSPAWNRADIUS)
	registerEnumIn("configKeys", ConfigManager::REMOVE_ON_DESPAWN)
	registerEnumIn("configKeys", ConfigManager::RATE_EXPERIENCE)
	registerEnumIn("configKeys", ConfigManager::RATE_SKILL)
	registerEnumIn("configKeys", ConfigManager::RATE_LOOT)
	registerEnumIn("configKeys", ConfigManager::RATE_MAGIC)
	registerEnumIn("configKeys", ConfigManager::RATE_SPAWN)
	registerEnumIn("configKeys", ConfigManager::HOUSE_PRICE)
	registerEnumIn("configKeys", ConfigManager::KILLS_TO_RED)
	registerEnumIn("configKeys", ConfigManager::KILLS_TO_BLACK)
	registerEnumIn("configKeys", ConfigManager::MAX_MESSAGEBUFFER)
	registerEnumIn("configKeys", ConfigManager::ACTIONS_DELAY_INTERVAL)
	registerEnumIn("configKeys", ConfigManager::EX_ACTIONS_DELAY_INTERVAL)
	registerEnumIn("configKeys", ConfigManager::KICK_AFTER_MINUTES)
	registerEnumIn("configKeys", ConfigManager::PROTECTION_LEVEL)
	registerEnumIn("configKeys", ConfigManager::DEATH_LOSE_PERCENT)
	registerEnumIn("configKeys", ConfigManager::STATUSQUERY_TIMEOUT)
	registerEnumIn("configKeys", ConfigManager::FRAG_TIME)
	registerEnumIn("configKeys", ConfigManager::WHITE_SKULL_TIME)
	registerEnumIn("configKeys", ConfigManager::GAME_PORT)
	registerEnumIn("configKeys", ConfigManager::LOGIN_PORT)
	registerEnumIn("configKeys", ConfigManager::STATUS_PORT)
	registerEnumIn("configKeys", ConfigManager::STAIRHOP_DELAY)
	registerEnumIn("configKeys", ConfigManager::MARKET_OFFER_DURATION)
	registerEnumIn("configKeys", ConfigManager::CHECK_EXPIRED_MARKET_OFFERS_EACH_MINUTES)
	registerEnumIn("configKeys", ConfigManager::MAX_MARKET_OFFERS_AT_A_TIME_PER_PLAYER)
	registerEnumIn("configKeys", ConfigManager::EXP_FROM_PLAYERS_LEVEL_RANGE)
	registerEnumIn("configKeys", ConfigManager::MAX_PACKETS_PER_SECOND)
	registerEnumIn("configKeys", ConfigManager::PLAYER_CONSOLE_LOGS)
	registerEnumIn("configKeys", ConfigManager::TWO_FACTOR_AUTH)
	registerEnumIn("configKeys", ConfigManager::EXP_ANALYSER_SEND_TRUE_RAW_EXP)
	registerEnumIn("configKeys", ConfigManager::MIN_MARKET_FEE)
	registerEnumIn("configKeys", ConfigManager::MAX_MARKET_FEE)
	registerEnumIn("configKeys", ConfigManager::REWARD_BAG_DURATION)

	// os
	registerMethod("os", "mtime", LuaScriptInterface::luaSystemTime);

	// table
	registerMethod("table", "create", LuaScriptInterface::luaTableCreate);
	registerMethod("table", "pack", LuaScriptInterface::luaTablePack);

	// Game
	registerTable("Game");

	registerMethod("Game", "getSpectators", LuaScriptInterface::luaGameGetSpectators);
	registerMethod("Game", "getPlayers", LuaScriptInterface::luaGameGetPlayers);
	registerMethod("Game", "getMonsterIds", LuaScriptInterface::luaGameGetMonsterIds);
	registerMethod("Game", "loadMap", LuaScriptInterface::luaGameLoadMap);

	registerMethod("Game", "getExperienceStage", LuaScriptInterface::luaGameGetExperienceStage);
	registerMethod("Game", "getExperienceStages", LuaScriptInterface::luaGameGetExperienceStages);
	registerMethod("Game", "getExperienceForLevel", LuaScriptInterface::luaGameGetExperienceForLevel);
	registerMethod("Game", "getMonsterCount", LuaScriptInterface::luaGameGetMonsterCount);
	registerMethod("Game", "getPlayerCount", LuaScriptInterface::luaGameGetPlayerCount);
	registerMethod("Game", "getNpcCount", LuaScriptInterface::luaGameGetNpcCount);
	registerMethod("Game", "getDepotBoxCount", LuaScriptInterface::luaGameGetDepotBoxCount);
	registerMethod("Game", "getMonsterTypes", LuaScriptInterface::luaGameGetMonsterTypes);
	registerMethod("Game", "getMountIdByLookType", LuaScriptInterface::luaGameGetMountIdByLookType);
	registerMethod("Game", "getCurrencyItems", LuaScriptInterface::luaGameGetCurrencyItems);
	registerMethod("Game", "getItemTypeByClientId", LuaScriptInterface::luaGameGetItemTypeByClientId);

	registerMethod("Game", "getTowns", LuaScriptInterface::luaGameGetTowns);
	registerMethod("Game", "getHouses", LuaScriptInterface::luaGameGetHouses);
	registerMethod("Game", "getOutfits", LuaScriptInterface::luaGameGetOutfits);
	registerMethod("Game", "getMounts", LuaScriptInterface::luaGameGetMounts);
	registerMethod("Game", "getFamiliars", LuaScriptInterface::luaGameGetFamiliars);
	registerMethod("Game", "getFamiliarById", LuaScriptInterface::luaGameGetFamiliarById);
	registerMethod("Game", "getInstantSpells", LuaScriptInterface::luaGameGetInstantSpells);
	registerMethod("Game", "getRuneSpells", LuaScriptInterface::luaGameGetRuneSpells);
	registerMethod("Game", "getVocations", LuaScriptInterface::luaGameGetVocations);

	registerMethod("Game", "getGameState", LuaScriptInterface::luaGameGetGameState);
	registerMethod("Game", "setGameState", LuaScriptInterface::luaGameSetGameState);

	registerMethod("Game", "getWorldType", LuaScriptInterface::luaGameGetWorldType);
	registerMethod("Game", "setWorldType", LuaScriptInterface::luaGameSetWorldType);

	registerMethod("Game", "getItemAttributeByName", LuaScriptInterface::luaGameGetItemAttributeByName);
	registerMethod("Game", "getReturnMessage", LuaScriptInterface::luaGameGetReturnMessage);

	registerMethod("Game", "createItem", LuaScriptInterface::luaGameCreateItem);
	registerMethod("Game", "createContainer", LuaScriptInterface::luaGameCreateContainer);
	registerMethod("Game", "createMonster", LuaScriptInterface::luaGameCreateMonster);
	registerMethod("Game", "createNpc", LuaScriptInterface::luaGameCreateNpc);
	registerMethod("Game", "createTile", LuaScriptInterface::luaGameCreateTile);
	registerMethod("Game", "createMonsterType", LuaScriptInterface::luaGameCreateMonsterType);

	registerMethod("Game", "startRaid", LuaScriptInterface::luaGameStartRaid);

	registerMethod("Game", "getClientVersion", LuaScriptInterface::luaGameGetClientVersion);

	registerMethod("Game", "reload", LuaScriptInterface::luaGameReload);

	registerMethod("Game", "getAccountStorageValue", LuaScriptInterface::luaGameGetAccountStorageValue);
	registerMethod("Game", "setAccountStorageValue", LuaScriptInterface::luaGameSetAccountStorageValue);
	registerMethod("Game", "saveAccountStorageValues", LuaScriptInterface::luaGameSaveAccountStorageValues);

	registerMethod("Game", "sendConsoleMessage", LuaScriptInterface::luaGameSendConsoleMessage);
	registerMethod("Game", "getLastConsoleMessage", LuaScriptInterface::luaGameGetLastConsoleMessage);

	registerMethod("Game", "playerHirelingFeatures", LuaScriptInterface::luaGamePlayerHirelingFeatures);

	registerMethod("Game", "addRewardByPlayerId", LuaScriptInterface::luaGameAddRewardByPlayerId);
	registerMethod("Game", "getNextRewardId", LuaScriptInterface::luaGameGetNextRewardId);

	// Variant
	registerClass("Variant", "", LuaScriptInterface::luaVariantCreate);

	registerMethod("Variant", "getNumber", LuaScriptInterface::luaVariantGetNumber);
	registerMethod("Variant", "getString", LuaScriptInterface::luaVariantGetString);
	registerMethod("Variant", "getPosition", LuaScriptInterface::luaVariantGetPosition);

	// Position
	registerClass("Position", "", LuaScriptInterface::luaPositionCreate);
	registerMetaMethod("Position", "__add", LuaScriptInterface::luaPositionAdd);
	registerMetaMethod("Position", "__sub", LuaScriptInterface::luaPositionSub);
	registerMetaMethod("Position", "__eq", LuaScriptInterface::luaPositionCompare);

	registerMethod("Position", "getDistance", LuaScriptInterface::luaPositionGetDistance);
	registerMethod("Position", "isSightClear", LuaScriptInterface::luaPositionIsSightClear);

	registerMethod("Position", "sendMagicEffect", LuaScriptInterface::luaPositionSendMagicEffect);
	registerMethod("Position", "sendDistanceEffect", LuaScriptInterface::luaPositionSendDistanceEffect);

	// Tile
	registerClass("Tile", "", LuaScriptInterface::luaTileCreate);
	registerMetaMethod("Tile", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("Tile", "remove", LuaScriptInterface::luaTileRemove);

	registerMethod("Tile", "getPosition", LuaScriptInterface::luaTileGetPosition);
	registerMethod("Tile", "getGround", LuaScriptInterface::luaTileGetGround);
	registerMethod("Tile", "getThing", LuaScriptInterface::luaTileGetThing);
	registerMethod("Tile", "getThingCount", LuaScriptInterface::luaTileGetThingCount);
	registerMethod("Tile", "getTopVisibleThing", LuaScriptInterface::luaTileGetTopVisibleThing);

	registerMethod("Tile", "getTopTopItem", LuaScriptInterface::luaTileGetTopTopItem);
	registerMethod("Tile", "getTopDownItem", LuaScriptInterface::luaTileGetTopDownItem);
	registerMethod("Tile", "getFieldItem", LuaScriptInterface::luaTileGetFieldItem);

	registerMethod("Tile", "getItemById", LuaScriptInterface::luaTileGetItemById);
	registerMethod("Tile", "getItemByType", LuaScriptInterface::luaTileGetItemByType);
	registerMethod("Tile", "getItemByTopOrder", LuaScriptInterface::luaTileGetItemByTopOrder);
	registerMethod("Tile", "getItemCountById", LuaScriptInterface::luaTileGetItemCountById);

	registerMethod("Tile", "getBottomCreature", LuaScriptInterface::luaTileGetBottomCreature);
	registerMethod("Tile", "getTopCreature", LuaScriptInterface::luaTileGetTopCreature);
	registerMethod("Tile", "getBottomVisibleCreature", LuaScriptInterface::luaTileGetBottomVisibleCreature);
	registerMethod("Tile", "getTopVisibleCreature", LuaScriptInterface::luaTileGetTopVisibleCreature);

	registerMethod("Tile", "getItems", LuaScriptInterface::luaTileGetItems);
	registerMethod("Tile", "getItemCount", LuaScriptInterface::luaTileGetItemCount);
	registerMethod("Tile", "getDownItemCount", LuaScriptInterface::luaTileGetDownItemCount);
	registerMethod("Tile", "getTopItemCount", LuaScriptInterface::luaTileGetTopItemCount);

	registerMethod("Tile", "getCreatures", LuaScriptInterface::luaTileGetCreatures);
	registerMethod("Tile", "getCreatureCount", LuaScriptInterface::luaTileGetCreatureCount);

	registerMethod("Tile", "getThingIndex", LuaScriptInterface::luaTileGetThingIndex);

	registerMethod("Tile", "hasProperty", LuaScriptInterface::luaTileHasProperty);
	registerMethod("Tile", "hasFlag", LuaScriptInterface::luaTileHasFlag);

	registerMethod("Tile", "queryAdd", LuaScriptInterface::luaTileQueryAdd);
	registerMethod("Tile", "addItem", LuaScriptInterface::luaTileAddItem);
	registerMethod("Tile", "addItemEx", LuaScriptInterface::luaTileAddItemEx);

	registerMethod("Tile", "getHouse", LuaScriptInterface::luaTileGetHouse);

	// NetworkMessage
	registerClass("NetworkMessage", "", LuaScriptInterface::luaNetworkMessageCreate);
	registerMetaMethod("NetworkMessage", "__eq", LuaScriptInterface::luaUserdataCompare);
	registerMetaMethod("NetworkMessage", "__gc", LuaScriptInterface::luaNetworkMessageDelete);
	registerMethod("NetworkMessage", "delete", LuaScriptInterface::luaNetworkMessageDelete);

	registerMethod("NetworkMessage", "getByte", LuaScriptInterface::luaNetworkMessageGetByte);
	registerMethod("NetworkMessage", "getU16", LuaScriptInterface::luaNetworkMessageGetU16);
	registerMethod("NetworkMessage", "getU32", LuaScriptInterface::luaNetworkMessageGetU32);
	registerMethod("NetworkMessage", "getU64", LuaScriptInterface::luaNetworkMessageGetU64);
	registerMethod("NetworkMessage", "getString", LuaScriptInterface::luaNetworkMessageGetString);
	registerMethod("NetworkMessage", "getPosition", LuaScriptInterface::luaNetworkMessageGetPosition);

	registerMethod("NetworkMessage", "addByte", LuaScriptInterface::luaNetworkMessageAddByte);
	registerMethod("NetworkMessage", "addU16", LuaScriptInterface::luaNetworkMessageAddU16);
	registerMethod("NetworkMessage", "addU32", LuaScriptInterface::luaNetworkMessageAddU32);
	registerMethod("NetworkMessage", "addU64", LuaScriptInterface::luaNetworkMessageAddU64);
	registerMethod("NetworkMessage", "addString", LuaScriptInterface::luaNetworkMessageAddString);
	registerMethod("NetworkMessage", "addPosition", LuaScriptInterface::luaNetworkMessageAddPosition);
	registerMethod("NetworkMessage", "addDouble", LuaScriptInterface::luaNetworkMessageAddDouble);
	registerMethod("NetworkMessage", "addItem", LuaScriptInterface::luaNetworkMessageAddItem);
	registerMethod("NetworkMessage", "addItemId", LuaScriptInterface::luaNetworkMessageAddItemId);
	registerMethod("NetworkMessage", "addItemType", LuaScriptInterface::luaNetworkMessageAddItemType);

	registerMethod("NetworkMessage", "reset", LuaScriptInterface::luaNetworkMessageReset);
	registerMethod("NetworkMessage", "seek", LuaScriptInterface::luaNetworkMessageSeek);
	registerMethod("NetworkMessage", "tell", LuaScriptInterface::luaNetworkMessageTell);
	registerMethod("NetworkMessage", "len", LuaScriptInterface::luaNetworkMessageLength);
	registerMethod("NetworkMessage", "skipBytes", LuaScriptInterface::luaNetworkMessageSkipBytes);
	registerMethod("NetworkMessage", "sendToPlayer", LuaScriptInterface::luaNetworkMessageSendToPlayer);

	// ModalWindow
	registerClass("ModalWindow", "", LuaScriptInterface::luaModalWindowCreate);
	registerMetaMethod("ModalWindow", "__eq", LuaScriptInterface::luaUserdataCompare);
	registerMetaMethod("ModalWindow", "__gc", LuaScriptInterface::luaModalWindowDelete);
	registerMethod("ModalWindow", "delete", LuaScriptInterface::luaModalWindowDelete);

	registerMethod("ModalWindow", "getId", LuaScriptInterface::luaModalWindowGetId);
	registerMethod("ModalWindow", "getTitle", LuaScriptInterface::luaModalWindowGetTitle);
	registerMethod("ModalWindow", "getMessage", LuaScriptInterface::luaModalWindowGetMessage);

	registerMethod("ModalWindow", "setTitle", LuaScriptInterface::luaModalWindowSetTitle);
	registerMethod("ModalWindow", "setMessage", LuaScriptInterface::luaModalWindowSetMessage);

	registerMethod("ModalWindow", "getButtonCount", LuaScriptInterface::luaModalWindowGetButtonCount);
	registerMethod("ModalWindow", "getChoiceCount", LuaScriptInterface::luaModalWindowGetChoiceCount);

	registerMethod("ModalWindow", "addButton", LuaScriptInterface::luaModalWindowAddButton);
	registerMethod("ModalWindow", "addChoice", LuaScriptInterface::luaModalWindowAddChoice);

	registerMethod("ModalWindow", "getDefaultEnterButton", LuaScriptInterface::luaModalWindowGetDefaultEnterButton);
	registerMethod("ModalWindow", "setDefaultEnterButton", LuaScriptInterface::luaModalWindowSetDefaultEnterButton);

	registerMethod("ModalWindow", "getDefaultEscapeButton", LuaScriptInterface::luaModalWindowGetDefaultEscapeButton);
	registerMethod("ModalWindow", "setDefaultEscapeButton", LuaScriptInterface::luaModalWindowSetDefaultEscapeButton);

	registerMethod("ModalWindow", "hasPriority", LuaScriptInterface::luaModalWindowHasPriority);
	registerMethod("ModalWindow", "setPriority", LuaScriptInterface::luaModalWindowSetPriority);

	registerMethod("ModalWindow", "sendToPlayer", LuaScriptInterface::luaModalWindowSendToPlayer);

	// Item
	registerClass("Item", "", LuaScriptInterface::luaItemCreate);
	registerMetaMethod("Item", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("Item", "isItem", LuaScriptInterface::luaItemIsItem);

	registerMethod("Item", "getParent", LuaScriptInterface::luaItemGetParent);
	registerMethod("Item", "getTopParent", LuaScriptInterface::luaItemGetTopParent);

	registerMethod("Item", "getId", LuaScriptInterface::luaItemGetId);

	registerMethod("Item", "clone", LuaScriptInterface::luaItemClone);
	registerMethod("Item", "split", LuaScriptInterface::luaItemSplit);
	registerMethod("Item", "remove", LuaScriptInterface::luaItemRemove);
	registerMethod("Item", "refresh", LuaScriptInterface::luaItemRefresh);

	registerMethod("Item", "getUniqueId", LuaScriptInterface::luaItemGetUniqueId);
	registerMethod("Item", "getActionId", LuaScriptInterface::luaItemGetActionId);
	registerMethod("Item", "setActionId", LuaScriptInterface::luaItemSetActionId);

	registerMethod("Item", "getCount", LuaScriptInterface::luaItemGetCount);
	registerMethod("Item", "getCharges", LuaScriptInterface::luaItemGetCharges);
	registerMethod("Item", "getFluidType", LuaScriptInterface::luaItemGetFluidType);
	registerMethod("Item", "getWeight", LuaScriptInterface::luaItemGetWeight);
	registerMethod("Item", "getWorth", LuaScriptInterface::luaItemGetWorth);

	registerMethod("Item", "getSubType", LuaScriptInterface::luaItemGetSubType);

	registerMethod("Item", "getName", LuaScriptInterface::luaItemGetName);
	registerMethod("Item", "getPluralName", LuaScriptInterface::luaItemGetPluralName);
	registerMethod("Item", "getArticle", LuaScriptInterface::luaItemGetArticle);

	registerMethod("Item", "getPosition", LuaScriptInterface::luaItemGetPosition);
	registerMethod("Item", "getTile", LuaScriptInterface::luaItemGetTile);

	registerMethod("Item", "hasAttribute", LuaScriptInterface::luaItemHasAttribute);
	registerMethod("Item", "getAttribute", LuaScriptInterface::luaItemGetAttribute);
	registerMethod("Item", "setAttribute", LuaScriptInterface::luaItemSetAttribute);
	registerMethod("Item", "removeAttribute", LuaScriptInterface::luaItemRemoveAttribute);
	registerMethod("Item", "getCustomAttribute", LuaScriptInterface::luaItemGetCustomAttribute);
	registerMethod("Item", "setCustomAttribute", LuaScriptInterface::luaItemSetCustomAttribute);
	registerMethod("Item", "removeCustomAttribute", LuaScriptInterface::luaItemRemoveCustomAttribute);

	registerMethod("Item", "moveTo", LuaScriptInterface::luaItemMoveTo);
	registerMethod("Item", "transform", LuaScriptInterface::luaItemTransform);
	registerMethod("Item", "decay", LuaScriptInterface::luaItemDecay);

	registerMethod("Item", "getSpecialDescription", LuaScriptInterface::luaItemGetSpecialDescription);

	registerMethod("Item", "hasProperty", LuaScriptInterface::luaItemHasProperty);
	registerMethod("Item", "isLoadedFromMap", LuaScriptInterface::luaItemIsLoadedFromMap);

	registerMethod("Item", "isMarketable", LuaScriptInterface::luaItemIsMarketable);

	registerMethod("Item", "setStoreItem", LuaScriptInterface::luaItemSetStoreItem);
	registerMethod("Item", "isStoreItem", LuaScriptInterface::luaItemIsStoreItem);

	registerMethod("Item", "setReflect", LuaScriptInterface::luaItemSetReflect);
	registerMethod("Item", "getReflect", LuaScriptInterface::luaItemGetReflect);

	registerMethod("Item", "setBoostPercent", LuaScriptInterface::luaItemSetBoostPercent);
	registerMethod("Item", "getBoostPercent", LuaScriptInterface::luaItemGetBoostPercent);

	registerMethod("Item", "getImbuements", LuaScriptInterface::luaItemGetImbuements);

	registerMethod("Item", "setImbuement", LuaScriptInterface::luaItemSetImbuement);
	registerMethod("Item", "getImbuement", LuaScriptInterface::luaItemGetImbuement);
	registerMethod("Item", "removeImbuement", LuaScriptInterface::luaItemRemoveImbuement);

	// Container
	registerClass("Container", "Item", LuaScriptInterface::luaContainerCreate);
	registerMetaMethod("Container", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("Container", "getSize", LuaScriptInterface::luaContainerGetSize);
	registerMethod("Container", "getCapacity", LuaScriptInterface::luaContainerGetCapacity);
	registerMethod("Container", "getEmptySlots", LuaScriptInterface::luaContainerGetEmptySlots);
	registerMethod("Container", "getItems", LuaScriptInterface::luaContainerGetItems);
	registerMethod("Container", "getItemHoldingCount", LuaScriptInterface::luaContainerGetItemHoldingCount);
	registerMethod("Container", "getItemCountById", LuaScriptInterface::luaContainerGetItemCountById);

	registerMethod("Container", "getItem", LuaScriptInterface::luaContainerGetItem);
	registerMethod("Container", "hasItem", LuaScriptInterface::luaContainerHasItem);
	registerMethod("Container", "addItem", LuaScriptInterface::luaContainerAddItem);
	registerMethod("Container", "addItemEx", LuaScriptInterface::luaContainerAddItemEx);
	registerMethod("Container", "getCorpseOwner", LuaScriptInterface::luaContainerGetCorpseOwner);

	registerMethod("Container", "isLootContainer", LuaScriptInterface::luaContainerIsLootContainer);
	registerMethod("Container", "getLootContainerId", LuaScriptInterface::luaContainerGetLootContainerId);

	// RewardBag
	registerClass("RewardBag", "Container", LuaScriptInterface::luaRewardBagCreate);
	registerMetaMethod("RewardBag", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("RewardBag", "rewardId", LuaScriptInterface::luaRewardBagRewardId);
	registerMethod("RewardBag", "createdAt", LuaScriptInterface::luaRewardBagCreatedAt);

	// Teleport
	registerClass("Teleport", "Item", LuaScriptInterface::luaTeleportCreate);
	registerMetaMethod("Teleport", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("Teleport", "getDestination", LuaScriptInterface::luaTeleportGetDestination);
	registerMethod("Teleport", "setDestination", LuaScriptInterface::luaTeleportSetDestination);

	// Podium
	registerClass("Podium", "Item", LuaScriptInterface::luaPodiumCreate);
	registerMetaMethod("Podium", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("Podium", "getOutfit", LuaScriptInterface::luaPodiumGetOutfit);
	registerMethod("Podium", "setOutfit", LuaScriptInterface::luaPodiumSetOutfit);
	registerMethod("Podium", "hasFlag", LuaScriptInterface::luaPodiumHasFlag);
	registerMethod("Podium", "setFlag", LuaScriptInterface::luaPodiumSetFlag);
	registerMethod("Podium", "getDirection", LuaScriptInterface::luaPodiumGetDirection);
	registerMethod("Podium", "setDirection", LuaScriptInterface::luaPodiumSetDirection);
	
	// HirelingLamp
	registerClass("HirelingLamp", "Item", LuaScriptInterface::luaHirelingLampCreate);
	registerMetaMethod("HirelingLamp", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("HirelingLamp", "hirelingName", LuaScriptInterface::luaHirelingLampName);
	registerMethod("HirelingLamp", "sex", LuaScriptInterface::luaHirelingLampSex);
	registerMethod("HirelingLamp", "outfit", LuaScriptInterface::luaHirelingLampOutfit);
	registerMethod("HirelingLamp", "flags", LuaScriptInterface::luaHirelingLampFlags);
	registerMethod("HirelingLamp", "direction", LuaScriptInterface::luaHirelingLampDirection);
	registerMethod("HirelingLamp", "unpacked", LuaScriptInterface::luaHirelingLampUnpacked);

	// Creature
	registerClass("Creature", "", LuaScriptInterface::luaCreatureCreate);
	registerMetaMethod("Creature", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("Creature", "getEvents", LuaScriptInterface::luaCreatureGetEvents);
	registerMethod("Creature", "registerEvent", LuaScriptInterface::luaCreatureRegisterEvent);
	registerMethod("Creature", "unregisterEvent", LuaScriptInterface::luaCreatureUnregisterEvent);

	registerMethod("Creature", "isRemoved", LuaScriptInterface::luaCreatureIsRemoved);
	registerMethod("Creature", "isCreature", LuaScriptInterface::luaCreatureIsCreature);
	registerMethod("Creature", "isInGhostMode", LuaScriptInterface::luaCreatureIsInGhostMode);
	registerMethod("Creature", "isHealthHidden", LuaScriptInterface::luaCreatureIsHealthHidden);
	registerMethod("Creature", "isMovementBlocked", LuaScriptInterface::luaCreatureIsMovementBlocked);
	registerMethod("Creature", "isImmune", LuaScriptInterface::luaCreatureIsImmune);

	registerMethod("Creature", "canSee", LuaScriptInterface::luaCreatureCanSee);
	registerMethod("Creature", "canSeeCreature", LuaScriptInterface::luaCreatureCanSeeCreature);
	registerMethod("Creature", "canSeeGhostMode", LuaScriptInterface::luaCreatureCanSeeGhostMode);
	registerMethod("Creature", "canSeeInvisibility", LuaScriptInterface::luaCreatureCanSeeInvisibility);

	registerMethod("Creature", "getParent", LuaScriptInterface::luaCreatureGetParent);

	registerMethod("Creature", "getId", LuaScriptInterface::luaCreatureGetId);
	registerMethod("Creature", "getName", LuaScriptInterface::luaCreatureGetName);
	registerMethod("Creature", "getDisplayName", LuaScriptInterface::luaCreatureGetDisplayName);
	registerMethod("Creature", "setDisplayName", LuaScriptInterface::luaCreatureSetDisplayName);
	registerMethod("Creature", "getDisplayMode", LuaScriptInterface::luaCreatureGetDisplayMode);
	registerMethod("Creature", "setDisplayMode", LuaScriptInterface::luaCreatureSetDisplayMode);

	registerMethod("Creature", "isPhantom", LuaScriptInterface::luaCreatureIsPhantom);
	registerMethod("Creature", "setPhantom", LuaScriptInterface::luaCreatureSetPhantom);

	registerMethod("Creature", "getTarget", LuaScriptInterface::luaCreatureGetTarget);
	registerMethod("Creature", "setTarget", LuaScriptInterface::luaCreatureSetTarget);

	registerMethod("Creature", "getFollowCreature", LuaScriptInterface::luaCreatureGetFollowCreature);
	registerMethod("Creature", "setFollowCreature", LuaScriptInterface::luaCreatureSetFollowCreature);

	registerMethod("Creature", "getMaster", LuaScriptInterface::luaCreatureGetMaster);
	registerMethod("Creature", "setMaster", LuaScriptInterface::luaCreatureSetMaster);

	registerMethod("Creature", "getLight", LuaScriptInterface::luaCreatureGetLight);
	registerMethod("Creature", "setLight", LuaScriptInterface::luaCreatureSetLight);

	registerMethod("Creature", "getSpeed", LuaScriptInterface::luaCreatureGetSpeed);
	registerMethod("Creature", "getBaseSpeed", LuaScriptInterface::luaCreatureGetBaseSpeed);
	registerMethod("Creature", "changeSpeed", LuaScriptInterface::luaCreatureChangeSpeed);

	registerMethod("Creature", "setDropLoot", LuaScriptInterface::luaCreatureSetDropLoot);
	registerMethod("Creature", "setSkillLoss", LuaScriptInterface::luaCreatureSetSkillLoss);

	registerMethod("Creature", "getPosition", LuaScriptInterface::luaCreatureGetPosition);
	registerMethod("Creature", "getTile", LuaScriptInterface::luaCreatureGetTile);
	registerMethod("Creature", "getDirection", LuaScriptInterface::luaCreatureGetDirection);
	registerMethod("Creature", "setDirection", LuaScriptInterface::luaCreatureSetDirection);

	registerMethod("Creature", "getHealth", LuaScriptInterface::luaCreatureGetHealth);
	registerMethod("Creature", "setHealth", LuaScriptInterface::luaCreatureSetHealth);
	registerMethod("Creature", "addHealth", LuaScriptInterface::luaCreatureAddHealth);
	registerMethod("Creature", "getMaxHealth", LuaScriptInterface::luaCreatureGetMaxHealth);
	registerMethod("Creature", "setMaxHealth", LuaScriptInterface::luaCreatureSetMaxHealth);
	registerMethod("Creature", "setHiddenHealth", LuaScriptInterface::luaCreatureSetHiddenHealth);
	registerMethod("Creature", "setMovementBlocked", LuaScriptInterface::luaCreatureSetMovementBlocked);

	registerMethod("Creature", "getSkull", LuaScriptInterface::luaCreatureGetSkull);
	registerMethod("Creature", "setSkull", LuaScriptInterface::luaCreatureSetSkull);

	registerMethod("Creature", "getOutfit", LuaScriptInterface::luaCreatureGetOutfit);
	registerMethod("Creature", "setOutfit", LuaScriptInterface::luaCreatureSetOutfit);

	registerMethod("Creature", "getCondition", LuaScriptInterface::luaCreatureGetCondition);
	registerMethod("Creature", "addCondition", LuaScriptInterface::luaCreatureAddCondition);
	registerMethod("Creature", "removeCondition", LuaScriptInterface::luaCreatureRemoveCondition);
	registerMethod("Creature", "hasCondition", LuaScriptInterface::luaCreatureHasCondition);

	registerMethod("Creature", "remove", LuaScriptInterface::luaCreatureRemove);
	registerMethod("Creature", "teleportTo", LuaScriptInterface::luaCreatureTeleportTo);
	registerMethod("Creature", "say", LuaScriptInterface::luaCreatureSay);

	registerMethod("Creature", "getDamageMap", LuaScriptInterface::luaCreatureGetDamageMap);
	registerMethod("Creature", "resetDamageMap", LuaScriptInterface::luaCreatureResetDamageMap);

	registerMethod("Creature", "getSummons", LuaScriptInterface::luaCreatureGetSummons);

	registerMethod("Creature", "getDescription", LuaScriptInterface::luaCreatureGetDescription);

	registerMethod("Creature", "getPathTo", LuaScriptInterface::luaCreatureGetPathTo);
	registerMethod("Creature", "move", LuaScriptInterface::luaCreatureMove);

	registerMethod("Creature", "getZone", LuaScriptInterface::luaCreatureGetZone);

	registerMethod("Creature", "hasIcon", LuaScriptInterface::luaCreatureHasIcon);
	registerMethod("Creature", "getIconValue", LuaScriptInterface::luaCreatureGetIconValue);
	registerMethod("Creature", "setIconValue", LuaScriptInterface::luaCreatureSetIconValue);
	registerMethod("Creature", "removeIcon", LuaScriptInterface::luaCreatureRemoveIcon);

	registerMethod("Creature", "getSpeechBubble", LuaScriptInterface::luaCreatureGetSpeechBubble);
	registerMethod("Creature", "setSpeechBubble", LuaScriptInterface::luaCreatureSetSpeechBubble);

	// Player
	registerClass("Player", "Creature", LuaScriptInterface::luaPlayerCreate);
	registerMetaMethod("Player", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("Player", "isPlayer", LuaScriptInterface::luaPlayerIsPlayer);

	registerMethod("Player", "setName", LuaScriptInterface::luaPlayerSetName);

	registerMethod("Player", "getGuid", LuaScriptInterface::luaPlayerGetGuid);
	registerMethod("Player", "getIp", LuaScriptInterface::luaPlayerGetIp);
	registerMethod("Player", "getAccountId", LuaScriptInterface::luaPlayerGetAccountId);
	registerMethod("Player", "getLastLoginSaved", LuaScriptInterface::luaPlayerGetLastLoginSaved);
	registerMethod("Player", "getLastLogout", LuaScriptInterface::luaPlayerGetLastLogout);
	registerMethod("Player", "fastRelog", LuaScriptInterface::luaPlayerFastRelog);

	registerMethod("Player", "getAccountType", LuaScriptInterface::luaPlayerGetAccountType);
	registerMethod("Player", "setAccountType", LuaScriptInterface::luaPlayerSetAccountType);

	registerMethod("Player", "addAccountResource", LuaScriptInterface::luaPlayerAddAccountResource);
	registerMethod("Player", "setAccountResource", LuaScriptInterface::luaPlayerSetAccountResource);
	registerMethod("Player", "getAccountResource", LuaScriptInterface::luaPlayerGetAccountResource);
	registerMethod("Player", "saveAccountResource", LuaScriptInterface::luaPlayerSaveAccountResource);

	registerMethod("Player", "getCapacity", LuaScriptInterface::luaPlayerGetCapacity);
	registerMethod("Player", "setCapacity", LuaScriptInterface::luaPlayerSetCapacity);

	registerMethod("Player", "getBaseCapacity", LuaScriptInterface::luaPlayerGetBaseCapacity);
	registerMethod("Player", "getFreeCapacity", LuaScriptInterface::luaPlayerGetFreeCapacity);

	registerMethod("Player", "getDepotChest", LuaScriptInterface::luaPlayerGetDepotChest);
	registerMethod("Player", "getRewardChest", LuaScriptInterface::luaPlayerGetRewardChest);
	registerMethod("Player", "getRewardBagById", LuaScriptInterface::luaPlayerGetRewardBagById);
	registerMethod("Player", "getRewardById", LuaScriptInterface::luaPlayerGetRewardById);
	registerMethod("Player", "getInbox", LuaScriptInterface::luaPlayerGetInbox);

	registerMethod("Player", "getSkullTime", LuaScriptInterface::luaPlayerGetSkullTime);
	registerMethod("Player", "setSkullTime", LuaScriptInterface::luaPlayerSetSkullTime);
	registerMethod("Player", "getDeathPenalty", LuaScriptInterface::luaPlayerGetDeathPenalty);

	registerMethod("Player", "getExperience", LuaScriptInterface::luaPlayerGetExperience);
	registerMethod("Player", "addExperience", LuaScriptInterface::luaPlayerAddExperience);
	registerMethod("Player", "removeExperience", LuaScriptInterface::luaPlayerRemoveExperience);
	registerMethod("Player", "getLevel", LuaScriptInterface::luaPlayerGetLevel);

	registerMethod("Player", "getMagicLevel", LuaScriptInterface::luaPlayerGetMagicLevel);
	registerMethod("Player", "getBaseMagicLevel", LuaScriptInterface::luaPlayerGetBaseMagicLevel);
	registerMethod("Player", "getMana", LuaScriptInterface::luaPlayerGetMana);
	registerMethod("Player", "addMana", LuaScriptInterface::luaPlayerAddMana);
	registerMethod("Player", "getMaxMana", LuaScriptInterface::luaPlayerGetMaxMana);
	registerMethod("Player", "setMaxMana", LuaScriptInterface::luaPlayerSetMaxMana);
	registerMethod("Player", "getManaSpent", LuaScriptInterface::luaPlayerGetManaSpent);
	registerMethod("Player", "addManaSpent", LuaScriptInterface::luaPlayerAddManaSpent);
	registerMethod("Player", "removeManaSpent", LuaScriptInterface::luaPlayerRemoveManaSpent);

	registerMethod("Player", "getBaseMaxHealth", LuaScriptInterface::luaPlayerGetBaseMaxHealth);
	registerMethod("Player", "getBaseMaxMana", LuaScriptInterface::luaPlayerGetBaseMaxMana);

	registerMethod("Player", "getVibrancy", LuaScriptInterface::luaPlayerGetVibrancy);

	registerMethod("Player", "getSkillLevel", LuaScriptInterface::luaPlayerGetSkillLevel);
	registerMethod("Player", "getEffectiveSkillLevel", LuaScriptInterface::luaPlayerGetEffectiveSkillLevel);
	registerMethod("Player", "getSkillPercent", LuaScriptInterface::luaPlayerGetSkillPercent);
	registerMethod("Player", "getSkillTries", LuaScriptInterface::luaPlayerGetSkillTries);
	registerMethod("Player", "addSkillTries", LuaScriptInterface::luaPlayerAddSkillTries);
	registerMethod("Player", "removeSkillTries", LuaScriptInterface::luaPlayerRemoveSkillTries);
	registerMethod("Player", "getSpecialSkill", LuaScriptInterface::luaPlayerGetSpecialSkill);
	registerMethod("Player", "addSpecialSkill", LuaScriptInterface::luaPlayerAddSpecialSkill);

	registerMethod("Player", "addOfflineTrainingTime", LuaScriptInterface::luaPlayerAddOfflineTrainingTime);
	registerMethod("Player", "getOfflineTrainingTime", LuaScriptInterface::luaPlayerGetOfflineTrainingTime);
	registerMethod("Player", "removeOfflineTrainingTime", LuaScriptInterface::luaPlayerRemoveOfflineTrainingTime);

	registerMethod("Player", "addOfflineTrainingTries", LuaScriptInterface::luaPlayerAddOfflineTrainingTries);

	registerMethod("Player", "getOfflineTrainingSkill", LuaScriptInterface::luaPlayerGetOfflineTrainingSkill);
	registerMethod("Player", "setOfflineTrainingSkill", LuaScriptInterface::luaPlayerSetOfflineTrainingSkill);

	registerMethod("Player", "getItemCount", LuaScriptInterface::luaPlayerGetItemCount);
	registerMethod("Player", "getItemById", LuaScriptInterface::luaPlayerGetItemById);

	registerMethod("Player", "getVocation", LuaScriptInterface::luaPlayerGetVocation);
	registerMethod("Player", "setVocation", LuaScriptInterface::luaPlayerSetVocation);

	registerMethod("Player", "getSex", LuaScriptInterface::luaPlayerGetSex);
	registerMethod("Player", "setSex", LuaScriptInterface::luaPlayerSetSex);

	registerMethod("Player", "getTown", LuaScriptInterface::luaPlayerGetTown);
	registerMethod("Player", "setTown", LuaScriptInterface::luaPlayerSetTown);

	registerMethod("Player", "getGuild", LuaScriptInterface::luaPlayerGetGuild);
	registerMethod("Player", "setGuild", LuaScriptInterface::luaPlayerSetGuild);

	registerMethod("Player", "getGuildLevel", LuaScriptInterface::luaPlayerGetGuildLevel);
	registerMethod("Player", "setGuildLevel", LuaScriptInterface::luaPlayerSetGuildLevel);

	registerMethod("Player", "getGuildNick", LuaScriptInterface::luaPlayerGetGuildNick);
	registerMethod("Player", "setGuildNick", LuaScriptInterface::luaPlayerSetGuildNick);

	registerMethod("Player", "getGroup", LuaScriptInterface::luaPlayerGetGroup);
	registerMethod("Player", "setGroup", LuaScriptInterface::luaPlayerSetGroup);

	registerMethod("Player", "getStamina", LuaScriptInterface::luaPlayerGetStamina);
	registerMethod("Player", "setStamina", LuaScriptInterface::luaPlayerSetStamina);

	registerMethod("Player", "getSoul", LuaScriptInterface::luaPlayerGetSoul);
	registerMethod("Player", "addSoul", LuaScriptInterface::luaPlayerAddSoul);
	registerMethod("Player", "getMaxSoul", LuaScriptInterface::luaPlayerGetMaxSoul);

	registerMethod("Player", "getBankBalance", LuaScriptInterface::luaPlayerGetBankBalance);
	registerMethod("Player", "setBankBalance", LuaScriptInterface::luaPlayerSetBankBalance);
	registerMethod("Player", "sendResourceBalance", LuaScriptInterface::luaPlayerSendResourceBalance);

	registerMethod("Player", "getStorageValue", LuaScriptInterface::luaPlayerGetStorageValue);
	registerMethod("Player", "setStorageValue", LuaScriptInterface::luaPlayerSetStorageValue);

	registerMethod("Player", "addItem", LuaScriptInterface::luaPlayerAddItem);
	registerMethod("Player", "addItemEx", LuaScriptInterface::luaPlayerAddItemEx);
	registerMethod("Player", "removeItem", LuaScriptInterface::luaPlayerRemoveItem);

	registerMethod("Player", "sendSupplyUsed", LuaScriptInterface::luaPlayerSendSupplyUsed);

	registerMethod("Player", "getMoney", LuaScriptInterface::luaPlayerGetMoney);
	registerMethod("Player", "addMoney", LuaScriptInterface::luaPlayerAddMoney);
	registerMethod("Player", "removeMoney", LuaScriptInterface::luaPlayerRemoveMoney);

	registerMethod("Player", "showTextDialog", LuaScriptInterface::luaPlayerShowTextDialog);

	registerMethod("Player", "sendTextMessage", LuaScriptInterface::luaPlayerSendTextMessage);
	registerMethod("Player", "sendChannelMessage", LuaScriptInterface::luaPlayerSendChannelMessage);
	registerMethod("Player", "sendPrivateMessage", LuaScriptInterface::luaPlayerSendPrivateMessage);
	registerMethod("Player", "channelSay", LuaScriptInterface::luaPlayerChannelSay);
	registerMethod("Player", "openChannel", LuaScriptInterface::luaPlayerOpenChannel);

	registerMethod("Player", "getSlotItem", LuaScriptInterface::luaPlayerGetSlotItem);

	registerMethod("Player", "getParty", LuaScriptInterface::luaPlayerGetParty);

	registerMethod("Player", "addOutfit", LuaScriptInterface::luaPlayerAddOutfit);
	registerMethod("Player", "addOutfitAddon", LuaScriptInterface::luaPlayerAddOutfitAddon);
	registerMethod("Player", "removeOutfit", LuaScriptInterface::luaPlayerRemoveOutfit);
	registerMethod("Player", "removeOutfitAddon", LuaScriptInterface::luaPlayerRemoveOutfitAddon);
	registerMethod("Player", "hasOutfit", LuaScriptInterface::luaPlayerHasOutfit);
	registerMethod("Player", "canWearOutfit", LuaScriptInterface::luaPlayerCanWearOutfit);
	registerMethod("Player", "sendOutfitWindow", LuaScriptInterface::luaPlayerSendOutfitWindow);

	registerMethod("Player", "sendEditPodium", LuaScriptInterface::luaPlayerSendEditPodium);

	registerMethod("Player", "addMount", LuaScriptInterface::luaPlayerAddMount);
	registerMethod("Player", "removeMount", LuaScriptInterface::luaPlayerRemoveMount);
	registerMethod("Player", "hasMount", LuaScriptInterface::luaPlayerHasMount);
	registerMethod("Player", "hasRandomizedMount", LuaScriptInterface::luaPlayerHasRandomizedMount);
	registerMethod("Player", "setRandomizedMount", LuaScriptInterface::luaPlayerSetRandomizedMount);

	registerMethod("Player", "addFamiliar", LuaScriptInterface::luaPlayerAddFamiliar);
	registerMethod("Player", "removeFamiliar", LuaScriptInterface::luaPlayerRemoveFamiliar);
	registerMethod("Player", "hasFamiliar", LuaScriptInterface::luaPlayerHasFamiliar);
	registerMethod("Player", "canUseFamiliar", LuaScriptInterface::luaPlayerCanUseFamiliar);
	registerMethod("Player", "getCurrentFamiliar", LuaScriptInterface::luaPlayerGetCurrentFamiliar);
	registerMethod("Player", "setCurrentFamiliar", LuaScriptInterface::luaPlayerSetCurrentFamiliar);

	registerMethod("Player", "getPremiumEndsAt", LuaScriptInterface::luaPlayerGetPremiumEndsAt);
	registerMethod("Player", "setPremiumEndsAt", LuaScriptInterface::luaPlayerSetPremiumEndsAt);

	registerMethod("Player", "hasBlessing", LuaScriptInterface::luaPlayerHasBlessing);
	registerMethod("Player", "addBlessing", LuaScriptInterface::luaPlayerAddBlessing);
	registerMethod("Player", "removeBlessing", LuaScriptInterface::luaPlayerRemoveBlessing);

	registerMethod("Player", "canLearnSpell", LuaScriptInterface::luaPlayerCanLearnSpell);
	registerMethod("Player", "learnSpell", LuaScriptInterface::luaPlayerLearnSpell);
	registerMethod("Player", "forgetSpell", LuaScriptInterface::luaPlayerForgetSpell);
	registerMethod("Player", "hasLearnedSpell", LuaScriptInterface::luaPlayerHasLearnedSpell);

	registerMethod("Player", "setLootContainer", LuaScriptInterface::luaPlayerSetLootContainer);
	registerMethod("Player", "getLootContainer", LuaScriptInterface::luaPlayerGetLootContainer);
	registerMethod("Player", "getLootContainerFlags", LuaScriptInterface::luaPlayerGetLootContainerFlags);

	registerMethod("Player", "sendTutorial", LuaScriptInterface::luaPlayerSendTutorial);
	registerMethod("Player", "addMapMark", LuaScriptInterface::luaPlayerAddMapMark);

	registerMethod("Player", "save", LuaScriptInterface::luaPlayerSave);
	registerMethod("Player", "popupFYI", LuaScriptInterface::luaPlayerPopupFYI);

	registerMethod("Player", "isPzLocked", LuaScriptInterface::luaPlayerIsPzLocked);

	registerMethod("Player", "getClient", LuaScriptInterface::luaPlayerGetClient);

	registerMethod("Player", "getHouse", LuaScriptInterface::luaPlayerGetHouse);
	registerMethod("Player", "sendHouseWindow", LuaScriptInterface::luaPlayerSendHouseWindow);
	registerMethod("Player", "setEditHouse", LuaScriptInterface::luaPlayerSetEditHouse);

	registerMethod("Player", "setGhostMode", LuaScriptInterface::luaPlayerSetGhostMode);

	registerMethod("Player", "getContainerId", LuaScriptInterface::luaPlayerGetContainerId);
	registerMethod("Player", "getContainerById", LuaScriptInterface::luaPlayerGetContainerById);
	registerMethod("Player", "getContainerIndex", LuaScriptInterface::luaPlayerGetContainerIndex);
	registerMethod("Player", "getOpenContainers", LuaScriptInterface::luaPlayerGetOpenContainers);
	
	registerMethod("Player", "getInstantSpells", LuaScriptInterface::luaPlayerGetInstantSpells);
	registerMethod("Player", "canCast", LuaScriptInterface::luaPlayerCanCast);

	registerMethod("Player", "hasChaseMode", LuaScriptInterface::luaPlayerHasChaseMode);
	registerMethod("Player", "hasSecureMode", LuaScriptInterface::luaPlayerHasSecureMode);
	registerMethod("Player", "getFightMode", LuaScriptInterface::luaPlayerGetFightMode);

	registerMethod("Player", "getStoreInbox", LuaScriptInterface::luaPlayerGetStoreInbox);

	registerMethod("Player", "isNearDepotBox", LuaScriptInterface::luaPlayerIsNearDepotBox);

	registerMethod("Player", "getIdleTime", LuaScriptInterface::luaPlayerGetIdleTime);

	registerMethod("Player", "isIgnoringFriction", LuaScriptInterface::luaPlayerIsIgnoringFriction);
	registerMethod("Player", "setIgnoreFriction", LuaScriptInterface::luaPlayerSetIgnoreFriction);

	registerMethod("Player", "imbuementsReload", LuaScriptInterface::luaPlayerImbuementsReload);

	// Monster
	registerClass("Monster", "Creature", LuaScriptInterface::luaMonsterCreate);
	registerMetaMethod("Monster", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("Monster", "isMonster", LuaScriptInterface::luaMonsterIsMonster);

	registerMethod("Monster", "getType", LuaScriptInterface::luaMonsterGetType);

	registerMethod("Monster", "rename", LuaScriptInterface::luaMonsterRename);

	registerMethod("Monster", "getSpawnPosition", LuaScriptInterface::luaMonsterGetSpawnPosition);
	registerMethod("Monster", "isInSpawnRange", LuaScriptInterface::luaMonsterIsInSpawnRange);

	registerMethod("Monster", "isIdle", LuaScriptInterface::luaMonsterIsIdle);
	registerMethod("Monster", "setIdle", LuaScriptInterface::luaMonsterSetIdle);

	registerMethod("Monster", "isFamiliar", LuaScriptInterface::luaMonsterIsFamiliar);
	registerMethod("Monster", "setFamiliar", LuaScriptInterface::luaMonsterSetFamiliar);

	registerMethod("Monster", "isTarget", LuaScriptInterface::luaMonsterIsTarget);
	registerMethod("Monster", "isOpponent", LuaScriptInterface::luaMonsterIsOpponent);
	registerMethod("Monster", "isFriend", LuaScriptInterface::luaMonsterIsFriend);

	registerMethod("Monster", "addFriend", LuaScriptInterface::luaMonsterAddFriend);
	registerMethod("Monster", "removeFriend", LuaScriptInterface::luaMonsterRemoveFriend);
	registerMethod("Monster", "getFriendList", LuaScriptInterface::luaMonsterGetFriendList);
	registerMethod("Monster", "getFriendCount", LuaScriptInterface::luaMonsterGetFriendCount);

	registerMethod("Monster", "addTarget", LuaScriptInterface::luaMonsterAddTarget);
	registerMethod("Monster", "removeTarget", LuaScriptInterface::luaMonsterRemoveTarget);
	registerMethod("Monster", "getTargetList", LuaScriptInterface::luaMonsterGetTargetList);
	registerMethod("Monster", "getTargetCount", LuaScriptInterface::luaMonsterGetTargetCount);

	registerMethod("Monster", "selectTarget", LuaScriptInterface::luaMonsterSelectTarget);
	registerMethod("Monster", "searchTarget", LuaScriptInterface::luaMonsterSearchTarget);

	registerMethod("Monster", "isWalkingToSpawn", LuaScriptInterface::luaMonsterIsWalkingToSpawn);
	registerMethod("Monster", "walkToSpawn", LuaScriptInterface::luaMonsterWalkToSpawn);

	registerMethod("Monster", "hasMonsterIcon", LuaScriptInterface::luaMonsterHasIcon);
	registerMethod("Monster", "getMonsterIconValue", LuaScriptInterface::luaMonsterGetIconValue);
	registerMethod("Monster", "setMonsterIconValue", LuaScriptInterface::luaMonsterSetIconValue);
	registerMethod("Monster", "removeMonsterIcon", LuaScriptInterface::luaMonsterRemoveIcon);

	// Npc
	registerClass("Npc", "Creature", LuaScriptInterface::luaNpcCreate);
	registerMetaMethod("Npc", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("Npc", "isNpc", LuaScriptInterface::luaNpcIsNpc);
	registerMethod("Npc", "setName", LuaScriptInterface::luaNpcSetName);

	registerMethod("Npc", "setMasterPos", LuaScriptInterface::luaNpcSetMasterPos);
	registerMethod("Npc", "getMasterPos", LuaScriptInterface::luaNpcGetMasterPos);

	registerMethod("Npc", "setOwnerGUID", LuaScriptInterface::luaNpcSetOwnerGUID);
	registerMethod("Npc", "getOwnerGUID", LuaScriptInterface::luaNpcGetOwnerGUID);

	registerMethod("Npc", "setSex", LuaScriptInterface::luaNpcSetSex);
	registerMethod("Npc", "getSex", LuaScriptInterface::luaNpcGetSex);

	// Guild
	registerClass("Guild", "", LuaScriptInterface::luaGuildCreate);
	registerMetaMethod("Guild", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("Guild", "getId", LuaScriptInterface::luaGuildGetId);
	registerMethod("Guild", "getName", LuaScriptInterface::luaGuildGetName);
	registerMethod("Guild", "getMembersOnline", LuaScriptInterface::luaGuildGetMembersOnline);

	registerMethod("Guild", "addRank", LuaScriptInterface::luaGuildAddRank);
	registerMethod("Guild", "getRankById", LuaScriptInterface::luaGuildGetRankById);
	registerMethod("Guild", "getRankByLevel", LuaScriptInterface::luaGuildGetRankByLevel);
	registerMethod("Guild", "getLeaderRankLevel", LuaScriptInterface::luaGuildGetLeaderRankLevel);

	registerMethod("Guild", "getMotd", LuaScriptInterface::luaGuildGetMotd);
	registerMethod("Guild", "setMotd", LuaScriptInterface::luaGuildSetMotd);

	// Group
	registerClass("Group", "", LuaScriptInterface::luaGroupCreate);
	registerMetaMethod("Group", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("Group", "getId", LuaScriptInterface::luaGroupGetId);
	registerMethod("Group", "getName", LuaScriptInterface::luaGroupGetName);
	registerMethod("Group", "getFlags", LuaScriptInterface::luaGroupGetFlags);
	registerMethod("Group", "getAccess", LuaScriptInterface::luaGroupGetAccess);
	registerMethod("Group", "getMaxDepotItems", LuaScriptInterface::luaGroupGetMaxDepotItems);
	registerMethod("Group", "getMaxVipEntries", LuaScriptInterface::luaGroupGetMaxVipEntries);
	registerMethod("Group", "hasFlag", LuaScriptInterface::luaGroupHasFlag);

	// Vocation
	registerClass("Vocation", "", LuaScriptInterface::luaVocationCreate);
	registerMetaMethod("Vocation", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("Vocation", "getId", LuaScriptInterface::luaVocationGetId);
	registerMethod("Vocation", "getClientId", LuaScriptInterface::luaVocationGetClientId);
	registerMethod("Vocation", "getName", LuaScriptInterface::luaVocationGetName);
	registerMethod("Vocation", "getDescription", LuaScriptInterface::luaVocationGetDescription);

	registerMethod("Vocation", "getRequiredSkillTries", LuaScriptInterface::luaVocationGetRequiredSkillTries);
	registerMethod("Vocation", "getRequiredManaSpent", LuaScriptInterface::luaVocationGetRequiredManaSpent);

	registerMethod("Vocation", "getCapacityGain", LuaScriptInterface::luaVocationGetCapacityGain);

	registerMethod("Vocation", "getHealthGain", LuaScriptInterface::luaVocationGetHealthGain);
	registerMethod("Vocation", "getHealthGainTicks", LuaScriptInterface::luaVocationGetHealthGainTicks);
	registerMethod("Vocation", "getHealthGainAmount", LuaScriptInterface::luaVocationGetHealthGainAmount);

	registerMethod("Vocation", "getManaGain", LuaScriptInterface::luaVocationGetManaGain);
	registerMethod("Vocation", "getManaGainTicks", LuaScriptInterface::luaVocationGetManaGainTicks);
	registerMethod("Vocation", "getManaGainAmount", LuaScriptInterface::luaVocationGetManaGainAmount);

	registerMethod("Vocation", "getMaxSoul", LuaScriptInterface::luaVocationGetMaxSoul);
	registerMethod("Vocation", "getSoulGainTicks", LuaScriptInterface::luaVocationGetSoulGainTicks);

	registerMethod("Vocation", "getAttackSpeed", LuaScriptInterface::luaVocationGetAttackSpeed);
	registerMethod("Vocation", "getBaseSpeed", LuaScriptInterface::luaVocationGetBaseSpeed);

	registerMethod("Vocation", "getDemotion", LuaScriptInterface::luaVocationGetDemotion);
	registerMethod("Vocation", "getPromotion", LuaScriptInterface::luaVocationGetPromotion);

	registerMethod("Vocation", "allowsPvp", LuaScriptInterface::luaVocationAllowsPvp);

	// Town
	registerClass("Town", "", LuaScriptInterface::luaTownCreate);
	registerMetaMethod("Town", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("Town", "getId", LuaScriptInterface::luaTownGetId);
	registerMethod("Town", "getName", LuaScriptInterface::luaTownGetName);
	registerMethod("Town", "getTemplePosition", LuaScriptInterface::luaTownGetTemplePosition);

	// House
	registerClass("House", "", LuaScriptInterface::luaHouseCreate);
	registerMetaMethod("House", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("House", "getId", LuaScriptInterface::luaHouseGetId);
	registerMethod("House", "getName", LuaScriptInterface::luaHouseGetName);
	registerMethod("House", "getTown", LuaScriptInterface::luaHouseGetTown);
	registerMethod("House", "getExitPosition", LuaScriptInterface::luaHouseGetExitPosition);

	registerMethod("House", "getRent", LuaScriptInterface::luaHouseGetRent);
	registerMethod("House", "setRent", LuaScriptInterface::luaHouseSetRent);

	registerMethod("House", "getPaidUntil", LuaScriptInterface::luaHouseGetPaidUntil);
	registerMethod("House", "setPaidUntil", LuaScriptInterface::luaHouseSetPaidUntil);

	registerMethod("House", "getPayRentWarnings", LuaScriptInterface::luaHouseGetPayRentWarnings);
	registerMethod("House", "setPayRentWarnings", LuaScriptInterface::luaHouseSetPayRentWarnings);

	registerMethod("House", "getOwnerName", LuaScriptInterface::luaHouseGetOwnerName);
	registerMethod("House", "getOwnerAccountId", LuaScriptInterface::luaHouseGetOwnerAccountId);
	registerMethod("House", "getOwnerGuid", LuaScriptInterface::luaHouseGetOwnerGuid);
	registerMethod("House", "setOwnerGuid", LuaScriptInterface::luaHouseSetOwnerGuid);
	registerMethod("House", "startTrade", LuaScriptInterface::luaHouseStartTrade);

	registerMethod("House", "getBeds", LuaScriptInterface::luaHouseGetBeds);
	registerMethod("House", "getBedCount", LuaScriptInterface::luaHouseGetBedCount);

	registerMethod("House", "getDoors", LuaScriptInterface::luaHouseGetDoors);
	registerMethod("House", "getDoorCount", LuaScriptInterface::luaHouseGetDoorCount);
	registerMethod("House", "getDoorIdByPosition", LuaScriptInterface::luaHouseGetDoorIdByPosition);

	registerMethod("House", "getTiles", LuaScriptInterface::luaHouseGetTiles);
	registerMethod("House", "getItems", LuaScriptInterface::luaHouseGetItems);
	registerMethod("House", "getTileCount", LuaScriptInterface::luaHouseGetTileCount);

	registerMethod("House", "canEditAccessList", LuaScriptInterface::luaHouseCanEditAccessList);
	registerMethod("House", "getAccessList", LuaScriptInterface::luaHouseGetAccessList);
	registerMethod("House", "setAccessList", LuaScriptInterface::luaHouseSetAccessList);
	registerMethod("House", "isInAccessList", LuaScriptInterface::luaHouseIsInAccessList);
	registerMethod("House", "getAccessLevel", LuaScriptInterface::luaHouseGetAccessLevel);

	registerMethod("House", "kickPlayer", LuaScriptInterface::luaHouseKickPlayer);

	registerMethod("House", "save", LuaScriptInterface::luaHouseSave);

	// ItemType
	registerClass("ItemType", "", LuaScriptInterface::luaItemTypeCreate);
	registerMetaMethod("ItemType", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("ItemType", "isCorpse", LuaScriptInterface::luaItemTypeIsCorpse);
	registerMethod("ItemType", "isDoor", LuaScriptInterface::luaItemTypeIsDoor);
	registerMethod("ItemType", "isContainer", LuaScriptInterface::luaItemTypeIsContainer);
	registerMethod("ItemType", "isFluidContainer", LuaScriptInterface::luaItemTypeIsFluidContainer);
	registerMethod("ItemType", "isMovable", LuaScriptInterface::luaItemTypeIsMovable);
	registerMethod("ItemType", "isRune", LuaScriptInterface::luaItemTypeIsRune);
	registerMethod("ItemType", "isStackable", LuaScriptInterface::luaItemTypeIsStackable);
	registerMethod("ItemType", "isReadable", LuaScriptInterface::luaItemTypeIsReadable);
	registerMethod("ItemType", "isWritable", LuaScriptInterface::luaItemTypeIsWritable);
	registerMethod("ItemType", "isBlocking", LuaScriptInterface::luaItemTypeIsBlocking);
	registerMethod("ItemType", "isGroundTile", LuaScriptInterface::luaItemTypeIsGroundTile);
	registerMethod("ItemType", "isMagicField", LuaScriptInterface::luaItemTypeIsMagicField);
	registerMethod("ItemType", "isUseable", LuaScriptInterface::luaItemTypeIsUseable);
	registerMethod("ItemType", "isPickupable", LuaScriptInterface::luaItemTypeIsPickupable);

	registerMethod("ItemType", "getType", LuaScriptInterface::luaItemTypeGetType);
	registerMethod("ItemType", "getGroup", LuaScriptInterface::luaItemTypeGetGroup);
	registerMethod("ItemType", "getId", LuaScriptInterface::luaItemTypeGetId);
	registerMethod("ItemType", "getClientId", LuaScriptInterface::luaItemTypeGetClientId);
	registerMethod("ItemType", "getRotateId", LuaScriptInterface::luaItemTypeGetRotateId);
	registerMethod("ItemType", "getWareId", LuaScriptInterface::luaItemTypeGetWareId);
	registerMethod("ItemType", "getName", LuaScriptInterface::luaItemTypeGetName);
	registerMethod("ItemType", "getPluralName", LuaScriptInterface::luaItemTypeGetPluralName);
	registerMethod("ItemType", "getArticle", LuaScriptInterface::luaItemTypeGetArticle);
	registerMethod("ItemType", "getDescription", LuaScriptInterface::luaItemTypeGetDescription);
	registerMethod("ItemType", "getSlotPosition", LuaScriptInterface::luaItemTypeGetSlotPosition);

	registerMethod("ItemType", "getCharges", LuaScriptInterface::luaItemTypeGetCharges);
	registerMethod("ItemType", "getFluidSource", LuaScriptInterface::luaItemTypeGetFluidSource);
	registerMethod("ItemType", "getCapacity", LuaScriptInterface::luaItemTypeGetCapacity);
	registerMethod("ItemType", "getWeight", LuaScriptInterface::luaItemTypeGetWeight);
	registerMethod("ItemType", "getWorth", LuaScriptInterface::luaItemTypeGetWorth);

	registerMethod("ItemType", "getHitChance", LuaScriptInterface::luaItemTypeGetHitChance);
	registerMethod("ItemType", "getShootRange", LuaScriptInterface::luaItemTypeGetShootRange);

	registerMethod("ItemType", "getAttack", LuaScriptInterface::luaItemTypeGetAttack);
	registerMethod("ItemType", "getAttackSpeed", LuaScriptInterface::luaItemTypeGetAttackSpeed);
	registerMethod("ItemType", "getDefense", LuaScriptInterface::luaItemTypeGetDefense);
	registerMethod("ItemType", "getExtraDefense", LuaScriptInterface::luaItemTypeGetExtraDefense);
	registerMethod("ItemType", "getArmor", LuaScriptInterface::luaItemTypeGetArmor);
	registerMethod("ItemType", "getWeaponType", LuaScriptInterface::luaItemTypeGetWeaponType);

	registerMethod("ItemType", "getElementType", LuaScriptInterface::luaItemTypeGetElementType);
	registerMethod("ItemType", "getElementDamage", LuaScriptInterface::luaItemTypeGetElementDamage);

	registerMethod("ItemType", "getTransformEquipId", LuaScriptInterface::luaItemTypeGetTransformEquipId);
	registerMethod("ItemType", "getTransformDeEquipId", LuaScriptInterface::luaItemTypeGetTransformDeEquipId);
	registerMethod("ItemType", "getDestroyId", LuaScriptInterface::luaItemTypeGetDestroyId);
	registerMethod("ItemType", "getDecayId", LuaScriptInterface::luaItemTypeGetDecayId);
	registerMethod("ItemType", "getRequiredLevel", LuaScriptInterface::luaItemTypeGetRequiredLevel);
	registerMethod("ItemType", "getAmmoType", LuaScriptInterface::luaItemTypeGetAmmoType);
	registerMethod("ItemType", "getCorpseType", LuaScriptInterface::luaItemTypeGetCorpseType);
	registerMethod("ItemType", "getClassification", LuaScriptInterface::luaItemTypeGetClassification);

	registerMethod("ItemType", "getAbilities", LuaScriptInterface::luaItemTypeGetAbilities);

	registerMethod("ItemType", "hasShowAttributes", LuaScriptInterface::luaItemTypeHasShowAttributes);
	registerMethod("ItemType", "hasShowCount", LuaScriptInterface::luaItemTypeHasShowCount);
	registerMethod("ItemType", "hasShowCharges", LuaScriptInterface::luaItemTypeHasShowCharges);
	registerMethod("ItemType", "hasShowDuration", LuaScriptInterface::luaItemTypeHasShowDuration);
	registerMethod("ItemType", "hasAllowDistRead", LuaScriptInterface::luaItemTypeHasAllowDistRead);
	registerMethod("ItemType", "getWieldInfo", LuaScriptInterface::luaItemTypeGetWieldInfo);
	registerMethod("ItemType", "getDuration", LuaScriptInterface::luaItemTypeGetDuration);
	registerMethod("ItemType", "getLevelDoor", LuaScriptInterface::luaItemTypeGetLevelDoor);
	registerMethod("ItemType", "getRuneSpellName", LuaScriptInterface::luaItemTypeGetRuneSpellName);
	registerMethod("ItemType", "getVocationString", LuaScriptInterface::luaItemTypeGetVocationString);
	registerMethod("ItemType", "getMinReqLevel", LuaScriptInterface::luaItemTypeGetMinReqLevel);
	registerMethod("ItemType", "getMinReqMagicLevel", LuaScriptInterface::luaItemTypeGetMinReqMagicLevel);
	registerMethod("ItemType", "getMarketBuyStatistics", LuaScriptInterface::luaItemTypeGetMarketBuyStatistics);
	registerMethod("ItemType", "getMarketSellStatistics", LuaScriptInterface::luaItemTypeGetMarketSellStatistics);

	registerMethod("ItemType", "hasSubType", LuaScriptInterface::luaItemTypeHasSubType);

	registerMethod("ItemType", "isStoreItem", LuaScriptInterface::luaItemTypeIsStoreItem);

	// Combat
	registerClass("Combat", "", LuaScriptInterface::luaCombatCreate);
	registerMetaMethod("Combat", "__eq", LuaScriptInterface::luaUserdataCompare);
	registerMetaMethod("Combat", "__gc", LuaScriptInterface::luaCombatDelete);
	registerMethod("Combat", "delete", LuaScriptInterface::luaCombatDelete);

	registerMethod("Combat", "setParameter", LuaScriptInterface::luaCombatSetParameter);
	registerMethod("Combat", "getParameter", LuaScriptInterface::luaCombatGetParameter);

	registerMethod("Combat", "setFormula", LuaScriptInterface::luaCombatSetFormula);

	registerMethod("Combat", "setArea", LuaScriptInterface::luaCombatSetArea);
	registerMethod("Combat", "addCondition", LuaScriptInterface::luaCombatAddCondition);
	registerMethod("Combat", "clearConditions", LuaScriptInterface::luaCombatClearConditions);
	registerMethod("Combat", "setCallback", LuaScriptInterface::luaCombatSetCallback);
	registerMethod("Combat", "setOrigin", LuaScriptInterface::luaCombatSetOrigin);

	registerMethod("Combat", "execute", LuaScriptInterface::luaCombatExecute);

	// Condition
	registerClass("Condition", "", LuaScriptInterface::luaConditionCreate);
	registerMetaMethod("Condition", "__eq", LuaScriptInterface::luaUserdataCompare);
	registerMetaMethod("Condition", "__gc", LuaScriptInterface::luaConditionDelete);

	registerMethod("Condition", "getId", LuaScriptInterface::luaConditionGetId);
	registerMethod("Condition", "getSubId", LuaScriptInterface::luaConditionGetSubId);
	registerMethod("Condition", "getType", LuaScriptInterface::luaConditionGetType);
	registerMethod("Condition", "getIcons", LuaScriptInterface::luaConditionGetIcons);
	registerMethod("Condition", "getEndTime", LuaScriptInterface::luaConditionGetEndTime);

	registerMethod("Condition", "clone", LuaScriptInterface::luaConditionClone);

	registerMethod("Condition", "getTicks", LuaScriptInterface::luaConditionGetTicks);
	registerMethod("Condition", "setTicks", LuaScriptInterface::luaConditionSetTicks);

	registerMethod("Condition", "setParameter", LuaScriptInterface::luaConditionSetParameter);
	registerMethod("Condition", "getParameter", LuaScriptInterface::luaConditionGetParameter);

	registerMethod("Condition", "setFormula", LuaScriptInterface::luaConditionSetFormula);
	registerMethod("Condition", "setOutfit", LuaScriptInterface::luaConditionSetOutfit);

	registerMethod("Condition", "addDamage", LuaScriptInterface::luaConditionAddDamage);

	// ImbuementType
	registerClass("ImbuementType", "", LuaScriptInterface::luaImbuementTypeCreate);
	registerMetaMethod("ImbuementType", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("ImbuementType", "name", LuaScriptInterface::luaImbuementTypeName);
	registerMethod("ImbuementType", "description", LuaScriptInterface::luaImbuementTypeDescription);
	registerMethod("ImbuementType", "type", LuaScriptInterface::luaImbuementTypeType);
	registerMethod("ImbuementType", "icon", LuaScriptInterface::luaImbuementTypeIconId);
	registerMethod("ImbuementType", "primaryValue", LuaScriptInterface::luaImbuementTypePrimaryValue);
	registerMethod("ImbuementType", "secondaryValue", LuaScriptInterface::luaImbuementTypeSecondaryValue);
	registerMethod("ImbuementType", "duration", LuaScriptInterface::luaImbuementTypeDuration);
	registerMethod("ImbuementType", "outOfCombat", LuaScriptInterface::luaImbuementTypeOutOfCombat);
	
	// Outfit
	registerClass("Outfit", "", LuaScriptInterface::luaOutfitCreate);
	registerMetaMethod("Outfit", "__eq", LuaScriptInterface::luaOutfitCompare);

	// MonsterType
	registerClass("MonsterType", "", LuaScriptInterface::luaMonsterTypeCreate);
	registerMetaMethod("MonsterType", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("MonsterType", "isAttackable", LuaScriptInterface::luaMonsterTypeIsAttackable);
	registerMethod("MonsterType", "isChallengeable", LuaScriptInterface::luaMonsterTypeIsChallengeable);
	registerMethod("MonsterType", "isConvinceable", LuaScriptInterface::luaMonsterTypeIsConvinceable);
	registerMethod("MonsterType", "isSummonable", LuaScriptInterface::luaMonsterTypeIsSummonable);
	registerMethod("MonsterType", "isIgnoringSpawnBlock", LuaScriptInterface::luaMonsterTypeIsIgnoringSpawnBlock);
	registerMethod("MonsterType", "isIllusionable", LuaScriptInterface::luaMonsterTypeIsIllusionable);
	registerMethod("MonsterType", "isHostile", LuaScriptInterface::luaMonsterTypeIsHostile);
	registerMethod("MonsterType", "isPushable", LuaScriptInterface::luaMonsterTypeIsPushable);
	registerMethod("MonsterType", "isHealthHidden", LuaScriptInterface::luaMonsterTypeIsHealthHidden);
	registerMethod("MonsterType", "isBoss", LuaScriptInterface::luaMonsterTypeIsBoss);

	registerMethod("MonsterType", "canPushItems", LuaScriptInterface::luaMonsterTypeCanPushItems);
	registerMethod("MonsterType", "canPushCreatures", LuaScriptInterface::luaMonsterTypeCanPushCreatures);

	registerMethod("MonsterType", "canWalkOnEnergy", LuaScriptInterface::luaMonsterTypeCanWalkOnEnergy);
	registerMethod("MonsterType", "canWalkOnFire", LuaScriptInterface::luaMonsterTypeCanWalkOnFire);
	registerMethod("MonsterType", "canWalkOnPoison", LuaScriptInterface::luaMonsterTypeCanWalkOnPoison);

	registerMethod("MonsterType", "name", LuaScriptInterface::luaMonsterTypeName);
	registerMethod("MonsterType", "nameDescription", LuaScriptInterface::luaMonsterTypeNameDescription);

	registerMethod("MonsterType", "health", LuaScriptInterface::luaMonsterTypeHealth);
	registerMethod("MonsterType", "maxHealth", LuaScriptInterface::luaMonsterTypeMaxHealth);
	registerMethod("MonsterType", "runHealth", LuaScriptInterface::luaMonsterTypeRunHealth);
	registerMethod("MonsterType", "experience", LuaScriptInterface::luaMonsterTypeExperience);
	registerMethod("MonsterType", "skull", LuaScriptInterface::luaMonsterTypeSkull);

	registerMethod("MonsterType", "combatImmunities", LuaScriptInterface::luaMonsterTypeCombatImmunities);
	registerMethod("MonsterType", "conditionImmunities", LuaScriptInterface::luaMonsterTypeConditionImmunities);

	registerMethod("MonsterType", "getAttackList", LuaScriptInterface::luaMonsterTypeGetAttackList);
	registerMethod("MonsterType", "addAttack", LuaScriptInterface::luaMonsterTypeAddAttack);

	registerMethod("MonsterType", "getDefenseList", LuaScriptInterface::luaMonsterTypeGetDefenseList);
	registerMethod("MonsterType", "addDefense", LuaScriptInterface::luaMonsterTypeAddDefense);

	registerMethod("MonsterType", "getElementList", LuaScriptInterface::luaMonsterTypeGetElementList);
	registerMethod("MonsterType", "addElement", LuaScriptInterface::luaMonsterTypeAddElement);

	registerMethod("MonsterType", "getVoices", LuaScriptInterface::luaMonsterTypeGetVoices);
	registerMethod("MonsterType", "addVoice", LuaScriptInterface::luaMonsterTypeAddVoice);

	registerMethod("MonsterType", "getLoot", LuaScriptInterface::luaMonsterTypeGetLoot);
	registerMethod("MonsterType", "addLoot", LuaScriptInterface::luaMonsterTypeAddLoot);

	registerMethod("MonsterType", "getCreatureEvents", LuaScriptInterface::luaMonsterTypeGetCreatureEvents);
	registerMethod("MonsterType", "registerEvent", LuaScriptInterface::luaMonsterTypeRegisterEvent);

	registerMethod("MonsterType", "eventType", LuaScriptInterface::luaMonsterTypeEventType);
	registerMethod("MonsterType", "onThink", LuaScriptInterface::luaMonsterTypeEventOnCallback);
	registerMethod("MonsterType", "onAppear", LuaScriptInterface::luaMonsterTypeEventOnCallback);
	registerMethod("MonsterType", "onDisappear", LuaScriptInterface::luaMonsterTypeEventOnCallback);
	registerMethod("MonsterType", "onMove", LuaScriptInterface::luaMonsterTypeEventOnCallback);
	registerMethod("MonsterType", "onSay", LuaScriptInterface::luaMonsterTypeEventOnCallback);

	registerMethod("MonsterType", "getSummonList", LuaScriptInterface::luaMonsterTypeGetSummonList);
	registerMethod("MonsterType", "addSummon", LuaScriptInterface::luaMonsterTypeAddSummon);

	registerMethod("MonsterType", "maxSummons", LuaScriptInterface::luaMonsterTypeMaxSummons);

	registerMethod("MonsterType", "armor", LuaScriptInterface::luaMonsterTypeArmor);
	registerMethod("MonsterType", "defense", LuaScriptInterface::luaMonsterTypeDefense);
	registerMethod("MonsterType", "outfit", LuaScriptInterface::luaMonsterTypeOutfit);
	registerMethod("MonsterType", "race", LuaScriptInterface::luaMonsterTypeRace);
	registerMethod("MonsterType", "corpseId", LuaScriptInterface::luaMonsterTypeCorpseId);
	registerMethod("MonsterType", "manaCost", LuaScriptInterface::luaMonsterTypeManaCost);
	registerMethod("MonsterType", "baseSpeed", LuaScriptInterface::luaMonsterTypeBaseSpeed);
	registerMethod("MonsterType", "light", LuaScriptInterface::luaMonsterTypeLight);

	registerMethod("MonsterType", "staticAttackChance", LuaScriptInterface::luaMonsterTypeStaticAttackChance);
	registerMethod("MonsterType", "targetDistance", LuaScriptInterface::luaMonsterTypeTargetDistance);
	registerMethod("MonsterType", "yellChance", LuaScriptInterface::luaMonsterTypeYellChance);
	registerMethod("MonsterType", "yellSpeedTicks", LuaScriptInterface::luaMonsterTypeYellSpeedTicks);
	registerMethod("MonsterType", "changeTargetChance", LuaScriptInterface::luaMonsterTypeChangeTargetChance);
	registerMethod("MonsterType", "changeTargetSpeed", LuaScriptInterface::luaMonsterTypeChangeTargetSpeed);

	// Loot
	registerClass("Loot", "", LuaScriptInterface::luaCreateLoot);
	registerMetaMethod("Loot", "__gc", LuaScriptInterface::luaDeleteLoot);
	registerMethod("Loot", "delete", LuaScriptInterface::luaDeleteLoot);

	registerMethod("Loot", "setId", LuaScriptInterface::luaLootSetId);
	registerMethod("Loot", "setMaxCount", LuaScriptInterface::luaLootSetMaxCount);
	registerMethod("Loot", "setSubType", LuaScriptInterface::luaLootSetSubType);
	registerMethod("Loot", "setChance", LuaScriptInterface::luaLootSetChance);
	registerMethod("Loot", "setActionId", LuaScriptInterface::luaLootSetActionId);
	registerMethod("Loot", "setDescription", LuaScriptInterface::luaLootSetDescription);
	registerMethod("Loot", "setTop", LuaScriptInterface::luaLootSetTop);
	registerMethod("Loot", "addChildLoot", LuaScriptInterface::luaLootAddChildLoot);

	// MonsterSpell
	registerClass("MonsterSpell", "", LuaScriptInterface::luaCreateMonsterSpell);
	registerMetaMethod("MonsterSpell", "__gc", LuaScriptInterface::luaDeleteMonsterSpell);
	registerMethod("MonsterSpell", "delete", LuaScriptInterface::luaDeleteMonsterSpell);

	registerMethod("MonsterSpell", "setType", LuaScriptInterface::luaMonsterSpellSetType);
	registerMethod("MonsterSpell", "setScriptName", LuaScriptInterface::luaMonsterSpellSetScriptName);
	registerMethod("MonsterSpell", "setChance", LuaScriptInterface::luaMonsterSpellSetChance);
	registerMethod("MonsterSpell", "setInterval", LuaScriptInterface::luaMonsterSpellSetInterval);
	registerMethod("MonsterSpell", "setRange", LuaScriptInterface::luaMonsterSpellSetRange);
	registerMethod("MonsterSpell", "setCombatValue", LuaScriptInterface::luaMonsterSpellSetCombatValue);
	registerMethod("MonsterSpell", "setCombatType", LuaScriptInterface::luaMonsterSpellSetCombatType);
	registerMethod("MonsterSpell", "setAttackValue", LuaScriptInterface::luaMonsterSpellSetAttackValue);
	registerMethod("MonsterSpell", "setNeedTarget", LuaScriptInterface::luaMonsterSpellSetNeedTarget);
	registerMethod("MonsterSpell", "setNeedDirection", LuaScriptInterface::luaMonsterSpellSetNeedDirection);
	registerMethod("MonsterSpell", "setCombatLength", LuaScriptInterface::luaMonsterSpellSetCombatLength);
	registerMethod("MonsterSpell", "setCombatSpread", LuaScriptInterface::luaMonsterSpellSetCombatSpread);
	registerMethod("MonsterSpell", "setCombatRadius", LuaScriptInterface::luaMonsterSpellSetCombatRadius);
	registerMethod("MonsterSpell", "setCombatRing", LuaScriptInterface::luaMonsterSpellSetCombatRing);
	registerMethod("MonsterSpell", "setConditionType", LuaScriptInterface::luaMonsterSpellSetConditionType);
	registerMethod("MonsterSpell", "setConditionDamage", LuaScriptInterface::luaMonsterSpellSetConditionDamage);
	registerMethod("MonsterSpell", "setConditionSpeedChange", LuaScriptInterface::luaMonsterSpellSetConditionSpeedChange);
	registerMethod("MonsterSpell", "setConditionDuration", LuaScriptInterface::luaMonsterSpellSetConditionDuration);
	registerMethod("MonsterSpell", "setConditionDrunkenness", LuaScriptInterface::luaMonsterSpellSetConditionDrunkenness);
	registerMethod("MonsterSpell", "setConditionTickInterval", LuaScriptInterface::luaMonsterSpellSetConditionTickInterval);
	registerMethod("MonsterSpell", "setCombatShootEffect", LuaScriptInterface::luaMonsterSpellSetCombatShootEffect);
	registerMethod("MonsterSpell", "setCombatEffect", LuaScriptInterface::luaMonsterSpellSetCombatEffect);
	registerMethod("MonsterSpell", "setOutfit", LuaScriptInterface::luaMonsterSpellSetOutfit);

	// Party
	registerClass("Party", "", LuaScriptInterface::luaPartyCreate);
	registerMetaMethod("Party", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("Party", "disband", LuaScriptInterface::luaPartyDisband);

	registerMethod("Party", "getLeader", LuaScriptInterface::luaPartyGetLeader);
	registerMethod("Party", "setLeader", LuaScriptInterface::luaPartySetLeader);

	registerMethod("Party", "getMembers", LuaScriptInterface::luaPartyGetMembers);
	registerMethod("Party", "getActiveMembers", LuaScriptInterface::luaPartyGetActiveMembers);
	registerMethod("Party", "getMemberCount", LuaScriptInterface::luaPartyGetMemberCount);

	registerMethod("Party", "getInvitees", LuaScriptInterface::luaPartyGetInvitees);
	registerMethod("Party", "getInviteeCount", LuaScriptInterface::luaPartyGetInviteeCount);

	registerMethod("Party", "addInvite", LuaScriptInterface::luaPartyAddInvite);
	registerMethod("Party", "removeInvite", LuaScriptInterface::luaPartyRemoveInvite);

	registerMethod("Party", "addMember", LuaScriptInterface::luaPartyAddMember);
	registerMethod("Party", "removeMember", LuaScriptInterface::luaPartyRemoveMember);

	registerMethod("Party", "isSharedExperienceActive", LuaScriptInterface::luaPartyIsSharedExperienceActive);
	registerMethod("Party", "isSharedExperienceEnabled", LuaScriptInterface::luaPartyIsSharedExperienceEnabled);
	registerMethod("Party", "shareExperience", LuaScriptInterface::luaPartyShareExperience);
	registerMethod("Party", "setSharedExperience", LuaScriptInterface::luaPartySetSharedExperience);

	// Spells
	registerClass("Spell", "", LuaScriptInterface::luaSpellCreate);
	registerMetaMethod("Spell", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("Spell", "onCastSpell", LuaScriptInterface::luaSpellOnCastSpell);
	registerMethod("Spell", "register", LuaScriptInterface::luaSpellRegister);
	registerMethod("Spell", "name", LuaScriptInterface::luaSpellName);
	registerMethod("Spell", "id", LuaScriptInterface::luaSpellId);
	registerMethod("Spell", "group", LuaScriptInterface::luaSpellGroup);
	registerMethod("Spell", "cooldown", LuaScriptInterface::luaSpellCooldown);
	registerMethod("Spell", "groupCooldown", LuaScriptInterface::luaSpellGroupCooldown);
	registerMethod("Spell", "level", LuaScriptInterface::luaSpellLevel);
	registerMethod("Spell", "magicLevel", LuaScriptInterface::luaSpellMagicLevel);
	registerMethod("Spell", "mana", LuaScriptInterface::luaSpellMana);
	registerMethod("Spell", "manaPercent", LuaScriptInterface::luaSpellManaPercent);
	registerMethod("Spell", "soul", LuaScriptInterface::luaSpellSoul);
	registerMethod("Spell", "range", LuaScriptInterface::luaSpellRange);
	registerMethod("Spell", "isPremium", LuaScriptInterface::luaSpellPremium);
	registerMethod("Spell", "isEnabled", LuaScriptInterface::luaSpellEnabled);
	registerMethod("Spell", "needTarget", LuaScriptInterface::luaSpellNeedTarget);
	registerMethod("Spell", "needWeapon", LuaScriptInterface::luaSpellNeedWeapon);
	registerMethod("Spell", "needLearn", LuaScriptInterface::luaSpellNeedLearn);
	registerMethod("Spell", "isSelfTarget", LuaScriptInterface::luaSpellSelfTarget);
	registerMethod("Spell", "isBlocking", LuaScriptInterface::luaSpellBlocking);
	registerMethod("Spell", "isAggressive", LuaScriptInterface::luaSpellAggressive);
	registerMethod("Spell", "isPzLock", LuaScriptInterface::luaSpellPzLock);
	registerMethod("Spell", "vocation", LuaScriptInterface::luaSpellVocation);

	// only for InstantSpell
	registerMethod("Spell", "words", LuaScriptInterface::luaSpellWords);
	registerMethod("Spell", "needDirection", LuaScriptInterface::luaSpellNeedDirection);
	registerMethod("Spell", "hasParams", LuaScriptInterface::luaSpellHasParams);
	registerMethod("Spell", "hasPlayerNameParam", LuaScriptInterface::luaSpellHasPlayerNameParam);
	registerMethod("Spell", "needCasterTargetOrDirection", LuaScriptInterface::luaSpellNeedCasterTargetOrDirection);
	registerMethod("Spell", "isBlockingWalls", LuaScriptInterface::luaSpellIsBlockingWalls);

	// only for RuneSpells
	registerMethod("Spell", "runeLevel", LuaScriptInterface::luaSpellRuneLevel);
	registerMethod("Spell", "runeMagicLevel", LuaScriptInterface::luaSpellRuneMagicLevel);
	registerMethod("Spell", "runeId", LuaScriptInterface::luaSpellRuneId);
	registerMethod("Spell", "charges", LuaScriptInterface::luaSpellCharges);
	registerMethod("Spell", "allowFarUse", LuaScriptInterface::luaSpellAllowFarUse);
	registerMethod("Spell", "blockWalls", LuaScriptInterface::luaSpellBlockWalls);
	registerMethod("Spell", "checkFloor", LuaScriptInterface::luaSpellCheckFloor);

	// Action
	registerClass("Action", "", LuaScriptInterface::luaCreateAction);
	registerMethod("Action", "onUse", LuaScriptInterface::luaActionOnUse);
	registerMethod("Action", "register", LuaScriptInterface::luaActionRegister);
	registerMethod("Action", "id", LuaScriptInterface::luaActionItemId);
	registerMethod("Action", "aid", LuaScriptInterface::luaActionActionId);
	registerMethod("Action", "uid", LuaScriptInterface::luaActionUniqueId);
	registerMethod("Action", "allowFarUse", LuaScriptInterface::luaActionAllowFarUse);
	registerMethod("Action", "blockWalls", LuaScriptInterface::luaActionBlockWalls);
	registerMethod("Action", "checkFloor", LuaScriptInterface::luaActionCheckFloor);

	// TalkAction
	registerClass("TalkAction", "", LuaScriptInterface::luaCreateTalkaction);
	registerMethod("TalkAction", "onSay", LuaScriptInterface::luaTalkactionOnSay);
	registerMethod("TalkAction", "register", LuaScriptInterface::luaTalkactionRegister);
	registerMethod("TalkAction", "separator", LuaScriptInterface::luaTalkactionSeparator);
	registerMethod("TalkAction", "access", LuaScriptInterface::luaTalkactionAccess);
	registerMethod("TalkAction", "accountType", LuaScriptInterface::luaTalkactionAccountType);

	// CreatureEvent
	registerClass("CreatureEvent", "", LuaScriptInterface::luaCreateCreatureEvent);
	registerMethod("CreatureEvent", "type", LuaScriptInterface::luaCreatureEventType);
	registerMethod("CreatureEvent", "register", LuaScriptInterface::luaCreatureEventRegister);
	registerMethod("CreatureEvent", "onLogin", LuaScriptInterface::luaCreatureEventOnCallback);
	registerMethod("CreatureEvent", "onLogout", LuaScriptInterface::luaCreatureEventOnCallback);
	registerMethod("CreatureEvent", "onThink", LuaScriptInterface::luaCreatureEventOnCallback);
	registerMethod("CreatureEvent", "onPrepareDeath", LuaScriptInterface::luaCreatureEventOnCallback);
	registerMethod("CreatureEvent", "onDeath", LuaScriptInterface::luaCreatureEventOnCallback);
	registerMethod("CreatureEvent", "onKill", LuaScriptInterface::luaCreatureEventOnCallback);
	registerMethod("CreatureEvent", "onAdvance", LuaScriptInterface::luaCreatureEventOnCallback);
	registerMethod("CreatureEvent", "onModalWindow", LuaScriptInterface::luaCreatureEventOnCallback);
	registerMethod("CreatureEvent", "onTextEdit", LuaScriptInterface::luaCreatureEventOnCallback);
	registerMethod("CreatureEvent", "onHealthChange", LuaScriptInterface::luaCreatureEventOnCallback);
	registerMethod("CreatureEvent", "onManaChange", LuaScriptInterface::luaCreatureEventOnCallback);
	registerMethod("CreatureEvent", "onExtendedOpcode", LuaScriptInterface::luaCreatureEventOnCallback);

	// MoveEvent
	registerClass("MoveEvent", "", LuaScriptInterface::luaCreateMoveEvent);
	registerMethod("MoveEvent", "type", LuaScriptInterface::luaMoveEventType);
	registerMethod("MoveEvent", "register", LuaScriptInterface::luaMoveEventRegister);
	registerMethod("MoveEvent", "level", LuaScriptInterface::luaMoveEventLevel);
	registerMethod("MoveEvent", "magicLevel", LuaScriptInterface::luaMoveEventMagLevel);
	registerMethod("MoveEvent", "slot", LuaScriptInterface::luaMoveEventSlot);
	registerMethod("MoveEvent", "id", LuaScriptInterface::luaMoveEventItemId);
	registerMethod("MoveEvent", "aid", LuaScriptInterface::luaMoveEventActionId);
	registerMethod("MoveEvent", "uid", LuaScriptInterface::luaMoveEventUniqueId);
	registerMethod("MoveEvent", "position", LuaScriptInterface::luaMoveEventPosition);
	registerMethod("MoveEvent", "premium", LuaScriptInterface::luaMoveEventPremium);
	registerMethod("MoveEvent", "vocation", LuaScriptInterface::luaMoveEventVocation);
	registerMethod("MoveEvent", "tileItem", LuaScriptInterface::luaMoveEventTileItem);
	registerMethod("MoveEvent", "onEquip", LuaScriptInterface::luaMoveEventOnCallback);
	registerMethod("MoveEvent", "onDeEquip", LuaScriptInterface::luaMoveEventOnCallback);
	registerMethod("MoveEvent", "onStepIn", LuaScriptInterface::luaMoveEventOnCallback);
	registerMethod("MoveEvent", "onStepOut", LuaScriptInterface::luaMoveEventOnCallback);
	registerMethod("MoveEvent", "onAddItem", LuaScriptInterface::luaMoveEventOnCallback);
	registerMethod("MoveEvent", "onRemoveItem", LuaScriptInterface::luaMoveEventOnCallback);

	// GlobalEvent
	registerClass("GlobalEvent", "", LuaScriptInterface::luaCreateGlobalEvent);
	registerMethod("GlobalEvent", "type", LuaScriptInterface::luaGlobalEventType);
	registerMethod("GlobalEvent", "register", LuaScriptInterface::luaGlobalEventRegister);
	registerMethod("GlobalEvent", "time", LuaScriptInterface::luaGlobalEventTime);
	registerMethod("GlobalEvent", "interval", LuaScriptInterface::luaGlobalEventInterval);
	registerMethod("GlobalEvent", "onThink", LuaScriptInterface::luaGlobalEventOnCallback);
	registerMethod("GlobalEvent", "onTime", LuaScriptInterface::luaGlobalEventOnCallback);
	registerMethod("GlobalEvent", "onStartup", LuaScriptInterface::luaGlobalEventOnCallback);
	registerMethod("GlobalEvent", "onShutdown", LuaScriptInterface::luaGlobalEventOnCallback);
	registerMethod("GlobalEvent", "onRecord", LuaScriptInterface::luaGlobalEventOnCallback);

	// Weapon
	registerClass("Weapon", "", LuaScriptInterface::luaCreateWeapon);
	registerMethod("Weapon", "action", LuaScriptInterface::luaWeaponAction);
	registerMethod("Weapon", "register", LuaScriptInterface::luaWeaponRegister);
	registerMethod("Weapon", "id", LuaScriptInterface::luaWeaponId);
	registerMethod("Weapon", "level", LuaScriptInterface::luaWeaponLevel);
	registerMethod("Weapon", "magicLevel", LuaScriptInterface::luaWeaponMagicLevel);
	registerMethod("Weapon", "mana", LuaScriptInterface::luaWeaponMana);
	registerMethod("Weapon", "manaPercent", LuaScriptInterface::luaWeaponManaPercent);
	registerMethod("Weapon", "health", LuaScriptInterface::luaWeaponHealth);
	registerMethod("Weapon", "healthPercent", LuaScriptInterface::luaWeaponHealthPercent);
	registerMethod("Weapon", "soul", LuaScriptInterface::luaWeaponSoul);
	registerMethod("Weapon", "breakChance", LuaScriptInterface::luaWeaponBreakChance);
	registerMethod("Weapon", "premium", LuaScriptInterface::luaWeaponPremium);
	registerMethod("Weapon", "wieldUnproperly", LuaScriptInterface::luaWeaponUnproperly);
	registerMethod("Weapon", "vocation", LuaScriptInterface::luaWeaponVocation);
	registerMethod("Weapon", "onUseWeapon", LuaScriptInterface::luaWeaponOnUseWeapon);
	registerMethod("Weapon", "element", LuaScriptInterface::luaWeaponElement);
	registerMethod("Weapon", "attack", LuaScriptInterface::luaWeaponAttack);
	registerMethod("Weapon", "defense", LuaScriptInterface::luaWeaponDefense);
	registerMethod("Weapon", "range", LuaScriptInterface::luaWeaponRange);
	registerMethod("Weapon", "charges", LuaScriptInterface::luaWeaponCharges);
	registerMethod("Weapon", "duration", LuaScriptInterface::luaWeaponDuration);
	registerMethod("Weapon", "decayTo", LuaScriptInterface::luaWeaponDecayTo);
	registerMethod("Weapon", "transformEquipTo", LuaScriptInterface::luaWeaponTransformEquipTo);
	registerMethod("Weapon", "transformDeEquipTo", LuaScriptInterface::luaWeaponTransformDeEquipTo);
	registerMethod("Weapon", "slotType", LuaScriptInterface::luaWeaponSlotType);
	registerMethod("Weapon", "hitChance", LuaScriptInterface::luaWeaponHitChance);
	registerMethod("Weapon", "extraElement", LuaScriptInterface::luaWeaponExtraElement);

	// exclusively for distance weapons
	registerMethod("Weapon", "ammoType", LuaScriptInterface::luaWeaponAmmoType);
	registerMethod("Weapon", "maxHitChance", LuaScriptInterface::luaWeaponMaxHitChance);

	// exclusively for wands
	registerMethod("Weapon", "damage", LuaScriptInterface::luaWeaponWandDamage);

	// exclusively for wands & distance weapons
	registerMethod("Weapon", "shootType", LuaScriptInterface::luaWeaponShootType);
}

#undef registerEnum
#undef registerEnumIn

void LuaScriptInterface::registerClass(const std::string& className, const std::string& baseClass, lua_CFunction newFunction/* = nullptr*/)
{
	// className = {}
	lua_newtable(luaState);
	lua_pushvalue(luaState, -1);
	lua_setglobal(luaState, className.c_str());
	int methods = lua_gettop(luaState);

	// methodsTable = {}
	lua_newtable(luaState);
	int methodsTable = lua_gettop(luaState);

	if (newFunction) {
		// className.__call = newFunction
		lua_pushcfunction(luaState, newFunction);
		lua_setfield(luaState, methodsTable, "__call");
	}

	uint32_t parents = 0;
	if (!baseClass.empty()) {
		lua_getglobal(luaState, baseClass.c_str());
		lua_rawgeti(luaState, -1, 'p');
		parents = getNumber<uint32_t>(luaState, -1) + 1;
		lua_pop(luaState, 1);
		lua_setfield(luaState, methodsTable, "__index");
	}

	// setmetatable(className, methodsTable)
	lua_setmetatable(luaState, methods);

	// className.metatable = {}
	luaL_newmetatable(luaState, className.c_str());
	int metatable = lua_gettop(luaState);

	// className.metatable.__metatable = className
	lua_pushvalue(luaState, methods);
	lua_setfield(luaState, metatable, "__metatable");

	// className.metatable.__index = className
	lua_pushvalue(luaState, methods);
	lua_setfield(luaState, metatable, "__index");

	// className.metatable['h'] = hash
	lua_pushnumber(luaState, std::hash<std::string>()(className));
	lua_rawseti(luaState, metatable, 'h');

	// className.metatable['p'] = parents
	lua_pushnumber(luaState, parents);
	lua_rawseti(luaState, metatable, 'p');

	// className.metatable['t'] = type
	if (className == "Item") {
		lua_pushnumber(luaState, LuaData_Item);
	} else if (className == "RewardBag") {
		lua_pushnumber(luaState, LuaData_RewardBag);
	} else if (className == "Container") {
		lua_pushnumber(luaState, LuaData_Container);
	} else if (className == "Teleport") {
		lua_pushnumber(luaState, LuaData_Teleport);
	} else if (className == "Podium") {
		lua_pushnumber(luaState, LuaData_Podium);
	} else if (className == "Player") {
		lua_pushnumber(luaState, LuaData_Player);
	} else if (className == "Monster") {
		lua_pushnumber(luaState, LuaData_Monster);
	} else if (className == "Npc") {
		lua_pushnumber(luaState, LuaData_Npc);
	} else if (className == "Tile") {
		lua_pushnumber(luaState, LuaData_Tile);
	} else {
		lua_pushnumber(luaState, LuaData_Unknown);
	}
	lua_rawseti(luaState, metatable, 't');

	// pop className, className.metatable
	lua_pop(luaState, 2);
}

void LuaScriptInterface::registerTable(const std::string& tableName)
{
	// _G[tableName] = {}
	lua_newtable(luaState);
	lua_setglobal(luaState, tableName.c_str());
}

void LuaScriptInterface::registerMethod(const std::string& globalName, const std::string& methodName, lua_CFunction func)
{
	// globalName.methodName = func
	lua_getglobal(luaState, globalName.c_str());
	lua_pushcfunction(luaState, func);
	lua_setfield(luaState, -2, methodName.c_str());

	// pop globalName
	lua_pop(luaState, 1);
}

void LuaScriptInterface::registerMetaMethod(const std::string& className, const std::string& methodName, lua_CFunction func)
{
	// className.metatable.methodName = func
	luaL_getmetatable(luaState, className.c_str());
	lua_pushcfunction(luaState, func);
	lua_setfield(luaState, -2, methodName.c_str());

	// pop className.metatable
	lua_pop(luaState, 1);
}

void LuaScriptInterface::registerGlobalMethod(const std::string& functionName, lua_CFunction func)
{
	// _G[functionName] = func
	lua_pushcfunction(luaState, func);
	lua_setglobal(luaState, functionName.c_str());
}

void LuaScriptInterface::registerVariable(const std::string& tableName, const std::string& name, lua_Number value)
{
	// tableName.name = value
	lua_getglobal(luaState, tableName.c_str());
	setField(luaState, name.c_str(), value);

	// pop tableName
	lua_pop(luaState, 1);
}

void LuaScriptInterface::registerGlobalVariable(const std::string& name, lua_Number value)
{
	// _G[name] = value
	lua_pushnumber(luaState, value);
	lua_setglobal(luaState, name.c_str());
}

void LuaScriptInterface::registerGlobalBoolean(const std::string& name, bool value)
{
	// _G[name] = value
	pushBoolean(luaState, value);
	lua_setglobal(luaState, name.c_str());
}

std::string LuaScriptInterface::escapeString(const std::string& string)
{
	std::string s = string;
	replaceString(s, "\\", "\\\\");
	replaceString(s, "\"", "\\\"");
	replaceString(s, "'", "\\'");
	replaceString(s, "[[", "\\[[");
	return s;
}

#ifndef LUAJIT_VERSION
const luaL_Reg LuaScriptInterface::luaBitReg[] = {
	//{"tobit", LuaScriptInterface::luaBitToBit},
	{"bnot", LuaScriptInterface::luaBitNot},
	{"band", LuaScriptInterface::luaBitAnd},
	{"bor", LuaScriptInterface::luaBitOr},
	{"bxor", LuaScriptInterface::luaBitXor},
	{"lshift", LuaScriptInterface::luaBitLeftShift},
	{"rshift", LuaScriptInterface::luaBitRightShift},
	//{"arshift", LuaScriptInterface::luaBitArithmeticalRightShift},
	//{"rol", LuaScriptInterface::luaBitRotateLeft},
	//{"ror", LuaScriptInterface::luaBitRotateRight},
	//{"bswap", LuaScriptInterface::luaBitSwapEndian},
	//{"tohex", LuaScriptInterface::luaBitToHex},
	{nullptr, nullptr}
};

int LuaScriptInterface::luaBitNot(lua_State* L)
{
	lua_pushnumber(L, ~getNumber<uint32_t>(L, -1));
	return 1;
}

#define MULTIOP(name, op) \
int LuaScriptInterface::luaBit##name(lua_State* L) \
{ \
	int n = lua_gettop(L); \
	uint32_t w = getNumber<uint32_t>(L, -1); \
	for (int i = 1; i < n; ++i) \
		w op getNumber<uint32_t>(L, i); \
	lua_pushnumber(L, w); \
	return 1; \
}

MULTIOP(And, &=)
MULTIOP(Or, |=)
MULTIOP(Xor, ^=)

#define SHIFTOP(name, op) \
int LuaScriptInterface::luaBit##name(lua_State* L) \
{ \
	uint32_t n1 = getNumber<uint32_t>(L, 1), n2 = getNumber<uint32_t>(L, 2); \
	lua_pushnumber(L, (n1 op n2)); \
	return 1; \
}

SHIFTOP(LeftShift, << )
SHIFTOP(RightShift, >> )
#endif

const luaL_Reg LuaScriptInterface::luaConfigManagerTable[] = {
	{"getString", LuaScriptInterface::luaConfigManagerGetString},
	{"getNumber", LuaScriptInterface::luaConfigManagerGetNumber},
	{"getBoolean", LuaScriptInterface::luaConfigManagerGetBoolean},
	{nullptr, nullptr}
};

int LuaScriptInterface::luaConfigManagerGetString(lua_State* L)
{
	pushString(L, g_config.getString(getNumber<ConfigManager::string_config_t>(L, -1)));
	return 1;
}

int LuaScriptInterface::luaConfigManagerGetNumber(lua_State* L)
{
	lua_pushnumber(L, g_config.getNumber(getNumber<ConfigManager::integer_config_t>(L, -1)));
	return 1;
}

int LuaScriptInterface::luaConfigManagerGetBoolean(lua_State* L)
{
	pushBoolean(L, g_config.getBoolean(getNumber<ConfigManager::boolean_config_t>(L, -1)));
	return 1;
}

int LuaScriptInterface::luaIsScriptsInterface(lua_State* L)
{
	//isScriptsInterface()
	if (getScriptEnv()->getScriptInterface() == &g_scripts->getScriptInterface()) {
		pushBoolean(L, true);
	} else {
		reportErrorFunc(L, "EventCallback: can only be called inside (data/scripts/)");
		pushBoolean(L, false);
	}
	return 1;
}

// Userdata
int LuaScriptInterface::luaUserdataCompare(lua_State* L)
{
	// userdataA == userdataB
	pushBoolean(L, getUserdata<void>(L, 1) == getUserdata<void>(L, 2));
	return 1;
}

// _G
int LuaScriptInterface::luaIsType(lua_State* L)
{
	// isType(derived, base)
	lua_getmetatable(L, -2);
	lua_getmetatable(L, -2);

	lua_rawgeti(L, -2, 'p');
	uint_fast8_t parentsB = getNumber<uint_fast8_t>(L, 1);

	lua_rawgeti(L, -3, 'h');
	size_t hashB = getNumber<size_t>(L, 1);

	lua_rawgeti(L, -3, 'p');
	uint_fast8_t parentsA = getNumber<uint_fast8_t>(L, 1);
	for (uint_fast8_t i = parentsA; i < parentsB; ++i) {
		lua_getfield(L, -3, "__index");
		lua_replace(L, -4);
	}

	lua_rawgeti(L, -4, 'h');
	size_t hashA = getNumber<size_t>(L, 1);

	pushBoolean(L, hashA == hashB);
	return 1;
}

int LuaScriptInterface::luaRawGetMetatable(lua_State* L)
{
	// rawgetmetatable(metatableName)
	luaL_getmetatable(L, getString(L, 1).c_str());
	return 1;
}

//
LuaEnvironment::LuaEnvironment() : LuaScriptInterface("Main Interface") {}

LuaEnvironment::~LuaEnvironment()
{
	delete testInterface;
	closeState();
}

bool LuaEnvironment::initState()
{
	luaState = luaL_newstate();
	if (!luaState) {
		return false;
	}

	luaL_openlibs(luaState);
	registerFunctions();

	//runningEventId = EVENT_ID_USER;
	return true;
}

bool LuaEnvironment::reInitState()
{
	// TODO: get children, reload children
	closeState();
	return initState();
}

bool LuaEnvironment::closeState()
{
	if (!luaState) {
		return false;
	}

	for (const auto& combatEntry : combatIdMap) {
		clearCombatObjects(combatEntry.first);
	}

	for (const auto& areaEntry : areaIdMap) {
		clearAreaObjects(areaEntry.first);
	}

	for (auto& timerEntry : timerEvents) {
		LuaTimerEventDesc timerEventDesc = std::move(timerEntry.second);
		for (int32_t parameter : timerEventDesc.parameters) {
			luaL_unref(luaState, LUA_REGISTRYINDEX, parameter);
		}
		luaL_unref(luaState, LUA_REGISTRYINDEX, timerEventDesc.function);
	}

	combatIdMap.clear();
	areaIdMap.clear();
	timerEvents.clear();
	//cacheFiles.clear();

	lua_close(luaState);
	luaState = nullptr;
	return true;
}

LuaScriptInterface* LuaEnvironment::getTestInterface()
{
	if (!testInterface) {
		testInterface = new LuaScriptInterface("Test Interface");
		testInterface->initState();
	}
	return testInterface;
}

Combat_ptr LuaEnvironment::getCombatObject(uint32_t id) const
{
	auto it = combatMap.find(id);
	if (it == combatMap.end()) {
		return nullptr;
	}
	return it->second;
}

Combat_ptr LuaEnvironment::createCombatObject(LuaScriptInterface* interface)
{
	Combat_ptr combat = std::make_shared<Combat>();
	combatMap[++lastCombatId] = combat;
	combatIdMap[interface].push_back(lastCombatId);
	return combat;
}

void LuaEnvironment::clearCombatObjects(LuaScriptInterface* interface)
{
	auto it = combatIdMap.find(interface);
	if (it == combatIdMap.end()) {
		return;
	}

	for (uint32_t id : it->second) {
		auto itt = combatMap.find(id);
		if (itt != combatMap.end()) {
			combatMap.erase(itt);
		}
	}
	it->second.clear();
}

AreaCombat* LuaEnvironment::getAreaObject(uint32_t id) const
{
	auto it = areaMap.find(id);
	if (it == areaMap.end()) {
		return nullptr;
	}
	return it->second;
}

uint32_t LuaEnvironment::createAreaObject(LuaScriptInterface* interface)
{
	areaMap[++lastAreaId] = new AreaCombat;
	areaIdMap[interface].push_back(lastAreaId);
	return lastAreaId;
}

void LuaEnvironment::clearAreaObjects(LuaScriptInterface* interface)
{
	auto it = areaIdMap.find(interface);
	if (it == areaIdMap.end()) {
		return;
	}

	for (uint32_t id : it->second) {
		auto itt = areaMap.find(id);
		if (itt != areaMap.end()) {
			delete itt->second;
			areaMap.erase(itt);
		}
	}
	it->second.clear();
}

void LuaEnvironment::executeTimerEvent(uint32_t eventIndex)
{
	auto it = timerEvents.find(eventIndex);
	if (it == timerEvents.end()) {
		return;
	}

	LuaTimerEventDesc timerEventDesc = std::move(it->second);
	timerEvents.erase(it);

	//push function
	lua_rawgeti(luaState, LUA_REGISTRYINDEX, timerEventDesc.function);

	//push parameters
	for (auto parameter : boost::adaptors::reverse(timerEventDesc.parameters)) {
		lua_rawgeti(luaState, LUA_REGISTRYINDEX, parameter);
	}

	//call the function
	if (reserveScriptEnv()) {
		ScriptEnvironment* env = getScriptEnv();
		env->setTimerEvent();
		env->setScriptId(timerEventDesc.scriptId, this);
		callFunction(timerEventDesc.parameters.size());
	} else {
		reportOverflow();
	}

	//free resources
	luaL_unref(luaState, LUA_REGISTRYINDEX, timerEventDesc.function);
	for (auto parameter : timerEventDesc.parameters) {
		luaL_unref(luaState, LUA_REGISTRYINDEX, parameter);
	}
}
