local element = COMBAT_ICEDAMAGE
local effect = CONST_ME_BLUECHAIN
local targetCount = 1 -- amount of bounces (2+ is extended)
local nextTileDamageRate = 1.15

-- script will take values from here
-- do not set min/max in monster file
local defaultMin = -4800
local defaultMax = -5200

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
		local chainConfig = {
			element = element,
			effect = effect,
			min = defaultMin,
			max = defaultMax,
			rate = nextTileDamageRate,
			targetCount = targetCount,
			visited = {}
		}
		executeChain(creature, creature:getPosition(), targetPos, chainConfig)
	end
	
	return ret
end

spell:name("chain morshabaal")
spell:words("###chainMorshabaal")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:needDirection(true)
spell:needTarget(true)
spell:register()