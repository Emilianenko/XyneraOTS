function onUpdateDatabase()
	print("> Updating database to version 37 (store coins)")
	db.query('ALTER TABLE `accounts` ADD COLUMN `coins` int(12) NOT NULL DEFAULT '0' AFTER `password`;')
	return true
end
