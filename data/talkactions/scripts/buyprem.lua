local config = {
	days = 90,
	maxDays = 365,
	price = 10000
}

function onSay(player, words, param)
	if configManager.getBoolean(configKeys.FREE_PREMIUM) then
		return true
	end

	if player:getPremiumDays() <= config.maxDays then
		if player:removeTotalMoney(config.price) then
			player:addPremiumDays(config.days)
			player:sendColorMessage("You have bought " .. config.days .." days of premium account.", MESSAGE_COLOR_YELLOW)
		else
			player:sendColorMessage("You don't have enough money, " .. config.maxDays .. " days premium account costs " .. config.price .. " gold coins.", MESSAGE_COLOR_PURPLE)
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
		end
	else
		player:sendColorMessage("You can not buy more than " .. config.maxDays .. " days of premium account.", MESSAGE_COLOR_PURPLE)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
	end
	return false
end
