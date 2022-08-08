local destinations = {
	["Monsters"] = {Position(1052, 1010, 5), CONST_ME_FIREWORK_BLUE},
	["Trainers"] = {Position(0, 0, 0), CONST_ME_FIREWORK_BLUE}
}

local init = false
local selfPos
local effect
local arrowDown = string.char(25)

if not TP_MARKERS_RELOAD_GUARD then
	TP_MARKERS_RELOAD_GUARD = {}
end

local function onInit(npcId)
	local self = Creature(npcId)
	if not self then
		return
	end
	
	local selfName = self:getName()
	selfPos = self:getPosition()
	
	self:setOutfit({lookTypeEx = 1548})
	self:setDisplayName(string.format("<center><h2>%s %s %s</h2></center>Travel to %s", arrowDown, selfName, arrowDown, selfName))
	self:setHiddenHealth(true)
	self:setPhantom(true)
	
	if TP_MARKERS_RELOAD_GUARD[npcId] then
		effect = destinations[selfName][2]
	else
		TP_MARKERS_RELOAD_GUARD[npcId] = true
		local destination = destinations[selfName][1]
		if destination then
			local tp = Game.createItem(1387, 1, selfPos)
			if tp then
				tp:setDestination(destination)
				effect = destinations[selfName][2]
			end
		end
	end
end

function onCreatureAppear(cid)	
	if not init then
		init = true
		addEvent(onInit, 100, getNpcCid())
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