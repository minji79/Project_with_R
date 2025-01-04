
/************************************************************************************
| Project name : identify GLP1 users
| Task Purpose : 
|      1. GLP1 new users from 2018 - 2020 (n = 69,115)
|      2. 00
| Final dataset : input.glp1users_pde_17to20
************************************************************************************/


/************************************************************************************
	1.    GLP1 new users from 2018 - 2020 (n = 69,115)
************************************************************************************/

/**************************************************
* new table: input.glp1users_pde_17to20
* original table: pde_file_2017 - pde_file_2020
* description: 
*       glp1 = Ozempic(semaglutide), Rybelsus(semaglutide), Mounjaro(tirzepatide)
*       no glp1 users in pde_file_2017 -> all of the users in "input.glp1users_pde_17to20" are new users
*       the first prescription date = index date
**************************************************/

* read the pde file;
proc print data=pde20.pde_file_2020 (obs=30);
    title "pde_file_2020";       /* 304859025 obs */
run;                      
proc contents data=pde20.pde_file_2020;
    title "pde_file_2020";
run; 

* 1. Select Ozempic(semaglutide), Rybelsus(semaglutide), Mounjaro(tirzepatide) by year;
/* 2020 */
data work.glp1users_v00;
  set pde20.pde_file_2020;
  if BN in ('OZEMPIC', 'RYBELSUS', 'MOUNJARO');
run; /* 260232 obs */

/* 2019 */
data work.glp1users_v01;
  set pde19.pde_file_2019;
  if BN in ('OZEMPIC', 'RYBELSUS', 'MOUNJARO');
run;  /* 107597 obs */

/* 2018 */
data work.glp1users_v02;
  set pde18.pde_file_2018;
  if BN in ('OZEMPIC', 'RYBELSUS', 'MOUNJARO');
run; /* 12476 obs */

/* 2017 */
data work.glp1users_v03;
  set pde17.pde_file_2017;
  if BN in ('OZEMPIC', 'RYBELSUS', 'MOUNJARO');
run;
proc print data = work.glp1users_v03 (obs = 20);
  title "glp1users_v03";
run;  /* 0 obs */

* 2. stack all files;
data input.glp1users_pde_17to20;
 set work.glp1users_v00 work.glp1users_v01 work.glp1users_v02 work.glp1users_v03;
run;  /* 380305 */

proc sort data=input.glp1users_pde_17to20;
  by BENE_ID SRVC_DT;
run;

* 3. count distinct beneficiaries;
proc sql;
	select count(distinct BENE_ID) as distinct_patient_count
 	from input.glp1users_pde_17to20;
quit;      /* 69115 obs */

/************************************************************************************
	2.    Exclude MA subsidiaries (n = 69,115)
************************************************************************************/

/**************************************************
* new table: input.glp1users_pde_17to20_v01
* original table: input.glp1users_pde_17to20
* description: exclude MA subsidiaries
*       DRUG_CVRG_STUS_CD = "C"
**************************************************/




* var BENE_ID FORMULARY_ID FRMLRY_RX_ID SRVC_DT BN GNN STR BRND_GNRC_CD ; 








