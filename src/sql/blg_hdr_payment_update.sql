insert into blg_hdr_payment (
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
kontoauszuege.id + 80000000 id,
VALUTA datum,
VALUTA faelligam,
VALUTA buchungsdatum,
0 skonto_netto,
0 skonto_brutto,
0 provision_netto,
0 provision_brutto,
kontoauszuege.BETRAG netto,
kontoauszuege.BETRAG brutto,

0 steuer,
0 bezahlt,
kontoauszuege.BETRAG minderung,
0 gegeben,
0 zurueck,
'' zahlart,
VERWENDUNGSZWECK1 referenz,
getSessionUser() login

from 
kontoauszuege_belege
join 
kontoauszuege
on kontoauszuege_belege.id = kontoauszuege.id 
join
blg_pay_rechnung
on kontoauszuege_belege.belegnummer = blg_pay_rechnung.belegnummer
and blg_pay_rechnung.datum=kontoauszuege.VALUTA
join 
blg_deb_rechnung on blg_pay_rechnung.belegnummer =  kontoauszuege_belege.belegnummer
group by  kontoauszuege.id

union


select 
kontoauszuege.id + 80000000 id,
VALUTA datum,
VALUTA faelligam,
VALUTA buchungsdatum,
0 skonto_netto,
0 skonto_brutto,
0 provision_netto,
0 provision_brutto,
kontoauszuege.BETRAG netto,
kontoauszuege.BETRAG brutto,

0 steuer,
0 bezahlt,
kontoauszuege.BETRAG minderung,
0 gegeben,
0 zurueck,
'' zahlart,
VERWENDUNGSZWECK1 referenz,
getSessionUser() login

from 
kontoauszuege_belege
join 
kontoauszuege
on kontoauszuege_belege.id = kontoauszuege.id 
join
blg_pay_krechnung
on kontoauszuege_belege.belegnummer = blg_pay_krechnung.belegnummer
and blg_pay_krechnung.datum=kontoauszuege.VALUTA
join 
blg_krd_krechnung on blg_krd_krechnung.id =  kontoauszuege_belege.belegnummer
group by  kontoauszuege.id

on duplicate key update id = values(id)

;







insert into blg_pos_payment
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
    blg_pay_rechnung.id + 200900000 id,
    kontoauszuege.id + 80000000 beleg,
    0 pos,
    'Zahlungen' artikel,
    concat('Rechnung ',blg_hdr_rechnung.id,' EUR ',round(blg_hdr_rechnung.brutto,2),' vom ',blg_hdr_rechnung.datum ) bemerkung,
    'Ausgangsrechnung' zusatztext,
    1 anzahl,
    blg_pay_rechnung.betrag epreis,
    blg_pay_rechnung.betrag netto,
    blg_pay_rechnung.betrag brutto,
    0 steuer,
    0 steuersatz,
    blg_deb_rechnung.kundennummer konto,
    blg_deb_rechnung.id referenz 
from 
kontoauszuege_belege
join kontoauszuege
    on kontoauszuege_belege.id = kontoauszuege.id 
join blg_pay_rechnung
    on kontoauszuege_belege.belegnummer = blg_pay_rechnung.belegnummer
    and blg_pay_rechnung.datum=kontoauszuege.VALUTA
join blg_deb_rechnung 
    on blg_deb_rechnung.id =  kontoauszuege_belege.belegnummer
join blg_hdr_rechnung 
    on blg_hdr_rechnung.id =  blg_deb_rechnung.id



union 


select
    blg_pay_krechnung.id + 7900000 id,
    kontoauszuege.id + 80000000 beleg,
    0 pos,
    'Zahlungen' artikel,
    concat('Beleg ',blg_hdr_krechnung.id,' EUR ',round(blg_hdr_krechnung.brutto,2),' vom ',blg_hdr_krechnung.datum ) bemerkung,
    'Eingangsrechnung' zusatztext,
    1 anzahl,
    blg_pay_krechnung.betrag*-1 epreis,
    blg_pay_krechnung.betrag*-1 netto,
    blg_pay_krechnung.betrag*-1 brutto,
    0 steuer,
    0 steuersatz,
    blg_krd_krechnung.kundennummer konto,
    blg_krd_krechnung.id referenz 
from 
kontoauszuege_belege
join kontoauszuege
    on kontoauszuege_belege.id = kontoauszuege.id 
join blg_pay_krechnung
    on kontoauszuege_belege.belegnummer = blg_pay_krechnung.belegnummer
    and blg_pay_krechnung.datum=kontoauszuege.VALUTA
join blg_krd_krechnung 
    on blg_krd_krechnung.id =  kontoauszuege_belege.belegnummer
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







insert into blg_buchungskonten_payment
(
    id,
    kundennummer,
    kostenstelle
)


select 
kontoauszuege.id + 80000000 id,
'1200' kundennummer,
0 kostenstelle

from 


kontoauszuege_belege
join kontoauszuege
    on kontoauszuege_belege.id = kontoauszuege.id 
join blg_pay_krechnung
    on kontoauszuege_belege.belegnummer = blg_pay_krechnung.belegnummer
    and blg_pay_krechnung.datum=kontoauszuege.VALUTA
join blg_krd_krechnung 
    on blg_krd_krechnung.id =  kontoauszuege_belege.belegnummer
join blg_hdr_krechnung 
    on blg_hdr_krechnung.id =  blg_krd_krechnung.id

group by  kontoauszuege.id

union

select 
kontoauszuege.id + 80000000 id,
'1200' kundennummer,
0 kostenstelle

from 

kontoauszuege_belege
join kontoauszuege
    on kontoauszuege_belege.id = kontoauszuege.id 
join blg_pay_rechnung
    on kontoauszuege_belege.belegnummer = blg_pay_rechnung.belegnummer
    and blg_pay_rechnung.datum=kontoauszuege.VALUTA
join blg_deb_rechnung 
    on blg_deb_rechnung.id =  kontoauszuege_belege.belegnummer
join blg_hdr_rechnung 
    on blg_hdr_rechnung.id =  blg_deb_rechnung.id

group by  kontoauszuege.id


on duplicate key update id = values(id)

;
















insert into blg_pos_payment
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
    blg_pay_rechnung.id + 200900000 id,
    kontoauszuege.id + 80000000 beleg,
    0 pos,
    'Zahlungen' artikel,
    concat('Rechnung ',blg_hdr_rechnung.id,' EUR ',round(blg_hdr_rechnung.brutto,2),' vom ',blg_hdr_rechnung.datum ) bemerkung,
    'Ausgangsrechnung' zusatztext,
    1 anzahl,
    blg_pay_rechnung.betrag epreis,
    blg_pay_rechnung.betrag netto,
    blg_pay_rechnung.betrag brutto,
    0 steuer,
    0 steuersatz,
    blg_deb_rechnung.kundennummer konto,
    blg_deb_rechnung.id referenz 
from 
kontoauszuege_belege
join kontoauszuege
    on kontoauszuege_belege.id = kontoauszuege.id 
join blg_pay_rechnung
    on kontoauszuege_belege.belegnummer = blg_pay_rechnung.belegnummer
    and blg_pay_rechnung.datum=kontoauszuege.VALUTA
join blg_deb_rechnung 
    on blg_deb_rechnung.id =  kontoauszuege_belege.belegnummer
join blg_hdr_rechnung 
    on blg_hdr_rechnung.id =  blg_deb_rechnung.id



union 


select
    blg_pay_krechnung.id + 7900000 id,
    kontoauszuege.id + 80000000 beleg,
    0 pos,
    'Zahlungen' artikel,
    concat('Beleg ',blg_hdr_krechnung.id,' EUR ',round(blg_hdr_krechnung.brutto,2),' vom ',blg_hdr_krechnung.datum ) bemerkung,
    'Eingangsrechnung' zusatztext,
    1 anzahl,
    blg_pay_krechnung.betrag*-1 epreis,
    blg_pay_krechnung.betrag*-1 netto,
    blg_pay_krechnung.betrag*-1 brutto,
    0 steuer,
    0 steuersatz,
    blg_krd_krechnung.kundennummer konto,
    blg_krd_krechnung.id referenz 
from 
kontoauszuege_belege
join kontoauszuege
    on kontoauszuege_belege.id = kontoauszuege.id 
join blg_pay_krechnung
    on kontoauszuege_belege.belegnummer = blg_pay_krechnung.belegnummer
    and blg_pay_krechnung.datum=kontoauszuege.VALUTA
join blg_krd_krechnung 
    on blg_krd_krechnung.id =  kontoauszuege_belege.belegnummer
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
