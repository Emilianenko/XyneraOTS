local creatureevent = CreatureEvent("adminColorNameLogin")
function creatureevent.onLogin(player)
	if player:getGroup():getAccess() then
		player:setDisplayName(string.format('<font size="5" color="#ff0000">%s %s</font>&nbsp;&nbsp;', string.char(5), player:getName()))
	end
	
	return true
end
creatureevent:register()
