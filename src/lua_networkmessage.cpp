// Copyright 2022 Xynera.net. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "luascript.h"

#include "item.h"
#include "items.h"
#include "networkmessage.h"
#include "player.h"

// NetworkMessage
int LuaScriptInterface::luaNetworkMessageCreate(lua_State* L)
{
	// NetworkMessage()
	pushUserdata<NetworkMessage>(L, new NetworkMessage);
	setMetatable(L, -1, "NetworkMessage");
	return 1;
}

int LuaScriptInterface::luaNetworkMessageDelete(lua_State* L)
{
	NetworkMessage** messagePtr = getRawUserdata<NetworkMessage>(L, 1);
	if (messagePtr && *messagePtr) {
		delete *messagePtr;
		*messagePtr = nullptr;
	}
	return 0;
}

int LuaScriptInterface::luaNetworkMessageGetByte(lua_State* L)
{
	// networkMessage:getByte()
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		lua_pushnumber(L, message->getByte());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageGetU16(lua_State* L)
{
	// networkMessage:getU16()
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		lua_pushnumber(L, message->get<uint16_t>());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageGetU32(lua_State* L)
{
	// networkMessage:getU32()
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		lua_pushnumber(L, message->get<uint32_t>());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageGetU64(lua_State* L)
{
	// networkMessage:getU64()
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		lua_pushnumber(L, message->get<uint64_t>());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageGetI8(lua_State* L)
{
	// networkMessage:getI8()
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		lua_pushnumber(L, message->get<int8_t>());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageGetI16(lua_State* L)
{
	// networkMessage:getI16()
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		lua_pushnumber(L, message->get<int16_t>());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageGetI32(lua_State* L)
{
	// networkMessage:getI32()
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		lua_pushnumber(L, message->get<int32_t>());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageGetI64(lua_State* L)
{
	// networkMessage:getI64()
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		lua_pushnumber(L, message->get<int64_t>());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageGetString(lua_State* L)
{
	// networkMessage:getString()
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		pushString(L, message->getString());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageGetPosition(lua_State* L)
{
	// networkMessage:getPosition()
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		pushPosition(L, message->getPosition());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageAddByte(lua_State* L)
{
	// networkMessage:addByte(number)
	uint8_t number = getNumber<uint8_t>(L, 2);
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		message->addByte(number);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageAddU16(lua_State* L)
{
	// networkMessage:addU16(number)
	uint16_t number = getNumber<uint16_t>(L, 2);
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		message->add<uint16_t>(number);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageAddU32(lua_State* L)
{
	// networkMessage:addU32(number)
	uint32_t number = getNumber<uint32_t>(L, 2);
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		message->add<uint32_t>(number);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageAddU64(lua_State* L)
{
	// networkMessage:addU64(number)
	uint64_t number = getNumber<uint64_t>(L, 2);
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		message->add<uint64_t>(number);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageAddI8(lua_State* L)
{
	// networkMessage:addI8(number)
	int8_t number = getNumber<int8_t>(L, 2);
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		message->add<int8_t>(number);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageAddI16(lua_State* L)
{
	// networkMessage:addI16(number)
	int16_t number = getNumber<int16_t>(L, 2);
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		message->add<int16_t>(number);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageAddI32(lua_State* L)
{
	// networkMessage:addI32(number)
	int32_t number = getNumber<int32_t>(L, 2);
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		message->add<int32_t>(number);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageAddI64(lua_State* L)
{
	// networkMessage:addI64(number)
	int64_t number = getNumber<int64_t>(L, 2);
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		message->add<int64_t>(number);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageAddString(lua_State* L)
{
	// networkMessage:addString(string)
	const std::string& string = getString(L, 2);
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		message->addString(string);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageAddPosition(lua_State* L)
{
	// networkMessage:addPosition(position)
	const Position& position = getPosition(L, 2);
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		message->addPosition(position);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageAddDouble(lua_State* L)
{
	// networkMessage:addDouble(number)
	double number = getNumber<double>(L, 2);
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		message->addDouble(number);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageAddItem(lua_State* L)
{
	// networkMessage:addItem(item)
	Item* item = getUserdata<Item>(L, 2);
	if (!item) {
		reportErrorFunc(L, getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		message->addItem(item);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageAddItemId(lua_State* L)
{
	// networkMessage:addItemId(itemId)
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (!message) {
		lua_pushnil(L);
		return 1;
	}

	uint16_t itemId;
	if (isNumber(L, 2)) {
		itemId = getNumber<uint16_t>(L, 2);
	} else {
		itemId = Item::items.getItemIdByName(getString(L, 2));
		if (itemId == 0) {
			lua_pushnil(L);
			return 1;
		}
	}

	message->addItemId(itemId);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaNetworkMessageAddItemType(lua_State* L)
{
	// networkMessage:addItemType(itemType)
	ItemType* itemType = getUserdata<ItemType>(L, 2);
	uint16_t itemId = itemType && itemType->clientId != 0 ? itemType->id : 100;

	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		message->addItem(itemId, 0);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageReset(lua_State* L)
{
	// networkMessage:reset()
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		message->reset();
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageSeek(lua_State* L)
{
	// networkMessage:seek(position)
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message && isNumber(L, 2)) {
		pushBoolean(L, message->setBufferPosition(getNumber<uint16_t>(L, 2)));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageTell(lua_State* L)
{
	// networkMessage:tell()
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		lua_pushnumber(L, message->getBufferPosition() - message->INITIAL_BUFFER_POSITION);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageLength(lua_State* L)
{
	// networkMessage:len()
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		lua_pushnumber(L, message->getLength());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageSkipBytes(lua_State* L)
{
	// networkMessage:skipBytes(number)
	int16_t number = getNumber<int16_t>(L, 2);
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		message->skipBytes(number);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageSendToPlayer(lua_State* L)
{
	// networkMessage:sendToPlayer(player)
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (!message) {
		lua_pushnil(L);
		return 1;
	}

	Player* player = getPlayer(L, 2);
	if (player) {
		player->sendNetworkMessage(*message);
		pushBoolean(L, true);
	} else {
		reportErrorFunc(L, getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		lua_pushnil(L);
	}
	return 1;
}
