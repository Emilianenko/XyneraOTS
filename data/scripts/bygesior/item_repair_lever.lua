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
	[50020] = {itemId = 3161, count = 100, cost = 5700, name = "avalanche runes" },
	[50021] = {itemId = 3155, count = 100, cost = 13500, name = "sudden death runes" },
	[50022] = {itemId = 3175, count = 100, cost = 3700, name = "stone shower runes" },
	[50023] = {itemId = 3171, count = 100, cost = 5700, name = "great fireball runes" },
	[50024] = {itemId = 3202, count = 100, cost = 4700, name = "thunderstorm runes" },
	[50025] = {itemId = 3192, count = 100, cost = 14700, name = "fire bomb runes" },
	[50026] = {itemId = 3173, count = 100, cost = 8500, name = "poison bomb runes" },
	[50027] = {itemId = 3149, count = 100, cost = 20300, name = "energy bomb runes" },
	[50028] = {itemId = 23375, count = 100, cost = 62500, name = "supreme health potions" },
	[50029] = {itemId = 239, count = 100, cost = 22500, name = "great health potions" },
	[50030] = {itemId = 236, count = 100, cost = 11500, name = "strong health potions" },
	[50031] = {itemId = 266, count = 100, cost = 5000, name = "health potions" },
	[50032] = {itemId = 23374, count = 100, cost = 43800, name = "ultimate spirit potions" },
	[50033] = {itemId = 7642, count = 100, cost = 22800, name = "great spirit potions" },
	[50034] = {itemId = 3180, count = 100, cost = 11600, name = "magic wall runes" },
	[50035] = {itemId = 3165, count = 10, cost = 9000, name = "paralyse runes" },
	[50036] = {itemId = 3156, count = 100, cost = 16000, name = "wild growth runes" },
	[50037] = {itemId = 23373, count = 100, cost = 43800, name = "ultimate mana potions" },
	[50038] = {itemId = 238, count = 100, cost = 14400, name = "great mana potions" },
	[50039] = {itemId = 237, count = 100, cost = 9300, name = "strong mana potions" },
	[50040] = {itemId = 268, count = 100, cost = 5600, name = "mana potions" },
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
			player:sendTextMessage(MESSAGE_COLOR_PURPLE, itemName .. " repair costs " .. requiredItemCount .. "x " .. requiredItemName .. ".")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		end

		if player:getItemCount(itemId) < 1 then
			player:sendTextMessage(MESSAGE_COLOR_PURPLE, "You do not have " .. itemName .. ".")
				player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		end

		player:removeItem(requiredItemId, requiredItemCount)
		player:removeItem(itemId, 1)
		player:addItem(newItemId, 1)
		player:sendTextMessage(MESSAGE_COLOR_WHITE, itemName .. " repaired for " .. requiredItemCount .. "x " .. requiredItemName .. ".")
		player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)

		return true
	end

	-- Shop lever
	local config = itemShopConfig[item.actionid]
	if config then

		if player:removeTotalMoney(config.cost) then
            player:sendColorMessage("Success! You bought ".. config.count .." ".. config.name .. " for ".. config.cost .. " gold coins.", MESSAGE_COLOR_WHITE)
			player:getPosition():sendMagicEffect(CONST_ME_SOUND_GREEN)
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

for k, v in pairs(itemShopConfig) do
	itemRepairAction:aid(k)
end

itemRepairAction:register()
