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
	podiumCompleted = {"You have already claimed this reward."},
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
PlayerStorageKeys.earlyWeaponReward = 1002

local specialQuests = {
	-- chests with these uids will give anninhilator storage
	--[PlayerStorageKeys.annihilatorReward] = {1200, 1201, 1202, 1203},
	
	-- level 30 weapon (single choice)
	[PlayerStorageKeys.earlyWeaponReward] = {1002, 1003, 1004, 1005, 1006, 1007}
	
	-- other quest example
	-- [yourStorageHere] = {yourUID1, yourUID2},
}

-- achievements based on quest storage
local achievements = {
	-- anni storage value
	--[PlayerStorageKeys.annihilatorReward] = "Annihilator",
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

local exceptions = {
	-- mage/summoner conversion
	[130] = 141,
	[133] = 138,
	[138] = 133,
	[141] = 130,
	
	-- nobleman/noblewoman
	[132] = 140,
	[140] = 132,
	
	-- norseman/norsewoman
	[251] = 252,
	[252] = 251,
	
	-- retro mage/summoner conversion
	[964] = 969,
	[965] = 968,
	[968] = 965,
	[969] = 964,
	
	-- retro nobleman/noblewoman
	[966] = 967,
	[967] = 966,
}

local outfitListCache = {}
for _, outfitInfo in pairs(Game.getOutfits(PLAYERSEX_MALE)) do
	if not exceptions[outfitInfo.lookType] then
		outfitListCache[outfitInfo.name] = {}
		outfitListCache[outfitInfo.name][1] = outfitInfo.lookType
	end
end
for _, outfitInfo in pairs(Game.getOutfits(PLAYERSEX_FEMALE)) do
	if not exceptions[outfitInfo.lookType] then
		outfitListCache[outfitInfo.name][0] = outfitInfo.lookType
	end
end

local outfitPrefixes = {
	[0] = "the ",
	[1] = "first ",
	[2] = "second ",
	[3] = "full "
}

local outfitSuffixes = {
	[0] = " outfit",
	[1] = " addon",
	[2] = " addon",
	[3] = " outfit"
}

local function handlePodiumReward(player, item, storage)
	-- check if the reward was already taken
	if player:getStorageValue(storage) ~= -1 then
		sendQuestSystemMessage(player, questSystemMessages.podiumCompleted[1])
		return true
	end
	
	local outfit = item:getOutfit()
	local hasOutfit = item:hasFlag(PODIUM_SHOW_OUTFIT)
	local hasMount = item:hasFlag(PODIUM_SHOW_MOUNT)
	local mountName = ""
	
	if outfit then
		local outfitRewardA = 0
		local outfitRewardB = 0
		local outfitAddons = outfit.lookAddons
		local mountReward = 0
		
		local outfitType = Outfit(outfit.lookType)
		if outfitType then
			if hasOutfit then
				if exceptions[outfit.lookType] then
					outfitRewardA = outfit.lookType
					outfitRewardB = exceptions[outfit.lookType]
				elseif outfitListCache[outfitType.name] then
					outfitRewardA = outfitListCache[outfitType.name][PLAYERSEX_FEMALE]
					outfitRewardB = outfitListCache[outfitType.name][PLAYERSEX_MALE]
				end
			end
			
			-- search mount
			mountName = getMountNameByLookType(outfit.lookMount)
			if mountName and hasMount then
				mountReward = Game.getMountIdByLookType(outfit.lookMount)
			end
		else
			-- search mount
			local realLookMount = outfit.lookMount
			mountName = getMountNameByLookType(outfit.lookMount)
			local isEnabled = mountName and hasMount
			if not mountName then
				mountName = getMountNameByLookType(outfit.lookType)
				isEnabled = mountName and hasOutfit
				realLookMount = outfit.lookType
			end
			
			if mountName and isEnabled then
				mountReward = Game.getMountIdByLookType(outfit.lookMount)
			end
		end
		
		local rewards = {}
		if outfitRewardA and outfitRewardA ~= 0 and outfitRewardB and outfitRewardB ~= 0 then
			player:addOutfit(outfitRewardA)
			player:addOutfit(outfitRewardB)
			if outfitAddons > 0 then
				player:addOutfitAddon(outfitRewardA, outfitAddons)
				player:addOutfitAddon(outfitRewardB, outfitAddons)
			end
			
			local prefix = outfitPrefixes[outfitAddons] or ""
			local suffix = outfitSuffixes[outfitAddons] or ""
			rewards[#rewards + 1] = string.format("%s%s%s", prefix, outfitType.name, suffix)
		end
		
		if mountReward and mountReward ~= 0 then
			player:addMount(mountReward)
			rewards[#rewards + 1] = string.format("the %s mount", mountName or "(errorName)")
		end
		
		if #rewards > 0 then
			sendQuestSystemMessage(player, string.format("You have unlocked %s.", table.concat(rewards, " and ")))
			player:setStorageValue(storage, 1)
			
			local itemPos = item:getPosition()
			itemPos:sendMagicEffect(CONST_ME_FIREWORK_CIRCLE)
			itemPos:sendMagicEffect(CONST_ME_PINKSPARK)
			player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_TURQUOISE)
			player:takeScreenshot(SCREENSHOT_TYPE_TREASUREFOUND)
		else
			sendQuestSystemMessage(player, "This podium does not offer a reward.")
		end
	end
end

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	-- ignore unscripted chests
	if item.uid > 65535 then
		-- podium toggle light
		local id = item:getId()
		if id == 38629 then
			item:transform(38330)
		elseif id == 38330 then
			item:transform(38629)
		end
	
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
	
	-- outfit reward
	if item:getType():isPodium() then
		handlePodiumReward(player, item, storage)
		return true
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
