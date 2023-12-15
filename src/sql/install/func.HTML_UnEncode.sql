CREATE OR REPLACE FUNCTION `HTML_UnEncode`(X longblob) RETURNS longblob
    DETERMINISTIC
BEGIN 

DECLARE TextString longblob ; 
SET TextString = X ; 

IF INSTR( X , '&#351;' ) 
THEN SET TextString = REPLACE(TextString, '&#351;','Ş') ; 
END IF ; 

IF INSTR( X , '&#34;' ) 
THEN SET TextString = REPLACE(TextString, '&#34;',' ') ; 
END IF ; 


IF INSTR( X , '&quot;' ) 
THEN SET TextString = REPLACE(TextString, '&quot;','"') ; 
END IF ; 


IF INSTR( X , '&apos;' ) 
THEN SET TextString = REPLACE(TextString, '&apos;','"') ; 
END IF ; 


IF INSTR( X , '&amp;' ) 
THEN SET TextString = REPLACE(TextString, '&amp;','&') ; 
END IF ; 


IF INSTR( X , '&lt;' ) 
THEN SET TextString = REPLACE(TextString, '&lt;','<') ; 
END IF ; 


IF INSTR( X , '&gt;' ) 
THEN SET TextString = REPLACE(TextString, '&gt;','>') ; 
END IF ; 


IF INSTR( X , '&nbsp;' ) 
THEN SET TextString = REPLACE(TextString, '&nbsp;',' ') ; 
END IF ; 


IF INSTR( X , '&iexcl;' ) 
THEN SET TextString = REPLACE(TextString, '&iexcl;','¡') ; 
END IF ; 


IF INSTR( X , '&cent;' ) 
THEN SET TextString = REPLACE(TextString, '&cent;','¢') ; 
END IF ; 


IF INSTR( X , '&pound;' ) 
THEN SET TextString = REPLACE(TextString, '&pound;','£') ; 
END IF ; 


IF INSTR( X , '&curren;' ) 
THEN SET TextString = REPLACE(TextString, '&curren;','¤') ; 
END IF ; 


IF INSTR( X , '&yen;' ) 
THEN SET TextString = REPLACE(TextString, '&yen;','¥') ; 
END IF ; 


IF INSTR( X , '&brvbar;' ) 
THEN SET TextString = REPLACE(TextString, '&brvbar;','¦') ; 
END IF ; 


IF INSTR( X , '&sect;' ) 
THEN SET TextString = REPLACE(TextString, '&sect;','§') ; 
END IF ; 


IF INSTR( X , '&uml;' ) 
THEN SET TextString = REPLACE(TextString, '&uml;','¨') ; 
END IF ; 


IF INSTR( X , '&copy;' ) 
THEN SET TextString = REPLACE(TextString, '&copy;','©') ; 
END IF ; 


IF INSTR( X , '&ordf;' ) 
THEN SET TextString = REPLACE(TextString, '&ordf;','ª') ; 
END IF ; 


IF INSTR( X , '&laquo;' ) 
THEN SET TextString = REPLACE(TextString, '&laquo;','«') ; 
END IF ; 


IF INSTR( X , '&not;' ) 
THEN SET TextString = REPLACE(TextString, '&not;','¬') ; 
END IF ; 


IF INSTR( X , '&shy;' ) 
THEN SET TextString = REPLACE(TextString, '&shy;','­') ; 
END IF ; 


IF INSTR( X , '&reg;' ) 
THEN SET TextString = REPLACE(TextString, '&reg;','®') ; 
END IF ; 


IF INSTR( X , '&macr;' ) 
THEN SET TextString = REPLACE(TextString, '&macr;','¯') ; 
END IF ; 


IF INSTR( X , '&deg;' ) 
THEN SET TextString = REPLACE(TextString, '&deg;','°') ; 
END IF ; 


IF INSTR( X , '&plusmn;' ) 
THEN SET TextString = REPLACE(TextString, '&plusmn;','±') ; 
END IF ; 


