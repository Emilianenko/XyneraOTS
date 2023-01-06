-- retroMode changes level and quest doors behaviour to ones from 7.6
local retroMode = false

-- door keys
keys = {
	2086, 2087, 2088, 2089, 2090, 2091, 2092, 10032
}

-- normal doors
openDoors = {
	1211, 1214, 1233, 1236, 1251, 1254, 3537, 3546, 4915, 4918, 5100, 5109, 5118, 5127, 5136, 5139, 5142,
	5145, 5280, 5283, 5734, 5737, 6194, 6197, 6251, 6254, 6893, 6902, 7035, 7044, 8543, 8546, 9167, 9170,
	9269, 9272, 10270, 10273, 10470, 10479, 10777, 10786, 12094, 12101, 12190, 12199, 19842, 19851, 19982,
	19991, 20275, 20284, 22816, 22825, 25285, 25292, 43027, 43028, 44697, 44698
}
closedDoors = {
	1210, 1213, 1232, 1235, 1250, 1253, 3536, 3545, 4914, 4917, 5099, 5108, 5117, 5126, 5135, 5138, 5141,
	5144, 5279, 5282, 5733, 5736, 6193, 6196, 6250, 6253, 6892, 6901, 7034, 7043, 8542, 8545, 9166, 9169,
	9268, 9271, 10269, 10272, 10469, 10478, 10776, 10785, 12093, 12100, 12189, 12198, 12692, 12701, 14633,
	14640, 19841, 19850, 19981, 19990, 20274, 20283, 22815, 22824, 25284, 25291, 26529, 26531, 27559, 31020,
	31022, 32689, 32690, 32693, 32694, 33428, 33430, 33489, 33491, 36288, 36290, 36868, 36871, 37292, 37295,
	37298, 37301, 37592, 37594, 39115, 39117, 43024, 43026, 44691, 44692
}
lockedDoors = {
	1209, 1212, 1231, 1234, 1249, 1252, 3535, 3544, 4913, 4916, 5098, 5107, 5116, 5125, 5134, 5137, 5140,
	5143, 5278, 5281, 5732, 5735, 6192, 6195, 6249, 6252, 6891, 6900, 7033, 7042, 8541, 8544, 9165, 9168,
	9267, 9270, 10268, 10271, 10468, 10477, 10775, 10784, 12092, 12099, 12188, 12197, 13236, 13237, 14634,
	14641, 19840, 19849, 19980, 19989, 20273, 20282, 22814, 22823, 25283, 25290, 26530, 26532, 31175, 31021,
	31023, 32705, 32706, 32707, 32708, 33429, 33431, 33490, 33492, 36289, 36291, 36867, 36870, 37291, 37294,
	37297, 37300, 37593, 37595, 39116, 39118, 43023, 43025
}

-- simple doors (behaves like house doors)
openExtraDoors = {
	1540, 1542, 6796, 6798, 6800, 6802, 6960, 6962, 7055, 7057, 25159, 25161, 27198, 27200, 27243, 27245,
	31541, 31542, 34152, 34153, 36878, 36880, 39204
}
closedExtraDoors = {
	1539, 1541, 6795, 6797, 6799, 6801, 6959, 6961, 7054, 7056, 25158, 25160, 27197, 27199, 27242, 27244,
	31314, 31315, 34150, 34151, 36877, 36879, 39203
}

-- house doors
openHouseDoors = {
	1220, 1222, 1238, 1240, 3539, 3548, 5083, 5085, 5102, 5111, 5120, 5129, 5285, 5287, 5516, 5518, 6199,
	6201, 6256, 6258, 6895, 6904, 7037, 7046, 8548, 8550, 9172, 9174, 9274, 9276, 10275, 10277, 10472, 10481,
	13021, 13023, 17236, 17238, 18209, 19844, 19853, 19984, 19993, 20277, 20286, 22818, 22827, 35928, 35930
}
closedHouseDoors = {
	1219, 1221, 1237, 1239, 3538, 3547, 5082, 5084, 5101, 5110, 5119, 5128, 5284, 5286, 5515, 5517, 6198,
	6200, 6255, 6257, 6894, 6903, 7036, 7045, 8547, 8549, 9171, 9173, 9273, 9275, 10274, 10276, 10471, 10480,
	13020, 13022, 17235, 17237, 18208, 19843, 19852, 19983, 19992, 20276, 20285, 22817, 22826, 35927, 35929
}

