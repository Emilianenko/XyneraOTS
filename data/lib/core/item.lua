function Item:getType()
	return ItemType(self:getId())
end

function Item:getClientId()
	return self:getType():getClientId()
end

function Item:getClassification()
	return self:getType():getClassification()
end

-- polymorphism for "look" method, not a compat
Item.getDuration = Item.getDurationLeft

function Item:isContainer()
	return false
end

function Item:isCreature()
	return false
end

function Item:isMonster()
	return false
end

function Item:isNpc()
	return false
end

function Item:isPlayer()
	return false
end

function Item:isTeleport()
	return false
end

function Item:isPodium()
	return false
end

function Item:isHirelingLamp()
	return self:getType():isHirelingLamp()
end

function Item:isRewardBag()
	return self:getType():isRewardBag()
end

function Item:isTile()
	return false
end

function Item:isCorpse()
	return self:getType():isCorpse()
end

function Item:isItemType()
	return false
end

function Item:isSupply()
	return self:getType():isSupply()
end

function Item:isCurrency()
	return self:getType():isCurrency()
end

function Item:getRelativePosition(player)
	local topParent = self:getTopParent()
	if topParent then
		if topParent:isPlayer() then
			local parent = self:getParent()
			if parent then
				if parent:isPlayer() then
					for slotId = CONST_SLOT_FIRST, CONST_SLOT_LAST do
						if self == player:getSlotItem(slotId) then
							return Position(CONTAINER_POSITION, slotId, 0)
						end
					end
				elseif parent:isContainer() then
					local contId = player:getContainerId(parent)
					if contId and contId > -1 then
						for index, item in pairs(parent:getItems()) do
							if self == item then
								return Position(CONTAINER_POSITION, 64 + contId, index - 1)
							end
						end
					end
				end
				
				return false
			end
		elseif topParent:isTile() then
			return self:getPosition()
		end
	end

	return false
end

function Item:pauseDecay()
	if self:getAttribute(ITEM_ATTRIBUTE_DURATION) == 0 or self:getAttribute(ITEM_ATTRIBUTE_DECAYTO) == -1 then
		return false
	end
	
	local decayId = self:getAttribute(ITEM_ATTRIBUTE_DECAYTO)
	self:setAttribute(ITEM_ATTRIBUTE_DECAYTO, -1)
	self:setAttribute(ITEM_ATTRIBUTE_DECAYSTATE, 0)
	self:setCustomAttribute("targetDecayId", decayId)
	return true
end

function Item:resumeDecay()
	local decayId = self:getAttribute(ITEM_ATTRIBUTE_DECAYTO)
	if decayId <= 0 then
		local decayAttr = self:getCustomAttribute("targetDecayId")
		decayId = decayAttr or math.max(decayId, self:getType():getDecayId())
	end
	
	self:removeCustomAttribute("targetDecayId")
	self:setAttribute(ITEM_ATTRIBUTE_DECAYTO, decayId)
	self:decay()
end

function Item:setTier(newTier)
	return newTier >= 0 and newTier < 256 and self:setAttribute(ITEM_ATTRIBUTE_TIER, newTier)
end

-- used interchangeably with ItemType:getAllReflects() for polymorphism in onLook
-- returns table with [combatId] = {chance = x, percent = y}
-- COMBAT_(element)DAMAGE = 2^combatId
function Item:getAllReflects()
	local response = {}
	for combatId = 0, 11 do
		response[combatId+1] = self:getReflect(2^combatId)
	end
	
	return response
end

-- same as above
function Item:getAllBoosts()
	local response = {}
	for combatId = 0, 11 do
		response[combatId+1] = self:getBoostPercent(2^combatId)
	end
	
	return response
end

