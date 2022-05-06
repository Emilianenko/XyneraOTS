-- requires ITEMSYSTEM module
ImbuingSystem = true -- enables the system

-- imbuements are consumed every minute with an offset to prevent lagging
ASYNC_IMBUEMENT_PLAYERS_PER_TURN = 10 -- how many players equipments should the system check at once?
ASYNC_IMBUEMENT_TURN_INTERVAL = 1000 -- time to wait before checking next x players

-- custom attribute ids
CUSTOM_ATTRIBUTE_IMBUEMENTS = 30000 -- imbuements info
CUSTOM_ATTRIBUTE_SOCKETCOUNT = 30001 -- custom socket count for item

-- enums (ordered by client icons)
IMBUEMENT_NONE = 0

IMBUEMENT_CRIT = 1

IMBUEMENT_DAMAGE_DEATH = 2
IMBUEMENT_DAMAGE_EARTH = 3
IMBUEMENT_DAMAGE_ENERGY = 4
IMBUEMENT_DAMAGE_FIRE = 5
IMBUEMENT_DAMAGE_HOLY = 6
IMBUEMENT_DAMAGE_ICE = 7
IMBUEMENT_DAMAGE_PHYSICAL = 8

IMBUEMENT_DAMAGE_FIRST = IMBUEMENT_DAMAGE_DEATH
IMBUEMENT_DAMAGE_LAST = IMBUEMENT_DAMAGE_PHYSICAL

IMBUEMENT_PROTECTION_DEATH = 9
IMBUEMENT_PROTECTION_EARTH = 10
IMBUEMENT_PROTECTION_ENERGY = 11
IMBUEMENT_PROTECTION_FIRE = 12
IMBUEMENT_PROTECTION_HOLY = 13
IMBUEMENT_PROTECTION_ICE = 14
IMBUEMENT_PROTECTION_PHYSICAL = 15

IMBUEMENT_PROTECTION_FIRST = IMBUEMENT_PROTECTION_DEATH
IMBUEMENT_PROTECTION_LAST = IMBUEMENT_PROTECTION_PHYSICAL

IMBUEMENT_LEECH_LIFE = 16
IMBUEMENT_LEECH_MANA = 17

IMBUEMENT_BOOST_AXE = 18
IMBUEMENT_BOOST_CLUB = 19
IMBUEMENT_BOOST_DISTANCE = 20
IMBUEMENT_BOOST_FIST = 21
IMBUEMENT_BOOST_MAGIC = 22
IMBUEMENT_BOOST_SHIELD = 23
IMBUEMENT_BOOST_SWORD = 24
IMBUEMENT_BOOST_SPEED = 25
IMBUEMENT_BOOST_CAPACITY = 26

IMBUEMENT_DEFLECT_PARALYZE = 27

IMBUEMENT_TYPE_NONE = 0
IMBUEMENT_TYPE_CRIT = 1
IMBUEMENT_TYPE_LEECH_HP = 2
IMBUEMENT_TYPE_LEECH_MP = 3
IMBUEMENT_TYPE_BOOST = 4
IMBUEMENT_TYPE_PROTECTION = 5
IMBUEMENT_TYPE_DAMAGE = 6
IMBUEMENT_TYPE_SPEED = 7
IMBUEMENT_TYPE_VIBRANCY = 8

-- condition subids for imbuements
SUBID_IMBU_CRIT = 6000
SUBID_IMBU_LEECH_HP = 6001
SUBID_IMBU_LEECH_MP = 6002
SUBID_IMBU_BOOST = 6003

-- condition resets
SUBID_IMBU_FIRST = 6000
SUBID_IMBU_LAST = 6003

-- slots to search for imbuements that tick out of combat
PassiveImbuementSlots = {CONST_SLOT_BACKPACK, CONST_SLOT_FEET}

-- default categories for regular imbuement types
local damageDefaults = {"weapons", "weapons_distance"}
local protectionDefaults = {"armors", "shields"}
local boostDefaults = {"helmets"}
local tierNames = {
	[1] = "Basic",
	[2] = "Intricate",
	[3] = "Powerful"
}

-- helper for magic level imbuement
local tier1ML = {32083}
local tier2ML = {32083, 36812, 31371}

local function isMLImbuable(player, item, imbuement, tier)
	if not item:getType():isHelmet() then
		return false
	end
	
	local vocStr = item:getType():getVocationString()
	if vocStr and (vocStr:find("sorcerer") or vocStr:find("druid")) then
		return true
	end
	
	local itemId = item:getId()
	return tier == 1 and table.contains(tier1ML, itemId) or tier == 2 and table.contains(tier2ML, itemId)
end

