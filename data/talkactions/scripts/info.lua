function onSay(player, words, param)
	if not player:isAdmin() then
		return true
	end

	local target = Player(param)
	if not target then
		player:sendColorMessage("Player not found.", MESSAGE_COLOR_PURPLE)
		return false
	end

	if target:getAccountType() > player:getAccountType() then
		player:sendColorMessage("You can not get info about this player.", MESSAGE_COLOR_PURPLE)
		return false
	end

	local targetIp = target:getIp()
	local response = {}
	response[#response + 1] = "Name: " .. target:getName()
	response[#response + 1] = "Access: " .. (target:getGroup():getAccess() and "1" or "0")
	response[#response + 1] = "Level: " .. target:getLevel()
	response[#response + 1] = "Magic Level: " .. target:getMagicLevel()
	response[#response + 1] = "Speed: " .. target:getSpeed()
	response[#response + 1] = "Position: " .. string.format("(%d / %d / %d)", target:getPosition().x, target:getPosition().y, target:getPosition().z)
	response[#response + 1] = "IP: " .. Game.convertIpToString(targetIp)

	local players = {}
	for _, targetPlayer in ipairs(Game.getPlayers()) do
		if targetPlayer:getIp() == targetIp and targetPlayer ~= target then
			players[#players + 1] = targetPlayer:getName() .. " [" .. targetPlayer:getLevel() .. "]"
		end
	end

	if #players > 0 then
		response[#response + 1] = "Other players on same IP: " .. table.concat(players, ", ") .. "."
	end
	
	player:sendTextMessage(MESSAGE_INFO_DESCR, table.concat(response, "\n"))
	return false
end
