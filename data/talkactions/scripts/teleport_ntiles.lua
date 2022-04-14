function onSay(player, words, param)
	if not player:isAdmin() then
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
	
	player:teleportTo(position)
	return false
end
