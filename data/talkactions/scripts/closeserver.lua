function onSay(player, words, param)
	if not player:isAdmin() then
		return true
	end

	if param == "shutdown" then
		Game.setGameState(GAME_STATE_SHUTDOWN)
	else
		Game.setGameState(GAME_STATE_CLOSED)
		player:sendColorMessage("Server is now closed.", MESSAGE_COLOR_PURPLE)
	end
	return false
end
