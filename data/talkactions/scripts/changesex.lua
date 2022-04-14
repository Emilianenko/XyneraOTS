local premiumDaysCost = 3

function onSay(player, words, param)
	if player:isAdmin() then
		player:setSex(player:getSex() == PLAYERSEX_FEMALE and PLAYERSEX_MALE or PLAYERSEX_FEMALE)
		player:sendColorMessage("You have changed your sex.", MESSAGE_COLOR_YELLOW)
		return false
	end

	if player:getPremiumDays() >= premiumDaysCost then
		player:removePremiumDays(premiumDaysCost)
		player:setSex(player:getSex() == PLAYERSEX_FEMALE and PLAYERSEX_MALE or PLAYERSEX_FEMALE)
		player:sendColorMessage("You have changed your sex for " .. premiumDaysCost .. " days of your premium account.", MESSAGE_COLOR_YELLOW)
	else
		player:sendColorMessage("You do not have enough premium days, changing sex costs " .. premiumDaysCost .. " days of your premium account.", MESSAGE_COLOR_PURPLE)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
	end
	return false
end
