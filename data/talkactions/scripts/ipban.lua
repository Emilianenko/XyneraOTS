local ipBanDays = 7

function onSay(player, words, param)
	if not player:isAdmin() then
		return true
	end

	local resultId = db.storeQuery("SELECT `name`, `lastip` FROM `players` WHERE `name` = " .. db.escapeString(param))
	if resultId == false then
		return false
	end

	local targetName = result.getString(resultId, "name")
	local targetIp = result.getNumber(resultId, "lastip")
	result.free(resultId)

	local timeNow = os.time()
	local banEndsAt = timeNow + (ipBanDays * 86400)
	
	local kicked = false
	
	local targetPlayer = Player(param)
	if targetPlayer then
		targetIp = targetPlayer:getIp()
		targetPlayer:remove(string.format("Your IP has been banned until %s.", os.date("%d %b %Y %X", banEndsAt)))
		kicked = true
	end

	if targetIp == 0 then
		player:sendColorMessage("An error occured (IP = 0).", MESSAGE_COLOR_PURPLE)
		return false
	end

	resultId = db.storeQuery("SELECT 1 FROM `ip_bans` WHERE `ip` = " .. targetIp)
	if resultId ~= false then
		if kicked then
			player:sendColorMessage(targetName .. " has been IP banned for " .. ipBanDays .. " days.", MESSAGE_COLOR_PURPLE)
		else
			player:sendColorMessage(targetName .. " is already banned.", MESSAGE_COLOR_PURPLE)
		end
		result.free(resultId)
		return false
	end

	
	db.query("INSERT INTO `ip_bans` (`ip`, `reason`, `banned_at`, `expires_at`, `banned_by`) VALUES (" ..
			targetIp .. ", '', " .. timeNow .. ", " .. banEndsAt .. ", " .. player:getGuid() .. ")")
	player:sendColorMessage(targetName .. " has been IP banned for " .. ipBanDays .. " days.", MESSAGE_COLOR_PURPLE)
	return false
end
