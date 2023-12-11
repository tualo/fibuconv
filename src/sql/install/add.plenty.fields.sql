
alter table blg_pos_plenty add brutto_currency	decimal(15,5) default 0;
alter table blg_pos_plenty add kurs	decimal(15,5)	decimal(15,5) default 0;
alter table blg_pos_plenty add currency	varchar(10)	decimal(15,5) default 'EUR';

alter table blg_hdr_plenty add filename	varchar(255) default null;
alter table blg_hdr_plenty add fileid	varchar(255) default null;
alter table blg_hdr_plenty add zusatzinfo	varchar(255) default null;
alter table blg_hdr_plenty add zusatzinfo2	varchar(255) default null;
alter table blg_hdr_plenty add zahlungsart	varchar(255) default null;
alter table blg_hdr_plenty add paymentid	varchar(255) default null;
alter table blg_hdr_plenty add iso	varchar(255) default null;
alter table blg_hdr_plenty add fremdbeleg	varchar(50) default null;
alter table blg_hdr_plenty add brutto_currency	decimal(15,5) default null;
alter table blg_hdr_plenty add kurs	decimal(15,5) default null;
alter table blg_hdr_plenty add herkunft	varchar(20) default null;
