
/************************************************************************************
| Project name : Identify off label use of GLP1 following several definitions
| Task Purpose : 
|      1. Definition 1 : Have no previous diabetic medication fill (non-GLP1) at first GLP-1 fill date (n = 6121, 8.86%)
|      2. Definition 2 : Have no recorded diagnosis of diabetes at or prior to first fill (n = 24876, 35.99%)
|      3. Definition 3 : Both (1) AND (2)   (n = 3201, 4.63%)
|      4. Definition 4 : Had (3) and no diagnosis or (non-GLP1) diabetic fill after first GLP-1 fill (n = 1849, 2.68%)
|      5. Add offlabel_df1 - offlabel_df4 indicators for the glp1 users
|      6. Add index_date for the glp1 users
| Final dataset : 
|       input.glp1users_pde_17to20_v03
|       input.offlabel_v04
|       input.glp1users_beneid_17to20 (add index_date)
|       input.glp1users_all_medhis_16to20
|       input.glp1users_medhis_16to20
************************************************************************************/


/************************************************************************************
	1.    Definition 1 : Have no previous diabetic medication fill (non-GLP1) at first GLP-1 fill date (n = 6121, 8.86%)
************************************************************************************/

* 1. indicate the first GLP-1 fill date (index_date);
/**************************************************
* new table: input.glp1users_beneid_17to20
* original table: input.glp1users_beneid_17to20
* description: BENE_ID for 69,115 + add the first GLP-1 fill date
**************************************************/

proc sql;
   create table index_date as
   select BENE_ID, SRVC_DT, min(SRVC_DT) as index_date format=yymmdd10.
   from input.glp1users_pde_17to20_v02
   group by BENE_ID;
quit;

proc sql;
   create table input.glp1users_beneid_17to20 as
   select distinct a.*, b.index_date 
   from input.glp1users_beneid_17to20 as a left join index_date as b
   on a.BENE_ID = b.BENE_ID;
quit; /* 69115 obs */ 


* 2. medication history for all glp1 users;
/**************************************************
* new table: input.glp1users_all_medhis_16to20
* original table: pde
* description: BENE_ID for 69,115 + add the first GLP-1 fill date
**************************************************/

%macro yearly(data=, refer=);

proc sql;
    create table &data as
    select distinct a.*, b.SRVC_DT, b.GNN, b.BN
    from input.glp1users_beneid_17to20 as a 
    left join &refer as b
    on a.BENE_ID = b.BENE_ID;
    
quit;

%mend yearly;
%yearly(data=medhistory_2020, refer=pde20.pde_file_2020);  /* 4099396 obs */
%yearly(data=medhistory_2019, refer=pde19.pde_file_2019);  /* 3768132 obs */
%yearly(data=medhistory_2018, refer=pde18.pde_file_2018);  /* 3385536 obs */
%yearly(data=medhistory_2017, refer=pde17.pde_file_2017);  /* 3048838 obs */
%yearly(data=medhistory_2016, refer=pde16.pde_file_2016);  /* 2725088 obs */

/* stack all dataset */
data input.glp1users_all_medhis_16to20_BN;
  set medhistory_2016 medhistory_2017 medhistory_2018 medhistory_2019 medhistory_2020;
run; /* 17026990 obs */

data input.glp1users_all_medhis_16to20;
	set input.glp1users_all_medhis_16to20_BN;
 	drop BN; run;
proc sql;
	create table input.glp1users_all_medhis_16to20 as
 	select distinct *
  from input.glp1users_all_medhis_16to20;
quit;

* 3. GNN list up diabetic medications based on 2024 ;

/**************************************************
* new table: input.glp1users_medhis_16to20
* original table: input.glp1users_all_medhis_16to20
* description: 
**************************************************/

/* check for Generic */
proc print data=form20.formulary_2020 (obs=10);
   var BN GNN;
   where find(lowcase(GNN), 'acarbose') > 0
     or find(lowcase(GNN), 'glimepiride') > 0
     or find(lowcase(GNN), 'glipizide') > 0
     or find(lowcase(GNN), 'metformin') > 0
     or find(lowcase(GNN), 'miglitol') > 0
     or find(lowcase(GNN), 'nateglinide') > 0
     or find(lowcase(GNN), 'pioglitazone') > 0
     or find(lowcase(GNN), 'repaglinide') > 0
     or find(lowcase(GNN), 'insulin') > 0;
   
