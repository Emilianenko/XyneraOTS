local t = TalkAction("/save")
t.onSay = function(player, words, param)
	if not player:getGroup():getAccess() then
		return true
	end
	
	local start = os.mtime()
	saveServer()	
	player:sendColorMessage(string.format("Server saved in %0.3fs", (os.mtime() - start)/1000), MESSAGE_COLOR_PURPLE)
end
t:register()
