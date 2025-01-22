/************************************************************************************
| Project name : Identify off label use of GLP1 following several definitions
| Task Purpose : 
|      1. add age
| Final dataset : 
|       input.glp1users_pde_17to20_demo
************************************************************************************/


/************************************************************************************
	1.    Age
************************************************************************************/

proc sql;
  create table demo_age as
  select distinct a.*, b.BENE_BIRTH_DT
  from input.glp1users_pde_17to20 as a left join mbsf20.mbsf_abcd_summary_2020 as b
  on a.BENE_ID = b.BENE_ID;
quit;

data input.glp1users_pde_17to20_demo;
  set demo_age;
  year_birth = year(BENE_BIRTH_DT);
  age_at_index = year(SRVC_DT) - year_birth;
run;

proc means data=input.glp1users_pde_17to20_demo n nmiss mean std;
  var age_at_index;
  title "age";
run;


/************************************************************************************
	2.   Race
************************************************************************************/

proc sql;
  create table input.glp1users_pde_17to20_demo as
  select distinct a.*, b.BENE_RACE_CD 
  from input.glp1users_pde_17to20_demo as a left join mbsf20.mbsf_abcd_summary_2020 as b
  on a.BENE_ID = b.BENE_ID;
quit;


/************************************************************************************
	3.   State
************************************************************************************/

proc sql;
  create table demo_state as
  select distinct a.*, b.STATE_CODE   
  from input.glp1users_pde_17to20_demo as a left join mbsf20.mbsf_abcd_summary_2020 as b
  on a.BENE_ID = b.BENE_ID;
quit;

/* check */
proc print data=demo_state (obs=20); 
  var BENE_ID STATE_CODE;
run;
proc freq data=demo_state; table STATE_CODE; run;


proc contents data=mbsf20.mbsf_abcd_summary_2020; run;








