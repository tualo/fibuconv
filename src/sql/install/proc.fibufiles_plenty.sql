delimiter //

CREATE OR REPLACE PROCEDURE `fibufiles_plenty`( )
BEGIN 

    declare incorrect_column_count int default 0;
    DECLARE filedata LONGBLOB;

    DECLARE incorrect_columncount CONDITION FOR SQLSTATE '21S01';
    DECLARE CONTINUE HANDLER FOR incorrect_columncount SET incorrect_column_count = 1;
    
    set @debug=0;
    set @sessionuser='thomas.hoffmann@tualo.de';

    FOR files IN (
        select * from  view_readtable_fibufiles where 
            detected_type='plenty'
            and (processed_report=0 or processed_report is null)
            and duplicate_file = 1
            limit 10000
    ) DO
        select files.__file_id,files.__file_name,files.detected_charset;
        set filedata = (select  from_base64( SUBSTRING_INDEX(data ,',',-1) )  names from ds_files_data where file_id = files.__file_id);
        set filedata = HTML_UnEncode(filedata);
        select substring(filedata,1,800);
        drop table if exists sample;

        set incorrect_column_count=0;
        call csv_to_table(filedata,char(10),char(59),'sample');

        if (incorrect_column_count=1) then
            update fibufiles set processed_report=2 where file_id=files.__file_id;
        else
            call fibufiles_plenty_address();
            for reports in (

                        select 
                        json_object(
                            "fremdbeleg", `Rechn.-Nr. (Belegfeld 1)`,
                            "date", str_to_date(`Belegdatum`,'%d.%m.%Y %H:%i'),
                            "time", cast(str_to_date(`Belegdatum`,'%d.%m.%Y %H:%i') as time),
                            "bookingdate", str_to_date(`Belegdatum`,'%d.%m.%Y %H:%i'),
                            "service_period_start", ifnull ( str_to_date(`Datum Auftragseingang`,'%d.%m.%Y %H:%i'), str_to_date(`Belegdatum`,'%d.%m.%Y %H:%i') ),
                            "service_period_stop", ifnull ( str_to_date(`Datum Warenausgang`,'%d.%m.%Y %H:%i'), str_to_date(`Belegdatum`,'%d.%m.%Y %H:%i')  ),
                            "warehouse", 0,
                            "reference", `Order ID (Belegfeld 2)`,
                            "filename",files.__file_name,
                            "fileid",files.__file_id,
                            "herkunft" ,herkunft,
                            "kindofbill","netto",
                            "zusatzinfo", `Zusatzinfo Inhalt`,
                            "zusatzinfo2", `Zusatzinfo Inhalt 2`,
                            "zahlungsart", zahlungsart,
                            "paymentid", 
                                if( 
                                        zahlungsart in (
                                                'Amazon Pay',
                                                'Amazon Payments',
                                                'eBay Payment',
                                                'Kaufland.de Payment',
                                                'Metro Paypal',
                                                'OTTO Payment',
                                                'idealo Direktkauf',
                                                'Paypal',
                                                'Paypal Plus (Lastschrift, Kreditkarte, Kauf auf Rechnung)',
                                                'PayPal Express'
                                        ) ,
                                        `Zusatzinfo Inhalt`,
                                        if( 
                                        zahlungsart in (
                                                'PayPal Plus'
                                        ) ,
                                        `Zusatzinfo Inhalt 2`,null
                                        )
                                ),
                                
                                
                                
                                
                            "referencenr", kundennummer,
                            "costcenter", kostenstelle,
                            "iso", `Rechnungsanschrift Land ISO`,
                            "address", concat(`Firma`,char(10),`Vorname`,' ',`Nachname`),
                            "companycode", "0000",
                            "brutto_currency", if(`Soll-Haben`='S',1,-1) * german_to_decimal(`Rechnungsbetrag (brutto in Auftragswährung)`) ,
                            "kurs", (if(`Soll-Haben`='S',1,-1) * german_to_decimal(`Rechnungsbetrag (brutto in Auftragswährung)`))  / (if(`Soll-Haben`='S',1,-1) * german_to_decimal(`Rechnungsbetrag (brutto in Systemwährung)`)),
                                    
                            "office", 1,
                            "positions",
                                json_arrayagg(
                                        pos
                                )

                        ) c,
                        postid
                        from (
                            select 
                                `Kunde ID` kundennummer,
                                md5(concat(
                                    trim(ifnull(sample.kunde,'')),
                                    trim(ifnull(sample.firma,'')),
                                    trim(ifnull(sample.vorname,'')),
                                    trim(ifnull(sample.nachname,'')),
                                    trim(ifnull(sample.`rechnungsanschrift land iso`,''))
                                )) postid,
                                0 kostenstelle,
                                sample.*,
                                json_object(
                                    -- "id", `Rechn.-Nr. (Belegfeld 1)` * 1000 + row_number() over (partition by `Rechn.-Nr. (Belegfeld 1)`  order by `Gegenkonto (Erlöskonto)`),
                                    "article", `Zusatzinfo Art 2`,
                                    "position", row_number() over ( partition by `Rechn.-Nr. (Belegfeld 1)` order by `Gegenkonto (Erlöskonto)`),
                                    "account", if(`Gegenkonto (Erlöskonto)`="",0,`Gegenkonto (Erlöskonto)`),
                                    "amount", 1.00000,
                                    "notes", null,
                                    "additionaltext", "",
                                    "currency",`Auftragswährung`,
                                    "brutto_currency", if(`Soll-Haben`='S',1,-1) * german_to_decimal(`Rechnungsbetrag (brutto in Auftragswährung)`) ,
                                    "kurs", (if(`Soll-Haben`='S',1,-1) * german_to_decimal(`Rechnungsbetrag (brutto in Auftragswährung)`))  / (if(`Soll-Haben`='S',1,-1) * german_to_decimal(`Rechnungsbetrag (brutto in Systemwährung)`)),
                                    "singleprice", if(`Soll-Haben`='S',1,-1) * ( german_to_decimal(`Rechnungsbetrag (brutto in Systemwährung)`) - german_to_decimal(`MwSt in Systemwährung`) ),
                                    "tax", 19.00000,
                                    "net", if(`Soll-Haben`='S',1,-1) * ( german_to_decimal(`Rechnungsbetrag (brutto in Systemwährung)`) - german_to_decimal(`MwSt in Systemwährung`) ),
                                    "taxvalue", if(`Soll-Haben`='S',1,-1) * german_to_decimal(`MwSt in Systemwährung`),
                                    "gross", if(`Soll-Haben`='S',1,-1) * german_to_decimal(`Rechnungsbetrag (brutto in Systemwährung)`)
                                ) pos
                            from 
                                sample /*
                                join adressen 
                                on `Kunde ID`=adressen.kundennummer
                                and postid = md5(concat(
                                    trim(ifnull(sample.kunde,'')),
                                    trim(ifnull(sample.firma,'')),
                                    trim(ifnull(sample.vorname,'')),
                                    trim(ifnull(sample.nachname,'')),
                                    trim(ifnull(sample.`rechnungsanschrift land iso`,''))
                                ))*/
                        ) sample
                        group by `Rechn.-Nr. (Belegfeld 1)`


            ) do
                    select reports.c;
                    set @kn=null;
                    set @kst=null;
                    select max(kundennummer),max(kostenstelle) 
                    into @kn,@kst 
                    from adressen 
                    where postid=reports.postid and adressen.kundennummer=JSON_VALUE(@r, '$.referencenr');
                    SET @r = reports.c;
                    SET @r = JSON_SET(@r, '$.referencenr', @kn);
                    SET @r = JSON_SET(@r, '$.costcenter', @kst);

                    call setReport('plenty',reports.c,@o);

            end for;


            update fibufiles set processed_report=1 where file_id=files.__file_id;
        end if;
    END FOR;
END //