do
	local aux = {
		['Defense'] = {key = ITEM_ATTRIBUTE_DEFENSE},
		['ExtraDefense'] = {key = ITEM_ATTRIBUTE_EXTRADEFENSE},
		['Attack'] = {key = ITEM_ATTRIBUTE_ATTACK},
		['AttackSpeed'] = {key = ITEM_ATTRIBUTE_ATTACK_SPEED},
		['HitChance'] = {key = ITEM_ATTRIBUTE_HITCHANCE},
		['ShootRange'] = {key = ITEM_ATTRIBUTE_SHOOTRANGE},
		['Armor'] = {key = ITEM_ATTRIBUTE_ARMOR},
		--['Duration'] = {key = ITEM_ATTRIBUTE_DURATION, cmp = function(v) return v > 0 end},
		['Text'] = {key = ITEM_ATTRIBUTE_TEXT, cmp = function(v) return v ~= '' end},
		['Date'] = {key = ITEM_ATTRIBUTE_DATE},
		['Writer'] = {key = ITEM_ATTRIBUTE_WRITER, cmp = function(v) return v ~= '' end},
		['Tier'] = {key = ITEM_ATTRIBUTE_TIER}
	}

	function setAuxFunctions()
		for name, def in pairs(aux) do
			Item['get'.. name] = function(self)
				local attr = self:getAttribute(def.key)
				if def.cmp and def.cmp(attr) then
					return attr
				elseif not def.cmp and attr and attr ~= 0 then
					return attr
				end
				local default = ItemType['get'.. name]
				return default and default(self:getType()) or nil
			end
		end
	end
	setAuxFunctions()
end

