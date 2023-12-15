CREATE OR REPLACE PROCEDURE `fibufiles_otto`( )
BEGIN 

    declare incorrect_string_type int default 0;
    declare incorrect_column_type int default 0;
    declare incorrect_table_type int default 0;
    declare incorrect_column_count int default 0;
    declare incorrect_cursor int default 0;
    DECLARE filedata LONGBLOB;

/*
    DECLARE incorrect_string CONDITION FOR SQLSTATE '22007';
    DECLARE incorrect_column CONDITION FOR SQLSTATE '42S22';
    DECLARE incorrect_table CONDITION FOR SQLSTATE '42S02';
    DECLARE incorrect_cursor_e CONDITION FOR SQLSTATE '24099';
    
    DECLARE incorrect_columncount CONDITION FOR SQLSTATE '42000';
    

    DECLARE CONTINUE HANDLER FOR incorrect_cursor_e SET incorrect_cursor = 1;
    DECLARE CONTINUE HANDLER FOR incorrect_string SET incorrect_string_type = 1;
    DECLARE CONTINUE HANDLER FOR incorrect_column SET incorrect_column_type = 1;
    DECLARE CONTINUE HANDLER FOR incorrect_columncount SET incorrect_column_count = 1;
    DECLARE CONTINUE HANDLER FOR incorrect_table SET incorrect_table_type = 1;
    */

    set @debug=1;
set @sessionuser='thomas.hoffmann@tualo.de';


    FOR files IN (
        select * from  view_readtable_fibufiles where 
            detected_type='otto-aus'
        and processed_report=0
        and duplicate_file = 1
        limit 1
    ) DO

        select files.__file_id,files.__file_name,files.detected_charset;
        set filedata = (select  from_base64( SUBSTRING_INDEX(data ,',',-1) )  names from ds_files_data where file_id = files.__file_id);
        set filedata = HTML_UnEncode(filedata);
        select substring(filedata,1,800);

        set incorrect_string_type = 0;
            

        if (incorrect_string_type = 0) then
            drop table if exists temp_auszahlung2;
            drop table if exists temp_csv_lines;
            drop table if exists temp_csv_columns;

            -- select 'aaaa';
            -- select filedata;
            call csv_to_table(filedata,char(10),char(59),'temp_auszahlung2');
            -- select 'xxx';
            
            set incorrect_column_type = 0;
            set incorrect_column_count = 0;
            set incorrect_table_type=0;
            set incorrect_cursor=0;
            if (incorrect_column_type=0 and incorrect_column_count=0 and incorrect_table_type=0) then
                for reports in (

                        select 
                        json_object(
                            "date", if( max(`Forderungsdatum`) like '____-__-__',max(`Forderungsdatum`), str_to_date(max(`Forderungsdatum`),'%d.%m.%Y') ),
                            "bookingdate", if( max(`Forderungsdatum`) like '____-__-__',max(`Forderungsdatum`), str_to_date(max(`Forderungsdatum`),'%d.%m.%Y') ),
                            "service_period_start", if( max(`Forderungsdatum`) like '____-__-__',max(`Forderungsdatum`), str_to_date(max(`Forderungsdatum`),'%d.%m.%Y') ),
                            "service_period_stop", if( max(`Forderungsdatum`) like '____-__-__',max(`Forderungsdatum`), str_to_date(max(`Forderungsdatum`),'%d.%m.%Y') ),
                            "time", '00:00:01',
                            "warehouse", 0,
                            "reference", files.__file_id,
                            "filename",files.__file_name,
                            "fileid",files.__file_id,
                            "referencenr", '70001',
                            "costcenter", 0,
                            "address", concat(files.__file_name,char(10),files.__file_id),
                            "companycode", "0000",
                            "office", 1,
                            "positions",
                                json_arrayagg(
                                        pos
                                )

                        ) c
                        from (
                            select 
                                temp_auszahlung2.*,
                                json_object(
                                    "article", `Vorgangstyp`,
                                    "position", row_number() over (),
                                    "account", '0000',
                                    "amount", 1.00000,
                                    "notes", `RechnungID`,
                                    "additionaltext", `Auftragsnummer`,
                                    "singleprice", german_to_decimal(`Betrag`),
                                    "tax", 0.00000,
                                    "net",  german_to_decimal(`Betrag`),
                                    "taxvalue", 0,
                                    "gross", german_to_decimal(`Betrag`)
                                ) pos
                            from temp_auszahlung2
                        ) sample
                    limit 1


                ) do
                        -- select reports.c;
                        call setReport('ottoauszahlung',reports.c,@o);
                        show warnings;
                        select json_value(@o,'$.id');
                end for;
                    if (incorrect_table_type=0) then    
            update fibufiles set processed_report=1 where file_id=files.__file_id;
                    end if;


            end if; -- incorrect column
        end if; -- incorrect type

    END FOR;




END