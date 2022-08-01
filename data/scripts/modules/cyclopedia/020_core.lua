function sendCyclopediaError(player, infoType, errorCode)
	local response = NetworkMessage();
	response:addByte(CYCLOPEDIA_RESPONSE_PLAYERDATA)
	response:addByte(infoType)
	response:addByte(errorCode)
	response:sendToPlayer(player)
end