IF INSTR( X , '&sup2;' ) 
THEN SET TextString = REPLACE(TextString, '&sup2;','²') ; 
END IF ; 


IF INSTR( X , '&sup3;' ) 
THEN SET TextString = REPLACE(TextString, '&sup3;','³') ; 
END IF ; 


IF INSTR( X , '&acute;' ) 
THEN SET TextString = REPLACE(TextString, '&acute;','´') ; 
END IF ; 


IF INSTR( X , '&micro;' ) 
THEN SET TextString = REPLACE(TextString, '&micro;','µ') ; 
END IF ; 


IF INSTR( X , '&para;' ) 
THEN SET TextString = REPLACE(TextString, '&para;','¶') ; 
END IF ; 


IF INSTR( X , '&middot;' ) 
THEN SET TextString = REPLACE(TextString, '&middot;','·') ; 
END IF ; 


IF INSTR( X , '&cedil;' ) 
THEN SET TextString = REPLACE(TextString, '&cedil;','¸') ; 
END IF ; 


IF INSTR( X , '&sup1;' ) 
THEN SET TextString = REPLACE(TextString, '&sup1;','¹') ; 
END IF ; 


IF INSTR( X , '&ordm;' ) 
THEN SET TextString = REPLACE(TextString, '&ordm;','º') ; 
END IF ; 


IF INSTR( X , '&raquo;' ) 
THEN SET TextString = REPLACE(TextString, '&raquo;','»') ; 
END IF ; 


IF INSTR( X , '&frac14;' ) 
THEN SET TextString = REPLACE(TextString, '&frac14;','¼') ; 
END IF ; 


IF INSTR( X , '&frac12;' ) 
THEN SET TextString = REPLACE(TextString, '&frac12;','½') ; 
END IF ; 


IF INSTR( X , '&frac34;' ) 
THEN SET TextString = REPLACE(TextString, '&frac34;','¾') ; 
END IF ; 


IF INSTR( X , '&iquest;' ) 
THEN SET TextString = REPLACE(TextString, '&iquest;','¿') ; 
END IF ; 


IF INSTR( X , '&times;' ) 
THEN SET TextString = REPLACE(TextString, '&times;','×') ; 
END IF ; 


IF INSTR( X , '&divide;' ) 
THEN SET TextString = REPLACE(TextString, '&divide;','÷') ; 
END IF ; 


IF INSTR( X , '&Agrave;' ) 
THEN SET TextString = REPLACE(TextString, '&Agrave;','À') ; 
END IF ; 


IF INSTR( X , '&Aacute;' ) 
THEN SET TextString = REPLACE(TextString, '&Aacute;','Á') ; 
END IF ; 


IF INSTR( X , '&Acirc;' ) 
THEN SET TextString = REPLACE(TextString, '&Acirc;','Â') ; 
END IF ; 


IF INSTR( X , '&Atilde;' ) 
THEN SET TextString = REPLACE(TextString, '&Atilde;','Ã') ; 
END IF ; 


IF INSTR( X , '&Auml;' ) 
THEN SET TextString = REPLACE(TextString, '&Auml;','Ä') ; 
END IF ; 


IF INSTR( X , '&Aring;' ) 
THEN SET TextString = REPLACE(TextString, '&Aring;','Å') ; 
END IF ; 


IF INSTR( X , '&AElig;' ) 
THEN SET TextString = REPLACE(TextString, '&AElig;','Æ') ; 
END IF ; 


IF INSTR( X , '&Ccedil;' ) 
THEN SET TextString = REPLACE(TextString, '&Ccedil;','Ç') ; 
END IF ; 


IF INSTR( X , '&Egrave;' ) 
THEN SET TextString = REPLACE(TextString, '&Egrave;','È') ; 
END IF ; 


IF INSTR( X , '&Eacute;' ) 
THEN SET TextString = REPLACE(TextString, '&Eacute;','É') ; 
END IF ; 


IF INSTR( X , '&Ecirc;' ) 
THEN SET TextString = REPLACE(TextString, '&Ecirc;','Ê') ; 
END IF ; 


