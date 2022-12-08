--[[
	-- client description variables
	store_description_placeholder_account
	store_description_placeholder_activated
	store_description_placeholder_backtoinbox
	store_description_placeholder_battlesign
	store_description_placeholder_battlesignicon
	store_description_placeholder_box
	store_description_placeholder_boxicon
	store_description_placeholder_capacity
	store_description_placeholder_character
	store_description_placeholder_house
	store_description_placeholder_info
	store_description_placeholder_limit
	store_description_placeholder_limiticon
	store_description_placeholder_once
	store_description_placeholder_speedboost
	store_description_placeholder_storeinbox
	store_description_placeholder_storeinboxicon
	store_description_placeholder_transferableprice
	store_description_placeholder_usablebyall
	store_description_placeholder_usablebyallicon
	store_description_placeholder_use
	store_description_placeholder_useicon
	store_description_placeholder_vocationlevelcheck

	---- 13.10 protocol
	-- EMPTY PLACEHOLDER PAGE
		local msg = NetworkMessage()
		msg:addByte(0xFC)
		msg:addString("") -- tabName
		msg:addU32(0) -- offerId
		msg:addByte(0) -- sort type
		msg:addByte(0) -- menu count

		msg:addString("") -- tab name
		msg:addU16(0) -- menu count
		msg:addU16(0) -- ?
		msg:sendToPlayer(self)

	-- EMPTY HOME PAGE (estimated)
		local msg = NetworkMessage()
		msg:addByte(0xFC)
		msg:addString("Home") -- tabName
		msg:addU32(0) -- offerId
		msg:addByte(0) -- sort type
		msg:addByte(0) -- menu count

		msg:addString("") -- tab name
		msg:addU16(0) -- menu count
		msg:addByte(0)
		msg:addByte(0)
		msg:addByte(0)
		msg:addByte(0)
		msg:sendToPlayer(self)
]]
