-- DEFAULT AMMO
do
	function generateDefaultArrow(itemId)
		local itemType = ItemType(itemId)
		if not itemType then
			return
		end
		
		local missile = Weapon(WEAPON_AMMO)
		missile:id(itemId)
		missile:action("removecount")
		missile:attack(itemType:getAttack())
		if Equippables.ammo[itemId] and Equippables.ammo[itemId].level then
			missile:level(Equippables.ammo[itemId].level)
			missile:wieldUnproperly(true)
		end
		missile:ammoType(itemType:getAmmoType() == AMMO_ARROW and "arrow" or "bolt")
		missile:maxHitChance(100)
		missile:register()
	end
end

-- DEFAULT MISSILE
do
	function generateDefaultMissile(itemId)
		local itemType = ItemType(itemId)
		if not itemType then
			return
		end
		
		local missile = Weapon(WEAPON_DISTANCE)
		missile:id(itemId)
		
		local itemInfo = Equippables.throwables[itemId]
		if itemInfo then
			if itemInfo.level then
				missile:level(itemInfo.level)
				missile:wieldUnproperly(true)
			end
		
			if itemInfo.breakChance then
				missile:breakChance(itemInfo.breakChance)
			end
			
			if itemInfo.maxHitChance then
				missile:maxHitChance(itemInfo.maxHitChance)
			end
		end
		
		missile:attack(itemType:getAttack())
		missile:register()
	end
end

