local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_LIFEDRAIN)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_GREEN)

arr = {
        {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
        {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
        {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0}
	}

local area = createCombatArea(arr)
	combat:setArea(area)


	local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("grimeleech wave")
spell:words("###1001")
spell:isAggressive(true)
spell:needLearn(true)
spell:needDirection(true)
spell:needTarget(false)
spell:register()