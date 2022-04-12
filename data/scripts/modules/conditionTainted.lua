---- CONSTANTS
CONDITION_SUBID_TAINTED = 610
TAINTED_CHECK_INTERVAL = 10 -- in seconds

TAINT_STORAGE = PlayerStorageKeys.taints

TAINT_INFERNO = 1
TAINT_EBBFLOW = 2
TAINT_CRATER = 3
TAINT_MIRROR = 4
TAINT_ROTTEN = 5

TAINT_FIRST = TAINT_INFERNO
TAINT_LAST = TAINT_ROTTEN

---- FUNCTIONS

-- note: taint effect descriptions are hardcoded in client
TaintLevels = {
	-- nearby creature teleports to you periodically
	[1] = {
		icon = ICON_GOSHNAR1,
		interval = TAINTED_CHECK_INTERVAL,

		-- chance (10% = 1000), range, max floor diff
		args = {1000, 10, 1}
	},
	
	-- new creature spawns on-hit
	[2] = {
		icon = ICON_GOSHNAR2,

		-- chance, effect cooldown
		args = {50, TAINTED_CHECK_INTERVAL * 3}
	},
	
	-- increased incoming damage
	[3] = {
		icon = ICON_GOSHNAR3,
		
		-- percent increase
		args = {15}
	},
	
	-- creature will heal back to full instead of dying
	[4] = {
		icon = ICON_GOSHNAR4,

		-- chance, effect cooldown
		args = {100, 0}
	},
	
	-- lose vital points percent every cycle (10% = 1000)
	[5] = {
		icon = ICON_GOSHNAR5,
		interval = TAINTED_CHECK_INTERVAL,
		
		-- partial hp loss, partial mana loss
		args = {1000, 1000}
	}
}

TaintGivers = {
	["brachiodemon"] = TAINT_INFERNO,
	["bony sea devil"] = TAINT_EBBFLOW,
	["cloak of terror"] = TAINT_CRATER,
	["many faces"] = TAINT_MIRROR,
	["branchy crawler"] = TAINT_ROTTEN
}

-- returns the amount of active player taints
function Player:getTaintCount()
	local taintCount = 0
	local taints = math.max(0, self:getStorageValue(TAINT_STORAGE))
	
	for taintId = TAINT_FIRST, TAINT_LAST do
		if bit.band(taints, 2^(taintId - 1)) ~= 0 then
			taintCount = taintCount + 1
		end
	end
		
	return taintCount
end

-- updates taints info in client ui
function Player:refreshTaints()
	local taintCount = self:getTaintCount()
	self:removeCondition(CONDITION_ATTRIBUTES, CONDITIONID_COMBAT, CONDITION_SUBID_TAINTED)
	
	if taintCount == 0 then
		return
	end
	
	local condition = Condition(CONDITION_ATTRIBUTES)
	condition:setParameter(CONDITION_PARAM_SUBID, CONDITION_SUBID_TAINTED)
	condition:setParameter(CONDITION_PARAM_TICKS, -1)
	condition:setParameter(CONDITION_PARAM_ICONS, TaintLevels[taintCount].icon)
	self:addCondition(condition)
end

-- enables location specific taint
-- example: player:setTaintStatus(TAINT_CRATER, true)
function Player:setTaintStatus(taintId, isEnabled)
	if taintId < TAINT_FIRST or taintId > TAINT_LAST then
		return false
	end
	
	local taints = math.max(0, self:getStorageValue(TAINT_STORAGE))
	local flag = 2^(taintId - 1)
	self:setStorageValue(TAINT_STORAGE, isEnabled and bit.addFlag(taints, flag) or bit.removeFlag(taints, flag))
	self:refreshTaints()
	return true
end

-- removes all taints from the player
function Player:clearTaints()
	self:setStorageValue(TAINT_STORAGE, -1)
	self:removeCondition(CONDITION_ATTRIBUTES, CONDITIONID_COMBAT, CONDITION_SUBID_TAINTED)
end


