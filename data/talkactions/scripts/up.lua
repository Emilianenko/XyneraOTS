function onSay(player, words, param)
	if not player:isAdmin() then
		return true
	end

	local position = player:getPosition()
	position.z = position.z - 1
	
	if not Tile(position) then
		Game.createTile(position)
	end

	player:teleportTo(position)
	return false
end
