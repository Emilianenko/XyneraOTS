// Copyright 2022 Xynera.net. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#ifndef FS_IMBUING_H
#define FS_IMBUING_H

enum ImbuingIcons_t : uint8_t {
	// icon empty slot
	IMBUEMENT_NONE = 0,

	// icon critical
	IMBUEMENT_CRIT_1 = 1,
	IMBUEMENT_CRIT_2 = 2,
	IMBUEMENT_CRIT_3 = 3,

	// icon element damage
	IMBUEMENT_DAMAGE_DEATH_1 = 4,
	IMBUEMENT_DAMAGE_DEATH_2 = 5,
	IMBUEMENT_DAMAGE_DEATH_3 = 6,
	IMBUEMENT_DAMAGE_EARTH_1 = 7,
	IMBUEMENT_DAMAGE_EARTH_2 = 8,
	IMBUEMENT_DAMAGE_EARTH_3 = 9,
	IMBUEMENT_DAMAGE_ENERGY_1 = 10,
	IMBUEMENT_DAMAGE_ENERGY_2 = 11,
	IMBUEMENT_DAMAGE_ENERGY_3 = 12,
	IMBUEMENT_DAMAGE_FIRE_1 = 13,
	IMBUEMENT_DAMAGE_FIRE_2 = 14,
	IMBUEMENT_DAMAGE_FIRE_3 = 15,
	IMBUEMENT_DAMAGE_HOLY_1 = 16,
	IMBUEMENT_DAMAGE_HOLY_2 = 17,
	IMBUEMENT_DAMAGE_HOLY_3 = 18,
	IMBUEMENT_DAMAGE_ICE_1 = 19,
	IMBUEMENT_DAMAGE_ICE_2 = 20,
	IMBUEMENT_DAMAGE_ICE_3 = 21,
	IMBUEMENT_DAMAGE_PHYSICAL_1 = 22,
	IMBUEMENT_DAMAGE_PHYSICAL_2 = 23,
	IMBUEMENT_DAMAGE_PHYSICAL_3 = 24,

	// icon element protection
	IMBUEMENT_PROTECTION_DEATH_1 = 25,
	IMBUEMENT_PROTECTION_DEATH_2 = 26,
	IMBUEMENT_PROTECTION_DEATH_3 = 27,
	IMBUEMENT_PROTECTION_EARTH_1 = 28,
	IMBUEMENT_PROTECTION_EARTH_2 = 29,
	IMBUEMENT_PROTECTION_EARTH_3 = 30,
	IMBUEMENT_PROTECTION_ENERGY_1 = 31,
	IMBUEMENT_PROTECTION_ENERGY_2 = 32,
	IMBUEMENT_PROTECTION_ENERGY_3 = 33,
	IMBUEMENT_PROTECTION_FIRE_1 = 34,
	IMBUEMENT_PROTECTION_FIRE_2 = 35,
	IMBUEMENT_PROTECTION_FIRE_3 = 36,
	IMBUEMENT_PROTECTION_HOLY_1 = 37,
	IMBUEMENT_PROTECTION_HOLY_2 = 38,
	IMBUEMENT_PROTECTION_HOLY_3 = 39,
	IMBUEMENT_PROTECTION_ICE_1 = 40,
	IMBUEMENT_PROTECTION_ICE_2 = 41,
	IMBUEMENT_PROTECTION_ICE_3 = 42,
	IMBUEMENT_PROTECTION_PHYSICAL_1 = 43,
	IMBUEMENT_PROTECTION_PHYSICAL_2 = 44,
	IMBUEMENT_PROTECTION_PHYSICAL_3 = 45,

	// icon leech
	IMBUEMENT_LEECH_LIFE_1 = 46,
	IMBUEMENT_LEECH_LIFE_2 = 47,
	IMBUEMENT_LEECH_LIFE_3 = 48,
	IMBUEMENT_LEECH_MANA_1 = 49,
	IMBUEMENT_LEECH_MANA_2 = 50,
	IMBUEMENT_LEECH_MANA_3 = 51,

	// icon skill boost
	IMBUEMENT_BOOST_AXE_1 = 52,
	IMBUEMENT_BOOST_AXE_2 = 53,
	IMBUEMENT_BOOST_AXE_3 = 54,
	IMBUEMENT_BOOST_CLUB_1 = 55,
	IMBUEMENT_BOOST_CLUB_2 = 56,
	IMBUEMENT_BOOST_CLUB_3 = 57,
	IMBUEMENT_BOOST_DISTANCE_1 = 58,
	IMBUEMENT_BOOST_DISTANCE_2 = 59,
	IMBUEMENT_BOOST_DISTANCE_3 = 60,
	IMBUEMENT_BOOST_FIST_1 = 61,
	IMBUEMENT_BOOST_FIST_2 = 62,
	IMBUEMENT_BOOST_FIST_3 = 63,
	IMBUEMENT_BOOST_MAGIC_1 = 64,
	IMBUEMENT_BOOST_MAGIC_2 = 65,
	IMBUEMENT_BOOST_MAGIC_3 = 66,
	IMBUEMENT_BOOST_SHIELD_1 = 67,
	IMBUEMENT_BOOST_SHIELD_2 = 68,
	IMBUEMENT_BOOST_SHIELD_3 = 69,
	IMBUEMENT_BOOST_SWORD_1 = 70,
	IMBUEMENT_BOOST_SWORD_2 = 71,
	IMBUEMENT_BOOST_SWORD_3 = 72,

