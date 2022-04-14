function onSay(player, words, param)
	if not player:isAdmin() then
		return true
	end

	local creature = Creature(param)
	if not creature then
		player:sendColorMessage("A creature with that name could not be found.", MESSAGE_COLOR_PURPLE)
		return false
	end

	local oldPosition = creature:getPosition()
	local newPosition = creature:getClosestFreePosition(player:getPosition(), false)
	if newPosition.x == 0 then
		player:sendColorMessage("You can not teleport " .. creature:getName() .. ".", MESSAGE_COLOR_PURPLE)
		return false
	elseif creature:teleportTo(newPosition) then
		if not creature:isInGhostMode() then
			oldPosition:sendMagicEffect(CONST_ME_POFF)
			newPosition:sendMagicEffect(CONST_ME_TELEPORT)
		end
	end
	return false
end
