Is that name a valid sas variable name? (validvarnamr=V7)

 Unfortunately you need SCL to use the SASNAME function

   WORKING CODE
   SAS/WPS (exactly the same results)

     rc = prxparse('/^(?=.{1,32}$)([a-zA-Z_][a-zA-Z0-9_]*)$/');
     valid = prxmatch(rc, trim(varname));

see
https://goo.gl/3NSAqS
https://communities.sas.com/t5/General-SAS-Programming/How-to-capture-special-character-space-in-character-string/m-p/406444

https://goo.gl/fUpZgv
https://blogs.sas.com/content/sasdummy/2012/08/22/using-a-regular-expression-to-validate-a-sas-variable-name/

HAVE
====

 WORK.HAVE total obs=10

  Obs    pid    varname

    1    101     acbd
    2    102     !and   INVALID SAS NAME
    3    103     X.Y    INVALID SAS NAME
    4    104     1TVN   INVALID SAS NAME
    5    105     A
    6    106     bd
    7    107     ANKR
    8    108     K@234  INVALID SAS NAME
    9    109     KRS
   10    110     235    INVALID SAS NAME

WANT
====

  WORK.WANT total obs=10

  Obs    pid    varname    valid

    1    101     acbd        1
    2    102     !and        0  INVALID SAS NAME
    3    103     X.Y         0  INVALID SAS NAME
    4    104     1TVN        0  INVALID SAS NAME
    5    105     A           1
    6    106     bd          1
    7    107     ANKR        1
    8    108     K@234       0  INVALID SAS NAME
    9    109     KRS         1
   10    110     235         0  INVALID SAS NAME

*                _               _       _
 _ __ ___   __ _| | _____     __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \   / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/  | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|   \__,_|\__,_|\__\__,_|

;

options validvarname=v7;
data have;
retain pid;
format varname $32.;
input pid varname ;
cards4;
101 acbd
102 !and
103 X.Y
104 1TVN
105 A BCD
106 bd
107 ANKR
108 K@234
109 KRS
110 235
;;;;
run;quit;

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __  ___
/ __|/ _ \| | | | | __| |/ _ \| '_ \/ __|
\__ \ (_) | | |_| | |_| | (_) | | | \__ \
|___/\___/|_|\__,_|\__|_|\___/|_| |_|___/

;

* sas;
data want;
set have;
 rc = prxparse("/^(?=.{1,32}$)([a-zA-Z_][a-zA-Z0-9_]*)$/");
 valid = prxmatch(rc, trim(varname));
 put valid=;
 drop rc;
run;quit;

* wps;
%utl_submit_wps64('
libname wrk sas7bdat "%sysfunc(pathname(work))";
data want;
set wrk.have;
 rc = prxparse("/^(?=.{1,32}$)([a-zA-Z_][a-zA-Z0-9_]*)$/");
 valid = prxmatch(rc, trim(varname));
 put valid=;
 drop rc;
run;quit;
');




data find2;
set find1;
where found ne '';
run;


%utl_submit_wps64('
data _null_;
  valid=sasname("roger");
  put valid=;
run;quit;
');


data vars (keep=varname valid);
  length varname $ 50;
  input varname 1-50 ;
  re = prxparse('/^(?=.{1,32}$)([a-zA-Z_][a-zA-Z0-9_]*)$/');
  pos = prxmatch(re, trim(varname));
  valid = ifc(pos>0, "YES","NO");
cards;
var1
no space
1var
_temp
thisVarIsOver32charactersInLength
thisContainsFunkyChar!
_
yes_underscore_is_valid_name
run;

