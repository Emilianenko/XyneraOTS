local function forceTakeItem(player, targetItem)
	local newItem = targetItem:clone()
	if targetItem:isTeleport() then
		newItem:setDestination(targetItem:getDestination())
	elseif targetItem:isPodium() then
		newItem:setOutfit(targetItem:getOutfit())
		newItem:setFlag(PODIUM_SHOW_PLATFORM, targetItem:hasFlag(PODIUM_SHOW_PLATFORM))
		newItem:setFlag(PODIUM_SHOW_OUTFIT, targetItem:hasFlag(PODIUM_SHOW_OUTFIT))
		newItem:setFlag(PODIUM_SHOW_MOUNT, targetItem:hasFlag(PODIUM_SHOW_MOUNT))
		newItem:setDirection(targetItem:getDirection())
	end	
	
	if targetItem:remove() then
		player:getStoreInbox():addItemEx(newItem, -1, bit.bor(FLAG_NOLIMIT, FLAG_IGNORENOTPICKUPABLE))
		return true
	end

	newItem:remove()
end

local constructionRune = Action()
function constructionRune.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player:isAdmin() then
		return false
	end


	local targetItem = target and Item(target.uid)
	local targetPos = targetItem and targetItem:getPosition() or toPosition

	-- drop on the floor
	if targetItem then
		local topParent = target:getTopParent()
		if topParent and topParent == player then
			targetItem:moveTo(player:getPosition())
			targetPos:sendMagicEffect(CONST_ME_MAGIC_RED)
			return true
		end
	end

	-- take from the floor
	if toPosition.x ~= CONTAINER_POSITION then
		local tile = Tile(toPosition)
		if tile then
			-- try to take tile item
			local tileItems = tile:getItems()
			if #tileItems > 0 then
				for i = 1, #tileItems do
					if forceTakeItem(player, tileItems[i]) then
						targetPos:sendMagicEffect(CONST_ME_MAGIC_RED)
						return true
					end
				end
			end

			-- try to take ground
			local ground = tile:getGround()
			if ground then
				if forceTakeItem(player, ground) then
					targetPos:sendMagicEffect(CONST_ME_MAGIC_RED)
					return true
				end
			end
		end
		
		player:sendColorMessage("No items to move on this tile!", MESSAGE_COLOR_PURPLE)
		return true
	end

	-- take from opened container
	if target and target.uid ~= 0 and forceTakeItem(player, target) then
		targetPos:sendMagicEffect(CONST_ME_MAGIC_RED)
		return true
	end

	player:sendColorMessage("This item cannot be picked up!", MESSAGE_COLOR_PURPLE)
	return true
end

constructionRune:id(2309)
constructionRune:register()
