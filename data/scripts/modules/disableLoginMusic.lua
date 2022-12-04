-- turn off login screen music on successful login
do
	local ec = EventCallback
	function ec.onConnect(player, isLogin)
		local m = NetworkMessage()
		m:addByte(0x85)
		m:addByte(0x01)
		m:addByte(0x00)
		m:addByte(0x00)
		m:sendToPlayer(player)
	end
	ec:register()
end
