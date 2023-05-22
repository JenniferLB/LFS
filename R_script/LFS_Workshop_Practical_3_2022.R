# LFS WORKSHOP PRACTICAL SESSION
## Exercise 3: Examining Labour Market Flows using the Labour Force Survey Two-Quarter Longitudinal Dataset.

### Notes
### This exercise is based on data for July - December, 2020, which is available from the UK Data Service: SN: 8778, <http://doi.org/10.5255/UKDA-SN-8778-1> 
### The exercise uses three different methods of examining labour market flows using the Two-Quarter Longitudinal Dataset.
### The estimates relate to figures published by ONS on the 'Labour market flows NSA' sheet in dataset X02: 
### <https://www.ons.gov.uk/employmentandlabourmarket/peopleinwork/employmentandemployeetypes/datasets/labourforcesurveyflowsestimatesx02>
library(dplyr)
library(tidyr)
library(sjmisc)
library(tidytab)

### Set the directory, open the data and keep the necessary variables.

#setwd("~/LFS Workshop")

lfs_js20_od20 <- haven::read_sav("UKDA-8778-spss/spss/spss25/LGWT20_2q_js20_od20_eul.sav")

mydata3 <- select(lfs_js20_od20, AGES2, AGE2, LGWT20, EMPLEN1, EMPLEN2, flow, SEX, ILODEFR1, ILODEFR2, INCAC051, INCAC052, SC10MMJ1, SC10MMJ2, In792sm2, In792sm1)


### Examine the variables.

#colnames(mydata3)
frq(mydata3[c(1:2,4:15)])


### REVIEW QUESTIONS 1
### What is the variable flow?
### Why do some variables have a suffix of 1 or 2?
  
### Method 1 - use the variable flow to examine labour market flows.
### Filter for those aged 16-64.
### Weight by the longitudinal weight.
### Examine the variables flow.

mydata3 %>% 
  filter(AGE2>15 & AGE2<65) %>% 
  frq(flow, weights = LGWT20)


### REVIEW QUESTIONS 2 
### How many were in employment at first quarter and in employment at final quarter?
### Note: These results are the not seasonally adjusted estimates (people aged 16-64, UK (thousands))

### Method 2: use a filter to select a group and the frequency table for flow.

mydata3 %>% 
   filter(ILODEFR1==1 & EMPLEN2==1) %>% 
  frq(flow, weights = LGWT20)


### REVIEW QUESTIONS 3
### What has been estimated with the filter and table above?
### Note: examine the two variables used in the filter to understand the selection.

frq(mydata3[c(5,8)])

### Method 3: Examine change using a cross-tabulation of equivalent variables 
### at time point 1 and time point 2 (Employee and self-employment flows).

### Create a simplified economic activity variable 
###(with employee+ and one inactive group) for time point 1.

mydata3$eco1 <- rec(mydata3$INCAC051, rec="1,3,4=1;2=2;5=3; else=4")

mydata3$eco1 <- sjlabelled::set_labels(mydata3$eco1,
                                      labels = c( "Employee +", 
                                                  "Self-Employed",       
                                                  "Unemployed", 
                                                  "Inactive"))


### Create an equivalent variable for time point 2.

mydata3$eco2 <- rec(mydata3$INCAC052, rec="1,3,4=1;2=2;5=3; else=4")

mydata3$eco2 <- sjlabelled::set_labels(mydata3$eco2,
                                      labels = c( "Employee +", 
                                                  "Self-Employed",       
                                                  "Unemployed", 
                                                  "Inactive"))

### Filter by age.
### Weight by LGWT20.
### Examine change in status using a cross-tabulation of economic activity at time 1 and time 2.

mydata3 %>% 
  filter(AGE2>15 & AGE2<65) %>% 
  uncount(weights = .$LGWT20) %>% 
  tab(eco1,eco2)


### REVIEW QUESTIONS 4
### What was the flow between 1) employee and self-employed and 2) self-employed to employee?
  
  
### What next? This is the final structured exercise. Some ideas for what to do next are:
### Use the methods above to examine flows between industry or occupation (SC10MMJ1 SC10MMJ2 in792sm2 in792sm1).

### Open the full dataset to examine what variables in the Two-Quarter Longitudinal Dataset.

colnames(lfs_js20_od20)

