-- hybrid quest system
-- created by Zbizu

--[[
	configurations presets:
		retro quest messages:
			local messageType = MESSAGE_INFO_DESCR

		modern quest messages:
			local messageType = MESSAGE_EVENT_ADVANCE

		single color quest messages:
			local messageType = MESSAGE_LOOT
			local baseColor = MESSAGE_COLOR_BLUE
			local colorLoot = false
			
		fancy quest messages:
			local messageType = MESSAGE_LOOT
			local baseColor = MESSAGE_COLOR_GREEN
			local colorLoot = true
]]

local messageType = MESSAGE_LOOT
local baseColor = MESSAGE_COLOR_GREEN
local colorLoot = true

local questSystemMessages = {
	pluralReward = "%d items",
	treasureFound = {"You have found %s."},
	treasureFoundMulti = {"You have found: %s"},
	notEnoughCap = {"You have found %s weighing %s. %s too heavy.", "It is", "They are"},
	notEnoughRoom = {"You have found %s, but you have no room to take %s.", "it", "them"},
	questCompleted = {"The %s is empty."},
	storageConflict = {"Unable to open this %s. Configuration conflicting with another server system. Please contact administrator."},
	badConfiguration = {"Unable to open this %s. Invalid reward configuration. Please contact administrator."},
}

local colorTemplate = "{%d|%s}"

-- load conflicting storages
local reservedStorageKeys = {}
for _, key in pairs(PlayerStorageKeys) do
	reservedStorageKeys[#reservedStorageKeys + 1] = key
end

-- multiple uids, one storage
local specialQuests = {
	-- chests with these uids will give anninhilator storage
	[PlayerStorageKeys.annihilatorReward] = {1200, 1201, 1202, 1203},
	[PlayerStorageKeys.yurPharaohQuest] = {1204, 1205, 1206}
	
	-- other quest example
	-- [yourStorageHere] = {yourUID1, yourUID2},
}

-- achievements based on quest storage
local achievements = {
	-- anni storage value
	[PlayerStorageKeys.annihilatorReward] = "Annihilator",
}

local function sendQuestSystemMessage(player, message)
	if messageType == MESSAGE_LOOT then
		player:sendColorMessage(message, baseColor)
	else
		player:sendTextMessage(messageType, message)
	end
end

local function formatWithColor(message, ...)
	if messageType ~= MESSAGE_LOOT then
		return string.format(message, ...)
	end
	
	message = string.format(colorTemplate, baseColor, message)
	local args = table.pack(...)
	
	for argId, arg in pairs(args) do
		args[argId] = string.format("}%s{%d|", arg, baseColor)
	end
	
	return string.format(message, unpack(args))
end

local function getRewardDescription(item)
	if messageType == MESSAGE_LOOT then
		if colorLoot then
			return item:getColorContentDescription(baseColor)
		else
			return string.format(colorTemplate, baseColor, item:getContentDescription())
		end
	end

	return item:getContentDescription()
end

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	-- ignore unscripted chests
	if item.uid > 65535 then
		return false
	end
	
	-- prevent storage conflict
	-- NOTE: does not check for specialQuests
	if table.contains(reservedStorageKeys, item.uid) then
		-- storage conflict error
		sendQuestSystemMessage(player, string.format(questSystemMessages.storageConflict[1], item:getName()))
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
		sendQuestSystemMessage(player, string.format(questSystemMessages.questCompleted[1], item:getName()))
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
			sendQuestSystemMessage(player, string.format(questSystemMessages.badConfiguration[1], item:getName()))
			return true
		end
	end
	
	-- local totalSlots = #rewards
	local totalWeight = 0
	for _, rewardItem in pairs(rewards) do
		totalWeight = totalWeight + rewardItem:getWeight()
	end

	-- determine reward name
	local rewardName = #rewards == 1 and rewards[1]:getNameDescription(rewards[1]:getSubType(), true) or string.format(questSystemMessages.pluralReward, #rewards)
	if messageType == MESSAGE_LOOT then
		if #rewards == 1 then
			rewardName = string.format(colorTemplate, colorLoot and rewards[1]:getType():getClientId() or baseColor, rewardName)
		elseif not colorLoot then
			rewardName = string.format(colorTemplate, baseColor, rewardName)
		end
	end
		
	-- check capacity
	if player:getFreeCapacity() < totalWeight then
		local grammarForm = #rewards == 1 and questSystemMessages.notEnoughCap[2] or questSystemMessages.notEnoughCap[3]
		local weightString = string.format("%0.2f oz", totalWeight/100)
		if messageType == MESSAGE_LOOT then
			grammarForm = string.format(colorTemplate, baseColor, grammarForm)
			
			if not colorLoot then
				weightString = string.format(colorTemplate, baseColor, weightString)
			end
		end
		
		player:sendTextMessage(messageType, formatWithColor(questSystemMessages.notEnoughCap[1], rewardName, weightString, grammarForm))
		return true
	end
	
	-- scan backpack to find free slots
	local playerBP = player:getSlotItem(CONST_SLOT_BACKPACK)
	local slotsAvailable = 0
	if playerBP then
		slotsAvailable = playerBP:getEmptySlots(true)
	end
	
	if #rewards > slotsAvailable then
		local grammarForm = #rewards == 1 and questSystemMessages.notEnoughRoom[2] or questSystemMessages.notEnoughRoom[3]
		if messageType == MESSAGE_LOOT then
			grammarForm = string.format(colorTemplate, baseColor, grammarForm)
		end
		
		player:sendTextMessage(messageType, formatWithColor(questSystemMessages.notEnoughRoom[1], rewardName, grammarForm))
		return true
	end
	
	-- all checks passed, add reward
	-- determine color based on cfg
	rewardName = #rewards == 1 and rewardName or getRewardDescription(item)
	
	-- "you have found" message
	if #rewards == 1 then
		player:sendTextMessage(messageType, formatWithColor(questSystemMessages.treasureFound[1], rewardName))
	else
		player:sendTextMessage(messageType, formatWithColor(questSystemMessages.treasureFoundMulti[1], rewardName))
	end
	
	-- storage
	player:setStorageValue(storage, 1)
	
	-- add reward
	for _, reward in pairs(rewards) do
		player:addItemEx(reward)
	end
	
	-- add achievement
	if achievements[storage] then
		player:addAchievement(achievements[storage])
	end
	
	-- trigger screenshot
	player:takeScreenshot(SCREENSHOT_TYPE_TREASUREFOUND)
	return true
end
