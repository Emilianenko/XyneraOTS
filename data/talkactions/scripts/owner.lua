function onSay(player, words, param)
	if not player:isAdmin() then
		return true
	end

	local tile = Tile(player:getPosition())
	local house = tile and tile:getHouse()
	if not house then
		player:sendColorMessage("You are not inside a house.", MESSAGE_COLOR_PURPLE)
		return false
	end

	if param == "" or param == "none" or param == "nobody" then
		house:setOwnerGuid(0)
		player:sendColorMessage("House owner cleared.", MESSAGE_COLOR_PURPLE)
		return false
	end

	local targetPlayer = Player(param)
	if not targetPlayer then
		player:sendColorMessage("Player not found.", MESSAGE_COLOR_PURPLE)
		return false
	end

	house:setOwnerGuid(targetPlayer:getGuid())
	player:sendColorMessage(string.format("House owner successfully set to %s.", targetPlayer:getName()), MESSAGE_COLOR_PURPLE)
	return false
end
