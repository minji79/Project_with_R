
* 1. merge patients' diagnosis ICD10 code;
/* for non-institutional claims */
proc sql;
	create table tm_car21 as
 	select distinct a.*, b.ICD_DGNS_CD1
	from input.glp1users_beneid_17to20 as a
 	left join tm_car21.bcarrier_claims_2021 as b
  	on a.BENE_ID = b.BENE_ID;
quit;
proc sql;
	create table tm_car20 as
 	select distinct a.*, b.ICD_DGNS_CD1
	from input.glp1users_beneid_17to20 as a
 	left join tm_car20.bcarrier_claims_2020 as b
  	on a.BENE_ID = b.BENE_ID;
quit;
proc sql;
	create table tm_car19 as
 	select distinct a.*, b.ICD_DGNS_CD1
	from input.glp1users_beneid_17to20 as a
 	left join tm_car19.bcarrier_claims_2019 as b
  	on a.BENE_ID = b.BENE_ID;
quit;
proc sql;
	create table tm_car18 as
 	select distinct a.*, b.ICD_DGNS_CD1
	from input.glp1users_beneid_17to20 as a
 	left join tm_car18.bcarrier_claims_k_2018 as b
  	on a.BENE_ID = b.BENE_ID;
quit;
proc sql;
	create table tm_car17 as
 	select distinct a.*, b.ICD_DGNS_CD1
	from input.glp1users_beneid_17to20 as a
 	left join tm_car17.bcarrier_claims_k_2017 as b
  	on a.BENE_ID = b.BENE_ID;
quit;
proc sql;
	create table tm_car16 as
 	select distinct a.*, b.ICD_DGNS_CD1
	from input.glp1users_beneid_17to20 as a
 	left join tm_car16.bcarrier_claims_k_2016 as b
  	on a.BENE_ID = b.BENE_ID;
quit;
proc sql;
	create table tm_car15 as
 	select distinct a.*, b.ICD_DGNS_CD1
	from input.glp1users_beneid_17to20 as a
 	left join tm_car15.bcarrier_claims_k_2015 as b
  	on a.BENE_ID = b.BENE_ID;
quit;


/* inpatients claim */
proc sql;
	create table tm_ip21 as
 	select distinct a.*, b.ICD_DGNS_CD1
	from input.glp1users_beneid_17to20 as a
 	left join tm_ip21.inpatient_base_claims_2021 as b
  	on a.BENE_ID = b.BENE_ID;
quit;
proc sql;
	create table tm_ip20 as
 	select distinct a.*, b.ICD_DGNS_CD1
	from input.glp1users_beneid_17to20 as a
 	left join tm_ip20.inpatient_base_claims_2020 as b
  	on a.BENE_ID = b.BENE_ID;
quit;
proc sql;
	create table tm_ip19 as
 	select distinct a.*, b.ICD_DGNS_CD1
	from input.glp1users_beneid_17to20 as a
 	left join tm_ip19.inpatient_base_claims_2019 as b
  	on a.BENE_ID = b.BENE_ID;
quit;
proc sql;
	create table tm_ip18 as
 	select distinct a.*, b.ICD_DGNS_CD1
	from input.glp1users_beneid_17to20 as a
 	left join tm_ip18.inpatient_base_claims_k_2018 as b
  	on a.BENE_ID = b.BENE_ID;
quit;
proc sql;
	create table tm_ip17 as
 	select distinct a.*, b.ICD_DGNS_CD1
	from input.glp1users_beneid_17to20 as a
 	left join tm_ip17.inpatient_base_claims_k_2017 as b
  	on a.BENE_ID = b.BENE_ID;
quit;
proc sql;
	create table tm_ip16 as
 	select distinct a.*, b.ICD_DGNS_CD1
	from input.glp1users_beneid_17to20 as a
 	left join tm_ip16.inpatient_base_claims_k_2016 as b
  	on a.BENE_ID = b.BENE_ID;
quit;
proc sql;
	create table tm_ip15 as
 	select distinct a.*, b.ICD_DGNS_CD1
	from input.glp1users_beneid_17to20 as a
 	left join tm_ip15.inpatient_base_claims_k_2015 as b
  	on a.BENE_ID = b.BENE_ID;
quit;

/* outpatients claim */
proc sql;
	create table tm_op21 as
 	select distinct a.BENE_ID, b.ICD_DGNS_CD1
	from input.glp1users_beneid_17to20 as a
 	left join tm_op21.outpatient_base_claims_2021 as b
  	on a.BENE_ID = b.BENE_ID;
quit;
proc sql;
	create table tm_op20 as
 	select distinct a.BENE_ID, b.ICD_DGNS_CD1
	from input.glp1users_beneid_17to20 as a
 	left join tm_op20.outpatient_base_claims_2020 as b
  	on a.BENE_ID = b.BENE_ID;
quit;
proc sql;
	create table tm_op19 as
 	select distinct a.BENE_ID, b.ICD_DGNS_CD1
	from input.glp1users_beneid_17to20 as a
 	left join tm_op19.outpatient_base_claims_2019 as b
  	on a.BENE_ID = b.BENE_ID;
quit;
proc sql;
	create table tm_op18 as
 	select distinct a.BENE_ID, b.ICD_DGNS_CD1
	from input.glp1users_beneid_17to20 as a
 	left join tm_op18.outpatient_base_claims_k_2018 as b
  	on a.BENE_ID = b.BENE_ID;
