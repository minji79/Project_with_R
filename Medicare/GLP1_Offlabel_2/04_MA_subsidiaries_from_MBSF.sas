/************************************************************************************
| Project name : Identify MA subsidiaries (n = 45,939)
| Task Purpose : 
|      1. Identify MA subsidiaries (n = 45,939)
|      2. Add MA subsidiaries variable to PDE files for glp1 users
| Final dataset : 
|	input.glp1users_pde_17to20  (with MA status indicators)
|	input.glp1users_beneid_17to20
|	input.glp1users_beneid_17to20_ma
************************************************************************************/

proc print data=mbsf20.mbsf_abcd_summary_2020 (obs=20);
	var BENE_ID ptc_plan_type_cd_01--ptc_plan_type_cd_12; 
    title "mbsf_abcd_summary_2020";      
run; 

/************************************************************************************
	1.    Identify MA subsidiaries (n = 45,939)
************************************************************************************/

%macro yearly(year=, data=, refer=);

proc sql;
	create table &data as
 	select distinct a.*, b.ptc_plan_type_cd_01, &year as dig_year  /* diabetes_tm_yr */
	from input.glp1users_beneid_17to20 as a
 	left join &refer as b
  	on a.BENE_ID = b.BENE_ID;
quit;

%mend yearly;

%yearly(data=ma20, year=2020, refer=mbsf20.mbsf_abcd_summary_2020);
