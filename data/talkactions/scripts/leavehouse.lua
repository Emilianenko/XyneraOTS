function onSay(player, words, param)
	local position = player:getPosition()
	local tile = Tile(position)
	local house = tile and tile:getHouse()
	if not house then
		player:sendColorMessage("You are not inside a house.", MESSAGE_COLOR_PURPLE)
		position:sendMagicEffect(CONST_ME_POFF)
		return false
	end

	if house:getOwnerGuid() ~= player:getGuid() then
		player:sendColorMessage("You are not the owner of this house.", MESSAGE_COLOR_PURPLE)
		position:sendMagicEffect(CONST_ME_POFF)
		return false
	end

	house:setOwnerGuid(0)
	player:sendColorMessage("You have successfully left your house.", MESSAGE_COLOR_YELLOW)
	position:sendMagicEffect(CONST_ME_POFF)
	return false
end
