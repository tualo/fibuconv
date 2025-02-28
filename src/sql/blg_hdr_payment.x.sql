
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
round(kontoauszuege.BETRAG,2) netto,
round(kontoauszuege.BETRAG,2) brutto,

0 steuer,
0 bezahlt,
round(kontoauszuege.BETRAG,2) minderung,
0 gegeben,
0 zurueck,
'' zahlart,
VERWENDUNGSZWECK1 referenz,
getSessionUser() login

from 
(
    select * from kontoauszuege where rechnungsnummer in ('Lohn','Sozial','Steuer','Steuern')
) kontoauszuege

group by  kontoauszuege.id


on duplicate key update id = values(id) ;


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
(select * from kontoauszuege where rechnungsnummer in ('Lohn','Sozial','Steuer','Steuern')) kontoauszuege

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
    kontoauszuege.id + 80000000 id,
    kontoauszuege.id + 80000000 beleg,
    0 pos,
    'Zahlungen' artikel,
    concat('',kontoauszuege.rechnungsnummer,' EUR ',round(kontoauszuege.BETRAG,2),' vom ',kontoauszuege.VALUTA ) bemerkung,
    'Spezial' zusatztext,
    1 anzahl,
    kontoauszuege.BETRAG epreis,
    kontoauszuege.BETRAG netto,
    kontoauszuege.BETRAG brutto,
    0 steuer,
    0 steuersatz,
    agenda_kontoauszug_sachkonto(kontoauszuege.rechnungsnummer) konto,
    agenda_kontoauszug_sachkonto(kontoauszuege.rechnungsnummer) referenz 
from 
(select * from kontoauszuege where rechnungsnummer in ('Lohn','Sozial','Steuer','Steuern')) kontoauszuege

group by  kontoauszuege.id
on duplicate key update id = values(id)
