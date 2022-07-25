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
	local player = Player(cid)
	if not player then
		return 1, 0
	end

	local amount = amount or 1
	local subType = subType or 0

	local itemType = ItemType(itemid)
	local weight = itemType:getWeight()

	if itemType:isStackable() then
		local baseAmount = amount
		local mainBackpack = player:getSlotItem(CONST_SLOT_BACKPACK)

		if inBackpacks then
			-- stackable, buy in backpacks: true
			local shoppingBagType = ItemType(backpack)
			local shoppingBagSlots = shoppingBagType:getCapacity()
			if shoppingBagSlots == 0 then
				-- avoid dividing by zero
				return 0, 0
			end

			-- generate virtual shopping bags
			local itemsToAdd = {}
			while amount > 0 do
				local shoppingBag = Game.createItem(backpack, 1)

				while shoppingBag:getEmptySlots() > 0 and amount > 0 do
					local currentAmount = math.min(amount, 100)
					shoppingBag:addItem(itemid, currentAmount)
					amount = amount - currentAmount
				end

				itemsToAdd[#itemsToAdd + 1] = shoppingBag
			end

			-- check if virtual bags can be carried
			local playerCap = player:getFreeCapacity()
			local playerSlots = (mainBackpack and mainBackpack:getEmptySlots(true) or 0)
			local shoppingBagCount = #itemsToAdd
			local slotsDiff = playerSlots - shoppingBagCount
			local totalWeight = weight * baseAmount + shoppingBagType:getWeight() * shoppingBagCount
			local weightDiff = playerCap - totalWeight

			if weightDiff >= 0 and slotsDiff >= 0 then
				-- conditions are met - player has enough cap/slots
				for _, shoppingBag in pairs(itemsToAdd) do
					player:addItemEx(shoppingBag, ignoreCap)
				end

				return baseAmount, shoppingBagCount
			end

			-- check if player has ignore cap selected
			if not ignoreCap then
				return 0, 0
			end

			-- check if tile exists
			local tile = player:getTile()
			if not tile then
				return 0, 0
			end

			local fullShoppingBagWeight = shoppingBagSlots * baseAmount * weight * 100
			local lastShoppingBagWeight = itemsToAdd[#itemsToAdd]:getWeight()

			local droppedBackpacks = shoppingBagCount
			for i = 1, shoppingBagCount do
				local currentBagWeight = i < shoppingBagCount and fullShoppingBagWeight or lastShoppingBagWeight
				playerCap = playerCap - currentBagWeight
				playerSlots = playerSlots - 1
				if playerCap < 0 or playerSlots < 0 then
					droppedBackpacks = droppedBackpacks + 1
				end
			end

			-- check if tile can accept more items
			if NPCTRADE_MAX_ITEMS_ON_TILE - tile:getItemCount() < droppedBackpacks then
				-- unable to add bags to player, release from memory
				for _, shoppingBag in pairs(itemsToAdd) do
					shoppingBag:remove()
				end

				return 0, 0
			end

			-- shove shopping bags to player inventory
			for _, shoppingBag in pairs(itemsToAdd) do
				player:addItemEx(shoppingBag, ignoreCap)
			end

			return baseAmount, shoppingBagCount
		else
			-- stackable, buy in backpacks: false
			local slotCount = math.ceil(amount / 100)
			local slotsDiff = (mainBackpack and mainBackpack:getEmptySlots(true) or 0) - slotCount
			local weightDiff = player:getFreeCapacity() - (weight * amount)

			if weightDiff >= 0 and slotsDiff >= 0 then
				-- conditions are met - player has enough cap/slots
				player:addItem(itemid, amount, false)
				return baseAmount, 0
			end

			if ignoreCap then
				-- ignore cap enabled, calculate how many stacks will drop on the floor
				local tile = player:getTile()
				if tile and NPCTRADE_MAX_ITEMS_ON_TILE - tile:getItemCount() >= math.max(math.ceil(-weightDiff / (weight * 100)), -slotsDiff) then
					player:addItem(itemid, amount)
					return baseAmount, 0
				end
			end

			-- ignore cap disabled or tile not found or tile too trashed to drop new stacks
			return 0, 0
		end
	end

	local tile = player:getTile()
	local tileSlots = tile and NPCTRADE_MAX_ITEMS_ON_TILE - tile:getItemCount() or 0

	-- not stackable, buy in backpacks: true
	local a = 0
	if inBackpacks then
		local container, b = Game.createItem(backpack, 1), 1
		local canTakeItems = true

		for i = 1, amount do
			local item = container:addItem(itemid, subType)
			if table.contains({(ItemType(backpack):getCapacity() * b), amount}, i) then
				-- try adding a shopping bag
				local taken = false
				if canTakeItems then
					if player:addItemEx(container, false) == RETURNVALUE_NOERROR then
						taken = true
					else
						canTakeItems = false
					end
				end

				-- handle ignoreCap situation
				if not taken then
					if tileSlots > 0 and player:addItemEx(container, ignoreCap) == RETURNVALUE_NOERROR then
						tileSlots = tileSlots - 1
					else
						b = b - 1
						break
					end
				end

				a = i
				if amount > i then
					container = Game.createItem(backpack, 1)
					b = b + 1
				end
			end
		end
		
		return a, b
	end

	-- not stackable, buy in backpacks: false
	local canTakeItems = true
	for i = 1, amount do
		local item = Game.createItem(itemid, subType)

		-- try adding item normally
		local taken = false
		if canTakeItems then
			if player:addItemEx(item, false) ~= RETURNVALUE_NOERROR then
				taken = true
			else
				canTakeItems = false
			end
		end

		-- handle ignoreCap situation
		if not taken then
			if tileSlots > 0 and player:addItemEx(item, ignoreCap) == RETURNVALUE_NOERROR then
				tileSlots = tileSlots - 1
			else
				break
			end
		end

		a = i
	end

	return a, 0
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

function getMoneyCount(string)
	local b, e = string:find("%d+")
	local tonumber = tonumber(string:sub(b, e))
	if tonumber > 2 ^ 32 - 1 then
		print("Warning: Casting value to 32bit to prevent crash\n"..debug.traceback())
	end
	local money = b and e and math.min(2 ^ 32 - 1, tonumber) or -1
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
