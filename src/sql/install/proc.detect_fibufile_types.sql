DELIMITER // 
CREATE OR REPLACE PROCEDURE `detect_fibufile_types`() 
BEGIN 
    declare charset_type varchar(20);
    declare incorrect_string_type int default 0;

    DECLARE incorrect_string CONDITION FOR SQLSTATE '22007';

    DECLARE CONTINUE HANDLER FOR incorrect_string
    SET
        incorrect_string_type = 1;

    set
        charset_type = 'utf8';

    for record in (
        select
            *
        from
            view_readtable_fibufiles
        where
            detected_type = 'unkown'
            and __file_type in ('text/plain', 'text/csv')
        limit
            10000
    ) DO
    set
        incorrect_string_type = 0;

    select
        record.__file_id;

    set
        @d = (
            select
                from_base64(SUBSTRING_INDEX(data, ',', -1)) names
            from
                ds_files_data
            where
                file_id = record.__file_id
        );

    set
        @orig = @d;

    select
        record.__file_name,
        record.__file_type;

    if (SUBSTRING(@d, 1, 2)) = 'PK'
    and locate('[Content_Types].xml', @d) > 1 then
    select
        'Excel' found;

    update
        fibufiles
    set
        typ = 'Excel'
    where
        fibufiles.id = record.id;

    elseif locate('MediaBox', @d) > 1
    and locate('PDF', @d) > 1 then
    select
        'PDF' found;

    update
        fibufiles
    set
        typ = 'PDF'
    where
        fibufiles.id = record.id;

    elseif record.__file_type = 'application/pdf' then
    select
        'PDF' found;

    update
        fibufiles
    set
        typ = 'PDF'
    where
        fibufiles.id = record.id;

    else drop table if exists temp_csv_lines;

    call split_str_into_table(SUBSTRING(@d, 1, 1200), char(10), 'temp_csv_lines');

    if incorrect_string_type = 1 then
    set
        charset_type = 'latin1';

    set
        @d = CONVERT (@d USING latin1);

    set
        incorrect_string_type = 0;

    drop table if exists temp_csv_lines;

    call split_str_into_table(SUBSTRING(@d, 1, 1200), char(10), 'temp_csv_lines');

    --  select SUBSTRING(@d,1,150) x1;
    -- select locate("\0",SUBSTRING(@d,1,200)) yy ;
    if (
        locate("\0", SUBSTRING(@d, 1, 200)) > 0
    ) THEN -- select locate("\0",SUBSTRING(@d,1,200)) yy ;
    set
        incorrect_string_type = 1;

    set
        @d = @orig;

    END IF;

    end if;

    set
        @d = @orig;

    select
        SUBSTRING(@orig, 1, 50) x;

    --     select  SUBSTRING(@d,1,200) yy ;
    if incorrect_string_type = 1 then
    set
        charset_type = 'utf16le';

    set
        @d = CONVERT (@d USING utf16le);

    set
        incorrect_string_type = 0;

    drop table if exists temp_csv_lines;

    call split_str_into_table(SUBSTRING(@d, 1, 1200), char(10), 'temp_csv_lines');

    -- select SUBSTRING(@d,1,150) x2;
    if (
        locate("\0", SUBSTRING(@d, 1, 200)) > 0
    ) THEN
    set
        incorrect_string_type = 1;

    set
        @d = @orig;

    END IF;

    end if;

    select
        incorrect_string_type;

    set
        @row = (
            select
                word
            from
                temp_csv_lines
            where
                num = 1
        );

    set
        @found = false;

    for type in (
        select
            *
        from
            fibufiles_typen
    ) do -- select locate(type.text_to_find,@row);
    if (
        locate(type.text_to_find, @row) >= 1
    ) then
    select
        type.id found;

    update
        fibufiles
    set
        typ = type.id,
        detected_charset = charset_type
    where
        fibufiles.id = record.id;

    set
        @found = true;

    end if;

    end for;

    if @found = false then
    select
        SUBSTRING(@d, 1, 1500) x;

    end if;

    -- detected_type
    end if;

    -- if  locate("Wähbbrung;Soll-Haben;Rechnungsbetrag (brutto);Buchungsschlüssel;Gegenkonto (Erlöskonto);Rechn.-Nr. (Belegfeld 1);Order ID (Belegfeld 2);Belegdatum;Konto (Debitor);Kunde ID;Kunde;Firma;Vorname;Nachname;Rechnungsanschrift Land ISO;Lieferanschrift Land ISO;Buchungstext;Umsatz;Ust ID;Brutto-Betrag (mit Vorzeichen);Zusatzinfo Art;Zusatzinfo Inhalt;MwSt;Zahlungseingang;Zusatzinfo Art 2;Zusatzinfo Inhalt 2;Datum",@row) l;
    END FOR;

END //