do
	StringStream = {}

	setmetatable(StringStream, {
		__call = function(self)
			local obj = {}
			return setmetatable(obj, {__index = StringStream})
		end
	})

	function StringStream.append(self, str, ...)
		self[#self+1] = string.format(str, ...)
	end

	function StringStream.concat(self, sep)
		return table.concat(self, sep)
	end

	local function internalItemGetNameDescription(it, item, subType, addArticle)
		subType = subType or (item and item:getSubType() or -1)
		local ss = StringStream()
		local obj = item or it
		local name = obj:getName()
		if name ~= '' then
			if it:isStackable() and subType >  1 then
				if it:hasShowCount() then
					ss:append('%d ', subType)
				end
				ss:append('%s', obj:getPluralName())
			else
				if addArticle and obj:getArticle() ~= '' then
					ss:append('%s ', obj:getArticle())
				end
				ss:append('%s', obj:getName())
			end
		else
			ss:append('an item of type %d', obj:getId())
		end
		return ss:concat()
	end

	function Item:getNameDescription(subType, addArticle)
		return internalItemGetNameDescription(self:getType(), self, subType, addArticle)
	end

	function ItemType:getNameDescription(subType, addArticle)
		return internalItemGetNameDescription(self, nil, subType, addArticle)
	end
end

do
	-- Lua item descriptions created by Zbizu
	local housePriceVisible = configManager.getBoolean(configKeys.HOUSE_DOOR_SHOW_PRICE)
	local pricePerSQM = configManager.getNumber(configKeys.HOUSE_PRICE)
	
	local showAtkWeaponTypes = {WEAPON_FIST, WEAPON_CLUB, WEAPON_SWORD, WEAPON_AXE, WEAPON_DISTANCE}
	local showDefWeaponTypes = {WEAPON_FIST, WEAPON_CLUB, WEAPON_SWORD, WEAPON_AXE, WEAPON_DISTANCE, WEAPON_SHIELD}
	local suppressedConditionNames = {
		-- NOTE: these names are made up just to match dwarven ring attribute style
		[CONDITION_POISON] = "antidote",
		[CONDITION_FIRE] = "non-inflammable",
		[CONDITION_ENERGY] = "antistatic",
		[CONDITION_BLEEDING] = "antiseptic",
		[CONDITION_HASTE] = "heavy",
		[CONDITION_PARALYZE] = "slow immunity",
		[CONDITION_DRUNK] = "hard drinking",
		[CONDITION_DROWN] = "water breathing",
		[CONDITION_FREEZING] = "warm",
		[CONDITION_DAZZLED] = "dazzle immunity",
		[CONDITION_CURSED] = "curse immunity"
	}
	
	-- items that will show special description at any distance
	local playerCorpses = {
		-- corpse m
		3058, 3059, 3060,
		
		-- corpse f
		3064, 3065, 3066,
	}
	
	-- first argument: Item, itemType or item id
	local function internalItemGetDescription(item, lookDistance, subType, addArticle)
		-- optional, but true by default
		if addArticle == nil then
			addArticle = true
		end
		
		local isVirtual = false -- check if we're inspecting a real item or itemType only
		local itemType
				
		-- determine the kind of item data to process
		if tonumber(item) then
			-- number in function argument
			-- pull data from itemType instead
			isVirtual = true
			itemType = ItemType(item)
			if not itemType then
				return
			end
			
			-- polymorphism for item attributes (atk, def, etc)
			item = itemType
		elseif item:isItemType() then
			isVirtual = true
			itemType = item
		else
			itemType = item:getType()
		end

		-- use default values if not provided
		lookDistance = lookDistance or -1
		subType = subType or (not isVirtual and item:getSubType() or -1)
				
		-- possibility of picking the item up (will be reused later)
		local isPickupable = itemType:isMovable() and itemType:isPickupable()

		-- has uniqueId tag
		local isUnique = false
		if not isVirtual then
			local uid = item:getUniqueId()
			if uid > 100 and uid < 0xFFFF then
				isUnique = true
			end
		end
				
		-- read item name with article
		local itemName = item:getNameDescription(subType, addArticle)
		
		-- things that will go in parenthesis "(...)"
		local descriptions = {}
				
		-- spell words
		do
			local spellName = itemType:getRuneSpellName()
			if spellName then
				descriptions[#descriptions + 1] = string.format('"%s"', spellName)
			end
		end
		
		-- container capacity
		do
			-- show container capacity only on non-quest containers
			if not isUnique then
				local isContainer = itemType:isContainer()
				if isContainer then
					descriptions[#descriptions + 1] = string.format("Vol:%d", itemType:getCapacity())
				end
			end
		end
		
		-- actionId (will be reused)
		local actionId = 0
		if not isVirtual then
			actionId = item:getActionId()
		end
		
		-- item group checks for later use
		local isDoor = itemType:isDoor()
		local isTeleport = itemType:isTeleport()
		local isPodium = itemType:isPodium()
		local isBed = itemType:isBed()
		local isKey = itemType:isKey()
		
		-- key
		do
			if not isVirtual and isKey then
				descriptions[#descriptions + 1] = string.format("Key:%0.4d", actionId)
			end
		end
			
		-- skip all these checks if not applicable
		if not (isDoor or isTeleport or isPodium or isBed or isKey) then
			
			-- weapon type (will be reused)
			local weaponType = itemType:getWeaponType()
			
			-- attack attributes
			do
				local attack = item:getAttack()

				-- bows and crossbows
				-- range, attack, hit%
				if itemType:isBow() then
					descriptions[#descriptions + 1] = string.format("Range:%d", item:getShootRange())
					
					if attack ~= 0 then
						descriptions[#descriptions + 1] = string.format("Atk:%+d", attack)
					end
					
					local hitPercent = item:getHitChance()
					if hitPercent ~= 0 then
						descriptions[#descriptions + 1] = string.format("Hit%%:%+d", hitPercent)
					end
					
				-- melee weapons and missiles
				-- atk x physical +y% element
				elseif table.contains(showAtkWeaponTypes, weaponType) then
					local atkString = string.format("Atk:%d", attack)
					local elementDmg = itemType:getElementDamage()
					if elementDmg ~= 0 then
						atkString = string.format("%s physical %+d %s", atkString, elementDmg, getCombatName(itemType:getElementType()))
					end
					
					descriptions[#descriptions + 1] = atkString
				end
			end
			
			-- attack speed
			do
				local atkSpeed = item:getAttackSpeed()
				if atkSpeed ~= 0 then
					descriptions[#descriptions + 1] = string.format("AS:%0.2f/turn", 2000 / atkSpeed)
				end
			end
			
			-- defense attributes
			do
				local showDef = table.contains(showDefWeaponTypes, weaponType)
				local ammoType = itemType:getAmmoType()
				if showDef then
					local defense = item:getDefense()
					local defAttrs = {}
					if weaponType == WEAPON_DISTANCE then
						-- throwables
						if ammoType ~= AMMO_ARROW and ammoType ~= AMMO_BOLT then
							defAttrs[#defAttrs + 1] = defense
						end
					else
						defAttrs[#defAttrs + 1] = defense
					end
					
					-- extra def
					local xD = item:getExtraDefense()
					if xD ~= 0 then
						defAttrs[#defAttrs + 1] = string.format("%+d", xD)
					end
					
					if #defAttrs > 0 then
						descriptions[#descriptions + 1] = string.format("Def:%s", table.concat(defAttrs, " "))
					end
				end
			end

			-- armor
			do
				local arm = item:getArmor()
				if arm > 0 then
					descriptions[#descriptions + 1] = string.format("Arm:%d", arm)
				end
			end
			
			-- abilities (will be reused)
			local abilities = itemType:getAbilities()
			
			-- stats: hp/mp/soul/magic level/cap
			do
				local stats = {}
				-- flat buffs
				for stat, value in pairs(abilities.stats) do
					stats[stat] = {name = getStatName(stat-1)}
					if value ~= 0 then
						stats[stat].flat = value
					end
				end
				
				-- percent buffs
				for stat, value in pairs(abilities.statsPercent) do
					if value ~= 0 then
						stats[stat].percent = value
					end
				end
				
				-- display the buffs
				for stat, statData in pairs(stats) do
					local displayValues = {}
					if statData.flat then
						if stat ~= STAT_CAPACITY+1 then
							displayValues[1] = string.format("%+d", statData.flat)
						else
							displayValues[1] = string.format("%+d", statData.flat/100)
						end
					end
					
					if statData.percent then
						displayValues[#displayValues + 1] = string.format("%d%%", statData.percent - 100)
					end
					
					-- desired format examples:
					-- +5%
					-- +20 and 5%
					if #displayValues > 0 then
						descriptions[#descriptions + 1] = string.format("%s %s", statData.name, table.concat(displayValues, " and "))
					end
				end
			end
					
			-- skill boosts
			do
				for skill, value in pairs(abilities.skills) do
					if value ~= 0 then
						descriptions[#descriptions + 1] = string.format("%s %+d", getSkillName(skill-1), value)
					end
				end
			end
			
			-- element magic level
			do
				for element, value in pairs(abilities.specialMagicLevel) do
					if value ~= 0 then
						descriptions[#descriptions + 1] = string.format("%s magic level %+d", getCombatName(2^(element-1)), value)
					end
				end
			end
			
			-- flat damage reflection
			if abilities.reflectDamage ~= 0 then
				descriptions[#descriptions + 1] = string.format("%d damage reflection", abilities.reflectDamage)
			end
			
			-- special skills
			do
				for skill, value in pairs(abilities.specialSkills) do
					if value ~= 0 then
						-- add + symbol to special skill "amount" fields
						if skill-1 < 6 and skill % 2 == 1 then
							value = string.format("%+d", value)
						elseif skill-1 >= 6 then
							-- fatal, dodge, momentum coming from the item natively
							-- (stats coming from tier are near tier info)
							value = string.format("%0.2f", value/100)
						end
						
						descriptions[#descriptions + 1] = string.format("%s %s%%", getSpecialSkillName(skill-1), value)
					end
				end
			end
			
			-- cleave
			-- perfect shot
			-- to do
			
			-- protections
			do
				local protections = {}
				for element, value in pairs(abilities.absorbPercent) do
					if value ~= 0 then
						protections[#protections + 1] = string.format("%s %+d%%", getCombatName(2^(element-1)), value)
					end
				end
				
				if #protections > 0 then
					descriptions[#descriptions + 1] = string.format("protection %s", table.concat(protections, ", "))
				end
			end
			
			-- damage boosts
			do
				local boostInfo = item:getAllBoosts()
				local boosts = {}
				
				local allElements = true
														
				local identicalValue = true
				local currentValue = -1
								
				for combatId, boost in pairs(boostInfo) do
					if boost > 0 then
						boosts[#boosts + 1] = {element = getCombatName(2^(combatId-1)), percent = boost}
						if currentValue == -1 then
							currentValue = boost
						elseif currentValue ~= boost then
							identicalValue = false
						end
					else
						allElements = false
					end
				end
				
				if #boosts > 0 then
					local boostResponse = ""
					
					if allElements and identicalValue then
						-- all elements identical value
						-- display short info
						boostResponse = string.format("damage and healing %+d%%", boosts[1].percent)
					else
						local healString
						
						-- incomplete elements list/different values
						-- display full info
						local boostValues = {}
						for i = 1, #boosts do
							if boosts[i].element ~= "healing" then
								boostValues[#boostValues + 1] = string.format("%s %+d%%", boosts[i].element, boosts[i].percent)
							else
								healString = string.format("healing power %+d%%", boosts[i].percent)
							end
						end
						
						local boostResponseData = {}
						if #boostValues > 0 then
							boostResponseData[#boostResponseData + 1] = string.format("damage %s", table.concat(boostValues, ", "))
						end
						
						boostResponseData[#boostResponseData + 1] = healString
						boostResponse = table.concat(boostResponseData, ", ")
					end
														
					descriptions[#descriptions + 1] = boostResponse
				end
			end
			
			-- damage reflection
			do
				local reflectInfo = item:getAllReflects()
				local reflects = {}
				
				local allElements = true
														
				local identicalChance = true
				local currentChance = -1
														
				for combatId, reflect in pairs(reflectInfo) do
					if reflect.chance > 0 and reflect.percent > 0 then
						reflects[#reflects + 1] = {element = getCombatName(2^(combatId-1)), percent = reflect.percent, chance = reflect.chance}
						
						if currentChance == -1 then
							currentChance = reflect.chance
						elseif currentChance ~= reflect.chance then
							identicalChance = false
						end
					else
						allElements = false
					end
				end
				
				if #reflects > 0 then
					local reflectResponse = ""
					
					if allElements and identicalChance then
						-- chance and amount are identical
						-- display single values for chance and amount
						local chanceInfo = reflects[1].chance ~= 100 and string.format(" chance %d%%", reflects[1].chance) or ""
						reflectResponse = string.format("%+d%%%s", reflects[1].percent, chanceInfo)
						
					elseif identicalChance then
						-- incomplete elements list (chances still identical)
						-- display single value for chance only
						local reflectValues = {}
						for i = 1, #reflects do
							reflectValues[#reflectValues + 1] = string.format("%s %+d%%", reflects[i].element, reflects[i].percent)
						end
						
						local chanceInfo = reflects[1].chance ~= 100 and string.format(" chance %d%%", reflects[1].chance) or ""
						reflectResponse = string.format("%s%s", table.concat(reflectValues, ", "), chanceInfo)
					else
						-- chances or amounts are different
						-- display full info
						local reflectValues = {}
						for i = 1, #reflects do
							reflectValues[#reflectValues + 1] = string.format("%s %+d%% chance %d%%", reflects[i].element, reflects[i].percent, reflects[i].chance)
						end
						
						reflectResponse = table.concat(reflectValues, ", ")
					end
														
					descriptions[#descriptions + 1] = string.format("reflect %s", reflectResponse)
				end
			end
			
			-- magic shield (classic)
			if abilities.manaShield then
				descriptions[#descriptions + 1] = "magic shield"
			end
			
			-- magic shield capacity +flat and x%
			-- to do
			
			-- regeneration
			if abilities.manaGain > 0 or abilities.healthGain > 0 or abilities.regeneration then
				descriptions[#descriptions + 1] = "faster regeneration"
			end
			
			-- invisibility
			if abilities.invisible then
				descriptions[#descriptions + 1] = "invisibility"
			end
			
			-- condition immunities
			do
				local suppressions = abilities.conditionSuppressions
				for conditionId, conditionName in pairs(suppressedConditionNames) do
					if bit.band(abilities.conditionSuppressions, conditionId) ~= 0 then
						descriptions[#descriptions + 1] = conditionName
					end
				end			
			end
			
			-- speed
			if abilities.speed ~= 0 then
				descriptions[#descriptions + 1] = string.format("speed %+d", math.floor(abilities.speed / 2))
			end
		end
		
		-- collecting attributes finished
		-- build the output text
		local response = {itemName}
		
		-- item group (will be reused)
		local itemGroup = itemType:getGroup()
		
		-- fluid type
		do
			if (itemGroup == ITEM_GROUP_FLUID or itemGroup == ITEM_GROUP_SPLASH) and subType > 0 then
				local subTypeName = getSubTypeName(subType)
				response[#response + 1] = string.format(" of %s", (subTypeName ~= '' and subTypeName or "unknown"))
			end
		end
		
		-- door info
		if isDoor then
			if not isVirtual then
				local minLevelDoor = itemType:getLevelDoor()
				if minLevelDoor ~= 0 then
					if actionId >= minLevelDoor then
						response[#response + 1] = string.format(" for level %d", actionId - minLevelDoor)
					end
				end
			end
		end
		
		-- primary attributes parenthesis
		if #descriptions > 0 then
			response[#response + 1] = string.format(" (%s)", table.concat(descriptions, ", "))
		end

		-- podium description
		if not isVirtual and isPodium then
			local outfit = item:getOutfit()
			local hasOutfit = item:hasFlag(PODIUM_SHOW_OUTFIT)
			local hasMount = item:hasFlag(PODIUM_SHOW_MOUNT)
			if outfit then
				local podiumParts = {}
				local outfitType = Outfit(outfit.lookType)
				if outfitType then
					if hasOutfit then
						podiumParts[#podiumParts + 1] = string.format("%s outfit", outfitType.name)
					end
					
					-- search mount
					local mountName = getMountNameByLookType(outfit.lookMount)
					if mountName and hasMount then
						podiumParts[#podiumParts + 1] = string.format("%s mount", mountName)
					end
				else
					-- search mount
					local mountName = getMountNameByLookType(outfit.lookMount)
					local isEnabled = mountName and hasMount
					if not mountName then
						mountName = getMountNameByLookType(outfit.lookType)
						isEnabled = mountName and hasOutfit
					end
					
					if mountName and isEnabled then
						podiumParts[#podiumParts + 1] = string.format("%s mount", mountName)
					end
				end
				
				if #podiumParts > 0 then
					response[#response + 1] = string.format(" displaying the %s", table.concat(podiumParts, " on the "))
				end
			end
		end
		
		-- charges and duration
		do
			local expireInfo = {}
			
			-- charges
			if itemType:hasShowCharges() then
				local charges = item:getCharges()
				expireInfo[#expireInfo + 1] = string.format("has %d charge%s left", charges, (charges ~= 1 and "s" or ""))
			end
		
			-- duration
			local transferId = itemType:getTransformEquipId()

			-- magic light wand (exception)
			if item:getId() == 2162 then
				transferId = 2163
			end

			local transferType = transferId ~= 0 and ItemType(transferId) or itemType
			local hasShowDuration = transferType:hasShowDuration()

			if hasShowDuration then
				local currentDuration = item:getDuration()
				if isVirtual then
					currentDuration = currentDuration * 1000
				end
				
				local maxDuration = transferType:getDuration() * 1000
				if currentDuration == 0 then
					currentDuration = maxDuration
				end
				
				if currentDuration == maxDuration and itemType ~= transferType then
					expireInfo[#expireInfo + 1] = "is brand-new"
				elseif currentDuration ~= 0 then
					expireInfo[#expireInfo + 1] = string.format("will expire in %s", Game.getCountdownString(math.floor(currentDuration/1000), true, true))
				end
			end

			-- response
			if #expireInfo > 0 then
				response[#response + 1] = string.format(" that %s", table.concat(expireInfo, " and "))
			end
		end
		
		-- dot after primary attributes info
		response[#response + 1] = "."
		
		-- empty fluid container suffix
		if itemGroup == ITEM_GROUP_FLUID and subType < 1 then
			response[#response + 1] = " It is empty."
		end
		
		-- house door
		if isDoor and not isVirtual then
			local tile = item:getTile()
			if tile then
				local house = tile:getHouse()
				if house then
					local houseName = house:getName()
					local houseOwnerName = house:getOwnerName()
					local isForSale = false
					
					if not houseOwnerName or houseOwnerName:len() == 0 then
						houseOwnerName = "Nobody"
						isForSale = true
					end
					
					response[#response + 1] = string.format(" It belongs to house '%s'. %s owns this house.", houseName, houseOwnerName)
					if housePriceVisible and isForSale and pricePerSQM > 0 then
						response[#response + 1] = string.format(" It costs %d gold coins.", pricePerSQM * house:getTileCount())
					end
				end
			end
		end
		
		-- imbuements
		if ImbuingSystem then
			response[#response + 1] = item:getImbuementsDescription()
		end
		
		-- item class
		-- Classification: x Tier: y (0.50% Onslaught).
		do
			local classification = itemType:getClassification()
			local tier = isVirtual and 0 or item:getTier() or 0

			if classification > 0 or tier > 0 then
				if classification == 0 then
					classification = "other"
				end
				
				local tierString = tier
				if tier > 0 then
					local bonusType, bonusValue = itemType:getTierBonus(tier)
					if bonusType ~= -1 then
						if bonusType > 5 then
							tierString = string.format("%d (%0.2f%% %s)", tier, bonusValue, getSpecialSkillName(bonusType))
						else
							tierString = string.format("%d (%d%% %s)", tier, bonusValue, getSpecialSkillName(bonusType))
						end
					end
				end
			
				response[#response + 1] = string.format("\nClassification: %s Tier: %s.", classification, tierString)
			end
		end

		-- item count (will be reused later)
		local count = isVirtual and 1 or item:getCount()
		
		-- wield info
		do
			if itemType:isRune() then
				local rune = Spell(itemType:getId())
				if rune then
					local runeLevel = rune:runeLevel()
					local runeMagLevel = rune:runeMagicLevel()
					local runeVocMap = rune:vocation()
					
					local hasLevel = runeLevel > 0
					local hasMLvl = runeMagLevel > 0
					local hasVoc = #runeVocMap > 0
					if hasLevel or hasMLvl or hasVoc then
						local vocAttrs = {}
						if not hasVoc then
							vocAttrs[#vocAttrs + 1] = "players"
						else
							for _, vocName in ipairs(runeVocMap) do
								local vocation = Vocation(vocName)
								if vocation and vocation:getPromotion() then
									vocAttrs[#vocAttrs + 1] = string.format("%ss", vocName:lower())
								end
							end
						end
						
						if #vocAttrs > 1 then
							vocAttrs[#vocAttrs - 1] = string.format("and %s", vocAttrs[#vocAttrs - 1])
						end
						
						local levelInfo = {}
						if hasLevel then
							levelInfo[#levelInfo + 1] = string.format("level %d", runeLevel)
						end
						
						if hasMLvl then
							levelInfo[#levelInfo + 1] = string.format("magic level %d", runeMagLevel)
						end
						
						local levelStr = ""
						if #levelInfo > 0 then
							levelStr = string.format(" of %s or higher", table.concat(levelInfo, " and "))
						end
						
						response[#response + 1] = string.format(
							"\n%s can only be used properly by %s%s.",
							(count > 1 and "They" or "It"),
							table.concat(vocAttrs, ", "),
							levelStr
						)
					end
				end
			else
				local wieldInfo = itemType:getWieldInfo()
				if wieldInfo ~= 0 then
					local wieldAttrs = {}
					if bit.band(wieldInfo, WIELDINFO_PREMIUM) ~= 0 then
						wieldAttrs[#wieldAttrs + 1] = "premium"
					end
					
					local vocStr = itemType:getVocationString()
					if vocStr ~= '' then
						wieldAttrs[#wieldAttrs + 1] = vocStr
					else
						wieldAttrs[#wieldAttrs + 1] = "players"
					end

					local levelInfo = {}
					if bit.band(wieldInfo, WIELDINFO_LEVEL) ~= 0 then
						levelInfo[#levelInfo + 1] = string.format("level %d", itemType:getMinReqLevel())
					end
					
					if bit.band(wieldInfo, WIELDINFO_MAGLV) ~= 0 then
						levelInfo[#levelInfo + 1] = string.format("magic level %d", itemType:getMinReqMagicLevel())
					end
					
					if #levelInfo > 0 then
						wieldAttrs[#wieldAttrs + 1] = string.format("of %s or higher", table.concat(levelInfo, " and "))
					end
					
					response[#response + 1] = string.format(
						"\n%s can only be wielded properly by %s.",
						(count > 1 and "They" or "It"),
						table.concat(wieldAttrs, " ")
					)
				end
			end
		end
		
		-- add hireling lamp desc if module installed
		if HirelingsUsageCache and not isVirtual then
			local hirelingDesc = item:getHirelingLampDescription()
			if hirelingDesc then
				response[#response + 1] = string.format("\n%s", hirelingDesc)
			end
		end
		
		if lookDistance <= 1 then
			local weight = item:getWeight()
			if isPickupable and not isUnique then
				response[#response + 1] = string.format("\n%s %0.2f oz.", (count == 1 or not itemType:hasShowCount()) and "It weighs" or "They weigh", weight / 100)
			end
		end
		
		-- item text
		if not isVirtual and itemType:hasAllowDistRead() then
			local text = item:getText()
			if text and text:len() > 0 then
				if lookDistance <= 4 then
					local writer = item:getAttribute(ITEM_ATTRIBUTE_WRITER)
					local writeDate = item:getAttribute(ITEM_ATTRIBUTE_DATE)
					local writeInfo = {}
					if writer and writer:len() > 0 then
						writeInfo[#writeInfo + 1] = string.format("\n%s wrote", writer)
						
						if writeDate and writeDate > 0 then
							writeInfo[#writeInfo + 1] = string.format(" on %s", os.date("%d %b %Y", writeDate))
						end
					end

					if #writeInfo > 0 then
						response[#response + 1] = string.format("%s:\n%s", table.concat(writeInfo, ""), text)
					else
						response[#response + 1] = string.format("\nYou read: %s", text)
					end
				else
					response[#response + 1] = "\nYou are too far away to read it."
				end				
			else
				response[#response + 1] = "\nNothing is written on it."
			end
		end
		
		-- show reward bag description if module installed
		if RewardSystem and not isVirtual and itemType:getType() == ITEM_TYPE_REWARDBAG then
			local creationTime = item:createdAt()
			if creationTime ~= 0 then
				local created = os.date("%d %b %Y %X", creationTime)
				local expires = os.date("%d %b %Y", creationTime + configManager.getNumber(configKeys.REWARD_BAG_DURATION))
				response[#response + 1] = string.format("\nIt was created on %s and will be available until %s.", created, expires)
			end
		end
		
		-- item description
		if lookDistance <= 1 or (not isVirtual and (isDoor or isBed or table.contains(playerCorpses, item:getId()))) then
			-- custom item description
			local desc = not isVirtual and item:getSpecialDescription()
			
			-- native item description
			if not desc or desc == "" then
				desc = itemType:getDescription()
			end
			
			-- level door description
			if isDoor and lookDistance <= 1 and (not desc or desc == "") and itemType:getLevelDoor() ~= 0 then
				desc = "Only the worthy may pass."
			end
			
			local itemId = itemType:getId()
			if not isVirtual and (itemId == ITEM_STORE_KIT or itemId == ITEM_FURNITURE_KIT) then
				local wrapTo = item:hasAttribute(ITEM_ATTRIBUTE_WRAPID) and ItemType(item:getAttribute(ITEM_ATTRIBUTE_WRAPID)) or false
				local kitDesc = "Unable to open. Missing attribute wrapId."
				if wrapTo then
					kitDesc = string.format("Use it in your house to construct %s.", wrapTo:getNameDescription(subType, true))
				end

				if desc and desc ~= "" then
					desc = string.format("%s %s", desc, kitDesc)
				else
					desc = kitDesc
				end
			end
			
			if desc and desc:len() > 0 then
				if not (isBed and desc == "Nobody is sleeping there.") then
					response[#response + 1] = string.format("\n%s", desc)
				end
			end
		end
		
		-- pickupable items with store flag
		if not isVirtual and isPickupable and item:isStoreItem() then
			response[#response + 1] = "\nThis item cannot be traded."
		end
		
		-- turn response into a single string
		return table.concat(response, "")
	end

	function Item:getDescription(lookDistance, subType, addArticle)
		return internalItemGetDescription(self, lookDistance, subType, addArticle)
	end

	function ItemType:getItemDescription(lookDistance, subType, addArticle)
		return internalItemGetDescription(self, lookDistance, subType, addArticle)
	end
end
