local itemRepairConfig = {
	[50101] = {itemId = 32084, newItemId = 32998, requiredItemId = 25172, requiredItemCount = 2}, -- sleep shawl
	[50102] = {itemId = 32085, newItemId = 33000, requiredItemId = 25172, requiredItemCount = 2}, -- pendulet
	[50103] = {itemId = 33057, newItemId = 33059, requiredItemId = 25172, requiredItemCount = 2}, -- theugly
	[50104] = {itemId = 35292, newItemId = 35277, requiredItemId = 25172, requiredItemCount = 2}, -- ring of souls
	[50105] = {itemId = 34277, newItemId = 34213, requiredItemId = 25172, requiredItemCount = 2}, -- blister ring
	[50106] = {itemId = 44266, newItemId = 44264, requiredItemId = 25172, requiredItemCount = 2}, -- turtle amulet
	[50107] = {itemId = 44210, newItemId = 44208, requiredItemId = 25172, requiredItemCount = 5}, -- spiritthorn ring
	[50108] = {itemId = 44213, newItemId = 44211, requiredItemId = 25172, requiredItemCount = 5}, --  alicorn ring
	[50109] = {itemId = 44219, newItemId = 44217, requiredItemId = 25172, requiredItemCount = 5}, -- arboreal ring
	[50110] = {itemId = 44216, newItemId = 44214, requiredItemId = 25172, requiredItemCount = 5}, -- arcanomancer sigil
}

local itemShopConfig = {
	[50021] = {itemId = 2286, count = 100, cost = 13500, name = "sudden death runes" },
}

local leverIds = {1945, 1946}

local itemRepairAction = Action()

function itemRepairAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	
	-- Repair lever
	local config = itemRepairConfig[item.actionid]
	if config then
		item:transform(item.itemid == leverIds[1] and leverIds[2] or leverIds[1])

		local itemId = config.itemId
		local newItemId = config.newItemId
		local requiredItemId = config.requiredItemId
		local requiredItemCount = config.requiredItemCount

		local itemType = ItemType(itemId)
		local itemName = itemType:getName() or "error-unknown-item"
		local requiredItemType = ItemType(requiredItemId)
		local requiredItemName = requiredItemType:getName() or "error-unknown-item"


		if player:getItemCount(requiredItemId) < requiredItemCount then
			player:sendTextMessage(MESSAGE_INFO_DESCR, itemName .. " repair costs " .. requiredItemCount .. "x " .. requiredItemName .. ".")
			item:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		end

		if player:getItemCount(itemId) < 1 then
			player:sendTextMessage(MESSAGE_INFO_DESCR, "You do not have " .. itemName .. ".")
			item:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		end

		player:removeItem(requiredItemId, requiredItemCount)
		player:removeItem(itemId, 1)
		player:addItem(newItemId, 1)
		player:sendTextMessage(MESSAGE_INFO_DESCR, itemName .. " repaired for " .. requiredItemCount .. "x " .. requiredItemName .. ".")
		item:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)

		return true
	end

	-- Shop lever
	local config = itemShopConfig[item:getUniqueId()]
	if config then
		if player:removeTotalMoney(config.cost) then
            player:sendColorMessage("Success! You bought ".. config.count .." ".. config.name .. " for ".. config.cost .. " gold coins.", MESSAGE_COLOR_YELLOW)
			player:addItem(config.itemId, config.count)
            return true
        else
            player:sendColorMessage("You don't have enough money.", MESSAGE_COLOR_PURPLE)
            player:getPosition():sendMagicEffect(CONST_ME_POFF)

			return false
        end
	else
		item:getPosition():sendMagicEffect(CONST_ME_POFF) 
	end
end

for k, v in pairs(itemRepairConfig) do
	itemRepairAction:aid(k)
end

itemRepairAction:register()
