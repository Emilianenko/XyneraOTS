local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)

areaBeam = {
    {0, 0, 1, 0, 0},
    {0, 0, 1, 0, 0},
    {0, 0, 1, 0, 0},
    {0, 0, 1, 0, 0},
    {0, 0, 1, 0, 0},
    {0, 0, 1, 0, 0},
    {0, 0, 1, 0, 0},
    {0, 0, 1, 0, 0},
    {0, 0, 3, 0, 0}
}

local area = createCombatArea(areaBeam)
combat:setArea(area)


local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	 for _, target in ipairs(combat:getTargets(creature, variant)) do
	creature:addDamageCondition(target, CONDITION_FREEZING, DAMAGELIST_VARYING_PERIOD, 8, {8, 8}, 26)
	 end
	return true
end

spell:name("frost asura freezing beam")
spell:words("###1007")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needTarget(false)
spell:needLearn(true)
spell:needDirection(true)
spell:register()