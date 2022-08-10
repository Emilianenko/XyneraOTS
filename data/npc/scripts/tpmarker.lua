-- wczesniejszy wyglad
-- local labelDefault = "<center><h2>|ARROWDOWN| |NPCNAME| |ARROWDOWN|</h2></center>Travel to |NPCNAME|",

-- wersja 2
-- local labelDefaultLeft = "<h2>|NPCNAME| |ARROWDOWN|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</h2>"
-- local labelDefaultRight = "<h2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|ARROWDOWN| |NPCNAME|</h2>"

local labelDefault = '<font color="#f7df05" size="5">|NPCNAME|<br />|CENTERARROW||ARROWDOWN|</font>'

local markers = {
	["Monsters"] = {
		itemId = 1387,
		destination = Position(1052, 1010, 5),
		effect = 178,
		label = labelDefault,
	},
	["Temple"] = {
		itemId = 1387,
		destination = Position(1121, 959, 7),
		effect = 178,
		label = labelDefault,
	},
	["Quests"] = {
		itemId = 1387,
		destination = Position(1050, 1000, 5),
		effect = 178,
		label = labelDefault,
	},
	["NPC"] = {
		itemId = 1387,
		destination = Position(968, 1059, 7),
		effect = 178,
		label = labelDefault,
	},
	["Bosses"] = {
		itemId = 1387,
		-- destination = Position(968, 1059, 7),
		effect = 178,
		label = labelDefault,
	},
	["Cassino"] = {
		itemId = 1387,
		-- destination = Position(968, 1059, 7),
		effect = 178,
		label = labelDefault,
	},
	["Trainers"] = {
		--itemId = 1387,
		--destination = Position(0, 0, 0),
		effect = 178,
		label = labelDefault,
	}
}

local macros = {
	["|ARROWDOWN|"] = function(creature, pos) return string.char(25) end,
	["|NPCNAME|"] = function(creature, pos) return creature:getName() end,
	["|CENTERARROW|"] = function(creature, pos) return string.rep("&nbsp;", math.floor(creature:getName():len() * 0.85)) end,
}

local init = false
local selfPos
local effect

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
	
	local tpInfo = markers[selfName]
	local label = tpInfo.label
	for macro, callback in pairs(macros) do
		label = label:gsub(macro, callback(self, selfPos))
	end
	
	self:setDisplayName(label)
	self:setDisplayMode(CREATURE_DISPLAY_MODE_PLAYER)
	self:setHiddenHealth(true)
	self:setPhantom(true)
	
	
	if TP_MARKERS_RELOAD_GUARD[npcId] then
		-- handle reload
		effect = tpInfo.effect
		local tile = self:getTile()
		if tile then
			local prevTp = TP_MARKERS_RELOAD_GUARD[npcId]
			if prevTp and prevTp ~= 1 then
				local oldTp = tile:getItemById(prevTp)
				if oldTp then
					oldTp:remove()
				end
			end
		end
	end

	-- initialize
	TP_MARKERS_RELOAD_GUARD[npcId] = tpInfo.itemId or 1
	local destination = tpInfo.destination
	if destination then
		local destId = tpInfo.itemId
		if not destId then
			markers[selfName].itemId = 1387
			destId = 1387
		end
	
		local tp = Game.createItem(destId, 1, selfPos)
		if tp then
			tp:setDestination(destination)
			effect = tpInfo.effect
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