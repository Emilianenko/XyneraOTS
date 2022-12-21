local talk = TalkAction("!movecarpet")

function talk.onSay(player, words, param)
	-- check origin pos
	local pos = player:getPosition()
	local tile = Tile(pos)
	local oldTile = tile
	if not tile then
		player:sendColorMessage("Tile not found.", MESSAGE_COLOR_PURPLE)
		return false
	end
	
	local house = tile:getHouse()
	local prevHouse = house
	if not house then
		player:sendColorMessage("You need to be in a house.", MESSAGE_COLOR_PURPLE)
		return false	
	end
	
	if house:getOwnerGuid() ~= player:getGuid() then
		player:sendColorMessage("You do not own this house.", MESSAGE_COLOR_PURPLE)
		return false
	end
	
	-- check destination pos
	pos:getNextPosition(player:getDirection())
	tile = Tile(pos)
	if not tile or not tile:getGround() then
		player:sendColorMessage("You cannot move your carpet there.", MESSAGE_COLOR_PURPLE)
		return false
	end
	
	local house = tile:getHouse()
	if not house then
		player:sendColorMessage("Target tile has to be a house.", MESSAGE_COLOR_PURPLE)
		return false	
	end
	
	if house:getOwnerGuid() ~= player:getGuid() or prevHouse:getOwnerGuid() ~= house:getOwnerGuid() then
		player:sendColorMessage("You cannot move the carpet out of your house.", MESSAGE_COLOR_PURPLE)
		return false
	end

	-- check if there is a carpet to move
	local tileItems = oldTile:getItems()
	if not tileItems or #tileItems == 0 then
		player:sendColorMessage("Stand on a carpet in order to move it.", MESSAGE_COLOR_PURPLE)
		return false
	end

	-- locate a carpet to move
	local carpetToMove
	for stackPos, tileItem in pairs(tileItems) do
		local carpetId = tileItem:getId()
		if CarpetMap[carpetId] or ReverseCarpetMap[carpetId] then
			carpetToMove = tileItem
			break
		end
	end
	
	-- failed to find a carpet to move
	if not carpetToMove then
		player:sendColorMessage("Stand on a carpet in order to move it.", MESSAGE_COLOR_PURPLE)
		return false
	end
	
	-- carpets to reorder
	local carpetStack = {}
	
	-- check if more carpets are allowed
	local carpetCount = 0
	for stackPos, tileItem in pairs(tile:getItems()) do
		local carpetId = tileItem:getId()
		if ReverseCarpetMap[carpetId] then
			carpetStack[#carpetStack + 1] = tileItem
			carpetCount = carpetCount + 1
		end
	end
	if carpetCount > 2 then
		player:sendColorMessage("Too many carpets!", MESSAGE_COLOR_PURPLE)
		return false
	end

	-- move the carpet
	carpetToMove:moveTo(pos)
	player:sendColorMessage("The carpet has been moved.\n\nHint: If you are unable to fold it, try standing on another side of a wall.", MESSAGE_COLOR_WHITE)
	
	-- reorder the stack
	local shufflePos = Position(pos.x, pos.y + 1, pos.z)
	
	if #carpetStack > 0 then
		for i = #carpetStack, 1, -1 do
			carpetStack[i]:moveTo(shufflePos)
			carpetStack[i]:moveTo(pos)
		end
	end

	return false
end

talk:register()
