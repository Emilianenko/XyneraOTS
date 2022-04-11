-- global index of fiendish creatures
if not FiendishMonsters then
	FiendishMonsters = {}
end

NoDustAreas = {
	-- example: TFS rook
	-- { from = Position(60, 30, 0), to = Position(135, 150, 15) },

	-- example area 2
	-- { from = Position(100, 100, 5}, to = Position(150, 150, 7) },
}

-- general
local levelMod = 0.03 -- +3% hp/dmg per level

-- influenced monster specific
local spawnChance = 100 -- 100 = 1%
local levelMin = 1
local levelMax = 5

-- fiendish monster specific
local fiendishLimit = 3
local fiendishDuration = 1 * 60 * 60 -- 1 hour (seconds)
local fiendCheckInterval = 5 * 60 * 1000 -- 5 min (milliseconds)
local levelFiendish = 15
local sliversMin = 5
local sliversMax = 5

function Monster:isFiendish()
	return self:hasMonsterIcon(MONSTER_ICON_FIENDISH)
end

function Monster:getFiendishLevel()
	return self:isFiendish() and math.max(1, self:getMonsterIconValue(MONSTER_ICON_FIENDISH)) or 0
end

function Monster:getInfluenceLevel()
	return self:getMonsterIconValue(MONSTER_ICON_INFLUENCED) + levelFiendish * self:getFiendishLevel()
end

-- update monster hp
function Monster:updateInfluencedHP()
	local mType = self:getType()
	if not mType then
		return false
	end
	
	local maxHP = mType:maxHealth()
	self:setMaxHealth(maxHP + maxHP * levelMod * self:getInfluenceLevel())
	self:addHealth(self:getMaxHealth())
	return true
end

-- set monster level
function Monster:setInfluenceLevel(level)
	if level > -1 then
		self:setMonsterIconValue(MONSTER_ICON_INFLUENCED, level)
	else
		self:removeMonsterIcon(MONSTER_ICON_INFLUENCED)
	end
	self:updateInfluencedHP()
end

-- enable/disable fiendish status
function Monster:setFiendish(isFiendish)
	if isFiendish then
		self:setMonsterIconValue(MONSTER_ICON_FIENDISH, 0)
	else
		self:removeMonsterIcon(MONSTER_ICON_FIENDISH)
	end
	self:updateInfluencedHP()
end

-- set more severe fiendish level (-1 to disable)
function Monster:setFiendishLevel(level)
	if level > -1 then
		self:setMonsterIconValue(MONSTER_ICON_FIENDISH, level)
	else
		self:removeMonsterIcon(MONSTER_ICON_FIENDISH)
	end
	self:updateInfluencedHP()
end

-- roll monster level
function rollInfluence(monsterId)
	local monster = Monster(monsterId)
	if monster and not monster:isRemoved() then
		if monster:canSpawnInfluenced() and math.random(10000) < spawnChance then
			monster:setInfluenceLevel(math.random(levelMin, levelMax))
		end
	end
end

-- spawn influenced monster
do
	local ec = EventCallback
	ec.onSpawn = function(self, position, startup, artificial)
		self:registerEvent("influencedDeath")
		
		-- delay the roll to make sure creature is not a summon
		addEvent(rollInfluence, 100, self:getId())
		return true
	end
	ec:register()
end

