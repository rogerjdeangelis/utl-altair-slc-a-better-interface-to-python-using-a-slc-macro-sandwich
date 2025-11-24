%let pgm=utl-altair-slc-a-better-interface-to-python-using-a-slc-macro-sandwich;

%stop_submission;

Altair slc a better interface to python using a slc macro sandwich

Too long to post to a listserve, see github

https://github.com/rogerjdeangelis/utl-altair-slc-a-better-interface-to-python-using-a-slc-macro-sandwich

Better interface to python using a macro sandwich
I have had some issues with proc python, using more recent python and numpy.

Although you cannot use a macro wrapper, you can execute macros and
resolve macro variables and slc macros inside yor python c sandwich.

Macro in this repo, on end of this message and in
macros
https://github.com/rogerjdeangelis/utl-macros-used-in-many-of-rogerjdeangelis-repositories

PROBLEM

 create a slc sas dataset as select name, sex from [panda dataframe] where sex=F

CONTENTS

   1  usage
   2  documentation
   3  input
   4  process
   5  output cls sas dataset
   6  files created
   7  log
   8  samdwich macros

/*
 _   _ ___  __ _  __ _  ___
| | | / __|/ _` |/ _` |/ _ \
| |_| \__ \ (_| | (_| |  __/
 \__,_|___/\__,_|\__, |\___|
                 |___/
*/

/*************************************************************************************************************/
/*     INPUT             |                      PROCESS                                |     OUTPUT          */
/*options                |  %utl_slc_pybeginx(                                         | Altair SLC          */
/* validvarname=upcase ; |     return=date             /*-  return date from python-*/ |                     */
/*data sd1.have ;        |    ,resolve=Y               /*- resolve macros in python-*/ | WORK.FEMALE         */
/*  input                |    ,in=d:/sd1/have.sas7bdat /*- input sas dataset       -*/ |                     */
/*    name$              |    ,out=female              /*- output work.female      -*/ |   NAME   SEX AGE    */
/*    sex$ age;          |    ,py2r=c:/temp/py_dataframe.rds);/*- py 2 r dataframe -*/ |                     */
/*cards4;                |  cards4;                                                    |  Alice    F   13    */
/*Alfred  M 14           |                                                             |  Barbara  F   13    */
/*Alice   F 13           |  import pyreadstat as ps                                    |  Carol    F   14    */
/*Barbara F 13           |  import pandas as pd                                        |                     */
/*Carol   F 14           |  import pyreadr as pr                                       | MACRO VARIABLE DATE */
/*Henry   M 14           |  from datetime import date                                  | FROM PYTHON         */
/*James   M 12           |                                                             |                     */
/*;;;;                   |  pyperclip.copy(date.today()) # clipboard to slc macro var  | date=2025-11-24     */
/*run;quit;              |                                                             |                     */
/*                       |  have,meta = ps.read_sas7bdat("&in") # slc datastep to py   |                     */
/*                       |                                                             |                     */
/*                       |  &out=have.loc[have["SEX"] == "F"] # filter by sex          |                     */
/*                       |                                                             |                     */
/*                       |  print(&out)                                                |                     */
/*                       |                                                             |                     */
/*                       |  pr.write_rds("&py2r",&out) # panda datafame 2 r dataframe  |                     */
/*                       |  ;;;;                                                       |                     */
/*                       |  %utl_slc_pyendx                                            |                     */
/*                       |                                                             |                     */
/*                       |  %put &=date;                                               |                     */
/*                       |                                                             |                     */
/*                       |  proc print data=Female;                                    |                     */
/*                       |  run;                                                       |                     */
/*************************************************************************************************************/

