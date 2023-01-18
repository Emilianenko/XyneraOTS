function makePlayers()
	for accId = 101, 120 do
		for playerId = 1, 50 do
			db.query("INSERT INTO `players`(`name`, `account_id`) VALUES ('test " .. accId - 100 .. "-" .. playerId .. "','" .. accId .. "')")
		end
	end
end