local chainMaxDamage = 0x10000000 -- 2^28 + some space reserved for damage modifiers
local function getNextDamage(dmg, mult)
	return math.min(dmg * mult, chainMaxDamage)
end

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

function Position:getSteepLine(toPos)
	local dx = toPos.x - self.x
	local slope = dx == 0 and 1 or ((toPos.y - self.y) / dx)
	local xi = self.y + slope

	local res = {}
	for y = self.x + 1, toPos.x - 1 do
		-- 0.1 is necessary to avoid loss of precision during calculation
		local pathPos = Position(math.floor(xi + 0.1), y, self.z)
		local tile = Tile(pathPos)
		if tile and tile:hasProperty(CONST_PROP_BLOCKPROJECTILE) then
			return
		end
		res[#res + 1] = pathPos

		xi = xi + slope
	end

	return res
end

function Position:getSlightLine(toPos)
	local dx = toPos.x - self.x
	local slope = dx == 0 and 1 or ((toPos.y - self.y) / dx)
	local yi = self.y + slope

	local res = {}
	for x = self.x + 1, toPos.x - 1 do
		-- 0.1 is necessary to avoid loss of precision during calculation
		local pathPos = Position(x, math.floor(yi + 0.1), self.z)
		local tile = Tile(pathPos)
		if tile and tile:hasProperty(CONST_PROP_BLOCKPROJECTILE) then
			return
		end
		res[#res + 1] = pathPos
		
		yi = yi + slope
	end

	return res
end

function Position:getSightLine(toPos)
	-- same pos
	if self.x == toPos.x and self.y == toPos.y then
		return {}
	end

	-- melee range
	if math.abs(self.x - toPos.x) < 2 and math.abs(self.y - toPos.y) < 2 then
		return {}
	end

	-- long range, determine 
	if math.abs(toPos.y - self.y) > math.abs(toPos.x - self.x) then
		if toPos.y > self.y then
			return Position(self.y, self.x, self.z):getSteepLine(Position(toPos.y, toPos.x, toPos.z))
		end
		return Position(toPos.y, toPos.x, toPos.z):getSteepLine(Position(self.y, self.x, self.z))
	end

	if self.x > toPos.x then
		return toPos:getSlightLine(self)
	end

	return self:getSlightLine(toPos)
end

function executeSubChain(creature, pos, chainConfig, isTrail)
	-- check for duplicates
	for _, visitedPos in pairs(chainConfig.visited) do
		if pos == visitedPos then
			-- tile already checked by chain
			return false
		end
	end

	-- notify about tile being visited
	chainConfig.visited[#chainConfig.visited + 1] = pos
	
	-- check if attacker can see the target pos
	-- does not apply to extended chain
	if not chainConfig.extended then
		local rootPos = creature:getPosition()
		if math.abs(pos.x - rootPos.x) > 7 or math.abs(pos.y - rootPos.y) > 5 then	
			return false
		end	
	end
	
	-- check if tile exists
	local tile = Tile(pos)
	if not tile then
		return false
	end
	
	local tileCreatures = tile:getCreatures() or {}
	for _, target in pairs(tileCreatures) do
		if creature:isOpponent(target) then
			doAreaCombat(creature:getId(), chainConfig.element, pos, {1}, chainConfig.min, chainConfig.max, chainConfig.effect, ORIGIN_SPELL)

			-- direct hit, spread to neighbours
			if not isTrail then
				-- chain hit something, increase damage
				chainConfig.min = getNextDamage(chainConfig.min, chainConfig.rate)
				chainConfig.max = getNextDamage(chainConfig.max, chainConfig.rate)

				-- check neighbours
				for dir = 0, 7 do
					local offset = Position.directionOffset[dir]
					local nextPos = Position(pos.x + offset.x, pos.y + offset.y, pos.z)
					if executeSubChain(creature, nextPos, chainConfig, false) then
						-- chain hit something, increase damage
						chainConfig.min = getNextDamage(chainConfig.min, chainConfig.rate)
						chainConfig.max = getNextDamage(chainConfig.max, chainConfig.rate)
					end
				end
			end
			
			return true
		end
	end

	return false
end

function executeChain(creature, fromPos, toPos, chainConfig)
	local sightLine = fromPos:getSightLine(toPos)
	if not sightLine then
		return false
	end
	
	if chainConfig.targetCount > 1 then
		chainConfig.extended = true
	end
	
	-- chain starting point
	if executeSubChain(creature, fromPos, chainConfig, false) then
		-- player was found on chain way to target, increase damage
		chainConfig.min = getNextDamage(chainConfig.min, chainConfig.rate)
		chainConfig.max = getNextDamage(chainConfig.max, chainConfig.rate)
	else
		-- no targets on caster tile
		fromPos:sendMagicEffect(chainConfig.effect)
	end
	
	-- chain trail to the target
	for _, pos in pairs(sightLine) do
		if executeSubChain(creature, pos, chainConfig, true) then
			-- chain hit something, increase damage
			chainConfig.min = getNextDamage(chainConfig.min, chainConfig.rate)
			chainConfig.max = getNextDamage(chainConfig.max, chainConfig.rate)
		else
			-- empty tile on the way to the target
			pos:sendMagicEffect(chainConfig.effect)
		end
	end

	-- final step of the chain
	chainConfig.targetCount = chainConfig.targetCount - 1
	if chainConfig.targetCount < 1 then
		-- chain ended - strike on toPos and end
		if executeSubChain(creature, toPos, chainConfig, false) then
			-- increase damage for extended chain
			chainConfig.min = getNextDamage(chainConfig.min, chainConfig.rate)
			chainConfig.max = getNextDamage(chainConfig.max, chainConfig.rate)
		else
			-- target disappeared from tile before script ended
			toPos:sendMagicEffect(chainConfig.effect)
		end
		
		return true
	end
	
	-- extended chain - search for next target
	-- clockwise spiral pattern starting from direction east
	local x = 0
	local y = 0
	local dx = 0
	local dy = -1
	
	-- (2 * range + 1)^2 = 121 if chain bounce range = 5
	-- we substract 1 because the spiral does not count base tile
	for i = 1, 120 do
		if x == y or (x < 0 and x == -y) or (x > 0 and x == 1-y) then
			dx, dy = -dy, dx
		end
		x, y = x+dx, y+dy
		
		-- determine next spiral position
		local nextPos = Position(toPos.x + x, toPos.y + y, toPos.z)
		
		-- check tile presence
		local tile = Tile(nextPos)
		if tile and tile:getCreatureCount() > 0 then
			-- check if not already visited
			if not table.contains(chainConfig.visited, nextPos) then
				-- check if next target can be attacked
				if executeChain(creature, toPos, nextPos, chainConfig) then
					-- jump successful, escape the recurrency
					return true
				end
			end
		end
	end

	-- extended chain - no more targets to hit, strike toPos
	executeSubChain(creature, toPos, chainConfig, false)
	return true
end
