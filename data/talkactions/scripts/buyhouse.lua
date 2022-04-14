local config = {
	level = 1,
	onlyPremium = true
}

function onSay(player, words, param)
	local housePrice = configManager.getNumber(configKeys.HOUSE_PRICE)
	if housePrice == -1 then
		return true
	end

	if player:getLevel() < config.level then
		player:sendColorMessage("You need level " .. config.level .. " or higher to buy a house.", MESSAGE_COLOR_PURPLE)
		return false
	end

	if config.onlyPremium and not player:isPremium() then
		player:sendColorMessage("You need a premium account.", MESSAGE_COLOR_PURPLE)
		return false
	end

	local position = player:getPosition()
	position:getNextPosition(player:getDirection())

	local tile = Tile(position)
	local house = tile and tile:getHouse()
	if not house then
		player:sendColorMessage("You have to be looking at the door of the house you would like to buy.", MESSAGE_COLOR_PURPLE)
		return false
	end

	if house:getOwnerGuid() > 0 then
		player:sendColorMessage("This house already has an owner.", MESSAGE_COLOR_PURPLE)
		return false
	end

	if player:getHouse() then
		player:sendColorMessage("You are already the owner of a house.", MESSAGE_COLOR_PURPLE)
		return false
	end

	local price = house:getTileCount() * housePrice
	if not player:removeTotalMoney(price) then
		player:sendColorMessage("You do not have enough money.", MESSAGE_COLOR_PURPLE)
		return false
	end

	house:setOwnerGuid(player:getGuid())
	player:sendColorMessage("You have successfully bought this house, be sure to have the money for the rent in the bank.", MESSAGE_COLOR_YELLOW)
	return false
end
