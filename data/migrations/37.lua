function onUpdateDatabase()
	print("> Updating database to version 38 (store history)")
	db.query([[CREATE TABLE IF NOT EXISTS `store_history` (
  `transaction_id` int NOT NULL AUTO_INCREMENT,
  `date` bigint unsigned NOT NULL,
  `status` smallint NOT NULL DEFAULT '0',
  `account_id` int NOT NULL,
  `player_id` int NOT NULL,
  `email` varchar(255) NOT NULL DEFAULT '',
  `ip` int unsigned NOT NULL DEFAULT '0',
  `name` varchar(255) NOT NULL,
  `amount` smallint NOT NULL DEFAULT '1',
  `price` int NOT NULL DEFAULT '0',
  `currency` smallint NOT NULL DEFAULT '0',
  `param_1` varchar(255) NOT NULL DEFAULT '',
  `param_2` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`transaction_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;]])
	return true
end
