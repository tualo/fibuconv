


insert into blg_hdr_cashpayment (
    id,
    datum,
    faelligam,
    buchungsdatum,
    skonto_netto,
    skonto_brutto,
    provision_netto,
    provision_brutto,
    netto,
    brutto,
    steuer,
    bezahlt,
    minderung,
    gegeben,
    zurueck,
    zahlart,
    referenz,
    login
) 


select 
beleg id,
datum datum,
datum faelligam,
datum buchungsdatum,
0 skonto_netto,
0 skonto_brutto,
0 provision_netto,
0 provision_brutto,
 netto,
 brutto,

0 steuer,
0 bezahlt,
0 minderung,
0 gegeben,
0 zurueck,
'' zahlart,
bemerkung referenz,
getSessionUser() login

from 

(

select
    blg_min_rechnung.id + 80000000 id,
    blg_min_rechnung.belegnummer + 80000000 beleg,
    blg_hdr_rechnung.datum,
    0 pos,
    'Zahlungen' artikel,
    concat('Rechnung ',blg_hdr_rechnung.id,' EUR ',round(blg_hdr_rechnung.brutto,2),' vom ',blg_hdr_rechnung.datum ) bemerkung,
    'Ausgangsrechnung' zusatztext,
    1 anzahl,
    blg_min_rechnung.betrag epreis,
    blg_min_rechnung.betrag netto,
    blg_min_rechnung.betrag brutto,
    0 steuer,
    0 steuersatz,
    blg_deb_rechnung.kundennummer konto,
    blg_deb_rechnung.id referenz 
from 
blg_min_rechnung
join blg_deb_rechnung 
    on blg_min_rechnung.id =  blg_min_rechnung.belegnummer
    and blg_min_rechnung.name='Bar bezahlt'
join blg_hdr_rechnung 
    on blg_hdr_rechnung.id =  blg_deb_rechnung.id



union 


select
    blg_min_krechnung.id + 7900000 id,
    blg_min_krechnung.belegnummer + 9000000 beleg,
    blg_hdr_krechnung.datum,
    0 pos,
    'Zahlungen' artikel,
    concat('Beleg ',blg_hdr_krechnung.id,' EUR ',round(blg_hdr_krechnung.brutto,2),' vom ',blg_hdr_krechnung.datum ) bemerkung,
    'Eingangsrechnung' zusatztext,
    1 anzahl,
    blg_min_krechnung.betrag*-1 epreis,
    blg_min_krechnung.betrag*-1 netto,
    blg_min_krechnung.betrag*-1 brutto,
    0 steuer,
    0 steuersatz,
    blg_krd_krechnung.kundennummer konto,
    blg_krd_krechnung.id referenz 
from 
blg_min_krechnung
join blg_krd_krechnung 
    on blg_krd_krechnung.id =  blg_min_krechnung.belegnummer
    and blg_min_krechnung.name='Bar bezahlt'
join blg_hdr_krechnung 
    on blg_hdr_krechnung.id =  blg_krd_krechnung.id

) sub


on duplicate key update id = values(id)

;


insert into blg_buchungskonten_cashpayment
(
    id,
    kundennummer,
    kostenstelle
)


select 
sub.beleg,
'731' kundennummer,
0 kostenstelle

from 

