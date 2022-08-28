local hirelingLamp = Action()

function hirelingLamp.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	player:say("skrypt w budowie")
	local hireling = Game.createNpc("Hireling", player:getPosition(), false, true)
	if hireling then
		hireling:setSpeechBubble(SPEECHBUBBLE_HIRELING)
		hireling:setPhantom(true)
		--item:remove(1)
	end
	return true
end

hirelingLamp:id(32088)
hirelingLamp:register()
