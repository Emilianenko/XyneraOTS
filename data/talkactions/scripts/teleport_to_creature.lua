function onSay(player, words, param)
	if not player:isAdmin() then
		return true
	end

	local target = Creature(param)
	if target then
		player:teleportTo(target:getPosition())
	else
		player:sendColorMessage("Creature not found.", MESSAGE_COLOR_PURPLE)
	end
	return false
end
