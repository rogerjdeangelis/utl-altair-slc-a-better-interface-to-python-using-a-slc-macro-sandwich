/* Derived from the repo's usage example (README section "1 usage" / main
   .sas file): the sd1.have input dataset and the sex=F filter/listing that
   utl_slc_pybeginx's python sandwich exists to reproduce ("create a slc sas
   dataset as select name, sex from [panda dataframe] where sex=F" -- the
   PROBLEM statement in the README). This bundle runs the SAS-native
   equivalent of that filter directly, without the Python round-trip:
   same input rows, same WHERE condition, same output shape. */

options validvarname=upcase;

data have;
  input
    name $
    sex $ age;
cards4;
Alfred  M 14
Alice   F 13
Barbara F 13
Carol   F 14
Henry   M 14
James   M 12
;;;;
run;

proc sql;
  create table female as
  select name, sex, age
  from have
  where sex = "F";
quit;

proc print data=female;
run;