-- quest doors
openQuestDoors = {
	1224, 1226, 1242, 1244, 1256, 1258, 3543, 3552, 5106, 5115, 5124, 5133, 5289, 5291, 5746, 5749, 6203,
	6205, 6260, 6262, 6899, 6908, 7041, 7050, 8552, 8554, 9176, 9178, 9278, 9280, 10279, 10281, 10476, 10485,
	10783, 10792, 12098, 12105, 12194, 12203, 14639, 14646, 19848, 19857, 19988, 19997, 20281, 20290, 22822,
	22831, 25163, 25165, 25289, 25296, 32698, 32700, 32702, 32704, 34320, 34322, 34225, 34227 
}
closedQuestDoors = {
	1223, 1225, 1241, 1243, 1255, 1257, 3542, 3551, 5105, 5114, 5123, 5132, 5288, 5290, 5745, 5748, 6202,
	6204, 6259, 6261, 6898, 6907, 7040, 7049, 8551, 8553, 9175, 9177, 9277, 9279, 10278, 10280, 10475, 10484,
	10782, 10791, 12097, 12104, 12193, 12202, 14638, 14645, 19847, 19856, 19987, 19996, 20280, 20289, 22821,
	22830, 25162, 25164, 25288, 25295, 32697, 32699, 32701, 32703, 34319, 34321, 34224, 34226
}

-- level doors
openLevelDoors = {
	1228, 1230, 1246, 1248, 1260, 1262, 3541, 3550, 5104, 5113, 5122, 5131, 5293, 5295, 6207, 6209, 6264,
	6266, 6897, 6906, 7039, 7048, 8556, 8558, 9180, 9182, 9282, 9284, 10283, 10285, 10474, 10483, 10781,
	10790, 12096, 12103, 12196, 12205, 19846, 19855, 19986, 19995, 20279, 20288, 22820, 22829, 25287, 25294
}
closedLevelDoors = {
	1227, 1229, 1245, 1247, 1259, 1261, 3540, 3549, 5103, 5112, 5121, 5130, 5292, 5294, 6206, 6208, 6263,
	6265, 6896, 6905, 7038, 7047, 8555, 8557, 9179, 9181, 9281, 9283, 10282, 10284, 10473, 10482, 10780,
	10789, 12095, 12102, 12195, 12204, 19845, 19854, 19985, 19994, 20278, 20287, 22819, 22828, 25286, 25293
}

