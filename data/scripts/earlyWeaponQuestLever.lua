local stonePos = {x = 504, y = 1399, z = 12}
local stoneId = 1304

local lever_off = 1945
local lever_on = 1946

local soundStoneMove = 1180
local soundMechanismMove = 2689
local soundLeverMove = 2800
local soundLeverBlocked = 2065
local soundsToPlay = {
	-- soundId, pitch
	[soundLeverMove] = 2,
	[soundMechanismMove] = 2
}

local gateDuration = 180 * 1000

local function resetQuest(uid)
	local sp = Position(stonePos)
	Game.createItem(1304, 1, sp)
	sp:sendMagicEffect(CONST_ME_POFF)
	sp:playSound(soundStoneMove, 0)
	local item = Item(uid)
	if item then
		item:transform(lever_off)
		item:getPosition():playSoundMulti(soundsToPlay)
		item:getPosition():sendMagicEffect(CONST_ME_BLOCKHIT)
	end
end

local earlyWeaponQuestLever = Action()
function earlyWeaponQuestLever.onUse(player, item)
	local itPos = item:getPosition()
	if item.itemid == lever_off then
		item:transform(lever_on)
		itPos:playSoundMulti(soundsToPlay)
		itPos:sendMagicEffect(CONST_ME_BLOCKHIT)
		local stone = Tile(Position(stonePos)):getItemById(stoneId)
		if stone then
			local sp = Position(stonePos)
			sp:playSound(soundStoneMove, 2, 40, 30)
			sp:sendMagicEffect(CONST_ME_POFF)
			
			local ppos = player:getPosition()
			player:say("*RUMBLE*", TALKTYPE_MONSTER_SAY, false, nil, Position(ppos.x - 8, ppos.y - 6, ppos.z))
			stone:remove()
			addEvent(resetQuest, gateDuration, item.uid)
		end
	else
		player:say("The lever won't budge.", TALKTYPE_MONSTER_SAY, false, player)
		player:playSound(soundLeverBlocked, 0, itPos)
	end
	
	return true
end
earlyWeaponQuestLever:uid(1008)
earlyWeaponQuestLever:register()
