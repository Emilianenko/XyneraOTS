function onSay(player, words, param)
	if not player:isAdmin() then
		return true
	end

	logCommand(player, words, param)

	local returnValue = Game.startRaid(param)
	if returnValue ~= RETURNVALUE_NOERROR then
		player:sendColorMessage(Game.getReturnMessage(returnValue), MESSAGE_COLOR_PURPLE)
	else
		player:sendColorMessage("Raid started.", MESSAGE_COLOR_PURPLE)
	end

	return false
end
