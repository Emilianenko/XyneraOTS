-- hints:
-- 1:
-- do not set destination to exit teleport in the mapeditor
-- set uniqueid and use this config instead
-- this will prevent players from dying or killers from getting frags

-- 2:
-- set pvp zone + no-logout inside the pvp arena and pz around it
-- for best pvp arena experience

PVPArenas = {
--[[
	-- yur
	[7001] = {
		-- area in which players do not die
		fromPos = Position(121, 33, 9),
		toPos = Position(128, 37, 9),
		
		-- uid and destination of exit teleporter
		exitPos = Position(125, 31, 9),
		exitUID = 7011,
		
		-- minimal requirement
		minFighters = 2,
		
		-- tiles to stand and where they tp
		entrances = {
			--{tile, destination},
			{Position(119, 35, 9), Position(122, 35, 9)},
			{Position(130, 35, 9), Position(127, 35, 9)},
		},
		
		-- if the fight is not concluded, the players can be kicked out by waiting candidates
		timeLimit = 15 * 60,
		
		-- (cache) timestamp of last fight
		lastBattle = 0,
		
		-- (cache) timestamp of last attempt to start
		lastLeverPull = 0,
	},
	
	-- evo
	[7002] = {
		fromPos = Position(1041, 985, 9),
		toPos = Position(1052, 991, 9),
		exitPos = Position(1038, 988, 8),
		exitUID = 7012,

		minFighters = 2,
		entrances = {
			{Position(1040, 987, 8), Position(1043, 988, 9)},
			{Position(1040, 989, 8), Position(1049, 988, 9)},
		},
		
		timeLimit = 15 * 60,	
		lastBattle = 0,
		lastLeverPull = 0,
	}
	]]
}

-- leave arena either through tp or death
function Player:leavePVPArena(playerPos, exitPos)
	-- prevent potential frag counting
	self:resetDamageMap()
	
	-- addHealth needs to be executed before teleporting
	-- to avoid condition finishing the player
	self:addHealth(self:getMaxHealth())
	self:teleportTo(exitPos)
end

-- prevent death consequences in pvp arena
do
	local arenaDeath = CreatureEvent("pvpArenaDeath")
	function arenaDeath.onPrepareDeath(player, killer)
		local playerPos = player:getPosition()
		for _, arenaData in pairs(PVPArenas) do
			if playerPos:isInRange(arenaData.fromPos, arenaData.toPos) then
				-- execution effect
				playerPos:sendMagicEffect(CONST_ME_FIREAREA)
				
				-- leave arena
				player:leavePVPArena(playerPos, arenaData.exitPos)
				
				-- exit effect
				arenaData.exitPos:sendMagicEffect(CONST_ME_TELEPORT)
	
				return false
			end
		end
		
		return true
	end
	arenaDeath:register()

	local arenaLogin = CreatureEvent("pvpArenaLogin")
	function arenaLogin.onLogin(player)
		player:registerEvent("pvpArenaDeath")
		return true
	end
	arenaLogin:register()
end

-- prevent death consequences in early leave situation
local arenaExit = MoveEvent()
arenaExit:type("stepin")
function arenaExit.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		creature:remove()
		return true
	end
	
	for _, arenaData in pairs(PVPArenas) do
		if arenaData.exitUID == item.uid then
			-- leave effect
			item:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			
			-- leave arena
			creature:leavePVPArena(playerPos, arenaData.exitPos)
			
			-- exit effect
			arenaData.exitPos:sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end
	end
	
	return true
end
for _, arenaData in pairs(PVPArenas) do
	arenaExit:uid(arenaData.exitUID)
end
arenaExit:register()

-- NOTE: this function scales poorly.
-- Consider splitting it to events + sectors or redesigning if you want to make big arenas
function isPVPArenaBlocked(uid)
	local arenaData = PVPArenas[uid]
	if not arenaData then
		return true
	end
	
	-- previous fight is in arena long enough to be over
	if os.time() > arenaData.lastBattle then
		return false
	end
	
	-- loop through arena tiles to find remaining players
	local fromPos = arenaData.fromPos
	local toPos = arenaData.toPos
	
	local playerCount = 0
	for z = fromPos.z, toPos.z do
	for y = fromPos.y, toPos.y do
	for x = fromPos.x, toPos.x do
		local pos = Position(x, y, z)
		local tile = Tile(pos)
		if tile then
			local creatures = tile:getCreatures()
			for _, creature in pairs(creatures) do
				if creature:isPlayer() then
					playerCount = playerCount + 1
					if playerCount > 1 then
						return true
					end
				end
			end
		end
	end
	end
	end
	
	return false
