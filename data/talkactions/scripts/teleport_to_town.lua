function onSay(player, words, param)
	if not player:isAdmin() then
		return true
	end

	local town = Town(param) or Town(tonumber(param))
	if town then
		player:teleportTo(town:getTemplePosition())
	else
		player:sendColorMessage("Town not found.", MESSAGE_COLOR_PURPLE)
	end
	return false
end
