local ec = EventCallback

ec.onLook = function(self, thing, position, distance, description)
	local description = "You see " .. thing:getDescription(distance)
	if self:getGroup():getAccess() then
		if thing:isItem() then
			description = string.format("%s\nItem ID: %d", description, thing:getId())
			description = string.format("%s\nClient ID: %d", description, ItemType(thing:getId()):getClientId())
			
			local actionId = thing:getActionId()
			if actionId ~= 0 then
				description = string.format("%s\nAction ID: %d", description, actionId)
			end

			local uniqueId = thing:getAttribute(ITEM_ATTRIBUTE_UNIQUEID)
			if uniqueId > 0 and uniqueId < 65536 then
				description = string.format("%s, Unique ID: %d", description, uniqueId)
			end

			local itemType = thing:getType()

			local transformEquipId = itemType:getTransformEquipId()
			local transformDeEquipId = itemType:getTransformDeEquipId()
			if transformEquipId ~= 0 then
				description = string.format("%s\nTransforms to: %d (onEquip)", description, transformEquipId)
			elseif transformDeEquipId ~= 0 then
				description = string.format("%s\nTransforms to: %d (onDeEquip)", description, transformDeEquipId)
			end

			local decayId = itemType:getDecayId()
			if decayId ~= -1 then
				description = string.format("%s\nDecays to: %d", description, decayId)
			end
			
			if itemType:isDoor() then
				local doorId = thing:getAttribute(ITEM_ATTRIBUTE_DOORID)
				if doorId ~= 0 then
					description = string.format("%s\nDoor id: %d", description, doorId)
				end
				
				local actionId = thing:getActionId()
				if actionId ~= 0 then
					local itemId = itemType:getId()
					if table.contains(closedQuestDoors, itemId) then
						description = string.format("%s\n[Storage: %d]", description, actionId)
					elseif table.contains(lockedDoors, itemId) or table.contains(openDoors, itemId) or table.contains(closedDoors, itemId) then
						description = string.format("%s\n[Key: %.4d]", description, actionId)
					end
				elseif table.contains(lockedDoors, itemId) then
					description = string.format("%s\n[Key: none]", description)
				end
			end
			
			local topParent = thing:getTopParent()
			if topParent and topParent:isTile() then
				local house = topParent:getHouse()
				if house then
					description = string.format("%s\nHouse id: %d", description, house:getId())
				end
			end
			
			if itemType:getType() == ITEM_TYPE_REWARDBAG then
				description = string.format("%s\nReward id: %d", description, thing:rewardId())
			end
		elseif thing:isCreature() then
			local str = "%s\nHealth: %d / %d"
			if thing:isPlayer() and thing:getMaxMana() > 0 then
				str = string.format("%s, Mana: %d / %d", str, thing:getMana(), thing:getMaxMana())
			end
			description = string.format(str, description, thing:getHealth(), thing:getMaxHealth()) .. "."
		end

		local position = thing:getPosition()
		description = string.format(
			"%s\nPosition: %d, %d, %d",
			description, position.x, position.y, position.z
		)

		if thing:isTeleport() then
			position = thing:getDestination()
			description = string.format(
			"%s\nDestination: %d, %d, %d",
			description, position.x, position.y, position.z
		)
		end
		
		if thing:isCreature() then
			local outfit = thing:getOutfit()
			if outfit.lookTypeEx == 0 then
				description = string.format("%s\nOutfit: %d", description, outfit.lookType)
				if outfit.lookHead > 0 or outfit.lookBody > 0 or outfit.lookLegs > 0 or outfit.lookFeet > 0 then
					description = string.format("%s\nColors: %d, %d, %d, %d", description, outfit.lookHead, outfit.lookBody, outfit.lookLegs, outfit.lookFeet)
				end
				
				if outfit.lookAddons > 0 then
					description = string.format("%s\nAddons: %d", description, outfit.lookAddons)
				end
			else
				local itemType = ItemType(outfit.lookTypeEx)
				local clientId = 0
				if itemType then
					clientId = itemType:getClientId()
				end
				
				description = string.format("%s\nItem ID: %d\nClient ID: %d", description, outfit.lookTypeEx, clientId)
			end
			
			if outfit.lookMount ~= 0 then
				description = string.format("%s\nMount: %d", description, outfit.lookMount)
				if outfit.lookMountHead > 0 or outfit.lookMountBody > 0 or outfit.lookMountLegs > 0 or outfit.lookMountFeet > 0 then
					description = string.format("%s\nColors: %d, %d, %d, %d", description, outfit.lookMountHead, outfit.lookMountBody, outfit.lookMountLegs, outfit.lookMountFeet)
				end
			end
			
			description = string.format("%s\ncid: %s", description, thing:getId())
			
			if thing:isPlayer() then
				description = string.format("%s\nGUID: %s", description, thing:getGuid())
				description = string.format("%s\nIP: %s", description, Game.convertIpToString(thing:getIp()))
			end
		end
	elseif self:getAccountType() >= ACCOUNT_TYPE_TUTOR then
		local position = thing:getPosition()
		description = string.format(
			"%s\nPosition: %d, %d, %d",
			description, position.x, position.y, position.z
		)

		if thing:isTeleport() then
			position = thing:getDestination()
			description = string.format(
			"%s\nDestination: %d, %d, %d",
			description, position.x, position.y, position.z
		)
		end
	end
	return description
end

ec:register()
