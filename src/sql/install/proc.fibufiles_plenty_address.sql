CREATE OR REPLACE PROCEDURE `fibufiles_plenty_address`( )
BEGIN 

select 'fibufiles_plenty_address';
    for record in (
        select 
        `kunde id`,
        DENSE_RANK() over (partition by `kunde id` order by 
        md5(concat(
            trim(ifnull(kunde,'')),
            trim(ifnull(firma,'')),
            trim(ifnull(vorname,'')),
            trim(ifnull(nachname,'')),
            trim(ifnull(`rechnungsanschrift land iso`,''))
        ))) -1  kostenstelle,
        md5(concat(
            trim(ifnull(kunde,'')),
            trim(ifnull(firma,'')),
            trim(ifnull(vorname,'')),
            trim(ifnull(nachname,'')),
            trim(ifnull(`rechnungsanschrift land iso`,''))
        )) md5,
        kunde,
        firma,
        vorname,
        nachname,
        `rechnungsanschrift land iso`

        from `sample`  order by `kunde id`, kostenstelle

    ) do

        set @maxkostenstelle = null;
        select record.`kunde id`,record.md5;
        select max(kostenstelle) into @maxkostenstelle from adressen where kundennummer=record.`kunde id` and postid = record.md5;
        if (@maxkostenstelle is null) then
            select ifnull(max(kostenstelle)+1,0) into @maxkostenstelle from adressen where kundennummer=record.`kunde id`;
        end if;

        -- select record.`kunde id`,@maxkostenstelle,record.md5,record.kunde,record.firma,record.vorname,record.nachname,record.`rechnungsanschrift land iso`;
        insert ignore into adressen (kundennummer,kostenstelle,postid,name,firma,vorname,nachname,lc,steuerschluessel,preiskategorie) 
        values (record.`kunde id`,@maxkostenstelle,record.md5,record.kunde,record.firma,record.vorname,record.nachname,record.`rechnungsanschrift land iso`,'normalbesteuert',1);
            
    end for;
select 'fibufiles_plenty_address done';

END