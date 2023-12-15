CREATE OR REPLACE PROCEDURE `saldenausgleich_amazonmarket`( )
BEGIN 


set @debug=0;
set @sessionuser='thomas.hoffmann@tualo.de';

    FOR record IN (
        select 
            h.id belegnummer,
            h.filename,
            h.datum,
            p.* 
        from 
            blg_pos_amazonmarket p
            join blg_hdr_amazonmarket h
            on p.beleg = h.id
        where 
            p.saldenausgleich = 0 
            and p.currency='EUR' 
            and p.artikel in ('ItemPrice','Promotion')
            and p.referenz <> ''
        limit 1000000
    ) DO

            select 
                max(id) plenty_beleg
            into 
                @plenty_beleg
            from 
                blg_hdr_plenty 
            where 
                blg_hdr_plenty.zusatzinfo = record.referenz
            ;

            if @plenty_beleg is not null then
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
                "companycode", "0000",
                "office", 1,
                "positions",
                    json_array (
                        json_object(
                            "article", 'Saldenausgleich',
                            "position", 1,
                            "account", '0000',
                            "amount", 1.00000,
                            "referenz", record.belegnummer,
                            "vid", record.id,
                            "vzusatz", "amazonmarket",
                            "notes", "",
                            "additionaltext", "",
                            "singleprice", record.brutto,
                            "tax", 0.00000,
                            "net",  record.brutto,
                            "taxvalue", 0,
                            "gross", record.brutto
                        ),
                        json_object(
                            "article", 'Saldenausgleich',
                            "position", 1,
                            "account", '0000',
                            "amount", -1.00000,
                            "referenz", record.belegnummer,
                            "vid", record.id,
                            "vzusatz", "amazonmarket",
                            "notes", "",
                            "additionaltext", "",
                            "singleprice", record.brutto*-1,
                            "tax", 0.00000,
                            "net",  record.brutto*-1,
                            "taxvalue", 0,
                            "gross", record.brutto*-1
                        )
                    )

            );

            call setReport('salden',@report,@o);

            select json_value(@o,'$.id') id,record.referenz,@plenty_beleg;
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
                @plenty_beleg,
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

            else

                update blg_pos_amazonmarket  set saldenausgleich = -1 where id = record.id;

            end if;



    END FOR;

END //

alter table blg_pos_amazonmarket add currency varchar(20) default null; 
alter table blg_pos_amazonmarket add saldenausgleich bigint default 0;
create index idx_blg_pos_amazonmarket_saldenausgleich on blg_pos_amazonmarket(saldenausgleich);
