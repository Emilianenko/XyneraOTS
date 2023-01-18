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
			[1] = {x = 1118, y = 919, z = 9},
			[2] = {x = 1119, y = 919, z = 9},
			[3] = {x = 1120, y = 919, z = 9},
			[4] = {x = 1121, y = 919, z = 9},
		},
		fightPos = {
			[1] = {x = 1122, y = 918, z = 10},
			[2] = {x = 1123, y = 918, z = 10},
			[3] = {x = 1124, y = 918, z = 10},
			[4] = {x = 1125, y = 918, z = 10},
		},
		monsters = {
			{"Demon", {x = 1122, y = 916, z = 10}},
			{"Demon", {x = 1124, y = 916, z = 10}},
			{"Demon", {x = 1123, y = 920, z = 10}},
			{"Demon", {x = 1125, y = 920, z = 10}},
			{"Demon", {x = 1126, y = 918, z = 10}},
			{"Demon", {x = 1127, y = 918, z = 10}},
		},
		
		-- teleport players out if time is over
		timeLimit = 10 * 60,
		timeoutPos = {x = 1130, y = 918, z = 10}
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
	end
	
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
	if AnnihilatorCache[item.uid] then
		if os.time < AnnihilatorCache[item.uid][2] and isAnnihilatorBlocked(item.uid) then
			player:say("The annihilator room is currently in use. Please try again later.", TALKTYPE_MONSTER_SAY, false, nil, toPosition)
			toPosition:sendMagicEffect(CONST_ME_POFF)
			player:playSound(soundLeverBlocked, 1)
			return true
		end
	end
	
	clearAnnihilator(item.uid)

	-- start quest
	local now = os.time()
	AnnihilatorCache[item.uid] = {now + 2, now + anni.timeLimit}

	toPosition:sendMagicEffect(CONST_ME_ENERGYAREA)
	toPosition:playSound(soundLeverMove, 1)
	toPosition:playSound(soundTeleport, 1)
	for i = 1, #anni.enterPos do
		-- remove player summons
		local summs = players[i]:getSummons()
		if summs then
			for _, summon in pairs(summs) do
				summon:remove()
			end
		end
	
		-- teleport to annihilator
		Position(anni.enterPos[i]):sendMagicEffect(CONST_ME_POFF)
		players[i]:teleportTo(anni.fightPos[i])
		Position(anni.fightPos[i]):sendMagicEffect(CONST_ME_ENERGYAREA)
	end
	Position(anni.fightPos[1]):playSound(soundTeleport2, 1)
	
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

local mountFixer = MoveEvent()
mountFixer:type("stepin")

function mountFixer.onStepIn(player, item, position, fromPosition)
	if player and player:isPlayer() then
		if player:getStorageValue(PlayerStorageKeys.annihilatorReward) == 1 and player:getStorageValue(1012) == -1 then
			player:sendColorMessage("Dragon lord hatchling mount was added to your character.", MESSAGE_COLOR_PURPLE)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
			player:addMount(Game.getMountIdByLookType(272))
			player:setStorageValue(1012, 1)
		end
	end
	
	return true
end

mountFixer:aid(5001)
mountFixer:register()