-- config
ImbuingTypes = {
	-- available rules:
	-- categories - blanket support for item category
	-- weaponTypes - support for specific weapon type
	-- items - support for specific item ids (eg. wands with crit)
	-- callback - calls function(player, item, imbuement, tier), if function returns true, item is imbuable
	
	-- crit boost
	[IMBUEMENT_CRIT] = {
		-- name config (tierName + this name)
		name = "Strike",
		
		-- determines the buff type
		type = IMBUEMENT_TYPE_CRIT,
		
		-- inspection description (one %d for amount, two if both amount and chance are active)
		description = "Critical extra damage: %d%%. Critical hit chance: %d%%.",

		-- upgrade strength config
		tiers = {
			[1] = {icon = 1, chance = 10, amount = 15, products = {[12400] = 20}},
			[2] = {icon = 2, chance = 10, amount = 25, products = {[12400] = 20, [11228] = 25}},
			[3] = {icon = 3, chance = 10, amount = 50, products = {[12400] = 20, [11228] = 25, [25384] = 5}},
		},
		
		-- eligibility config
		categories = {"weapons", "weapons_distance"},
		items = {30113, 30114, 31372, 31373, 33056, 36746, 36747, 36808}
	},
	
	-- damage conversion
	[IMBUEMENT_DAMAGE_DEATH] = {
		name = "Reap",
		type = IMBUEMENT_TYPE_DAMAGE,
		subType = COMBAT_DEATHDAMAGE, -- secondary value for buff type
		description = "Converts %d%% of physical damage to death damage.",
		tiers = {
			[1] = {icon = 4, amount = 10, products = {[12440] = 25}},
			[2] = {icon = 5, amount = 25, products = {[12440] = 25, [10564] = 20}},
			[3] = {icon = 6, amount = 50, products = {[12440] = 25, [10564] = 20, [11337] = 5}},
		},
		categories = damageDefaults
	},
	[IMBUEMENT_DAMAGE_EARTH] = {
		name = "Venom",
		type = IMBUEMENT_TYPE_DAMAGE,
		subType = COMBAT_EARTHDAMAGE,
		description = "Converts %d%% of physical damage to earth damage.",
		tiers = {
			[1] = {icon = 7, amount = 10, products = {[10603] = 25}},
			[2] = {icon = 8, amount = 25, products = {[10603] = 25, [10557] = 20}},
			[3] = {icon = 9, amount = 50, products = {[10603] = 25, [10557] = 20, [23565] = 2}},
		},
		categories = damageDefaults
	},
	[IMBUEMENT_DAMAGE_ENERGY] = {
		name = "Electrify",
		type = IMBUEMENT_TYPE_DAMAGE,
		subType = COMBAT_ENERGYDAMAGE,
		description = "Converts %d%% of physical damage to energy damage.",
		tiers = {
			[1] = {icon = 10, amount = 10, products = {[21310] = 25}},
			[2] = {icon = 11, amount = 25, products = {[21310] = 25, [24631] = 5}},
			[3] = {icon = 12, amount = 50, products = {[21310] = 25, [24631] = 5, [26164] = 1}},
		},
		categories = damageDefaults
	},
	[IMBUEMENT_DAMAGE_FIRE] = {
		name = "Scorch",
		type = IMBUEMENT_TYPE_DAMAGE,
		subType = COMBAT_FIREDAMAGE,
		description = "Converts %d%% of physical damage to fire damage.",
		tiers = {
			[1] = {icon = 13, amount = 10, products = {[10553] = 25}},
			[2] = {icon = 14, amount = 25, products = {[10553] = 25, [5920] = 5}},
			[3] = {icon = 15, amount = 50, products = {[10553] = 25, [5920] = 5, [5954] = 5}},
		},
		categories = damageDefaults
	},
	[IMBUEMENT_DAMAGE_HOLY] = {
		-- unused
		-- conversion to holy damage
		-- you can uncomment tiers to enable
		-- made up recipe: 25 colourful feathers, 20 dragon priests wandtips, 5 fafnar symbols
		name = "Purify",
		type = IMBUEMENT_TYPE_DAMAGE,
		subType = COMBAT_HOLYDAMAGE,
		description = "Converts %d%% of physical damage to holy damage.",
		--[[
		tiers = {
			[1] = {icon = 16, amount = 10, products = {[12470] = 25}},
			[2] = {icon = 17, amount = 25, products = {[12470] = 25, [11361] = 20}},
			[3] = {icon = 18, amount = 50, products = {[12470] = 25, [11361] = 20, [34099] = 5}},
		},
		]]
		categories = damageDefaults
	},
	[IMBUEMENT_DAMAGE_ICE] = {
		name = "Frost",
		type = IMBUEMENT_TYPE_DAMAGE,
		subType = COMBAT_ICEDAMAGE,
		description = "Converts %d%% of physical damage to ice damage.",
		tiers = {
			[1] = {icon = 19, amount = 10, products = {[10578] = 25}},
			[2] = {icon = 20, amount = 25, products = {[10578] = 25, [24170] = 10}},
			[3] = {icon = 21, amount = 50, products = {[10578] = 25, [24170] = 10, [10567] = 5}},
		},
		categories = damageDefaults
	},
	[IMBUEMENT_DAMAGE_PHYSICAL] = {
		-- unused
		-- the icon is white flame
		-- it does not make sense to convert physical to physical
		-- so it is coded to convert magic damage to physical instead
		-- and supported by wands only
		-- you can uncomment tiers to enable
		-- made up recipe: 25 globs of mercury, 10 werewolf fangs, 5 yielocks 
		name = "Wound",
		type = IMBUEMENT_TYPE_DAMAGE,
		subType = COMBAT_PHYSICALDAMAGE,
		description = "Converts %d%% of magic damage to physical damage.",
		--[[
		tiers = {
			[1] = {icon = 22, amount = 10, products = {[9966] = 25}},
			[2] = {icon = 23, amount = 25, products = {[9966] = 25, [24708] = 10}},
			[3] = {icon = 24, amount = 50, products = {[9966] = 25, [24708] = 10, [13942] = 5}},
		},
		]]
		categories = {"weapons_magic"}
	},

	-- element protection
	[IMBUEMENT_PROTECTION_DEATH] = {
		name = "Lich Shroud",
		type = IMBUEMENT_TYPE_PROTECTION,
		subType = COMBAT_DEATHDAMAGE,
		description = "Reduces incoming death damage by %d%%.",
		tiers = {
			[1] = {icon = 25, amount = 2, products = {[12422] = 25}},
			[2] = {icon = 26, amount = 5, products = {[12422] = 25, [24663] = 20}},
			[3] = {icon = 27, amount = 10, products = {[12422] = 25, [24663] = 20, [10577] = 5}},
		},
		categories = protectionDefaults
	},
	[IMBUEMENT_PROTECTION_EARTH] = {
		name = "Snake Skin",
		type = IMBUEMENT_TYPE_PROTECTION,
		subType = COMBAT_EARTHDAMAGE,
		description = "Reduces incoming earth damage by %d%%.",
		tiers = {
			[1] = {icon = 28, amount = 3, products = {[20103] = 25}},
			[2] = {icon = 29, amount = 8, products = {[20103] = 25, [10611] = 20}},
			[3] = {icon = 30, amount = 15, products = {[20103] = 25, [10611] = 20, [12658] = 10}},
		},
		categories = protectionDefaults
	},
	[IMBUEMENT_PROTECTION_ENERGY] = {
		name = "Cloud Fabric",
		type = IMBUEMENT_TYPE_PROTECTION,
		subType = COMBAT_ENERGYDAMAGE,
		description = "Reduces incoming energy damage by %d%%.",
		tiers = {
			[1] = {icon = 31, amount = 3, products = {[10561] = 25}},
			[2] = {icon = 32, amount = 8, products = {[10561] = 25, [15482] = 15}},
			[3] = {icon = 33, amount = 15, products = {[10561] = 25, [15482] = 15, [10582] = 10}},
		},
		categories = protectionDefaults
	},
	[IMBUEMENT_PROTECTION_FIRE] = {
		name = "Dragon Hide",
		type = IMBUEMENT_TYPE_PROTECTION,
		subType = COMBAT_FIREDAMAGE,
		description = "Reduces incoming fire damage by %d%%.",
		tiers = {
			[1] = {icon = 34, amount = 3, products = {[5877] = 25}},
			[2] = {icon = 35, amount = 8, products = {[5877] = 25, [18425] = 10}},
			[3] = {icon = 36, amount = 15, products = {[5877] = 25, [18425] = 10, [12614] = 5}},
		},
		categories = protectionDefaults
	},
	[IMBUEMENT_PROTECTION_HOLY] = {
		name = "Demon Presence",
		type = IMBUEMENT_TYPE_PROTECTION,
		subType = COMBAT_HOLYDAMAGE,
		description = "Reduces incoming holy damage by %d%%.",
		tiers = {
			[1] = {icon = 37, amount = 3, products = {[10566] = 25}},
			[2] = {icon = 38, amount = 8, products = {[10566] = 25, [10555] = 25}},
			[3] = {icon = 39, amount = 15, products = {[10566] = 25, [10555] = 25, [11221] = 20}},
		},
		categories = protectionDefaults
	},
	[IMBUEMENT_PROTECTION_ICE] = {
		name = "Quara Scale",
		type = IMBUEMENT_TYPE_PROTECTION,
		subType = COMBAT_ICEDAMAGE,
		description = "Reduces incoming ice damage by %d%%.",
		tiers = {
			[1] = {icon = 40, amount = 3, products = {[11212] = 25}},
			[2] = {icon = 41, amount = 8, products = {[11212] = 25, [11224] = 15}},
			[3] = {icon = 42, amount = 15, products = {[11212] = 25, [11224] = 15, [15425] = 10}},
		},
		categories = protectionDefaults
	},
	[IMBUEMENT_PROTECTION_PHYSICAL] = {
		-- unused
		-- you can uncomment tiers to enable
		-- made up recipe: 25 sea serpent scales, 15 scythe legs, 5 pieces of royal steel
		name = "Hardening",
		type = IMBUEMENT_TYPE_PROTECTION,
		subType = COMBAT_PHYSICALDAMAGE,
		description = "Reduces incoming physical damage by %d%%.",
		--[[
		tiers = {
			[1] = {icon = 43, amount = 3, products = {[10583] = 25}},
			[2] = {icon = 44, amount = 8, products = {[10583] = 25, [11229] = 15}},
			[3] = {icon = 45, amount = 15, products = {[10583] = 25, [11229] = 15, [5887] = 5}},
		},
		]]
		categories = protectionDefaults
	},

	-- leech
	[IMBUEMENT_LEECH_LIFE] = {
		name = "Vampirism",
		type = IMBUEMENT_TYPE_LEECH_HP,
		description = "Converts %d%% of damage to health with a chance of %d%%.",
		tiers = {
			[1] = {icon = 46, amount = 5, chance = 100, products = {[10602] = 25}},
			[2] = {icon = 47, amount = 10, chance = 100, products = {[10602] = 25, [10550] = 15}},
			[3] = {icon = 48, amount = 25, chance = 100, products = {[10602] = 25, [10550] = 15, [10580] = 5}},
		},
		categories = {"armors", "weapons", "weapons_distance", "weapons_magic"}
	},
	[IMBUEMENT_LEECH_MANA] = {
		name = "Void",
		type = IMBUEMENT_TYPE_LEECH_MP,
		description = "Converts %d%% of damage to mana with a chance of %d%%.",
		tiers = {
			[1] = {icon = 49, amount = 3, chance = 100, products = {[12448] = 25}},
			[2] = {icon = 50, amount = 5, chance = 100, products = {[12448] = 25, [22534] = 25}},
			[3] = {icon = 51, amount = 8, chance = 100, products = {[12448] = 25, [22534] = 25, [25386] = 5}},
		},
		categories = {"helmets", "weapons", "weapons_distance", "weapons_magic"}
	},

	-- skill boost
	[IMBUEMENT_BOOST_AXE] = {
		name = "Chop",
		type = IMBUEMENT_TYPE_BOOST,
		subType = CONDITION_PARAM_SKILL_AXE,
		description = "Axe fighting %+d.",
		tiers = {
			[1] = {icon = 52, amount = 1, products = {[11113] = 20}},
			[2] = {icon = 53, amount = 2, products = {[11113] = 20, [12403] = 25}},
			[3] = {icon = 54, amount = 4, products = {[11113] = 20, [12403] = 25, [23571] = 20}},
		},
		categories = boostDefaults,
		weaponTypes = {WEAPON_AXE}
	},
	[IMBUEMENT_BOOST_CLUB] = {
		name = "Bash",
		type = IMBUEMENT_TYPE_BOOST,
		subType = CONDITION_PARAM_SKILL_CLUB,
		description = "Club fighting %+d.",
		tiers = {
			[1] = {icon = 55, amount = 1, products = {[10574] = 20}},
			[2] = {icon = 56, amount = 2, products = {[10574] = 20, [24845] = 15}},
			[3] = {icon = 57, amount = 4, products = {[10574] = 20, [24845] = 15, [11322] = 10}},
		},
		categories = boostDefaults,
		weaponTypes = {WEAPON_CLUB}
	},
	[IMBUEMENT_BOOST_DISTANCE] = {
		name = "Precision",
		type = IMBUEMENT_TYPE_BOOST,
		subType = CONDITION_PARAM_SKILL_DISTANCE,
		description = "Distance fighting %+d.",
		tiers = {
			[1] = {icon = 58, amount = 1, products = {[12420] = 25}},
			[2] = {icon = 59, amount = 2, products = {[12420] = 25, [21311] = 20}},
			[3] = {icon = 60, amount = 4, products = {[12420] = 25, [21311] = 20, [11215] = 10}},
		},
		categories = boostDefaults,
		weaponTypes = {WEAPON_DISTANCE}
	},
	[IMBUEMENT_BOOST_FIST] = {
		-- unused
		-- you can uncomment tiers to enable
		-- made up recipe: 25 trollroots, 15 draken wristbands, 5 behemoth claws
		-- note: if you do not have any fist weapons in your server, only helmets will be imbuable
		name = "Punch",
		type = IMBUEMENT_TYPE_BOOST,
		subType = CONDITION_PARAM_SKILL_FIST,
		description = "Fist fighting %+d.",
		--[[
		tiers = {
			[1] = {icon = 61, amount = 1, products = {[12471] = 25}},
			[2] = {icon = 62, amount = 2, products = {[12471] = 25, [12615] = 15}},
			[3] = {icon = 63, amount = 4, products = {[12471] = 25, [12615] = 15, [5930] = 5}},
		},
		]]
		categories = boostDefaults,
		weaponTypes = {WEAPON_FIST}
	},
	[IMBUEMENT_BOOST_MAGIC] = {
		name = "Epiphany",
		type = IMBUEMENT_TYPE_BOOST,
		subType = CONDITION_PARAM_STAT_MAGICPOINTS,
		description = "Magic Level %+d.",
		tiers = {
			[1] = {icon = 64, amount = 1, products = {[10552] = 25}},
			[2] = {icon = 65, amount = 2, products = {[10552] = 25, [12408] = 15}},
			[3] = {icon = 66, amount = 4, products = {[10552] = 25, [12408] = 15, [11226] = 15}},
		},
		callback = isMLImbuable
	},
	[IMBUEMENT_BOOST_SHIELD] = {
		name = "Blockade",
		type = IMBUEMENT_TYPE_BOOST,
		subType = CONDITION_PARAM_SKILL_SHIELD,
		description = "Shielding %+d.",
		tiers = {
			[1] = {icon = 67, amount = 1, products = {[10558] = 20}},
			[2] = {icon = 68, amount = 2, products = {[10558] = 20, [12659] = 25}},
			[3] = {icon = 69, amount = 4, products = {[10558] = 20, [12659] = 25, [22533] = 25}},
		},
		categories = boostDefaults,
		weaponTypes = {WEAPON_SHIELD}
	},
	[IMBUEMENT_BOOST_SWORD] = {
		name = "Slash",
		type = IMBUEMENT_TYPE_BOOST,
		subType = CONDITION_PARAM_SKILL_SWORD,
		description = "Sword fighting %+d.",
		tiers = {
			[1] = {icon = 70, amount = 1, products = {[10608] = 25}},
			[2] = {icon = 71, amount = 2, products = {[10608] = 25, [23573] = 25}},
			[3] = {icon = 72, amount = 4, products = {[10608] = 25, [23573] = 25, [10571] = 5}},
		},
		categories = boostDefaults,
		weaponTypes = {WEAPON_SWORD}
	},
	
	-- stat boost
	[IMBUEMENT_BOOST_SPEED] = {
		name = "Swiftness",
		type = IMBUEMENT_TYPE_SPEED,
		description = "Speed %+d.",
		outOfCombat = true, -- also burns out of combat
		tiers = {
			[1] = {icon = 73, amount = 10, products = {[19738] = 15}},
			[2] = {icon = 74, amount = 15, products = {[19738] = 15, [11219] = 25}},
			[3] = {icon = 75, amount = 30, products = {[19738] = 15, [11219] = 25, [15484] = 20}},
		},
		categories = {"boots"}
	},
	[IMBUEMENT_BOOST_CAPACITY] = {
		name = "Featherweight",
		type = IMBUEMENT_TYPE_BOOST,
		subType = CONDITION_PARAM_STAT_CAPACITYPERCENT,
		description = "Capacity %+d%%.",
		outOfCombat = true,
		tiers = {
			[1] = {icon = 76, amount = 3, products = {[28350] = 20}},
			[2] = {icon = 77, amount = 8, products = {[28350] = 20, [28358] = 10}},
			[3] = {icon = 78, amount = 15, products = {[28350] = 20, [28358] = 10, [22539] = 5}},
		},
		categories = {"backpacks"}
	},

	-- paral deflect
	[IMBUEMENT_DEFLECT_PARALYZE] = {
		type = IMBUEMENT_TYPE_VIBRANCY,
		name = "Vibrancy",
		description = "Reduces the chance of getting paralysed by %d%%.",
		tiers = {
			[1] = {icon = 79, amount = 15, products = {[24709] = 20}},
			[2] = {icon = 80, amount = 25, products = {[24709] = 20, [26163] = 15}},
			[3] = {icon = 81, amount = 50, products = {[24709] = 20, [26163] = 15, [31223] = 5}},
		},
		categories = {"boots"}
	},
}

