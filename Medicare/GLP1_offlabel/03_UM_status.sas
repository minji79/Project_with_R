
/************************************************************************************
| Project name : identify UM status for each prescriptions of glp1 users
| Task Purpose : 
|      1. Identify UM status for each prescriptions of glp1 user
| Final dataset : 
|	      input.glp1users_pde_17to20_v02 
************************************************************************************/

/************************************************************************************
	1.    Identify UM status for each prescriptions of glp1 user
************************************************************************************/

/**************************************************
* new table: input.glp1users_pde_17to20_v02 
* original table: input.glp1users_pde_17to20_v01
* description: add UM status for each row
**************************************************/

* 0. read the formularity file;                   
proc contents data=form20.formulary_2020;
    title "formulary_2020";    
run; 

* 1. SRVC_DT_year;                 
data input.glp1users_pde_17to20_v01;
	set input.glp1users_pde_17to20_v01;
	SRVC_DT_year = year(SRVC_DT);
run;

* 2. select UM indicators from formularity file for each year;
/* 2020 */
proc sql;
	create table glp1users_pde_17to20_2020 as
 	select distinct a.*, b.TIER_ID, b.PRIOR_AUTHORIZATION_YN, b.STEP, b.QUANTITY_LIMIT_YN
  
	from input.glp1users_pde_17to20_v01 as a
  left join form20.formulary_2020 as b 
  on a.FORMULARY_ID=b.FORMULARY_ID and a.FRMLRY_RX_ID = b.FRMLRY_RX_ID
  where a.SRVC_DT_year = 2020;
   
quit; /* 260232 obs */

/* 2019 */
proc sql;
	create table glp1users_pde_17to20_2019 as
 	select distinct a.*, b.TIER_ID, b.PRIOR_AUTHORIZATION_YN, b.STEP, b.QUANTITY_LIMIT_YN
  
	from input.glp1users_pde_17to20_v01 as a
  left join form19.formulary_2019 as b 
  on a.FORMULARY_ID=b.FORMULARY_ID and a.FRMLRY_RX_ID = b.FRMLRY_RX_ID
  where a.SRVC_DT_year = 2019;
   
quit; /* 107597 obs */

/* 2018 */
proc sql;
	create table glp1users_pde_17to20_2018 as
 	select distinct a.*, b.TIER_ID, b.PRIOR_AUTHORIZATION_YN, b.STEP, b.QUANTITY_LIMIT_YN
  
	from input.glp1users_pde_17to20_v01 as a
  left join form18.formulary_2018 as b 
  on a.FORMULARY_ID=b.FORMULARY_ID and a.FRMLRY_RX_ID = b.FRMLRY_RX_ID
  where a.SRVC_DT_year = 2018;
   
quit;     /* 12476 obs */

/* 2017 */
proc sql;
	create table glp1users_pde_17to20_2017 as
 	select distinct a.*, b.TIER_ID, b.PRIOR_AUTHORIZATION_YN, b.STEP, b.QUANTITY_LIMIT_YN
  
	from input.glp1users_pde_17to20_v01 as a
  left join form17.formulary_2017 as b 
  on a.FORMULARY_ID=b.FORMULARY_ID and a.FRMLRY_RX_ID = b.FRMLRY_RX_ID
  where a.SRVC_DT_year = 2017;
   
quit;  /* 0 obs */

* 3. stack UM indicators;
data input.glp1users_pde_17to20_v02;
  set glp1users_pde_17to20_2020 glp1users_pde_17to20_2019 glp1users_pde_17to20_2018;
run; /* 380305 pbs*/

proc print data=input.glp1users_pde_17to20_v02(obs=20);
	var BENE_ID SRVC_DT BN TIER_ID PRIOR_AUTHORIZATION_YN STEP QUANTITY_LIMIT_YN;
    title "glp1users_pde_17to20_v02";    
run;  

* 4. add numeric UM indicators;
data input.glp1users_pde_17to20_v02;
  set input.glp1users_pde_17to20_v02;
  if PRIOR_AUTHORIZATION_YN = '1' then PRIOR_AUTHORIZATION_num = 1;
  else PRIOR_AUTHORIZATION_num =0;
  
  if missing(STEP) then STEP_num = 0;
  else STEP_num =1;

  if QUANTITY_LIMIT_YN = '1' then QUANTITY_LIMIT_YN_num = 1;
  else QUANTITY_LIMIT_YN_num =0;
  
run;

proc freq data = input.glp1users_pde_17to20_v02;
  table QUANTITY_LIMIT_YN_num;
run;



