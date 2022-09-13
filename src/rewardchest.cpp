// Copyright 2022 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "rewardchest.h"

#include "game.h"

uint32_t RewardBag::lastSavedRewardId = 0;
uint32_t RewardBag::rewardAutoId = 0;

// begin chest methods
RewardChest::RewardChest(uint16_t type) :
	Container{ type, items[type].maxItems, false, true } {}

ReturnValue RewardChest::queryAdd(int32_t, const Thing& thing, uint32_t, uint32_t, Creature* actor) const
{
	// players can not throw items into reward chest
	if (actor) {
		return RETURNVALUE_CONTAINERNOTENOUGHROOM;
	}

	// allow if thing is item
	if (const Item* thingItem = thing.getItem()) {
		return RETURNVALUE_NOERROR;
	}

	return RETURNVALUE_NOTPOSSIBLE;
}
// end chest methods

RewardBag::RewardBag(uint16_t type) :
	Container{ type, items[type].maxItems, false, false } {}

RewardBag* RewardBag::clone() const
{
	RewardBag* clone = static_cast<RewardBag*>(Container::clone());
	clone->rewardId = rewardId;
	clone->createdAt = createdAt;
	return clone;
}

ReturnValue RewardBag::queryAdd(int32_t, const Thing& thing, uint32_t, uint32_t, Creature* actor) const
{
	// players can not throw items into reward bags
	if (actor) {
		return RETURNVALUE_CONTAINERNOTENOUGHROOM;
	}

	// allow if thing is item
	if (const Item* thingItem = thing.getItem()) {
		return RETURNVALUE_NOERROR;
	}

	return RETURNVALUE_NOTPOSSIBLE;
}

ReturnValue RewardBag::queryMaxCount(int32_t, const Thing&, uint32_t count, uint32_t& maxQueryCount, uint32_t) const
{
	maxQueryCount = std::max<uint32_t>(1, count);
	return RETURNVALUE_NOERROR;
}

Cylinder* RewardBag::queryDestination(int32_t&, const Thing&, Item**, uint32_t&)
{
	return this;
}

void RewardBag::addThing(Thing* thing)
{
	return addThing(0, thing);
}

void RewardBag::addThing(int32_t index, Thing* thing)
{
	// add items to bag only when the bag is not a player-specific copy
	Item* item = thing->getItem();
	if (item && spectatorId == 0) {
		Container::addThing(index, thing);
	}
}

void RewardBag::updateThing(Thing* thing, uint16_t itemId, uint32_t count)
{
	if (!thing) {
		// thing = nullptr
		return;
	}

	if (spectatorId != 0) {
		if (Player* rewardOwner = g_game.getPlayerByID(spectatorId)) {
			if (RewardBag* chestBag = rewardOwner->getRewardById(rewardId)) {
				// thing got replaced in opened bag, update reward chest bag
				Item* thingItem = thing->getItem();
				if (!thingItem) {
					// not applicable, continue with standard behaviour
					return Container::updateThing(thing, itemId, count);
				}

				int32_t thingIndex = getThingIndex(thing);
				if (thingIndex != INDEX_WHEREEVER) {
					// thing got replaced in opened bag, update reward chest bag
					chestBag->updateThing(chestBag->getItemByIndex(thingIndex), itemId, count);
				}
			}
		}
	}

	// continue with standard behaviour
	Container::updateThing(thing, itemId, count);
}

void RewardBag::replaceThing(uint32_t index, Thing* thing)
{
	if (!thing) {
		// thing = nullptr
		return;
	}

	if (spectatorId != 0) {
		if (Player* rewardOwner = g_game.getPlayerByID(spectatorId)) {
			if (RewardBag* chestBag = rewardOwner->getRewardById(rewardId)) {
				// thing got replaced in opened bag, update reward chest bag
				Item* thingItem = thing->getItem();
				if (!thingItem) {
					// not applicable, continue with standard behaviour
					return Container::replaceThing(index, thing);
				}

				int32_t thingIndex = getThingIndex(thing);
				if (thingIndex != INDEX_WHEREEVER) {
					// thing got replaced in opened bag, update reward chest bag
					chestBag->replaceThing(thingIndex, chestBag->getItemByIndex(thingIndex));
				}
			}
		}
	}

	// continue with standard behaviour
	Container::replaceThing(index, thing);
}

void RewardBag::removeThing(Thing* thing, uint32_t count)
{
	if (!thing) {
		// thing = nullptr
		return;
	}

	if (spectatorId != 0) {
		if (Player* rewardOwner = g_game.getPlayerByID(spectatorId)) {
			if (RewardBag* chestBag = rewardOwner->getRewardById(rewardId)) {
				Item* thingItem = thing->getItem();
				if (!thingItem) {
					// not applicable, continue with standard behaviour
					return Container::removeThing(thing, count);
				}

				int32_t thingIndex = getThingIndex(thing);
				if (thingIndex != INDEX_WHEREEVER) {
					// thing got removed in opened bag, update reward chest bag
					chestBag->removeThing(chestBag->getItemByIndex(thingIndex), count);
				}
			}
		}
	}

	// continue with standard behaviour
	Container::removeThing(thing, count);
}

Attr_ReadValue RewardBag::readAttr(AttrTypes_t attr, PropStream& propStream)
{
	if (attr == ATTR_REWARDBAG) {
		if (propStream.size() < 12) {
			return ATTR_READ_ERROR;
		}

		uint32_t tmpRewardId = 0;
		propStream.read<uint32_t>(tmpRewardId);
		setRewardId(tmpRewardId);

		int64_t creationTime = 0;
		propStream.read<int64_t>(creationTime);
		setCreationTime(creationTime);

		return ATTR_READ_CONTINUE;
	}

	return Container::readAttr(attr, propStream);
}

void RewardBag::serializeAttr(PropWriteStream& propWriteStream) const
{
	propWriteStream.write<uint8_t>(ATTR_REWARDBAG);
	propWriteStream.write<uint32_t>(rewardId);
	propWriteStream.write<int64_t>(createdAt);

	Container::serializeAttr(propWriteStream);
}

uint32_t RewardBag::generateRewardId() {
	return ++rewardAutoId;
}
