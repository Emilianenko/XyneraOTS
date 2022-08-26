local blessings = {
	[BLESSING_WISDOM] = "Wisdom of Solitude",
	[BLESSING_SPARK] = "Spark of the Phoenix",
	[BLESSING_FIRE] = "Fire of the Suns",
	[BLESSING_SPIRITUAL] = "Spiritual Shielding",
	[BLESSING_EMBRACE] = "Embrace of the World",
	[BLESSING_TWIST] = "Twist of Fate",
	[BLESSING_HEART] = "Heart of the Mountain",
	[BLESSING_BLOOD] = "Blood of the Mountain"
}

local checkBless = Action()

function checkBless.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local message = {"Received blessings:"}
	for i, blessing in pairs(blessings) do
		if player:hasBlessing(i) then
			message[#message + 1] = blessing
		end
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, #message == 1 and "No blessings received." or table.concat(message, '\n'))
	return true
end

checkBless:id(12424, 6561)
checkBless:register()
