DELIMITER ;
CREATE TABLE IF NOT EXISTS `marketplaces` (
  `kundennummer` varchar(10) NOT NULL,
  `kostenstelle` int(11) NOT NULL DEFAULT 0,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`kundennummer`,`kostenstelle`)
);


CREATE OR REPLACE VIEW `view_readtable_marketplaces` AS (select `marketplaces`.`kundennummer` AS `kundennummer`,`marketplaces`.`kostenstelle` AS `kostenstelle`,`marketplaces`.`name` AS `name`,concat(`marketplaces`.`kundennummer`,' - ',`marketplaces`.`name`) AS `display` from `marketplaces`);
