-- toggle super speed
local talk = TalkAction("/friction")
function talk.onSay(player, words, param)
	if not player:isAdmin() then
		return true
	end

	local newValue = not player:isIgnoringFriction()
	player:setIgnoreFriction(newValue)
	player:sendColorMessage(string.format("Your character %s.", newValue and "is super fast now" or "returns to normal speed"), MESSAGE_COLOR_PURPLE)
	player:setStorageValue(PlayerStorageKeys.adminSpeedPreference, newValue and 1 or -1)
	return false
end
talk:register()

-- load remembered preference
local creatureevent = CreatureEvent("tileFrictionLogin")
function creatureevent.onLogin(player)
	if player:isAdmin() and player:getStorageValue(PlayerStorageKeys.adminSpeedPreference) == 1 then
		player:setIgnoreFriction(true)
	end
	return true
end
creatureevent:register()
