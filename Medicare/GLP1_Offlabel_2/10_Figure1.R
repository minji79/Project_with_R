
## using R
module load R
module load rstudio
rstudio


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

# loading sas dataset;
df <- read_sas("studypop.sas7bdat")

# discrete time : monthly 
df <- df %>% mutate(rx_ym = format(SRVC_DT, "%Y-%m")) 


#### with definition 5
glp1_all_monthly <- df %>% group_by(rx_ym) %>% summarise(glp1_count = n())
glp1_offlabel_monthly <- df %>% filter(offlabel_df5 == 1) %>% group_by(rx_ym) %>% summarise(glp1_offlabel_count = n())

monthly <- glp1_all_monthly %>% left_join(glp1_offlabel_monthly, by="rx_ym")
monthly <- monthly %>% mutate(rx_ym = as.Date(paste0(rx_ym, "-01")))

# Plot
ggplot(data = monthly, aes(x = rx_ym)) +
  geom_point(aes(y = glp1_count), size=0.5, alpha = 1, color = "blue") +
  geom_line(aes(y = glp1_count), linewidth = 0.5, linetype = "solid", color = "blue") +
  geom_point(aes(y = glp1_offlabel_count), size=0.5, alpha = 1, color = "red") +
  geom_line(aes(y = glp1_offlabel_count), linewidth = 0.5, linetype = "solid", color = "red") +
  theme_classic() +
  labs(
    x = "Year-Month",
    y = "Patients",
    title = "New GLP-1 Users in Medicare by Month"
  ) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    plot.title = element_text(face = "bold", hjust = 0.5)  # Make title bold and centered
  ) + 
  scale_x_date(
    date_breaks = "1 year",   # Breaks at each year
    date_labels = "%Y"       # Show only the year
  ) +
  annotate("text", x = as.Date("2020-09-01"), y = 400, color = "red", size = 4, label = "Possibly Off-label Use") +
  annotate("text", x = as.Date("2020-09-01"), y = 4100, color = "blue", size = 4, label = "GLP1 New Users")
