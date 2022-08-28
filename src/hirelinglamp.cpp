// Copyright 2022 Xynera.net. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "hirelinglamp.h"

#include "game.h"
#include "outfit.h"

extern Game g_game;
struct Outfit;
Attr_ReadValue HirelingLamp::readAttr(AttrTypes_t attr, PropStream& propStream)
{
	if (attr == ATTR_HIRELINGDATA) {
		// hireling name
		std::string hirelingName;
		if (!propStream.readString(hirelingName)) {
			return ATTR_READ_ERROR;
		}
		this->hirelingName = hirelingName;

		// check all attrs before loading
		if (propStream.size() < 22) {
			return ATTR_READ_ERROR;
		}

		uint8_t sex = 0;
		Direction direction = DIRECTION_SOUTH;
		Outfit_t newOutfit;
		int32_t flags = 0;
		uint8_t unpacked = 0;

		// sex
		propStream.read<uint8_t>(sex);
		this->sex = sex;

		// direction
		uint8_t newDirection;
		propStream.read<uint8_t>(newDirection);
		direction = static_cast<Direction>(newDirection);
		this->direction = direction;

		// outfit
		propStream.read<uint16_t>(newOutfit.lookType);
		propStream.read<uint16_t>(newOutfit.lookTypeEx);
		propStream.read<uint8_t>(newOutfit.lookHead);
		propStream.read<uint8_t>(newOutfit.lookBody);
		propStream.read<uint8_t>(newOutfit.lookLegs);
		propStream.read<uint8_t>(newOutfit.lookFeet);
		propStream.read<uint8_t>(newOutfit.lookAddons);
		propStream.read<uint16_t>(newOutfit.lookMount);
		propStream.read<uint8_t>(newOutfit.lookMountHead);
		propStream.read<uint8_t>(newOutfit.lookMountBody);
		propStream.read<uint8_t>(newOutfit.lookMountLegs);
		propStream.read<uint8_t>(newOutfit.lookMountFeet);
		this->outfit = newOutfit;

		// flags
		propStream.read<int32_t>(flags);
		this->flags = flags;

		// unpacked
		propStream.read<uint8_t>(unpacked);
		this->unpacked = unpacked != 0;

		return ATTR_READ_CONTINUE;
	}

	return Item::readAttr(attr, propStream);
}

void HirelingLamp::serializeAttr(PropWriteStream& propWriteStream) const
{
	// header
	propWriteStream.write<uint8_t>(ATTR_HIRELINGDATA);

	// properties
	propWriteStream.writeString(hirelingName);
	propWriteStream.write<uint8_t>(sex);
	propWriteStream.write<uint8_t>(static_cast<uint8_t>(direction));

	// outfit
	propWriteStream.write<uint16_t>(outfit.lookType);
	propWriteStream.write<uint16_t>(outfit.lookTypeEx);
	propWriteStream.write<uint8_t>(outfit.lookHead);
	propWriteStream.write<uint8_t>(outfit.lookBody);
	propWriteStream.write<uint8_t>(outfit.lookLegs);
	propWriteStream.write<uint8_t>(outfit.lookFeet);
	propWriteStream.write<uint8_t>(outfit.lookAddons);
	propWriteStream.write<uint16_t>(outfit.lookMount);
	propWriteStream.write<uint8_t>(outfit.lookMountHead);
	propWriteStream.write<uint8_t>(outfit.lookMountBody);
	propWriteStream.write<uint8_t>(outfit.lookMountLegs);
	propWriteStream.write<uint8_t>(outfit.lookMountFeet);

	// more properties
	propWriteStream.write<int32_t>(flags);
	propWriteStream.write<uint8_t>(unpacked ? 1 : 0);

	Item::serializeAttr(propWriteStream);
}
