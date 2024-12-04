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

libname mj "/users/59883/c-mkim255-59883/minji";

libname input "cms01/data/dua/59883/"
