local upFloorIds = {1386, 3678, 5543, 22845, 22846}
function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	-- draw well (special case)
	if item.itemid == 1369 then
		if item:getActionId() ~= actionIds.drawWell then
			return false
		end
	end

	if table.contains(upFloorIds, item.itemid) then
		fromPosition:moveUpstairs()
	else
		fromPosition.z = fromPosition.z + 1
	end

	if player:isPzLocked() and Tile(fromPosition):hasFlag(TILESTATE_PROTECTIONZONE) then
		player:sendCancelMessage(RETURNVALUE_PLAYERISPZLOCKED)
		return true
	end

	player:teleportTo(fromPosition, false)
	return true
end
