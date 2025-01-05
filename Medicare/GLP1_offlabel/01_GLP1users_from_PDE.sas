
/************************************************************************************
| Project name : identify GLP1 users with MA status indicators
| Task Purpose : 
|      1. GLP1 new users from 2018 - 2020 (n = 69,115)
| Final dataset : 
|	input.glp1users_pde_17to20
|	input.glp1users_beneid_17to20
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

%macro yearly(data=, refer=);

data &data;
  set &refer;
  if BN in ('OZEMPIC', 'RYBELSUS', 'MOUNJARO');
run;

%mend yearly;
%yearly(data=glp1users_v00, refer=pde20.pde_file_2020);
%yearly(data=glp1users_v01, refer=pde19.pde_file_2019);
%yearly(data=glp1users_v02, refer=pde18.pde_file_2018);
%yearly(data=glp1users_v03, refer=pde17.pde_file_2017);


/* 2017 -> 0 */
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
	2.    Key ID summary for glp1 users (n = 69,115)
************************************************************************************/

/**************************************************
* new table: input.glp1users_beneid_17to20
* original table: input.glp1users_pde_17to20
* description: BENE_ID for 69,115
**************************************************/

proc sql;
	create table input.glp1users_beneid_17to20 as
 	select distinct a.BENE_ID
  	from input.glp1users_pde_17to20 as a;
quit;   /* 69115 obs */




