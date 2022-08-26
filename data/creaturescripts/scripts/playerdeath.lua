local deathListEnabled = true
local maxDeathRecords = 5

function onDeath(player, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
	local playerId = player:getId()
	if nextUseStaminaTime[playerId] then
		nextUseStaminaTime[playerId] = nil
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are dead.")
	
	---- DETERMINE REAL OWNER OF THE LAST HIT
	local byPlayer = 0
	local killerName
	local killerIsPlayer = false
	if killer then
		if killer:isPlayer() then
			killerIsPlayer = true
			byPlayer = 1
		else
			local master = killer:getMaster()
			if master and master ~= killer and master:isPlayer() then
				killerIsPlayer = true
				killer = master
				byPlayer = 1
			end
		end
		killerName = killer:getName()
	else
		killerName = "field item"
	end

	---- DETERMINE MOST DAMAGE DEALT
	local byPlayerMostDamage = 0
	local mostDamageKillerName
	if mostDamageKiller then
		if mostDamageKiller:isPlayer() then
			byPlayerMostDamage = 1
		else
			local master = mostDamageKiller:getMaster()
			if master and master ~= mostDamageKiller and master:isPlayer() then
				mostDamageKiller = master
				byPlayerMostDamage = 1
			end
		end
		mostDamageName = mostDamageKiller:getName()
	else
		mostDamageName = "field item"
	end
	
	---- DETERMINE THE KILLERS
	local messageKillerName = killer and killer:isMonster() and killer:getType():nameDescription() or killerName
	local messageMostDamageName = mostDamageKiller and mostDamageKiller:isMonster() and mostDamageKiller:getType():nameDescription() or mostDamageName
	
	if killerName == mostDamageName then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You were killed by %s.", messageKillerName))
	else
		if killer and mostDamageKiller then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You were killed by %s and %s.", messageKillerName, messageMostDamageName))
		elseif killer then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You were killed by %s.", messageKillerName))
		elseif mostDamageKiller then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You were killed by %s.", messageMostDamageName))
		end
	end
	
	---- BLESSINGS CHECK (consuption happens in sources)
	local blessCount = 0
	for i = BLESSING_FIRST, BLESSING_LAST do
		if i ~= BLESSING_TWIST and player:hasBlessing(i) then
			blessCount = blessCount + 1
		end
	end
	
	if player:hasBlessing(BLESSING_TWIST) then
		if killerIsPlayer then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You blessings were protected by Twist of Fate which was consumed in the process.")
		else
			if blessCount > 0 then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have lost your blessings.")
			else
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You did not have any blessings.")
			end
		end
	else
		if blessCount > 0 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have lost your blessings.")
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You did not have any blessings.")
		end
	end
		
	---- PLAYER DROP EQ
	if player:hasFlag(PlayerFlag_NotGenerateLoot) or player:getVocation():getId() == VOCATION_NONE then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You did not lose any equipment.")
	else
		local amulet = player:getSlotItem(CONST_SLOT_NECKLACE)
		local isRedOrBlack = table.contains({SKULL_RED, SKULL_BLACK}, player:getSkull())
		if amulet and amulet.itemid == ITEM_AMULETOFLOSS and not isRedOrBlack then
			local isPlayer = false
			if killer then
				if killer:isPlayer() then
					isPlayer = true
				else
					local master = killer:getMaster()
					if master and master:isPlayer() then
						isPlayer = true
					end
				end
			end

			if not isPlayer or not player:hasBlessing(6) then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You were protected by an amulet of loss.")
				player:removeItem(ITEM_AMULETOFLOSS, 1, -1, false)
			end
		else
			if isRedOrBlack then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your amulet of loss did not work due to excessive amount of unjustified kills.")
			elseif not amulet then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You did not wear an amulet of loss.")			
			end

			local itemsLost = 0
			for i = CONST_SLOT_HEAD, CONST_SLOT_AMMO do
				local item = player:getSlotItem(i)
				local lossPercent = player:getLossPercent()
				if item then
					if isRedOrBlack or math.random(item:isContainer() and 100 or 1000) <= lossPercent then
						if (isRedOrBlack or lossPercent ~= 0) and not item:moveTo(corpse) then
							itemsLost = itemsLost + 1
							item:remove()
						end
					end
				end
			end
			
			if itemsLost > 0 then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You dropped %d items.", itemsLost))	
			end
		end

		if not player:getSlotItem(CONST_SLOT_BACKPACK) then
			player:addItem(ITEM_BAG, 1, false, CONST_SLOT_BACKPACK)
		end
	end

	---- TAKE SCREENSHOT
	player:takeScreenshot(killerIsPlayer and SCREENSHOT_TYPE_DEATHPVP or SCREENSHOT_TYPE_DEATHPVE)
	if killerIsPlayer then
		killer:takeScreenshot(SCREENSHOT_TYPE_PLAYERKILL)
	end
	if mostDamageKiller and mostDamageKiller:isPlayer() then
		if not killer or killer ~= mostDamageKiller then
			mostDamageKiller:takeScreenshot(SCREENSHOT_TYPE_PLAYERKILL)
		end
	end

	---- ADD DEATH LIST ENTRY
	if not deathListEnabled then
		return
	end

	local playerGuid = player:getGuid()
	db.query("INSERT INTO `player_deaths` (`player_id`, `time`, `level`, `killed_by`, `is_player`, `mostdamage_by`, `mostdamage_is_player`, `unjustified`, `mostdamage_unjustified`) VALUES (" .. playerGuid .. ", " .. os.time() .. ", " .. player:getLevel() .. ", " .. db.escapeString(killerName) .. ", " .. byPlayer .. ", " .. db.escapeString(mostDamageName) .. ", " .. byPlayerMostDamage .. ", " .. (lastHitUnjustified and 1 or 0) .. ", " .. (mostDamageUnjustified and 1 or 0) .. ")")
	local resultId = db.storeQuery("SELECT `player_id` FROM `player_deaths` WHERE `player_id` = " .. playerGuid)

	local deathRecords = 0
	local tmpResultId = resultId
	while tmpResultId ~= false do
		tmpResultId = result.next(resultId)
		deathRecords = deathRecords + 1
	end

	if resultId ~= false then
		result.free(resultId)
	end

	local limit = deathRecords - maxDeathRecords
	if limit > 0 then
		db.asyncQuery("DELETE FROM `player_deaths` WHERE `player_id` = " .. playerGuid .. " ORDER BY `time` LIMIT " .. limit)
	end

	if byPlayer == 1 then
		local targetGuild = player:getGuild()
		targetGuild = targetGuild and targetGuild:getId() or 0
		if targetGuild ~= 0 then
			local killerGuild = killer:getGuild()
			killerGuild = killerGuild and killerGuild:getId() or 0
			if killerGuild ~= 0 and targetGuild ~= killerGuild and isInWar(playerId, killer:getId()) then
				local warId = false
				resultId = db.storeQuery("SELECT `id` FROM `guild_wars` WHERE `status` = 1 AND ((`guild1` = " .. killerGuild .. " AND `guild2` = " .. targetGuild .. ") OR (`guild1` = " .. targetGuild .. " AND `guild2` = " .. killerGuild .. "))")
				if resultId ~= false then
					warId = result.getNumber(resultId, "id")
					result.free(resultId)
				end

				if warId ~= false then
					db.asyncQuery("INSERT INTO `guildwar_kills` (`killer`, `target`, `killerguild`, `targetguild`, `time`, `warid`) VALUES (" .. db.escapeString(killerName) .. ", " .. db.escapeString(player:getName()) .. ", " .. killerGuild .. ", " .. targetGuild .. ", " .. os.time() .. ", " .. warId .. ")")
				end
			end
		end
	end
end
