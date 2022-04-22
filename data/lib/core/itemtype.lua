function ItemType:isItemType()
	return true
end

do
	local currencies = {}
	for _, itemType in ipairs(Game.getCurrencyItems()) do
		currencies[#currencies + 1] = itemType:getId()
	end

	function ItemType:isCurrency()
		return table.contains(currencies, self:getId())
	end
end

do
	local slotBits = {
		[CONST_SLOT_HEAD] = SLOTP_HEAD,
		[CONST_SLOT_NECKLACE] = SLOTP_NECKLACE,
		[CONST_SLOT_BACKPACK] = SLOTP_BACKPACK,
		[CONST_SLOT_ARMOR] = SLOTP_ARMOR,
		[CONST_SLOT_RIGHT] = SLOTP_RIGHT,
		[CONST_SLOT_LEFT] = SLOTP_LEFT,
		[CONST_SLOT_LEGS] = SLOTP_LEGS,
		[CONST_SLOT_FEET] = SLOTP_FEET,
		[CONST_SLOT_RING] = SLOTP_RING,
		[CONST_SLOT_AMMO] = SLOTP_AMMO
	}

	function ItemType:usesSlot(slot)
		return bit.band(self:getSlotPosition(), slotBits[slot] or 0) ~= 0
	end
end

function ItemType:isHelmet()
	return self:usesSlot(CONST_SLOT_HEAD)
end

function ItemType:isArmor()
	return self:usesSlot(CONST_SLOT_ARMOR)
end

function ItemType:isLegs()
	return self:usesSlot(CONST_SLOT_LEGS)
end

function ItemType:isBoots()
	return self:usesSlot(CONST_SLOT_FEET)
end

do
	local notWeapons = {WEAPON_NONE, WEAPON_SHIELD, WEAPON_AMMO}
	function ItemType:isWeapon()
		return not table.contains(notWeapons, self:getWeaponType())
	end
end

function ItemType:isTwoHanded()
	return bit.band(self:getSlotPosition(), SLOTP_TWO_HAND) ~= 0
end

function ItemType:isClub()
	return self:getWeaponType() == WEAPON_CLUB
end

function ItemType:isSword()
	return self:getWeaponType() == WEAPON_SWORD
end

function ItemType:isAxe()
	return self:getWeaponType() == WEAPON_AXE
end

function ItemType:isBow()
	local ammoType = self:getAmmoType()
	return self:getWeaponType() == WEAPON_DISTANCE and (ammoType == AMMO_ARROW or ammoType == AMMO_BOLT)
end

function ItemType:isMissile()
	local ammoType = self:getAmmoType()
	return self:getWeaponType() == WEAPON_DISTANCE and ammoType ~= AMMO_ARROW and ammoType ~= AMMO_BOLT
end

function ItemType:isDistanceWeapon()
	return self:isBow() or self:isMissile()
end

function ItemType:isQuiver()
	return self:getWeaponType() == WEAPON_QUIVER
end

function ItemType:isWand()
	return self:getWeaponType() == WEAPON_WAND
end

function ItemType:isShield()
	return self:getWeaponType() == WEAPON_SHIELD
end

function ItemType:isBackpack()
	return self:usesSlot(CONST_SLOT_BACKPACK)
end

function ItemType:isNecklace()
	return self:usesSlot(CONST_SLOT_NECKLACE)
end

function ItemType:isRing()
	return self:usesSlot(CONST_SLOT_RING)
end

function ItemType:isAmmo()
	return self:getWeaponType() == WEAPON_AMMO
end

function ItemType:isTrinket()
	return self:usesSlot(CONST_SLOT_AMMO) and self:getWeaponType() == WEAPON_NONE
end

function ItemType:isKey()
	return self:getType() == ITEM_TYPE_KEY
end

function ItemType:isBed()
	return self:getType() == ITEM_TYPE_BED
end

function ItemType:isSplash()
	return self:getGroup() == ITEM_GROUP_SPLASH
end

function ItemType:isPodium()
	return self:getGroup() == ITEM_GROUP_PODIUM
end

function ItemType:isTeleport()
	return self:getGroup() == ITEM_GROUP_TELEPORT or self:getType() == ITEM_TYPE_TELEPORT
end

do
	local realSlot = {
		isHelmet = CONST_SLOT_HEAD,
		isArmor = CONST_SLOT_ARMOR,
		isLegs = CONST_SLOT_LEGS,
		isBoots = CONST_SLOT_FEET,
		
		isWeapon = CONST_SLOT_LEFT,
		isWand = CONST_SLOT_LEFT,
		isMissile = CONST_SLOT_LEFT,
		isBow = CONST_SLOT_LEFT,
		
		isShield = CONST_SLOT_RIGHT,
		
		isBackpack = CONST_SLOT_BACKPACK,
		isNecklace = CONST_SLOT_NECKLACE,
		isRing = CONST_SLOT_RING,
		isAmmo = CONST_SLOT_AMMO,
		isTrinket = CONST_SLOT_AMMO
	}

	function ItemType:getRealSlot()
		for func, slot in pairs(realSlot) do
			if ItemType[func](self) then
				return slot
			end
		end
	end
end

function ItemType:getWeaponString()
	local weaponType = self:getWeaponType()
	local weaponString = "unknown"

	if weaponType == WEAPON_CLUB then
		weaponString = "blunt instrument"
	elseif weaponType == WEAPON_SWORD then
		weaponString = "stabbing weapon"
	elseif weaponType == WEAPON_AXE then
		weaponString = "cutting weapon"
	elseif weaponType == WEAPON_DISTANCE then
		weaponString = self:isBow() and "firearm" or "missile"
	elseif weaponType == WEAPON_WAND then
		weaponString = "wand/rod"
	elseif weaponType == WEAPON_FIST then
		weaponString = "punching weapon"
	elseif weaponType == WEAPON_QUIVER then
		weaponString = "quiver"	
	end
	
	if self:isTwoHanded() then
		weaponString = string.format("%s, two-handed", weaponString)
	end
	
	return weaponString
end


---- BEGIN SUPPLY SYSTEM
TrackableSupplies = {
	-- enchanting
	2146, 2147, 2149, 2150, 7759, 7760, 7761, 7762, 24739,
	
	-- rust and muck removers
	9930, 18395
}

function ItemType:isSupply()
	return table.contains(TrackableSupplies, self:getId()) or self:getDecayId() < 1 and (self:getCharges() > 0 or self:getDuration() > 0)
end

function registerSupply(itemId)
	if not table.contains(TrackableSupplies, itemId) then
		TrackableSupplies[#TrackableSupplies + 1] = itemId
		return true
	end

	return false
end

-- register as supplies, supplyBlock = {[itemId] = anything}
function registerSupplies(supplyBlock)
	for itemId, _ in pairs(supplyBlock) do
		if not registerSupply(itemId) then
			-- no point in looping when they are already registered
			break
		end
	end
end
---- END SUPPLY SYSTEM


---- BEGIN BOOST REFLECT
-- used interchangeably with Item:getAllReflects() for polymorphism in onLook
-- returns table with [combatId] = {chance = x, percent = y}
-- COMBAT_(element)DAMAGE = 2^combatId
function ItemType:getAllReflects()
	local abilities = self:getAbilities()
	local response = {}
	
	for combatId, chance in pairs(abilities.reflectChance) do
		local percent = abilities.reflectPercent[combatId]
		response[combatId] = {chance = chance, percent = percent}
	end
	
	return response
end

-- same as above
function ItemType:getAllBoosts()
	return self:getAbilities().boostPercent
end
---- END BOOST REFLECT


---- BEGIN TIER SYSTEM
function ItemType:getTier()
	return 0
end

-- bonus scaling for tiered items
do
	local function calculateTierBonus(tier, x, y)
		return x * tier + y * (tier-1)^2
	end

	function ItemType:getTierBonus(tier)
		if tier == 0 then
			return -1, 0
		end
		
		if self:isWeapon() then
			-- onslaught (fatal)
			return SPECIALSKILL_ONSLAUGHT, calculateTierBonus(tier, 0.5, 0.05)
		elseif self:isArmor() then
			-- ruse (dodge)
			return SPECIALSKILL_RUSE, calculateTierBonus(tier, 0.5, 0.03)
		elseif self:isHelmet() then
			-- momentum (cooldown reset)
			return SPECIALSKILL_MOMENTUM, calculateTierBonus(tier, 2, 0.05)
		end
		
		return -1, 0
	end
end
---- END TIER SYSTEM