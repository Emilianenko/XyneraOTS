function onSay(player, words, param)
	if not player:hasFlag(PlayerFlag_CanBroadcast) then
		return true
	end

	Game.sendConsoleMessage(CONSOLEMESSAGE_TYPE_BROADCAST, os.date("%H:%M") .. " " .. player:getName() .. " [" .. player:getLevel() .. "]: " .. param)
	for _, targetPlayer in ipairs(Game.getPlayers()) do
		targetPlayer:sendPrivateMessage(player, param, TALKTYPE_BROADCAST)
	end
	return false
end
