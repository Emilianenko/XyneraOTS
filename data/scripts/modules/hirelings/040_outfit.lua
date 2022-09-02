-- get id by looktype
local reverseHirelingOutfitMap = {}
local outfitTypes = {"male", "female", "type"}
for hirelingId, hirelingData in pairs(HirelingOutfits) do
	for i = 1, #outfitTypes do
		local lookType = hirelingData[outfitTypes[i]]
		if lookType then
			reverseHirelingOutfitMap[lookType] = hirelingId
		end
	end
end
function getHirelingOutfitIdByLookType(lookType)
	return reverseHirelingOutfitMap[lookType]
end

-- cache (reload-proofed)
if not HirelingsUsageCache then
	HirelingsUsageCache = {}
end
if not HirelingsPlacedCache then
	HirelingsPlacedCache = {}
end

-- unreferencing hireling outfit
local function unregisterHirelingOutfit(owner, outfitId)
	if HirelingsUsageCache[owner] and HirelingsUsageCache[owner][outfitId] then
		local newVal = HirelingsUsageCache[owner][outfitId] - 1
		if newVal > 0 then
			HirelingsUsageCache[owner][outfitId] = newVal
		else
			HirelingsUsageCache[owner][outfitId] = nil
		end
	end
end

---- INIT (on place npc)
function onHirelingInit(cid)
	local npc = Npc(cid)
	if npc then
		local owner = npc:getOwnerGUID()
		if owner ~= 0 then
			if HirelingsPlacedCache[owner] then
				for npcIndex, npcId in pairs(HirelingsPlacedCache[owner]) do
					if npcId == cid then
						-- already initialized
						return
					end
				end
			else
				HirelingsPlacedCache[owner] = {}
			end
			
			HirelingsPlacedCache[owner][#HirelingsPlacedCache[owner] + 1] = cid
			
			local lookType = npc:getOutfit().lookType			
			if not HirelingsUsageCache[owner] then
				HirelingsUsageCache[owner] = {}
			end
			
			local outfitId = getHirelingOutfitIdByLookType(lookType)
			if outfitId then
				HirelingsUsageCache[owner][outfitId] = HirelingsUsageCache[owner][outfitId] and HirelingsUsageCache[owner][outfitId] + 1 or 1
			end
		end		
	end
end

---- DESTROY (on remove npc)
function onHirelingDestroy(cid, owner, lookType)
	if owner ~= 0 then
		local outfitId = getHirelingOutfitIdByLookType(lookType)
		if outfitId then
			unregisterHirelingOutfit(owner, outfitId)
		end
		
		if HirelingsPlacedCache[owner] then
			for npcIndex, npcId in pairs(HirelingsPlacedCache[owner]) do
				if npcId == cid then
					table.remove(HirelingsPlacedCache[owner], npcIndex)
					return
				end
			end
		end
	end
end

---- SENDING OUTFIT WINDOW
local function sendHirelingUI(player, target)
	local outfitNames = {}
	local outfitList = {}
	if not player:isAdmin() then
		local npc = Npc(target:getId())
		if not npc then
			return
		elseif npc:getOwnerGUID() ~= player:getGuid() then
			player:sendCancelMessage("You do not own this hireling.")
			return
		end
		
		local npcSex = sexToString(npc:getSex())
		local owner = player:getGuid()
		for outfitId, outfitData in pairs(HirelingOutfits) do
			local lookType = outfitData.type or outfitData[npcSex]
			local outfitsInUse = HirelingsUsageCache[owner] and HirelingsUsageCache[owner][outfitId] or 0
			if (player:getStorageValue(HIRELING_UNLOCK_BASE_STORAGE + outfitId) > outfitsInUse)
				or lookType == HIRELING_BASE_MALE
				or lookType == HIRELING_BASE_FEMALE then
				
				outfitList[#outfitList + 1] = lookType
				outfitNames[#outfitNames + 1] = outfitData.name
			end
		end
	else
		-- all in-game looktypes
		local realCount = LOOK_TYPE_LAST - #InvalidLookTypes
		for lookType = 1, LOOK_TYPE_LAST do
			if not table.contains(InvalidLookTypes, lookType) then
				outfitList[#outfitList + 1] = lookType
				outfitNames[#outfitNames + 1] = lookType
			end
		end
	end

	local currentOutfit = target:getOutfit()
	local m = NetworkMessage()
	m:addByte(0xC8)
	
	-- current outfit
	m:addU16(currentOutfit.lookType)
	m:addByte(currentOutfit.lookHead)
	m:addByte(currentOutfit.lookBody)
	m:addByte(currentOutfit.lookLegs)
	m:addByte(currentOutfit.lookFeet)
	m:addByte(currentOutfit.lookAddons)
	
	-- current mount
	m:addU16(0)
	m:addByte(0)
	m:addByte(0)
	m:addByte(0)
	m:addByte(0)
	
	-- current familiar
	m:addU16(0)
	
	-- outfits block
	m:addU16(#outfitList)
	for i = 1, #outfitList do
		local lookType = outfitList[i]
		m:addU16(lookType)
		m:addString(outfitNames[i])
		m:addByte(0) -- unlocked addons
		m:addByte(0) -- unlock mode (0 - available, 1 - store (requires u32 offerId after that), 2 - golden outfit tooltip, 3 - royal costume tooltip
	end
	
	-- mounts block
	m:addU16(0)
	
	-- familiars block
	m:addU16(0)
	
	-- flags
	m:addByte(0x03) -- outfit window mode
	m:addByte(0x00) -- Is mounted bool
	m:addU32(target:getId())
	m:sendToPlayer(player)
end

---- REQUESTING OUTFIT WINDOW
do
	local ec = EventCallback
	function ec.onDressOtherCreatureRequest(player, target)
		sendHirelingUI(player, target)
	end
	ec:register()
end

---- APPLYING NEW OUTFIT
do
	local ec = EventCallback
	function ec.onDressOtherCreature(player, target, outfit)
		-- PLAYER HIRELING UI
		if not player:isAdmin() then
			local npc = Npc(target:getId())
			if not npc then
				return
			elseif npc:getOwnerGUID() ~= player:getGuid() then
				player:sendCancelMessage("You do not own this hireling.")
				return
			end

			-- prevent spoofed packets
			outfit.lookMount = 0
			outfit.lookAddons = 0
			local lookType = outfit.lookType
			local outfitId = getHirelingOutfitIdByLookType(lookType)
			if not outfitId then
				player:sendCancelMessage("Your hireling cannot wear this outfit.")
				return
			end
			
			-- check if player has enough copies of this outfit available
			local owner = player:getGuid()
			local outfitCount = HirelingsUsageCache[owner][outfitId] or 0
			if not (lookType == HIRELING_BASE_MALE or lookType == HIRELING_BASE_FEMALE) then
				if player:getStorageValue(HIRELING_UNLOCK_BASE_STORAGE + outfitId) < outfitCount + 1 then
					player:sendCancelMessage("You do not have enough copies of this outfit.")
					return
				end
			end
			-- verify npc sex
			local npcSex = sexToString(npc:getSex())
			if lookType ~= (HirelingOutfits[outfitId][npcSex] or HirelingOutfits[outfitId].type) then
				-- wrong npc sex, convert to correct looktype
				outfit.lookType = HirelingOutfits[outfitId][sexToString((npc:getSex() + 1) % 2)]
				lookType = outfit.lookType
			end
			
			-- unregister old outfit
			local prevLookType = npc:getOutfit().lookType
			local prevOutfitId = getHirelingOutfitIdByLookType(prevLookType)
			if prevOutfitId then
				unregisterHirelingOutfit(owner, prevOutfitId)
			end
			
			HirelingsUsageCache[owner][outfitId] = outfitCount + 1
			target:setOutfit(outfit)
			return
		end
		-- END PLAYER HIRELING UI
		
		-- ADMIN HIRELING UI
		if outfit.lookType and table.contains(InvalidLookTypes, outfit.lookType) then
			player:sendCancelMessage("Invalid looktype.")
			return
		end
		
		target:setOutfit(outfit)
		-- END ADMIN HIRELING UI
	end
	ec:register()
end