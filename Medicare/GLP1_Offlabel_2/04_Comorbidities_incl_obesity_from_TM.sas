/************************************************************************************
| Project name : identify diabetes patient among GLP1 users
| Task Purpose : 
|      1. identify diabetes patient among GLP1 users (n = 6543, 9.47%)
|      2. 
|      3. 
| Final dataset : 
|         input.glp1users_beneid_17to20_cc
************************************************************************************/

* base data = input.glp1users_beneid_17to20_diag_TM;

/************************************************************************************
	1.    identify obesity patient among GLP1 users (n = 6543, 9.47%)
************************************************************************************/

data obesity_id_obs;
	set input.glp1users_beneid_17to20_diag_TM;
	if ICD_DGNS_CD1 in ('E660', 'E6601', 'E661', 'E662', 'E663', 'E668', 'E66811', 'E66812', 'E66813', 'E669', '278.0', '278.01', '278.02'); 
run;
data obesity_id_obs; set obesity_id_obs; obesity = 1; run;

/* merge with study population */

proc sql;
	create table input.glp1users_beneid_17to20_cc as
 	select distinct a.*, b.obesity
  	from input.glp1users_beneid_17to20 as a
   	left join obesity_id_obs as b
    on a.BENE_ID=b.BENE_ID;
quit;

data input.glp1users_beneid_17to20_cc; set input.glp1users_beneid_17to20_cc; if missing(obesity) then obesity =0; run;
