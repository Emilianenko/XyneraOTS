function onUpdateDatabase()
	print("> Updating database to version 32 (item tiers)")
	db.query("ALTER TABLE `market_offers` ADD COLUMN `tier` smallint unsigned NOT NULL DEFAULT 0;")
	db.query("ALTER TABLE `market_history` ADD COLUMN `tier` smallint unsigned NOT NULL DEFAULT 0;")
	return true
end
