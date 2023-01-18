-- requires ITEMSYSTEM module
ImbuingSystem = true -- enables the system

ImbuLevels = {
	[0] = "Basic",
	[1] = "Intricate",
	[2] = "Powerful"
}

-- AUTOREGISTER / these variables will be cleared after initialization
ImbuNames = {
	[IMBUING_TYPE_CRIT] = "Strike",
	[IMBUING_TYPE_DAMAGE] = {
		[COMBAT_DEATHDAMAGE] = "Reap",
		[COMBAT_EARTHDAMAGE] = "Venom",
		[COMBAT_ENERGYDAMAGE] = "Electrify",
		[COMBAT_FIREDAMAGE] = "Scorch",
		[COMBAT_HOLYDAMAGE] = "Purify",
		[COMBAT_ICEDAMAGE] = "Frost",
		[COMBAT_PHYSICALDAMAGE] = "Wound"
	},
	[IMBUING_TYPE_PROTECTION] = {
		[COMBAT_DEATHDAMAGE] = "Lich Shroud",
		[COMBAT_EARTHDAMAGE] = "Snake Skin",
		[COMBAT_ENERGYDAMAGE] = "Cloud Fabric",
		[COMBAT_FIREDAMAGE] = "Dragon Hide",
		[COMBAT_HOLYDAMAGE] = "Demon Presence",
		[COMBAT_ICEDAMAGE] = "Quara Scale",
		[COMBAT_PHYSICALDAMAGE] = "Hardening"
	},
	[IMBUING_TYPE_LEECH_HP] = "Vampirism",
	[IMBUING_TYPE_LEECH_MANA] = "Void",
	[IMBUING_TYPE_SKILLBOOST] = {
		[SKILL_MAGLEVEL] = "Epiphany",
		[SKILL_FIST] = "Punch",
		[SKILL_CLUB] = "Bash",
		[SKILL_SWORD] = "Slash",
		[SKILL_AXE] = "Chop",
		[SKILL_DISTANCE] = "Precision",
		[SKILL_SHIELD] = "Blockade",
	},
	[IMBUING_TYPE_SPEED] = "Swiftness",
	[IMBUING_TYPE_CAPACITY] = "Featherweight",
	[IMBUING_TYPE_DEFLECT_PARALYZE] = "Vibrancy",
}

ImbuDescriptions = {
	[IMBUING_TYPE_CRIT] = "Critical extra damage: %d%%. Critical hit chance: %d%%.",
	[IMBUING_TYPE_DAMAGE] = {
		[COMBAT_DEATHDAMAGE] = "Converts %d%% of physical damage to death damage.",
		[COMBAT_EARTHDAMAGE] = "Converts %d%% of physical damage to earth damage.",
		[COMBAT_ENERGYDAMAGE] = "Converts %d%% of physical damage to energy damage.",
		[COMBAT_FIREDAMAGE] = "Converts %d%% of physical damage to fire damage.",
		[COMBAT_HOLYDAMAGE] = "Converts %d%% of physical damage to holy damage.",
		[COMBAT_ICEDAMAGE] = "Converts %d%% of physical damage to ice damage.",
		[COMBAT_PHYSICALDAMAGE] = "Converts %d%% of magic damage to physical damage."
	},
	[IMBUING_TYPE_PROTECTION] = {
		[COMBAT_DEATHDAMAGE] = "Reduces incoming death damage by %d%%.",
		[COMBAT_EARTHDAMAGE] = "Reduces incoming earth damage by %d%%.",
		[COMBAT_ENERGYDAMAGE] = "Reduces incoming energy damage by %d%%.",
		[COMBAT_FIREDAMAGE] = "Reduces incoming fire damage by %d%%.",
		[COMBAT_HOLYDAMAGE] = "Reduces incoming holy damage by %d%%.",
		[COMBAT_ICEDAMAGE] = "Reduces incoming ice damage by %d%%.",
		[COMBAT_PHYSICALDAMAGE] = "Reduces incoming physical damage by %d%%."
	},
	[IMBUING_TYPE_LEECH_HP] = "Converts %d%% of damage to health with a chance of %d%%.",
	[IMBUING_TYPE_LEECH_MANA] = "Converts %d%% of damage to mana with a chance of %d%%.",
	[IMBUING_TYPE_SKILLBOOST] = {
		[SKILL_MAGLEVEL] = "Magic Level %+d.",
		[SKILL_FIST] = "Fist fighting %+d.",
		[SKILL_CLUB] = "Club fighting %+d.",
		[SKILL_SWORD] = "Sword fighting %+d.",
		[SKILL_AXE] = "Axe fighting %+d.",
		[SKILL_DISTANCE] = "Distance fighting %+d.",
		[SKILL_SHIELD] = "Shielding %+d.",
	},
	-- unique imbuing type, single value only
	-- %c works as string.char - 0 will be invisible
	[IMBUING_TYPE_SPEED] = "Speed %+d.%c",
	[IMBUING_TYPE_CAPACITY] = "Capacity %+d%%.%c",
	[IMBUING_TYPE_DEFLECT_PARALYZE] = "Reduces the chance of getting paralysed by %d%%.%c",
}

