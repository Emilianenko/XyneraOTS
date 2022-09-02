--[[
functions added:	
	- sexToString(sex)
	- Game.playerExists(name)

	- Item:getHirelingLampDescription()

	- Creature:changeSex()
	- Creature:rename(newName)

	- Player:addHirelingOutfit(hirelingId, count)
	- Player:createHirelingFromLamp(item, isAdmin)
	- Player:dismissHireling(target)	
]]

ChangeSexMap = {}

do
	-- player outfits
	local outfits_f = Game.getOutfits(PLAYERSEX_FEMALE)
	local outfits_m = Game.getOutfits(PLAYERSEX_MALE)
	for i = 1, #outfits_f do
		local outfit_m = outfits_m[i]
		local outfit_f = outfits_f[i]
		
		local lookType_m = outfits_m[i].lookType
		local lookType_f = outfits_f[i].lookType
		
		ChangeSexMap[outfits_m[i].lookType] = lookType_f
		ChangeSexMap[outfits_f[i].lookType] = lookType_m
	end
	
	-- mage/summoner fix
	ChangeSexMap[130] = 141
	ChangeSexMap[133] = 138
	ChangeSexMap[138] = 133
	ChangeSexMap[141] = 130

	-- hireling outfits
	for _, outfitData in pairs(HirelingOutfits) do
		if outfitData.male and outfitData.female then
			ChangeSexMap[outfitData.male] = outfitData.female
			ChangeSexMap[outfitData.female] = outfitData.male
		elseif outfitData.type then
			ChangeSexMap[outfitData.type] = outfitData.type
		end
	end
end

function Creature:changeSex()
	local currentOutfit = self:getOutfit()
	local oldLookType = currentOutfit.lookType
	currentOutfit.lookType = ChangeSexMap[currentOutfit.lookType] or currentOutfit.lookType
	self:setOutfit(currentOutfit)
	
	if self:isPlayer() or self:isNpc() or oldLookType ~= currentOutfit.lookType then
		self:setSex((self:getSex() + 1) % 2)
		return true
	end
	
	return false
end

-- get sex name
function sexToString(sex)
	return sex == PLAYERSEX_MALE and "male" or "female"
end

-- unlock hireling outfit
function Player:addHirelingOutfit(hirelingId, count)
	if hirelingId <= 1 or hirelingId > 0xFFFF then
		-- id 1 is unlimited
		-- ids below 1 are not allowed
		return false
	end
	
	local currentAmount = math.max(0, self:getStorageValue(HIRELING_UNLOCK_BASE_STORAGE + hirelingId))
	self:setStorageValue(HIRELING_UNLOCK_BASE_STORAGE + hirelingId, math.max(0, currentAmount + count))
	return true
end

-- rename any creature
-- warning: call playerExists before executing this
function Creature:rename(newName)
	local cid = self:getId()
	
	local npc = Npc(cid)
	if npc then
		return npc:setName(newName)
	end

	local player = Player(cid)
	if player then
		local oldName = player:getName()
		local ret = player:setName(newName)

		if ret then
			Game.sendConsoleMessage(CONSOLEMESSAGE_TYPE_INFO, string.format("Name change: \"%s\" --> \"%s\"", oldName, newName))
		end

		return ret
	end

	local monster = Monster(cid)
	if monster then
		return monster:rename(newName)
	end
	
	return false
end

-- check if player exists
function Game.playerExists(name)
	if Player(name) then
		return true
	end
	
	local a = db.storeQuery('SELECT `name` FROM `players` WHERE `name` = ' .. db.escapeString(name) .. ' LIMIT 1')
	return a and true
end

-- onLook description
function Item:getHirelingLampDescription()
	local lamp = HirelingLamp(self.uid)
	if not lamp then
		return false
	end
	
	local name = lamp:hirelingName()
	name = name and name:len() > 0 and name or "Hireling"
	
	local sex = sexToString(lamp:sex())
	local outfitId = getHirelingOutfitIdByLookType(lamp:outfit().lookType)
	local outfitName = outfitId and HirelingOutfits[outfitId].name or "Other"
	
	--local response = string.format("Name: %s\nSex: %s\nOutfit: %s", name, sex, outfitName)
	local response = string.format("%s, %s, %s", name, sex:sub(1, 1):upper(), outfitName)
	local topParent = self:getTopParent()
	if topParent and topParent:isPlayer() and topParent:isAdmin() then
		response = string.format("%s\n[Features: %s]", response, lamp:flags())
	end
	
	return response
end

-- checks are being made in onUse
function Player:createHirelingFromLamp(item, isAdmin)
	local lamp = HirelingLamp(item.uid)
	if not lamp then
		-- missing attr in items.xml or wrong item id
		return
	end
	
	local owner = self:getGuid()
	if isAdmin then
		local tile = self:getTile()
		if tile then
			local house = tile:getHouse()
			if house then
				owner = house:getOwnerGuid()
			end
		end
	end

	local hireling = Game.createNpc("Hireling", self:getPosition(), false, true)
	if hireling then
		-- default attributes
		hireling:setSpeechBubble(SPEECHBUBBLE_HIRELING)
		hireling:setPhantom(true)
		hireling:setOwnerGUID(owner)

		-- lamp attributes
		local name = lamp:hirelingName()
		if name and name:len() > 0 then
			hireling:setName(name)
		end
		hireling:setSex(lamp:sex())
		
		local outfit = lamp:outfit()
		if outfit.lookType ~= 0 or outfit.lookTypeEx ~= 0 then
			hireling:setOutfit(outfit)
		end
				
		-- consume lamp
		item:remove(1)
	end

end

-- send hireling back to lamp
function Player:dismissHireling(target)
	if not self:isAdmin() then
		if target:getSpeechBubble() ~= SPEECHBUBBLE_HIRELING then
			self:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
			return
		end

		if target:getOwnerGUID() ~= self:getGuid() then
			self:sendCancelMessage("You do not own this hireling.")
			return
		end
	end
	
 	local toPos = target:getPosition()
	toPos:sendMagicEffect(CONST_ME_FOAM)
	local item = Game.createItem(ITEM_HIRELING_LAMP, 1)
	if item then
		item:setStoreItem(true)
	end
	local lamp = HirelingLamp(item.uid)
	if lamp then
		lamp:hirelingName(target:getName())
		lamp:sex(target:getSex())
		lamp:outfit(target:getOutfit())
		lamp:flags(math.max(0, Game.playerHirelingFeatures(target:getOwnerGUID())))
		lamp:direction(target:getDirection())
		lamp:unpacked(false)
	end
	
	self:getStoreInbox():addItemEx(item, -1, bit.bor(FLAG_NOLIMIT, FLAG_IGNORENOTPICKUPABLE))
	target:remove()
end
