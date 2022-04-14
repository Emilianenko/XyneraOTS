function onSay(player, words, param)
	if not player:isAdmin() then
		return true
	end

	local target = Player(param)
	if not target then
		player:sendColorMessage("Player not found.", MESSAGE_COLOR_PURPLE)
		return false
	end

	if target:getGroup():getAccess() then
		player:sendColorMessage("You cannot kick this player.", MESSAGE_COLOR_PURPLE)
		return false
	end

	player:sendColorMessage(string.format("%s has been kicked.", target:getName()), MESSAGE_COLOR_PURPLE)
	target:remove("You have been kicked.")
	return false
end
