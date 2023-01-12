local function sendHotkeyPreset(cid)
	local player = Player(cid)
	if player then
		local msg = NetworkMessage()
		msg:addByte(0x9D)
		msg:addU32(player:getVocation():getClientId())
		msg:sendToPlayer(player)
	end	
end

do
	local ec = EventCallback
	function ec.onConnect(player, isLogin)
		addEvent(sendHotkeyPreset, 200, player:getId())
	end
	ec:register()
end
