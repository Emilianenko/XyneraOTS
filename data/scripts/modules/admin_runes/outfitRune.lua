local function sendCraftedOutfitWindowTarget(player, target)
	if not player:isAdmin() then
		return true
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
	m:addU16(currentOutfit.lookMount)
	m:addByte(currentOutfit.lookMountHead)
	m:addByte(currentOutfit.lookMountBody)
	m:addByte(currentOutfit.lookMountLegs)
	m:addByte(currentOutfit.lookMountFeet)
	
	-- current familiar (wont be applied by this script)
	m:addU16(0)

	local realCount = LOOK_TYPE_LAST - #InvalidLookTypes
	
	-- outfits block
	m:addU16(realCount)
	for lookType = 1, LOOK_TYPE_LAST do
		if not table.contains(InvalidLookTypes, lookType) then
			m:addU16(lookType)
			m:addString(tostring(lookType))
			m:addByte(3) -- unlocked addons
			m:addByte(0) -- unlock mode (0 - available, 1 - store (requires u32 offerId after that), 2 - golden outfit tooltip, 3 - royal costume tooltip
		end
	end
	
	-- mounts block
	m:addU16(realCount)
	for lookType = 1, LOOK_TYPE_LAST do
		if not table.contains(InvalidLookTypes, lookType) then
			m:addU16(lookType)
			m:addString(tostring(lookType))
			m:addByte(0)
		end
	end
	
	-- familiars block
	m:addU16(0)
	
	-- flags
	m:addByte(0)
	m:addByte(0)
	
	-- randomize
	m:addByte(0)
	m:sendToPlayer(player)
end

-- click on anyone to edit his outfit
local targets = {}
local outfits = {}

local outfitRune = Action()
function outfitRune.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player:isAdmin() then
		return false
	end
	
	if target and target:isCreature() then
		local cid = player:getId()
		local tid = target:getId()
		if cid ~= tid then
			targets[cid] = tid
			outfits[cid] = player:getOutfit()
		end
		sendCraftedOutfitWindowTarget(player, target)
	end

	return true
end
outfitRune:allowFarUse(true)
outfitRune:blockWalls(false)
outfitRune:checkFloor(false)
outfitRune:id(2284)
outfitRune:register()

local ec = EventCallback
ec.onChangeOutfit = function(self, outfit)
	if not self:isPlayer() or not self:isAdmin() then
		return true
	end
	
	local cid = self:getId()
	local targetId = targets[cid]
	if targetId then
		local target = Creature(targetId)
		targets[cid] = nil
		if not target then
			self:sendTextMessage(MESSAGE_INFO_DESCR, "Creature not found.")
			return false
		end
		
		target:setOutfit(outfit)
		if outfits[cid] then
			self:setOutfit(outfits[cid])
			outfits[cid] = nil
		end
		
		return false
	end
	
	return true
end
ec:register(-1)
