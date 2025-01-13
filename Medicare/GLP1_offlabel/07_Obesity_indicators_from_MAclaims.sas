
* MA claim ;

/************************************************************************************
	1.    identify obesity patient among GLP1 users (n = 44,239)
************************************************************************************/

* 1. merge patients' diagnosis ICD10 code;
/* for non-institutional claims */
proc sql;
	create table obesity as
 	select distinct a.*, b.ICD_DGNS_CD1
	from input.glp1users_beneid_17to20 as a
 	left join ma_ca19.carrier_base_enc_2019 as b
  	on a.BENE_ID = b.BENE_ID;
quit;

/* inpatients claim */
proc sql;
	create table obesity1 as
 	select distinct a.*, b.ICD_DGNS_CD1
	from input.glp1users_beneid_17to20 as a
 	left join ma_ip19.ip_base_enc_2019 as b
  	on a.BENE_ID = b.BENE_ID;
quit;

/* outpatients claim */
proc sql;
	create table obesity2 as
 	select distinct a.*, b.ICD_DGNS_CD1
	from input.glp1users_beneid_17to20 as a
 	left join ma_op19.op_base_enc_2019 as b
  	on a.BENE_ID = b.BENE_ID;
quit;

/* merge */
data obesity_id; set obesity obesity1 obesity2; run;

proc contents data=cc; run;

/* remain only distinct one */
proc sql;
	create table input.glp1users_beneid_17to20_diag as
 	select distinct a.* 
	from obesity_id as a;
quit; /* 743196 obs */

proc sort data=input.glp1users_beneid_17to20_diag; by BENE_ID; run;

* 2. find obeisty by using ICD10;
data obesity_id_obs;
	set input.glp1users_beneid_17to20_diag;
	if ICD_DGNS_CD1 in ('E660', 'E6601', 'E661', 'E662', 'E663', 'E668', 'E66811', 'E66812', 'E66813', 'E669'); 
run;
data obesity_id_obs; set obesity_id_obs; obesity = 1; run;

proc sql;
	create table cc as
 	select distinct a.*, b.obesity
  	from input.glp1users_beneid_17to20_cc as a
   	left join obesity_id_obs as b
    on a.BENE_ID=b.BENE_ID;
quit;

data cc; set cc; if missing(obesity) then obesity =0; run;
proc freq data=cc; table obesity; run;

* 3. merge obesity indicator with the original BENE_ID file; 
proc sql;
	create table input.glp1users_beneid_17to20_cc as
 	select distinct a.*, b.obesity
  	from input.glp1users_beneid_17to20_cc as a
   	left join cc as b
    on a.BENE_ID=b.BENE_ID;
quit;

* 4. merge obesity indicator with the original population file; 
proc sql;
	create table input.glp1users_pde_17to20_v04 as
 	select distinct a.*, b.obesity
  	from input.glp1users_pde_17to20_v04 as a
   	left join input.glp1users_beneid_17to20_cc as b
    on a.BENE_ID=b.BENE_ID;
quit;


