local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 242)

local area = {
	{1, 1, 1},
	{0, 1, 0},
	{0, 3, 0}
}

combat:setArea(createCombatArea(area))

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("MenacingCarnivorTWave")
spell:words("###MenacingCarnivorTWave")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:needDirection(true)
spell:needTarget(false)
spell:register()