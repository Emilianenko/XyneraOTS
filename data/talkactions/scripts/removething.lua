function onSay(player, words, param)
	if not player:getGroup():getAccess() then
		return true
	end

	local position = player:getPosition()
	position:getNextPosition(player:getDirection())

	local tile = Tile(position)
	if not tile then
		player:sendColorMessage("Object not found.", MESSAGE_COLOR_PURPLE)
		return false
	end

	local thing = tile:getTopVisibleThing(player)
	if not thing then
		player:sendColorMessage("Thing not found.", MESSAGE_COLOR_PURPLE)
		return false
	end

	local value
	if thing:isItem() then
		value = tonumber(param) or -1
	end
	
	local res = thing:remove(value)

	if res then
		position:sendMagicEffect(CONST_ME_MAGIC_RED)
	else
		player:sendColorMessage("Failed to remove item.", MESSAGE_COLOR_PURPLE)
	end
	
	return false
end
