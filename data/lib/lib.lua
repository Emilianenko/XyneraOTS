-- fix for linux/git bash terminals getting stuck
if not PRINT_PATCHED then
	PRINT_PATCHED = true
	legacyPrint = print
	print = function(...)
		local ret = legacyPrint(...)
		refreshConsole()
		return ret
	end
	
	legacyIoWrite = io.write
	io.write = function(...)
		local ret = legacyIoWrite(...)
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
