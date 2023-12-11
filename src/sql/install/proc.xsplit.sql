delimiter //

CREATE OR REPLACE PROCEDURE `xsplit`( 
    IN _list LONGBLOB,
    IN delim VARCHAR(10),
    IN temp_table varchar(128)
)
BEGIN 

DECLARE _next LONGBLOB DEFAULT NULL;
DECLARE _nextlen INT DEFAULT NULL;
DECLARE _line INT DEFAULT 1;

DECLARE _value LONGBLOB DEFAULT NULL;


SET @create_table = CONCAT('CREATE TEMPORARY TABLE ',temp_table,' (num integer primary key, word LONGBLOB)');
PREPARE stmt FROM @create_table;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

iterator:
LOOP
    
    
    IF CHAR_LENGTH(TRIM(_list)) = 0 OR _list IS NULL THEN
    LEAVE iterator;
    END IF;

    
    SET _next = SUBSTRING_INDEX(_list,delim,1);

    
    
    
    SET _nextlen = CHAR_LENGTH(_next);

    
    SET _value = TRIM(_next);



    SET @insert = CONCAT('INSERT INTO ',temp_table,' (num,word) VALUES (?,?)');
    PREPARE stmt FROM @insert;
    EXECUTE stmt using _line,_value;
    DEALLOCATE PREPARE stmt;



    
    
    
    
    SET _list = INSERT(_list,1,_nextlen + 1,'');
    set _line = _line + 1;
END LOOP;

END //