-- dispatcher module
-- created by Zbizu

-- this module is being used by lua protocol features
-- to reduce server load on operations that request heavy data
-- but are trivial to smooth gameplay

-- THIS SYSTEM RELIES ON DELAYED EXECUTION (LIKE addEvent)
-- DO NOT PUT USERDATA IN addDispatcherTask
-- IF YOU DO, YOUR SERVER WILL HAVE HIGH CHANCE TO CRASH

-- time between dispatcher cycles
DISPATCHER_INTERVAL = 1500

-- max queue size per creature
-- old unprocessed tasks will be discarded
DISPATCHER_TASK_LIMIT = 5 

-- maximum amount of creatures processed per cycle
DISPATCHER_MAX_CREATURES_PER_CYCLE = 20

-- dispatcher unique ids
DISPATCHER_COMPENDIUM_BASE = 1
DISPATCHER_COMPENDIUM_GENERAL = 2
DISPATCHER_COMPENDIUM_COMBAT = 3
DISPATCHER_COMPENDIUM_DEATHS = 4
DISPATCHER_COMPENDIUM_PVPKILLS = 5
DISPATCHER_COMPENDIUM_ACHIEVEMENTS = 6
DISPATCHER_COMPENDIUM_INVENTORY = 7
DISPATCHER_COMPENDIUM_COSMETICS = 8
DISPATCHER_COMPENDIUM_STORE = 9
DISPATCHER_COMPENDIUM_INSPECTION = 10
DISPATCHER_COMPENDIUM_BADGES = 11
DISPATCHER_COMPENDIUM_TITLES = 12

-- reload-safe
if not GAME_DISPATCHER then
	GAME_DISPATCHER = {}
	GAME_DISPATCHER_TMP = {}
	
	function runDispatcher()
		local creaturesProcessed = 0
		for cid, tasks in pairs(GAME_DISPATCHER) do
			-- maximum amount of creatures reached
			if creaturesProcessed >= DISPATCHER_MAX_CREATURES_PER_CYCLE then
				addEvent(runDispatcher, DISPATCHER_INTERVAL)
				return
			end
			
			local creature = Creature(cid)
			if creature and not creature:isRemoved() and #GAME_DISPATCHER[cid] > 0 then
				-- minimal value is coded to work with reload
				GAME_DISPATCHER_TMP[cid] = {[-1] = {}}
				for taskIndex = math.max(1, #GAME_DISPATCHER[cid] + 1 - DISPATCHER_TASK_LIMIT), #GAME_DISPATCHER[cid] do
					-- schedule tasks to execute
					-- filter duplicates
					local task = GAME_DISPATCHER[cid][taskIndex]
					if task.uniqueId == -1 then
						GAME_DISPATCHER_TMP[cid][-1][#GAME_DISPATCHER_TMP[cid][-1] + 1] = {callback = task.callback, args = task.args}
					else
						GAME_DISPATCHER_TMP[cid][task.uniqueId] = {callback = task.callback, args = task.args}
					end
				end
				
				creature:executeDispatcherTasks()
				creaturesProcessed = creaturesProcessed + 1
			end
			
			GAME_DISPATCHER[cid] = nil
		end
		
		addEvent(runDispatcher, DISPATCHER_INTERVAL)
	end
	
	runDispatcher()
end

-- callback - what function executes
-- uniqueId - set a number to the task to filter duplicates, -1 to allow stacking
function Creature:addDispatcherTask(callback, uniqueId, ...)
	if DISPATCHER_TASK_LIMIT == 0 then
		return
	end
	
	local cid = self:getId()
	if not GAME_DISPATCHER[cid] then
		GAME_DISPATCHER[cid] = {}
	end
	
	local newTask = {callback = callback, uniqueId = uniqueId, args = table.pack(...)}
	
	if DISPATCHER_TASK_LIMIT > 1 then
		-- max queue size reached, ignore least recent call
		if #GAME_DISPATCHER[cid] == DISPATCHER_TASK_LIMIT then
			for taskIndex = 2, #GAME_DISPATCHER[cid] do
				GAME_DISPATCHER[cid][taskIndex-1] = GAME_DISPATCHER[cid][taskIndex]
			end

			GAME_DISPATCHER[cid][#GAME_DISPATCHER[cid]] = newTask
			return
		end
		
		-- add to queue
		GAME_DISPATCHER[cid][#GAME_DISPATCHER[cid] + 1] = newTask
		return
	end
	
	-- queue size is 1, just overwrite
	GAME_DISPATCHER[cid][1] = newTask
end

function executeDispatcherTask(cid, task)
	local creature = Creature(cid)
	if not creature or creature:isRemoved() then
		return
	end
	
	task.callback(unpack(task.args))
end

function Creature:executeDispatcherTasks()
	local cid = self:getId()
	
	if not (GAME_DISPATCHER_TMP and GAME_DISPATCHER_TMP[cid]) then
		return
	end

	-- execute stackable tasks
	if GAME_DISPATCHER_TMP[cid][-1] then
		for _, task in pairs(GAME_DISPATCHER_TMP[cid][-1]) do
			addEvent(executeDispatcherTask, 100, cid, task)
		end
		
		GAME_DISPATCHER_TMP[cid][-1] = nil
	end
	
	-- execute unique tasks
	for _, task in pairs(GAME_DISPATCHER_TMP[cid]) do
		addEvent(executeDispatcherTask, 100, cid, task)
	end
	
	GAME_DISPATCHER_TMP[cid] = nil
end
