---- METADATA (editing not recommended)
-- slots to search for imbuements that tick out of combat
PassiveImbuementSlots = {CONST_SLOT_BACKPACK, CONST_SLOT_FEET}

-- default categories for regular imbuement types
local damageDefaults = {"weapons", "weapons_distance"}
local protectionDefaults = {"armors", "shields"}
local boostDefaults = {"helmets"}

-- helper for magic level imbuement
local tier1ML = {32083, 36812, 31371}
local tier2ML = {36812, 31371}

-- callback for magic level imbuements
local function isMLImbuable(item, altarId, tier)
	-- helmets
	if not item:getType():isHelmet() then
		return false
	end
	
	-- is mage exclusive helmet
	local vocStr = item:getType():getVocationString()
	if vocStr and (vocStr:find("sorcerer") or vocStr:find("druid")) then
		return true
	end

	-- is knight/paladin helmet which allows it
	local itemId = item:getId()
	return tier == 1 and table.contains(tier1ML, itemId) or tier == 2 and table.contains(tier2ML, itemId)
end

-- callback for wand crit imbuements
local wandCrits = {
	-- wands of destruction
	[30113] = 3,
	[30114] = 3,

	-- falcon wands
	[31372] = 3,
	[31373] = 3,

	-- cobra wands
	[33055] = 3,
	[33056] = 3,
	
	-- eldritch wands
	[39324] = 3,
	[39325] = 3,
	[39330] = 3,
	[39331] = 3,
	
	-- soul wands
	[36746] = 3,
	[36747] = 3,
	
	-- lion wand (rod cant have crit)
	[36808] = 3,
	
	-- jungle wands
	[38177] = 2,
	[38178] = 2,

	-- naga wands
	[44193] = 3,
	[44194] = 3,
}

local function isCritImbuable(item, altarId, tier)
	local critTier = wandCrits[item:getId()] or 0
	return tier <= critTier
end

---- END METADATA

-- config
ImbuingAltars = {
	-- regular
	27716, 27717,

	-- wrappable
	27830, 27831,

	-- wrappable (gilded)
	27838, 27839
}

IMBUING_DEFAULT_DURATION = 20 * 60 * 60 -- 20 hours
IMBUING_DEFAULT_REMOVECOST = 15000 -- imbuement removal cost

local imbuingTiersConfig = {
	[1] = {
		price = 5000,
		protectionCost = 10000,
		successChance = 90,
	},
	[2] = {
		price = 25000,
		protectionCost = 30000,
		successChance = 70,
	},
	[3] = {
		price = 100000,
		protectionCost = 50000,
		successChance = 50,
	},
}

