function onSay(player, words, param)
	if not player:isAdmin() then
		return true
	end

	local split = param:splitTrimmed(",")

	local itemType = ItemType(split[1])
	if itemType:getId() == 0 then
		itemType = ItemType(tonumber(split[1]))
		if not tonumber(split[1]) or itemType:getId() == 0 then
			player:sendColorMessage("There is no item with that id or name.", MESSAGE_COLOR_PURPLE)
			return false
		end
	end

	if itemType:getId() < 100 then
		return false
	end

	local keyNumber = 0
	local count = tonumber(split[2])
	if count then
		if itemType:isStackable() then
			count = math.min(10000, math.max(1, count))
		elseif itemType:isKey() then
			keyNumber = count
			count = 1
		elseif not itemType:isFluidContainer() then
			count = math.min(100, math.max(1, count))
		else
			count = math.max(0, count)
		end
	else
		if not itemType:isFluidContainer() then
			count = 1
		else
			count = 0
		end
	end

	local result = player:addItem(itemType:getId(), count)
	if result then
		if not itemType:isStackable() then
			local charges = itemType:getCharges()
			if type(result) == "table" then
				for _, item in ipairs(result) do
					if charges > 1 then
						item:setAttribute(ITEM_ATTRIBUTE_CHARGES, charges)
					end
					item:decay()
				end
			else
				if itemType:isKey() then
					result:setAttribute(ITEM_ATTRIBUTE_ACTIONID, keyNumber)
				end
				
				if charges > 1 then
					result:setAttribute(ITEM_ATTRIBUTE_CHARGES, charges)
				end
				result:decay()
			end
		end
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	end
	return false
end
