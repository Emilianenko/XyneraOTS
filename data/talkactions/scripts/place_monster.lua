function onSay(player, words, param)
	if not player:isAdmin() then
		return true
	end

	local position = player:getPosition()
	local monster = Game.createMonster(param, position)
	if monster then
		monster:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		position:sendMagicEffect(CONST_ME_MAGIC_RED)
	else
		player:sendColorMessage("Unable to create monster. Check console for details.", MESSAGE_COLOR_PURPLE)
		position:sendMagicEffect(CONST_ME_POFF)
	end
	return false
end
