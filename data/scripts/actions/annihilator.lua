if not AnnihilatorCache then
	AnnihilatorCache = {
	-- [leverUid] = {lastPull, lastStart}
	}
end

Annihilators = {
	-- lever uid
	[7000] = {
		storage = PlayerStorageKeys.annihilatorReward,
		enterPos = {
			-- use strict indexes to avoid potential shuffling of player positions
			[1] = Position(191, 118, 9),
			[2] = Position(192, 118, 9),
			[3] = Position(193, 118, 9),
			[4] = Position(194, 118, 9),
		},
		fightPos = {
			[1] = Position(191, 118, 10),
			[2] = Position(192, 118, 10),
			[3] = Position(193, 118, 10),
			[4] = Position(194, 118, 10),
		},
		monsters = {
			{"Demon", Position(191, 116, 10)},
			{"Demon", Position(193, 116, 10)},
			{"Demon", Position(192, 120, 10)},
			{"Demon", Position(194, 120, 10)},
			{"Demon", Position(189, 118, 10)},
			{"Demon", Position(195, 118, 10)},
			{"Demon", Position(196, 118, 10)},		
		},
		
		-- teleport players out if time is over
		timeLimit = 10 * 60,
		timeoutPos = Position(204, 117, 10)
	},
}

function clearAnnihilatorPos(uid, pos)
	local tile = Tile(pos)
	if not tile then
		return
	end
	
	for _, creature in pairs(tile:getCreatures()) do
		if creature:isPlayer() then
			creature:teleportTo(Annihilators[uid].timeoutPos)
		else
			creature:remove()
		end
	end
end

function clearAnnihilator(uid)
	if not AnnihilatorCache[uid] then
		return
	end
	
	local anni = Annihilators[uid]
	for i = 1, #anni.fightPos do
		clearAnnihilatorPos(uid, anni.fightPos[i])
	end
	
	for i = 1, #anni.monsters do
		clearAnnihilatorPos(uid, anni.monsters[i][2])
	end
	
	AnnihilatorCache[uid] = nil
end

function isAnnihilatorBlocked(uid)
	if not AnnihilatorCache[uid] then
		return false
	end
		
	local anni = Annihilators[uid]
	for i = 1, #anni.fightPos do
		local tile = Tile(anni.fightPos[i])
		for _, creature in pairs(tile:getCreatures()) do
			if creature:isPlayer() then
				return true
			end
		end
	end
	
	for i = 1, #anni.monsters do
		local tile = Tile(anni.monsters[i][2])
		for _, creature in pairs(tile:getCreatures()) do
			if creature:isPlayer() then
				return true
			end
		end
	end
	
	return false
end

function checkAnnihilator(uid)
	if not AnnihilatorCache[uid] then
		return
	end

	if not isAnnihilatorBlocked(item.uid) or os.time > AnnihilatorCache[uid][2] then
		clearAnnihilator(uid)
		return
	end

	addEvent(checkAnnihilator, 2000, uid)
end

local annihilator = Action()
function annihilator.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local anni = Annihilators[item.uid]
	if not anni then
		local info = debug.getinfo(1,'S');
		local msg = string.format("%s - unable to start annihilator with lever uid %d!", info.source, item.uid)
		Game.sendConsoleMessage(CONSOLEMESSAGE_TYPE_WARNING, msg)
		return true
	end
	
	local players = {}

	-- check if can be started
	local cache = AnnihilatorCache[item.uid]
	if cache then
		-- antispam mechanic
		if os.time() < cache[1] then
			toPosition:sendMagicEffect(CONST_ME_POFF)
			return true
		end
		AnnihilatorCache[item.uid][1] = os.time() + 2
		
		-- check player requirements
		for i = 1, #anni.enterPos do
			local tile = Tile(anni.enterPos[i])
			local creatures = tile:getCreatures()
			local creature = creatures and creatures[1]
			if not creature then
				player:say("You need four players to proceed.", TALKTYPE_MONSTER_SAY, false, nil, toPosition)
				toPosition:sendMagicEffect(CONST_ME_POFF)
				return true
			elseif not creature:isPlayer() then
				player:say("Only players can participate.", TALKTYPE_MONSTER_SAY, false, nil, toPosition)
				toPosition:sendMagicEffect(CONST_ME_POFF)
				return true
			elseif creature:getStorageValue(storage) == 1 then
				player:say(creature:getName() .. " has already completed this challenge.", TALKTYPE_MONSTER_SAY, false, nil, toPosition)
				toPosition:sendMagicEffect(CONST_ME_POFF)
				return true
			else
				players[i] = creature
			end
		end
		
		-- active anni going on
		if os.time < AnnihilatorCache[item.uid][2] and isAnnihilatorBlocked(item.uid) then
			player:say("The annihilator room is currently in use. Please try again later.", TALKTYPE_MONSTER_SAY, false, nil, toPosition)
			toPosition:sendMagicEffect(CONST_ME_POFF)
			return true
		end
		
		clearAnnihilator(item.uid)
	end

	-- start quest
	local now = os.time()
	AnnihilatorCache[item.uid] = {now + 2, now + anni.timeLimit}

	toPosition:sendMagicEffect(CONST_ME_ENERGYAREA)
	for i = 1, #anni.enterPos do
		anni.enterPos[i]:sendMagicEffect(CONST_ME_POFF)
		players[i]:teleportTo(anni.fightPos[i])
		anni.fightPos[i]:sendMagicEffect(CONST_ME_ENERGYAREA)
	end

	for i = 1, #anni.monsters do
		Game.createMonster(anni.monsters[i][1], anni.monsters[i][2])
	end
	
	-- check if done
	addEvent(checkAnnihilator, 2000, item.uid)	
	return true
end

for uid, _ in pairs(Annihilators) do
	annihilator:uid(uid)
end
annihilator:register()