end

-- NOTE: this function scales poorly.
-- Consider splitting it to events + sectors or redesigning if you want to make big arenas
function clearPVPArena(uid)
	local arenaData = PVPArenas[uid]
	if not arenaData then
		return false
	end
	
	-- loop through arena tiles to find remaining players
	local fromPos = arenaData.fromPos
	local toPos = arenaData.toPos
	
	local sendExit = false
	for z = fromPos.z, toPos.z do
	for y = fromPos.y, toPos.y do
	for x = fromPos.x, toPos.x do		
		local pos = Position(x, y, z)
		local tile = Tile(pos)
		if tile then
			local sendTile = false
				
			local creatures = tile:getCreatures() or {}
			for _, creature in pairs(creatures) do
				if creature:isPlayer() then
					creature:leavePVPArena(pos, arenaData.exitPos)
					sendTile = true
					sendExit = true
				else
					creature:remove()
				end
			end
			
			local sendRemove = false
			local tileItems = tile:getItems() or {}
			for _, item in pairs(tileItems) do
				if not item:isLoadedFromMap() then
					local itemType = item:getType()
					if itemType:isMagicField() then
						item:remove()
						sendRemove = true
					end
				end
			end
			
			if sendRemove then
				pos:sendMagicEffect(CONST_ME_POFF)
			end
			
			if sendTile then
				pos:sendMagicEffect(CONST_ME_TELEPORT)
			end
		end
	end
	end
	end
	
	if sendExit then
		arenaData.exitPos:sendMagicEffect(CONST_ME_TELEPORT)
	end
	
	return false
end

-- arena lever
local arenaLever = Action()
function arenaLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	-- read arena config
	local arenaData = PVPArenas[item.uid]
	if not arenaData then
		local info = debug.getinfo(1,'S');
		local msg = string.format("%s - unable to start pvp arena battle with lever uid %d!", info.source, item.uid)
		Game.sendConsoleMessage(CONSOLEMESSAGE_TYPE_WARNING, msg)
		return true
	end
	
	local now = os.time()
	-- antispam mechanic
	if now < arenaData.lastLeverPull then
		toPosition:sendMagicEffect(CONST_ME_POFF)
		return true
	end
	PVPArenas[item.uid].lastLeverPull = now + 2
	
	-- check requirements
	local players = {}
	for index, entrance in pairs(arenaData.entrances) do
		local tile = Tile(entrance[1])
		local creatures = tile:getCreatures()
		local creature = creatures and creatures[1]
		if creature then
			if creature:isPlayer() then
				players[index] = creature
			else
				creature:remove()
			end
		end
	end
	
	if #players < arenaData.minFighters then
		player:say(string.format("You need %d players to start.", arenaData.minFighters), TALKTYPE_MONSTER_SAY, false, nil, toPosition)
		toPosition:sendMagicEffect(CONST_ME_POFF)
		return true
	end
	
	if isPVPArenaBlocked(item.uid) then
		local minLeft = math.ceil((arenaData.lastBattle - now)/60)
		local minS = minLeft == 1 and "" or "s"
		
		player:say(string.format("The arena is still in use. It will be available in %d minute%s.", minLeft, minS), TALKTYPE_MONSTER_SAY, false, nil, toPosition)
		toPosition:sendMagicEffect(CONST_ME_POFF)
		return true
	end
	
	-- clean after last fight
	if arenaData.lastBattle ~= 0 then
		clearPVPArena(item.uid)
	end
	
	-- teleport players to the arena
	for index, fighter in pairs(players) do
		local entrance = arenaData.entrances[index]
		entrance[1]:sendMagicEffect(CONST_ME_POFF)
		fighter:teleportTo(entrance[2])
		entrance[2]:sendMagicEffect(CONST_ME_TELEPORT)
		fighter:sendTextMessage(MESSAGE_STATUS_WARNING, "Fight!")
	end
	
	PVPArenas[item.uid].lastBattle = now + arenaData.timeLimit
	return true
end

local arenaCount = 0
for uid, _ in pairs(PVPArenas) do
	arenaLever:uid(uid)
	arenaCount = arenaCount + 1
end

if arenaCount > 0 then
	arenaLever:register()
end