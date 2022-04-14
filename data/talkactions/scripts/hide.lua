function onSay(player, words, param)
	if not player:isAdmin() then
		return true
	end

	local status = player:isHealthHidden()
	player:setHiddenHealth(not status)
	player:sendColorMessage(string.format("Your name and health are now %s.", status and "visible" or "hidden"), MESSAGE_COLOR_PURPLE)
	return false
end
