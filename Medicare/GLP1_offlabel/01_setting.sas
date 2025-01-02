## start 
ssh -X c-mkim255-59883@jhpcecms01.jhsph.edu  
srun --pty --x11 --partition=sas bash

cd /cms01/data/dua/59883/
cd /users/59883/c-mkim255-59883/

## using SAS : it is only available with SAS
module load sas
csas -WORK /tmp/

## using R
module load R
module load rstudio
rstudio

/********************************************************************************************************************************************************/
setwd("/cms01/data/dua/59883/part_d_pde/2020/SAS")

/* input file */
libname input "/users/59883/c-mkim255-59883/glp1off/sas_input";

/* part_d_pde */
libname pde16 "/cms01/data/dua/59883/part_d_pde/2016/SAS";
libname pde17 "/cms01/data/dua/59883/part_d_pde/2017/SAS";
libname pde18 "/cms01/data/dua/59883/part_d_pde/2018/SAS";
libname pde19 "/cms01/data/dua/59883/part_d_pde/2019/SAS";
libname pde20 "/cms01/data/dua/59883/part_d_pde/2020/SAS";

/* part_d_formulary */
libname form16 "/cms01/data/dua/59883/part_d_formulary/2016/SAS";
libname form17 "/cms01/data/dua/59883/part_d_formulary/2017/SAS";
libname form18 "/cms01/data/dua/59883/part_d_formulary/2018/SAS";
libname form19 "/cms01/data/dua/59883/part_d_formulary/2019/SAS";
libname form20 "/cms01/data/dua/59883/part_d_formulary/2020/SAS";

/*This is stacking all 6 years of traditional medicare inpatient files and save to my personal folder*/

data input.pde_16to20 (compress=yes);
set pde16.pde_file_2016
    pde17.pde_file_2017
    pde18.pde_file_2018
    pde19.pde_file_2019
    pde20.pde_file_2020;
run;

/* read the pde file */
proc print data=pde20.pde_file_2020 (obs=30);
    title "pde_file_2020";
run;                      
proc contents data=pde20.pde_file_2020;
    title "pde_file_2020";
run;  

/* read the formulary file */
* formulary_2020.sas7bdat ;
proc print data=form20.formulary_2020 (obs=30);
    title "formulary_2020";
run;                      
proc contents data=form20.formulary_2020;
    title "formulary_2020";
run; 

* excl_drugs_2020.sas7bdat ;
proc print data=form20.excl_drugs_2020 (obs=30);
    title "excl_drugs_2020";
run;                      
proc contents data=form20.excl_drugs_2020;
    title "excl_drugs_2020";
run; 

* ibc_2020.sas7bdat;
proc print data = form20.ibc_2020 (obs=30);
    title "ibc_2020";
run;                 
proc contents data=form20.ibc_2020;
    title "ibc_2020";
run;

* otc_drugs_2020.sas7bdat;
proc print data = form20.otc_drugs_2020 (obs=30);
    title "otc_drugs_2020";
run;                 
proc contents data=form20.otc_drugs_2020;
    title "otc_drugs_2020";
run;






