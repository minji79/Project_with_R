/************************************************************************************
| Project name : Identify off label use of GLP1 following several definitions
| Task Purpose : 
|      1. 
| Final dataset : 
|       00
************************************************************************************/

## using R
module load R
module load rstudio
rstudio

## Setting
setwd("/users/59883/c-mkim255-59883/glp1off/sas_input")

install.packages("MatchIt")
install.packages("cobalt")
install.packages("WeightIt")
install.packages("haven")

library(tidyverse)
library(haven)
library(lubridate)
library(dplyr)
library(ggplot2)
library(MatchIt)
library(cobalt)
library(WeightIt)

# loading sas dataset
df <- read_sas("studypop.sas7bdat")

#####################################################################################
#     1.    proprocessing before matching (drop 349 individuals with missing age)
#####################################################################################

# 1. change variable name and format
# Treated = PRIOR_AUTHORIZATION_YN (0/1) -> pa
# outcome = offlabel_df5 (0/1) -> offlabel

df <- df %>% rename(pa = PRIOR_AUTHORIZATION_YN, offlabel = offlabel_df5) 
df$pa <- as.numeric(trimws(df$pa))

# 2. check missingness (need to be no missingness)
mice::md.pattern(df, plot=FALSE)

# 3. drop 349 individuals with missing age
df <- df %>% select(-CMPND_CD, -PD_DT, -not_found_flag, -DOB_DT)
df <- df %>% filter(!is.na(age_at_index))


#####################################################################################
#     2.    Balance before matching
#####################################################################################

# No matching; constructing a pre-match matchit object (method=NULL)
m.out0 <- matchit(pa ~ ma_16to20 + BENEFIT_PHASE + TIER_ID + STEP + age_at_index + BENE_RACE_CD + region + obesity + htn + acute_mi + hf + stroke + alzh, 
                  data = df, method = NULL, distance = "glm")

# Checking balance prior to matching
summary(m.out0)


#####################################################################################
#     3.    Propensity score matching
#####################################################################################

#Performs the matching (1:1 PS matching w/o replacement)
m.out <- matchit(pa ~ ma_16to20 + BENEFIT_PHASE + TIER_ID + STEP + age_at_index + BENE_RACE_CD + region + obesity + htn + acute_mi + hf + stroke + alzh, 
                  data = df, method = "nearest") 

m.out

#Observations matched to each other (m.out$match.matrix)
head(m.out$match.matrix, 10)