-- DEFAULT WAND
do
	function generateDefaultWand(itemId)
		local itemType = ItemType(itemId)
		if not itemType then
			return
		end
		
		local wand = Weapon(WEAPON_WAND)
		wand:id(itemId)
		
		local itemInfo = Equippables.weapons_magic[itemId]
		if itemInfo then
			-- required voc + autogenerate promos
			if itemInfo.vocs then
				local vocPromoData = {}
				local realVocs = {}
				local lastVocId = -1
				for a, vocId in pairs(itemInfo.vocs) do
					vocPromoData[vocId] = true
					realVocs[#realVocs + 1] = vocId
					lastVocId = vocId
					local promos = Vocation(vocId):getAllPromotions()
					if promos then
						for b, promoVocId in pairs(promos) do
							vocPromoData[promoVocId] = false
							realVocs[#realVocs + 1] = promoVocId
						end
					end
				end
			
				for _, vocId in pairs(realVocs) do
					wand:vocation(Vocation(vocId):getName(), vocPromoData[vocId], vocId == lastVocId)
				end
			end
		
			-- required level
			if itemInfo.level then
				wand:level(itemInfo.level)
				wand:wieldUnproperly(true)
			end
		
			-- required mana
			if itemInfo.mana then
				wand:mana(itemInfo.mana)
			end
			
			-- damage
			if itemInfo.damage then
				wand:damage(itemInfo.damage[1], itemInfo.damage[2]) 
			end
			
			-- element
			if itemInfo.element then
				wand:element(itemInfo.element)
			end
		end
		
		wand:register()
	end
end

-- DEFAULT MELEE
do
	function generateDefaultMeleeWeapon(itemId)
		-- level, vocation
		local itemType = ItemType(itemId)
		if not itemType then
			return
		end
		
		local weaponType = itemType:getWeaponType()
		if weaponType == 0 then
			weaponType = 1
			Game.sendConsoleMessage(CONSOLEMESSAGE_TYPE_WARNING, string.format("(items.xml) Missing weapon type for item id %d. Assuming type sword.", itemId))
		end
		
		local weapon = Weapon(weaponType)
		weapon:id(itemId)
		
		local itemInfo = Equippables.weapons[itemId]
		if itemInfo then
			-- required voc + autogenerate promos
			if itemInfo.vocs then
				local vocPromoData = {}
				local realVocs = {}
				local lastVocId = -1
				for a, vocId in pairs(itemInfo.vocs) do
					vocPromoData[vocId] = true
					realVocs[#realVocs + 1] = vocId
					lastVocId = vocId
					local promos = Vocation(vocId):getAllPromotions()
					if promos then
						for b, promoVocId in pairs(promos) do
							vocPromoData[promoVocId] = false
							realVocs[#realVocs + 1] = promoVocId
						end
					end
				end

				for _, vocId in pairs(realVocs) do
					weapon:vocation(Vocation(vocId):getName(), vocPromoData[vocId], vocId == lastVocId)
				end
			end
		
			-- required level
			if itemInfo.level then
				weapon:level(itemInfo.level)
				weapon:wieldUnproperly(true)
			end
			
			-- charges (ice rapier, enchanted weapons)
			if itemInfo.removecharges then
				weapon:action("removecharge")
			end
		end
		
		weapon:register()
	end
end

-- DEFAULT CROSSBOW
do
	function generateDefaultCrossbow(itemId)
		local itemType = ItemType(itemId)
		if not itemType then
			return
		end
		
		local weapon = Weapon(WEAPON_DISTANCE)
		weapon:id(itemId)
		
		local itemInfo = Equippables.weapons_distance[itemId]
		if itemInfo then
			-- required voc + autogenerate promos
			if itemInfo.vocs then
				local vocPromoData = {}
				local realVocs = {}
				local lastVocId = -1
				for a, vocId in pairs(itemInfo.vocs) do
					vocPromoData[vocId] = true
					realVocs[#realVocs + 1] = vocId
					lastVocId = vocId
					local promos = Vocation(vocId):getAllPromotions()
					if promos then
						for b, promoVocId in pairs(promos) do
							vocPromoData[promoVocId] = false
							realVocs[#realVocs + 1] = promoVocId
						end
					end
				end

				for _, vocId in pairs(realVocs) do
					weapon:vocation(Vocation(vocId):getName(), vocPromoData[vocId], vocId == lastVocId)
				end
			end
		
			-- required level
			if itemInfo.level then
				weapon:level(itemInfo.level)
				weapon:wieldUnproperly(true)
			end
		end
		
		weapon:register()
	end
end

-- BURST ARROW
do
	local area = createCombatArea({
		{1, 1, 1},
		{1, 3, 1},
		{1, 1, 1}
	})

	local combat = Combat()
	combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
	combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_EXPLOSIONAREA)
	combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_BURSTARROW)
	combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
	combat:setFormula(COMBAT_FORMULA_SKILL, 0, 0, 1, 0)
	combat:setArea(area)

	function generateBurstArrow(itemId)
		local itemType = ItemType(itemId)
		if not itemType then
			return
		end
		
		local missile = Weapon(WEAPON_AMMO)
		missile.onUseWeapon = function(player, variant)
			if player:getSkull() == SKULL_BLACK then
				return false
			end

			return combat:execute(player, variant)
		end

		missile:id(itemId)
		missile:action("removecount")
		missile:attack(itemType:getAttack())
		if Equippables.ammo[itemId] and Equippables.ammo[itemId].level then
			missile:level(Equippables.ammo[itemId].level)
			missile:wieldUnproperly(true)
		end
		missile:ammoType(itemType:getAmmoType() == AMMO_ARROW and "arrow" or "bolt")
		missile:maxHitChance(100)
		missile:register()
	end
end

-- DIAMOND ARROW
do
	local area = createCombatArea({
		{0, 1, 1, 1, 0},
		{1, 1, 1, 1, 1},
		{1, 1, 3, 1, 1},
		{1, 1, 1, 1, 1},
		{0, 1, 1, 1, 0},
	})

	local combat = Combat()
	combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
	combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ENERGYHIT)
	combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_DIAMONDARROW)
	combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
	combat:setFormula(COMBAT_FORMULA_SKILL, 0, 0, 1, 0)
	combat:setArea(area)
	
	function generateDiamondArrow(itemId)
		local itemType = ItemType(itemId)
		if not itemType then
			return
		end
		
		local missile = Weapon(WEAPON_AMMO)
		missile.onUseWeapon = function(player, variant)
			if player:getSkull() == SKULL_BLACK then
				return false
			end

			return combat:execute(player, variant)
		end

		missile:id(itemId)
		missile:action("removecount")
		missile:attack(itemType:getAttack())
		if Equippables.ammo[itemId] and Equippables.ammo[itemId].level then
			missile:level(Equippables.ammo[itemId].level)
			missile:wieldUnproperly(true)
		end
		missile:ammoType(itemType:getAmmoType() == AMMO_ARROW and "arrow" or "bolt")
		missile:maxHitChance(100)
		missile:register()
	end
end

-- POISON ARROW
do
	local combat = Combat()
	combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
	combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_POISONARROW)
	combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
	combat:setFormula(COMBAT_FORMULA_SKILL, 0, 0, 1, 0)

	function generatePoisonArrow(itemId)
		local itemType = ItemType(itemId)
		if not itemType then
			return
		end
		
		local missile = Weapon(WEAPON_AMMO)
		missile.onUseWeapon = function(player, variant)
			if not combat:execute(player, variant) then
				return false
			end

			player:addDamageCondition(Creature(variant:getNumber()), CONDITION_POISON, DAMAGELIST_LOGARITHMIC_DAMAGE, 3)
			return true
		end

		missile:id(itemId)
		missile:action("removecount")
		missile:attack(itemType:getAttack())
		if Equippables.ammo[itemId] and Equippables.ammo[itemId].level then
			missile:level(Equippables.ammo[itemId].level)
			missile:wieldUnproperly(true)
		end
		missile:ammoType(itemType:getAmmoType() == AMMO_ARROW and "arrow" or "bolt")
		missile:maxHitChance(90)
		missile:register()
	end
end

-- VIPER STAR
do
	local combat = Combat()
	combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
	combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_GREENSTAR)
	combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
	combat:setFormula(COMBAT_FORMULA_SKILL, 0, 0, 1, 0)

	function generateViperStar(itemId)
		local itemType = ItemType(itemId)
		if not itemType then
			return
		end
		
		local missile = Weapon(WEAPON_DISTANCE)
		missile.onUseWeapon = function(player, variant)
			if not combat:execute(player, variant) then
				return false
			end

			player:addDamageCondition(Creature(variant:getNumber()), CONDITION_POISON, DAMAGELIST_LOGARITHMIC_DAMAGE, 2)
			return true
		end
		
		missile:id(itemId)
		missile:breakChance(30)
		missile:attack(itemType:getAttack())
		if Equippables.throwables[itemId] and Equippables.throwables[itemId].level then
			missile:level(Equippables.throwables[itemId].level)
			missile:wieldUnproperly(true)
		end
		missile:range(itemType:getShootRange())
		missile:maxHitChance(75)
		missile:register()
	end