	// icon speed boost
	IMBUEMENT_BOOST_SPEED_1 = 73,
	IMBUEMENT_BOOST_SPEED_2 = 74,
	IMBUEMENT_BOOST_SPEED_3 = 75,

	// icon cap boost
	IMBUEMENT_BOOST_CAPACITY_1 = 76,
	IMBUEMENT_BOOST_CAPACITY_2 = 77,
	IMBUEMENT_BOOST_CAPACITY_3 = 78,

	// icon paral deflect
	IMBUEMENT_DEFLECT_PARALYZE_1 = 79,
	IMBUEMENT_DEFLECT_PARALYZE_2 = 80,
	IMBUEMENT_DEFLECT_PARALYZE_3 = 81,

	// 82-255: red square
	IMBUEMENT_ERROR = 255,

	// element damage calculation
	IMBUEMENT_DAMAGE_FIRST = IMBUEMENT_DAMAGE_DEATH_1,
	IMBUEMENT_DAMAGE_LAST  = IMBUEMENT_DAMAGE_PHYSICAL_3,
	IMBUEMENT_PROTECTION_FIRST = IMBUEMENT_PROTECTION_DEATH_1,
	IMBUEMENT_PROTECTION_LAST  = IMBUEMENT_PROTECTION_PHYSICAL_3,
};

enum ImbuingTypes {
	IMBUING_TYPE_NONE,
	IMBUING_TYPE_CRIT,
	IMBUING_TYPE_LEECH_MANA,
	IMBUING_TYPE_LEECH_HP,
	IMBUING_TYPE_DAMAGE,
	IMBUING_TYPE_PROTECTION,
	IMBUING_TYPE_SKILLBOOST,
	IMBUING_TYPE_SPEED,
	IMBUING_TYPE_CAPACITY,
	IMBUING_TYPE_DEFLECT_PARALYZE,

	IMBUING_TYPE_SCRIPT,
};

// metadata holder for imbuements and their stats
class ImbuementType {
	public:
		// name
		void setName(const std::string& name) {
			this->name = name;
		}
		const std::string& getName() const {
			return name;
		}

		// description
		void setDescription(const std::string& description) {
			this->description = description;
		}
		const std::string& getDescription() const {
			return description;
		}

		// type
		void setType(uint8_t type) {
			this->type = type;
		}
		uint8_t getType() {
			return type;
		}

		// iconId
		void setIconId(uint8_t iconId) {
			this->iconId = iconId;
		}
		uint8_t getIconId() {
			return iconId;
		}

		// primaryValue
		void setPrimaryValue(int32_t primaryValue) {
			this->primaryValue = primaryValue;
		}
		int32_t getPrimaryValue() {
			return primaryValue;
		}

		// secondaryValue
		void setSecondaryValue(int32_t secondaryValue) {
			this->secondaryValue = secondaryValue;
		}
		int32_t getSecondaryValue() {
			return secondaryValue;
		}

		// duration
		void setDuration(int32_t duration) {
			this->duration = duration;
		}
		int32_t getDuration() {
			return duration;
		}

		// outOfCombat
		void setOutOfCombat(bool outOfCombat) {
			this->outOfCombat = outOfCombat;
		}
		bool isOutOfCombat() {
			return outOfCombat;
		}

	private:
		std::string name;
		std::string description;
		uint8_t type = 0;
		uint8_t iconId = static_cast<uint8_t>(IMBUEMENT_ERROR); // red square for imbuements with undefined icon
		int32_t primaryValue = 0;
		int32_t secondaryValue = 0;
		int32_t duration = 0;
		bool outOfCombat = false;
};

// concrete imbuement on item
class Imbuement {
	public:
		Imbuement() = default;
		Imbuement(uint8_t slotId, uint8_t imbuId, int32_t duration, int64_t lastUpdated) : slotId(slotId), imbuId(imbuId), duration(duration), lastUpdated(lastUpdated) {}

		uint8_t getSlotId() const {
			return slotId;
		}
		uint8_t getImbuId() const {
			return imbuId;
		}
		int32_t getDuration() const {
			return duration;
		}
		int64_t getLastUpdateTime() const {
			return lastUpdated;
		}

		void update(bool consumeDuration) {
			int64_t now = OTSYS_TIME();
			if (consumeDuration) {
				this->duration = duration - static_cast<int32_t>((now - lastUpdated)/1000);
			}
			this->lastUpdated = now;
		}

	private:
		uint8_t slotId = 0;
		uint8_t imbuId = 0;
		int32_t duration = 0;
		int64_t lastUpdated = 0;
};

class Imbuements {
	public:
		Imbuements();

		// non-copyable
		Imbuements(const Imbuements&) = delete;
		Imbuements& operator=(const Imbuements&) = delete;
		ImbuementType* getImbuementType(uint8_t imbuId);

	private:
		std::unordered_map<uint8_t, ImbuementType> imbuementTypes;
};

#endif
