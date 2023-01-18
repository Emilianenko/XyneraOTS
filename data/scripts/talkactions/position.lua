local talk = TalkAction("/pos", "!pos")

function talk.onSay(player, words, param)
	--if not player:isAdmin() then
	--	return true
	--end

	if param ~= "" then
		local split = param:split(",")
		local npos = Position(split[1], split[2], split[3])
		if not Tile(npos) then
			Game.createTile(npos)
		end
		
		player:teleportTo(npos)
	else
		local position = player:getPosition()
		player:sendTextMessage(MESSAGE_INFO_DESCR, "Your current position is: " .. position.x .. ", " .. position.y .. ", " .. position.z .. ".")
	end
	return false
end

talk:separator(" ")
talk:register()
