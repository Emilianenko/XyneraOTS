function onSay(player, words, param)
	if not player:getGroup():getAccess() then
		return true
	end

	local steps = tonumber(param)
	if not steps then
		return false
	end

	local position = player:getPosition()
	position:getNextPosition(player:getDirection(), steps)

	local tile = Tile(position)
	if not tile then
		Game.createTile(position)
	end
	
	if position.x == 0 then
		player:sendCancelMessage("You cannot teleport there.")
		return false
	end

	player:teleportTo(position)
	return false
end
