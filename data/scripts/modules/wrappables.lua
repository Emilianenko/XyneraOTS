local constructionKits = {
	[3901] = 1666, [3902] = 1670, [3903] = 1652, [3904] = 1674, [3905] = 1658,
	[3906] = 3813, [3907] = 3817, [3908] = 1619, [3909] = 2105, [3910] = 12799,
	[3911] = 1614, [3912] = 3806, [3913] = 3807, [3914] = 3809, [3915] = 1716,
	[3916] = 1724, [3917] = 1732, [3918] = 1775, [3919] = 1774, [3920] = 1750,
	[3921] = 3832, [3922] = 2095, [3923] = 2098, [3924] = 2064, [3925] = 2582,
	[3926] = 2117, [3927] = 1728, [3928] = 1442, [3929] = 1446, [3930] = 1447,
	[3931] = 2034, [3932] = 2604, [3933] = 2080, [3934] = 2084, [3935] = 3821,
	[3936] = 3811, [3937] = 2101, [3938] = 3812, [5086] = 5046, [5087] = 5055,
	[5088] = 5056, [6114] = 6111, [6115] = 6109, [6372] = 6356, [6373] = 6371,
	[8692] = 8688, [9974] = 9975, [11126] = 11127, [11133] = 11129, [11124] = 11125,
	[11205] = 11203, [14328] = 1616, [14329] = 1615, [16075] = 16020, [16099] = 16098,
	[20254] = 20295, [20255] = 20297, [20257] = 20299
}

-- auto generate entries for rotated furniture data
local rotateMap = {}
for kitId, furnitureId in pairs(constructionKits) do
	local tmpId = furnitureId
	repeat
		rotateMap[tmpId] = kitId
		
		local itemType = ItemType(tmpId)
		tmpId = itemType and itemType:getRotateId() or tmpId
	until rotateMap[tmpId]
end

-- wrap/unwrap handler
local function wrap(player, item)
	-- determine transferability
	local itemId = item:getId()
	local transformId = item:hasAttribute(ITEM_ATTRIBUTE_WRAPID) and item:getAttribute(ITEM_ATTRIBUTE_WRAPID) or constructionKits[itemId] or rotateMap[itemId]
	if not transformId then
		-- unable to find transform id
		return RETURNVALUE_CANNOTUSETHISOBJECT
	end
	
	local transformItemType = ItemType(transformId)
	if not transformItemType then
		-- bad transform id
		return RETURNVALUE_CANNOTUSETHISOBJECT
	end
	
	-- locate destination tile
	local tile = item:getTile()
	if not tile then
		-- unable to locate target tile
		return RETURNVALUE_CANNOTUSETHISOBJECT	
	end
	
	-- check if house
	local house = tile:getHouse()
	if not house or player:getAccountId() ~= house:getOwnerAccountId() then
		-- not in own house
		return RETURNVALUE_YOUCANONLYUNWRAPINOWNHOUSE	
	end
	
	-- try to wrap
	if transformItemType:isMovable() and transformItemType:isPickupable() then
		local itemCopy = item:clone()
		if itemCopy:hasAttribute(ITEM_ATTRIBUTE_WRAPID) then
			itemCopy:setAttribute(ITEM_ATTRIBUTE_WRAPID, itemId)
		end
			
		if player:getFreeCapacity() < itemCopy:getWeight() then
			itemCopy:remove()
			return RETURNVALUE_NOTENOUGHCAPACITY
		end
		
		local targetCylinder = player:getSlotItem(CONST_SLOT_BACKPACK)
		if itemCopy:isStoreItem() then
			targetCylinder = player:getStoreInbox()
		end
		
		if not targetCylinder then
			return RETURNVALUE_NOTENOUGHROOM
		end
		
		local ret = targetCylinder:addItemEx(itemCopy, -1, FLAG_IGNORENOTPICKUPABLE)
		itemCopy:transform(transformId)
		
		if ret == RETURNVALUE_NOERROR then
			item:remove()
		else
			itemCopy:remove()
		end
			
		return ret
	end
	
	-- send successful unwrap effect
	local topCylinder = item:getTopParent()
	local npos = topCylinder and topCylinder:getPosition()
	if npos then
		npos:sendMagicEffect(CONST_ME_BLOCKHIT)
	end
	
	-- unwrap
	if item:hasAttribute(ITEM_ATTRIBUTE_WRAPID) then
		item:setAttribute(ITEM_ATTRIBUTE_WRAPID, item:getId())
	end
	item:transform(transformId)
	item:moveTo(tile:getPosition())
	
	return RETURNVALUE_NOERROR
end

-- unwrapping on use
do
	local action = Action()
	action.onUse = function (player, item, fromPosition, target, toPosition, isHotkey)
		local wrapResponse = wrap(player, item)
		if wrapResponse ~= RETURNVALUE_NOERROR then
			-- send failed unwrap effect
			local topCylinder = item:getTopParent()
			local npos = topCylinder and topCylinder:getPosition()
			if npos then
				npos:sendMagicEffect(CONST_ME_BLOCKHIT)
			end
	
			player:sendCancelMessage(wrapResponse)
		end
		return true
	end
	for kitId, _ in pairs(constructionKits) do
		action:id(kitId)
	end
	action:id(ITEM_DECORATION_KIT)
	action:register()
end

-- wrap context menu
do
	local ec = EventCallback
	ec.onWrapItem = function(self, item)
		local wrapResponse = wrap(self, item)
		if wrapResponse ~= RETURNVALUE_NOERROR then
			if wrapResponse == RETURNVALUE_CANNOTUSETHISOBJECT then
				wrapResponse = RETURNVALUE_NOTPOSSIBLE
			end
			self:sendCancelMessage(wrapResponse)
		end
	end
	ec:register()
end
