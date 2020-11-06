CREATE PROCEDURE instr(
  str VARCHAR(255),
  mask VARCHAR(255),
  strt SMALLINT DEFAULT 1,
  occur smallint default 1
)
RETURNING INT;

DEFINE slen SMALLINT;
DEFINE mlen SMALLINT;
DEFINE tempstr VARCHAR(255);
DEFINE tempmask VARCHAR(255);
DEFINE nomatch SMALLINT;
DEFINE count SMALLINT;
DEFINE pos SMALLINT;
DEFINE retpos SMALLINT;
DEFINE i SMALLINT;
DEFINE j SMALLINT;
DEFINE srchstrt SMALLINT;

LET slen = length(str);
LET mlen = length(mask);
LET count = 0;
LET nomatch = 0;
LET pos = 1;
LET retpos = 1;
LET tempstr = '';
LET tempmask = '';
LET srchstrt = strt;

IF(strt < 0) THEN 
  
  -- reserve the str
  FOR i=1 TO slen
    LET tempstr = str[1,1] || tempstr;
    LET str = str[2,255];
  END FOR;
  
  --reserve the mask
  FOR i=1 TO mlen
    LET tempmask = mask[1,1] || tempmask;
    LET mask = mask[2,255];
  END FOR;
  
  LET srchstrt = strt * -1;
  LET str = tempstr;
  LET mask = tempmask;
  
END IF;

FOR j=1 TO slen 

  LET tempstr = str;
  LET tempmask = mask;

  FOR i=1 to mlen
    IF (tempmask[1,1] != tempstr[1,1]) THEN
      LET nomatch=1;
      EXIT FOR;
    END IF;

    LET tempmask = tempmask[2,255];
    LET tempstr = tempstr[2,255];
  END FOR;
  
  IF(nomatch = 0) THEN
    IF(pos >= srchstrt) THEN
      LET count = count + 1;
    END IF;
    IF (count = occur) THEN
      IF(strt < 0) THEN
        RETURN slen - pos +1;
      ELSE
        RETURN pos;
      END IF;
    END IF;
  END IF;

  LET str = str[2,255];
  LET nomatch = 0;
  LET pos = pos + 1;

END FOR;

RETURN 0;

END PROCEDURE;