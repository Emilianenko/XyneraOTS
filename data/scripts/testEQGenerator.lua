local testChest = Action()
function testChest.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	-- check if not claimed yet
	if player:getStorageValue(65535) > 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have already claimed your test set.")
		return true
	end

	-- send message
	player:sendTextMessage(MESSAGE_INFO_DESCR, "Testing equipment set.")
	item:getPosition():sendMagicEffect(CONST_ME_FIREWORK_RED)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
	
	-- set reward as claimed
	player:setStorageValue(65535, 1)
	
	-- set level to 400
	player:addExperience(1050779800)

	-- roll sex
	if math.random(100) <= 50 then
		player:changeSex()
	end
	
	-- roll vocation
	local voc = math.random(4)
	player:setVocation(voc)

	-- add vocation specific skills
	if voc == 4 then
		-- knight
		player:addSkill(SKILL_CLUB, 100)
		player:addSkill(SKILL_SWORD, 100)
		player:addSkill(SKILL_AXE, 100)
		player:addSkill(SKILL_MAGLEVEL, 17)
	elseif voc == 3 then
		-- paladin
		player:addSkill(SKILL_DISTANCE, 100)
		player:addSkill(SKILL_MAGLEVEL, 40)
	else
		-- sorc/druid
		player:addSkill(SKILL_MAGLEVEL, 100)
	end
	
	-- add shielding
	player:addSkill(SKILL_SHIELD, 100)
	
	-- amulet
	player:addItem(34287, 1)
	
	-- bp
	local bp = player:addItem(35276, 1)
	bp:setImbuement(0, IMBUEMENT_BOOST_CAPACITY_3, IMBUING_DEFAULT_DURATION)
	bp:addItem(10515, 1)
	bp:addItem(20620, 3)
	bp:addItem(2160, 100)
	bp:addItem(2795, 100)
	
	-- trinket
	player:addItem(28631, 1)
	
	-- vocation-specific
	if voc == 4 then
		-- knight
		
		-- helmet
		local helm = player:addItem(44179, 1)
		helm:setTier(10)
		helm:setImbuingSlots(3)
		helm:setImbuement(0, IMBUEMENT_BOOST_MAGIC_3, IMBUING_DEFAULT_DURATION)
		helm:setImbuement(1, IMBUEMENT_BOOST_SHIELD_3, IMBUING_DEFAULT_DURATION)
		helm:setImbuement(2, IMBUEMENT_LEECH_MANA_3, IMBUING_DEFAULT_DURATION)
		
		-- armor
		local arm = player:addItem(44178, 1)
		arm:setTier(10)
		arm:setImbuingSlots(3)
		arm:setImbuement(0, IMBUEMENT_CRIT_3, IMBUING_DEFAULT_DURATION)
		arm:setImbuement(1, IMBUEMENT_LEECH_LIFE_3, IMBUING_DEFAULT_DURATION)
		arm:setImbuement(2, IMBUEMENT_LEECH_MANA_3, IMBUING_DEFAULT_DURATION)
		
		-- legs
		player:addItem(31376, 1)
		
		-- boots
		local b = player:addItem(36753, 1)
		b:setImbuingSlots(1)
		b:setImbuement(0, IMBUEMENT_BOOST_SPEED_3, IMBUING_DEFAULT_DURATION)
		
		-- weapon
		local wp = player:addItem(36738, 1)
		wp:setTier(10)
		wp:setImbuingSlots(3)
		wp:setImbuement(0, IMBUEMENT_CRIT_3, IMBUING_DEFAULT_DURATION)
		wp:setImbuement(1, IMBUEMENT_LEECH_LIFE_3, IMBUING_DEFAULT_DURATION)
		wp:setImbuement(2, IMBUEMENT_LEECH_MANA_3, IMBUING_DEFAULT_DURATION)
		
		-- shield slot
		local sh = player:addItem(36755, 1)
		sh:setImbuingSlots(1)
		sh:setImbuement(0, IMBUEMENT_BOOST_SHIELD_3, IMBUING_DEFAULT_DURATION)
		
		-- ring
		player:addItem(44208, 1)
	elseif voc == 3 then
		-- paladin

		-- helmet
		local helm = player:addItem(44180, 1)
		helm:setTier(10)
		helm:setImbuingSlots(3)
		helm:setImbuement(0, IMBUEMENT_BOOST_MAGIC_3, IMBUING_DEFAULT_DURATION)
		helm:setImbuement(1, IMBUEMENT_BOOST_SHIELD_3, IMBUING_DEFAULT_DURATION)
		helm:setImbuement(2, IMBUEMENT_LEECH_MANA_3, IMBUING_DEFAULT_DURATION)
		
		-- armor
		local arm = player:addItem(36750, 1)
		arm:setTier(10)
		arm:setImbuingSlots(3)
		arm:setImbuement(0, IMBUEMENT_CRIT_3, IMBUING_DEFAULT_DURATION)
		arm:setImbuement(1, IMBUEMENT_LEECH_LIFE_3, IMBUING_DEFAULT_DURATION)
		arm:setImbuement(2, IMBUEMENT_LEECH_MANA_3, IMBUING_DEFAULT_DURATION)

		-- legs
		player:addItem(31376, 1)
		
		-- boots
		local b = player:addItem(36754, 1)
		b:setImbuingSlots(1)
		b:setImbuement(0, IMBUEMENT_BOOST_SPEED_3, IMBUING_DEFAULT_DURATION)

		-- weapon
		local wp = player:addItem(36744, 1)
		wp:setTier(10)
		wp:setImbuingSlots(3)
		wp:setImbuement(0, IMBUEMENT_CRIT_3, IMBUING_DEFAULT_DURATION)
		wp:setImbuement(1, IMBUEMENT_LEECH_LIFE_3, IMBUING_DEFAULT_DURATION)
		wp:setImbuement(2, IMBUEMENT_LEECH_MANA_3, IMBUING_DEFAULT_DURATION)
		
		-- shield slot
		local sh = player:addItem(44181, 1)
		sh:setImbuingSlots(1)
		sh:setImbuement(0, IMBUEMENT_BOOST_DISTANCE_3, IMBUING_DEFAULT_DURATION)
		
		-- ring
		player:addItem(44211, 1)
	elseif voc == 1 then
		-- sorc
		
		-- helmet
		local helm = player:addItem(44182, 1)
		helm:setTier(10)
		helm:setImbuingSlots(3)
		helm:setImbuement(0, IMBUEMENT_BOOST_MAGIC_3, IMBUING_DEFAULT_DURATION)
		helm:setImbuement(1, IMBUEMENT_BOOST_SHIELD_3, IMBUING_DEFAULT_DURATION)
		helm:setImbuement(2, IMBUEMENT_LEECH_MANA_3, IMBUING_DEFAULT_DURATION)
		
		-- armor
		local arm = player:addItem(36751, 1)
		arm:setTier(10)
		arm:setImbuingSlots(3)
		arm:setImbuement(0, IMBUEMENT_CRIT_3, IMBUING_DEFAULT_DURATION)
		arm:setImbuement(1, IMBUEMENT_LEECH_LIFE_3, IMBUING_DEFAULT_DURATION)
		arm:setImbuement(2, IMBUEMENT_LEECH_MANA_3, IMBUING_DEFAULT_DURATION)

		-- legs
		player:addItem(36748, 1)
		
		-- boots
		local b = player:addItem(32080, 1)
		b:setImbuingSlots(1)
		b:setImbuement(0, IMBUEMENT_BOOST_SPEED_3, IMBUING_DEFAULT_DURATION)

		-- weapon
		local wp = player:addItem(36746, 1)
		wp:setTier(10)
		wp:setImbuingSlots(3)
		wp:setImbuement(0, IMBUEMENT_CRIT_3, IMBUING_DEFAULT_DURATION)
		wp:setImbuement(1, IMBUEMENT_LEECH_LIFE_3, IMBUING_DEFAULT_DURATION)
		wp:setImbuement(2, IMBUEMENT_LEECH_MANA_3, IMBUING_DEFAULT_DURATION)
		
		-- shield slot
		local sh = player:addItem(44183, 1)
		sh:setImbuingSlots(1)
		sh:setImbuement(0, IMBUEMENT_BOOST_SHIELD_3, IMBUING_DEFAULT_DURATION)
		
		-- ring
		player:addItem(44214, 1)
	else
		-- druid
		
		-- helmet
		local helm = player:addItem(44184, 1)
		helm:setTier(10)
		helm:setImbuingSlots(3)
		helm:setImbuement(0, IMBUEMENT_BOOST_MAGIC_3, IMBUING_DEFAULT_DURATION)
		helm:setImbuement(1, IMBUEMENT_BOOST_SHIELD_3, IMBUING_DEFAULT_DURATION)
		helm:setImbuement(2, IMBUEMENT_LEECH_MANA_3, IMBUING_DEFAULT_DURATION)
		
		-- armor
		local arm = player:addItem(36752, 1)
		arm:setTier(10)
		arm:setImbuingSlots(3)
		arm:setImbuement(0, IMBUEMENT_CRIT_3, IMBUING_DEFAULT_DURATION)
		arm:setImbuement(1, IMBUEMENT_LEECH_LIFE_3, IMBUING_DEFAULT_DURATION)
		arm:setImbuement(2, IMBUEMENT_LEECH_MANA_3, IMBUING_DEFAULT_DURATION)

		-- legs
		player:addItem(36749, 1)
		
		-- boots
		local b = player:addItem(32080, 1)
		b:setImbuingSlots(1)
		b:setImbuement(0, IMBUEMENT_BOOST_SPEED_3, IMBUING_DEFAULT_DURATION)
		
		-- weapon
		local wp = player:addItem(36747, 1)
		wp:setTier(10)
		wp:setImbuingSlots(3)
		wp:setImbuement(0, IMBUEMENT_CRIT_3, IMBUING_DEFAULT_DURATION)
		wp:setImbuement(1, IMBUEMENT_LEECH_LIFE_3, IMBUING_DEFAULT_DURATION)
		wp:setImbuement(2, IMBUEMENT_LEECH_MANA_3, IMBUING_DEFAULT_DURATION)
		
		-- shield slot
		local sh = player:addItem(44185, 1)
		sh:setImbuingSlots(1)
		sh:setImbuement(0, IMBUEMENT_BOOST_MAGIC_3, IMBUING_DEFAULT_DURATION)
		
		-- ring
		player:addItem(44217, 1)
	end
	
	return true
end

testChest:id(28459)
testChest:register()
