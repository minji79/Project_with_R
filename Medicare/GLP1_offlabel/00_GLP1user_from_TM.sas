
/************************************************************************************
| Project name : identify GLP1 users from TM files
| Task Purpose : 
|      1. GLP1 new users from 2018 - 2020 (n = 69,115)
| Final dataset : 
|	input.glp1users_pde_17to20
|	input.glp1users_beneid_17to20
************************************************************************************/

proc print data=form20.formulary_2020 (obs=10);
    Where 
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



* NDC code for drug;
PROD_SRVC_ID : PDE /* */

/* NDCs codes 
Ozempic | in ('500905138%', '500905139%', '500905949%', '500906051%', '001694132%', '001694136%', '001694130%', '001694772%', '001694181%', 
'705182143%')
RYBELSUS | in ('001694303%', '001694307%', '001694314%')
Mounjaro | in ('000021457%', '000021460%', '000021471%', '000021484%', '000021495%', '000021506%', '000021152%', '000021243%', '000022214%', '000022340%', '000022423%', '000023002%')
*/

/* Type 2 Diabetes ICD10 codes
in ('E1100','E1101','E11618','E11620','E11621','E11622','E11628','E11630','E11638','E11641', 'E11649', 'E1165', 'E1169', 'E118', 'E119')
*/