-- AUTOREGISTER / these variables will be cleared after initialization
GameImbuingTypes = {
	-- crit/leech:
	-- primary -> chance, secondary -> amount

	-- protection/damage:
	-- primary -> combatType, secondary -> percent damage
	
	-- skill boost:
	-- primary -> skillType, secondary -> skill amount
	
	-- speed/vibrancy/capacity:
	-- primary -> flat boost?, secondary -> percent boost?
	
	[IMBUEMENT_CRIT_1] = { type = IMBUING_TYPE_CRIT, primary = 15, secondary = 10 },
	[IMBUEMENT_CRIT_2] = { type = IMBUING_TYPE_CRIT, primary = 25, secondary = 10 },
	[IMBUEMENT_CRIT_3] = { type = IMBUING_TYPE_CRIT, primary = 50, secondary = 10 },
	[IMBUEMENT_DAMAGE_DEATH_1] = { type = IMBUING_TYPE_DAMAGE, primary = COMBAT_DEATHDAMAGE, secondary = 10 },
	[IMBUEMENT_DAMAGE_DEATH_2] = { type = IMBUING_TYPE_DAMAGE, primary = COMBAT_DEATHDAMAGE, secondary = 25 },
	[IMBUEMENT_DAMAGE_DEATH_3] = { type = IMBUING_TYPE_DAMAGE, primary = COMBAT_DEATHDAMAGE, secondary = 50 },
	[IMBUEMENT_DAMAGE_EARTH_1] = { type = IMBUING_TYPE_DAMAGE, primary = COMBAT_EARTHDAMAGE, secondary = 10 },
	[IMBUEMENT_DAMAGE_EARTH_2] = { type = IMBUING_TYPE_DAMAGE, primary = COMBAT_EARTHDAMAGE, secondary = 25 },
	[IMBUEMENT_DAMAGE_EARTH_3] = { type = IMBUING_TYPE_DAMAGE, primary = COMBAT_EARTHDAMAGE, secondary = 50 },
	[IMBUEMENT_DAMAGE_ENERGY_1] = { type = IMBUING_TYPE_DAMAGE, primary = COMBAT_ENERGYDAMAGE, secondary = 10 },
	[IMBUEMENT_DAMAGE_ENERGY_2] = { type = IMBUING_TYPE_DAMAGE, primary = COMBAT_ENERGYDAMAGE, secondary = 25 },
	[IMBUEMENT_DAMAGE_ENERGY_3] = { type = IMBUING_TYPE_DAMAGE, primary = COMBAT_ENERGYDAMAGE, secondary = 50 },
	[IMBUEMENT_DAMAGE_FIRE_1] = { type = IMBUING_TYPE_DAMAGE, primary = COMBAT_FIREDAMAGE, secondary = 10 },
	[IMBUEMENT_DAMAGE_FIRE_2] = { type = IMBUING_TYPE_DAMAGE, primary = COMBAT_FIREDAMAGE, secondary = 25 },
	[IMBUEMENT_DAMAGE_FIRE_3] = { type = IMBUING_TYPE_DAMAGE, primary = COMBAT_FIREDAMAGE, secondary = 50 },
	[IMBUEMENT_DAMAGE_HOLY_1] = { type = IMBUING_TYPE_DAMAGE, primary = COMBAT_HOLYDAMAGE, secondary = 10 },
	[IMBUEMENT_DAMAGE_HOLY_2] = { type = IMBUING_TYPE_DAMAGE, primary = COMBAT_HOLYDAMAGE, secondary = 25 },
	[IMBUEMENT_DAMAGE_HOLY_3] = { type = IMBUING_TYPE_DAMAGE, primary = COMBAT_HOLYDAMAGE, secondary = 50 },
	[IMBUEMENT_DAMAGE_ICE_1] = { type = IMBUING_TYPE_DAMAGE, primary = COMBAT_ICEDAMAGE, secondary = 10 },
	[IMBUEMENT_DAMAGE_ICE_2] = { type = IMBUING_TYPE_DAMAGE, primary = COMBAT_ICEDAMAGE, secondary = 25 },
	[IMBUEMENT_DAMAGE_ICE_3] = { type = IMBUING_TYPE_DAMAGE, primary = COMBAT_ICEDAMAGE, secondary = 50 },
	[IMBUEMENT_DAMAGE_PHYSICAL_1] = { type = IMBUING_TYPE_DAMAGE, primary = COMBAT_PHYSICALDAMAGE, secondary = 10 },
	[IMBUEMENT_DAMAGE_PHYSICAL_2] = { type = IMBUING_TYPE_DAMAGE, primary = COMBAT_PHYSICALDAMAGE, secondary = 25 },
	[IMBUEMENT_DAMAGE_PHYSICAL_3] = { type = IMBUING_TYPE_DAMAGE, primary = COMBAT_PHYSICALDAMAGE, secondary = 50 },
	[IMBUEMENT_PROTECTION_DEATH_1] = { type = IMBUING_TYPE_PROTECTION, primary = COMBAT_DEATHDAMAGE, secondary = 2 },
	[IMBUEMENT_PROTECTION_DEATH_2] = { type = IMBUING_TYPE_PROTECTION, primary = COMBAT_DEATHDAMAGE, secondary = 5 },
	[IMBUEMENT_PROTECTION_DEATH_3] = { type = IMBUING_TYPE_PROTECTION, primary = COMBAT_DEATHDAMAGE, secondary = 10 },
	[IMBUEMENT_PROTECTION_EARTH_1] = { type = IMBUING_TYPE_PROTECTION, primary = COMBAT_EARTHDAMAGE, secondary = 3 },
	[IMBUEMENT_PROTECTION_EARTH_2] = { type = IMBUING_TYPE_PROTECTION, primary = COMBAT_EARTHDAMAGE, secondary = 8 },
	[IMBUEMENT_PROTECTION_EARTH_3] = { type = IMBUING_TYPE_PROTECTION, primary = COMBAT_EARTHDAMAGE, secondary = 15 },
	[IMBUEMENT_PROTECTION_ENERGY_1] = { type = IMBUING_TYPE_PROTECTION, primary = COMBAT_ENERGYDAMAGE, secondary = 3 },
	[IMBUEMENT_PROTECTION_ENERGY_2] = { type = IMBUING_TYPE_PROTECTION, primary = COMBAT_ENERGYDAMAGE, secondary = 8 },
	[IMBUEMENT_PROTECTION_ENERGY_3] = { type = IMBUING_TYPE_PROTECTION, primary = COMBAT_ENERGYDAMAGE, secondary = 15 },
	[IMBUEMENT_PROTECTION_FIRE_1] = { type = IMBUING_TYPE_PROTECTION, primary = COMBAT_FIREDAMAGE, secondary = 3 },
	[IMBUEMENT_PROTECTION_FIRE_2] = { type = IMBUING_TYPE_PROTECTION, primary = COMBAT_FIREDAMAGE, secondary = 8 },
	[IMBUEMENT_PROTECTION_FIRE_3] = { type = IMBUING_TYPE_PROTECTION, primary = COMBAT_FIREDAMAGE, secondary = 15 },
	[IMBUEMENT_PROTECTION_HOLY_1] = { type = IMBUING_TYPE_PROTECTION, primary = COMBAT_HOLYDAMAGE, secondary = 3 },
	[IMBUEMENT_PROTECTION_HOLY_2] = { type = IMBUING_TYPE_PROTECTION, primary = COMBAT_HOLYDAMAGE, secondary = 8 },
	[IMBUEMENT_PROTECTION_HOLY_3] = { type = IMBUING_TYPE_PROTECTION, primary = COMBAT_HOLYDAMAGE, secondary = 15 },
	[IMBUEMENT_PROTECTION_ICE_1] = { type = IMBUING_TYPE_PROTECTION, primary = COMBAT_ICEDAMAGE, secondary = 3 },
	[IMBUEMENT_PROTECTION_ICE_2] = { type = IMBUING_TYPE_PROTECTION, primary = COMBAT_ICEDAMAGE, secondary = 8 },
	[IMBUEMENT_PROTECTION_ICE_3] = { type = IMBUING_TYPE_PROTECTION, primary = COMBAT_ICEDAMAGE, secondary = 15 },
	[IMBUEMENT_PROTECTION_PHYSICAL_1] = { type = IMBUING_TYPE_PROTECTION, primary = COMBAT_PHYSICALDAMAGE, secondary = 3 },
	[IMBUEMENT_PROTECTION_PHYSICAL_2] = { type = IMBUING_TYPE_PROTECTION, primary = COMBAT_PHYSICALDAMAGE, secondary = 8 },
	[IMBUEMENT_PROTECTION_PHYSICAL_3] = { type = IMBUING_TYPE_PROTECTION, primary = COMBAT_PHYSICALDAMAGE, secondary = 15 },
	[IMBUEMENT_LEECH_LIFE_1] = { type = IMBUING_TYPE_LEECH_HP, primary = 5, secondary = 100 },
	[IMBUEMENT_LEECH_LIFE_2] = { type = IMBUING_TYPE_LEECH_HP, primary = 10, secondary = 100 },
	[IMBUEMENT_LEECH_LIFE_3] = { type = IMBUING_TYPE_LEECH_HP, primary = 25, secondary = 100 },
	[IMBUEMENT_LEECH_MANA_1] = { type = IMBUING_TYPE_LEECH_MANA, primary = 3, secondary = 100 },
	[IMBUEMENT_LEECH_MANA_2] = { type = IMBUING_TYPE_LEECH_MANA, primary = 5, secondary = 100 },
	[IMBUEMENT_LEECH_MANA_3] = { type = IMBUING_TYPE_LEECH_MANA, primary = 8, secondary = 100 },
	[IMBUEMENT_BOOST_AXE_1] = { type = IMBUING_TYPE_SKILLBOOST, primary = SKILL_AXE, secondary = 1 },
	[IMBUEMENT_BOOST_AXE_2] = { type = IMBUING_TYPE_SKILLBOOST, primary = SKILL_AXE, secondary = 2 },
	[IMBUEMENT_BOOST_AXE_3] = { type = IMBUING_TYPE_SKILLBOOST, primary = SKILL_AXE, secondary = 4 },
	[IMBUEMENT_BOOST_CLUB_1] = { type = IMBUING_TYPE_SKILLBOOST, primary = SKILL_CLUB, secondary = 1 },
	[IMBUEMENT_BOOST_CLUB_2] = { type = IMBUING_TYPE_SKILLBOOST, primary = SKILL_CLUB, secondary = 2 },
	[IMBUEMENT_BOOST_CLUB_3] = { type = IMBUING_TYPE_SKILLBOOST, primary = SKILL_CLUB, secondary = 4 },
	[IMBUEMENT_BOOST_DISTANCE_1] = { type = IMBUING_TYPE_SKILLBOOST, primary = SKILL_DISTANCE, secondary = 1 },
	[IMBUEMENT_BOOST_DISTANCE_2] = { type = IMBUING_TYPE_SKILLBOOST, primary = SKILL_DISTANCE, secondary = 2 },
	[IMBUEMENT_BOOST_DISTANCE_3] = { type = IMBUING_TYPE_SKILLBOOST, primary = SKILL_DISTANCE, secondary = 4 },
	[IMBUEMENT_BOOST_FIST_1] = { type = IMBUING_TYPE_SKILLBOOST, primary = SKILL_FIST, secondary = 1 },
	[IMBUEMENT_BOOST_FIST_2] = { type = IMBUING_TYPE_SKILLBOOST, primary = SKILL_FIST, secondary = 2 },
	[IMBUEMENT_BOOST_FIST_3] = { type = IMBUING_TYPE_SKILLBOOST, primary = SKILL_FIST, secondary = 4 },
	[IMBUEMENT_BOOST_MAGIC_1] = { type = IMBUING_TYPE_SKILLBOOST, primary = SKILL_MAGLEVEL, secondary = 1 },
	[IMBUEMENT_BOOST_MAGIC_2] = { type = IMBUING_TYPE_SKILLBOOST, primary = SKILL_MAGLEVEL, secondary = 2 },
	[IMBUEMENT_BOOST_MAGIC_3] = { type = IMBUING_TYPE_SKILLBOOST, primary = SKILL_MAGLEVEL, secondary = 4 },
	[IMBUEMENT_BOOST_SHIELD_1] = { type = IMBUING_TYPE_SKILLBOOST, primary = SKILL_SHIELD, secondary = 1 },
	[IMBUEMENT_BOOST_SHIELD_2] = { type = IMBUING_TYPE_SKILLBOOST, primary = SKILL_SHIELD, secondary = 2 },
	[IMBUEMENT_BOOST_SHIELD_3] = { type = IMBUING_TYPE_SKILLBOOST, primary = SKILL_SHIELD, secondary = 4 },
	[IMBUEMENT_BOOST_SWORD_1] = { type = IMBUING_TYPE_SKILLBOOST, primary = SKILL_SWORD, secondary = 1 },
	[IMBUEMENT_BOOST_SWORD_2] = { type = IMBUING_TYPE_SKILLBOOST, primary = SKILL_SWORD, secondary = 2 },
	[IMBUEMENT_BOOST_SWORD_3] = { type = IMBUING_TYPE_SKILLBOOST, primary = SKILL_SWORD, secondary = 4 },
	[IMBUEMENT_BOOST_SPEED_1] = { type = IMBUING_TYPE_SPEED, primary = 10, secondary = 0, passive = true }, -- passive - also ticks out of combat
	[IMBUEMENT_BOOST_SPEED_2] = { type = IMBUING_TYPE_SPEED, primary = 15, secondary = 0, passive = true },
	[IMBUEMENT_BOOST_SPEED_3] = { type = IMBUING_TYPE_SPEED, primary = 30, secondary = 0, passive = true },
	[IMBUEMENT_BOOST_CAPACITY_1] = { type = IMBUING_TYPE_CAPACITY, primary = 3, secondary = 0, passive = true },
	[IMBUEMENT_BOOST_CAPACITY_2] = { type = IMBUING_TYPE_CAPACITY, primary = 8, secondary = 0, passive = true },
	[IMBUEMENT_BOOST_CAPACITY_3] = { type = IMBUING_TYPE_CAPACITY, primary = 15, secondary = 0, passive = true },
	[IMBUEMENT_DEFLECT_PARALYZE_1] = { type = IMBUING_TYPE_DEFLECT_PARALYZE, primary = 15, secondary = 0 },
	[IMBUEMENT_DEFLECT_PARALYZE_2] = { type = IMBUING_TYPE_DEFLECT_PARALYZE, primary = 25, secondary = 0 },
	[IMBUEMENT_DEFLECT_PARALYZE_3] = { type = IMBUING_TYPE_DEFLECT_PARALYZE, primary = 50, secondary = 0 },
}

