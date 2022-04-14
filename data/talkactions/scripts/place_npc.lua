function onSay(player, words, param)
	if not player:isAdmin() then
		return true
	end

	local position = player:getPosition()
	local npc = Game.createNpc(param, position)
	if npc then
		npc:setMasterPos(position)
		position:sendMagicEffect(CONST_ME_MAGIC_RED)
	else
		player:sendColorMessage("Unable to create NPC. Check console for details.", MESSAGE_COLOR_PURPLE)
		position:sendMagicEffect(CONST_ME_POFF)
	end
	return false
end
