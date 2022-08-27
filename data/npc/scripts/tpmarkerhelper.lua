-- fix na menu kontekstowe
if not TP_HELPERS_RELOAD_GUARD then
	TP_HELPERS_RELOAD_GUARD = {}
end

local function onInit(npcId)
	local self = Creature(npcId)
	if not self then
		return
	end
	
	if not TP_HELPERS_RELOAD_GUARD[npcId] then
		TP_HELPERS_RELOAD_GUARD[npcId] = 1		
		self:setHiddenHealth(true)
		self:setPhantom(true)
	end
end

local init = false
function onCreatureAppear(cid)	
	if not init then
		init = true
		onInit(getNpcCid())
	end
end

function onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) end
function onThink()
	if selfPos and effect and os.time() % 2 == 0 then
		selfPos:sendMagicEffect(effect)
	end
	return true
end