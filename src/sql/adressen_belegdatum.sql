
CREATE OR REPLACE  PROCEDURE `adressen_belegdatum`( 

)
BEGIN 

for  rec  in (

   
select 
blg_adressen_plenty.kundennummer,
blg_adressen_plenty.kostenstelle,
min(datum) min_datum,
max( datum) max_datum
 from blg_hdr_plenty join blg_adressen_plenty on blg_hdr_plenty.id = blg_adressen_plenty.id 

 group by  

 blg_adressen_plenty.kundennummer,
blg_adressen_plenty.kostenstelle
) do 

 update adressen set 
 erster_beleg  = rec.min_datum,
 letzter_beleg = rec.max_datum
 where 
 kundennummer = rec.kundennummer and 
 kostenstelle = rec.kostenstelle
 ;

end for; 

END