ImbuingAltar = {
	-- iterates using #
	-- do not remove elements from the middle
	-- remove/comment categories if you wish to disable the imbuement from altar
	[1] = {
		name = "Critical Hit",
		baseId = IMBUEMENT_CRIT_1,
		products = {{12400, 20}, {11228, 25}, {25384, 5}},
		
		-- eligibility config
			-- available rules:
				-- categories - blanket support for item category
				-- weaponTypes - support for specific weapon type
				-- items - support for specific item ids (eg. wands with crit)
				-- callback - calls function(player, item, imbuement, tier), if function returns true, item is imbuable
		categories = {"weapons", "weapons_distance"},
		callback = isCritImbuable
	},
	[2] = {
		name = "Element Damage (Death)",
		baseId = IMBUEMENT_DAMAGE_DEATH_1,
		products = {{12440, 25}, {10564, 20}, {11337, 5}},
		categories = damageDefaults
	},
	[3] = {
		name = "Element Damage (Earth)",
		baseId = IMBUEMENT_DAMAGE_EARTH_1,
		products = {{10603, 25}, {10557, 20}, {23565, 2}},
		categories = damageDefaults
	},
	[4] = {
		name = "Element Damage (Energy)",
		baseId = IMBUEMENT_DAMAGE_ENERGY_1,
		products = {{21310, 25}, {24631, 5}, {26164, 1}},
		categories = damageDefaults
	},
	[5] = {
		name = "Element Damage (Fire)",
		baseId = IMBUEMENT_DAMAGE_FIRE_1,
		products = {{10553, 25}, {5920, 5}, {5954, 5}},
		categories = damageDefaults
	},
	[6] = {
		name = "Element Damage (Holy)",
		baseId = IMBUEMENT_DAMAGE_HOLY_1,
		products = {{12470, 25}, {11361, 20}, {34099, 5}},
		categories = {}, --damageDefaults, -- not in game
	},
	[7] = {
		name = "Element Damage (Ice)",
		baseId = IMBUEMENT_DAMAGE_ICE_1,
		products = {{10578, 25}, {24170, 10}, {10567, 5}},
		categories = damageDefaults
	},
	[8] = {
		name = "Element Damage (Physical)",
		baseId = IMBUEMENT_DAMAGE_PHYSICAL_1,
		products = {{9966, 25}, {24708, 10}, {13942, 5}},
		categories = {}, --{"weapons_magic"}, -- not in game
	},
	[9] = {
		name = "Element Protection (Death)",
		baseId = IMBUEMENT_PROTECTION_DEATH_1,
		products = {{12422, 25}, {24663, 20}, {10577, 5}},
		categories = protectionDefaults
	},
	[10] = {
		name = "Element Protection (Earth)",
		baseId = IMBUEMENT_PROTECTION_EARTH_1,
		products = {{20103, 25}, {10611, 20}, {12658, 10}},
		categories = protectionDefaults
	},
	[11] = {
		name = "Element Protection (Energy)",
		baseId = IMBUEMENT_PROTECTION_ENERGY_1,
		products = {{10561, 25}, {15482, 15}, {10582, 10}},
		categories = protectionDefaults
	},
	[12] = {
		name = "Element Protection (Fire)",
		baseId = IMBUEMENT_PROTECTION_FIRE_1,
		products = {{5877, 25}, {18425, 10}, {12614, 5}},
		categories = protectionDefaults
	},
	[13] = {
		name = "Element Protection (Holy)",
		baseId = IMBUEMENT_PROTECTION_HOLY_1,
		products = {{10566, 25}, {10555, 25}, {11221, 20}},
		categories = protectionDefaults
	},
	[14] = {
		name = "Element Protection (Ice)",
		baseId = IMBUEMENT_PROTECTION_ICE_1,
		products = {{11212, 25}, {11224, 15}, {15425, 10}},
		categories = protectionDefaults
	},
	[15] = {
		name = "Element Protection (Physical)",
		baseId = IMBUEMENT_PROTECTION_PHYSICAL_1,
		products = {{10583, 25}, {11229, 15}, {5887, 5}},
		categories = {}, -- protectionDefaults, -- not in game
	},
	[16] = {
		name = "Life Leech",
		baseId = IMBUEMENT_LEECH_LIFE_1,
		products = {{10602, 25}, {10550, 15}, {10580, 5}},
		categories = {"armors", "weapons", "weapons_distance", "weapons_magic"}
	},
	[17] = {
		name = "Mana Leech",
		baseId = IMBUEMENT_LEECH_MANA_1,
		products = {{12448, 25}, {22534, 25}, {25386, 5}},
		categories = {"helmets", "weapons", "weapons_distance", "weapons_magic"}
	},
	[18] = {
		name = "Skillboost (Axe Fighting)",
		baseId = IMBUEMENT_BOOST_AXE_1,
		products = {{11113, 20}, {12403, 25}, {23571, 20}},
		categories = boostDefaults,
		weaponTypes = {WEAPON_AXE}
	},
	[19] = {
		name = "Skillboost (Club Fighting)",
		baseId = IMBUEMENT_BOOST_CLUB_1,
		products = {{10574, 20}, {24845, 15}, {11322, 10}},
		categories = boostDefaults,
		weaponTypes = {WEAPON_CLUB}
	},
	[20] = {
		name = "Skillboost (Distance Fighting)",
		baseId = IMBUEMENT_BOOST_DISTANCE_1,
		products = {{12420, 25}, {21311, 20}, {11215, 10}},
		categories = boostDefaults,
		weaponTypes = {WEAPON_DISTANCE}
	},
	[21] = {
		name = "Skillboost (Fist Fighting)",
		baseId = IMBUEMENT_BOOST_FIST_1,
		products = {{12471, 25}, {12615, 15}, {5930, 5}},
		categories = boostDefaults,
		weaponTypes = {}, --{WEAPON_FIST}, -- not in game
	},
	[22] = {
		name = "Skillboost (Magic Level)",
		baseId = IMBUEMENT_BOOST_MAGIC_1,
		products = {{10552, 25}, {12408, 15}, {11226, 15}},
		weaponTypes = {WEAPON_WAND},
		callback = isMLImbuable,
	},
	[23] = {
		name = "Skillboost (Shielding)",
		baseId = IMBUEMENT_BOOST_SHIELD_1,
		products = {{10558, 20}, {12659, 25}, {22533, 25}},
		categories = boostDefaults,
		weaponTypes = {WEAPON_SHIELD}
	},
	[24] = {
		name = "Skillboost (Sword Fighting)",
		baseId = IMBUEMENT_BOOST_SWORD_1,
		products = {{10608, 25}, {23573, 25}, {10571, 5}},
		categories = boostDefaults,
		weaponTypes = {WEAPON_SWORD}
	},
	[25] = {
		name = "Skillboost (Walking Speed)",
		baseId = IMBUEMENT_BOOST_SPEED_1,
		products = {{19738, 15}, {11219, 25}, {15484, 20}},
		categories = {"boots"},
		items = {36753, 36754}, -- soul items
	},
	[26] = {
		name = "Skillboost (Capacity)",
		baseId = IMBUEMENT_BOOST_CAPACITY_1,
		products = {{28350, 20}, {28358, 10}, {22539, 5}},
		categories = {"backpacks"}
	},
	[27] = {
		name = "Paralysis Removal",
		baseId = IMBUEMENT_DEFLECT_PARALYZE_1,
		products = {{24709, 20}, {26163, 15}, {31223, 5}},
		categories = {"boots"}
	},
}