---- HELPER FUNCTIONS (for internal use)
local function pickNearbyMonster(pos, args)
	local range = args[2]
	local potentialMonsters = {}
	for z = math.max(0, pos.z - args[3]), math.min(15, pos.z + args[3]) do
		if (z > 7 and pos.z > 7) or (z < 8 and pos.z < 8) then
			local spect = Game.getSpectators(Position(pos.x, pos.y, z), false, false, range, range, range, range)
			for _, creature in pairs(spect) do
				if creature:isMonster() then
					potentialMonsters[#potentialMonsters + 1] = creature
				end
			end
		end
	end
	
	if #potentialMonsters == 0 then
		return
	end
	
	return potentialMonsters[math.random(#potentialMonsters)]
end

function checkTaints(cid)
	local player = Player(cid)
	if player then
		player:refreshTaints()
	end
end

---- SCRIPTS FOR TAINT EFFECTS

-- taint 1 and taint 5
-- teleport creature, lose percent vital points
do
	local creatureevent = CreatureEvent("onThinkTaint")
	function creatureevent.onThink(player, interval)
		local taintCount = player:getTaintCount()
		
		if taintCount > 0 then
			local timer = os.time()
			
			if player:getZone() ~= ZONE_PROTECTION then
				-- execute taint 1
				if timer % TaintLevels[1].interval == 0 then
					local args = TaintLevels[1].args

					-- roll for effect
					if math.random(10000) <= args[1] then
						-- apply effect
						local pos = self:getClosestFreePosition(player:getPosition())
						if pos.x ~= 0 then
							local monster = pickNearbyMonster(pos, args)
							if monster and monster:getType():isHostile() then
								monster:teleportTo(pos)
								monster:getPosition():sendMagicEffect(CONST_ME_STONES)
							end
						end
					end
				end
			
				-- execute taint 5
				if taintCount > 4 and timer % TaintLevels[5].interval == 0 then
					local args = TaintLevels[5].args
					player:addHealth(-player:getMaxHealth() * args[1] / 10000)
					player:addMana(-player:getMaxMana() * args[2] / 10000)
				end
			end
		end
	end
	creatureevent:register()
end

-- taint 2 and taint 4
-- spawn new creature on hit, heal monster back to full hp
do
	-- taint 2
	local timerTaint2 = PlayerStorageKeys.taintB_cooldown
	local onHit = CreatureEvent("onHitTaint")
	function onHit.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
		if attacker and attacker:isPlayer() and creature:isMonster() and not creature:isSummon() then
			if not creature:getType():isHostile() then
				return primaryDamage, primaryType, secondaryDamage, secondaryType
			end
			
			local taintCount = attacker:getTaintCount()
			if taintCount > 1 then
				local args = TaintLevels[2].args
			
				-- roll for taint 2
				if math.random(10000) < args[1] then
					if os.time() > attacker:getStorageValue(timerTaint2) then
						attacker:setStorageValue(timerTaint2, os.time() + args[2])
						Game.createMonster(creature:getName(), creature:getPosition())
					end
				end
			end
		end
		
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end
	onHit:register()
	
	-- taint 4
	local timerTaint4 = PlayerStorageKeys.taintD_cooldown
	local resurrect = CreatureEvent("resurrectTaint")
	function resurrect.onPrepareDeath(creature, killer)
		-- do not trigger on passive monsters
		if not creature:getType():isHostile() then
			return true
		end
			
		-- who pulls the strings
		if not killer then
			-- traps, fields, conditions with no owner
			return true
		end
		
		local player
		if killer:isPlayer() then
			player = killer
		elseif killer:isSummon() then
			local master = killer:getMaster()
			if master and master:isPlayer() then
				player = master
			end
		end
		
		if not player then
			return true
		end
		
		local taintCount = player:getTaintCount()
		if taintCount > 3 then
			local args = TaintLevels[4].args
		
			-- roll for taint 4
			if math.random(10000) < args[1] then
				if os.time() > player:getStorageValue(timerTaint4) then
					player:setStorageValue(timerTaint4, os.time() + args[2])
					creature:addHealth(creature:getMaxHealth())
					creature:getPosition():sendMagicEffect(CONST_ME_BATS)
					return false
				end
			end
		end
		
		return true
	end
	resurrect:register()
	
	-- add effects to monsters
	local ec = EventCallback
	ec.onSpawn = function(self, position, startup, artificial)
		self:registerEvent("onHitTaint")
		self:registerEvent("resurrectTaint")
		return true
	end
	ec:register()
end

-- taint 3 and applying taints on-hit
-- increased incoming damage
do
	local creatureevent = CreatureEvent("damageTaint")
	function creatureevent.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
		-- apply taint on-hit
		if attacker and attacker:isMonster() then
			local taintId = TaintGivers[attacker:getName():lower()]
			if taintId then
				creature:setTaintStatus(taintId, true)
			end
		end
		
		-- activate taint 3
		local taintCount = creature:getTaintCount()
		if taintCount > 2 then
			local args = TaintLevels[3].args
			local dmgMod = args[1]
			if dmgMod then
				primaryDamage = primaryDamage * dmgMod / 100
				secondaryDamage = secondaryDamage * dmgMod / 100
			end
		end
		
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end
	creatureevent:register()
end

-- reset taints on death
do
	local creatureevent = CreatureEvent("deathTaint")
	function creatureevent.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
		-- reset taints (condition will be cleared automatically)
		creature:setStorageValue(TAINT_STORAGE, -1)
		return true
	end
	creatureevent:register()
end

-- initialize on login
local creatureevent = CreatureEvent("taintsLogin")
function creatureevent.onLogin(player)
	player:registerEvent("onThinkTaint")
	player:registerEvent("damageTaint")
	player:registerEvent("deathTaint")
	
	-- let condition check happen once player is fully loaded
	addEvent(checkTaints, 100, player:getId())
	return true
end
creatureevent:register()

