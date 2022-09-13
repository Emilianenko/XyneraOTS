// Copyright 2022 Xynera.net. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#ifndef FS_REWARDBAG_H
#define FS_REWARDBAG_H

#include "configmanager.h"
#include "container.h"
#include "cylinder.h"
#include "item.h"

extern ConfigManager g_config;

// RewardBag
// if has rewardId, it looks for matching bag in player's reward chest
// reveals a copy of reward chest container to the player
class RewardBag final : public Container
{
	public:
		explicit RewardBag(uint16_t type);

		// non-copyable
		RewardBag(const RewardBag&) = delete;
		RewardBag& operator=(const RewardBag&) = delete;

		RewardBag* getRewardBag() override final {
			return this;
		}
		const RewardBag* getRewardBag() const override final {
			return this;
		}

		RewardBag* clone() const override final;

		uint32_t getRewardId() const {
			return rewardId;
		}
		void setRewardId(uint32_t rewardId) {
			this->rewardId = rewardId;
		}

		int64_t getCreationTime() {
			return createdAt;
		}
		void setCreationTime(int64_t creationTime) {
			this->createdAt = creationTime;
		}
		bool isExpired() {
			// bag is empty = expired
			if (getItemHoldingCount() == 0) {
				return true;
			}

			// no timestamp = keep forever
			if (createdAt == 0) {
				return false;
			}

			return createdAt + g_config.getNumber(ConfigManager::REWARD_BAG_DURATION) * 1000 < OTSYS_TIME();
		}

		// each time a boss dies, a new id is generated
		// rewardId of a bag in a corpse equals rewardId of a bag in the reward chest
		// players without matching reward chest bag will not be able to open the corpse bag
		static uint32_t lastSavedRewardId;
		static uint32_t rewardAutoId;

		// copies of reward bags are marked with player id
		uint32_t getSpectatorId() {
			return spectatorId;
		}
		void setSpectatorId(uint32_t spectatorId) {
			this->spectatorId = spectatorId;
		}

		//cylinder implementations
		ReturnValue queryAdd(int32_t index, const Thing& thing, uint32_t count,
			uint32_t flags, Creature* actor = nullptr) const override;
		ReturnValue queryMaxCount(int32_t index, const Thing& thing, uint32_t count,
			uint32_t& maxQueryCount, uint32_t flags) const override;
		Cylinder* queryDestination(int32_t& index, const Thing& thing, Item** destItem,
			uint32_t& flags) override;

		void addThing(Thing* thing) override;
		void addThing(int32_t index, Thing* thing) override;

		void updateThing(Thing* thing, uint16_t itemId, uint32_t count) override;
		void replaceThing(uint32_t index, Thing* thing) override;

		void removeThing(Thing* thing, uint32_t count) override;

		// serialization
		Attr_ReadValue readAttr(AttrTypes_t attr, PropStream& propStream) override;
		void serializeAttr(PropWriteStream& propWriteStream) const override;

		// reward id generator
		static uint32_t generateRewardId();

	private:
		uint32_t rewardId = 0;
		int64_t createdAt = 0;
		uint32_t spectatorId = 0;
};

using RewardChest_ptr = std::shared_ptr<RewardChest>;

class RewardChest final : public Container
{
	public:
		explicit RewardChest(uint16_t type);

		// non-copyable
		RewardChest(const RewardChest&) = delete;
		RewardChest& operator=(const RewardChest&) = delete;

		RewardChest* getRewardChest() override {
			return this;
		}
		const RewardChest* getRewardChest() const override {
			return this;
		}

		// cylinder
		ReturnValue queryAdd(int32_t index, const Thing& thing, uint32_t count,
			uint32_t flags, Creature* actor = nullptr) const override;

		uint32_t getSpectatorId() {
			return spectatorId;
		}
		void setSpectatorId(uint32_t spectatorId) {
			this->spectatorId = spectatorId;
		}

	private:
		uint32_t spectatorId = 0;
};

#endif
