
/************************************************************************************
| Project name : identify GLP1 users
| Task Purpose : 
|      1. GLP1 new users from 2018 - 2020 (n = 69,115)
|      2. Identify MA subsidiaries (n = 45,939)
|      3. Add MA subsidiaries variable to PDE files for glp1 users
| Final dataset : 
|	input.glp1users_pde_17to20  (with MA status indicators)
|	input.glp1users_beneid_17to20
|	input.glp1users_beneid_17to20_ma
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


/************************************************************************************
	2.    Identify MA subsidiaries (n = 45,939)
************************************************************************************/

* 0. read the mbsf file;
proc print data=mbsf20.mbsf_abcd_summary_2020 (obs=20);
	var BENE_ID PTC_CNTRCT_ID_01--PTC_CNTRCT_ID_12; 
    title "mbsf_abcd_summary_2020";      
run;                      
proc contents data=mbsf20.mbsf_abcd_summary_2020;
    title "mbsf_abcd_summary_2020";    
run; 

* 1. stack MA status from 01 to 12 for each year;

%macro yearly(data=, data_v01=, refer=, var=);

   proc sql;
      create table &data as
      select distinct 
         a.*, 
         b.PTC_CNTRCT_ID_01, b.PTC_CNTRCT_ID_02, b.PTC_CNTRCT_ID_03, 
         b.PTC_CNTRCT_ID_04, b.PTC_CNTRCT_ID_05, b.PTC_CNTRCT_ID_06, 
         b.PTC_CNTRCT_ID_07, b.PTC_CNTRCT_ID_08, b.PTC_CNTRCT_ID_09, 
         b.PTC_CNTRCT_ID_10, b.PTC_CNTRCT_ID_11, b.PTC_CNTRCT_ID_12
      from input.glp1users_beneid_17to20 as a
      left join &refer as b
      on a.BENE_ID = b.BENE_ID;
   quit;  /* 69115 obs */

   data &data_v01;
      set &data;
      if (PTC_CNTRCT_ID_01 in ('0', 'N')) and 
         (PTC_CNTRCT_ID_02 in ('0', 'N')) and 
         (PTC_CNTRCT_ID_03 in ('0', 'N')) and
         (PTC_CNTRCT_ID_04 in ('0', 'N')) and
         (PTC_CNTRCT_ID_05 in ('0', 'N')) and
         (PTC_CNTRCT_ID_06 in ('0', 'N')) and
         (PTC_CNTRCT_ID_07 in ('0', 'N')) and
         (PTC_CNTRCT_ID_08 in ('0', 'N')) and
         (PTC_CNTRCT_ID_09 in ('0', 'N')) and
         (PTC_CNTRCT_ID_10 in ('0', 'N')) and
         (PTC_CNTRCT_ID_11 in ('0', 'N')) and
         (PTC_CNTRCT_ID_12 in ('0', 'N')) then 
            &var = 0;
      else 
         &var = 1;
   run;  /* 69115 obs */

%mend yearly;
%yearly(data=glp1users_ma_2020, data_v01=glp1users_ma_2020_v01, refer=mbsf20.mbsf_abcd_summary_2020, var=ma_status_2020);
%yearly(data=glp1users_ma_2019, data_v01=glp1users_ma_2019_v01, refer=mbsf19.mbsf_abcd_summary_2019, var=ma_status_2019);
%yearly(data=glp1users_ma_2018, data_v01=glp1users_ma_2018_v01, refer=mbsf18.mbsf_abcd_summary_2018, var=ma_status_2018);
%yearly(data=glp1users_ma_2017, data_v01=glp1users_ma_2017_v01, refer=mbsf17.mbsf_abcd_summary_2017, var=ma_status_2017);

* 2. stack MA status from 2017 to 2020;
/**************************************************
* new table: input.glp1users_beneid_17to20_ma
* original table: input.glp1users_beneid_17to20
* description: 
**************************************************/

proc sql;
	create table input.glp1users_beneid_17to20_ma as
 	select distinct a.*, 

  		(b1.ma_status_2020) as ma_status_2020,
   		(b2.ma_status_2019) as ma_status_2019,
   		(b3.ma_status_2018) as ma_status_2018,
   		(b4.ma_status_2017) as ma_status_2017

	from input.glp1users_beneid_17to20 as a

 	left join glp1users_ma_2020_v01 b1 on a.BENE_ID = b1.BENE_ID
 	left join glp1users_ma_2019_v01 b2 on a.BENE_ID = b2.BENE_ID
  	left join glp1users_ma_2018_v01 b3 on a.BENE_ID = b3.BENE_ID
  	left join glp1users_ma_2017_v01 b4 on a.BENE_ID = b4.BENE_ID ;
   
quit;

data input.glp1users_beneid_17to20_ma;
	set input.glp1users_beneid_17to20_ma;
 	if (ma_status_2020 = 0) and 
  	   (ma_status_2019 = 0) and 
  	   (ma_status_2018 = 0) and 
           (ma_status_2017 = 0) then
    	   ma_status_17to20 = 0;
     	else ma_status_17to20 = 1;
run;        /* 69115 obs */

proc print data= input.glp1users_beneid_17to20_ma (obs =20);
	title "glp1users_beneid_17to20_ma";
run;

* 3. MA subsidiaries;
proc freq data = input.glp1users_beneid_17to20_ma;
	table ma_status_17to20;
 	title "ma_status_17to20";
run;

/************************************************************************************
	3.    Add MA subsidiaries variable to PDE files for glp1 users
************************************************************************************/

/**************************************************
* new table: input.glp1users_pde_17to20
* original table: input.glp1users_pde_17to20 + input.glp1users_beneid_17to20_ma
* description: 
*       glp1 = Ozempic(semaglutide), Rybelsus(semaglutide), Mounjaro(tirzepatide)
*       no glp1 users in pde_file_2017 -> all of the users in "input.glp1users_pde_17to20" are new users
*       the first prescription date = index date
**************************************************/

proc sql;
	create table input.glp1users_pde_17to20 as
 	select distinct a.*, b.ma_status_17to20
  	from input.glp1users_pde_17to20 as a left join input.glp1users_beneid_17to20_ma as b
   	on a.BENE_ID = b.BENE_ID;
quit;    /* 380305 obs */





