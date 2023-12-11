delimiter //

CREATE OR REPLACE PROCEDURE `split_str_into_table`( 
    IN data LONGBLOB,
    IN delim VARCHAR(10),
    IN temp_table varchar(128)
)
BEGIN 
DECLARE length_delim integer;
set length_delim=length(delim);

SET @sql = concat('
create temporary table ',temp_table,' as
with recursive
data as (
    select ',quote(data),' names , 1 num 
),
cte as (
    select 
    num,
    substring(names, 1, locate(',quote(delim),', names) - 1) word,
    substring(names, locate(',quote(delim),', names) + ',length_delim,') names
    from data
    union all
    select 
    num +1 num,
    substring(names, 1, locate(',quote(delim),', names) - 1) word,
    substring(names, locate(',quote(delim),', names) + ',length_delim,') names
    from cte
    where locate(',quote(delim),', names) > 0

),
last as (
   select substring_index(regexp_replace(',quote(data),',"[^0-9a-zA-Z,\-\.\;]",""),',quote(delim),',-1) word , 19999 num where ',quote(delim),'=char(59)
)
select num,word from cte
union select num,word from last
'); 
select @sql;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //