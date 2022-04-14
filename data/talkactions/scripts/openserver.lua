function onSay(player, words, param)
	if not player:isAdmin() then
		return true
	end

	Game.setGameState(GAME_STATE_NORMAL)
	player:sendColorMessage("Server is now open.", MESSAGE_COLOR_PURPLE)
	return false
end