-- last used altar cache
LastImbuingPosCache = {}

-- quick and easy to access list of products that are being used in imbuing
ImbuingProducts = {}
for _, imbuData in pairs(ImbuingAltar) do
	if imbuData.products then
		for _, product in pairs(imbuData.products) do
			if not table.contains(ImbuingProducts, product[1]) then
				ImbuingProducts[#ImbuingProducts + 1] = product[1]
			end
		end
	end
end

function Item:canBeImbuedWith(imbuId)
	local itemId = self:getId()
	local itemType = self:getType()
	
	local baseImbu = ImbuementType(imbuId)
	local imbuType = baseImbu:type()
	local altarId = math.floor((imbuId - (imbuId - 1) % 3) / 3) + 1

	-- deny imbuement if different tier of same imbuement was already installed
	for _, imbuement in pairs(self:getImbuements()) do
		if altarId == math.floor((imbuement.imbuId - (imbuement.imbuId - 1) % 3) / 3) + 1 then
			return false
		end
	end

	-- imbuable by id	
	local altarData = ImbuingAltar[altarId]
	if altarData then
		if altarData.items and table.contains(altarData.items, itemId) then
			return true
		end
	end

	-- deny imbuement by element type
	local abilities = itemType:getAbilities()
	if imbuType == IMBUING_TYPE_DAMAGE then
		local elementType = baseImbu:primaryValue()
		if elementType == abilities.elementType then
			-- weapon already deals this kind of damage
			return false
		end
	elseif imbuType == IMBUING_TYPE_PROTECTION then
		local elementType = baseImbu:primaryValue()
		for element, amount in pairs(abilities.absorbPercent) do
			if elementType == 2^(element-1) and amount ~= 0 then
				-- armor already blocks this kind of damage
				return false
			end
		end
	elseif imbuType == IMBUING_TYPE_SPEED then
		if abilities.speed ~= 0 then
			-- item already giving speed
			return false
		end
	end
	
	-- imbuable by weaponType or category
	if altarData.weaponTypes and table.contains(altarData.weaponTypes, itemType:getWeaponType()) then
		return true
	elseif altarData.categories and table.contains(altarData.categories, itemType:getEquippableCategory()) then
		return true
	end
	
	-- imbuable by callback
	if altarData.callback then
		return altarData.callback(self, altarId, ((imbuId - 1) % 3) + 1)
	end
	
	-- failed to match permissions
	return false
end

function Item:getAvailableImbuements()
	local itemId = self:getId()
	local itemType = self:getType()
	local itemCategory = itemType:getEquippableCategory()
	local itemWeaponType = itemType:getWeaponType()
	local excludedDamageTypes = 0
	
	local abilities = itemType:getAbilities()
	if abilities.elementDamage > 0 then
		excludedDamageTypes = bit.addFlag(excludedDamageTypes, abilities.elementType)
	end	
	for elementType, amount in pairs(abilities.absorbPercent) do
		if amount ~= 0 then
			excludedDamageTypes = bit.addFlag(excludedDamageTypes, 2^(elementType-1))
		end
	end
	
	local response = {
		count = 0,
		tiers = {}
	}
	
	-- all tiers enabled by default
	local tierMap = 7
	local tierCount = 3
			
	for i = 1, #ImbuingAltar do
		local altarData = ImbuingAltar[i]
		if altarData then
			-- imbuable by id
			if altarData.items and table.contains(altarData.items, itemId) then
				response.count = response.count + tierCount
				response.tiers[i] = tierMap
			end

			-- imbuable by weaponType or category
			-- ignored if item was defined in "items" already
			if not response.tiers[i] and (altarData.weaponTypes and table.contains(altarData.weaponTypes, itemWeaponType)
				or altarData.categories and table.contains(altarData.categories, itemCategory)) then
				
				local baseImbu = ImbuementType(altarData.baseId)
				local imbuType = baseImbu:type()

				if imbuType == IMBUING_TYPE_PROTECTION or imbuType == IMBUING_TYPE_DAMAGE then
					if bit.band(excludedDamageTypes, baseImbu:primaryValue()) == 0 then
						-- element imbuement: allow items without element protection/damage only
						response.count = response.count + tierCount
						response.tiers[i] = tierMap
					end
				elseif imbuType == IMBUING_TYPE_SPEED then
					-- speed imbuement: allow items without speed boost only
					if abilities.speed == 0 then
						response.count = response.count + tierCount
						response.tiers[i] = tierMap
					end
				else
					-- other imbuement: allow
					response.count = response.count + tierCount
					response.tiers[i] = tierMap
				end
			end
			
			-- imbuable by callback (used by magic level imbuement to handle helmets)
			if not response.tiers[i] and altarData.callback then
				local customTierMap = 0
				local customTierCount = 0
				for tierId = 1, 3 do
					if altarData.callback(self, i, tierId) then
						customTierMap = customTierMap + 2^(tierId-1)
						customTierCount = customTierCount + 1
					end
				end
				
				-- allow only selected tiers
				if customTierMap > 0 then
					response.count = response.count + customTierCount
					response.tiers[i] = customTierMap
				end
			end
		end
	end
	
	return response.tiers, response.count
end

function NetworkMessage:addImbuementInfo(imbuId, tier, maxDuration)
	if imbuId == 0 then
		imbuId = 255
	end
	
	local imbuType = ImbuementType(imbuId)
	local name = imbuType:name() or string.format("%s %s", ImbuLevels[tier-1], "Unnamed Imbuement")
	local description = imbuType:description() or "Missing effect description."
	local altarId = math.floor((imbuId + 3 - tier) / 3)
	local altarInfo = ImbuingAltar[altarId]
	local products = altarInfo and altarInfo.products or {}
	local productCount = math.min(tier, #products)
	local tierMeta = imbuingTiersConfig[tier]
	
	-- add data to the packet
	self:addU32(imbuId)
	self:addString(name)
	self:addString(description)
	self:addString(altarInfo and altarInfo.name or "Missing Imbuement Title")
	self:addU16(imbuType:icon())
	self:addU32(maxDuration) -- max duration
	self:addByte(0x00) -- isPremium
	
	self:addByte(productCount) -- items to build
	if productCount > 0 then
		for i = 1, productCount do
			local product = products[i]
			local productType = ItemType(product[1])
			local clientId = productType and productType:getClientId() or 0
			if clientId ~= 0 then
				self:addU16(clientId) -- clientId
				self:addString(productType:getName()) -- name
				self:addU16(product[2] or 0) -- count
			else
				self:addU16(100) -- clientId
				self:addString("Error") -- name
				self:addU16(0) -- count
			end			
		end
	end
	
	self:addU32(tierMeta.price) -- price
	self:addByte(tierMeta.successChance) -- baseChance
	self:addU32(tierMeta.protectionCost) -- protection cost
end

function NetworkMessage:addImbuables(item)
	local imbuTypes, imbuCount = item:getAvailableImbuements()
	local imbuements = item:getImbuements()
	for _, imbuement in pairs(imbuements) do
		local altarId = math.floor((imbuement.imbuId - (imbuement.imbuId - 1) % 3) / 3) + 1
		if imbuTypes[altarId] then
			for tierId = 1, 3 do
				imbuCount = imbuCount - math.min(1, bit.band(imbuTypes[altarId], 2^(tierId-1)))
			end
			imbuTypes[altarId] = nil
		end
	end
	self:addU16(imbuCount) -- buffs count
	local real = 0
	for altarId, tierMap in pairs(imbuTypes) do
		for tierId = 1, 3 do
			if bit.band(tierMap, 2^(tierId-1)) ~= 0 then
				real = real + 1
				self:addImbuementInfo(3 * altarId - (3 - tierId), tierId, IMBUING_DEFAULT_DURATION)
			end
		end
	end
end

function Player:sendImbuingUI(item, altar, relativePos)
	if not relativePos then
		player:closeImbuingUI()
		return
	end
	
	-- check if item has imbuing slots
	local socketCount = item:getImbuingSlots()
	local rawImbuements = item:getImbuements()
	
	socketCount = math.max(item:getImbuingSlots(), #rawImbuements)
	if socketCount == 0 then
		if item:getId() == 22678 then
			local altarPos = altar:getPosition()
			item:getPosition():sendMagicEffect(CONST_ME_BLOCKHIT, self)
			altarPos:sendMagicEffect(CONST_ME_FAEEXPLOSION, self)
			self:say("The wand curls and twists itself around, as if it itself does not want to be imbued.", TALKTYPE_MONSTER_SAY, true, self, altarPos)
			return
		end
		
		self:sendCancelMessage("This item is not imbuable.")
		return
	end

	-- store player position for imbuing operation
	local cid = self:getId()
	local imbuCache = {
		altarId = altar:getId(),
		altarPos = altar:getPosition(),
		itemPos = relativePos,
		itemId = item:getId(),
	}
	LastImbuingPosCache[cid] = imbuCache

	-- scan player inventory for creature products
	local products = {}
	local productsSize = 0
	for i = 1, #ImbuingProducts do
		local itemId = ImbuingProducts[i]
		local count = self:getItemCount(itemId)
		if count > 0 then
			products[itemId] = count
			productsSize = productsSize + 1
		end
	end
	
	-- scan item imbuements
	local imbuements = {}
	for _, imbuement in pairs(rawImbuements) do
		local slotId = imbuement.slotId
		imbuements[slotId + 1] = imbuement
		socketCount = math.max(slotId + 1, socketCount)
	end
	
	-- build the packet
	local msg = NetworkMessage()
	msg:addByte(0xEB) -- header
	-- selected item
	msg:addU16(item:getClientId())
	if item:getType():getClassification() > 0 then
		msg:addByte(item:getTier())
	end

	-- item sockets
	msg:addByte(socketCount)
	for i = 1, socketCount do
		local imbuement = imbuements[i]
		if imbuement then
			local imbuId = imbuement.imbuId
			local tier = ((imbuId - 1) % 3) + 1
			local currentDuration = item:getImbuementDuration(imbuement)
			local maxDuration = IMBUING_DEFAULT_DURATION
			if currentDuration == -1 then
				-- permanent imbuement, show filled bar with 0:00
				currentDuration = 1
				maxDuration = 1
			else
				-- duration longer than max, show fully filled bar with timer
				maxDuration = currentDuration < IMBUING_DEFAULT_DURATION and IMBUING_DEFAULT_DURATION or currentDuration
			end
		
			msg:addByte(0x01)
			msg:addImbuementInfo(imbuId, tier, maxDuration)
			msg:addU32(currentDuration) -- current duration
			msg:addU32(IMBUING_DEFAULT_REMOVECOST) -- remove cost
		else
			-- empty slot
			msg:addByte(0x00)
		end
	end

	-- available buffs
	msg:addImbuables(item)
	
	-- available products
	msg:addU32(productsSize)
	for itemId, count in pairs(products) do
		local itemType = ItemType(itemId)
		msg:addU16(itemType and itemType:getClientId() or 100)
		msg:addU16(math.min(count, 0xFFFF))
	end
	
	msg:sendToPlayer(self)
	self:sendResourceBalance(RESOURCE_BANK_BALANCE, self:getBankBalance())
	self:sendResourceBalance(RESOURCE_GOLD_EQUIPPED, self:getMoney())
end

function Player:closeImbuingUI()
	-- unregister imbuing activity
	LastImbuingPosCache[self:getId()] = nil
	
	-- send close packet
	m = NetworkMessage()
	m:addByte(0xEC)
	m:sendToPlayer(self)	
end

local altar = Action()
function altar.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target and target:isItem() then
		local itemType = target:getType()
		if itemType:isMovable() and itemType:isPickupable() then
			player:sendImbuingUI(target, item, toPosition)
			return true
		end
	end
	
	return false
end

for i = 1, #ImbuingAltars do
	altar:id(ImbuingAltars[i])
end
altar:register()

function Player:getImbuementAltar()
	local cid = self:getId()
	
	-- check if altar was used
	local cache = LastImbuingPosCache[cid]
	if not cache then
		return false
	end
	
	-- check if player was not pushed too far
	if self:getPosition():getDistance(cache.altarPos) > 2 then
		return false
	end

	-- check if altar was not moved
	local tile = Tile(cache.altarPos)
	return tile and tile:getItemById(cache.altarId)
end

function Player:getItemByPosition(relativePos, itemId)
	if relativePos.x == CONTAINER_POSITION then
		if relativePos.y <= CONST_SLOT_LAST then
			local item = self:getSlotItem(relativePos.y)
			
			if item then
				if itemId and item:getId() ~= itemId then
					return
				end
				
				return item
			end
		elseif relativePos.y >= 64 then
			local container = self:getContainerById(relativePos.y - 64)
			if container then
				local item = container:getItem(relativePos.z)
				
				if item then
					if itemId and item:getId() ~= itemId then
						return
					end
					
					return item
				end
			end
		end
	else
		local tile = Tile(relativePos)
		return tile and tile:getItemById(itemId)
	end
end

do
	local ec = EventCallback
	function ec.onImbuementApply(player, slotId, imbuId, luckProtection)
		-- check if altar is still nearby
		local altar = player:getImbuementAltar()
		if not altar then
			player:closeImbuingUI()
			player:sendInfoBox("Error")
			return
		end
	
		-- locate selected item
		local cache = LastImbuingPosCache[player:getId()]
		local item = player:getItemByPosition(cache.itemPos, cache.itemId)
		if not item then
			player:closeImbuingUI()
			player:sendInfoBox("Error: item not found")
			return
		end
		
		-- check socket
		if item:getImbuement(slotId) then
			player:sendInfoBox("Error: slot already occupied")
			return
		end
		
		-- check if item is eligible
		if not item:canBeImbuedWith(imbuId) then
			player:sendInfoBox("This item cannot hold this imbuement.")
			return
		end
		
		local tier = ((imbuId - 1) % 3) + 1
		
		-- check price
		local imbuPrice = imbuingTiersConfig[tier].price + (luckProtection and imbuingTiersConfig[tier].protectionCost or 0)
		if player:getTotalMoney() < imbuPrice then
			player:sendInfoBox("You do not have enough money.")
			player:sendResourceBalance(RESOURCE_BANK_BALANCE, player:getBankBalance())
			player:sendResourceBalance(RESOURCE_GOLD_EQUIPPED, player:getMoney())
			return
		end
		
		-- check ingredients
		local altarId = math.floor((imbuId - (imbuId - 1) % 3) / 3) + 1
		if ImbuingAltar[altarId] then
			for tierId = 1, tier do
				local product = ImbuingAltar[altarId].products[tierId]
				if product then
					if player:getItemCount(product[1]) < product[2] then
						player:sendInfoBox("You do not have required items.")
						return
					end
				end
			end
		else
			player:closeImbuingUI()
			player:sendInfoBox("Error: server error (missing ingredients list)")
			return
		end
		
		-- consume ingredients and money
		player:removeTotalMoney(imbuPrice)
		for tierId = 1, tier do
			local product = ImbuingAltar[altarId].products[tierId]
			if product then
				player:removeItem(product[1], product[2])
			end
		end
		cache.itemPos = item:getRelativePosition(player)
		
		-- roll for success
		if not luckProtection and math.random(1, 100) > imbuingTiersConfig[tier].successChance then
			player:sendImbuingUI(item, altar, item:getRelativePosition(player))
			player:sendInfoBox("Imbuing attempt unsuccessful.")
			return
		end
		
		-- imbue
		item:setImbuement(slotId, imbuId, IMBUING_DEFAULT_DURATION)
		player:sendImbuingUI(item, altar, item:getRelativePosition(player))
	end
	ec:register()
end

do
	local ec = EventCallback
	function ec.onImbuementClear(player, slotId)
		-- check if altar is still nearby
		local altar = player:getImbuementAltar()
		if not altar then
			player:closeImbuingUI()
			player:sendInfoBox("Error")
			return
		end

		-- locate selected item		
		local cache = LastImbuingPosCache[player:getId()]
		local item = player:getItemByPosition(cache.itemPos, cache.itemId)
		if not item then
			player:closeImbuingUI()
			player:sendInfoBox("Error: item not found")
			return
		end
		
		-- check socket
		if not item:getImbuement(slotId) then
			player:sendImbuingUI(item, altar, item:getRelativePosition(player))
			player:sendInfoBox("Error: selected slot is not imbued")
			return
		end
		
		if player:getTotalMoney() >= IMBUING_DEFAULT_REMOVECOST then
			if item:removeImbuement(slotId) then
				player:removeTotalMoney(IMBUING_DEFAULT_REMOVECOST)
				player:sendImbuingUI(item, altar, item:getRelativePosition(player))
			else
				player:sendImbuingUI(item, altar, item:getRelativePosition(player))
				player:sendInfoBox("Error: failed to remove imbuement")
			end
		else
			player:sendInfoBox("You do not have enough money.")
			player:sendResourceBalance(RESOURCE_BANK_BALANCE, player:getBankBalance())
			player:sendResourceBalance(RESOURCE_GOLD_EQUIPPED, player:getMoney())
		end
	end
	ec:register()
end

do
	local ec = EventCallback
	function ec.onImbuementExit(player)
		-- unregister imbuing activity
		LastImbuingPosCache[player:getId()] = nil
	end
	ec:register()
end