-- generate socket info on startup/reload
if Equippables then
	for _, category in pairs(Equippables) do
		for itemId, itemData in pairs(category) do
			if itemData.sockets then
				ItemType(itemId):setImbuingSlots(itemData.sockets)
			end
		end
	end
end

---- AUTOREGISTER IMBUEMENT TYPES
do
	-- imbulevel / imbuname (eg. basic strike)
	local function generateImbuementName(imbuId)
		local imbuData = GameImbuingTypes[imbuId]
		local imbuName = ImbuNames[imbuData.type]
		if type(imbuName) == "table" then
			imbuName = imbuName[imbuData.primary]
		end
		
		return string.format("%s %s", ImbuLevels[((imbuId-1) % 3)], imbuName)
	end

	local function getImbuementDescription(imbuId)
		local imbuData = GameImbuingTypes[imbuId]
		local imbuName = ImbuDescriptions[imbuData.type]
		if type(imbuName) == "table" then
			return string.format(imbuName[imbuData.primary], imbuData.secondary)
		end
		
		return string.format(imbuName, imbuData.primary, imbuData.secondary)
	end

	-- unload from online players
	local playersOnline = Game.getPlayers()
	for _, player in ipairs(playersOnline) do
		player:imbuementsReload(false)
	end
	
	-- register imbuements loop
	for imbuId = IMBUEMENT_CRIT_1, IMBUEMENT_DEFLECT_PARALYZE_3 do
		local imbuData = GameImbuingTypes[imbuId]
		if imbuData then
			local imbuType = ImbuementType(imbuId)
			imbuType:name(generateImbuementName(imbuId))
			imbuType:description(getImbuementDescription(imbuId))
			imbuType:type(imbuData.type)
			imbuType:icon(imbuId)
			imbuType:primaryValue(imbuData.primary)
			imbuType:secondaryValue(imbuData.secondary)
			imbuType:outOfCombat(imbuData.passive)
			imbuType:duration(20 * 60 * 60)
		end
	end

	-- free the memory after registering imbu types
	GameImbuingTypes = nil
	ImbuNames = nil
	generateImbuementName = nil
	getImbuementDescription = nil
	
	-- load for online players
	for _, player in ipairs(playersOnline) do
		player:imbuementsReload(true)
	end
