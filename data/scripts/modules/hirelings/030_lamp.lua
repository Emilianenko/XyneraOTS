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

-- hireling lamp
local hirelingLamp = Action()
function hirelingLamp.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:isAdmin() then
		player:sendTextMessage(MESSAGE_INFO_DESCR, "Administrator mode: placing hireling anywhere.")
		player:createHirelingFromLamp(item, true)
		return true
	end
	
	local tile = player:getTile()
	if tile then
		local house = tile:getHouse()
		if house and house:getOwnerGuid() == player:getGuid() then
			player:createHirelingFromLamp(item)
			return true
		end
	end
	
	player:getPosition():sendMagicEffect(CONST_ME_POFF)
	return false
end
hirelingLamp:id(ITEM_HIRELING_LAMP) -- 32088
hirelingLamp:register()

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

-- dismiss a hireling
local ec = EventCallback
function ec.onUseCreature(player, target)
	if not target then
		return
	end
	
	if not target:isNpc() then
		local tile = target:getTile()
		if tile then
			for _, creature in pairs(tile:getCreatures()) do
				if creature:isNpc() then
					target = creature
					break
				end
			end
		end	
	end
	
	if not target:isNpc() then
		if player:isAdmin() then
			target:remove()
			player:sendTextMessage(MESSAGE_INFO_DESCR, "Creature removed.")
		end
		return
	end
	
	player:dismissHireling(target)
end
ec:register()