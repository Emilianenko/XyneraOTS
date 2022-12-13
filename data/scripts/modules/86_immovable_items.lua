ITEM_SPARKLING_A = 8046
ITEM_SPARKLING_B = 8047

function isSparklingTile(pos)
	if pos.x == CONTAINER_POSITION then
		return false
	end

	local tile = Tile(pos)
	if tile then
		for _, item in pairs(tile:getItems() or {}) do
			local itemId = item:getId()
			if itemId == ITEM_SPARKLING_A or itemId == ITEM_SPARKLING_B then
				return true
			end
		end
	end
	
	return false
end

-- disable browse field
do
	local ec = EventCallback
	ec.onBrowseField = function(self, pos)
		return not isSparklingTile(pos)
	end
	ec:register()
end

-- disable moving
do
	local ec = EventCallback
	ec.onMoveItem = function(self, item, count, fromPosition, toPosition, fromCylinder, toCylinder)
		if isSparklingTile(item:getPosition()) then
			return RETURNVALUE_NOTMOVEABLE
		elseif isSparklingTile(toPosition) then
			return RETURNVALUE_NOTENOUGHROOM
		end
	
		return RETURNVALUE_NOERROR
	end
	ec:register()
end

-- disable trading
do
	local ec = EventCallback
	ec.onTradeRequest = function(self, target, item)
		return not isSparklingTile(item:getPosition())
	end
	ec:register()
end