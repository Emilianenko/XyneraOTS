local dustConversion = Action()
function dustConversion.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	player:say("Dust added to your forge balance.", TALKTYPE_MONSTER_SAY, true, player)
	item:getPosition():sendMagicEffect(CONST_ME_FIREWORK_TURQUOISE)
	player:addForgeDust(100, true)
	item:remove(1)
	return true
end

dustConversion:id(ITEM_FORGE_DUST)
dustConversion:register()

