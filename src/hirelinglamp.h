// Copyright 2022 Xynera.net. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#ifndef FS_HIRELINGLAMP_H
#define FS_HIRELINGLAMP_H

#include "item.h"

#include "game.h"
#include "npc.h"

class HirelingLamp final : public Item
{
	public:
		explicit HirelingLamp(uint16_t type) : Item(type) {};

		HirelingLamp* getHirelingLamp() override {
			return this;
		}
		const HirelingLamp* getHirelingLamp() const override {
			return this;
		}

		Attr_ReadValue readAttr(AttrTypes_t attr, PropStream& propStream) override;
		void serializeAttr(PropWriteStream& propWriteStream) const override;

		void setHirelingName(const std::string& hirelingName) {
			this->hirelingName = hirelingName;
		}
		const std::string& getHirelingName() {
			return hirelingName;
		}

		void setOutfit(const Outfit_t& outfit) {
			this->outfit = outfit;
		}
		const Outfit_t getOutfit() const {
			return outfit;
		}

		uint8_t getSex() const {
			return sex;
		}
		void setSex(uint8_t sex) {
			this->sex = sex;
		};

		bool hasFlag(int32_t flag) const {
			return (this->flags & flag) != 0;
		}
		void setFlagValue(int32_t flag, bool value) {
			if (value) {
				this->flags |= flag;
				return;
			}
			this->flags &= ~flag;
		}
		int32_t getFlags() {
			return flags;
		}
		void setFlags(int32_t flags) {
			this->flags = flags;
		}

		const Direction getDirection() const {
			return direction;
		}
		void setDirection(Direction direction) {
			this->direction = direction;
		}

		bool isUnpacked() const {
			return unpacked;
		}
		void setUnpacked(bool newValue) {
			this->unpacked = newValue;
		}

		void importNPC(const Npc* npc) {
			this->hirelingName = npc->getName();
			this->sex = npc->getSex();
			this->direction = npc->getDirection();
			this->outfit = npc->getCurrentOutfit();
			this->flags = g_game.getHirelingFeatures(npc->getOwner()); // pull from GUID->flags map (pass guid in argument)
			this->unpacked = true;
		}

		void exportNPC(Npc* npc) {
			if (!hirelingName.empty()) {
				npc->setName(hirelingName);
			}
			npc->setSex(static_cast<PlayerSex_t>(sex));
			npc->setDirection(direction);
			npc->setCurrentOutfit(outfit);
			// npc->flags // handled by another function
			npc->setSpeechBubble(SPEECHBUBBLE_HIRELING);
			npc->setPhantom(true);
			this->unpacked = false;
		}
	protected:
		Outfit_t outfit;
	private:
		std::string hirelingName;

		Direction direction = DIRECTION_SOUTH;

		int32_t flags = 0; // enabled features
		uint8_t sex = 0;

		bool unpacked = false;
};

#endif
