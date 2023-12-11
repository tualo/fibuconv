delimiter //
CREATE OR REPLACE PROCEDURE `fibufiles_amazon_markets`( )
BEGIN 
    DECLARE filedata LONGBLOB;
set session group_concat_max_len=4294967295;

set @debug=1;
set @sessionuser='thomas.hoffmann@tualo.de';

    FOR files IN (
        select * from  view_readtable_fibufiles where 
            detected_type='amazon-m'
            and ( processed_report=0 or processed_report is null)
            and duplicate_file = 1
            limit 1
    ) DO

        select files.__file_id,files.__file_name,files.detected_charset;
        set filedata = (select  from_base64( SUBSTRING_INDEX(data ,',',-1) )  names from ds_files_data where file_id = files.__file_id);
        set filedata = HTML_UnEncode(filedata);
        select substring(filedata,1,800);


        drop table if exists temp_auszahlung;
        drop table if exists temp_csv_lines;
        drop table if exists temp_csv_columns;
        call csv_to_table(filedata,char(10),char(9),'temp_auszahlung');
        select 
            str_to_date(`deposit-date`,'%d.%m.%Y %H:%i:%s UTC'),
            str_to_date(`settlement-start-date`,'%d.%m.%Y %H:%i:%s UTC'),
            str_to_date(`settlement-end-date`,'%d.%m.%Y %H:%i:%s UTC'),
            german_to_decimal(`total-amount`),
            currency
        into @dt,@dt_start,@dt_end,@gesamt,@currency 
        from temp_auszahlung where length(`deposit-date`)> 3;
        select max(`marketplace-name`) marketplace into @marketplace from temp_auszahlung;
        select count(*) anzahl from temp_auszahlung;
        for reports in (
                select 
                json_object(
                    "date", cast(@dt as date),
                    "bookingdate",  cast(@dt as date),
                    "service_period_start",  cast(@dt_start as date),
                    "service_period_stop",  cast(@dt_end as date),
                    "time", cast(@dt as time),
                    "warehouse", 0,
                    "reference", `settlement-id`,
                    "filename",files.__file_name,
                    "fileid",files.__file_id,
                    "referencenr", '70002',
                    "costcenter", 0,
                    "address", concat(files.__file_name,char(10),files.__file_id,char(10),`settlement-id`),
                    "companycode", "0000",
                    "office", 1,
                    "kindofbill","netto",
                    "marketplace",@marketplace,
                    "currency", @currency,
                    "positions",
                        json_arrayagg(
                                pos
                        )

                ) c
                from (
                    select 
                        temp_auszahlung.*,
                        json_object(
                            "article", `amount-type`,
                            "position", row_number() over (),
                            "account", '0000',
                            "amount", 1.00000,
                            "vdatum", str_to_date(`posted-date`,'%d.%m.%Y'),
                            "reference", `order-id`,
                            "notes", `amount-description`,
                            "marketplace", `marketplace-name`,
                            "fremdbezeichnung", `amount`,
                            "additionaltext", `order-item-code`,
                            "currency", @currency,
                            "singleprice", if(@currency not in ('SEK') , german_to_decimal(`amount`),`amount`),
                            "tax", 0.00000,
                            "net", if(@currency not in ('SEK') , german_to_decimal(`amount`),`amount`),
                            "taxvalue", 0,
                            "gross",if (@currency not in ('SEK') , german_to_decimal(`amount`),`amount`)
                        ) pos
                    from temp_auszahlung
                    where length(`deposit-date`)<3
                ) sample
            limit 1
        ) do
            -- delete from temp_testoutput;
            -- insert into temp_testoutput(id,data) values (1,reports.c);

            call setReport('amazonmarket',reports.c,@o);
            show warnings;
            select json_value(@o,'$.id');
        end for;
        select files.__file_id;
        update fibufiles set processed_report=1 where file_id = files.__file_id;

    END FOR;
END //