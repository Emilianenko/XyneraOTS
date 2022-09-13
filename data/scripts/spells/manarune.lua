---- USE MANA RUNE
local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_MANADRAIN)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, 0)
combat:setParameter(COMBAT_PARAM_TARGETCASTERORTOPMOST, 1)

function onGetFormulaValues(player, level, maglevel)
	local min = level * 1.8 + maglevel * 7
	local max = level * 1.8 + maglevel * 12
	return min, max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local rune = Spell("rune")

function rune.onCastSpell(creature, var, isHotkey)
	return combat:execute(creature, var)
end

rune:group("healing")
rune:name("Mana Rune")
rune:runeId(2294)
rune:allowFarUse(true)
rune:charges(3)
rune:level(400)
rune:cooldown(2000)
rune:groupCooldown(2000)
rune:isAggressive(false)
rune:needTarget(true)
rune:isBlocking(true) -- True = Solid / False = Creature
rune:register()

---- CONJURE MANA RUNE
local spell = Spell("instant")
function spell.onCastSpell(creature, variant)
	return creature:conjureItem(2260, 2294, 3)
end

spell:name("Conjure Mana Rune")
spell:words("adura max vis")
spell:group("support")
spell:vocation("druid;true", "elder druid;true")
spell:cooldown(2 * 1000)
spell:groupCooldown(2 * 1000)
spell:level(400)
spell:mana(5000)
spell:soul(3)
spell:isAggressive(false)
spell:needLearn(false)
spell:register()