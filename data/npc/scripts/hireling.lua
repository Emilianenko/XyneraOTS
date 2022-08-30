-- script which executes for all hirelings

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(creature)
	-- execute hireling code if module is installed
	if HirelingsUsageCache then
		local cid = creature:getId()
		if cid == getNpcCid() then
			-- give other systems time to set stats to the npc
			addEvent(onHirelingInit, 100, cid)
		end
	end
	
	-- continue with default behaviour
	npcHandler:onCreatureAppear(creature)
end

function onCreatureDisappear(creature)
	-- execute hireling code if module is installed
	if HirelingsUsageCache then
		local cid = creature:getId()
		if cid == getNpcCid() then
			local npc = Npc(cid)
			
			-- unregister
			onHirelingDestroy(cid, npc:getOwnerGUID(), npc:getOutfit().lookType)
		end
	end
	
	-- continue with default behaviour
	npcHandler:onCreatureDisappear(creature)
end

function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)    end
function onThink()                          npcHandler:onThink()                        end

npcHandler:addModule(FocusModule:new())
