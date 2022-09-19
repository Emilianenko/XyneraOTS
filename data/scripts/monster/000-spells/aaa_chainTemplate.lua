function Position:isValidChainPos(visitedTiles)
	-- check if tile exists
	local tile = Tile(self)
	if not (tile and tile:getCreatureCount() > 0) then
		return false
	end

	-- check if tile was not already visited
	for _, pos in pairs(visitedTiles) do
		if self == pos then
			return false
		end
	end
	
	-- eligible
	return true
end

function executeChain(creature, pos, element, effect, min, max, rate, remainingTiles, visitedTiles, lastDir)
	-- deal damage part
	doAreaCombat(creature:getId(), element, pos, {1}, min, max, effect)
	remainingTiles = remainingTiles - 1
	if remainingTiles < 1 then
		return
	end
	
	-- tile search part
	local dirList = {
		DIRECTION_NORTH, DIRECTION_EAST,
		DIRECTION_SOUTH, DIRECTION_WEST,
		DIRECTION_SOUTHWEST, DIRECTION_SOUTHEAST,
		DIRECTION_NORTHWEST, DIRECTION_NORTHEAST
	}

	local center = creature:getPosition()
	local fromPos = Position(center.x - 7, center.y - 5, center.z)
	local toPos = Position(center.x + 7, center.y + 5, center.z)
	
	local nextPos
	local nextDir = lastDir
	
	if lastDir then
		-- assumptions:
		-- *dirList is complete
		-- *dir ids are 0-7
		table.remove(dirList, lastDir + 1)
		local offset = Position.directionOffset[lastDir]
		nextPos = Position(pos.x + offset.x, pos.y + offset.y, pos.z)
		if not nextPos:isInRange(fromPos, toPos) or not nextPos:isValidChainPos(visitedTiles) then
			nextPos = nil
		end
	end
	
	if not nextPos then
		for i = 1, #dirList do
			local dirIndex = math.random(#dirList)
			local dir = dirList[dirIndex]
			table.remove(dirList, dirIndex)
			local offset = Position.directionOffset[dir]
			nextPos = Position(pos.x + offset.x, pos.y + offset.y, pos.z)

			if not nextPos:isInRange(fromPos, toPos) or not nextPos:isValidChainPos(visitedTiles) then
				nextPos = nil
				nextDir = dir
			else
				break
			end
		end
	end
	
	if nextPos then
		visitedTiles[#visitedTiles + 1] = nextPos
		executeChain(creature, nextPos, element, effect, min * rate, max * rate, rate, remainingTiles, visitedTiles, nextDir)
	end
end

local element = COMBAT_ENERGYDAMAGE
local effect = CONST_ME_ENERGYAREA
local tileCount = 5
local nextTileDamageRate = 1.25

-- script will take values from here
-- do not set min/max in monster file
local defaultMin = 45
local defaultMax = 55

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NONE)

local spell = Spell(SPELL_INSTANT)
function spell.onCastSpell(creature, variant)
	if not creature then
		return combat:execute(creature, variant)
	end
	
	local targetPos = variant:getPosition()
	if targetPos.x == 0 then
		local cid = variant:getNumber()
		if cid ~= 0 then
			local target = Creature(cid)
			if target then
				targetPos = target:getPosition()
				if targetPos.x == 0 then
					targetPos = creature:getPosition()
				end
			end
		end
	end
	
	local ret = combat:execute(creature, variant)
	if ret then
		executeChain(creature, targetPos, element, effect, defaultMin, defaultMax, nextTileDamageRate, tileCount, {creature:getPosition()})
	end
	
	return ret
end

spell:name("chain template")
spell:words("###chainTemplate")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:needDirection(true)
spell:needTarget(true)
spell:register()