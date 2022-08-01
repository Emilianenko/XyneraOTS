function onSay(player, words, param)
	if not player:hasFlag(PlayerFlag_CanBroadcast) then
		return true
	end

	if param:len() == 0 then
		player:sendColorMessage("Please type a message to broadcast.", MESSAGE_COLOR_PURPLE)
		return false
	end

	Game.sendConsoleMessage(CONSOLEMESSAGE_TYPE_BROADCAST, os.date("%H:%M") .. " " .. player:getName() .. " [" .. player:getLevel() .. "]: " .. param)
	for _, targetPlayer in ipairs(Game.getPlayers()) do
		targetPlayer:sendPrivateMessage(player, param, TALKTYPE_BROADCAST)
	end
	return false
end
