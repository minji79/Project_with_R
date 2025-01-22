/************************************************************************************
| Project name : identify UM status, coverage for each prescriptions of glp1 users
| Task Purpose : 
|      1. Identify UM status for each prescriptions of glp1 user
|      2. Identify Part D coverage for each prescriptions of glp1 user (n=6330, 9.16% uncovered)
| Final dataset : 
|	      input.glp1users_beneid_17to20_um
|	      input.glp1users_pde_17to20_coverage 
************************************************************************************/

/************************************************************************************
	1.    Identify UM status for each prescriptions of glp1 user
************************************************************************************/

%macro yearly(year=, refer=);

proc sql;
	create table um_&year as
 	select distinct a.*, b.TIER_ID, b.PRIOR_AUTHORIZATION_YN, b.STEP, b.QUANTITY_LIMIT_YN
	from input.glp1users_pde_17to20 as a
 	left join &refer as b
  	on a.FORMULARY_ID=b.FORMULARY_ID and a.FRMLRY_RX_ID = b.FRMLRY_RX_ID
   where year(SRVC_DT) = &year;
quit;

%mend yearly;
%yearly(year=2020, refer=form20.formulary_2020);
%yearly(year=2019, refer=form19.formulary_2019);
%yearly(year=2018, refer=form18.formulary_2018);
%yearly(year=2017, refer=form17.formulary_2017);
%yearly(year=2016, refer=form16.formulary_2016);

data input.glp1users_beneid_17to20_um; 
  set um_2020 um_2019 um_2018 um_2017 um_2016; 
  keep BENE_ID FORMULARY_ID FRMLRY_RX_ID SRVC_DT TIER_ID PRIOR_AUTHORIZATION_YN STEP QUANTITY_LIMIT_YN;
run;

/* NA fill */
data input.glp1users_beneid_17to20_um; set input.glp1users_beneid_17to20_um; if missing(STEP) then STEP = 0; run;

/* Any restriction */
data input.glp1users_beneid_17to20_um; 
  set input.glp1users_beneid_17to20_um; 
  if not missing(PRIOR_AUTHORIZATION_YN) | not missing(STEP) then any_restict = 1;
  else any_restict = 0;
run;

/************************************************************************************
	2.    Identify Part D coverage for each prescriptions of glp1 user (n=6330, 9.16% uncovered)
************************************************************************************/

%macro yearly(year=, refer=);

data pde_&year; set input.glp1users_pde_17to20; where year(SRVC_DT) = &year; run;

proc sql;
	 create table covered_&year as
   select distinct 
       a.*, 
       b.*, 
       case 
            when b.FORMULARY_ID is null then 1  /* Row not found in Table B */
            else 0                             /* Row matched in Table B */
        end as not_found_flag
    from pde_&year as a
    left join &refer as b 
    on a.FORMULARY_ID = b.FORMULARY_ID and a.FRMLRY_RX_ID = b.FRMLRY_RX_ID;
quit;

%mend yearly;
%yearly(year=2020, refer=form20.formulary_2020);
%yearly(year=2019, refer=form19.formulary_2019);
%yearly(year=2018, refer=form18.formulary_2018);
%yearly(year=2017, refer=form17.formulary_2017);
%yearly(year=2016, refer=form16.formulary_2016);


data input.glp1users_pde_17to20_coverage; 
  set covered_2020 covered_2019 covered_2018 covered_2017 covered_2016;
  keep BENE_ID FORMULARY_ID FRMLRY_RX_ID SRVC_DT not_found_flag;
  where not_found_flag =1;
run;

proc freq data=input.glp1users_pde_17to20_coverage; table not_found_flag; run; /* 6330, 9.16% uncovered */
  



 


