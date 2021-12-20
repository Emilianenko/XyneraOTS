local ipBanDays = 7

function onSay(player, words, param)
	if not player:getGroup():getAccess() then
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
	
	local targetPlayer = Player(param)
	if targetPlayer then
		targetIp = targetPlayer:getIp()
		targetPlayer:remove(string.format("Your IP has been banned until %s.", os.date("%d %b %Y %X", banEndsAt)))
	end

	if targetIp == 0 then
		return false
	end

	resultId = db.storeQuery("SELECT 1 FROM `ip_bans` WHERE `ip` = " .. targetIp)
	if resultId ~= false then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, targetName .. "  is already IP banned.")
		result.free(resultId)
		return false
	end

	
	db.query("INSERT INTO `ip_bans` (`ip`, `reason`, `banned_at`, `expires_at`, `banned_by`) VALUES (" ..
			targetIp .. ", '', " .. timeNow .. ", " .. banEndsAt .. ", " .. player:getGuid() .. ")")
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, targetName .. "  has been IP banned.")
	return false
end
