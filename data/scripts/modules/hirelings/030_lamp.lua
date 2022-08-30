local hirelingLamp = Action()

function hirelingLamp.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	player:say("skrypt w budowie")
	local hireling = Game.createNpc("Hireling", player:getPosition(), false, true)
	if hireling then
		hireling:setSpeechBubble(SPEECHBUBBLE_HIRELING)
		hireling:setPhantom(true)
		hireling:setOwnerGUID(player:getGuid())
		--item:remove(1)
		-- to do: cache?
	end
	return true
end

hirelingLamp:id(ITEM_HIRELING_LAMP) -- 32088
hirelingLamp:register()
