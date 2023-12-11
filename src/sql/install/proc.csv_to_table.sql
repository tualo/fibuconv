delimiter //

CREATE OR REPLACE PROCEDURE `csv_to_table`( 
    IN data LONGBLOB,
    IN line_delim VARCHAR(10),
    IN column_delim VARCHAR(10),
    IN temp_table varchar(128)
)
BEGIN 
    DECLARE rowdata LONGBLOB;

    drop table if exists temp_csv_lines;
    call xsplit(data,line_delim,'temp_csv_lines');
    set rowdata = concat((select word from temp_csv_lines where num=1) );
    select rowdata x;
    set @l=rowdata;
--    select substring_index(regexp_replace(rowdata,"[^0-9a-zA-Z,\-\.\;]",""),char(59),-1) word , 19999 num ;
    drop table if exists temp_csv_columns;
    call split_str_into_table(rowdata,column_delim,'temp_csv_columns');
    select * from temp_csv_columns;
    select 
        group_concat(
            concat('`',word,'` varchar(255)')
            order by num
            separator ','
        ) create_columns,
        group_concat(
            concat('`',word,'`')
            order by num
            separator ','
        ) insert_columns
    into 
        @create_columns,
        @insert_columns
    from 
        temp_csv_columns
    ;
    SET @create_table = concat('create temporary table ',temp_table,' (',@create_columns,')');

    PREPARE stmt FROM @create_table;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    FOR record in ((select word from temp_csv_lines where num>1 and trim(word)<>'' order by num)) DO


        drop table if exists temp_csv_column_data;
        call split_str_into_table(record.word,column_delim,'temp_csv_column_data');

        
        select 
            
            group_concat(
                concat('',quote(word),'')
                order by num
                separator ','
            ) insert_values
        into 
            @insert_values
        from 
            temp_csv_column_data
        ;
        SET @insert_table = concat('insert into ',temp_table,' (',@insert_columns,') values (',@insert_values,')');
        
        PREPARE stmt FROM @insert_table;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END FOR;

END //