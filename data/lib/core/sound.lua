function Player:playSound(soundId, pitch, pos)
	if not pitch or pitch > 2 or pitch < 0 then
		pitch = 0
	end
	
	local msg = NetworkMessage()
	if pos then
		local playerPos = self:getPosition()
		local realX = math.min(playerPos.x + 7, math.max(playerPos.x - 7, pos.x))
		local realY = math.min(playerPos.y + 5, math.max(playerPos.y - 5, pos.y))
		msg:addByte(0x83)
		msg:addPosition(Position(realX, realY, playerPos.z))
		msg:addByte(6)
		msg:addByte(pitch)
		msg:addU16(soundId)
		msg:addByte(0)
	else
		msg:addByte(0x85)
		msg:addByte(2)
		msg:addU16(soundId)
	end
	
	msg:sendToPlayer(self)
end


function Position:playSound(soundId, pitch, rangeX, rangeY, multiFloor)
	if not pitch or pitch > 2 or pitch < 0 then
		pitch = 0
	end

	local spec = Game.getSpectators(self, multiFloor, true, rangeX or 7, rangeX or 7, rangeY or 5, rangeY or 5)
	if spec then
		for _, target in pairs(spec) do
			target:playSound(soundId, pitch, self)
		end
	end
end

function Position:playSoundMulti(sounds)
	local msg = NetworkMessage()
	msg:addByte(0x83)
	msg:addPosition(self)
	for k, v in pairs(sounds) do
		msg:addByte(6)
		msg:addByte(v)
		msg:addU16(k)
	end
	msg:addByte(0)

	local spec = Game.getSpectators(self, multiFloor, true, rangeX or 7, rangeX or 7, rangeY or 5, rangeY or 5)
	if spec then
		for _, target in pairs(spec) do
			msg:sendToPlayer(target)
		end
	end
end
