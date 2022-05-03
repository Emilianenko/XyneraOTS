local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_RED)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_BURSTARROW)

arr = {
    {0, 0, 0, 0, 0},
    {0, 1, 1, 1, 0},
    {0, 1, 3, 1, 0},
    {0, 1, 1, 1, 0},
    {0, 0, 0, 0, 0}
}

local area = createCombatArea(arr)
combat:setArea(area)


local parameters = {
	{key = CONDITION_PARAM_TICKS, value = 6 * 1000},
	{key = CONDITION_PARAM_STAT_MAGICPOINTSPERCENT, value = 80}
}

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	for _, target in ipairs(combat:getTargets(creature, variant)) do
		target:addAttributeCondition(parameters)
	end
	return true
end

spell:name("asura skill reducer")
spell:words("###1004")
spell:isAggressive(true)
spell:needTarget(true)
spell:needLearn(true)
spell:register()

