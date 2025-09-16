CREATE OR REPLACE PROCEDURE `fibufiles_datemarker`( )
BEGIN 

declare min_date date;
declare main_date date;
declare max_date date;
declare cnt integer;

for rec in (select * from fibufiles where min_date is null) do
    -- your processing logic here
     select concat(`__file_name`, ' - ', `__file_size`) from view_readtable_fibufiles where id=rec.id;
    if exists(select 1 from blg_hdr_plenty where fileid=rec.file_id) then
        -- your logic for existing records
        select min(`datum`) as min_date, max(`datum`) as max_date 
            into min_date, max_date
        from blg_hdr_plenty where fileid=rec.file_id;

        select 
            datum,
            count(*) c
        into main_date, cnt
        from blg_hdr_plenty where fileid=rec.file_id
        order by c desc  limit 1;

        update fibufiles set min_date=min_date, main_date=main_date, max_date=max_date  where id=rec.id;
    end if;



    
    if exists(select 1 from blg_hdr_paypal where referenz=rec.file_id) then
        -- your logic for existing records
        select min(`datum`) as min_date, max(`datum`) as max_date 
            into min_date, max_date
        from blg_hdr_paypal where referenz=rec.file_id;

        select 
            datum,
            count(*) c
        into main_date, cnt
        from blg_hdr_paypal where referenz=rec.file_id
        order by c desc  limit 1;

        update fibufiles set min_date=min_date, main_date=main_date, max_date=max_date  where id=rec.id;
    end if;


    if exists(select 1 from blg_hdr_kaufland where referenz=rec.file_id) then
        -- your logic for existing records
        select min(`datum`) as min_date, max(`datum`) as max_date 
            into min_date, max_date
        from blg_hdr_kaufland where referenz=rec.file_id;

        select 
            datum,
            count(*) c
        into main_date, cnt
        from blg_hdr_kaufland where referenz=rec.file_id
        order by c desc  limit 1;

        update fibufiles set min_date=min_date, main_date=main_date, max_date=max_date  where id=rec.id;
    end if;
    

    if exists(select 1 from blg_hdr_amazonmarket where fileid=rec.file_id) then
        -- your logic for existing records
        select min(`datum`) as min_date, max(`datum`) as max_date 
            into min_date, max_date
        from blg_hdr_amazonmarket where fileid=rec.file_id;

        select 
            datum,
            count(*) c
        into main_date, cnt
        from blg_hdr_amazonmarket where fileid=rec.file_id
        order by c desc  limit 1;

        update fibufiles set min_date=min_date, main_date=main_date, max_date=max_date  where id=rec.id;
    end if;

end for;

END 