// Copyright 2022 Xynera.net. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "luascript.h"

#include "bed.h"
#include "game.h"
#include "house.h"
#include "housetile.h"
#include "iologindata.h"
#include "iomapserialize.h"

// House
int LuaScriptInterface::luaHouseCreate(lua_State* L)
{
	// House(id)
	House* house = g_game.map.houses.getHouse(getNumber<uint32_t>(L, 2));
	if (house) {
		pushUserdata<House>(L, house);
		setMetatable(L, -1, "House");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaHouseGetId(lua_State* L)
{
	// house:getId()
	House* house = getUserdata<House>(L, 1);
	if (house) {
		lua_pushnumber(L, house->getId());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaHouseGetName(lua_State* L)
{
	// house:getName()
	House* house = getUserdata<House>(L, 1);
	if (house) {
		pushString(L, house->getName());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaHouseGetTown(lua_State* L)
{
	// house:getTown()
	House* house = getUserdata<House>(L, 1);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	Town* town = g_game.map.towns.getTown(house->getTownId());
	if (town) {
		pushUserdata<Town>(L, town);
		setMetatable(L, -1, "Town");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaHouseGetExitPosition(lua_State* L)
{
	// house:getExitPosition()
	House* house = getUserdata<House>(L, 1);
	if (house) {
		pushPosition(L, house->getEntryPosition());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaHouseGetRent(lua_State* L)
{
	// house:getRent()
	House* house = getUserdata<House>(L, 1);
	if (house) {
		lua_pushnumber(L, house->getRent());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaHouseSetRent(lua_State* L)
{
	// house:setRent(rent)
	uint32_t rent = getNumber<uint32_t>(L, 2);
	House* house = getUserdata<House>(L, 1);
	if (house) {
		house->setRent(rent);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaHouseGetPaidUntil(lua_State* L)
{
	// house:getPaidUntil()
	House* house = getUserdata<House>(L, 1);
	if (house) {
		lua_pushnumber(L, house->getPaidUntil());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaHouseSetPaidUntil(lua_State* L)
{
	// house:setPaidUntil(timestamp)
	time_t timestamp = getNumber<time_t>(L, 2);
	House* house = getUserdata<House>(L, 1);
	if (house) {
		house->setPaidUntil(timestamp);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaHouseGetPayRentWarnings(lua_State* L)
{
	// house:getPayRentWarnings()
	House* house = getUserdata<House>(L, 1);
	if (house) {
		lua_pushnumber(L, house->getPayRentWarnings());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaHouseSetPayRentWarnings(lua_State* L)
{
	// house:setPayRentWarnings(warnings)
	uint32_t warnings = getNumber<uint32_t>(L, 2);
	House* house = getUserdata<House>(L, 1);
	if (house) {
		house->setPayRentWarnings(warnings);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaHouseGetOwnerName(lua_State* L)
{
	// house:getOwnerName()
	House* house = getUserdata<House>(L, 1);
	if (house) {
		pushString(L, house->getOwnerName());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaHouseGetOwnerAccountId(lua_State* L)
{
	// house:getOwnerAccountId()
	House* house = getUserdata<House>(L, 1);
	if (house) {
		lua_pushnumber(L, house->getOwnerAccountId());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaHouseGetOwnerGuid(lua_State* L)
{
	// house:getOwnerGuid()
	House* house = getUserdata<House>(L, 1);
	if (house) {
		lua_pushnumber(L, house->getOwner());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaHouseSetOwnerGuid(lua_State* L)
{
	// house:setOwnerGuid(guid[, updateDatabase = true])
	House* house = getUserdata<House>(L, 1);
	if (house) {
		uint32_t guid = getNumber<uint32_t>(L, 2);
		bool updateDatabase = getBoolean(L, 3, true);
		house->setOwner(guid, updateDatabase);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaHouseStartTrade(lua_State* L)
{
	// house:startTrade(player, tradePartner)
	House* house = getUserdata<House>(L, 1);
	Player* player = getUserdata<Player>(L, 2);
	Player* tradePartner = getUserdata<Player>(L, 3);

	if (!player || !tradePartner || !house) {
		lua_pushnil(L);
		return 1;
	}

	if (!Position::areInRange<2, 2, 0>(tradePartner->getPosition(), player->getPosition())) {
		lua_pushnumber(L, RETURNVALUE_TRADEPLAYERFARAWAY);
		return 1;
	}

	if (house->getOwner() != player->getGUID()) {
		lua_pushnumber(L, RETURNVALUE_YOUDONTOWNTHISHOUSE);
		return 1;
	}

	if (g_game.map.houses.getHouseByPlayerId(tradePartner->getGUID())) {
		lua_pushnumber(L, RETURNVALUE_TRADEPLAYERALREADYOWNSAHOUSE);
		return 1;
	}

	if (IOLoginData::hasBiddedOnHouse(tradePartner->getGUID())) {
		lua_pushnumber(L, RETURNVALUE_TRADEPLAYERHIGHESTBIDDER);
		return 1;
	}

	Item* transferItem = house->getTransferItem();
	if (!transferItem) {
		lua_pushnumber(L, RETURNVALUE_YOUCANNOTTRADETHISHOUSE);
		return 1;
	}

	transferItem->getParent()->setParent(player);
	if (!g_game.internalStartTrade(player, tradePartner, transferItem)) {
		house->resetTransferItem();
	}

	lua_pushnumber(L, RETURNVALUE_NOERROR);
	return 1;
}

int LuaScriptInterface::luaHouseGetBeds(lua_State* L)
{
	// house:getBeds()
	House* house = getUserdata<House>(L, 1);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	const auto& beds = house->getBeds();
	lua_createtable(L, beds.size(), 0);

	int index = 0;
	for (BedItem* bedItem : beds) {
		pushUserdata<Item>(L, bedItem);
		setItemMetatable(L, -1, bedItem);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaHouseGetBedCount(lua_State* L)
{
	// house:getBedCount()
	House* house = getUserdata<House>(L, 1);
	if (house) {
		lua_pushnumber(L, house->getBedCount());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaHouseGetDoors(lua_State* L)
{
	// house:getDoors()
	House* house = getUserdata<House>(L, 1);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	const auto& doors = house->getDoors();
	lua_createtable(L, doors.size(), 0);

	int index = 0;
	for (Door* door : doors) {
		pushUserdata<Item>(L, door);
		setItemMetatable(L, -1, door);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaHouseGetDoorCount(lua_State* L)
{
	// house:getDoorCount()
	House* house = getUserdata<House>(L, 1);
	if (house) {
		lua_pushnumber(L, house->getDoors().size());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaHouseGetDoorIdByPosition(lua_State* L)
{
	// house:getDoorIdByPosition(position)
	House* house = getUserdata<House>(L, 1);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	Door* door = house->getDoorByPosition(getPosition(L, 2));
	if (door) {
		lua_pushnumber(L, door->getDoorId());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaHouseGetTiles(lua_State* L)
{
	// house:getTiles()
	House* house = getUserdata<House>(L, 1);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	const auto& tiles = house->getTiles();
	lua_createtable(L, tiles.size(), 0);

	int index = 0;
	for (Tile* tile : tiles) {
		pushUserdata<Tile>(L, tile);
		setMetatable(L, -1, "Tile");
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaHouseGetItems(lua_State* L)
{
	// house:getItems()
	House* house = getUserdata<House>(L, 1);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	const auto& tiles = house->getTiles();
	lua_newtable(L);

	int index = 0;
	for (Tile* tile : tiles) {
		TileItemVector* itemVector = tile->getItemList();
		if(itemVector) {
			for(Item* item : *itemVector) {
				pushUserdata<Item>(L, item);
				setItemMetatable(L, -1, item);
				lua_rawseti(L, -2, ++index);
			}
		}
	}
	return 1;
}

int LuaScriptInterface::luaHouseGetTileCount(lua_State* L)
{
	// house:getTileCount()
	House* house = getUserdata<House>(L, 1);
	if (house) {
		lua_pushnumber(L, house->getTiles().size());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaHouseCanEditAccessList(lua_State* L)
{
	// house:canEditAccessList(listId, player)
	House* house = getUserdata<House>(L, 1);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	uint32_t listId = getNumber<uint32_t>(L, 2);
	Player* player = getPlayer(L, 3);

	pushBoolean(L, house->canEditAccessList(listId, player));
	return 1;
}

int LuaScriptInterface::luaHouseGetAccessList(lua_State* L)
{
	// house:getAccessList(listId)
	House* house = getUserdata<House>(L, 1);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	std::string list;
	uint32_t listId = getNumber<uint32_t>(L, 2);
	if (house->getAccessList(listId, list)) {
		pushString(L, list);
	} else {
		pushBoolean(L, false);
	}
	return 1;
}

int LuaScriptInterface::luaHouseSetAccessList(lua_State* L)
{
	// house:setAccessList(listId, list)
	House* house = getUserdata<House>(L, 1);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	uint32_t listId = getNumber<uint32_t>(L, 2);
	const std::string& list = getString(L, 3);
	house->setAccessList(listId, list);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaHouseIsInAccessList(lua_State* L)
{
	// house:isInAccessList(player, listId)
	House* house = getUserdata<House>(L, 1);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	Player* player = getUserdata<Player>(L, 2);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	if (house->getHouseAccessLevel(player) >= HOUSE_SUBOWNER) {
		pushBoolean(L, true);
		return 1;
	}

	uint32_t listId = getNumber<uint32_t>(L, 3);
	pushBoolean(L, house->isInAccessList(player, listId));
	return 1;
}

int LuaScriptInterface::luaHouseGetAccessLevel(lua_State* L)
{
	// house:getAccessLevel(player)
	House* house = getUserdata<House>(L, 1);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	Player* player = getUserdata<Player>(L, 2);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	lua_pushnumber(L, house->getHouseAccessLevel(player));
	return 1;
}

int LuaScriptInterface::luaHouseKickPlayer(lua_State* L)
{
	// house:kickPlayer(player, targetPlayer)
	House* house = getUserdata<House>(L, 1);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	pushBoolean(L, house->kickPlayer(getPlayer(L, 2), getPlayer(L, 3)));
	return 1;
}

int LuaScriptInterface::luaHouseSave(lua_State* L)
{
	// house:save()
	House* house = getUserdata<House>(L, 1);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	pushBoolean(L, IOMapSerialize::saveHouse(house));
	return 1;
}