run;

/****************  modelcule | GNN ***************
metformin | metformin
insulin | insulin
dpp4i | sitagliptin, Linagliptin, Saxagliptin, Alogliptin
sglt2 | empagliflozin, dapagliflozin, canagliflozin, ertugliflozin, Bexagliflozin, Sotagliflozin
sulfonylureas | Glipizide, Glimepiride, Glyburide, Gliclazide
thiazolidinediones | Pioglitazone, 
meglitinide | nateglinide, repaglinide
others | acarbose, bromocriptine, miglitol
**************************************************/

data input.glp1users_medhis_16to20;
  set input.glp1users_all_medhis_16to20;
  
  where find(lowcase(GNN), 'metformin') > 0
     or find(lowcase(GNN), 'insulin') > 0

    /* dpp4i */
     or find(lowcase(GNN), 'sitagliptin') > 0
     or find(lowcase(GNN), 'linagliptin') > 0
     or find(lowcase(GNN), 'saxagliptin') > 0
     or find(lowcase(GNN), 'alogliptin') > 0

    /* sglt2 */
     or find(lowcase(GNN), 'empagliflozin') > 0
     or find(lowcase(GNN), 'canagliflozin') > 0
     or find(lowcase(GNN), 'dapagliflozin') > 0
     or find(lowcase(GNN), 'ertugliflozin') > 0
     or find(lowcase(GNN), 'bexagliflozin') > 0
     or find(lowcase(GNN), 'sotagliflozin') > 0

    /* sulfonylureas */
     or find(lowcase(GNN), 'glipizide') > 0
     or find(lowcase(GNN), 'glimepiride') > 0
     or find(lowcase(GNN), 'glyburide') > 0
     or find(lowcase(GNN), 'gliclazide') > 0

    /* thiazolidinediones */
     or find(lowcase(GNN), 'pioglitazone') > 0
     or find(lowcase(GNN), 'rosiglitazone') > 0

    /* meglitinide */
     or find(lowcase(GNN), 'repaglinide') > 0
     or find(lowcase(GNN), 'nateglinide') > 0
     
    /* others */
     or find(lowcase(GNN), 'acarbose') > 0
     or find(lowcase(GNN), 'bromocriptine') > 0
     or find(lowcase(GNN), 'miglitol') > 0;
   
run;   /* 2938909 obs */

* 4. SRVC_DT < index_date;
/**************************************************
* new table: input.offlabel_v01
* original table: input.glp1users_medhis_16to20
* description: 
**************************************************/

proc sql;
  create table input.glp1users_medhis_16to20 as
  select distinct a.*, b.index_date
  from input.glp1users_medhis_16to20 as a left join input.glp1users_beneid_17to20 as b
  on a.BENE_ID=b.BENE_ID;
quit;

proc sql;
   create table offlabel_df1 as
   select distinct BENE_ID
   from input.glp1users_medhis_16to20
   where SRVC_DT < index_date;
quit; /* 62994 */

* 5. offlabel_df1 inndicator;
data offlabel_df1;
  set offlabel_df1;
  offlabel_df1 = 0;
run;

proc sql;
   create table input.offlabel_v01 as
   select distinct a.*, b.offlabel_df1
   from input.glp1users_beneid_17to20 as a left join offlabel_df1 as b
   on a.BENE_ID=b.BENE_ID;
quit;

data input.offlabel_v01;
  set input.offlabel_v01;
  if missing(offlabel_df1) then offlabel_df1 =1;
run;

proc freq data=input.offlabel_v01; table offlabel_df1; title "offlabel_df1"; run;


/************************************************************************************
	2.    Definition 2 : Have no recorded diagnosis of diabetes at or prior to first fill (n = 24876, 35.99%)
************************************************************************************/

* 1. offlabel_df2 inndicator;
/**************************************************
* new table: input.offlabel_v02
* original table: input.glp1users_pde_17to20_v02 
* description: 
**************************************************/

