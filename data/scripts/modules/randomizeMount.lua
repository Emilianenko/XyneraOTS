-- load remembered preference
local creatureevent = CreatureEvent("randomizeMountLogin")
function creatureevent.onLogin(player)
	if player:getStorageValue(PlayerStorageKeys.randomizeMount) == 1 then
		player:setRandomizedMount(true)
	end
	return true
end
creatureevent:register()

-- update the preference on changing outfit
local ec = EventCallback
ec.onChangeOutfit = function(self, outfit)
	self:setStorageValue(PlayerStorageKeys.randomizeMount, self:hasRandomizedMount() and 1 or 0)
	return true
end
ec:register()