function onSay(player, words, param)
	if not player:isAdmin() then
		return true
	end

	local position = player:getPosition()
	local isGhost = not player:isInGhostMode()

	player:setGhostMode(isGhost)
	if isGhost then
		player:sendColorMessage("You are now invisible.", MESSAGE_COLOR_PURPLE)
		position:sendMagicEffect(CONST_ME_POFF)
	else
		player:sendColorMessage("You are visible again.", MESSAGE_COLOR_PURPLE)
		position:sendMagicEffect(CONST_ME_TELEPORT, player)
	end
	return false
end
