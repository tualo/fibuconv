DELIMITER  //
CREATE TABLE IF NOT EXISTS `fibufiles_typen` (
  `id` varchar(12) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) //
call addfieldifnotexists('fibufiles_typen','text_to_find','longtext default null') //



insert ignore into `fibufiles_typen` (`id`, `name`) values ('unkown', 'Unbekannter Typ') //

insert into `fibufiles_typen` (`id`, `name`, `text_to_find`) values ('plenty', 'Plenty Datev Datei',
'Währung;Soll-Haben;Rechnungsbetrag (brutto);Buchungsschlüssel;Gegenkonto (Erlöskonto);Rechn.-Nr. (Belegfeld 1);Order ID (Belegfeld 2);Belegdatum;Konto (Debitor);Kunde ID;Kunde;Firma;Vorname;Nachname;Rechnungsanschrift Land ISO;Lieferanschrift Land ISO;Buc'
) on duplicate key update name=values(name), text_to_find=values(text_to_find) //