proc sql;
   create table offlabel_df2 as
   select distinct BENE_ID
   from input.glp1users_pde_17to20_v02 
   where diabetes = 1;
quit; /* 44239 */

data offlabel_df2;
  set offlabel_df2;
  offlabel_df2 = 0;
run;

proc sql;
   create table input.offlabel_v02 as
   select distinct a.*, b.offlabel_df2
   from input.offlabel_v01 as a left join offlabel_df2 as b
   on a.BENE_ID=b.BENE_ID;
quit;

data input.offlabel_v02;
  set input.offlabel_v02;
  if missing(offlabel_df2) then offlabel_df2 =1;
run;

proc freq data=input.offlabel_v02; table offlabel_df2; title "offlabel_df2"; run;


/************************************************************************************
	3.    Definition 3 : Both (1) AND (2)   (n = 3201, 4.63%)
************************************************************************************/

* 1. offlabel_df3 inndicator;
/**************************************************
* new table: input.offlabel_v03
* original table: input.offlabel_v02
* description: 
**************************************************/

data input.offlabel_v03;
  set input.offlabel_v02;
  if offlabel_df1 = 1 and offlabel_df2 = 1 then offlabel_df3 = 1;
  else offlabel_df3 = 0;
run;

proc freq data=input.offlabel_v03; table offlabel_df3; title "offlabel_df3"; run;


/************************************************************************************
	4.    Definition 4 : Had (3) and no diagnosis or (non-GLP1) diabetic fill after first GLP-1 fill (n = 1849, 2.68%)
************************************************************************************/

* 1. select individuals with anti-diabetics medications at any time point;
/**************************************************
* new table: input.offlabel_v04
* original table: input.glp1users_medhis_16to20
* description: 
**************************************************/

proc sql;
   create table offlabel_df4 as
   select distinct BENE_ID
   from input.glp1users_medhis_16to20;
quit; /* 66085 */

* 2. offlabel_df inndicator;
data offlabel_df4;
  set offlabel_df4;
  offlabel_df4_pre = 0;
run;

proc sql;
   create table input.offlabel_v04 as
   select distinct a.*, b.offlabel_df4_pre
   from input.offlabel_v03 as a left join offlabel_df4 as b
   on a.BENE_ID=b.BENE_ID;
quit;

data input.offlabel_v04;
  set input.offlabel_v04;
  if missing(offlabel_df4_pre) then offlabel_df4_pre =1;
run;

data input.offlabel_v04;
  set input.offlabel_v04;
  if offlabel_df4_pre = 1 and offlabel_df3 = 1 then offlabel_df4 = 1;
  else offlabel_df4 = 0;
run;

proc freq data=input.offlabel_v04; table offlabel_df4_pre; title "offlabel_df4"; run;
proc freq data=input.offlabel_v04; table offlabel_df4; title "offlabel_df4"; run;

* 3. delete dataset;
proc delete data =input.offlabel_v01; run;
proc delete data =input.offlabel_v02; run;
proc delete data =input.offlabel_v03; run;

/************************************************************************************
	5.    Add offlabel_df1 - offlabel_df4 indicators for the glp1 users
  6.    Add index_date for the glp1 users
************************************************************************************/

/**************************************************
* new table: input.glp1users_pde_17to20_v03
* original table: input.glp1users_pde_17to20_v02 
* description: Add offlabel_df1 - offlabel_df4 indicators
**************************************************/

* 1. add index_date;
proc sql;
   create table input.glp1users_pde_17to20_v03 as
   select distinct a.*, b.index_date
   from input.glp1users_pde_17to20_v02 as a left join input.glp1users_beneid_17to20 as b
   on a.BENE_ID=b.BENE_ID;
quit;

* 2. add offlabel_df1 - offlabel_df4 indicators;
proc sql;
   create table input.glp1users_pde_17to20_v03 as
   select distinct a.*, b.offlabel_df1, b.offlabel_df2, b.offlabel_df3, b.offlabel_df4
   from input.glp1users_pde_17to20_v03 as a left join input.offlabel_v04 as b
   on a.BENE_ID=b.BENE_ID and a.index_date=b.index_date;
quit;

