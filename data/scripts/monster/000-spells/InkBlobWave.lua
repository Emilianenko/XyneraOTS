local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_LOSEENERGY)

arr = {
        {0, 1, 1, 1, 0},
		{0, 1, 1, 1, 0},
		{0, 0, 3, 0, 0}
	}

local area = createCombatArea(arr)
	combat:setArea(area)


	local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("InkBlobWave")
spell:words("###1113")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:needDirection(true)
spell:needTarget(false)
spell:register()