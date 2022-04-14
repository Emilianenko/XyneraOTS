function onSay(player, words, param)
	local uptime = getWorldUpTime()

	local hours = math.floor(uptime / 3600)
	local minutes = math.floor((uptime - (3600 * hours)) / 60)
	player:sendColorMessage(string.format("Uptime: %d hour%s and %d minute%s.", hours, hours ~= 1 and "s" or "", minutes, minutes ~= 1 and "s" or ""), MESSAGE_COLOR_GREEN)
	return false
end
