function onSay(player, words, param)
	if not player:isAdmin() then
		return true
	end

	local position = player:getPosition()
	local placedCreature
	
	local mode = words:lower()
	local isNpc = mode == "/s"

	if isNpc then
		placedCreature = Game.createNpc(param, position)
	else
		placedCreature = Game.createMonster(param, position)
	end

	if placedCreature then
		if isNpc then
			placedCreature:setMasterPos(position)
		elseif mode == "/summon" then
			player:addSummon(placedCreature)
		end

		position:sendMagicEffect(CONST_ME_MAGIC_RED, player:isInGhostMode() and player)
	elseif placedCreature == false then
		if isNpc then
			player:sendColorMessage("Unable to place the creature. Not enough room.", MESSAGE_COLOR_PURPLE)
		else
			player:sendColorMessage("Unable to place the creature.\nPossible reasons:\n - not enough room\n - blocked by event\n - all tiles are PZ", MESSAGE_COLOR_PURPLE)
		end
		position:sendMagicEffect(CONST_ME_POFF, player:isInGhostMode() and player)
	else -- placedCreature == nil
		if isNpc then
			player:sendTextMessage(MESSAGE_STATUS_WARNING, Game.getLastConsoleMessage())
		else
			player:sendColorMessage("Unable to create monster. Monster type not found.", MESSAGE_COLOR_PURPLE)
		end
		position:sendMagicEffect(CONST_ME_POFF, player:isInGhostMode() and player)
	end

	return false
end
