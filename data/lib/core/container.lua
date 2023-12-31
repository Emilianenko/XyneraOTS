function Container:isContainer()
	return true
end

function Container:getContentDescription()
	local items = self:getItems()
	if items and #items > 0 then
		local loot = {}
		for i = 1, #items do
			loot[#loot+1] = items[i]:getNameDescription(items[i]:getSubType(), true)
		end

		return table.concat(loot, ", ")
	end

	return "nothing"
end

local style = "{%d|%s}"
function Container:getColorContentDescription(baseColor)
	local items = self:getItems()
	if items and #items > 0 then
		local loot = {}
		for i = 1, #items do
			loot[#loot+1] = string.format(style, items[i]:getType():getClientId(), items[i]:getNameDescription(items[i]:getSubType(), true))
		end

		return baseColor and table.concat(loot, string.format(style, baseColor, ", ")) or table.concat(loot, ", ")
	end

	return baseColor and string.format(style, baseColor, "nothing") or "nothing"
end

local function dropChanceFormula(contribution)	
	local contributionPercent = contribution * 100
	if contributionPercent < 1 then
		return 0.09 -- 9%
	elseif contributionPercent <= 2 then
		return 0.12
	elseif contributionPercent <= 6 then
		return 0.21
	elseif contributionPercent <= 20 then
		return 0.32
	elseif contributionPercent <= 40 then
		return 0.51
	elseif contributionPercent <= 50 then
		return 0.6
	elseif contributionPercent <= 70 then
		return 0.7
	elseif contributionPercent <= 90 then
		return 0.85
	end
	
	return 1
end

local lootRate = configManager.getNumber(configKeys.RATE_LOOT)
function Container:createLootItem(item, playerRank, contribution)
	if self:getEmptySlots() == 0 then
		return true
	end

	local itemCount = 0
	local itemType = ItemType(item.itemId)
	local stackable = itemType:isStackable()
	local luck = 1
	
	local dropChance = item.chance
	if dropChance ~= MAX_LOOTCHANCE then
		dropChance = dropChance * lootRate

		if contribution then
			luck = dropChanceFormula(contribution)
			if stackable then
				-- less harsh calculation for stackables
				luck = math.min(0.4 + 0.6 * luck, 1)
			end
			
			dropChance = math.floor(dropChance * luck)
		end
	end
	
	if math.random(0, MAX_LOOTCHANCE) < dropChance and (item.top == 0 or playerRank and playerRank <= item.top) then
		if stackable then
			itemCount = math.floor(item.maxCount * luck)
		else
			itemCount = 1
		end
	end

	while itemCount > 0 do
		local count = math.min(100, itemCount)
		
		local subType = count
		if itemType:isFluidContainer() then
			subType = math.max(0, item.subType)
		end
		
		local tmpItem = Game.createItem(item.itemId, subType)
		if not tmpItem then
			return false
		end

		if tmpItem:isContainer() then
			for i = 1, #item.childLoot do
				if not tmpItem:createLootItem(item.childLoot[i]) then
					tmpItem:remove()
					return false
				end
			end

			if #item.childLoot > 0 and tmpItem:getSize() == 0 then
				tmpItem:remove()
				return true
			end
		end

		if item.subType ~= -1 then
			tmpItem:setAttribute(ITEM_ATTRIBUTE_CHARGES, item.subType)
		else
			local defaultCharges = itemType:getCharges()
			if defaultCharges ~= 0 then
				tmpItem:setAttribute(ITEM_ATTRIBUTE_CHARGES, defaultCharges)
			end
		end

		if item.actionId ~= -1 then
			tmpItem:setActionId(item.actionId)
		end

		if item.text and item.text ~= "" then
			tmpItem:setText(item.text)
		end

		local ret = self:addItemEx(tmpItem)
		if ret ~= RETURNVALUE_NOERROR then
			tmpItem:remove()
		end

		itemCount = itemCount - count
	end
	return true
end
