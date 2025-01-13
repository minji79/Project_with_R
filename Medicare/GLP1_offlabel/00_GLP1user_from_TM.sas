
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

/* 2020 */
data pde2020;
	set input.studypop;
	where SRVC_DT_year = 2020;
run;  /* 38681 */

proc sql;
    create table pde2020_coverd as
    select distinct 
        a.*, 
        b.*, 
        case 
            when b.FORMULARY_ID is null then 1  /* Row not found in Table B */
            else 0                             /* Row matched in Table B */
        end as not_found_flag
    from pde2020 as a
    left join form20.formulary_2020 as b 
    on a.FORMULARY_ID = b.FORMULARY_ID and a.FRMLRY_RX_ID = b.FRMLRY_RX_ID;
quit;

proc freq data=pde2020_coverd;
    tables not_found_flag;
run;

data cover;
	set pde2020_coverd;
 	where not_found_flag =1;
run; /* 3098 -> /38681 = 91.9% */
data cover_diabetes;
	set cover;
 	where diabetes =1;
run; /* 1575 */


/* 2019 */
data pde2019;
	set input.studypop;
	where SRVC_DT_year = 2019;
run;  /* 25117 */

proc sql;
    create table pde2019_coverd as
    select distinct 
        a.*, 
        b.*, 
        case 
            when b.FORMULARY_ID is null then 1  /* Row not found in Table B */
            else 0                             /* Row matched in Table B */
        end as not_found_flag
    from pde2019 as a
    left join form19.formulary_2019 as b 
    on a.FORMULARY_ID = b.FORMULARY_ID and a.FRMLRY_RX_ID = b.FRMLRY_RX_ID;
quit;

data cover;
	set pde2019_coverd;
 	where not_found_flag =1;
run; /* 2366 -> /25177 = 90.6% */
data cover_diabetes;
	set cover;
 	where diabetes =1;
run; /* 1575 */

/* 2018 */
data pde2018;
	set input.studypop;
	where SRVC_DT_year = 2018;
run;  /* 5317 */

proc sql;
    create table pde2018_coverd as
    select distinct 
        a.*, 
        b.*, 
        case 
            when b.FORMULARY_ID is null then 1  /* Row not found in Table B */
            else 0                             /* Row matched in Table B */
        end as not_found_flag
    from pde2018 as a
    left join form18.formulary_2018 as b 
    on a.FORMULARY_ID = b.FORMULARY_ID and a.FRMLRY_RX_ID = b.FRMLRY_RX_ID;
quit;

data cover;
	set pde2018_coverd;
 	where not_found_flag =1;
run; /* 866 -> /5317 = 83.7% */

/* diabetes */
data cover_diabetes;
	set cover;
 	where diabetes =1;
run; /* 585 */


* demominator;
data total;
	set pde2020_coverd pde2019_coverd pde2018_coverd;
run;
data total_diabetes;
	set total;
 	where diabetes =1;
run; /* 44329 */

data diabetes_2020;
	set pde2020_coverd;
 	where diabetes =1; run; /* 24122 */
data diabetes_2019;
	set pde2019_coverd;
 	where diabetes =1; run; /* 16545 */
data diabetes_2018;
	set pde2018_coverd;
 	where diabetes =1; run; /* 3572 */





