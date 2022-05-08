local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_DRAWBLOOD)

arr = {
    {0, 0, 0, 0, 0},
    {0, 0, 1, 0, 0},
    {0, 1, 3, 1, 0},
    {0, 0, 1, 0, 0},
    {0, 0, 0, 0, 0}
}

local area = createCombatArea(arr)
combat:setArea(area)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	for _, target in ipairs(combat:getTargets(creature, variant)) do
		creature:addDamageCondition(CONDITION_BLEEDING, DAMAGELIST_VARYING_PERIOD, 15, {8, 15}, 26)
	end
	return true
end

spell:name("white lion bleeding")
spell:words("###1005")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needDirection(false)
spell:needTarget(false)
spell:needLearn(true)
spell:register()