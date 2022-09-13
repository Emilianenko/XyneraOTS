RewardSystem = true

local ticksDuration = configManager.getNumber(configKeys.PZ_LOCKED)
function generateBossRewards(monster, corpse)
	local rawDamageMap = monster:getDamageMap()
	
	-- remove expired damage outputs
	for playerId, damageData in pairs(rawDamageMap) do
		if os.time() - damageData.ticks > ticksDuration then
			rawDamageMap[playerId] = nil
		end
	end
	
	-- use assist map if installed
	if Creature.getKillCreditsMap then
		for playerId, _ in pairs(monster:getKillCreditsMap()) do
			if not rawDamageMap[playerId] then
				rawDamageMap[playerId] = {total = 0, ticks = os.time()}
			end
		end
	end

	-- sort players by damage dealt
	local sortedDamageMap = {}
	local totalDamageReceived = 0
	for playerId, damage in pairs(rawDamageMap) do
		table.insert(sortedDamageMap,{playerId, damage})
		totalDamageReceived = totalDamageReceived + damage.total
	end
	
	table.sort(sortedDamageMap, function(dmg1, dmg2) return dmg1[2].total > dmg2[2].total end)

	if #sortedDamageMap == 0 then
		-- no damage sources
		return
	end
	
	-- create main reward bag
	local rewardId = Game.getNextRewardId()
	local mainRewardBag = corpse:addItem(ITEM_REWARD_BAG, 1, -1, bit.bor(FLAG_NOLIMIT, FLAG_IGNORENOTPICKUPABLE))
	mainRewardBag:rewardId(rewardId)
	mainRewardBag:createdAt(os.time())
	
	-- read possible items to loot
	local mType = monster:getType()
	local monsterLoot = mType:getLoot()

	-- give rewards based on input
	-- skip non-player damage sources
	local realRank = 0
	for rank, playerDamage in ipairs(sortedDamageMap) do
		local currentPlayerId = playerDamage[1]
		if currentPlayerId > PLAYER_ID_MIN and currentPlayerId < PLAYER_ID_MAX then
			realRank = realRank + 1
			
			local playerRewardBag = Game.createItem(ITEM_REWARD_BAG, 1)
			for i = 1, #monsterLoot do
				local item = playerRewardBag:createLootItem(monsterLoot[i], realRank, playerDamage[2].total / totalDamageReceived)
				if not item then
					print("[Warning] DropLoot: Could not add loot item to corpse.")
				end
			end

			-- set loot message
			local rewardBagDescription = playerRewardBag:getColorContentDescription()

			-- set reward container metadata
			playerRewardBag:rewardId(rewardId)
			playerRewardBag:createdAt(os.time())
			
			
			local player = Player(currentPlayerId)
			if player then
				-- send reward to online player
				player:getRewardChest():addItemEx(playerRewardBag, -1, bit.bor(FLAG_NOLIMIT, FLAG_IGNORENOTPICKUPABLE))
				
				-- send loot message
				player:sendTextMessage(MESSAGE_LOOT, string.format("Loot of %s:\n%s\n\n{%d|Items added to your Reward Chest.}", mType:getNameDescription(), rewardBagDescription, MESSAGE_COLOR_GREEN))
			else
				-- send to offline player
				Game.addRewardByPlayerId(currentPlayerId, playerRewardBag)
			end
		end
	end
end

-- login message
local creatureevent = CreatureEvent("RewardChestLogin")
function creatureevent.onLogin(player)
	local rewardCount = #player:getRewardChest():getItems()
	if rewardCount > 0 then
		local amountVerbal = rewardCount ~= 1 and tostring(rewardCount) or "one"
		local countVerbal = rewardCount ~= 1 and "s" or ""
		
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You have %s reward%s in the reward chest.", amountVerbal, countVerbal))
	end
	
	return true
end
creatureevent:register()
