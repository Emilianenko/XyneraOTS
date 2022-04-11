local LEVEL_LOWER = 1
local LEVEL_SAME = 2
local LEVEL_HIGHER = 3

local DISTANCE_BESIDE = 1
local DISTANCE_CLOSE = 2
local DISTANCE_FAR = 3
local DISTANCE_VERYFAR = 4

local difficulties = {
	[0] = "harmless",
	[1] = "trivial",
	[2] = "easy",
	[3] = "medium",
	[4] = "hard",
	[5] = "challenging"
}

local directions = {
	[DIRECTION_NORTH] = "north",
	[DIRECTION_SOUTH] = "south",
	[DIRECTION_EAST] = "east",
	[DIRECTION_WEST] = "west",
	[DIRECTION_NORTHEAST] = "north-east",
	[DIRECTION_NORTHWEST] = "north-west",
	[DIRECTION_SOUTHEAST] = "south-east",
	[DIRECTION_SOUTHWEST] = "south-west"
}

local descriptions = {
	[DISTANCE_BESIDE] = {
		[LEVEL_LOWER] = "is below you",
		[LEVEL_SAME] = "is standing next to you",
		[LEVEL_HIGHER] = "is above you"
	},
	[DISTANCE_CLOSE] = {
		[LEVEL_LOWER] = "is on a lower level to the",
		[LEVEL_SAME] = "is to the",
		[LEVEL_HIGHER] = "is on a higher level to the"
	},
	[DISTANCE_FAR] = "is far to the",
	[DISTANCE_VERYFAR] = "is very far to the"
}

local spell = Spell(SPELL_INSTANT)
spell:name("find fiend")
spell:words("exiva moe res")
spell:id(248)
spell:level(25)
spell:mana(20)
spell:group("support")
spell:isAggressive(false)
spell:cooldown(2000)
spell:groupCooldown(2000)
spell:needLearn(false)
spell.onCastSpell = function(player, variant)
	local target
	local expires = 0
	local distance = 200000
	local now = os.time()
	
	for creatureId, expiresAt in pairs(FiendishMonsters) do
		local newTarget = Monster(creatureId)
		if newTarget then
			local targetPos = newTarget:getPosition()
			local newDistance = targetPos.x + targetPos.y + targetPos.z
			if newDistance < distance and now < expiresAt then
				distance = newDistance
				target = newTarget
				expires = expiresAt
			end
		end
	end
	
	local creaturePosition = player:getPosition()
	
	if not target then
		player:sendTextMessage(MESSAGE_INFO_DESCR, "At the moment there is no fiend with special loot roaming this world.")
		creaturePosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
		return true
	end

	local targetPosition = target:getPosition()
	local positionDifference = {
		x = creaturePosition.x - targetPosition.x,
		y = creaturePosition.y - targetPosition.y,
		z = creaturePosition.z - targetPosition.z
	}

	local maxPositionDifference, direction = math.max(math.abs(positionDifference.x), math.abs(positionDifference.y))
	if maxPositionDifference >= 5 then
		local positionTangent = positionDifference.x ~= 0 and positionDifference.y / positionDifference.x or 10
		if math.abs(positionTangent) < 0.4142 then
			direction = positionDifference.x > 0 and DIRECTION_WEST or DIRECTION_EAST
		elseif math.abs(positionTangent) < 2.4142 then
			direction = positionTangent > 0 and (positionDifference.y > 0 and DIRECTION_NORTHWEST or DIRECTION_SOUTHEAST) or positionDifference.x > 0 and DIRECTION_SOUTHWEST or DIRECTION_NORTHEAST
		else
			direction = positionDifference.y > 0 and DIRECTION_NORTH or DIRECTION_SOUTH
		end
	end

	local level = positionDifference.z > 0 and LEVEL_HIGHER or positionDifference.z < 0 and LEVEL_LOWER or LEVEL_SAME
	local distance = maxPositionDifference < 5 and DISTANCE_BESIDE or maxPositionDifference < 101 and DISTANCE_CLOSE or maxPositionDifference < 250 and DISTANCE_FAR or DISTANCE_VERYFAR
	local description = descriptions[distance][level] or descriptions[distance]
	if distance ~= DISTANCE_BESIDE then
		description = description .. " " .. directions[direction]
	end
	
	local minLeft = math.floor((expires - now)/60)
	local minStr = minLeft > 1 and string.format("%d minute%s", minLeft, minLeft ~= 1 and "s" or "") or "less than one minute"
	
	local bestiaryEntry = GameBestiary[target:getBestiaryRaceName()]
	if bestiaryEntry and bestiaryEntry.rarity == 1 then
		if player:getGroup():getAccess() then
			player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("%s %s.\nPosition: %d, %d, %d\nDuration: %s", target:getName(), description, targetPosition.x, targetPosition.y, targetPosition.z, minStr))
			return true
		end

		local difficulty = "unknown"
		if player:getBestiaryRaceProgress(bestiaryEntry.id) == 4 then
			difficulty = difficulties[bestiaryEntry.difficulty] or difficulty
		end

		player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("The creature of difficulty level %s %s. You have %s left.", difficulty, description, minStr))
	else
		player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("The creature %s. You have %s left.", description, minStr))
	end

	creaturePosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	return true
end
spell:register()