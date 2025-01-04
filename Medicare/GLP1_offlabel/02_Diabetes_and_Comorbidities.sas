
/************************************************************************************
| Project name : identify diabetes patient among GLP1 users
| Task Purpose : 
|      1. identify diabetes patient among GLP1 users (n = 44,239)
|      2. Identify cormorbidity (acute myocardial infarction, heart failure, hypertension, stroke, Alzheimer’s) among GLP1 users
|      3. Add diabetes & cormorbidity variable to PDE files for glp1 users
| Final dataset : 
|	  input.glp1users_pde_17to20_v01 (with diabetes & cormorbidity indicators)
|         input.glp1users_beneid_17to20_cc
************************************************************************************/

/************************************************************************************
	1.    identify diabetes patient among GLP1 users (n = 44,239)
 	2.    identify cormorbidity (acute myocardial infarction, heart failure, hypertension, stroke, Alzheimer’s) among GLP1 users
************************************************************************************/

* 0. read the mbsf file;                   
proc contents data=mbsf20.mbsf_chronic_summary_2020;
    title "mbsf_chronic_summary_2020";    
run; 
proc print data=mbsf20.mbsf_chronic_summary_2020 (obs=20);
	var BENE_ID DIABETES DIABETES_EVER; 
    title "mbsf_chronic_summary_2020";    
run;   

* 1. use the recent DIABETES_EVER as the indicator for diabetes status ;
/**************************************************
* new table: input.glp1users_beneid_17to20_cc
* original table: input.glp1users_beneid_17to20
* description:
  diabetes | DIABETES_EVER
  acute myocardial infarction | AMI_EVER
  heart failure | HF_EVER 
  stroke | STROKE_TIA_EVER 
  Alzheimer’s | ALZH_EVER
**************************************************/

proc sql;
	create table input.glp1users_beneid_17to20_cc as
 	select distinct a.*, b.DIABETES_EVER, b.AMI_EVER, b.HF_EVER, b.STROKE_TIA_EVER, b.ALZH_EVER

	from input.glp1users_beneid_17to20 as a
  left join mbsf20.mbsf_chronic_summary_2020 as b 
  on a.BENE_ID = b.BENE_ID;
   
quit; /* 69115 obs */

* 2. label variables;

data input.glp1users_beneid_17to20_cc;
  set input.glp1users_beneid_17to20_cc;

  diabetes = ifn(missing(DIABETES_EVER), 0, 1);
  cc_acute_mi = ifn(missing(AMI_EVER), 0, 1);
  cc_hf = ifn(missing(HF_EVER), 0, 1);
  cc_stroke = ifn(missing(STROKE_TIA_EVER), 0, 1);
  cc_alzh = ifn(missing(ALZH_EVER), 0, 1);
run;  /* 69115 obs */

/* check */
proc print data=input.glp1users_beneid_17to20_cc(obs=20);
	var BENE_ID DIABETES_EVER diabetes AMI_EVER cc_acute_mi; 
    title "glp1users_beneid_17to20_cc";    
run;  
proc contents data=input.glp1users_beneid_17to20_cc;
  title "glp1users_beneid_17to20_cc";    
run;  


* 2. diabetes status;
proc freq data = input.glp1users_beneid_17to20_cc;
	table diabetes;
 	title "diabetes status";
run;

/*
diabetes = 1 | n = 44239
diabetes = 0 | n = 24876
*/

* 3. comorbidities status;
proc freq data = input.glp1users_beneid_17to20_cc;
	table diabetes * cc_acute_mi;
 	title "cc_acute_mi status by diabetes";
run;

proc freq data = input.glp1users_beneid_17to20_cc;
	table diabetes * cc_hf;
 	title "cc_hf status by diabetes";
run;

proc freq data = input.glp1users_beneid_17to20_cc;
	table diabetes * cc_stroke;
 	title "cc_stroke status by diabetes";
run;

proc freq data = input.glp1users_beneid_17to20_cc;
	table diabetes * cc_alzh;
 	title "cc_alzh status by diabetes";
run;

/************************************************************************************
	3.    Add diabetes & cormorbidity variable to PDE files for glp1 users
************************************************************************************/

/**************************************************
* new table: input.glp1users_pde_17to20_v01 
* original table: input.glp1users_pde_17to20
* description: add indicators for comorbidities
**************************************************/

proc sql;
  create table input.glp1users_pde_17to20_v01 as
  select distinct a.*, b.diabetes, b.cc_acute_mi, b.cc_hf, b.cc_stroke, b.cc_alzh 
  from input.glp1users_pde_17to20 as a
  left join input.glp1users_beneid_17to20_cc as b
  on a.BENE_ID = b.BENE_ID;
quit;            /* 380305 obs */



















