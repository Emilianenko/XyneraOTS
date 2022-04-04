-- NOTE: if you want to use a custom cancel message
-- or cancel the action without sending any message,
-- put RETURNVALUE_SCRIPT in "return" statement

local ec = EventCallback

ec.onMoveItem = function(self, item, count, fromPosition, toPosition, fromCylinder, toCylinder)
	-- logic for moving store items
	if item:isStoreItem() then
		if fromPosition.x == CONTAINER_POSITION then
			if toPosition.x == CONTAINER_POSITION and not toCylinder:getTopParent():isPlayer() then
				-- trying to put store item in house chests (from other container)
				return RETURNVALUE_ITEMCANNOTBEMOVEDTHERE
			end
			
			local toTile = Tile(toCylinder:getPosition())
			local toHouse = toTile and toTile:getHouse()
			if toHouse and toHouse:getOwnerAccountId() ~= self:getAccountId() then
				-- trying to put store item on the floor as house guest
				return RETURNVALUE_ITEMCANNOTBEMOVEDTHERE
			end
		elseif toPosition.x == CONTAINER_POSITION then
			if not toCylinder:getTopParent():isPlayer() then
				-- trying to put store item in house chests (from the floor)
				return RETURNVALUE_ITEMCANNOTBEMOVEDTHERE
			end
			
			local fromTile = Tile(fromPosition)
			local fromHouse = fromTile and fromTile:getHouse()
			if fromHouse and fromHouse:getOwnerAccountId() ~= self:getAccountId() then
				-- trying to take the store item as house guest
				return RETURNVALUE_NOTPOSSIBLE
			end			
		else
			local fromTile = Tile(fromPosition)
			local toTile = Tile(toPosition)
			if fromTile and toTile then
				local fromHouse = fromTile:getHouse()
				local toHouse = toTile:getHouse()
				if not (fromHouse and toHouse and fromHouse:getOwnerAccountId() == toHouse:getOwnerAccountId()) then
					-- trying to throw the store item out of the house
					return RETURNVALUE_NOTPOSSIBLE
				end
			end
		end
		
		if (fromPosition.x ~= CONTAINER_POSITION and toPosition.x ~= CONTAINER_POSITION) or tile and not tile:getHouse() then
			if tile then 
				local house = tile:getHouse()
				if not house then
					return RETURNVALUE_NOTPOSSIBLE
				end
			end
		end
	end

	if toPosition.x ~= CONTAINER_POSITION then
		return RETURNVALUE_NOERROR
	end

	-- logic for moving items between/to containers
	local itemId = item:getId()
	if toCylinder:isItem() then
		local parent = toCylinder:getParent()
		
		-- moving into store inbox
		if parent:isItem() and parent:getId() == ITEM_STORE_INBOX then
			-- opened gold pouch container: try to move into container
			if toCylinder:getId() == ITEM_GOLD_POUCH then
				if item:getWorth() == 0 then
					-- gold pouch: item is not a currency
					self:sendTextMessage(MESSAGE_STATUS_SMALL, "You can move only money to this container.")
					return RETURNVALUE_SCRIPT
				end				
			else
				-- store inbox: container is not a gold pouch
				return RETURNVALUE_NOTPOSSIBLE
			end
		elseif toCylinder:getId() == ITEM_STORE_INBOX then
			-- opened store inbox: drag to gold pouch slot
			local targetItem = toCylinder:getItem(toPosition.z)
			if targetItem and targetItem:isContainer() then
				if targetItem:getId() == ITEM_GOLD_POUCH then
					if item:getWorth() == 0 then
						-- gold pouch: item is not a currency
						self:sendTextMessage(MESSAGE_STATUS_SMALL, "You can move only money to this container.")
						return RETURNVALUE_SCRIPT
					end
				else
					-- store inbox: container is not a gold pouch
					return RETURNVALUE_NOTPOSSIBLE
				end
			end
		end
		
		-- gold pouch without store flag
		local targetItem = toCylinder:getItem(toPosition.z)
		if (targetItem and targetItem:getId() == ITEM_GOLD_POUCH or toCylinder:getId() == ITEM_GOLD_POUCH) and item:getWorth() == 0 then
			-- gold pouch: item is not a currency
			self:sendTextMessage(MESSAGE_STATUS_SMALL, "You can move only money to this container.")
			return RETURNVALUE_SCRIPT
		end
		
	end
	
	if item:getTopParent() == self and bit.band(toPosition.y, 0x40) == 0 then
		local itemType, moveItem = ItemType(item:getId())
		if bit.band(itemType:getSlotPosition(), SLOTP_TWO_HAND) ~= 0 and toPosition.y == CONST_SLOT_LEFT then
			moveItem = self:getSlotItem(CONST_SLOT_RIGHT)
		elseif itemType:getWeaponType() == WEAPON_SHIELD and toPosition.y == CONST_SLOT_RIGHT then
			moveItem = self:getSlotItem(CONST_SLOT_LEFT)
			if moveItem and bit.band(ItemType(moveItem:getId()):getSlotPosition(), SLOTP_TWO_HAND) == 0 then
				return RETURNVALUE_NOERROR
			end
		end

		if moveItem then
			local parent = item:getParent()
			if parent:isContainer() and parent:getSize() == parent:getCapacity() then
				return RETURNVALUE_CONTAINERNOTENOUGHROOM
			else
				return moveItem:moveTo(parent)
			end
		end
	end

	return RETURNVALUE_NOERROR
end

ec:register()
