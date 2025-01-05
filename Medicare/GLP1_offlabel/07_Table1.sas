
/************************************************************************************
| Project name : Identify off label use of GLP1 following several definitions
| Task Purpose : 
|      1. 
| Final dataset : 
|       00
************************************************************************************/

/************************************************************************************
	0.    Among GLP1 new users from 2018 - 2020 (n = 69,115)
************************************************************************************/

* input.glp1users_pde_17to20_v04;

proc sort data=input.glp1users_pde_17to20_v04;
  by BENE_ID SRVC_DT;
run;

data input.studypop;
  set input.glp1users_pde_17to20_v04;
  by BENE_ID;
  if first.BENE_ID;
run;       

/************************************************************************************
	1.    GLP-1 Brand 
************************************************************************************/

proc freq data=input.studypop;
  table BN*offlabel_df4 / norow nopercent nocum chisq;
  title "GLP-1 Brand";
run;

/************************************************************************************
	2.    Ozempic Strength 
************************************************************************************/

data studypop_ozempic;
  set input.studypop;
  if BN in ('OZEMPIC');
run;  /* 63734 obs */

proc freq data=studypop_ozempic;
  table STR*offlabel_df4 / norow nopercent nocum chisq;
  title "Ozempic Strength";
run;

/************************************************************************************
	3.    Days Supply 
************************************************************************************/

proc means data=input.studypop n nmiss mean std;
  class offlabel_df4;
  var DAYS_SUPLY_NUM;
  title "Days Supply";
run;

/* p-value */
proc ttest data=input.studypop;
   class offlabel_df4;
   var DAYS_SUPLY_NUM;
run;

/************************************************************************************
	4.    OOP Costs 
************************************************************************************/

data input.studypop;
  set input.studypop;
  oop = PTNT_PAY_AMT + LICS_AMT + OTHR_TROOP_AMT + PLRO_AMT;
run;

/* p-value */
proc ttest data=input.studypop;
   class offlabel_df4;
   var PTNT_PAY_AMT;
   title "OOP Costs";
run;

/************************************************************************************
	5.    Gross Rx Cost 
************************************************************************************/

data input.studypop;
  set input.studypop;
  gross_cost = CVRD_D_PLAN_PD_AMT + GDC_ABV_OOPT_AMT + GDC_BLW_OOPT_AMT + LICS_AMT + NCVRD_PLAN_PD_AMT;
run;

proc ttest data=input.studypop;
   class offlabel_df4;
   var gross_cost;
   title "Gross Rx Cost";
run;

/************************************************************************************
	6.    Age
************************************************************************************/

proc ttest data=input.studypop;
   class offlabel_df4;
   var age;
   title "Age";
run;

/************************************************************************************
	7.    Female
************************************************************************************/

proc freq data=input.studypop;
  table GNDR_CD*offlabel_df4 / norow nopercent nocum chisq;
  title "Female";
run;

/************************************************************************************
	8.    Race
************************************************************************************/

proc freq data=input.studypop;
  table BENE_RACE_CD*offlabel_df4 / norow nopercent nocum chisq;
  title "Race";
run;

/************************************************************************************
	9.    Part D Plan GLP-1 
************************************************************************************/

/* coverage */
proc freq data=input.studypop;
  table DRUG_CVRG_STUS_CD*offlabel_df4 / norow nopercent nocum chisq;
  title "coverage";
run;

/* Prior Authorization */
proc freq data=input.studypop;
  table PRIOR_AUTHORIZATION_num*offlabel_df4 / norow nopercent nocum chisq;
  title "Prior Authorization";
run;

/* STEP */
proc freq data=input.studypop;
  table STEP_num *offlabel_df4 / norow nopercent nocum chisq;
  title "STEP";
run;

/************************************************************************************
	10.    Comorbidity
************************************************************************************/

/* Acute myocardial infarction */
proc freq data=input.studypop;
  table cc_acute_mi*offlabel_df4 / norow nopercent nocum chisq;
  title "Acute myocardial infarction";
run;

/* Heart failure */
proc freq data=input.studypop;
  table cc_hf*offlabel_df4 / norow nopercent nocum chisq;
  title "Heart failure";
run;

/* Stroke */
proc freq data=input.studypop;
  table cc_stroke*offlabel_df4 / norow nopercent nocum chisq;
  title "Stroke";
run;

/* Alzheimer’s */
proc freq data=input.studypop;
  table cc_alzh*offlabel_df4 / norow nopercent nocum chisq;
  title "alzh";
run;











