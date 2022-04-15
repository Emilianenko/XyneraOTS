REQUEST_EDIT_MOTD = 0x9B
RESPONSE_EDIT_MOTD = 0xAE

REQUEST_SAVE_MOTD = 0x9C

function parseRequestEditGuildMotd(player, recvbyte, msg)
	-- player guild check
	local guild = player:getGuild()
	if not guild then
		return
	end
	
	-- player "leader" status check
	if player:getGuildLevel() ~= guild:getLeaderRankLevel() then
		return
	end
	
	local response = NetworkMessage()
	response:addByte(RESPONSE_EDIT_MOTD)
	response:addString(guild:getMotd())
	response:sendToPlayer(player)
end
setPacketEvent(REQUEST_EDIT_MOTD, parseRequestEditGuildMotd)

function parseSetGuildMotd(player, recvbyte, msg)
	if not player:talkactionCooldownCheck() then
		return
	end
	
	-- player guild check
	local guild = player:getGuild()
	if not guild then
		return
	end
	
	-- player "leader" status check (again, to avoid crafted packet)
	if player:getGuildLevel() ~= guild:getLeaderRankLevel() then
		return
	end
	
	local motd = msg:getString()
	guild:setMotd(motd)
	db.query(string.format("UPDATE `guilds` SET `motd` = %s WHERE `id` = %d;", db.escapeString(motd), guild:getId()))
	
end
setPacketEvent(REQUEST_SAVE_MOTD, parseSetGuildMotd)