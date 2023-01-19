local markers = {
	["Monsters"] = {
		itemId = 1387,
		destination = Position(1064, 992, 3),
		effect = 178,
		color = "#f7df05",
	},
	["Temple"] = {
		itemId = 1387,
		destination = Position(1121, 959, 7),
		effect = 178,
		color = "#f7df05",
	},
	["Quests"] = {
		itemId = 1387,
		destination = Position(1050, 1000, 5),
		effect = 178,
		color = "#f7df05",
	},
	["NPC"] = {
		itemId = 1387,
		destination = Position(968, 1059, 7),
		effect = 178,
		color = "#f7df05",
	},
	["Bosses"] = {
		itemId = 1387,
		-- destination = Position(968, 1059, 7),
		effect = 178,
		color = "#f7df05",
	},
	["Cassino"] = {
		itemId = 1387,
		-- destination = Position(968, 1059, 7),
		effect = 178,
		color = "#f7df05",
	},
	["Trainers"] = {
		--itemId = 1387,
		--destination = Position(0, 0, 0),
		effect = 178,
		color = "#f7df05",
	}
}

local init = false
local effect

-- tymczasowa przechowalnia na npcki
if not TP_MARKERS_TECHPOS then
	TP_MARKERS_TECHPOS = Position(0, 0, 15)
	Game.createTile(TP_MARKERS_TECHPOS)
end

if not TP_MARKERS_RELOAD_GUARD then
	TP_MARKERS_RELOAD_GUARD = {}
	TP_MARKERS_HOME = {}
end

local function animate(npcId, frameId)
	local npc = Creature(npcId)
	if not npc then
		return
	end
	
	local npcName = npc:getName()
	if frameId and frameId == -1 then
		npc:setDisplayName(" ")
	else
		local marker = markers[npcName]
		if marker then
			npc:setDisplayName(string.format('<font color="%s"><h2>%s</h2></font>%s', marker.color, npcName, string.rep("<br />", frameId or 2)))
			
			if marker.effect and not frameId then
				Position(TP_MARKERS_HOME[npcId]):sendMagicEffect(marker.effect)
			end
		end
	end
	
	if not frameId then
		addEvent(animate, 175, npcId, 3)
		addEvent(animate, 350, npcId, 4)
		addEvent(animate, 525, npcId, 5)
		addEvent(animate, 700, npcId, 6)
		addEvent(animate, 875, npcId, -1)
		addEvent(animate, 1500, npcId)
	end
end

local function animate_2(npcId, frameId)
	local npc = Creature(npcId)
	if not npc then
		return
	end
	
	local npcName = npc:getName()
	if frameId and frameId == -1 then
		npc:setDisplayName(" ")
	else
		local marker = markers[npcName]
		if marker then
			npc:setDisplayName(string.format('<font color="%s"><h2>%s</h2></font>%s', marker.color, npcName, string.rep("<br />", frameId or 0)))
			
			if marker.effect and not frameId then
				Position(TP_MARKERS_HOME[npcId]):sendMagicEffect(marker.effect)
			end
		end
	end
	
	if not frameId then
		addEvent(animate_2, 500, npcId, 1)
		addEvent(animate_2, 675, npcId, 2)
		addEvent(animate_2, 850, npcId, 3)
		addEvent(animate_2, 1025, npcId, 4)
		addEvent(animate_2, 1200, npcId, 5)
		addEvent(animate_2, 1375, npcId, 6)
		addEvent(animate_2, 1875, npcId, 5)
		addEvent(animate_2, 2050, npcId, 4)
		addEvent(animate_2, 2225, npcId, 3)
		addEvent(animate_2, 2400, npcId, 2)
		addEvent(animate_2, 2575, npcId, 1)
		addEvent(animate_2, 2750, npcId)
	end
end

local function onInit(npcId)
	local self = Creature(npcId)
	if not self then
		return
	end
	
	local selfName = self:getName()
	local selfPos = self:getPosition()
	
	if not TP_MARKERS_HOME[npcId] then
		TP_MARKERS_HOME[npcId] = {x = selfPos.x, y = selfPos.y, z = selfPos.z}
	end
	
	self:setOutfit({lookTypeEx = 1548})
	
	local tpInfo = markers[selfName]
	self:setDisplayMode(CREATURE_DISPLAY_MODE_PLAYER)
	self:setHiddenHealth(true)
	self:setPhantom(true)

	if TP_MARKERS_RELOAD_GUARD[npcId] then
		-- handle reload
		effect = tpInfo.effect
		local tile = Tile(TP_MARKERS_HOME[npcId])
		if tile then
			local prevTp = TP_MARKERS_RELOAD_GUARD[npcId]
			if prevTp then
				local oldTp = tile:getItemById(prevTp)
				if oldTp then
					oldTp:remove()
				end
			end
		end
	else
		-- move the npc one tile down
		selfPos.y = selfPos.y + 1

		-- force technical npc on top of real one to hide context menu
		self:teleportTo(TP_MARKERS_TECHPOS)
		Game.createNpc("TpFilter", selfPos, false, true)
		self:teleportTo(selfPos)
		
		-- force a second npc to hide look
		Game.createNpc("TpFilter", selfPos, false, true)
		
		animate_2(npcId)
	end

	--self:setDisplayName(string.format('<h1><font color="%s">%s</font></h1>%s', tpInfo.color, selfName, string.rep("<br />", 2)))

	-- load tp itemid from config
	TP_MARKERS_RELOAD_GUARD[npcId] = tpInfo.itemId or 1
	
	-- initialize
	if tpInfo.itemId then
		local destination = tpInfo.destination
		if destination then
			local tp = Game.createItem(tpInfo.itemId, 1, TP_MARKERS_HOME[npcId])
			if tp then
				tp:setDestination(destination)
				effect = tpInfo.effect
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
	return true
end