-- irregularities
local openOddDoors = {
	[12695] = { locked = 13237, closed = 12692 },
	[12703] = { locked = 13236, closed = 12701 },
	[14635] = { locked = 14634, closed = 14633 },
	[17435] = { locked = 14641, closed = 14640 },
	[26533] = { locked = 26530, closed = 26529 },
	[26534] = { locked = 26532, closed = 26531 },
	[31176] = { locked = 31175, closed = 27559 },
	[31024] = { locked = 31021, closed = 31020 },
	[31025] = { locked = 31023, closed = 31022 },
	[31541] = { locked = 31314, closed = 31314 },
	[31542] = { locked = 31315, closed = 31315 },
	[32691] = { locked = 32705, closed = 32689 },
	[32692] = { locked = 32706, closed = 32690 },
	[32695] = { locked = 32707, closed = 32693 },
	[32696] = { locked = 32708, closed = 32694 },
	[33432] = { locked = 33429, closed = 33428 },
	[33433] = { locked = 33431, closed = 33430 },
	[33493] = { locked = 33490, closed = 33489 },
	[33494] = { locked = 33492, closed = 33491 },
	[34152] = { locked = 34150, closed = 34150 },
	[34153] = { locked = 34151, closed = 34151 },
	[36292] = { locked = 36289, closed = 36288 },
	[36293] = { locked = 36291, closed = 36290 },
	[37596] = { locked = 37593, closed = 37592 },
	[37597] = { locked = 37595, closed = 37594 },	
	[39119] = { locked = 39116, closed = 39115 },
	[39120] = { locked = 39118, closed = 39117 }
}
local closedOddDoors = {	
	[12692] = { locked = 13237, open = 12695 },
	[12701] = { locked = 13236, open = 12703 },
	[14633] = { locked = 14634, open = 14635 },
	[14640] = { locked = 14641, open = 17435 },
	[26529] = { locked = 26530, open = 26533 },
	[26531] = { locked = 26532, open = 26534 },
	[27559] = { locked = 31175, open = 31176 },
	[31020] = { locked = 31021, open = 31024 },
	[31022] = { locked = 31023, open = 31025 },
	[31314] = { locked = 31314, open = 31541 },
	[31315] = { locked = 31315, open = 31542 },
	[32689] = { locked = 32705, open = 32691 },
	[32690] = { locked = 32706, open = 32692 },
	[32693] = { locked = 32707, open = 32695 },
	[32694] = { locked = 32708, open = 32696 },
	[33428] = { locked = 33429, open = 33432 },
	[33430] = { locked = 33431, open = 33433 },
	[33489] = { locked = 33490, open = 33493 },
	[33491] = { locked = 33492, open = 33494 },
	[34150] = { locked = 34150, open = 34152 },
	[34151] = { locked = 34151, open = 34153 },
	[36288] = { locked = 36289, open = 36292 },
	[36290] = { locked = 36291, open = 36293 },
	[37592] = { locked = 37593, open = 37596 },
	[37594] = { locked = 37595, open = 37597 },
	[39115] = { locked = 39116, open = 39119 },
	[39117] = { locked = 39118, open = 39120 }
}
local lockedOddDoors = {
	[13237] = { closed = 12692, open = 12695 },
	[13236] = { closed = 12701, open = 12703 },
	[14634] = { closed = 14633, open = 14635 },
	[14641] = { closed = 14640, open = 17435 },
	[26530] = { closed = 26529, open = 26533 },
	[26532] = { closed = 26531, open = 26534 },
	[31175] = { closed = 27559, open = 31176 },	
	[31021] = { closed = 31020, open = 31024 },
	[31023] = { closed = 31022, open = 31025 },
	[32705] = { closed = 32689, open = 32691 },
	[32706] = { closed = 32690, open = 32692 },
	[32707] = { closed = 32693, open = 32695 },
	[32708] = { closed = 32694, open = 32696 },
	[33429] = { closed = 33428, open = 33432 },
	[33431] = { closed = 33430, open = 33433 },
	[33490] = { closed = 33489, open = 33493 },
	[33492] = { closed = 33491, open = 33494 },
	[36289] = { closed = 36288, open = 36292 },
	[36291] = { closed = 36290, open = 36293 },
	[37593] = { closed = 37592, open = 37596 },
	[37595] = { closed = 37594, open = 37597 },
	[39116] = { closed = 39115, open = 39119 },
	[39118] = { closed = 39117, open = 39120 }
}

local positionOffsets = {
	{x = 1, y = 0}, -- east
	{x = 0, y = 1}, -- south
	{x = -1, y = 0}, -- west
	{x = 0, y = -1}, -- north
}

