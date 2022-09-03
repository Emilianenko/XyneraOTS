-- Including the Advanced NPC System
dofile('data/npc/lib/npcsystem/npcsystem.lua')

function msgcontains(message, keyword)
	local message, keyword = message:lower(), keyword:lower()
	if message == keyword then
		return true
	end

	return message:find(keyword) and not message:find('(%w+)' .. keyword)
end

function doNpcSellItem(cid, itemid, amount, subType, ignoreCap, inBackpacks, backpack)
	local amountSold = 0
	local backpacksSold = 0

	local player = Player(cid)
	if not player then
		return amountSold, backpacksSold
	end

	-- item data
	local amount = amount or 1
	local itemType = ItemType(itemid)
	local stackable = itemType:isStackable()
	local subType = not stackable and subType or 0
	local weight = itemType:getWeight()

	-- handlers for dropping on the floor
	local tile = player:getTile()
	local tileSlots = tile and NPCTRADE_MAX_ITEMS_ON_TILE - tile:getItemCount() or 0
	local playerPos = player:getPosition()

	local amountToSell = amount

	-- buy in backpacks
	if inBackpacks then
		while amountToSell > 0 do
			-- try to add backpack
			local backpack = player:addItem(backpack, 1, false)
			if not backpack then
				if not ignoreCap or tileSlots < 1 then
					return amountSold, backpacksSold
				end

				backpack = Game.createItem(backpack, 1, playerPos)
				if not backpack then
					return amountSold, backpacksSold
				end

				tileSlots = tileSlots - 1
			end
			backpacksSold = backpacksSold + 1

			local bpSlots = backpack:getEmptySlots()
			while bpSlots > 0 do
				local currentAmount = math.min(amountToSell, stackable and 100 or 1)
				if currentAmount == 0 then
					return amountSold, backpacksSold
				end

				local realAmount = subType > 0 and not stackable and subType or currentAmount
				if backpack:addItem(itemid, realAmount) then
					bpSlots = bpSlots - 1

					amountToSell = amountToSell - currentAmount
					amountSold = amountSold + currentAmount
				else
					bpSlots = 0

					local topParent = backpack:getTopParent()
					if not topParent or topParent ~= player then
						return amountSold, backpacksSold
					end
				end
			end
		end

		return amountSold, backpacksSold
	end

	-- not in backpacks
	while amountToSell > 0 do
		local currentAmount = math.min(amountToSell, stackable and 100 or 1)
		if currentAmount == 0 then
			return amountSold, backpacksSold
		end

		local addedItems = player:addItem(itemid, currentAmount, false, subType)
		if addedItems and type(addedItems) == "table" and #addedItems == 0 then
			addedItems = false
		end

		if addedItems then
			amountToSell = amountToSell - currentAmount
			amountSold = amountSold + currentAmount
		else
			if not ignoreCap or tileSlots < 1 then
				return amountSold, backpacksSold
			end

			local realAmount = subType > 0 and not stackable and subType or currentAmount
			local item = Game.createItem(itemid, realAmount, playerPos)
			if not item then
				return amountSold, backpacksSold
			end

			amountToSell = amountToSell - currentAmount
			amountSold = amountSold + currentAmount
			tileSlots = tileSlots - 1
		end
	end

	return amountSold, backpacksSold
end

local func = function(cid, text, type, e, pcid)
	if Player(pcid):isPlayer() then
		local creature = Creature(cid)
		creature:say(text, type, false, pcid, creature:getPosition())
		e.done = true
	end
end

function doCreatureSayWithDelay(cid, text, type, delay, e, pcid)
	if Player(pcid):isPlayer() then
		e.done = false
		e.event = addEvent(func, delay < 1 and 1000 or delay, cid, text, type, e, pcid)
	end
end

function doPlayerSellItem(cid, itemid, count, cost)
	local player = Player(cid)
	if player:removeItem(itemid, count, -1, true, true) then
		if not player:addMoney(cost) then
			error('Could not add money to ' .. player:getName() .. '(' .. cost .. 'gp)')
		end
		return true
	end
	return false
end

function doPlayerBuyItemContainer(cid, containerid, itemid, count, cost, charges)
	local player = Player(cid)
	if not player:removeTotalMoney(cost) then
		return false
	end

	for i = 1, count do
		local container = Game.createItem(containerid, 1)
		for x = 1, ItemType(containerid):getCapacity() do
			container:addItem(itemid, charges)
		end

		if player:addItemEx(container, true) ~= RETURNVALUE_NOERROR then
			return false
		end
	end
	return true
end

function getCount(string)
	local b, e = string:find("%d+")
	local tonumber = tonumber(string:sub(b, e))
	if tonumber > 2 ^ 32 - 1 then
		print("Warning: Casting value to 32bit to prevent crash\n"..debug.traceback())
	end
	return b and e and math.min(2 ^ 32 - 1, tonumber) or -1
end

function isValidMoney(money)
	return isNumber(money) and money > 0
end

function getMoneyCount(msg)
	local b, e = msg:find("%d+")
	local amount = tonumber(msg:sub(b, e))
	if amount > 2 ^ 32 - 1 then
		print("Warning: Casting value to 32bit to prevent crash\n"..debug.traceback())
	end
	local money = b and e and math.min(2 ^ 32 - 1, amount) or -1
	if isValidMoney(money) then
		return money
	end
	return -1
end

function getMoneyWeight(money)
	local weight, currencyItems = 0, Game.getCurrencyItems()
	for index = #currencyItems, 1, -1 do
		local currency = currencyItems[index]
		local worth = currency:getWorth()
		local currencyCoins = math.floor(money / worth)
		if currencyCoins > 0 then
			money = money - (currencyCoins * worth)
			weight = weight + currency:getWeight(currencyCoins)
		end
	end
	return weight
end