(

select
    blg_min_rechnung.id + 80000000 id,
    blg_min_rechnung.belegnummer + 80000000 beleg,
    0 pos,
    'Zahlungen' artikel,
    concat('Rechnung ',blg_hdr_rechnung.id,' EUR ',round(blg_hdr_rechnung.brutto,2),' vom ',blg_hdr_rechnung.datum ) bemerkung,
    'Ausgangsrechnung' zusatztext,
    1 anzahl,
    blg_min_rechnung.betrag epreis,
    blg_min_rechnung.betrag netto,
    blg_min_rechnung.betrag brutto,
    0 steuer,
    0 steuersatz,
    blg_deb_rechnung.kundennummer konto,
    blg_deb_rechnung.id referenz 
from 
blg_min_rechnung
join blg_deb_rechnung 
    on blg_min_rechnung.id =  blg_min_rechnung.belegnummer
    and blg_min_rechnung.name='Bar bezahlt'
join blg_hdr_rechnung 
    on blg_hdr_rechnung.id =  blg_deb_rechnung.id



union 


select
    blg_min_krechnung.id + 7900000 id,
    blg_min_krechnung.belegnummer + 9000000 beleg,
    0 pos,
    'Zahlungen' artikel,
    concat('Beleg ',blg_hdr_krechnung.id,' EUR ',round(blg_hdr_krechnung.brutto,2),' vom ',blg_hdr_krechnung.datum ) bemerkung,
    'Eingangsrechnung' zusatztext,
    1 anzahl,
    blg_min_krechnung.betrag*-1 epreis,
    blg_min_krechnung.betrag*-1 netto,
    blg_min_krechnung.betrag*-1 brutto,
    0 steuer,
    0 steuersatz,
    blg_krd_krechnung.kundennummer konto,
    blg_krd_krechnung.id referenz 
from 
blg_min_krechnung
join blg_krd_krechnung 
    on blg_krd_krechnung.id =  blg_min_krechnung.belegnummer
    and blg_min_krechnung.name='Bar bezahlt'
join blg_hdr_krechnung 
    on blg_hdr_krechnung.id =  blg_krd_krechnung.id

) sub

on duplicate key update id = values(id)

;









insert into blg_pos_cashpayment
(
    id,
    beleg,
    pos,
    artikel,
    bemerkung,
    zusatztext,
    anzahl,
    epreis,
    netto,
    brutto,
    steuer,
    steuersatz,
    konto,
    referenz
)




select
    blg_min_rechnung.id + 80000000 id,
    blg_min_rechnung.belegnummer + 80000000 beleg,
    0 pos,
    'Zahlungen' artikel,
    concat('Rechnung ',blg_hdr_rechnung.id,' EUR ',round(blg_hdr_rechnung.brutto,2),' vom ',blg_hdr_rechnung.datum ) bemerkung,
    'Ausgangsrechnung' zusatztext,
    1 anzahl,
    blg_min_rechnung.betrag epreis,
    blg_min_rechnung.betrag netto,
    blg_min_rechnung.betrag brutto,
    0 steuer,
    0 steuersatz,
    blg_deb_rechnung.kundennummer konto,
    blg_deb_rechnung.id referenz 
from 
blg_min_rechnung
join blg_deb_rechnung 
    on blg_min_rechnung.id =  blg_min_rechnung.belegnummer
    and blg_min_rechnung.name='Bar bezahlt'
join blg_hdr_rechnung 
    on blg_hdr_rechnung.id =  blg_deb_rechnung.id



union 


select
    blg_min_krechnung.id + 7900000 id,
    blg_min_krechnung.belegnummer + 9000000 beleg,
    0 pos,
    'Zahlungen' artikel,
    concat('Beleg ',blg_hdr_krechnung.id,' EUR ',round(blg_hdr_krechnung.brutto,2),' vom ',blg_hdr_krechnung.datum ) bemerkung,
    'Eingangsrechnung' zusatztext,
    1 anzahl,
    blg_min_krechnung.betrag*-1 epreis,
    blg_min_krechnung.betrag*-1 netto,
    blg_min_krechnung.betrag*-1 brutto,
    0 steuer,
    0 steuersatz,
    blg_krd_krechnung.kundennummer konto,
    blg_krd_krechnung.id referenz 
from 
blg_min_krechnung
join blg_krd_krechnung 
    on blg_krd_krechnung.id =  blg_min_krechnung.belegnummer
    and blg_min_krechnung.name='Bar bezahlt'
join blg_hdr_krechnung 
    on blg_hdr_krechnung.id =  blg_krd_krechnung.id


on duplicate key update id = values(id),
    beleg= values(beleg),
    pos= values(pos),
    artikel= values(artikel),
    bemerkung= values(bemerkung),
    zusatztext= values(zusatztext),
    anzahl= values(anzahl),
    epreis= values(epreis),
    netto= values(netto),
    brutto= values(brutto),
    steuer= values(steuer),
    steuersatz= values(steuersatz),
    konto= values(konto),
    referenz= values(referenz)

;