/*   _                                       _        _   _
  __| | ___   ___ _   _ _ __ ___   ___ _ __ | |_ __ _| |_(_) ___  _ __
 / _` |/ _ \ / __| | | | `_ ` _ \ / _ \ `_ \| __/ _` | __| |/ _ \| `_ \
| (_| | (_) | (__| |_| | | | | | |  __/ | | | || (_| | |_| | (_) | | | |
 \__,_|\___/ \___|\__,_|_| |_| |_|\___|_| |_|\__\__,_|\__|_|\___/|_| |_|

*/

  0 Internal hardcoding, files and limitations

     HARDCODING

     options set=RHOME 'D:\r414
     d:\Python310\python.exe

     LIMITATIONS

      a Default is one input sas dataset (however you can add datasets using  ps.read_sas7bdat("path to sas dataset")
      b Only one output dataset because Altair did not provide a R or Python  package to write a sas dataset

     These files are created in the macro (c:/temp must exist)

      c:/temp/py_pgm.py         /*--- raw python program       ---*/
      c:/temp/py_pgm.pyx        /*--- resolved python program  ---*/
      c:/temp/py_pgm.log        /*--- python log               ---*/
      c:/temp/py_dataframe.rds  /*--- py dataframe to r        ---*/
      c:/temp/py_procr.sas      /*--- proc r make sas dataset  ---*/

  1  Sandwich

      a Top slice, Prep for creating python program statements
        data _null_;
         file "c:/temp/py_pgm.py";
         input;
         put _infile_;

      b  Middle Filling is the pythom program
         cards4;
         manually entered program with macro variables, should be able to use a slc macro in your R code
         ;;;;

      c  Bottom slice. This is where the work is done,

         1 resolve manually entered code
         2 submit to python interpreter
         3 copy txt to windows clipboard
         4 convert panda dataframe to R RDS file
         5 copy window clipboard text to a slc macro variable
         6 use proc r to convert the r RDS file to a sas dataset


  2  Currently the slc can read mutiple slc sas datasets but can only
     return one sas dataset. Also R and pyhton home enviromnent variable is hardcoded.

  3  c:/temp folder has to exist
     The sandwich will create
        final python code    in c:/temp/py_pgm.py
        resolved python code in c:/temp/py_pgm.pyx
        python & slc log     in c:/temp/py_pgm.log

  4  Sandwich resolves macro and macro variables in c:/temp/py_pgm.py

  5  If macro argument 'resolve=' is not empty, ie 'resolve=Y' macro triggers are resolved and code
     is piped into the python interpreter

  6  raw, unresolved python code is written to c;/temp/py_pgm_py
     resolved python code is written to c;/temp/py_pgm_pyx
  7  Log is written to c;/temp/py_pgm_log

  8  Pyhton reads a sas dataset
     import pyreadstat as ps
     have,meta = ps.read_sas7bdat('d:/sd1/have.sas7bdat')

  9  Return a macro variable from python back to the slc using windows clipboard

      a  note 'import pyperclip' is automatically added to your python code.

      b  a non empty return argument , 'return=date', copies python text to windoes clipboard

       1 from datetime import date
         pyperclip.copy(date.today())

       2 Then the slc loads the text into the return macro variable

         filename clp clipbrd ;
         data _null_;
          infile clp;
          input;
          call symputx("&return.",_infile_,"G");
         run;quit;

         Now the macro value is available in the parent slc code

  10  Python creates a R rds image of the panda dataframe created
      import pyreadr as pr
      pr.write_rds('d:/rds/pywant.rds',have)

  11  SLC 'proc r' program is dynamically created to convert the r dataframe
      in rds format to a sas dataset.

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

libname sd1 sas7bdat "d:/sd1";

options
 validvarname=upcase ;

data sd1.have ;
  input
    name$
    sex$ age;
cards4;
Alfred  M 14
Alice   F 13
Barbara F 13
Carol   F 14
Henry   M 14
James   M 12
;;;;
run;quit;

SD1.HAVE

Obs     NAME      SEX    AGE

 1     Alfred      M      14
 2     Alice       F      13
 3     Barbara     F      13
 4     Carol       F      14
 5     Henry       M      14
 6     James       M      12

/*
 _ __  _ __ ___   ___ ___  ___ ___
| `_ \| `__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
*/

%utl_slc_pybeginx(
   return=date             /*-  return date            -*/
  ,resolve=Y               /*- resolve macros in python-*/
  ,in=d:/sd1/have.sas7bdat /*- input sas dataset       -*/
  ,out=female              /*- output work.female      -*/
  ,py2r=c:/temp/py_dataframe.rds);/*- py 2 r dataframe -*/
cards4;

import pyreadstat as ps
import pandas as pd
import pyreadr as pr
from datetime import date

pyperclip.copy(date.today()) # clipboard to slc macro var

have,meta = ps.read_sas7bdat("&in") # slc datasetro r

&out=have.loc[have["SEX"] == "F"] # filter by sex

print(&out)

pr.write_rds("&py2r",&out) # panda datafame 2 r dataframe
;;;;
%utl_slc_pyendx

%put &=date;

proc print data=Female;
run;

/*           _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| `_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
*/

Altair SLC

Altair SLC
      NAME SEX   AGE
1    Alice   F  13.0
2  Barbara   F  13.0
3    Carol   F  14.0

Altair SLC

     NAME SEX AGE
1   Alice   F  13
2 Barbara   F  13
3   Carol   F  14

Altair SLC

Obs     NAME      SEX    AGE

 1     Alice       F      13
 2     Barbara     F      13
 3     Carol       F      14


/*__ _ _
 / _(_) | ___  ___
| |_| | |/ _ \/ __|
|  _| | |  __/\__ \
|_| |_|_|\___||___/

*/

-----------------------------------------------------------------------------

/*--- ORIGINAL PYTHON CODE ---*/

c:/temp/py_pgm.py
-----------------

import pyreadstat as ps
import pandas as pd
import pyreadr as pr
from datetime import date

pyperclip.copy(date.today())

have,meta = ps.read_sas7bdat("&in")

&out=have.loc[have["SEX"] == "F"]

print(&out)

pr.write_rds("&py2r",&out)

-----------------------------------------------------------------------------

/*--- RESOLVED PYTHON CODE ---*/

c:/temp/py_pgm.pyx
------------------

import pyperclip

import pyreadstat as ps
import pandas as pd
import pyreadr as pr
from datetime import date

pyperclip.copy(date.today())

have,meta = ps.read_sas7bdat("d:/sd1/have.sas7bdat")

female=have.loc[have["SEX"] == "F"]

print(female)

pr.write_rds("c:/temp/py_dataframe.rds",female)

.*-- panda dataframe to

-----------------------------------------------------------------------------

/*--- EXPORTED R DATAFRAME RDS FILE FROM PYTHON ---*/

c:/temp/py_dataframe.rds
------------------------


SCII Flatfile Ruler & Hex
utlrulr
c:/temp/py_dataframe.rds

 --- Record Number ---  1   ---  Record Length ---- 80

X.....................................Alice........Barbara........Carol.........
1...5....10...15...20...25...30...35...40...45...50...55...60...65...70...75...8
50000000000000000100000001000000000000466660000000046766760000000046766000100000
8A0002023002300033000300000003000900051C93500090007212212100090005312FC000000030

 --- Record Number ---  2   ---  Record Length ---- 80

.......F........F........F........@*......@*......@,......................datala
1...5....10...15...20...25...30...35...40...45...50...55...60...65...70...75...8
00000004000000004000000004000000004200000042000000420000000000000000000000667666
00900016000900016000900016000E00030A0000000A0000000C00000000420001000900094141C1

 --- Record Number ---  3   ---  Record Length ---- 80

bel................................names................NAME........SEX........A
1...5....10...15...20...25...30...35...40...45...50...55...60...65...70...75...8
66600010000000000000000000000000000666670001000000000000444400000000545000000004
25C00000001000900000042000100090005E1D530000000300090004E1D500090003358000900031

 --- Record Number ---  4   ---  Record Length ---- 80

GE................var.labels................................................clas
1...5....10...15...20...25...30...35...40...45...50...55...60...65...70...75...8
44000000000000000076726666670001000000000000000000000000000000000000000000006667
75004200010009000A612EC125C30000000300090000000900000009000000420001000900053C13

 --- Record Number ---  5   ---  Record Length ---- 80

s................data.frame................row.names................1........2..
1...5....10...15...20...25...30...35...40...45...50...55...60...65...70...75...8
70001000000000000667626766600000000000000007672666670001000000000000300000000300
3000000010009000A4141E621D500420001000900092F7EE1D530000000300090001100090001200

-----------------------------------------------------------------------------

/*--- GENERATED PROC R CODE TO CREATE OUTPUT SLC SAS DATSET ---*/

c:/temp/py_procr.sas
--------------------

options set=RHOME 'D:\r414';
proc r;
submit;
female<-readRDS('c:/temp/py_dataframe.rds')
head(female)
endsubmit;
import data=female r=female;
;quit;run;

/*
| | ___   __ _
| |/ _ \ / _` |
| | (_) | (_| |
|_|\___/ \__, |
         |___/
*/

1                                          Altair SLC       12:03 Monday, November 24, 2025

NOTE: Copyright 2002-2025 World Programming, an Altair Company
NOTE: Altair SLC 2026 (05.26.01.00.000758)
      Licensed to Roger DeAngelis
NOTE: This session is executing on the X64_WIN11PRO platform and is running in 64 bit mode

NOTE: AUTOEXEC processing beginning; file is C:\wpsoto\autoexec.sas
NOTE: AUTOEXEC source line
1       +  ï»¿;;;;
           ^
ERROR: Expected a statement keyword : found "?"
NOTE: Library workx assigned as follows:
      Engine:        SAS7BDAT
      Physical Name: d:\wpswrkx


NOTE: 1 record was written to file PRINT

NOTE: The data step took :
      real time : 0.011
      cpu time  : 0.000


NOTE: AUTOEXEC processing completed

1         proc datasets lib=sd1;
                               ^
ERROR: Library "sd1" cannot be found
2          delete have;
NOTE: Procedure DATASETS was not executed because of errors detected
3         run;quit;
NOTE: Procedure datasets step took :
      real time : 0.000
      cpu time  : 0.015


4
5         %macro utl_slc_pybeginx(
6               return=                         /*--- macro var  ---*/
7              ,resolve=Y                       /*--- resolve mac---*/
8              ,in=d:/sd1/have.sas7bdat         /*--- inp data   ---*/
9              ,out=tbl                         /*--- out data   ---*/
10             ,py2r=c:/temp/py_dataframe.rds   /* py 2 r data   ---*/
11             );
12
13
14         /*--- CLEAR FILES NEEDED FOR THE MACROS         ---*/
15         %utlfkil(c:/temp/py_pgm.py );        /*--- raw python ---*/
16         %utlfkil(c:/temp/py_pgm.pyx);        /*--- resolved   ---*/
17         %utlfkil(c:/temp/py_pgm.log);        /*--- pyhton log ---*/
18         %utlfkil(c:/temp/py_mac.sas);        /*--- mac vars   ---*/
19         %utlfkil(c:/temp/py_dataframe.rds ); /*--- r rds file ---*/
20         %utlfkil(c:/temp/py_procr.sas );     /*--- py to slc  ---*/
21
22         /*--- USE A FILE TO TRANSFER MACRO VARS TO BOTTOM SANDWICH ---*/
23         /*--- RATHER DO THIS THEN USE GLOBAL MACRO VARIABLES       ---*/
24         data _null_;
25          input;
26          file "c:/temp/py_pgm.py";
27          put _infile_;
28         if _n_=1 then do;
29            file "c:/temp/py_mac.sas"  dsd;
30            put "&return " ',' "&resolve " ',' "&in" ',' "&out" ',' "&py2r" ;
31         end;

2                                                                                                                         Altair SLC

32
33        %mend utl_slc_pybeginx;
34
35        %macro utl_slc_pyendx;
36
37        run;quit; /*--- EXECUTE DATASTEP CREATES C:/TEMP/PY_PGM.PY ---*/
38
39        /*-- JUST IN CASE A GLOBAL EXISTS ---*/
40        %symdel return / nowarn;
41
42        /*--- GET MACRO VARIABLE CREATED IN TOP SLICE ---*/
43        data _null_;
44          infile "c:/temp/py_mac.sas" delimiter = ',' dsd;
45          informat return resolve in out  py2r $255.;
46          input return resolve in out  py2r;
47          call symputx('return'  ,return  );
48          call symputx('resolve' ,resolve );
49          call symputx('in'      ,in      );
50          call symputx('out'     ,out     );
51          call symputx('py2r'    ,py2r    );
52        run;quit;
53
54        /*-- delete the only output slc sas dataset ---*/
55        proc datasets lib=work nolist nodetails;
56         delete &out;
57        run;quit;
58
59        /*--- RESOLVE MACRO TRIGGERS IN YOU PYTHON CODE ---*/
60        data _null_;
61          infile "c:/temp/py_pgm.py";
62          input;
63          file "c:/temp/py_pgm.pyx";
64          if _n_=1 then put "import pyperclip";
65          if "&resolve" ^= ""  then
66             _infile_=resolve(_infile_);
67          put _infile_;
68          putlog _infile_;
69        run;quit;
70
71        /*--- EXECUTE THE PYTHON PROGRAM                ---*/
72        options noxwait noxsync;
73        filename rut pipe  "d:\Python310\python.exe c:/temp/py_pgm.pyx 2> c:/temp/py_pgm.log";
74        run;quit;
75
76        /*--- PRINT THE LOG TO OUTPUT WINDOW            ---*/
77        data _null_;
78          file print;
79          infile rut;
80          input;
81          put _infile_;
82          putlog _infile_;
83        run;quit;
84
85        /*--- PRINT THE LOG TO LOG FILE                 ---*/
86        data _null_;
87          infile "c:/temp/py_pgm.log";
88          input;
89          putlog _infile_;
90        run;quit;
91
92
93        /*--- PYPERCLIP TEXT TO MACRO VARIABLE          ---*/
94        %if "&return" ne ""  %then %do;

3                                                                                                                         Altair SLC

95          filename clp clipbrd ;
96          data _null_;
97           infile clp;
98           input;
99           putlog "xxxxxx  " _infile_;
100          call symputx("&return.",_infile_,"G");
101         run;quit;
102       %end;
103
104
105       /*--- PANDA DATAFRAME TO SLC SAS DATASET        ---*/
106       data _null_;
107         file "c:/temp/py_procr.sas";
108         put "options set=RHOME 'D:\r414';         ";
109         put "proc r;                              ";
110         put "submit;                              ";
111         put "&out<-readRDS('&py2r')                ";
112         put "head(&out)                           ";
113         put "endsubmit;                           ";
114         put "import data=&out r=&out;             ";
115         put ";quit;run;                           ";
116       run;quit;
117
118       %include "c:/temp/py_procr.sas";
119       run;
120
121       %mend utl_slc_pyendx;
122
123       libname sd1 sas7bdat "d:/sd1";  /*--- need sas7bdat ---*/
NOTE: Library sd1 assigned as follows:
      Engine:        SAS7BDAT
      Physical Name: d:\sd1

124
125       options
126        validvarname=upcase ;
127       data sd1.have ;
128         input
129           name$
130           sex$ age;
131       cards4;

NOTE: Data set "SD1.have" has 6 observation(s) and 3 variable(s)
NOTE: The data step took :
      real time : 0.025
      cpu time  : 0.000


132       Alfred  M 14
133       Alice   F 13
134       Barbara F 13
135       Carol   F 14
136       Henry   M 14
137       James   M 12
138       ;;;;
139       run;quit;
140
141       %utl_slc_pybeginx(
142             return=date              /*--- macro var  ---*/
143            ,resolve=Y                /*--- resolve mac---*/
144            ,in=d:/sd1/have.sas7bdat  /*--- inp data   ---*/
145            ,out=female               /*---out work.tbl---*/
146            ,py2r=c:/temp/py_dataframe.rds);

4                                                                                                                         Altair SLC

147       cards4;

NOTE: The file 'c:\temp\py_pgm.py' is:
      Filename='c:\temp\py_pgm.py',
      Owner Name=T7610\Roger,
      File size (bytes)=0,
      Create Time=08:40:12 Nov 24 2025,
      Last Accessed=12:03:00 Nov 24 2025,
      Last Modified=12:03:00 Nov 24 2025,
      Lrecl=32767, Recfm=V

NOTE: The file 'c:\temp\py_mac.sas' is:
      Filename='c:\temp\py_mac.sas',
      Owner Name=T7610\Roger,
      File size (bytes)=0,
      Create Time=08:40:12 Nov 24 2025,
      Last Accessed=12:03:00 Nov 24 2025,
      Last Modified=12:03:00 Nov 24 2025,
      Lrecl=32767, Recfm=V

NOTE: 15 records were written to file 'c:\temp\py_pgm.py'
      The minimum record length was 80
      The maximum record length was 80
NOTE: 1 record was written to file 'c:\temp\py_mac.sas'
      The minimum record length was 61
      The maximum record length was 61
NOTE: The data step took :
      real time : 0.001
      cpu time  : 0.000


148
149       import pyreadstat as ps
150       import pandas as pd
151       import pyreadr as pr
152       from datetime import date
153
154       pyperclip.copy(date.today())
155
156       have,meta = ps.read_sas7bdat("&in")
157
158       &out=have.loc[have["SEX"] == "F"]
159
160       print(&out)
161
162       pr.write_rds("&py2r",&out)
163       ;;;;
164       %utl_slc_pyendx

NOTE: The infile 'c:\temp\py_mac.sas' is:
      Filename='c:\temp\py_mac.sas',
      Owner Name=T7610\Roger,
      File size (bytes)=63,
      Create Time=08:40:12 Nov 24 2025,
      Last Accessed=12:03:00 Nov 24 2025,
      Last Modified=12:03:00 Nov 24 2025,
      Lrecl=32767, Recfm=V

NOTE: 1 record was read from file 'c:\temp\py_mac.sas'
      The minimum record length was 61
      The maximum record length was 61
NOTE: The data step took :
      real time : 0.000

5                                                                                                                         Altair SLC

      cpu time  : 0.000


NOTE: WORK.FEMALE (memtype="DATA") was not found, and has not been deleted
NOTE: Procedure datasets step took :
      real time : 0.000
      cpu time  : 0.000



NOTE: The infile 'c:\temp\py_pgm.py' is:
      Filename='c:\temp\py_pgm.py',
      Owner Name=T7610\Roger,
      File size (bytes)=1230,
      Create Time=08:40:12 Nov 24 2025,
      Last Accessed=12:03:00 Nov 24 2025,
      Last Modified=12:03:00 Nov 24 2025,
      Lrecl=32767, Recfm=V

NOTE: The file 'c:\temp\py_pgm.pyx' is:
      Filename='c:\temp\py_pgm.pyx',
      Owner Name=T7610\Roger,
      File size (bytes)=0,
      Create Time=09:14:06 Nov 24 2025,
      Last Accessed=12:03:00 Nov 24 2025,
      Last Modified=12:03:00 Nov 24 2025,
      Lrecl=32767, Recfm=V


import pyreadstat as ps
import pandas as pd
import pyreadr as pr
from datetime import date

pyperclip.copy(date.today())

have,meta = ps.read_sas7bdat("d:/sd1/have.sas7bdat")

female=have.loc[have["SEX"] == "F"]

print(female)

pr.write_rds("c:/temp/py_dataframe.rds",female)
NOTE: 15 records were read from file 'c:\temp\py_pgm.py'
      The minimum record length was 80
      The maximum record length was 80
NOTE: 16 records were written to file 'c:\temp\py_pgm.pyx'
      The minimum record length was 16
      The maximum record length was 101
NOTE: The data step took :
      real time : 0.002
      cpu time  : 0.015



NOTE: The infile rut is:
      Unnamed Pipe Access Device,
      Process=d:\Python310\python.exe c:/temp/py_pgm.pyx 2> c:/temp/py_pgm.log,
      Lrecl=32767, Recfm=V

      NAME SEX   AGE
1    Alice   F  13.0
2  Barbara   F  13.0

6                                                                                                                         Altair SLC

3    Carol   F  14.0
NOTE: 4 records were written to file PRINT

NOTE: 4 records were read from file rut
      The minimum record length was 20
      The maximum record length was 20
NOTE: The data step took :
      real time : 1.264
      cpu time  : 0.031



NOTE: The infile 'c:\temp\py_pgm.log' is:
      Filename='c:\temp\py_pgm.log',
      Owner Name=T7610\Roger,
      File size (bytes)=0,
      Create Time=09:14:06 Nov 24 2025,
      Last Accessed=12:03:00 Nov 24 2025,
      Last Modified=12:03:00 Nov 24 2025,
      Lrecl=32767, Recfm=V

NOTE: No records were read from file 'c:\temp\py_pgm.log'
NOTE: The data step took :
      real time : 0.001
      cpu time  : 0.000



NOTE: The infile clp is:
      Clipboard

xxxxxx  2025-11-24
NOTE: 1 record was read from file clp
      The minimum record length was 10
      The maximum record length was 10
NOTE: The data step took :
      real time : 0.002
      cpu time  : 0.000



NOTE: The file 'c:\temp\py_procr.sas' is:
      Filename='c:\temp\py_procr.sas',
      Owner Name=T7610\Roger,
      File size (bytes)=0,
      Create Time=09:14:06 Nov 24 2025,
      Last Accessed=12:03:02 Nov 24 2025,
      Last Modified=12:03:02 Nov 24 2025,
      Lrecl=32767, Recfm=V

NOTE: 8 records were written to file 'c:\temp\py_procr.sas'
      The minimum record length was 37
      The maximum record length was 59
NOTE: The data step took :
      real time : 0.000
      cpu time  : 0.000


Start of %INCLUDE(level 1) c:/temp/py_procr.sas
165     +  options set=RHOME 'D:\r414';
166     +  proc r;
167     +  submit;
168     +  female<-readRDS('c:/temp/py_dataframe.rds')

7                                                                                                                         Altair SLC

169     +  head(female)
170     +  endsubmit;
NOTE: Using R version 4.5.1 (2025-06-13 ucrt) from d:\r451

NOTE: Submitting statements to R:

> female<-readRDS('c:/temp/py_dataframe.rds')
> head(female)

NOTE: Processing of R statements complete

171     +  import data=female r=female;
NOTE: Creating data set 'WORK.female' from R data frame 'female'
NOTE: Data set "WORK.female" has 3 observation(s) and 3 variable(s)

172     +  ;quit;run;
NOTE: Procedure r step took :
      real time : 0.385
      cpu time  : 0.015


End of %INCLUDE(level 1) c:/temp/py_procr.sas
173
174       %put &=date;
date=2025-11-24
175
176       proc print data=Female;
177       run;
NOTE: 3 observations were read from "WORK.Female"
NOTE: Procedure print step took :
      real time : 0.005
      cpu time  : 0.000


178
ERROR: Error printed on page 1

NOTE: Submitted statements took :
      real time : 1.824
      cpu time  : 0.187

/*                       _      _
 ___  __ _ _ ____      _(_) ___| |__    _ __ ___   __ _  ___ _ __ ___  ___
/ __|/ _` | `_ \ \ /\ / / |/ __| `_ \  | `_ ` _ \ / _` |/ __| `__/ _ \/ __|
\__ \ (_| | | | \ V  V /| | (__| | | | | | | | | | (_| | (__| | | (_) \__ \
|___/\__,_|_| |_|\_/\_/ |_|\___|_| |_| |_| |_| |_|\__,_|\___|_|  \___/|___/
 _
| |_ ___  _ __
| __/ _ \| `_ \
| || (_) | |_) |
 \__\___/| .__/
         |_|
*/

/*--- COPY MACROS TO AUTOCALL LIBRARY ---*/
data _null_;
 file "c:/wpsoto\utl_slc_pybeginx.sas";
 input;
 put _infile_;
cards4;
%macro utl_slc_pybeginx(
      return=                         /*--- macro var  ---*/
     ,resolve=Y                       /*--- resolve mac---*/
     ,in=d:/sd1/have.sas7bdat         /*--- inp data   ---*/
     ,out=tbl                         /*--- out data   ---*/
     ,py2r=c:/temp/py_dataframe.rds   /* py 2 r data   ---*/
     );


 /*--- CLEAR FILES NEEDED FOR THE MACROS         ---*/
 %utlfkil(c:/temp/py_pgm.py );        /*--- raw python ---*/
 %utlfkil(c:/temp/py_pgm.pyx);        /*--- resolved   ---*/
 %utlfkil(c:/temp/py_pgm.log);        /*--- pyhton log ---*/
 %utlfkil(c:/temp/py_mac.sas);        /*--- mac vars   ---*/
 %utlfkil(c:/temp/py_dataframe.rds ); /*--- r rds file ---*/
 %utlfkil(c:/temp/py_procr.sas );     /*--- py to slc  ---*/

 /*--- USE A FILE TO TRANSFER MACRO VARS TO BOTTOM SANDWICH ---*/
 /*--- RATHER DO THIS THEN USE GLOBAL MACRO VARIABLES       ---*/
 data _null_;
  input;
  file "c:/temp/py_pgm.py";
  put _infile_;
 if _n_=1 then do;
    file "c:/temp/py_mac.sas"  dsd;
    put "&return " ',' "&resolve " ',' "&in" ',' "&out" ',' "&py2r" ;
 end;

%mend utl_slc_pybeginx;
;;;;
run;quit;


/*           _   _
| |__   ___ | |_| |_ ___  _ __ ___
| `_ \ / _ \| __| __/ _ \| `_ ` _ \
| |_) | (_) | |_| || (_) | | | | | |
|_.__/ \___/ \__|\__\___/|_| |_| |_|

*/

data _null;
 file "c:/wpsoto\utl_slc_pyendx.sas";
 input;
 put _infile_;
cards4;
%macro utl_slc_pyendx;

run;quit; /*--- EXECUTE DATASTEP CREATES C:/TEMP/PY_PGM.PY ---*/

/*-- JUST IN CASE A GLOBAL EXISTS ---*/
%symdel return / nowarn;

/*--- GET MACRO VARIABLE CREATED IN TOP SLICE ---*/
data _null_;
  infile "c:/temp/py_mac.sas" delimiter = ',' dsd;
  informat return resolve in out  py2r $255.;
  input return resolve in out  py2r;
  call symputx('return'  ,return  );
  call symputx('resolve' ,resolve );
  call symputx('in'      ,in      );
  call symputx('out'     ,out     );
  call symputx('py2r'    ,py2r    );
run;quit;

/*-- delete the only output slc sas dataset ---*/
proc datasets lib=work nolist nodetails;
 delete &out;
run;quit;

/*--- RESOLVE MACRO TRIGGERS IN YOU PYTHON CODE ---*/
data _null_;
  infile "c:/temp/py_pgm.py";
  input;
  file "c:/temp/py_pgm.pyx";
  if _n_=1 then put "import pyperclip";
  if "&resolve" ^= ""  then
     _infile_=resolve(_infile_);
  put _infile_;
  putlog _infile_;
run;quit;

/*--- EXECUTE THE PYTHON PROGRAM                ---*/
options noxwait noxsync;
filename rut pipe  "d:\Python310\python.exe c:/temp/py_pgm.pyx 2> c:/temp/py_pgm.log";
run;quit;

/*--- PRINT THE LOG TO OUTPUT WINDOW            ---*/
data _null_;
  file print;
  infile rut;
  input;
  put _infile_;
  putlog _infile_;
run;quit;

/*--- PRINT THE LOG TO LOG FILE                 ---*/
data _null_;
  infile "c:/temp/py_pgm.log";
  input;
  putlog _infile_;
run;quit;


/*--- PYPERCLIP TEXT TO MACRO VARIABLE          ---*/
%if "&return" ne ""  %then %do;
  filename clp clipbrd ;
  data _null_;
   infile clp;
   input;
   putlog "xxxxxx  " _infile_;
   call symputx("&return.",_infile_,"G");
  run;quit;
%end;


/*--- PANDA DATAFRAME TO SLC SAS DATASET        ---*/
data _null_;
  file "c:/temp/py_procr.sas";
  put "options set=RHOME 'D:\r414';         ";
  put "proc r;                              ";
  put "submit;                              ";
  put "&out<-readRDS('&py2r')                ";
  put "head(&out)                           ";
  put "endsubmit;                           ";
  put "import data=&out r=&out;             ";
  put ";quit;run;                           ";
run;quit;

%include "c:/temp/py_procr.sas";
run;

%mend utl_slc_pyendx;
;;;;
run;quit;

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
