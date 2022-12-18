-- change name scroll
-- change sex rune
local hirelingItem = Action()
function hirelingItem.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local itemId = item:getId()
	if itemId == ITEM_HIRELING_RUNE then
		-- hireling sex change
		if target and target:isCreature() then
			if target:isNpc() and target:getOwnerGUID() == player:getGuid() or player:getId() == target:getId() or player:isAdmin() then
				if target:changeSex() then
					target:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
					if not player:isAdmin() then
						item:remove(1)
					else
						player:sendTextMessage(MESSAGE_INFO_DESCR, "Administrator mode: rune not consumed.")
					end
				else
					player:sendCancelMessage("This creature cannot be altered.")
					player:getPosition():sendMagicEffect(CONST_ME_POFF, player)
				end
			elseif target:isNpc() and target:getSpeechBubble(SPEECHBUBBLE_HIRELING) then
				player:sendCancelMessage("You do not own this hireling.")
				player:getPosition():sendMagicEffect(CONST_ME_POFF, player)
			else
				return false
			end
			
			return true
		end
	elseif itemId == ITEM_HIRELING_SCROLL then
		-- hireling name change
		-- (item consumption in event)
		if target and target:isCreature() then
			local msg = NetworkMessage()
			msg:addByte(0xDB)
			msg:addU32(0) -- unknown
			msg:addU32(target:getId())
			msg:sendToPlayer(player)
			return true
		end
	end
	
	return false
end

hirelingItem:id(ITEM_HIRELING_SCROLL)
hirelingItem:id(ITEM_HIRELING_RUNE)
hirelingItem:allowFarUse(true)
hirelingItem:blockWalls(false)
hirelingItem:register()

-- rename
local ec = EventCallback
function ec.onEditName(player, target, name)
	if not target then
		return
	end

	-- rename anyone (admin mode)
	if player:isAdmin() then
		-- prevent duplicate player names
		if target:isPlayer() then
			if Game.playerExists(name) then
				player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("Name \"%s\" is already in use!", name))
				return
			end
		end

		-- rename
		target:rename(name)
		target:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
		
		-- name verification (check only)
		local nameError = Game.verifyName(name)
		if nameError then
			nameError = string.format("\nWarning: Potentially illegal name.\nReason: %s", nameError)
		end
		nameError = nameError or ""
		
		player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("Administrator mode: Creature renamed successfully.%s", nameError))
		return
	end

	-- spoofed packet or lost the rename scroll before confirming new name
	if player:getItemCount(ITEM_HIRELING_SCROLL) == 0 then
		return
	end
	
	-- rename self
	if player:getId() == target:getId() then
		-- name verification
		local nameError = Game.verifyName(name)
		if nameError then
			player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("This name may not be used.\nReason: %s", nameError))
			return
		end

		-- prevent duplicate name
		if Game.playerExists(name) then
			player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("Name \"%s\" is already in use!", name))
			return
		end
		
		if player:removeItem(ITEM_HIRELING_SCROLL, 1) then
			target:rename(name)
			player:sendTextMessage(MESSAGE_STATUS_WARNING, "Warning: Due to name change, you may need to restart your client in order to be able to log in again!")
			target:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
		else
			player:sendTextMessage(MESSAGE_INFO_DESCR, "Error: unable to consume hireling scroll.")
		end
		
		return
	end
	
	-- spoofed packet or lost admin permissions while editing
	local npc = Npc(target:getId())
	if not npc then
		return
	end
	
	-- hireling check
	if npc:getSpeechBubble() ~= SPEECHBUBBLE_HIRELING then
		return
	end
	
	-- owner verification
	if npc:getOwnerGUID() ~= player:getGuid() then
		player:sendCancelMessage("You do not own this hireling.")
		return
	end
	
	-- name verification
	local nameError = Game.verifyName(name)
	if nameError then
		player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("This name may not be used.\nReason: %s", nameError))
		return
	end

	-- rename
	if player:removeItem(ITEM_HIRELING_SCROLL, 1) then
		local oldName = target:getName()
		target:rename(name)
		target:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
		player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("%s successfully renamed to \"%s\".", oldName, name))
		return
	end
	
	player:sendTextMessage(MESSAGE_INFO_DESCR, "Error: unable to consume hireling scroll.")
end
ec:register()
