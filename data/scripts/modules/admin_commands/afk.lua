-- toggle afk status
local talk = TalkAction("/afk", "!afk")
function talk.onSay(player, words, param)
	if not player:isAdmin() then
		return true
	end
	
	local newAfk = not player:isAfk()
	player:setAfk(newAfk)
	player:sendColorMessage(newAfk and "You are now AFK." or "You are no longer AFK.", MESSAGE_COLOR_PURPLE)
	return false
end
talk:register()