--[[
When closing a door with a creature in it findPushPosition will find the most appropriate
adjacent position following a prioritization order.
The function returns the position of the first tile that fulfills all the checks in a round.
The function loops trough east -> south -> west -> north on each following line in that order.
In round 1 it checks if there's an unhindered walkable tile without any creature.
In round 2 it checks if there's a tile with a creature.
In round 3 it checks if there's a tile blocked by a movable tile-blocking item.
In round 4 it checks if there's a tile blocked by a magic wall or wild growth.
]]
local function findPushPosition(creature, round)
	local pos = creature:getPosition()
	for _, offset in ipairs(positionOffsets) do
		local offsetPosition = Position(pos.x + offset.x, pos.y + offset.y, pos.z)
		local tile = Tile(offsetPosition)
		if tile then
			local creatureCount = tile:getCreatureCount()
			if round == 1 then
				if tile:queryAdd(creature) == RETURNVALUE_NOERROR and creatureCount == 0 then
					if not tile:hasFlag(TILESTATE_PROTECTIONZONE) or (tile:hasFlag(TILESTATE_PROTECTIONZONE) and creature:canAccessPz()) then
						return offsetPosition
					end
				end
			elseif round == 2 then
				if creatureCount > 0 then
					if not tile:hasFlag(TILESTATE_PROTECTIONZONE) or (tile:hasFlag(TILESTATE_PROTECTIONZONE) and creature:canAccessPz()) then
						return offsetPosition
					end
				end
			elseif round == 3 then
				local topItem = tile:getTopDownItem()
				if topItem then
					if topItem:getType():isMovable() then
						return offsetPosition
					end
				end
			else
				if tile:getItemById(ITEM_MAGICWALL) or tile:getItemById(ITEM_WILDGROWTH) then
					return offsetPosition
				end
			end
		end
	end
	if round < 4 then
		return findPushPosition(creature, round + 1)
	end
end

local function passDoorRetro(player, item)
	local pos = player:getPosition()
	local topos = item:getPosition()
	
	if pos.x == topos.x then
		if pos.y < topos.y then
			pos.y = topos.y + 1
		else
			pos.y = topos.y - 1
		end
	elseif pos.y == topos.y then
		if pos.x < topos.x then
			pos.x = topos.x + 1
		else
			pos.x = topos.x - 1
		end
	else
		player:sendTextMessage(MESSAGE_INFO_DESCR, "Stand in front of the door.")
		return
	end

	if player:isPzLocked() then
		local tile = Tile(topos)
		if tile and tile:hasFlag(TILESTATE_PROTECTIONZONE) then
			player:sendCancelMessage(RETURNVALUE_PLAYERISPZLOCKED)
			return
		end
	end
	
	player:teleportTo(pos)
	topos:sendMagicEffect(CONST_ME_MAGIC_RED)
end

