CREATE TABLE IF NOT EXISTS `fibuconv_uploaded_files` (
  `id` varchar(36) NOT NULL,
  `filename` varchar(150) NOT NULL,
  `pathname` varchar(255) NOT NULL DEFAULT '/',
  `processed` tinyint(4) DEFAULT 0,
  `processed_datetime` datetime DEFAULT NULL,
  `upload_datetime` datetime NOT NULL,
  `filesize` int(11) NOT NULL DEFAULT 0,
  `extension` varchar(10) NOT NULL,
  `checksum` varchar(36) NOT NULL,
  `login` varchar(100) NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `done` tinyint(4) DEFAULT 0,
  `von` date DEFAULT NULL,
  `bis` date DEFAULT NULL,
  `diff` int(11) DEFAULT NULL,
  `incorrect_string_type` tinyint(4) DEFAULT 0,
  `incorrect_column_type` tinyint(4) DEFAULT 0,
  `incorrect_table_type` tinyint(4) DEFAULT 0,
  `incorrect_column_count` tinyint(4) DEFAULT 0,
  `detected_type` varchar(255) DEFAULT NULL,
  `processed_report` tinyint(4) DEFAULT 0,
  `detected_charset` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uidx_fibuconv_uploaded_files_checksum` (`checksum`),
  KEY `idx_fibuconv_uploaded_files_filename` (`filename`),
  KEY `idx_fibuconv_uploaded_files_upload_datetime` (`upload_datetime`),
  KEY `idx_fibuconv_uploaded_files_pathname` (`pathname`),
  KEY `idx_fibuconv_uploaded_files_q1` (`processed`,`type`,`upload_datetime`)
);

CREATE TABLE IF NOT EXISTS `fibuconv_uploaded_files_data` (
  `id` varchar(36) NOT NULL,
  `data` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_fibuconv_uploaded_files_data` FOREIGN KEY (`id`) REFERENCES `fibuconv_uploaded_files` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
);