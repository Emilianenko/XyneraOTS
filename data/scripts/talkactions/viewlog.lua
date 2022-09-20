local options = {
	build = "log_build.txt",
	cmake = "log_cmake.txt"
}

local t = TalkAction("/viewlog")
t.onSay = function(player, words, param)
	-- permission check
	if player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end
	
	local filename = options[param]
	if not filename then
		player:sendColorMessage("Log type not found.", MESSAGE_COLOR_PURPLE)
		return false
	end

	if not file_exists(filename) then
		player:sendColorMessage("File not found.", MESSAGE_COLOR_PURPLE)
		return false
	end
	
	local lineId = 1
	for line in io.lines(cmakelog) do
		if lineId > DEPLOY_LINE_COUNT_CMAKE then
			player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("%d: %s", lineId, line))
		end
		lineId = lineId + 1
	end

	return false
end

t:separator(" ")
t:register()