do
	local door = Action()
	function door.onUse(player, item, fromPosition, target, toPosition, isHotkey)
		local itemId = item:getId()
		local transformTo = 0
		if table.contains(closedQuestDoors, itemId) then
			if player:getStorageValue(item.actionid) ~= -1 or player:getGroup():getAccess() then
				if retroMode then
					passDoorRetro(player, item)
				else
					if player:isPzLocked() then
						local tile = Tile(toPosition)
						if tile and tile:hasFlag(TILESTATE_PROTECTIONZONE) then
							player:sendCancelMessage(RETURNVALUE_PLAYERISPZLOCKED)
							return true
						end
					end
					
					item:transform(itemId + 1)
					player:teleportTo(toPosition, true)
				end
			else
				player:sendTextMessage(MESSAGE_INFO_DESCR, "The door seems to be sealed against unwanted intruders.")
			end
			return true
		elseif table.contains(closedLevelDoors, itemId) then
			if item.actionid > 0 and player:getLevel() >= item.actionid - actionIds.levelDoor or player:getGroup():getAccess() then
				if retroMode then
					passDoorRetro(player, item)
				else
					if player:isPzLocked() then
						local tile = Tile(toPosition)
						if tile and tile:hasFlag(TILESTATE_PROTECTIONZONE) then
							player:sendCancelMessage(RETURNVALUE_PLAYERISPZLOCKED)
							return true
						end
					end
					
					item:transform(itemId + 1)
					player:teleportTo(toPosition, true)
				end
			else
				player:sendTextMessage(MESSAGE_INFO_DESCR, "Only the worthy may pass.")
			end
			return true
		elseif table.contains(keys, itemId) then
			local tile = Tile(toPosition)
			if not tile then
				return false
			end
			target = tile:getTopVisibleThing()
			if target.actionid == 0 then
				return false
			end
			if table.contains(keys, target.itemid) then
				return false
			end
			if not table.contains(openDoors, target.itemid) and not table.contains(closedDoors, target.itemid) and not table.contains(lockedDoors, target.itemid) then
				return false
			end
			if item.actionid ~= target.actionid then
				player:sendTextMessage(MESSAGE_STATUS_SMALL, "The key does not match.")
				return true
			end
			if lockedOddDoors[target.itemid] then
				transformTo = lockedOddDoors[target.itemid].open
			else
				transformTo = target.itemid + 2
			end
			if table.contains(openDoors, target.itemid) then
				if openOddDoors[target.itemid] then
					transformTo = openOddDoors[target.itemid].locked
				else
					transformTo = target.itemid - 2
				end
			elseif table.contains(closedDoors, target.itemid) then
				if closedOddDoors[target.itemid] then
					transformTo = closedOddDoors[target.itemid].locked
				else
					transformTo = target.itemid - 1
				end
			end
			target:transform(transformTo)
			return true
		elseif table.contains(lockedDoors, itemId) then
			player:sendTextMessage(MESSAGE_INFO_DESCR, "It is locked.")
			return true
		elseif table.contains(openDoors, itemId) or table.contains(openExtraDoors, itemId) or table.contains(openHouseDoors, itemId) then
			local creaturePositionTable = {}
			local doorCreatures = Tile(toPosition):getCreatures()
			if doorCreatures and #doorCreatures > 0 then
				for _, doorCreature in pairs(doorCreatures) do
					local pushPosition = findPushPosition(doorCreature, 1)
					if not pushPosition then
						player:sendCancelMessage(RETURNVALUE_NOTENOUGHROOM)
						return true
					end
					table.insert(creaturePositionTable, {creature = doorCreature, position = pushPosition})
				end
				for _, tableCreature in ipairs(creaturePositionTable) do
					tableCreature.creature:teleportTo(tableCreature.position, true)
				end
			end

			if openOddDoors[itemId] then
				transformTo = openOddDoors[itemId].closed
			else
				transformTo = itemId - 1
			end
			item:transform(transformTo)
			return true
		elseif table.contains(closedDoors, itemId) or table.contains(closedExtraDoors, itemId) or table.contains(closedHouseDoors, itemId) then
			if closedOddDoors[itemId] then
				transformTo = closedOddDoors[itemId].open
			else
				transformTo = itemId + 1
			end
			
			-- autolock in houses
			if item.actionid ~= 0 then
				local tile = item:getTile()
				if tile then
					local house = tile:getHouse()
					if house then
						if retroMode then
							passDoorRetro(player, item)
						else
							if player:isPzLocked() then
								if tile:hasFlag(TILESTATE_PROTECTIONZONE) then
									player:sendCancelMessage(RETURNVALUE_PLAYERISPZLOCKED)
									return true
								end
							end
							
							item:transform(transformTo)
							player:teleportTo(toPosition, true)
						end
						return true
					end
				end
			end
		
			item:transform(transformTo)
			return true
		end
		return false
	end

	local doorTables = {keys, openDoors, closedDoors, lockedDoors, openExtraDoors, closedExtraDoors, openHouseDoors, closedHouseDoors, closedQuestDoors, closedLevelDoors}
	for _, doors in pairs(doorTables) do
		for _, doorId in pairs(doors) do
			door:id(doorId)
		end
	end
	door:register()
end

local function canEnterAutolockedDoor(player, house, doorId)
	return house:isInAccessList(player, doorId) or player:getAccountId() == house:getOwnerAccountId() or house:isInAccessList(player, SUBOWNER_LIST)
end

