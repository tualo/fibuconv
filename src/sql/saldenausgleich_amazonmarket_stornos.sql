
CREATE OR REPLACE  PROCEDURE `saldenausgleich_amazonmarket_stornos`( 

)
BEGIN 
    set @sessionuser='thomas.hoffmann@tualo.de';
    
    
    for  storno_rec  in (
        select 
            blg_hdr_plenty.*,
            blg_adressen_plenty.kundennummer,
            blg_adressen_plenty.kostenstelle
        from 
            blg_hdr_plenty
            join blg_adressen_plenty on blg_hdr_plenty.id = blg_adressen_plenty.id
            
        where zahlungsart in (
            'Amazon'
        )
        and year(datum)=2024
        and length(zusatzinfo) < 8
        and offen <> 0 
        and blg_hdr_plenty.id in (10248460,10167595)
        limit 10
    ) do 

        for  orig_rec  in (
            select blg_hdr_plenty.*,
            blg_adressen_plenty.kundennummer,
            blg_adressen_plenty.kostenstelle
            
             from blg_hdr_plenty 
            join blg_adressen_plenty on blg_hdr_plenty.id = blg_adressen_plenty.id
            where zusatzinfo2 = concat('ORDER ',storno_rec.zusatzinfo) 
        ) do 

            if 
                orig_rec.offen + storno_rec.offen = 0
                and orig_rec.kundennummer = storno_rec.kundennummer
                and orig_rec.kostenstelle = storno_rec.kostenstelle
            then

                set @report =
                    json_object(
                        "date", storno_rec.datum,
                        "bookingdate", storno_rec.datum,
                        "service_period_start", orig_rec.datum,
                        "service_period_stop", storno_rec.datum,
                        "time", '00:00:01',
                        "warehouse", 0,
                        "reference", storno_rec.kundennummer ,
                        "referencenr", '0000',
                        "costcenter", 0,
                        "address", "",
                        "kindofbill","netto",
                        "companycode", "0000",
                        "office", 1,

                        "netto",0,
                        "brutto",0,
                        "steuer",0,

                        "zahlart","korrektur_amz",
                        "gedruckt",storno_rec.datum,
                        "gedruckt_am",storno_rec.datum,
                        "provision_brutto",0,
                        "provision_netto",0,
                        "hardwareid","",
                        "mahnstufe",0,
                        "archiv",0,
                        "mandatsreferenz","",
                        "buchungskreis","0000",
                        "bezahlt",0,
                        "tabellenzusatz","salden",
                        "abschluss",0,
                        "sperre",0,
                        "steuernummer","",
                        "istoffen",0,
                        "zurueck",0,
                        "gegeben",0,
                        "skonto_netto",0,
                        "skonto_brutto",0,
                        "layout",0,
                        "datev_export",0,
                        "offen",0,
                        "minderung",0,
                        "positions",
                            json_array (
                                json_object(
                                    "article", 'Saldenausgleich',
                                    "position", 1,
                                    "account", '0000',
                                    "amount", 1.00000,
                                    "referenz", storno_rec.id,
                                    "plenty_report", storno_rec.id,
                                    "vid", storno_rec.id,
                                    "vzusatz", "plenty",
                                    "notes", "",
                                    "additionaltext", "",
                                    "singleprice", storno_rec.offen,
                                    "tax", 0.00000,
                                    "net",  storno_rec.offen,
                                    "taxvalue", 0,
                                    "gross", storno_rec.offen,
                                    "vdatum",storno_rec.datum,


                                    "handwerkeranteil", 0,
                                    "bereich","",
                                    "fremdbezeichnung","",

                                    "ekpreis",0,
                                    "ekpreis_summe",0,
                                    "gldpreis",0,
                                    "gldpreis_summe",0,

                                    "gewicht",0,
                                    "bezugsnebenkosten",0,
                                    "einheit_symbol","",
                                    "einheit_faktor","",
                                    "einheit","",
                                    "preistyp",0,
                                    "kombiartikel",0,
                                    "einspeiserkennzeichen",""

                                ),
                                json_object(
                                    "article", 'Saldenausgleich',
                                    "position", 1,
                                    "account", '0000',
                                    "amount", -1.00000,
                                    "referenz", orig_rec.id,
                                    "plenty_report",orig_rec.id,
                                    "vid", orig_rec.id,
                                    "vzusatz", "plenty",
                                    "notes", "",
                                    "additionaltext", "",
                                    "singleprice", orig_rec.offen ,
                                    "tax", 0.00000,
                                    "net",  orig_rec.offen,
                                    "taxvalue", 0,
                                    "gross", orig_rec.offen,
                                    "vdatum",orig_rec.datum,


                                    "handwerkeranteil", 0,
                                    "bereich","",
                                    "fremdbezeichnung","",

                                    "ekpreis",0,
                                    "ekpreis_summe",0,
                                    "gldpreis",0,
                                    "gldpreis_summe",0,

                                    "gewicht",0,
                                    "bezugsnebenkosten",0,
                                    "einheit_symbol","",
                                    "einheit_faktor","",
                                    "einheit","",
                                    "preistyp",0,
                                    "kombiartikel",0,
                                    "einspeiserkennzeichen",""
                                )
                            )
        
                    );

                call setReport('salden',@report,@o);
                -- select @report;

                select 
                    orig_rec.offen as orig_offen,
                    storno_rec.offen as storno_offen,
                    json_value(@o,'$.id') as saldenausgleich_id,
                    orig_rec.id as orig_id,
                    storno_rec.id as storno_id;


                select ifnull(max(id),1)+1 into @index from blg_pay_plenty;
        
                insert into blg_pay_plenty (
                    id,
                    datum,
                    belegnummer,
                    art,
                    betrag,
                    referenztabellenzusatz,
                    referenzbelegnummer
    
                ) values (
                    @index,
                    orig_rec.datum,
                    orig_rec.id,
                    'Saldenausgleich',
                    orig_rec.offen  ,
                    'salden',
                    json_value(@o,'$.id')
                );

                select ifnull(max(id),1)+1 into @index from blg_pay_plenty;
        
                insert into blg_pay_plenty (
                    id,
                    datum,
                    belegnummer,
                    art,
                    betrag,
                    referenztabellenzusatz,
                    referenzbelegnummer
    
                ) values (
                    @index,
                    storno_rec.datum,
                    storno_rec.id,
                    'Saldenausgleich',
                    storno_rec.offen ,
                    'salden',
                    json_value(@o,'$.id')
                );

                call recalculateHeader('plenty',orig_rec.id);
                call recalculateHeader('plenty',storno_rec.id);

                select id,datum,brutto,offen from blg_hdr_plenty where id in (orig_rec.id,storno_rec.id);
            end if;
        
        end for;

    end for; 
 