-- make levelled monster drop rewards
do
	-- drop slivers from fiendish monsters
	local ec = EventCallback
	ec.onDropLoot = function(self, corpse)
		local monsterLevel = self:getInfluenceLevel()
		if monsterLevel > 0 then
			if self:isFiendish() then
				corpse:addItem(ITEM_FORGE_SLIVERS, math.random(sliversMin, sliversMax) * self:getFiendishLevel())
			end
		end			
	end
	ec:register()
	
	-- add dust to all kill participants
	local creatureevent = CreatureEvent("influencedDeath")
	function creatureevent.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
		-- unregister
		FiendishMonsters[creature:getId()] = nil
		
		local monsterLevel = creature:getInfluenceLevel()
		if monsterLevel > 0 then
			local compensation = false
			if not (corpse and corpse:isContainer()) then
				monsterLevel = monsterLevel + math.random(sliversMin, sliversMax) * self:getFiendishLevel() * getForgeData().sliversDustCost
				compensation = true
			end
			
			for attackerId, _ in pairs(creature:getKillCreditsMap()) do
				local attacker = Player(attackerId)
				if attacker then
					local dustAdded = attacker:addForgeDust(monsterLevel, compensation)
					if dustAdded > 0 then
						if not compensation then
							attacker:say(string.format("+%d dust!", dustAdded))
						else
							attacker:say(string.format("+%d dust (slivers compensation)!", dustAdded))
						end
					else
						attacker:sendTextMessage(MESSAGE_EVENT_DEFAULT, "Your dust collection is full.")
					end
				end
			end
			
		end

		return true
	end
	creatureevent:register()
end

-- make levelled monster deal more damage
do
	local creatureevent = CreatureEvent("influencedMonsterDamage")
	function creatureevent.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
		if attacker and attacker:isMonster() then						
			local monsterLevel = attacker:getInfluenceLevel()
			if monsterLevel > 0 then
				primaryDamage = primaryDamage * (1 + levelMod * monsterLevel)
				secondaryDamage = secondaryDamage * (1 + levelMod * monsterLevel)
			end
		end
		
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end
	creatureevent:register()
end

-- register 
do
	local creatureevent = CreatureEvent("influencedMonstersLogin")
	function creatureevent.onLogin(player)
		player:registerEvent("influencedMonsterDamage")
		return true
	end
	creatureevent:register()
end

-- checks for monster spawn
function Monster:canSpawnInfluenced()
	-- already influenced
	if self:getInfluenceLevel() > 0 then
		return false
	end

	-- passive or invalid
	local mType = self:getType()
	if not(mType and mType:isHostile()) then
		return false
	end
	
	-- not lootable
	local corpse = ItemType(mType:corpseId())
	if not(corpse and corpse:isContainer()) then
		return false
	end
	
	-- busy or not eligible
	if mType:isBoss() or self:isSummon() or not self:isIdle() then
		return false
	end
	
	-- not common or no category
	local bestiaryEntry = GameBestiary[self:getBestiaryRaceName()]
	if not(bestiaryEntry and bestiaryEntry.rarity == 1) then
		return false
	end
	
	-- area excluded from spawning
	local monsterPos = self:getPosition()
	for _, area in pairs(NoDustAreas) do
		if monsterPos:isInRange(area.from, area.to) then
			return false
		end
	end
	
	return true
end

-- generate fiendish monsters
function checkFiendish()
	local now = os.time()
	local fiendCount = 0
	
	for monsterId, expires in pairs(FiendishMonsters) do
		local creature = Creature(monsterId)
		if not creature then
			FiendishMonsters[monsterId] = nil
		elseif now > expires then
			FiendishMonsters[monsterId] = nil
			creature:setFiendish(false)
		else
			fiendCount = fiendCount + 1
		end
	end

	if fiendCount < fiendishLimit then
		local monIds = Game.getMonsterIds()
		local monSize = #monIds
		
		-- make 20 attempts to populate the map with fiendish monsters
		if monSize > 0 then
			for i = 1, 20 do
				local monsterId = monIds[math.random(monSize)]
				local monster = Monster(monsterId)
				if monster and not monster:isRemoved() then
					if monster:canSpawnInfluenced() then
						monster:setFiendish(true)
						fiendCount = fiendCount + 1
						FiendishMonsters[monsterId] = now + fiendishDuration
					end
				end
				
				if fiendCount >= fiendishLimit then
					return true
				end
			end
		end
	end
end

do
	local globalEvent = GlobalEvent("fiendishLoop")
	globalEvent:interval(fiendCheckInterval)
	globalEvent.onThink = function(interval)
		checkFiendish()
		return true
	end
	
	globalEvent:register()
end

-- first run doesn't find anything because the monsters are not placed yet
-- we spawn them earlier instead of waiting full interval for next cycle
addEvent(checkFiendish, 15000)