do
	local doorEvent = MoveEvent()
	doorEvent:type("stepin")
	function doorEvent.onStepIn(creature, item, position, fromPosition)
		if not creature:isPlayer() then
			return false
		end
		
		if creature:getGroup():getAccess() then
			return true
		end
		
		if table.contains(openQuestDoors, item.itemid) then
			if creature:getStorageValue(item.actionid) == -1 then
				creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The door seems to be sealed against unwanted intruders.")
				creature:teleportTo(fromPosition, true)
				return false
			end
		elseif table.contains(openLevelDoors, item.itemid) then
			if creature:getLevel() < item.actionid - actionIds.levelDoor then
				creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Only the worthy may pass.")
				creature:teleportTo(fromPosition, true)
				return false
			end
		-- autolock in houses
		elseif item.actionid ~= 0 then
			local tile = item:getTile()
			if tile then
				local house = tile:getHouse()
				if house then
					local doorId = item:getAttribute(ITEM_ATTRIBUTE_DOORID)
					if doorId ~= 0 and not canEnterAutolockedDoor(creature, house, doorId) then
						creature:sendCancelMessage(RETURNVALUE_PLAYERISNOTINVITED)
						creature:teleportTo(fromPosition, true)
						return false
					end
				end
			end
		end
		
		return true
	end

	local doorTables = {openDoors, openExtraDoors, openHouseDoors, openLevelDoors, openQuestDoors}
	for _, doors in pairs(doorTables) do
		for _, doorId in pairs(doors) do
			doorEvent:id(doorId)
		end
	end
	doorEvent:register()
end

do
	local doorEvent = MoveEvent()
	doorEvent:type("stepout")
	function doorEvent.onStepOut(creature, item, position, fromPosition)
		local tile = Tile(position)
		if tile:getCreatureCount() > 0 then
			return true
		end

		-- house doors with autolock
		if not (table.contains(openLevelDoors, item.itemid) or table.contains(openQuestDoors, item.itemid)) then
			local house = tile:getHouse()
			if not house then
				return true
			end
			
			if item.actionid == 0 then
				return true
			end
		end

		local newPosition = {x = position.x + 1, y = position.y, z = position.z}
		local query = Tile(newPosition):queryAdd(creature)
		if query ~= RETURNVALUE_NOERROR or query == RETURNVALUE_NOTENOUGHROOM then
			newPosition.x = newPosition.x - 1
			newPosition.y = newPosition.y + 1
			query = Tile(newPosition):queryAdd(creature)
		end

		if query == RETURNVALUE_NOERROR or query ~= RETURNVALUE_NOTENOUGHROOM then
			doRelocate(position, newPosition)
		end

		local i, tileItem, tileCount = 1, true, tile:getThingCount()
		while tileItem and i < tileCount do
			tileItem = tile:getThing(i)
			if tileItem and tileItem:getUniqueId() ~= item.uid and tileItem:getType():isMovable() then
				tileItem:remove()
			else
				i = i + 1
			end
		end

		if openOddDoors[item.itemid] then
			transformTo = openOddDoors[item.itemid].closed
		else
			transformTo = item.itemid - 1
		end
		
		item:transform(transformTo)
		return true
	end
	
	local doorTables = {openDoors, openExtraDoors, openHouseDoors, openLevelDoors, openQuestDoors}
	for _, doors in pairs(doorTables) do
		for _, doorId in pairs(doors) do
			doorEvent:id(doorId)
		end
	end
	doorEvent:register()
end

-- talkaction !autolock
local autolockActionId = 1000
local talk = TalkAction("/autolock", "!autolock")
function talk.onSay(player, words, param)
	local creaturePos = player:getPosition()
	creaturePos:getNextPosition(player:getDirection())
	local tile = Tile(creaturePos)
	local house = tile and tile:getHouse()
	local doorId = house and house:getDoorIdByPosition(creaturePos)
	if not doorId or not house:canEditAccessList(doorId, player) then
		player:sendColorMessage("Access denied.", MESSAGE_COLOR_PURPLE)
		return false
	end

	local itemCount = 0
	for _, item in pairs(tile:getItems()) do
		if item:getType():isDoor() then
			local newState = item:getActionId() == 0
			if newState then
				item:setActionId(autolockActionId)
			else
				item:removeAttribute(ITEM_ATTRIBUTE_ACTIONID)
			end
			player:sendColorMessage(string.format("Auto locking %s.", newState and "enabled" or "disabled"), MESSAGE_COLOR_PURPLE)
		end
	
		if itemCount > 10 then
			player:sendColorMessage("Access denied.", MESSAGE_COLOR_PURPLE)
			return false
		end
		
		itemCount = itemCount + 1
	end
	
	return false
end

talk:register()
