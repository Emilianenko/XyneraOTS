local itemRepairConfig = {
	[50101] = {itemId = 10021, newItemId = 6132, requiredItemId = 25172, requiredItemCount = 5}, -- soft boots
	[50102] = {itemId = 10021, newItemId = 6132, requiredItemId = 25172, requiredItemCount = 5}, -- znowu soft boots
}

local leverIds = {2401, 2402}

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
		return false
	end

	if player:getItemCount(itemId) < 1 then
		player:sendTextMessage(MESSAGE_INFO_DESCR, "You do not have " .. itemName .. ".")
		return false
	end

	player:removeItem(requiredItemId, requiredItemCount)
	player:removeItem(itemId, 1)
	player:addItem(newItemId, 1)
	player:sendTextMessage(MESSAGE_INFO_DESCR, itemName .. " repaired for " .. requiredItemCount .. "x " .. requiredItemName .. ".")

	return true
end

for k, v in pairs(itemRepairConfig) do
	itemRepairAction:aid(k)
end

itemRepairAction:register()
