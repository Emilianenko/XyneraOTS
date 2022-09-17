-- fix for linux/git bash terminals getting stuck
if not PRINT_PATCHED then
	PRINT_PATCHED = true
	legacyPrint = print
	print = function(...)
		local ret = legacyPrint(...)
		if Game.isDevMode() then
			local t = {...}
			if #t > 0 then
				for i = 1, #t do
					t[i] = tostring(t[i])
				end
			end
			
			local msg = table.concat(t, "\t")
			Game.appendConsoleHistory(CONSOLEMESSAGE_TYPE_RESPONSE, msg, false)
			sendChannelMessage(CHANNEL_CONSOLE, TALKTYPE_CHANNEL_O, msg)
		end
		refreshConsole()
		return ret
	end
	
	legacyIoWrite = io.write
	io.write = function(...)
		local ret = legacyIoWrite(...)
		if Game.isDevMode() then
			local t = {...}
			if #t > 0 then
				for i = 1, #t do
					t[i] = tostring(t[i])
				end
			end
			
			local msg = table.concat(t, "\t")
			Game.appendConsoleHistory(CONSOLEMESSAGE_TYPE_RESPONSE, msg, false)
			sendChannelMessage(CHANNEL_CONSOLE, TALKTYPE_CHANNEL_O, msg)
		end
		refreshConsole()
		return ret
	end
end

-- Core API functions implemented in Lua
dofile('data/lib/core/core.lua')

-- Compatibility library for our old Lua API
dofile('data/lib/compat/compat.lua')

-- Debugging helper function for Lua developers
dofile('data/lib/debugging/dump.lua')
dofile('data/lib/debugging/lua_version.lua')
