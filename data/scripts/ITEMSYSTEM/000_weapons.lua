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
		if Equippables.ammo[itemId] and Equippables.ammo[itemId].level then
			missile:level(Equippables.ammo[itemId].level)
			missile:wieldUnproperly(true)
		end
		missile:range(itemType:getShootRange())
		missile:maxHitChance(75)
		missile:register()
	end
end
