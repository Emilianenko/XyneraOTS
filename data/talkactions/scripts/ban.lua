local banDays = 7

function onSay(player, words, param)
	if not player:isAdmin() then
		return true
	end

	local name = param
	local reason = ''

	local separatorPos = param:find(',')
	if separatorPos then
		name = param:sub(0, separatorPos - 1)
		reason = string.trim(param:sub(separatorPos + 1))
	end

	local accountId = getAccountNumberByPlayerName(name)
	if accountId == 0 then
		player:sendColorMessage("Player not found.", MESSAGE_COLOR_PURPLE)
		return false
	end

	local resultId = db.storeQuery("SELECT 1 FROM `account_bans` WHERE `account_id` = " .. accountId)
	if resultId ~= false then
		result.free(resultId)
		player:sendColorMessage("Player not found.", MESSAGE_COLOR_PURPLE)
		return false
	end

	local timeNow = os.time()
	local banEndsAt = timeNow + (banDays * 86400)
	db.query("INSERT INTO `account_bans` (`account_id`, `reason`, `banned_at`, `expires_at`, `banned_by`) VALUES (" ..
			accountId .. ", " .. db.escapeString(reason) .. ", " .. timeNow .. ", " .. banEndsAt .. ", " .. player:getGuid() .. ")")

	local target = Player(name)
	if target then
		player:sendColorMessage(target:getName() .. " has been banned for " .. banDays .. " days.", MESSAGE_COLOR_PURPLE)
		
		local outputReason = reason:len() > 0 and string.format("\n\nReason: %s", reason) or ""
		target:remove(string.format("Your account has been banned until %s.%s", os.date("%d %b %Y %X", banEndsAt), outputReason))
	else
		player:sendColorMessage(name .. " has been banned for " .. banDays .. " days.", MESSAGE_COLOR_PURPLE)
	end
end
