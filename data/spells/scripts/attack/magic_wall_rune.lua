local id = ITEM_MAGICWALL
local combat = Combat()
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ENERGY)
combat:setParameter(COMBAT_PARAM_CREATEITEM, id)

local function tile_timer(id, pos, delay, color)
	if getTileItemById(pos, id).uid == 0 then
		return true
	end
	
	if delay ~= 1 then
		addEvent(tile_timer, 1000, id, pos, delay - 1, color)
	end
   
	local people = Game.getSpectators(pos, 5, 5, 7, 7, false, true)
	if not people then
		return true
	end
	
	for i = 1, #people do
		people[i]:sendTextMessage(MESSAGE_EXPERIENCE_OTHERS, "Magic wall will disappear in " .. delay .. " second" .. (delay > 1 and "s" or "") .. ".", pos, delay, color)
	end
end

local function removeMw(pos, mw, wall)
	local tile = Tile(pos)
	mw = tile:getItemById(mw)
	wall = tile:getItemById(wall)
	if mw then mw:remove() end
	if wall then wall:remove() end
end

function onCastSpell(creature, var, isHotkey)
	local c = combat:execute(creature, var)
	if c then
		local pos = variantToPosition(var)
		local wall = Game.createItem(12550, 1, pos)
		addEvent(removeMw, 20000, pos, id, wall:getId())
		tile_timer(id, pos, 20, TEXTCOLOR_LIGHTBLUE)
	end
	return c
end