end

-- returns imbuement name pushed for description
local function internalGetImbuementName(imbuId)
	local name = imbuId ~= 0 and ImbuementType(imbuId):name() or "Empty Slot"
	return name:len() > 0 and name or "Unnamed Imbuement"
end

-- returns imbuement duration in seconds
function Item:getImbuementDuration(imbuData)
	if imbuData.duration == -1 then
		return -1
	end

	local parent = self:getParent()
	if parent and Player(parent) then
		-- get duration of equipped item
		local passive = ImbuementType(imbuData.imbuId):outOfCombat()
		if passive or parent:hasCondition(CONDITION_INFIGHT) and parent:getZone() ~= ZONE_PROTECTION then
			-- player in combat or imbuement is passive
			-- calculate time passed since last update
			local timeDiff = math.floor((os.mtime() - imbuData.lastUpdated) / 1000)
			return math.max(0, imbuData.duration - timeDiff)
		end
	end
	
	-- player out of combat or item not equipped
	return imbuData.duration
end

-- [ItemType] verbal description of imbuing slots
function ItemType:getImbuementsDescription(socketCount)
	if not socketCount then
		socketCount = self:getImbuingSlots()
	end

	if socketCount == 0 then
		-- nothing to send
		return ""
	end

	local slots = {}
	for i = 1, socketCount do
		slots[#slots + 1] = "Empty Slot"
	end
	
	return string.format("\nImbuements: (%s).", table.concat(slots, ", "))
end

-- [Item] verbal description of imbuing slots
function Item:getImbuementsDescription()
	local socketCount = self:getImbuingSlots()

	local rawImbuements = self:getImbuements()
	if not rawImbuements or #rawImbuements == 0 then
		-- all slots are empty, get info from ItemType
		return self:getType():getImbuementsDescription(socketCount)
	end
	
	for _, imbuData in pairs(rawImbuements) do
		socketCount = math.max(socketCount, imbuData.slotId)
	end

	if socketCount == 0 then
		-- nothing to send
		return ""
	end
	
	local imbuements = {}
	local maxSocketId = socketCount
	for _, imbuement in pairs(rawImbuements) do
		local slotId = imbuement.slotId
		imbuements[slotId] = imbuement
		maxSocketId = math.max(slotId + 1, maxSocketId)
	end
	
	local response = {}
	for socketId = 0, maxSocketId - 1 do
		if imbuements[socketId] then
			local duration = self:getImbuementDuration(imbuements[socketId])
			local durationStr = "--:--h"
			if duration ~= -1 then
				duration = math.floor(duration / 60)
				durationStr = string.format("%d:%.2dh", math.floor(duration / 60), duration % 60)
			end

			response[#response + 1] = string.format("%s %s", internalGetImbuementName(imbuements[socketId].imbuId), durationStr)
		else
			response[#response + 1] = "Empty Slot"
		end
	end

	return #response > 0 and string.format("\nImbuements: (%s)", table.concat(response, ", ")) or ""
end

-- adds imbuements icons to item inspection UI
function NetworkMessage:addImbuements(item, isVirtual)
	local count = item:getImbuingSlots()

	if isVirtual then	
		self:addByte(count)
	
		if count > 0 then
			for i = 1, count do
				self:addU16(0)
			end
		end
		
		return
	end

	local rawImbuements = item:getImbuements()
	local imbuements = {}
	local count = math.max(count, #rawImbuements)
	for _, imbuement in pairs(rawImbuements) do
		local slotId = imbuement.slotId
		imbuements[slotId] = ImbuementType(imbuement.imbuId):icon()
		count = math.max(slotId + 1, count)
	end

	self:addByte(count)
	if count > 0 then
		for slotId = 0, count-1 do
			self:addU16(imbuements[slotId] or 0)
		end
	end
end

-- descriptions in inspection menu
function getInspectImbuements(item, isVirtual)
	local response = {}
	local sendEmpty = true
	local socketCount = 0
	local rawImbuements
	
	if not isVirtual then
		rawImbuements = item:getImbuements()
		if rawImbuements and #rawImbuements ~= 0 then
			socketCount = math.max(item:getImbuingSlots(), #rawImbuements)
			if socketCount > 0 then
				sendEmpty = false
			end
		end			
	end

	-- handle virtual/not imbued items
	if sendEmpty then
		socketCount = item:getImbuingSlots()
		if socketCount > 0 then
			for socketId = 1, socketCount do
				response[#response + 1] = {"Imbuement Slot " .. socketId, "empty"}
			end
		end
		
		return response
	end
	
	-- handle real items
	local imbuements = {}
	for _, imbuement in pairs(rawImbuements) do
		local slotId = imbuement.slotId
		imbuements[slotId] = imbuement
		socketCount = math.max(slotId + 1, socketCount)
	end
	
	for socketId = 0, socketCount-1 do
		local slotStr = "empty"
		local imbuement = imbuements[socketId]
		
		if imbuement then
			local imbuType = ImbuementType(imbuement.imbuId)
		
			slotStr = internalGetImbuementName(imbuement.imbuId)
			local description = imbuType:description()
			if not description or description:len() == 0 then
				description = "No description available."
			end
			
			-- duration
			local duration = item:getImbuementDuration(imbuement)
			local durationStr = ", permanent"
			if duration ~= -1 then
				duration = math.floor(duration / 60)
				durationStr = string.format(
					", lasts %d:%.2dh%s",
					math.floor(duration / 60),
					duration % 60,
					imbuType:outOfCombat() and "" or " while fighting"
				)
			end
				
			slotStr = string.format("%s (%s)%s.", slotStr, description, durationStr)
		end
		
		response[#response + 1] = {"Imbuement Slot " .. socketId + 1, slotStr}
	end
	
	return response
end

-- vibrancy (STAT_VIBRANCY)
ParalDeflect = {}
local paralDeflect = EventCallback
function paralDeflect.onAddCondition(creature, condition, isForced)
	local player = Player(creature)
	if not player then
		return RETURNVALUE_NOERROR
	end

	if not(condition and condition:getType() == CONDITION_PARALYZE) then
		return RETURNVALUE_NOERROR
	end

	local vibrancy = player:getVibrancy()
	if vibrancy <= 0 then
		return RETURNVALUE_NOERROR
	end
	
	local cid = creature:getId()
	if ParalDeflect[cid] and os.time() < ParalDeflect[cid] then
		return RETURNVALUE_NOTPOSSIBLE
	end
	
	if creature:hasCondition(CONDITION_PARALYZE) and math.random(100) < vibrancy then
		ParalDeflect[cid] = os.time() + 2
		creature:removeCondition(CONDITION_PARALYZE)
		return RETURNVALUE_NOTPOSSIBLE
	end

	return RETURNVALUE_NOERROR	
end
paralDeflect:register()

