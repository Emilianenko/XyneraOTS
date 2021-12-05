-- hybrid quest system
-- created by Zbizu

-- config
local triggerScreenshot = true

-- to do:
-- colored messages (true/false)
-- basecolor (for "you have found")

local questSystemMessages = {
	pluralReward = "%d items",
	treasureFound = {"You have found %s", MESSAGE_EVENT_ADVANCE},
	treasureFoundMulti = {"You have found: %s", MESSAGE_EVENT_ADVANCE},
	notEnoughCap = {"You have found %s weighing %0.2f oz. %s too heavy.", MESSAGE_EVENT_ADVANCE, "It is", "They are"},
	notEnoughRoom = {"You have found %s, but you have no room to take %s.", MESSAGE_EVENT_ADVANCE, "it", "them"},
	questCompleted = {"The %s is empty.", MESSAGE_EVENT_ADVANCE},
	storageConflict = {"Unable to open this %s. Configuration conflicting with another server system. Please contact administrator.", MESSAGE_EVENT_ADVANCE},
	badConfiguration = {"Unable to open this %s. Invalid reward configuration. Please contact administrator.", MESSAGE_EVENT_ADVANCE},
}

-- load conflicting storages
local reservedStorageKeys = {}
for _, key in pairs(PlayerStorageKeys) do
	reservedStorageKeys[#reservedStorageKeys + 1] = key
end

-- multiple uids, one storage
local specialQuests = {
	-- anni chest uids
	[PlayerStorageKeys.annihilatorReward] = {1990, 2400, 2431, 2494},
}

-- achievements based on quest storage
local achievements = {
	-- anni storage value
	[PlayerStorageKeys.annihilatorReward] = "Annihilator",
}

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	-- ignore unscripted chests
	if item.uid > 65536 then
		return false
	end
	
	-- prevent storage conflict
	-- NOTE: does not check for specialQuests
	if item.uid < 65536 and table.contains(reservedStorageKeys, item.uid) then
		-- storage conflict error
		player:sendTextMessage(questSystemMessages.storageConflict[2], string.format(questSystemMessages.storageConflict[1], item:getName()))
		return true
	end

	-- determine quest storage
	local storage = item.uid
	for specialStorage, reservedUIDs in pairs(specialQuests) do
		if table.contains(reservedUIDs, item.uid) then
			storage = specialStorage
			break
		end
	end
	
	-- check if the reward was already taken
	if player:getStorageValue(storage) ~= -1 then
		-- the chest is empty
		player:sendTextMessage(questSystemMessages.questCompleted[2], string.format(questSystemMessages.questCompleted[1], item:getName()))
		return true
	end
	
	-- determine quest system used
	local isContainer = item:isContainer()
	local containerItems = isContainer and item:getItems()
	local rewards = {}
	
	if isContainer and #containerItems > 0 then
		-- TFS 0.4 quest system
		for _, containerItem in pairs(containerItems) do
			rewards[#rewards + 1] = containerItem:clone()
		end
	else
		-- legacy quest system
		local itemType = ItemType(item.uid)
		if itemType and itemType:isMovable() and itemType:isPickupable() then
			-- single item reward
			rewards = {Game.createItem(item.uid)}
		else
			-- invalid reward
			player:sendTextMessage(questSystemMessages.badConfiguration[2], string.format(questSystemMessages.badConfiguration[1], item:getName()))
			return true
		end
	end
	
	-- local totalSlots = #rewards
	local totalWeight = 0
	for _, rewardItem in pairs(rewards) do
		totalWeight = totalWeight + rewardItem:getWeight()
	end

	-- determine reward name
	-- to do: color it?
	local rewardName = #rewards == 1 and rewards[1]:getNameDescription(rewards[1]:getSubType(), true) or string.format(questSystemMessages.pluralReward, #rewards)

	-- check capacity
	if player:getFreeCapacity() < totalWeight then
		local grammarForm = #rewards == 1 and questSystemMessages.notEnoughCap[3] or questSystemMessages.notEnoughCap[4]
		player:sendTextMessage(questSystemMessages.notEnoughCap[2], string.format(questSystemMessages.notEnoughCap[1], rewardName, totalWeight/100, grammarForm))
		return true
	end
	
	-- scan backpack to find free slots
	local playerBP = player:getSlotItem(CONST_SLOT_BACKPACK)
	local slotsAvailable = 0
	if playerBP then
		slotsAvailable = playerBP:getEmptySlots(true)
	end
	
	if #rewards > slotsAvailable then
		local grammarForm = #rewards == 1 and questSystemMessages.notEnoughRoom[3] or questSystemMessages.notEnoughRoom[4]
		player:sendTextMessage(questSystemMessages.notEnoughRoom[2], string.format(questSystemMessages.notEnoughRoom[1], rewardName, grammarForm))
		return true
	end
	
	-- all checks passed, add reward
	-- to do: send color? (content desc true)
	rewardName = #rewards == 1 and rewardName or item:getContentDescription()
	
	-- "you have found" message
	if #rewards == 1 then
		player:sendTextMessage(questSystemMessages.treasureFound[2], string.format(questSystemMessages.treasureFound[1], rewardName))
	else
		player:sendTextMessage(questSystemMessages.treasureFoundMulti[2], string.format(questSystemMessages.treasureFoundMulti[1], rewardName))
	end
	-- storage
	player:setStorageValue(storage, 1)
	
	-- add reward
	for _, reward in pairs(rewards) do
		player:addItemEx(reward)
	end
	
	-- add achievement
	local achieved = false
	if achievements[storage] then
		player:addAchievement(achievements[storage])
		achieved = true
	end
	
	-- trigger screenshot
	if triggerScreenshot then
		player:takeScreenshot(SCREENSHOT_TYPE_TREASUREFOUND)
		
		if achieved then
			player:takeScreenshot(SCREENSHOT_TYPE_ACHIEVEMENT)
		end
	end
	
	return true
end
