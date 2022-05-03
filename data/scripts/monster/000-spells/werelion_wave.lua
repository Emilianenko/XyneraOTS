local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_HOLYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITAREA)

	arr = {
		{0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0},
		{0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0}
	}

local area = createCombatArea(arr)
	combat:setArea(area)


	local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("werelion wave")
spell:words("###473")
spell:isAggressive(true)
spell:needLearn(true)
spell:needDirection(true)
spell:needTarget(false)
spell:register()