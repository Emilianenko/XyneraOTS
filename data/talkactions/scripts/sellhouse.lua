function onSay(player, words, param)
	local tradePartner = Player(param)
	if not tradePartner or tradePartner == player then
		player:sendColorMessage("Trade player not found.", MESSAGE_COLOR_PURPLE)
		return false
	end

	local house = player:getTile():getHouse()
	if not house then
		player:sendColorMessage("You must stand in your house to initiate the trade.", MESSAGE_COLOR_PURPLE)
		return false
	end

	local returnValue = house:startTrade(player, tradePartner)
	if returnValue ~= RETURNVALUE_NOERROR then
		player:sendCancelMessage(returnValue)
	else
		player:sendColorMessage("House transfer completed.", MESSAGE_COLOR_YELLOW)
	end
	return false
end
