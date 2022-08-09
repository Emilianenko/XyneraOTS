local function sendHotkeyPreset(cid)
	local player = Player(cid)
	if player then
		local msg = NetworkMessage()
		msg:addByte(0x9D)
		msg:addU32(player:getVocation():getClientId())
		msg:sendToPlayer(player)
	end	
end


local creatureevent = CreatureEvent("hotkeyPresetLogin")
function creatureevent.onLogin(player)
	addEvent(sendHotkeyPreset, 200, player:getId())
	return true
end
creatureevent:register()
