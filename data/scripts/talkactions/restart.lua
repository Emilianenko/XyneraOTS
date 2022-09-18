local t = TalkAction("/restart")
t.onSay = function(player, words, param)
	-- permission check
	if player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end
	
	-- save and shutdown
	-- (restarter is expected to start the engine again)
	Game.setGameState(GAME_STATE_SHUTDOWN)
	return false
end
t:register()
