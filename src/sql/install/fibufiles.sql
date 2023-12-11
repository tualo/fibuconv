DELIMITER;

CREATE TABLE IF NOT EXISTS `fibufiles` (
  `id` varchar(36) DEFAULT NULL,
  `typ` varchar(12) NOT NULL,
  `file_id` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`id` ),
  KEY `typ` (`typ`),
  CONSTRAINT `fibufiles_ibfk_2` FOREIGN KEY (`typ`) REFERENCES `fibufiles_typen` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
);

call addfieldifnotexists('fibufiles','processed_report','tinyint default 0');
call addfieldifnotexists('fibufiles','detected_charset','varchar(25) default null');

call addfieldifnotexists('fibufiles','detected_charset','varchar(25) default null');


CREATE
OR REPLACE VIEW `view_readtable_fibufiles` AS
select
  `fibufiles`.`id` AS `id`,
  `fibufiles`.`typ` AS `typ`,

  `fibufiles`.`processed_report` AS `processed_report`,
  `fibufiles`.`typ` AS `detected_type`,
  `fibufiles`.`detected_charset` AS `detected_charset`,
  
  `ds_files`.`name` AS `__file_name`,
  `ds_files`.`path` AS `path`,
  `ds_files`.`size` AS `__file_size`,
  `ds_files`.`mtime` AS `mtime`,
  `ds_files`.`ctime` AS `ctime`,
  `ds_files`.`type` AS `__file_type`,
  `ds_files`.`file_id` AS `__file_id`,
  `ds_files`.`hash` AS `hash`,
  '' AS `__file_data`,

  rank() over (
        partition by `ds_files`.`hash`
        order by
            `ds_files`.`ctime`
    ) AS `duplicate_file`

from
  (
    `fibufiles`
    left join `ds_files` on(
      `fibufiles`.`file_id` = `ds_files`.`file_id`
    )
  );