-- auto register out of combat imbuements to tick
PassiveImbuements = {}
for imbuId, imbuInfo in pairs(ImbuingTypes) do
	if imbuInfo.outOfCombat then
		PassiveImbuements[#PassiveImbuements+1] = imbuId
	end
end

-- generate quick damage/resistance references
ImbuDamages = {}
for i = IMBUEMENT_DAMAGE_FIRST, IMBUEMENT_DAMAGE_LAST do
	local imbuInfo = ImbuingTypes[i]
	local tiers = imbuInfo.tiers
	if tiers then
		ImbuDamages[i] = {}
		for tierId, tierData in pairs(tiers) do
			ImbuDamages[i][tierId] = {imbuInfo.subType, tierData.amount}
		end
	end
end
ImbuResistances = {}
for i = IMBUEMENT_PROTECTION_FIRST, IMBUEMENT_PROTECTION_LAST do
	local imbuInfo = ImbuingTypes[i]
	local tiers = imbuInfo.tiers
	if tiers then
		ImbuResistances[i] = {}
		for tierId, tierData in pairs(tiers) do
			ImbuResistances[i][tierId] = {imbuInfo.subType, tierData.amount}
		end
	end
end

function getImbuementIconByProps(properties)
	-- nil was passed, return empty socket
	if not properties then
		return 0
	end
	
	local type = tonumber(properties[1])
	if not type or type == IMBUEMENT_NONE then
		return 0
	end
	
	local tier = tonumber(properties[2])
	-- return red icon if default is unavailable
	return ImbuingTypes[type] and ImbuingTypes[type].tiers and ImbuingTypes[type].tiers[tier].icon or 255
end

function getImbuementName(type, tier, duration)
	type = tonumber(type)
	
	if type == IMBUEMENT_NONE then
		return "Empty Slot"
	end

	duration = tonumber(duration) or -1
	tier = tonumber(tier) or 0
	
	return string.format(
		"%s %s %s",
		tierNames[tier] or "Unknown",
		ImbuingTypes[type] and ImbuingTypes[type].name or "Untitled",
		duration > 0 and string.format("%d:%.2dh", math.floor(duration / 60), duration % 60) or "-:--h"
	)
end

-- load socket info on startup/reload
SocketMap = {}
if Equippables then
	for _, category in pairs(Equippables) do
		for itemId, itemData in pairs(category) do
			if itemData.sockets then
				SocketMap[itemId] = itemData.sockets
			end
		end
	end
end

-- NOT CONFIGURABLE
-- (changing these two variables after players already imbued their items will break them)
-- control characters to split imbuements info (characters that are unlikely to be used)
local socketSeparator = string.char(180)
local propertySeparator = string.char(184)

-- returns imbuing slots count for the item type
function ItemType:getSocketCount()
	return SocketMap[self:getId()] or 0
end

-- returns imbuing slots count for selected item
function Item:getSocketCount()
	local count = self:getCustomAttribute(CUSTOM_ATTRIBUTE_SOCKETCOUNT)
	return count or self:getType():getSocketCount()
end

-- deserializes and returns active imbuements
-- needs calling tonumber
function Item:getImbuements()
	local imbuStr = self:getCustomAttribute(CUSTOM_ATTRIBUTE_IMBUEMENTS)
	if not imbuStr then
		return {}
	end
	
	local response = {}
	for slotId, imbuement in pairs(imbuStr:split(socketSeparator)) do
		response[slotId] = imbuement and imbuement:split(propertySeparator)
	end
	
	return response
end

function serializeImbuements(imbuements)
	local imbuInfo = {}
	local maxn = table.maxn(imbuements)
	if maxn > 0 then
		for i = 1, maxn do
			local socket = imbuements[i]
			if socket and #socket > 0 then
				imbuInfo[#imbuInfo+1] = table.concat(socket, propertySeparator)
			else
				imbuInfo[#imbuInfo+1] = IMBUEMENT_NONE
			end
		end
	end

	return #imbuInfo > 0 and table.concat(imbuInfo, socketSeparator)
end

-- sets imbuement to selected socket
-- no validation - any stat can be added
-- overwrites if socket already occupied
function Item:setImbuement(type, tier, socketId, duration)
	local imbuements = self:getImbuements()
	imbuements[socketId] = {type, tier, duration}
	imbuements = serializeImbuements(imbuements)
	if imbuements then
		self:setCustomAttribute(CUSTOM_ATTRIBUTE_IMBUEMENTS, imbuements)
	else
		self:removeCustomAttribute(CUSTOM_ATTRIBUTE_IMBUEMENTS)
	end		
end

-- item info on shop lists
function ItemType:getImbuementsDescription()
	local sockets = SocketMap[self:getId()] or 0
	if sockets == 0 then
		return ""
	end

	local slots = {}
	for i = 1, sockets do
		slots[#slots + 1] = "Empty Slot"
	end
	
	return string.format("\nImbuements: (%s).", table.concat(slots, ", "))
end

-- item info on actual item
function Item:getImbuementsDescription()
	local imbuements = self:getImbuements()
	if not imbuements or #imbuements == 0 then
		-- all slots are empty, get info from ItemType
		return self:getType():getImbuementsDescription()
	end
	
	local socketCount = math.max(self:getSocketCount(), #imbuements)
	if socketCount == 0 then
		-- nothing to send
		return ""
	end
	
	local response = {}
	for i = 1, socketCount do
		if imbuements[i] then
			response[#response + 1] = getImbuementName(unpack(imbuements[i]))
		else
			response[#response + 1] = "Empty Slot"
		end
	end
	
	return #response > 0 and string.format("\nImbuements: (%s)", table.concat(response, ", ")) or ""
end

function getInspectImbuements(item, isVirtual)
	local response = {}
	local sendEmpty = true
	local socketCount = 0
	local imbuements
	
	if not isVirtual then
		imbuements = item:getImbuements()
		if imbuements and #imbuements ~= 0 then
			socketCount = math.max(item:getSocketCount(), #imbuements)
			if socketCount > 0 then
				sendEmpty = false
			end
		end			
	end

	if sendEmpty then
		socketCount = item:getSocketCount()
		if socketCount > 0 then
			for socketId = 1, socketCount do
				response[#response + 1] = {"Imbuement Slot " .. socketId, "empty"}
			end
		end
		
		return response
	end
	
	for socketId = 1, socketCount do
		local slotStr = "empty"
		
		if imbuements[socketId] then	
			local type = tonumber(imbuements[socketId][1]) or -1
			if type ~= IMBUEMENT_NONE then
			
				local imbuInfo = ImbuingTypes[type]
				local tier = tonumber(imbuements[socketId][2]) or 0
				local description = "no effect"
				
				-- name and description
				if imbuInfo then
					-- valid imbuement
					if imbuInfo.tiers then
						description = imbuInfo.description or "missing description"
						
						-- format desc
						local tierData = imbuInfo.tiers[tier]
						if tierData then
							if tierData.chance then
								if tierData.amount then
									description = string.format(description, tierData.amount, tierData.chance)
								else
									description = string.format(description, tierData.chance)
								end
							elseif tierData.amount then
								description = string.format(description, tierData.amount)
							end
						end
					else
						description = "disabled"
					end
					
					slotStr = string.format("%s %s", tierNames[tier] or "Unknown", imbuInfo.name or "Untitled")					
				else
					-- error type imbuement
					slotStr = string.format("error imbuement %d", type)
				end
				
				-- duration
				local duration = tonumber(imbuements[socketId][3]) or -1
				local durationStr = ", permanent"
				if duration > 0 then
					durationStr = string.format(
						", lasts %d:%.2dh%s",
						math.floor(duration / 60),
						duration % 60,
						imbuInfo and imbuInfo.outOfCombat and "" or " while fighting"
					)
				end
				
				-- OUTPUT
				slotStr = string.format("%s (%s)%s.", slotStr, description, durationStr)
			end
		end
		
		response[#response + 1] = {"Imbuement Slot " .. socketId, slotStr}
	end
	
	return response
end

-- adds imbuements icons to item inspection UI
function NetworkMessage:addImbuements(item, isVirtual)
	if isVirtual then
		local count = item:getSocketCount()
		self:addByte(count)
	
		if count > 0 then
			for i = 1, count do
				self:addU16(0)
			end
		end
		
		return
	end

	local imbuements = item:getImbuements()
	local count = math.max(item:getSocketCount(), #imbuements)

	self:addByte(count)
	if count > 0 then
		for i = 1, count do
			self:addU16(getImbuementIconByProps(imbuements[i]))
		end
	end
end

-- consumes out of combat imbuements
function Player:consumePassiveImbuements()
	local needUpdate = false
	for _, slotId in ipairs(PassiveImbuementSlots) do
		local slotItem = self:getSlotItem(slotId)
		if slotItem then
			local imbuements = slotItem:getImbuements()
			if #imbuements > 0 then
				for socketId, imbuement in ipairs(imbuements) do
					local imbuId = imbuement[1] and tonumber(imbuement[1]) or 0
					if table.contains(PassiveImbuements, imbuId) then
						local duration = tonumber(imbuement[3]) or -1
						if duration > 0 then
							if duration - 1 == 0 then
								local thisUpdate = self:internalDeEquipImbuement(slotItem, imbuId, tonumber(imbuement[2]) or 0)
								needUpdate = needUpdate or thisUpdate
								imbuements[socketId] = nil
							else
								imbuement[3] = duration - 1
								imbuements[socketId] = imbuement
							end
						end
					end
				end
				
				imbuements = serializeImbuements(imbuements)
				if imbuements then
					slotItem:setCustomAttribute(CUSTOM_ATTRIBUTE_IMBUEMENTS, imbuements)
				else
					slotItem:removeCustomAttribute(CUSTOM_ATTRIBUTE_IMBUEMENTS)
				end
			end
		end
	end
	
	if needUpdate then
		self:unloadImbuements()
		self:loadImbuements()
	end
end

function asyncConsumeImbuements(playerIds)
	local tail = table.maxn(playerIds)
	if tail > 0 then
		local head = math.max(1, tail - ASYNC_IMBUEMENT_PLAYERS_PER_TURN)
		for playerIndex = head, tail do
			local player = Player(playerIds[playerIndex])
			playerIds[playerIndex] = nil
			
			if player then
				player:consumePassiveImbuements()
			end
		end
		
		addEvent(asyncConsumeImbuements, ASYNC_IMBUEMENT_TURN_INTERVAL, playerIds)
	end
end

do
	local globalEvent = GlobalEvent("consumeImbuements")
	globalEvent:interval(60000)
	globalEvent.onThink = function(interval)
		local online = Game.getPlayers()
		local onlineIds = {}
		for _, player in pairs(online) do
			onlineIds[#onlineIds+1] = player:getId()
		end

		asyncConsumeImbuements(onlineIds)
		return true
	end
	
	globalEvent:register()
end

-- consume in-combat imbuements
function Player:consumeActiveImbuements(minutes)
	local needUpdate = false

	for slotId = CONST_SLOT_FIRST, CONST_SLOT_LAST do
		local slotItem = self:getSlotItem(slotId)
		if slotItem then
			local imbuements = slotItem:getImbuements()
			if #imbuements > 0 then
				for socketId, imbuement in ipairs(imbuements) do
					local imbuId = imbuement[1] and tonumber(imbuement[1]) or 0
					if not table.contains(PassiveImbuements, imbuId) then
						local duration = tonumber(imbuement[3]) or -1
						if duration > -1 then
							local newDuration = duration - minutes
							if newDuration < 1 then
								local thisUpdate = self:internalDeEquipImbuement(slotItem, imbuId, tonumber(imbuement[2]) or 0)
								needUpdate = needUpdate or thisUpdate
								imbuements[socketId] = nil
							else
								imbuement[3] = newDuration
								imbuements[socketId] = imbuement
							end
						end
					end
				end
				
				imbuements = serializeImbuements(imbuements)
				if imbuements then
					slotItem:setCustomAttribute(CUSTOM_ATTRIBUTE_IMBUEMENTS, imbuements)
				else
					slotItem:removeCustomAttribute(CUSTOM_ATTRIBUTE_IMBUEMENTS)
				end
			end
		end
	end
	
	if needUpdate then
		self:unloadImbuements()
		self:loadImbuements()
	end
end

do
	local ec = EventCallback
	ec.onUseStamina = function(self, staminaMinutes, rawSpentMinutes)
		self:consumeActiveImbuements(rawSpentMinutes)
		return staminaMinutes
	end
	
	ec:register()
end

-- store active player imbuements
if not PlayerImbuements then
	PlayerImbuements = {}
end

local specialSkills = {
	[IMBUEMENT_TYPE_CRIT] = {CONDITION_PARAM_SPECIALSKILL_CRITICALHITCHANCE, CONDITION_PARAM_SPECIALSKILL_CRITICALHITAMOUNT, SUBID_IMBU_CRIT},
	[IMBUEMENT_TYPE_LEECH_HP] = {CONDITION_PARAM_SPECIALSKILL_LIFELEECHCHANCE, CONDITION_PARAM_SPECIALSKILL_LIFELEECHAMOUNT, SUBID_IMBU_LEECH_HP},
	[IMBUEMENT_TYPE_LEECH_MP] = {CONDITION_PARAM_SPECIALSKILL_MANALEECHCHANCE, CONDITION_PARAM_SPECIALSKILL_MANALEECHAMOUNT, SUBID_IMBU_LEECH_MP}
}

function Player:loadImbuements()
	local activeBoosts = PlayerImbuements[self:getId()]
	if not activeBoosts then
		return
	end
	
	-- crit, leech
	for skillType, skillData in pairs(specialSkills) do
		if ImbuingTypes[skillType].tiers then
			local amount = 0
			local chance = 0
			
			for _, imbuement in pairs(activeBoosts[skillType]) do
				local tier = imbuement[2]
				local tierData = tier and ImbuingTypes[skillType].tiers[tier]
				if tier and tierData then
					chance = chance + tierData.chance
					amount = amount + tierData.amount
				end
			end
			
			chance = math.min(chance, 100)
			if chance > 0 and amount > 0 then
				local condition = Condition(CONDITION_ATTRIBUTES)
				condition:setParameter(skillData[1], chance)
				condition:setParameter(skillData[2], amount)
				condition:setParameter(CONDITION_PARAM_SUBID, skillData[3])
				condition:setParameter(CONDITION_PARAM_TICKS, -1)
				self:addCondition(condition)
			end
		end
	end
	
	-- stat/skill boosts
	local boosts = {}
	local boostCount = 0
	for _, imbuement in pairs(activeBoosts[IMBUEMENT_TYPE_BOOST]) do
		local imbuId = imbuement[1]
		local imbuData = ImbuingTypes[imbuId]
		if imbuData and imbuData.subType and imbuData.tiers then
			local tier = imbuement[2]
			local tierData = tier and imbuData.tiers[tier]
			if tier and tierData then
				boosts[imbuData.subType] = (boosts[imbuData.subType] or 0) + tierData.amount
				boostCount = boostCount + 1
			end
		end
	end
	
	if boostCount > 0 then
		local condition = Condition(CONDITION_ATTRIBUTES)
		for type, amount in pairs(boosts) do
			condition:setParameter(type, amount)
		end
		condition:setParameter(CONDITION_PARAM_SUBID, SUBID_IMBU_BOOST)
		condition:setParameter(CONDITION_PARAM_TICKS, -1)
		self:addCondition(condition)
	end
	
	-- speed
	local totalSpeed = 0
	for _, imbuement in pairs(activeBoosts[IMBUEMENT_TYPE_SPEED]) do
		local imbuId = imbuement[1]
		local imbuData = ImbuingTypes[imbuId]
		if imbuData and imbuData.tiers then
			local tier = imbuement[2]
			local tierData = tier and imbuData.tiers[tier]
			if tier and tierData then
				totalSpeed = totalSpeed + tierData.amount
			end
		end
	end
	
	if totalSpeed ~= 0 then
		self:changeSpeed(totalSpeed)
	end
end

function Player:unloadImbuements()
	-- unload buffs
	for subId = SUBID_IMBU_FIRST, SUBID_IMBU_LAST do
		self:removeCondition(CONDITION_ATTRIBUTES, CONDITIONID_COMBAT, subId)
	end
	
	-- unload speed
	local totalSpeed = 0
	for _, imbuement in pairs(PlayerImbuements[self:getId()][IMBUEMENT_TYPE_SPEED]) do
		local imbuId = imbuement[1]
		local imbuData = ImbuingTypes[imbuId]
		if imbuData and imbuData.tiers then
			local tier = imbuement[2]
			local tierData = tier and imbuData.tiers[tier]
			if tier and tierData then
				totalSpeed = totalSpeed + tierData.amount
			end
		end
	end
	
	if totalSpeed ~= 0 then
		self:changeSpeed(-totalSpeed)
	end
end

function Player:registerImbuements()
	local foundBuffs = {
		[IMBUEMENT_TYPE_CRIT] = {},
		[IMBUEMENT_TYPE_LEECH_HP] = {},
		[IMBUEMENT_TYPE_LEECH_MP] = {},
		[IMBUEMENT_TYPE_BOOST] = {},
		[IMBUEMENT_TYPE_PROTECTION] = {},
		[IMBUEMENT_TYPE_DAMAGE] = {},
		[IMBUEMENT_TYPE_SPEED] = {},
		[IMBUEMENT_TYPE_VIBRANCY] = {}
	}

	for slotId = CONST_SLOT_FIRST, CONST_SLOT_LAST do
		local slotItem = self:getSlotItem(slotId)
		if slotItem then
			for _, imbuement in pairs(slotItem:getImbuements()) do
				local imbuId = imbuement[1] and tonumber(imbuement[1]) or 0
				local imbuInfo = ImbuingTypes[imbuId]
				if imbuId ~= 0 and imbuInfo then
					local type = imbuInfo.type
					if imbuInfo.type then
						foundBuffs[type][#foundBuffs[type] + 1] = {imbuId, tonumber(imbuement[2])}
					end
				end
			end
		end
	end
	
	PlayerImbuements[self:getId()] = foundBuffs
	self:loadImbuements()
end

function Player:equipImbuements(item)
	local needUpdate = false
	local imbuements = item:getImbuements()

	for imbuIndex, imbuement in pairs(imbuements) do
		local imbuId = imbuement[1] and tonumber(imbuement[1]) or 0
		local imbuInfo = ImbuingTypes[imbuId]
		if imbuId ~= 0 and imbuInfo then
			local removed = false
			-- remove one minute of timed imbuements to prevent dodging the out of combat timer with equip/deequip
			if imbuInfo.outOfCombat then
				local duration = tonumber(imbuement[3])
				if duration > -1 then
					duration = duration - 1
					if duration > 0 then
						imbuements[imbuIndex] = {imbuement[1], imbuement[2], duration}
					else
						imbuements[imbuIndex] = nil
						removed = true
					end
				end
				item:setCustomAttribute(CUSTOM_ATTRIBUTE_IMBUEMENTS, serializeImbuements(imbuements))
			end
		
			local type = imbuInfo.type
			if imbuInfo.type then
				local tier = tonumber(imbuement[2])
				PlayerImbuements[self:getId()][type][#PlayerImbuements[self:getId()][type] + 1] = {imbuId, tier}
				if type == IMBUEMENT_TYPE_SPEED and not removed then
					local tierData = tier and imbuInfo.tiers[tier]
					if tier and tierData then
						self:changeSpeed(tierData.amount)
					end
				end
				
				if type ~= IMBUEMENT_TYPE_PROTECTION and type ~= IMBUEMENT_TYPE_DAMAGE then
					needUpdate = true
				end
			end
		end
	end
	
	if needUpdate then
		self:unloadImbuements()
		self:loadImbuements()
	end
end

function Player:internalRemoveImbuement(imbuId, tier)
	for imbuType, imbuements in pairs(PlayerImbuements[self:getId()]) do
		for index, imbuement in pairs(imbuements) do
			if imbuId == imbuement[1] and tier == imbuement[2] then
				table.remove(PlayerImbuements[self:getId()][imbuType], index)
				
				if imbuId == IMBUEMENT_BOOST_SPEED and ImbuingTypes[IMBUEMENT_BOOST_SPEED].tiers then
					self:changeSpeed(-ImbuingTypes[IMBUEMENT_BOOST_SPEED].tiers[tier].amount)
				end
				return imbuType
			end
		end
	end
	
	return -1
end

function Player:internalDeEquipImbuement(item, imbuId, tier)
	local categoryType = self:internalRemoveImbuement(imbuId, tier)
	if categoryType > -1 then
		if categoryType ~= IMBUEMENT_TYPE_PROTECTION and categoryType ~= IMBUEMENT_TYPE_DAMAGE and categoryType ~= IMBUEMENT_TYPE_SPEED then
			return true
		end
	else
		print(
			string.format(
				"[Warning - imbuements deequip]: could not remove imbuement type %d from player %s, item id: %d, properties: %s",
				imbuId,
				self:getName(),
				item:getId(),
				item:getCustomAttribute(CUSTOM_ATTRIBUTE_IMBUEMENTS)
			)
		)
	end
	
	return false
end

function Player:deEquipImbuements(item)
	local needUpdate = false
	
	for _, imbuement in pairs(item:getImbuements()) do
		local imbuId = imbuement[1] and tonumber(imbuement[1]) or 0
		local tier = tonumber(imbuement[2]) or 0
		if imbuId > 0 and tier > 0 then
			local thisUpdate = self:internalDeEquipImbuement(item, imbuId, tier)
			needUpdate = needUpdate or thisUpdate
		end
	end
	
	if needUpdate then
		self:unloadImbuements()
		self:loadImbuements()
	end
end

-- events and scripts
do
	local ec = EventCallback
	ec.onInventoryUpdate = function(self, item, slot, equip)
		if equip then
			--fix for glitched equip
			if self:getStorageValue(PlayerStorageKeys.imbuLastEquipSlot) == slot and self:getStorageValue(PlayerStorageKeys.imbuLastEquipItem) == item:getId() then
				self:setStorageValue(PlayerStorageKeys.imbuLastEquipSlot, -1)
				self:setStorageValue(PlayerStorageKeys.imbuLastEquipItem, -1)
				return
			end
			self:setStorageValue(PlayerStorageKeys.imbuLastEquipSlot, slot)
			self:setStorageValue(PlayerStorageKeys.imbuLastEquipItem, item:getId())			
			
			-- equip imbuements
			self:equipImbuements(item)
			return
		end
		
		-- fix for glitched equip
		self:setStorageValue(PlayerStorageKeys.imbuLastEquipSlot, -1)
		self:setStorageValue(PlayerStorageKeys.imbuLastEquipItem, -1)
		
		-- fix glitched deequip
		local slotItem = self:getSlotItem(slot)
		if slotItem == item then
			return
		end
		
		-- deequip imbuements
		self:deEquipImbuements(item)
	end
	ec:register()
end

ParalDeflect = {}

local death = CreatureEvent("imbuDeath")
function death.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
	-- clear cached values
	local cid = creature:getId()
	ParalDeflect[cid] = nil
	PlayerImbuements[cid] = nil
	return true
end
death:register()

-- player imbuements reducing taken damage
local imbuResistances = CreatureEvent("imbuResistances")
function imbuResistances.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin, isBeforeManaShield)
	if not isBeforeManaShield or primaryType == COMBAT_HEALING then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end
	
	local imbuements = PlayerImbuements[creature:getId()]
	local protections = imbuements and imbuements[IMBUEMENT_TYPE_PROTECTION]
	if not protections then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end
	
	for _, imbuement in pairs(protections) do
		local buffId = imbuement[1]
		local tier = imbuement[2]
		local imbuData = ImbuResistances[buffId] and ImbuResistances[buffId][tier]
		if imbuData then
			local mult = (100-imbuData[2])/100
			if primaryType == imbuData[1] then
				primaryDamage = math.floor(primaryDamage * mult)
			end
			
			if secondaryType == imbuData[2] then
				secondaryDamage = math.floor(secondaryDamage * mult)
			end
		end
	end
	
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end
imbuResistances:register()

-- player imbuements converting dealt damage before hitting the creature
local imbuConversion = CreatureEvent("imbuDamageConversion")
function imbuConversion.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin, isBeforeManaShield)
	if primaryType == COMBAT_HEALING or not(isBeforeManaShield and attacker and attacker:isPlayer()) then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end
	
	local imbuements = PlayerImbuements[attacker:getId()]
	local conversions = imbuements and imbuements[IMBUEMENT_TYPE_DAMAGE]
	if not conversions then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end
	
	local damageTypes = {
		[COMBAT_PHYSICALDAMAGE] = 0
	}
	
	damageTypes[primaryType] = primaryDamage
	if primaryType == secondaryType then
		damageTypes[primaryType] = damageTypes[primaryType] + secondaryDamage
	else
		damageTypes[secondaryType] = secondaryDamage
	end
	
	for _, imbuement in pairs(conversions) do
		local buffId = imbuement[1]
		local tier = imbuement[2]
		local imbuData = ImbuDamages[buffId] and ImbuDamages[buffId][tier]
		
		if imbuData then
			if buffId ~= IMBUEMENT_DAMAGE_PHYSICAL then
				-- physical to magic
				local physDmg = damageTypes[COMBAT_PHYSICALDAMAGE]
				if physDmg ~= 0 then
					local convertedDmg = math.ceil(physDmg * (imbuData[2]/100))
					damageTypes[imbuData[1]] = (damageTypes[imbuData[1]] or 0) + convertedDmg
					damageTypes[COMBAT_PHYSICALDAMAGE] = math.max(0, physDmg - convertedDmg)
				end
			else
				-- magic to physical
				for damageType, amount in pairs(damageTypes) do
					if buffId ~= IMBUEMENT_DAMAGE_PHYSICAL then
						local convertedDmg = math.ceil(amount * (imbuData[2]/100))
						damageTypes[COMBAT_PHYSICALDAMAGE] = amount + convertedDmg
						damageTypes[damageType] = math.max(0, amount - convertedDmg)
					end
				end
			end
		end		
	end
	
	primaryDamage = 0
	primaryType = COMBAT_NONE
	secondaryDamage = 0
	secondaryType = COMBAT_NONE
	
	for type, damage in pairs(damageTypes) do
		if primaryDamage == 0 then
			if damage ~= 0 then
				primaryType = type
				primaryDamage = damage
			end
		elseif secondaryDamage == 0 then
			if damage ~= 0 then
				secondaryType = type
				secondaryDamage = damage
			end
		else
			doTargetCombat(attacker:getId(), creature:getId(), type, -damage, -damage, CONST_ME_NONE, origin, true, true, false)
		end
	end
	
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end
imbuConversion:register()

local logout = CreatureEvent("imbuLogout")
function logout.onLogout(player)
	-- clear cached values
	local cid = player:getId()
	PlayerImbuements[cid] = nil
	ParalDeflect[cid] = nil
	return true
end
logout:register()

local login = CreatureEvent("imbuLogin")
function login.onLogin(player)
	player:registerImbuements()
	player:registerEvent("imbuLogout")
	player:registerEvent("imbuDeath")
	player:registerEvent("imbuResistances") -- damage taken
	player:registerEvent("imbuDamageConversion") -- pvp damage conversion
	return true
end
login:register()

local spawn = EventCallback
function spawn.onSpawn(monster, position, startup, artificial)
	monster:registerEvent("imbuDamageConversion") -- pve damage conversion
	return true
end
spawn:register()

VibrancyCache = {}
if ImbuingTypes and ImbuingTypes[IMBUEMENT_DEFLECT_PARALYZE] then
	local tiers = ImbuingTypes[IMBUEMENT_DEFLECT_PARALYZE].tiers
	if tiers then
		for tier, tierData in pairs(tiers) do
			VibrancyCache[tier] = tierData.amount
		end
	end
end

local paralDeflect = EventCallback
function paralDeflect.onAddCondition(creature, condition, isForced)

	local player = Player(creature)
	if not player then
		return RETURNVALUE_NOERROR
	end

	local cid = creature:getId()
	if ParalDeflect[cid] and os.time() < ParalDeflect[cid] then
		return RETURNVALUE_NOTPOSSIBLE
	end
	
	if creature:hasCondition(CONDITION_PARALYZE) then
		local imbuements = PlayerImbuements[cid]
		if imbuements then
			-- roll for vibrancy
			for _, imbuement in ipairs(imbuements[IMBUEMENT_TYPE_VIBRANCY]) do
				local chance = VibrancyCache[imbuement[2]]
				
				print(chance, VibrancyCache[imbuement[2]], imbuement[2])
				if chance and math.random(100) < chance then
					ParalDeflect[cid] = os.time() + 2
					creature:removeCondition(CONDITION_PARALYZE)
					return RETURNVALUE_NOTPOSSIBLE
				end
			end
		end
	end

	return RETURNVALUE_NOERROR	
end
paralDeflect:register()