end

-- SPRITE WAND
do
	local function formulaMin(level, ml)
		return (level * 0.1) + (ml / 2)
	end

	local function formulaMax(level, ml)
		return (level * 0.15) + (ml / 2)
	end

	local function getManaCost(player)
		if player then
			local level = player:getLevel()
			local ml = player:getMagicLevel()
			return math.ceil((formulaMin(level, ml) + formulaMax(level, ml)) * 0.08)
		end

		return 0
	end

	local combat = Combat()
	combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
	combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_FAEEXPLOSION)
	combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_SMALLHOLY)

	function onGetFormulaValues(player, level, magicLevel)
		local crit = 1
		local target = player:getTarget()
		if target and math.random(100) < 30 then
			crit = 1.5
			local effect = math.random(CONST_ME_FAECOMING, CONST_ME_FAEGOING)
			local tpos = target:getPosition()
			tpos:sendMagicEffect(CONST_ME_CRITICAL_DAMAGE)
			if effect == CONST_ME_FAECOMING then
				tpos.x = tpos.x + math.random(1, 2) - 1
				tpos.y = tpos.y + math.random(1, 2) - 1
			else
				tpos.x = tpos.x + math.random(1, 3) - 2
				tpos.y = tpos.y + math.random(1, 3) - 2
			end
			tpos:sendMagicEffect(effect)
		end
		
		return math.floor(-formulaMin(level, magicLevel)) * crit, math.floor(-formulaMax(level, magicLevel)) * crit
	end

	combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

	function generateSpriteWand(itemId)
		local itemInfo = Equippables.weapons_magic[itemId]
		if itemInfo then
			local wand = Weapon(WEAPON_WAND)
			wand:id(itemId)
			
			-- required voc + autogenerate promos
			if itemInfo.vocs then
				local vocPromoData = {}
				local realVocs = {}
				local lastVocId = -1
				for a, vocId in pairs(itemInfo.vocs) do
					vocPromoData[vocId] = true
					realVocs[#realVocs + 1] = vocId
					lastVocId = vocId
					local promos = Vocation(vocId):getAllPromotions()
					if promos then
						for b, promoVocId in pairs(promos) do
							vocPromoData[promoVocId] = false
							realVocs[#realVocs + 1] = promoVocId
						end
					end
				end
			
				for _, vocId in pairs(realVocs) do
					wand:vocation(Vocation(vocId):getName(), vocPromoData[vocId], vocId == lastVocId)
				end
			end
			
			-- required level
			if itemInfo.level then
				wand:level(itemInfo.level)
				wand:wieldUnproperly(true)
			end
		
			--[[ HANDLED BY SCRIPT, DO NOT TYPE INTO CONFIG
			-- required mana
			if itemInfo.mana then
				wand:mana(itemInfo.mana)
			end
			
			-- damage
			if itemInfo.damage then
				wand:damage(itemInfo.damage[1], itemInfo.damage[2]) 
			end
			
			-- element
			if itemInfo.element then
				wand:element(itemInfo.element)
			end
			]]
			
			wand.onUseWeapon = function(player, variant)
				local cost = getManaCost(player)
				if player:getMana() < cost then
					return false
				end
				
				player:addMana(-cost)
				player:addManaSpent(cost * configManager.getNumber(configKeys.RATE_MAGIC))
				return combat:execute(player, variant)
			end
			
			wand:register()
		end
	end
end
