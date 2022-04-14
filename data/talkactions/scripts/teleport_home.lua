function onSay(player, words, param)
	if not player:isAdmin() then
		return true
	end

	player:teleportTo(player:getTown():getTemplePosition())
	return false
end
