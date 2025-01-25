/************************************************************************************
| Project name : Identify off label use of GLP1 following several definitions
| Task Purpose : 
|      1. 
| Final dataset : 
|       00
************************************************************************************/

/************************************************************************************
	1.    OOP 
************************************************************************************/

/*
variable
DRUG_CVRG_CD

*/






/************************************************************************************
	2.    Gross Rx cost
************************************************************************************/

/*
variable
CTSTRPHC_CVRG_CD == C (C = Above attachment point ) -> GDC_ABV_OOPT_AMT is not null
GDC_ABV_OOPT_AMT : This variable is the portion of the gross drug cost for the prescription drug fill that was covered by Part D’s catastrophic coverage. 
GDC_BLW_OOPT_AMT : This variable is the portion of the gross drug cost for the prescription drug fill that was not covered by Part D’s catastrophic coverage. 

TOT_RX_CST_AMT : total drug cost : This is the price paid for the drug at the point of sale

PTNT_PAY_AMT : Amount Paid by Patient 
OTHR_TROOP_AMT  : Other True Out-of-Pocket (TrOOP) Amount (Two examples are payments by qualified state pharmacy assistance programs or charities. )
LICS_AMT : Amount paid for the PDE by Part D low income subsidy  (This is the amount of cost sharing for the drug that was paid by the Part D low-income subsidy (LICS)) plan-reported amounts per drug event;
PLRO_AMT : Reduction in patient liability due to payments by other payers (PLRO) - This is the amount of any payment by other third-party payers that reduces the beneficiary’s liability for the PDE but does not count towards Part D’s true out-of-pocket (TrOOP) requirement.
(payments by group health plans, worker's compensation, and governmental programs)

CVRD_D_PLAN_PD_AMT :Amount paid by Part D plan for the PDE (drug is covered by Part D) : This is the net amount that the Part D plan paid for a PDE that was covered by the Medicare Part D benefit.  
NCVRD_PLAN_PD_AMT :Amount paid by Part D plan for the PDE (drug is not covered by Part D) 
*/

proc print data=input.studypop (obs=30); 
  var GDC_ABV_OOPT_AMT GDC_BLW_OOPT_AMT TOT_RX_CST_AMT;
run;

