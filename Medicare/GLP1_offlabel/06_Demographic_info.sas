
/************************************************************************************
| Project name : Identify off label use of GLP1 following several definitions
| Task Purpose : 
|      1. add age
| Final dataset : 
|       input.glp1users_pde_17to20_v04
************************************************************************************/


/************************************************************************************
	1.    Age
************************************************************************************/

proc sql;
  create table input.glp1users_pde_17to20_v04 as
  select distinct a.*, b.BENE_BIRTH_DT
  from input.glp1users_pde_17to20_v03 as a left join mbsf20.mbsf_abcd_summary_2020 as b
  on a.BENE_ID = b.BENE_ID;
quit;

data input.glp1users_pde_17to20_v04;
  set input.glp1users_pde_17to20_v04;
  year_birth = year(BENE_BIRTH_DT);
  year_fill = year(SRVC_DT);
  age = year_fill - year_birth;
run;

proc means data=input.glp1users_pde_17to20_v04 n nmiss mean std;
  var age;
  title "age";
run;


/************************************************************************************
	2.   Race
************************************************************************************/

proc sql;
  create table input.glp1users_pde_17to20_v04 as
  select distinct a.*, b.BENE_RACE_CD 
  from input.glp1users_pde_17to20_v04 as a left join mbsf20.mbsf_abcd_summary_2020 as b
  on a.BENE_ID = b.BENE_ID;
quit;