quit;
proc sql;
	create table tm_op17 as
 	select distinct a.BENE_ID, b.ICD_DGNS_CD1
	from input.glp1users_beneid_17to20 as a
 	left join tm_op17.outpatient_base_claims_k_2017 as b
  	on a.BENE_ID = b.BENE_ID;
quit;
proc sql;
	create table tm_op16 as
 	select distinct a.BENE_ID, b.ICD_DGNS_CD1
	from input.glp1users_beneid_17to20 as a
 	left join tm_op16.outpatient_base_claims_k_2016 as b
  	on a.BENE_ID = b.BENE_ID;
quit;
proc sql;
	create table tm_op15 as
 	select distinct a.BENE_ID, b.ICD_DGNS_CD1
	from input.glp1users_beneid_17to20 as a
 	left join tm_op15.outpatient_base_claims_k_2015 as b
  	on a.BENE_ID = b.BENE_ID;
quit;

/* tm_hha15 */
proc sql;
	create table tm_hha21 as
 	select distinct a.BENE_ID, b.ICD_DGNS_CD1
	from input.glp1users_beneid_17to20 as a
 	left join tm_hha21.hha_base_claims_2021 as b
  	on a.BENE_ID = b.BENE_ID;
quit;
proc sql;
	create table tm_hha20 as
 	select distinct a.BENE_ID, b.ICD_DGNS_CD1
	from input.glp1users_beneid_17to20 as a
 	left join tm_hha20.hha_base_claims_2020 as b
  	on a.BENE_ID = b.BENE_ID;
quit;
proc sql;
	create table tm_hha19 as
 	select distinct a.BENE_ID, b.ICD_DGNS_CD1
	from input.glp1users_beneid_17to20 as a
 	left join tm_hha19.hha_base_claims_2019 as b
  	on a.BENE_ID = b.BENE_ID;
quit;
proc sql;
	create table tm_hha18 as
 	select distinct a.BENE_ID, b.ICD_DGNS_CD1
	from input.glp1users_beneid_17to20 as a
 	left join tm_hha18.hha_base_claims_k_2018 as b
  	on a.BENE_ID = b.BENE_ID;
quit;
proc sql;
	create table tm_hha17 as
 	select distinct a.BENE_ID, b.ICD_DGNS_CD1
	from input.glp1users_beneid_17to20 as a
 	left join tm_hha17.hha_base_claims_k_2017 as b
  	on a.BENE_ID = b.BENE_ID;
quit;
proc sql;
	create table tm_hha16 as
 	select distinct a.BENE_ID, b.ICD_DGNS_CD1
	from input.glp1users_beneid_17to20 as a
 	left join tm_hha16.hha_base_claims_k_2016 as b
  	on a.BENE_ID = b.BENE_ID;
quit;
proc sql;
	create table tm_hha15 as
 	select distinct a.BENE_ID, b.ICD_DGNS_CD1
	from input.glp1users_beneid_17to20 as a
 	left join tm_hha15.hha_base_claims_k_2015 as b
  	on a.BENE_ID = b.BENE_ID;
quit;


/* merge */
data tm_dig_id; 
set tm_car21 tm_car20 tm_car19 tm_car18 tm_car17 tm_car16 tm_car15
tm_ip21 tm_ip20 tm_ip19 tm_ip18 tm_ip17 tm_ip16 tm_ip15 
tm_op21 tm_op20 tm_op19 tm_op18 tm_op17 tm_op16 tm_op15
tm_hha21 tm_hha20 tm_hha19 tm_hha18 tm_hha17 tm_hha16 tm_hha15; 
run;

/* remain only distinct one */
proc sql;
	create table input.glp1users_beneid_17to20_diag_TM as
 	select distinct a.* 
	from tm_dig_id as a;
quit;


* 2. find diabetes by using ICD10;
data diabetes_id;
	set input.glp1users_beneid_17to20_diag_TM;
	if ICD_DGNS_CD1 in ('E11','E1100','E1101','E11618','E11620','E11621','E11622','E11628','E11630','E11638','E11641', 'E11649', 'E1165', 'E1169', 'E118', 'E119');
run;
data diabetes_id; set diabetes_id; diabetes_tm = 1; run;

proc sql;
	create table cc as
 	select distinct a.*, b.diabetes_tm
  	from input.glp1users_beneid_17to20_cc as a
   	left join diabetes_id as b
    on a.BENE_ID=b.BENE_ID;
quit;
data cc; set cc; if missing(diabetes_tm) then diabetes_tm =0; run;
proc freq data=cc; table diabetes_tm; run;

* 3. merge obesity indicator with the original BENE_ID file; 
proc sql;
	create table input.glp1users_beneid_17to20_cc as
 	select distinct a.*, b.diabetes_tm
  	from input.glp1users_beneid_17to20_cc as a
   	left join cc as b
    on a.BENE_ID=b.BENE_ID;
quit;

* 4. merge obesity indicator with the original population file; 
proc sql;
	create table input.glp1users_pde_17to20_v04 as
 	select distinct a.*, b.diabetes_tm
  	from input.glp1users_pde_17to20_v04 as a
   	left join input.glp1users_beneid_17to20_cc as b
    on a.BENE_ID=b.BENE_ID;
quit;
