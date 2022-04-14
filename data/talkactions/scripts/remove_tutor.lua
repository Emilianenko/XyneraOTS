function onSay(player, words, param)
	if player:getAccountType() <= ACCOUNT_TYPE_SENIORTUTOR then
		return true
	end

	local resultId = db.storeQuery("SELECT `name`, `account_id`, (SELECT `type` FROM `accounts` WHERE `accounts`.`id` = `account_id`) AS `account_type` FROM `players` WHERE `name` = " .. db.escapeString(param))
	if resultId == false then
		player:sendColorMessage("A player with that name does not exist.", MESSAGE_COLOR_PURPLE)
		return false
	end

	if result.getNumber(resultId, "account_type") ~= ACCOUNT_TYPE_TUTOR then
		player:sendColorMessage("You can only demote a tutor to a normal player.", MESSAGE_COLOR_PURPLE)
		result.free(resultId)
		return false
	end

	local target = Player(param)
	if target then
		target:setAccountType(ACCOUNT_TYPE_NORMAL)
	else
		db.query("UPDATE `accounts` SET `type` = " .. ACCOUNT_TYPE_NORMAL .. " WHERE `id` = " .. result.getNumber(resultId, "account_id"))
	end

	player:sendColorMessage("You have demoted " .. result.getString(resultId, "name") .. " to a normal player.", MESSAGE_COLOR_PURPLE)
	result.free(resultId)
	return false
end
