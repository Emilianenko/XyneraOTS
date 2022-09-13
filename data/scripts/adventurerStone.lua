local startPos = Position(1093, 746, 7)
local endPos = Position(1128, 773, 7)
local destPos = Position(1107, 764, 7)

local action = Action()
function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getAccountType() < ACCOUNT_TYPE_GOD then
		return false
	end
	
	if player:getPosition():isInRange(startPos, endPos) then
		player:teleportTo(player:getTown():getTemplePosition())
	else
		player:teleportTo(destPos)
		destPos:sendMagicEffect(CONST_ME_TELEPORT)
	end

	return true
end
action:id(18559)
action:register()
