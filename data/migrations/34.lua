function onUpdateDatabase()
	-- NOTE: THIS IS FIRST CUSTOM MIGRATION
	-- TFS COMPATIBILITY MAY BREAK AT THIS POINT
	print("> Updating database to version 35 (more blessings)")
	print("WARNING: THIS UPDATE MAY BREAK BACKWARDS COMPATIBILITY WITH OTLAND TFS!")
	db.query("ALTER TABLE `players` MODIFY COLUMN `blessings` int unsigned NOT NULL DEFAULT '0';")
	return true
end
