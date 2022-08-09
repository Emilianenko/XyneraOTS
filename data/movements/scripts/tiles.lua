local increasing = {[416] = 417, [426] = 425, [446] = 447, [3216] = 3217, [3202] = 3215, [11062] = 11063}
local decreasing = {[417] = 416, [425] = 426, [447] = 446, [3217] = 3216, [3215] = 3202, [11063] = 11062}

local function getDepotItemsCount(player)
	local totalCount = 0
	for boxId = 1, Game.getDepotBoxCount() do
		local depotBox = player:getDepotChest(boxId - 1)
		if depotBox then
			totalCount = totalCount + depotBox:getItemHoldingCount()
		end
	end
	
	return totalCount
end


function onStepIn(creature, item, position, fromPosition)
	if not increasing[item.itemid] then
		return true
	end

	if not creature:isPlayer() or creature:isInGhostMode() then
		return true
	end

	item:transform(increasing[item.itemid])

	if item.actionid >= actionIds.levelDoor then
		if creature:getLevel() < item.actionid - actionIds.levelDoor then
			creature:walkback(position, fromPosition)
			position:sendMagicEffect(CONST_ME_MAGIC_BLUE)
			creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The tile seems to be protected against unwanted intruders.")
		end
		return true
	end

	if Tile(position):hasFlag(TILESTATE_PROTECTIONZONE) then
		local lookPosition = creature:getPosition()
		lookPosition:getNextPosition(creature:getDirection())
		local depotItem = Tile(lookPosition):getItemByType(ITEM_TYPE_DEPOT)
		if depotItem then
			local depotItemCount = getDepotItemsCount(creature)
			creature:sendTextMessage(MESSAGE_STATUS_DEFAULT, "Your depot contains " .. depotItemCount .. " item" .. (depotItemCount ~= 1 and "s." or "."))
			creature:addAchievementProgress("Safely Stored Away", 1000)
			return true
		end
	end

	if item.actionid ~= 0 and creature:getStorageValue(item.actionid) <= 0 then
		creature:walkback(position, fromPosition)
		position:sendMagicEffect(CONST_ME_MAGIC_BLUE)
		creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The tile seems to be protected against unwanted intruders.")
		return true
	end
	return true
end

function onStepOut(creature, item, position, fromPosition)
	if not decreasing[item.itemid] then
		return true
	end

	if creature:isPlayer() and creature:isInGhostMode() then
		return true
	end

	item:transform(decreasing[item.itemid])
	return true
end
