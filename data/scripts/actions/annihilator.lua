if not AnnihilatorCache then
	AnnihilatorCache = {
	-- [leverUid] = {lastPull, lastStart}
	}
end

Annihilators = {
	-- lever uid
	[1013] = {
		storage = PlayerStorageKeys.annihilatorReward,
		enterPos = {
			-- use strict indexes to avoid potential shuffling of player positions
			[1] = Position(1118, 919, 9),
			[2] = Position(1119, 919, 9),
			[3] = Position(1120, 919, 9),
			[4] = Position(1121, 919, 9),
		},
		fightPos = {
			[1] = Position(1122, 918, 10),
			[2] = Position(1123, 918, 10),
			[3] = Position(1124, 918, 10),
			[4] = Position(1125, 918, 10),
		},
		monsters = {
			{"Demon", Position(1122, 916, 10)},
			{"Demon", Position(1124, 916, 10)},
			{"Demon", Position(1123, 920, 10)},
			{"Demon", Position(1125, 920, 10)},
			{"Demon", Position(1126, 918, 10)},
			{"Demon", Position(1127, 918, 10)},
		},
		
		-- teleport players out if time is over
		timeLimit = 10 * 60,
		timeoutPos = Position(1130, 918, 10)
	},
}

local soundLeverMove = 2800
local soundLeverBlocked = 2065
local soundTeleport = 1180
local soundTeleport2 = 1083
local soundTimeout = 2772

function clearAnnihilatorPos(uid, pos)
	local tile = Tile(pos)
	if not tile then
		return
	end
	
	Annihilators[uid].timeoutPos:playSound(soundTimeout, 1)
	
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
				player:playSound(soundLeverBlocked, 1)
				return true
			elseif not creature:isPlayer() then
				player:say("Only players can participate.", TALKTYPE_MONSTER_SAY, false, nil, toPosition)
				toPosition:sendMagicEffect(CONST_ME_POFF)
				player:playSound(soundLeverBlocked, 1)
				return true
			elseif creature:getStorageValue(storage) == 1 then
				player:say(creature:getName() .. " has already completed this challenge.", TALKTYPE_MONSTER_SAY, false, nil, toPosition)
				toPosition:sendMagicEffect(CONST_ME_POFF)
				player:playSound(soundLeverBlocked, 1)
				return true
			else
				players[i] = creature
			end
		end
		
		-- active anni going on
		if os.time < AnnihilatorCache[item.uid][2] and isAnnihilatorBlocked(item.uid) then
			player:say("The annihilator room is currently in use. Please try again later.", TALKTYPE_MONSTER_SAY, false, nil, toPosition)
			toPosition:sendMagicEffect(CONST_ME_POFF)
			player:playSound(soundLeverBlocked, 1)
			return true
		end
		
		clearAnnihilator(item.uid)
	end

	-- start quest
	local now = os.time()
	AnnihilatorCache[item.uid] = {now + 2, now + anni.timeLimit}

	toPosition:sendMagicEffect(CONST_ME_ENERGYAREA)
	toPosition:playSound(soundLeverMove, 1)
	toPosition:playSound(soundTeleport, 1)
	for i = 1, #anni.enterPos do
		anni.enterPos[i]:sendMagicEffect(CONST_ME_POFF)
		players[i]:teleportTo(anni.fightPos[i])
		anni.fightPos[i]:sendMagicEffect(CONST_ME_ENERGYAREA)
	end
	anni.fightPos[1]:playSound(soundTeleport2, 1)
	
	for i = 1, #anni.monsters do
		Game.createMonster(anni.monsters[i][1], anni.monsters[i][2])
	end
	
	-- check if done
	addEvent(checkAnnihilator, 2000, item.uid)	
	return true
end

local anniCount = 0
for uid, _ in pairs(Annihilators) do
	annihilator:uid(uid)
	anniCount = anniCount + 1
end

if anniCount > 0 then
	annihilator:register()
end
