
/************************************************************************************
| Project name : identify GLP1 users from TM files
| Task Purpose : 
|      1. GLP1 new users from 2018 - 2020 (n = 69,115)
| Final dataset : 
|	input.glp1users_pde_17to20
|	input.glp1users_beneid_17to20
************************************************************************************/

* NDC code for drug;
PROD_SRVC_ID : PDE /* */
LINE_NDC_CD : at TM


/* NDCs codes 
Ozempic | in ('500905138%', '500905139%', '500905949%', '500906051%', '001694132%', '001694136%', '001694130%', '001694772%', '001694181%', 
'705182143%')
RYBELSUS | in ('001694303%', '001694307%', '001694314%')
Mounjaro | in ('000021457%', '000021460%', '000021471%', '000021484%', '000021495%', '000021506%', '000021152%', '000021243%', '000022214%', '000022340%', '000022423%', '000023002%')
*/

* select glp1 users from TM;
proc contents data=tm_ip21.inpatient_base_claims_2021;
run;

    var BENE_ID LINE_NDC_CD;
    Where LINE_NDC_CD like '500905138%' or 
        LINE_NDC_CD like '500905139%' or 
        LINE_NDC_CD like '500906051%';
run;

proc print data=input.glp1users_pde_17to20 (obs = 20);
where PROD_SRVC_ID like '500905138%' or 
          PROD_SRVC_ID like '500905139%' or 
          PROD_SRVC_ID like '500905949%' or 
          PROD_SRVC_ID like '500906051%' or 
          PROD_SRVC_ID like '001694132%' or 
          PROD_SRVC_ID like '001694136%' or 
          PROD_SRVC_ID like '001694130%' or 
          PROD_SRVC_ID like '001694772%' or 
          PROD_SRVC_ID like '001694181%' or 
          PROD_SRVC_ID like '705182143%';
run;





* merge PDE 2020 with formulary 2020 to identify coverage;

data glp1users_pde20;
  set pde20.pde_file_2020;
  if BN in ('OZEMPIC', 'RYBELSUS', 'MOUNJARO');
run;

proc sql;
	create table glp1users_pde20_v01 as
 	select distinct a.*, b.*
  	from glp1users_pde20_v01 as a
  left join form20.formulary_2020 as b 
  on a.FORMULARY_ID=b.FORMULARY_ID and a.FRMLRY_RX_ID = b.FRMLRY_RX_ID;   
quit; /* 260232 obs */

proc sql;
    create table glp1users_pde20_v01 as
    select distinct 
        a.*, 
        b.*, 
        case 
            when b.FORMULARY_ID is null then 1  /* Row not found in Table B */
            else 0                             /* Row matched in Table B */
        end as not_found_flag
    from glp1users_pde20 as a
    left join form20.formulary_2020 as b 
    on a.FORMULARY_ID = b.FORMULARY_ID and a.FRMLRY_RX_ID = b.FRMLRY_RX_ID;
quit;

data input.glp1users_pde20_v01;
set glp1users_pde20_v01;
run;

proc print data=input.glp1users_pde20_v01 (obs=10); run;

proc freq data=input.glp1users_pde20_v01;
    tables not_found_flag;
run;







