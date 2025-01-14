
* by using DIABETES variable to identify cohorts;
* input.glp1users_beneid_17to20_cc;

proc print data=

proc sql;
	create table input.glp1users_beneid_17to20_cc as
 	select distinct a.*, b.DIABETES_EVER, b.AMI_EVER, b.HF_EVER, b.STROKE_TIA_EVER, b.ALZH_EVER

	from input.glp1users_beneid_17to20 as a
  left join mbsf20.mbsf_chronic_summary_2020 as b 
  on a.BENE_ID = b.BENE_ID;
   
quit; /* 69115 obs */

