function onUpdateDatabase()
	print("> Updating database to version 36 (reward chest)")
	local q = "CREATE TABLE IF NOT EXISTS `player_rewardchest` (" ..
				"`player_id` int NOT NULL," ..
				"`sid` int NOT NULL DEFAULT '0'," ..
				"`pid` int NOT NULL DEFAULT '0'," ..
				"`itemtype` smallint unsigned NOT NULL," ..
				"`count` smallint NOT NULL DEFAULT '0'," ..
				"`attributes` blob NOT NULL," ..
				"UNIQUE KEY `player_id_2` (`player_id`, `sid`)," ..
				"FOREIGN KEY (`player_id`) REFERENCES `players`(`id`) ON DELETE CASCADE" ..
			") ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;"

	db.query(q)
	return true
end