IF INSTR( X , '&Euml;' ) 
THEN SET TextString = REPLACE(TextString, '&Euml;','Ë') ; 
END IF ; 


IF INSTR( X , '&Igrave;' ) 
THEN SET TextString = REPLACE(TextString, '&Igrave;','Ì') ; 
END IF ; 


IF INSTR( X , '&Iacute;' ) 
THEN SET TextString = REPLACE(TextString, '&Iacute;','Í') ; 
END IF ; 


IF INSTR( X , '&Icirc;' ) 
THEN SET TextString = REPLACE(TextString, '&Icirc;','Î') ; 
END IF ; 


IF INSTR( X , '&Iuml;' ) 
THEN SET TextString = REPLACE(TextString, '&Iuml;','Ï') ; 
END IF ; 


IF INSTR( X , '&ETH;' ) 
THEN SET TextString = REPLACE(TextString, '&ETH;','Ð') ; 
END IF ; 


IF INSTR( X , '&Ntilde;' ) 
THEN SET TextString = REPLACE(TextString, '&Ntilde;','Ñ') ; 
END IF ; 


IF INSTR( X , '&Ograve;' ) 
THEN SET TextString = REPLACE(TextString, '&Ograve;','Ò') ; 
END IF ; 


IF INSTR( X , '&Oacute;' ) 
THEN SET TextString = REPLACE(TextString, '&Oacute;','Ó') ; 
END IF ; 


IF INSTR( X , '&Ocirc;' ) 
THEN SET TextString = REPLACE(TextString, '&Ocirc;','Ô') ; 
END IF ; 


IF INSTR( X , '&Otilde;' ) 
THEN SET TextString = REPLACE(TextString, '&Otilde;','Õ') ; 
END IF ; 


IF INSTR( X , '&Ouml;' ) 
THEN SET TextString = REPLACE(TextString, '&Ouml;','Ö') ; 
END IF ; 


IF INSTR( X , '&Oslash;' ) 
THEN SET TextString = REPLACE(TextString, '&Oslash;','Ø') ; 
END IF ; 


IF INSTR( X , '&Ugrave;' ) 
THEN SET TextString = REPLACE(TextString, '&Ugrave;','Ù') ; 
END IF ; 


IF INSTR( X , '&Uacute;' ) 
THEN SET TextString = REPLACE(TextString, '&Uacute;','Ú') ; 
END IF ; 


IF INSTR( X , '&Ucirc;' ) 
THEN SET TextString = REPLACE(TextString, '&Ucirc;','Û') ; 
END IF ; 


IF INSTR( X , '&Uuml;' ) 
THEN SET TextString = REPLACE(TextString, '&Uuml;','Ü') ; 
END IF ; 


IF INSTR( X , '&Yacute;' ) 
THEN SET TextString = REPLACE(TextString, '&Yacute;','Ý') ; 
END IF ; 


IF INSTR( X , '&THORN;' ) 
THEN SET TextString = REPLACE(TextString, '&THORN;','Þ') ; 
END IF ; 


IF INSTR( X , '&szlig;' ) 
THEN SET TextString = REPLACE(TextString, '&szlig;','ß') ; 
END IF ; 


IF INSTR( X , '&agrave;' ) 
THEN SET TextString = REPLACE(TextString, '&agrave;','à') ; 
END IF ; 


IF INSTR( X , '&aacute;' ) 
THEN SET TextString = REPLACE(TextString, '&aacute;','á') ; 
END IF ; 


IF INSTR( X , '&acirc;' ) 
THEN SET TextString = REPLACE(TextString, '&acirc;','â') ; 
END IF ; 


IF INSTR( X , '&atilde;' ) 
THEN SET TextString = REPLACE(TextString, '&atilde;','ã') ; 
END IF ; 


IF INSTR( X , '&auml;' ) 
THEN SET TextString = REPLACE(TextString, '&auml;','ä') ; 
END IF ; 


IF INSTR( X , '&aring;' ) 
THEN SET TextString = REPLACE(TextString, '&aring;','å') ; 
END IF ; 


