function onSay(player, words, param)
	if player:getAccountType() <= ACCOUNT_TYPE_SENIORTUTOR then
		return true
	end

	local target = Player(param)
	if not target then
		player:sendColorMessage("A player with that name is not online.", MESSAGE_COLOR_PURPLE)
		return false
	end

	if target:getAccountType() ~= ACCOUNT_TYPE_NORMAL then
		player:sendColorMessage("You can only promote a normal player to a tutor.", MESSAGE_COLOR_PURPLE)
		return false
	end

	target:setAccountType(ACCOUNT_TYPE_TUTOR)
	target:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have been promoted to a tutor by " .. player:getName() .. ".")
	player:sendColorMessage("You have promoted " .. target:getName() .. " to a tutor.", MESSAGE_COLOR_PURPLE)
	return false
end
