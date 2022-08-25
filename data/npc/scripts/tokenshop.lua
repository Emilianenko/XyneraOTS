local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)              npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)           npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)    end
function onThink()                          npcHandler:onThink()                        end

npcHandler:setMessage(MESSAGE_GREET, "Greetings |PLAYERNAME|. I sell {imbuing components}.")

local offerList = {}
local offerListIndex = {}
local topic = {}
local currency = ItemType("Gold Token"):getId()

local offerCategoriesRoot = {"skill boosts", "damage conversion", "protection", "other"}
local offerCategoriesOther = {"strike", "vampirism", "void", "swiftness", "featherweight", "vibrancy"}
local offerCategoriesDamage = {"reap", "venom", "electrify", "scorch", "purify", "frost", "wound"}
local offerCategoriesProtection = {"lich shroud", "snake skin", "cloud fabric", "dragon hide", "demon presence", "quara scale", "hardening"}
local offerCategoriesSkillBoost = {"epiphany", "punch", "bash", "slash", "chop", "precision", "blockade"}

if ImbuingAltar then
	for altarId = 1, #ImbuingAltar do
		local altarData = ImbuingAltar[altarId]
		
		for tier = 1, 3 do
			local imbuType = ImbuementType(altarData.baseId + tier - 1)
			local name = imbuType:name()
			if name then
				name = name:lower()
				offerList[name] = {}
				offerListIndex[#offerListIndex+1] = name
				for i = 1, tier do
					if altarData.products[i] then
						offerList[name][i] = altarData.products[i]
					end
				end
			end
		end
	end
else
	Game.sendConsoleMessage(CONSOLEMESSAGE_TYPE_WARNING, "Unable to load ImbuingAltar for token NPC")
end

function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	msg = msg:lower()

	local player = Player(cid)
	if topic[cid] then
		if msgcontains(msg, 'yes') then
			local price = 3
			if topic[cid]:find("intricate") then
				price = 2
			elseif topic[cid]:find("basic") then
				price = 1
			end

			if player:getItemCount(currency) >= price * 2 then
				player:removeItem(currency, price * 2)
				local offer = offerList[topic[cid]]
				for i = 1, price do
					player:addItem(offer[i][1], offer[i][2])
				end
				npcHandler:say('Here you are.', cid)
			else
				npcHandler:say('You do not have enough tokens.', cid)
			end
		else
			npcHandler:say('Then not.', cid)
		end
		
		topic[cid] = nil
		return true
	end
	
	if msgcontains(msg, 'imbuing') or msgcontains(msg, 'ingredients') then
		npcHandler:say(string.format("I offer ingredients for basic, intricate and powerful imbuements for categories: {%s}", table.concat(offerCategoriesRoot, "}, {")), cid)
		return true
	elseif msgcontains(msg, 'damage') then
		npcHandler:say(string.format("I offer ingredients for: {%s}", table.concat(offerCategoriesDamage, "}, {")), cid)
		return true
	elseif msgcontains(msg, 'protection') then
		npcHandler:say(string.format("I offer ingredients for: {%s}", table.concat(offerCategoriesProtection, "}, {")), cid)
		return true
	elseif msgcontains(msg, 'skill') or msgcontains(msg, 'boost') then
		npcHandler:say(string.format("I offer ingredients for: {%s}", table.concat(offerCategoriesSkillBoost, "}, {")), cid)
		return true
	elseif msgcontains(msg, 'other') then
		npcHandler:say(string.format("I offer ingredients for: {%s}", table.concat(offerCategoriesOther, "}, {")), cid)
		return true
	else
		for _, categorySet in pairs({offerCategoriesRoot, offerCategoriesDamage, offerCategoriesProtection, offerCategoriesSkillBoost, offerCategoriesOther}) do
			if table.contains(categorySet, msg) then
				npcHandler:say(string.format("I can offer {basic %s}, {intricate %s} and {powerful %s}", msg, msg, msg), cid)
			end
		end
	end
	
	if offerList[msg] then
		local price = 3
		if msg:find("intricate") then
			price = 2
		elseif msg:find("basic") then
			price = 1
		end
		
		local cost = string.format("%d %s", price * 2, ItemType(currency):getPluralName())
		npcHandler:say(string.format('Would you like to buy ingredients for %s for %s?', msg, cost), cid)
		topic[cid] = msg
	end

	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
