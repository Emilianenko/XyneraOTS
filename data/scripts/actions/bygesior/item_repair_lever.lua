local itemRepairConfig = {
	[50101] = {itemId = 32084, newItemId = 32998, requiredItemId = 25172, requiredItemCount = 2}, -- sleep shawl
	[50102] = {itemId = 32085, newItemId = 33001, requiredItemId = 25172, requiredItemCount = 2}, -- pendulet
	[50103] = {itemId = 33057, newItemId = 33059, requiredItemId = 25172, requiredItemCount = 2}, -- theugly
	[50104] = {itemId = 35277, newItemId = 35292, requiredItemId = 25172, requiredItemCount = 2}, -- ring of souls
	[50105] = {itemId = 34213, newItemId = 34277, requiredItemId = 25172, requiredItemCount = 2}, -- blister ring
}

local leverIds = {1945, 1946}

local itemRepairAction = Action()

function itemRepairAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local config = itemRepairConfig[item.actionid]
	if not config then
		return false
	end

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

for k, v in pairs(itemRepairConfig) do
	itemRepairAction:aid(k)
end

itemRepairAction:register()
