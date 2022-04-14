function onSay(player, words, param)
	if not player:isAdmin() then
		return true
	end

	local start = os.mtime()
	local itemCount = cleanMap()

	player:sendColorMessage(
		string.format(
			"Cleaned %d item%s in %0.3fs",
			itemCount,
			(itemCount ~= 1 and "s" or ""),
			(os.mtime() - start)/1000
		),
		MESSAGE_COLOR_PURPLE
	)
	return false
end