END

/*

CREATE DEFINER=`thomashoffmann`@`%` PROCEDURE `saldenausgleich_amazonmarket`( )
BEGIN 


    -- set @debug=1;

    FOR record IN (
        select 
            h.id belegnummer,
            h.filename,
            h.datum,
            p.*,
            min(blg_hdr_plenty.id) plenty_beleg
        from 
            blg_pos_amazonmarket p
            join blg_hdr_amazonmarket h
            on p.beleg = h.id
            join blg_hdr_plenty
                on blg_hdr_plenty.zusatzinfo = p.referenz
            and blg_hdr_plenty.zusatzinfo<>'' 
            and blg_hdr_plenty.zusatzinfo is not null 
        where 
            p.saldenausgleich = 0
            and p.currency='EUR' 
            and p.vdatum >= saldenausgleich_min_date()
            and p.vdatum <= saldenausgleich_max_date()
            and p.artikel in ('ItemPrice','Promotion')
            and p.referenz <> ''
        group by p.id
        order by p.vdatum
        
    ) DO
            select 'x';
                    set @report =
                    json_object(
                        "date", record.datum,
                        "bookingdate", record.datum,
                        "service_period_start", record.datum,
                        "service_period_stop", record.datum,
                        "time", '00:00:01',
                        "warehouse", 0,
                        "reference", record.belegnummer ,
                        "referencenr", '0000',
                        "costcenter", 0,
                        "address", "",
                        "kindofbill","netto",
                        "companycode", "0000",
                        "office", 1,

                        "netto",0,
                        "brutto",0,
                        "steuer",0,

                        "zahlart","amz",
                        "gedruckt",record.datum,
                        "gedruckt_am",record.datum,
                        "provision_brutto",0,
                        "provision_netto",0,
                        "hardwareid","",
                        "mahnstufe",0,
                        "archiv",0,
                        "mandatsreferenz","",
                        "buchungskreis","0000",
                        "bezahlt",0,
                        "tabellenzusatz","salden",
                        "abschluss",0,
                        "sperre",0,
                        "steuernummer","",
                        "istoffen",0,
                        "zurueck",0,
                        "gegeben",0,
                        "skonto_netto",0,
                        "skonto_brutto",0,
                        "layout",0,
                        "datev_export",0,
                        "offen",0,
                        "minderung",0,
                        "positions",
                            json_array (
                                json_object(
                                    "article", 'Saldenausgleich',
                                    "position", 1,
                                    "account", '0000',
                                    "amount", 1.00000,
                                    "referenz", record.belegnummer,
                                    "plenty_report", record.plenty_beleg,
                                    "vid", record.id,
                                    "vzusatz", "amazonmarket",
                                    "notes", "",
                                    "additionaltext", "",
                                    "singleprice", record.brutto,
                                    "tax", 0.00000,
                                    "net",  record.brutto,
                                    "taxvalue", 0,
                                    "gross", record.brutto,
                                    "vdatum",record.datum,


                                    "handwerkeranteil", 0,
                                    "bereich","",
                                    "fremdbezeichnung","",

                                    "ekpreis",0,
                                    "ekpreis_summe",0,
                                    "gldpreis",0,
                                    "gldpreis_summe",0,

                                    "gewicht",0,
                                    "bezugsnebenkosten",0,
                                    "einheit_symbol","",
                                    "einheit_faktor","",
                                    "einheit","",
                                    "preistyp",0,
                                    "kombiartikel",0,
                                    "einspeiserkennzeichen",""

                                ),
                                json_object(
                                    "article", 'Saldenausgleich',
                                    "position", 1,
                                    "account", '0000',
                                    "amount", -1.00000,
                                    "referenz", record.belegnummer,
                                    "plenty_report",record.plenty_beleg,
                                    "vid", record.id,
                                    "vzusatz", "amazonmarket",
                                    "notes", "",
                                    "additionaltext", "",
                                    "singleprice", record.brutto*-1,
                                    "tax", 0.00000,
                                    "net",  record.brutto*-1,
                                    "taxvalue", 0,
                                    "gross", record.brutto*-1,
                                    "vdatum",record.datum,


                                    "handwerkeranteil", 0,
                                    "bereich","",
                                    "fremdbezeichnung","",

                                    "ekpreis",0,
                                    "ekpreis_summe",0,
                                    "gldpreis",0,
                                    "gldpreis_summe",0,

                                    "gewicht",0,
                                    "bezugsnebenkosten",0,
                                    "einheit_symbol","",
                                    "einheit_faktor","",
                                    "einheit","",
                                    "preistyp",0,
                                    "kombiartikel",0,
                                    "einspeiserkennzeichen",""
                                )
                            )
        
                    );
        
                    select 'y';
                    call setReport('salden',@report,@o);
        
                    select 'z';
                    select json_value(@o,'$.id') id,record.referenz;

                    select ifnull(max(id),1)+1 into @index from blg_pay_plenty;
        
                    insert into blg_pay_plenty (
                        id,
                        datum,
                        belegnummer,
                        art,
                        betrag,
                        referenztabellenzusatz,
                        referenzbelegnummer
        
                    ) values (
                        @index,
                        record.datum,
                        record.plenty_beleg,
                        'Saldenausgleich',
                        record.brutto,
                        'salden',
                        json_value(@o,'$.id')
                    );
                    select @index;
                    select ifnull(max(id),1)+1 into @index from blg_pay_amazonmarket;
                    insert into blg_pay_amazonmarket (
                        id,
                        datum,
                        belegnummer,
                        art,
                        betrag,
                        referenztabellenzusatz,
                        referenzbelegnummer
        
                    ) values (
                        @index,
                        record.datum,
                        record.belegnummer,
                        'Saldenausgleich',
                        record.brutto,
                        'salden',
                        json_value(@o,'$.id')
                    );
                    
                    update blg_pos_amazonmarket  set saldenausgleich = json_value(@o,'$.id') where id = record.id;
                    call recalculateHeader('amazonmarket',record.belegnummer);
                    call recalculateHeader('plenty',record.plenty_beleg);
            

            if exists(select * from saldenausgleich_state where id = 'stoploop' and value=1) then
                SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO=30001, MESSAGE_TEXT='Stop Loop';
            end if;


    END FOR;

END
*/