IF INSTR( X , '&aelig;;' ) 
THEN SET TextString = REPLACE(TextString, '&aelig;;','æ;;') ; 
END IF ; 

IF INSTR( X , '&aelig;' ) 
THEN SET TextString = REPLACE(TextString, '&aelig;','æ') ; 
END IF ; 


IF INSTR( X , '&ccedil;' ) 
THEN SET TextString = REPLACE(TextString, '&ccedil;','ç') ; 
END IF ; 


IF INSTR( X , '&egrave;' ) 
THEN SET TextString = REPLACE(TextString, '&egrave;','è') ; 
END IF ; 


IF INSTR( X , '&eacute;' ) 
THEN SET TextString = REPLACE(TextString, '&eacute;','é') ; 
END IF ; 


IF INSTR( X , '&ecirc;' ) 
THEN SET TextString = REPLACE(TextString, '&ecirc;','ê') ; 
END IF ; 


IF INSTR( X , '&euml;' ) 
THEN SET TextString = REPLACE(TextString, '&euml;','ë') ; 
END IF ; 


IF INSTR( X , '&igrave;' ) 
THEN SET TextString = REPLACE(TextString, '&igrave;','ì') ; 
END IF ; 


IF INSTR( X , '&iacute;' ) 
THEN SET TextString = REPLACE(TextString, '&iacute;','í') ; 
END IF ; 


IF INSTR( X , '&icirc;' ) 
THEN SET TextString = REPLACE(TextString, '&icirc;','î') ; 
END IF ; 


IF INSTR( X , '&iuml;' ) 
THEN SET TextString = REPLACE(TextString, '&iuml;','ï') ; 
END IF ; 


IF INSTR( X , '&eth;' ) 
THEN SET TextString = REPLACE(TextString, '&eth;','ð') ; 
END IF ; 


IF INSTR( X , '&ntilde;' ) 
THEN SET TextString = REPLACE(TextString, '&ntilde;','ñ') ; 
END IF ; 


IF INSTR( X , '&ograve;' ) 
THEN SET TextString = REPLACE(TextString, '&ograve;','ò') ; 
END IF ; 


IF INSTR( X , '&oacute;' ) 
THEN SET TextString = REPLACE(TextString, '&oacute;','ó') ; 
END IF ; 


IF INSTR( X , '&ocirc;' ) 
THEN SET TextString = REPLACE(TextString, '&ocirc;','ô') ; 
END IF ; 


IF INSTR( X , '&otilde;' ) 
THEN SET TextString = REPLACE(TextString, '&otilde;','õ') ; 
END IF ; 


IF INSTR( X , '&ouml;' ) 
THEN SET TextString = REPLACE(TextString, '&ouml;','ö') ; 
END IF ; 


IF INSTR( X , '&oslash;' ) 
THEN SET TextString = REPLACE(TextString, '&oslash;','ø') ; 
END IF ; 


IF INSTR( X , '&ugrave;' ) 
THEN SET TextString = REPLACE(TextString, '&ugrave;','ù') ; 
END IF ; 


IF INSTR( X , '&uacute;' ) 
THEN SET TextString = REPLACE(TextString, '&uacute;','ú') ; 
END IF ; 


IF INSTR( X , '&ucirc;' ) 
THEN SET TextString = REPLACE(TextString, '&ucirc;','û') ; 
END IF ; 


IF INSTR( X , '&uuml;' ) 
THEN SET TextString = REPLACE(TextString, '&uuml;','ü') ; 
END IF ; 


IF INSTR( X , '&yacute;' ) 
THEN SET TextString = REPLACE(TextString, '&yacute;','ý') ; 
END IF ; 


IF INSTR( X , '&thorn;' ) 
THEN SET TextString = REPLACE(TextString, '&thorn;','þ') ; 
END IF ; 


IF INSTR( X , '&yuml;' ) 
THEN SET TextString = REPLACE(TextString, '&yuml;','ÿ') ; 
END IF ; 

RETURN TextString ; 

END
