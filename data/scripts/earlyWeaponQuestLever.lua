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
	end
end

local earlyWeaponQuestLever = Action()
function earlyWeaponQuestLever.onUse(player, item)
	if item.itemid == lever_off then
		item:transform(lever_on)
		item:getPosition():playSoundMulti(soundsToPlay)
		
		local stone = Tile(Position(stonePos)):getItemById(stoneId)
		if stone then
			local sp = Position(stonePos)
			sp:playSound(soundStoneMove, 2, 40, 30)
			sp:sendMagicEffect(CONST_ME_POFF)
			player:say("*RUMBLE*", TALKTYPE_MONSTER_SAY, false, nil, sp)
			stone:remove()
			addEvent(resetQuest, gateDuration, item.uid)
		end
	else
		player:say("The lever won't budge.", TALKTYPE_MONSTER_SAY, false, player)
		item:getPosition():playSound(soundLeverBlocked, 0)
	end
	
	return true
end
earlyWeaponQuestLever:uid(1008)
earlyWeaponQuestLever:register()
