
/************************************************************************************
| Project name : 
| Task Purpose : 
|      1. Goldstandard
|      2. Identified using only pde - use certain drug ar any time
|      3. Calculate Se and Sp
| Final dataset : 
|       input.sesp
************************************************************************************/

* input.glp1users_beneid_17to20_cc:
proc contents data=input.glp1users_beneid_17to20_cc; run;

/************************************************************************************
	1.    Goldstandard
************************************************************************************/

proc sql;
  create table sesp as
  select BENE_ID, diabetes as diabetes_std, obesity as obesity_std, cc_acute_mi as acutemi_std, cc_hf as hf_std, cc_stroke as stroke_std, cc_alzh as alzh_std
  from input.glp1users_beneid_17to20_cc;
quit;

/************************************************************************************
	2.    Identified using only pde - use certain drug ar any time
************************************************************************************/

/**************************************************
* new table: input.sesp
* original table: input.glp1users_all_medhis_16to20;
* description: 
**************************************************/

* 1. diabetes;
proc sql;
   create table diabetes as
   select distinct BENE_ID
   from input.glp1users_medhis_16to20;
quit; /* 66085 */
data diabetes; set diabetes; diabetes_pde = 1; run;

* 2. obesity;
data obesity1;
  set input.glp1users_all_medhis_16to20;  
  where find(lowcase(GNN), 'orlistat') > 0
     or find(lowcase(GNN), 'phentermine') > 0
     or find(lowcase(GNN), 'topiramate') > 0
     or find(lowcase(GNN), 'naltrexone') > 0
     or find(lowcase(GNN), 'bupropion') > 0;
run;     
data obesity2;
  set input.glp1users_all_medhis_16to20_BN;  
  where find(lowcase(BN), 'saxenda') > 0
     or find(lowcase(BN), 'wegovy') > 0
     or find(lowcase(BN), 'zepbound') > 0;
run;    
data obesity; set obesity1 obesity2; run;
data obesity; set obesity; obesity_pde = 1; run;
proc delete data=input.glp1users_all_medhis_16to20_BN; run;

* 3. acutemi;
data acutemi;
  set input.glp1users_all_medhis_16to20;  
  where find(lowcase(GNN), 'aspirin') > 0
     or find(lowcase(GNN), 'lopidogrel') > 0
     or find(lowcase(GNN), 'prasugrel') > 0
     or find(lowcase(GNN), 'ticagrelor') > 0
     or find(lowcase(GNN), 'alteplase') > 0
     or find(lowcase(GNN), 'streptokinase') > 0
     or find(lowcase(GNN), 'heparin') > 0
     or find(lowcase(GNN), 'warfarin') > 0
     or find(lowcase(GNN), 'dabigatran') > 0
     or find(lowcase(GNN), 'rivaroxaban') > 0
     or find(lowcase(GNN), 'apixaban') > 0
     or find(lowcase(GNN), 'edoxaban') > 0
     or find(lowcase(GNN), 'nitrates') > 0;
run;
data acutemi; set acutemi; acutemi_pde = 1; run;

* 4. heart failure;
data hf;
  set input.glp1users_all_medhis_16to20;  
  where find(lowcase(GNN), 'spironolactone') > 0
     or find(lowcase(GNN), 'eplerenone') > 0
     or find(lowcase(GNN), 'finerenone') > 0
     or find(lowcase(GNN), 'canrenoic') > 0
     or find(lowcase(GNN), 'canrenone') > 0
     or find(lowcase(GNN), 'hydralazine') > 0
     or find(lowcase(GNN), 'dinitrate') > 0
     or find(lowcase(GNN), 'ivabradine') > 0
     or find(lowcase(GNN), 'digoxin') > 0
     or find(lowcase(GNN), 'riociguat') > 0
     or find(lowcase(GNN), 'vericiguat') > 0;
run;
data hf; set hf; hf_pde = 1; run;

* 5. stroke;
data stroke;
  set input.glp1users_all_medhis_16to20;  
  where find(lowcase(GNN), 'alteplase') > 0
     or find(lowcase(GNN), 'tenecteplase') > 0
     or find(lowcase(GNN), 'aspirin') > 0
     or find(lowcase(GNN), 'lopidogrel') > 0
     or find(lowcase(GNN), 'prasugrel') > 0
     or find(lowcase(GNN), 'ticagrelor') > 0;
run;
data stroke; set stroke; stroke_pde = 1; run;

* 6. Alzheimer’s;
data alzh;
  set input.glp1users_all_medhis_16to20;  
  where find(lowcase(GNN), 'donepezil') > 0
     or find(lowcase(GNN), 'galantamine') > 0
     or find(lowcase(GNN), 'rivastigmine') > 0
     or find(lowcase(GNN), 'memantine') > 0
     or find(lowcase(GNN), 'brexpiprazole') > 0
     or find(lowcase(GNN), 'lecanemab') > 0
     or find(lowcase(GNN), 'donanemab') > 0;
run;
data alzh; set alzh; alzh_pde = 1; run;

* merge;
proc sql;
  create table input.sesp as
  select distinct a.*,

  		(b1.diabetes_pde) as diabetes_pde,
   		(b2.obesity_pde) as obesity_pde,
   		(b3.acutemi_pde) as acutemi_pde,
   		(b4.hf_pde) as hf_pde,
      (b5.stroke_pde) as stroke_pde,
      (b6.alzh_pde) as alzh_pde
     
	from sesp as a

 	left join diabetes b1 on a.BENE_ID = b1.BENE_ID
 	left join obesity b2 on a.BENE_ID = b2.BENE_ID
  left join acutemi b3 on a.BENE_ID = b3.BENE_ID
  left join hf b4 on a.BENE_ID = b4.BENE_ID
  left join stroke b5 on a.BENE_ID = b5.BENE_ID
  left join alzh b6 on a.BENE_ID = b6.BENE_ID ;
   
quit;

* missing;
data input.sesp; 
    set input.sesp; 
    if missing(diabetes_pde) then diabetes_pde = 0;
    if missing(obesity_pde) then obesity_pde = 0;
    if missing(acutemi_pde) then acutemi_pde = 0;
    if missing(hf_pde) then hf_pde = 0;
    if missing(stroke_pde) then stroke_pde = 0;
    if missing(alzh_pde) then alzh_pde = 0;
run;

/************************************************************************************
	3.    Calculate Se and Sp
************************************************************************************/

%macro disease(cc=, cc_std=, cc_pde= );

data &cc; 
    set input.sesp;
    if &cc_std = 1 and &cc_pde = 1 then indicator = "a";
    else if &cc_std = 0 and &cc_pde = 1 then indicator = "b";
    else if &cc_std = 1 and &cc_pde = 0 then indicator = "c";
    else if &cc_std = 0 and &cc_pde = 0 then indicator = "d";
run;
proc freq data=&cc; table indicator; title "&cc"; run;

%mend disease;
%disease(cc= se_diabetes, cc_std=diabetes_std, cc_pde=diabetes_pde);
%disease(cc= se_obesity, cc_std=obesity_std, cc_pde=obesity_pde);
%disease(cc= se_acutemi, cc_std=acutemi_std, cc_pde=acutemi_pde);
%disease(cc= se_hf, cc_std=hf_std, cc_pde=hf_pde);
%disease(cc= se_stroke, cc_std=stroke_std, cc_pde=stroke_pde);
%disease(cc= se_alzh, cc_std=alzh_std, cc_pde=alzh_pde);





