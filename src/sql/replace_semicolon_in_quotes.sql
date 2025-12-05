DELIMITER //
CREATE or replace FUNCTION replace_semicolon_in_quotes(input_text longtext)
RETURNS TEXT
DETERMINISTIC
NO SQL
BEGIN
    DECLARE result longtext DEFAULT '';
    DECLARE current_char CHAR(1);
    DECLARE inside_quotes BOOLEAN DEFAULT FALSE;
    DECLARE i INT DEFAULT 1;
    DECLARE text_length INT;
    
    SET text_length = CHAR_LENGTH(input_text);
    
    WHILE i <= text_length DO
        SET current_char = SUBSTRING(input_text, i, 1);
        
        -- Prüfen ob Anführungszeichen
        IF current_char = '"' THEN
            SET inside_quotes = NOT inside_quotes;
            SET result = CONCAT(result, current_char);
        -- Semikolon innerhalb von Anführungszeichen durch Leerzeichen ersetzen
        ELSEIF current_char = ';' AND inside_quotes THEN
            SET result = CONCAT(result, ' ');
        ELSE
            SET result = CONCAT(result, current_char);
        END IF;
        
        SET i = i + 1;
    END WHILE;
    
    RETURN result;
END //