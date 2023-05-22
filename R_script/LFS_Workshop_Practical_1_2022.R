# LFS WORKSHOP PRACTICAL SESSION
## Exercise 1: estimates of temporary employment

### This exercise recreates ONS labour market analysis reported in the table EMP07 Temporary Employees
### <https://www.ons.gov.uk/employmentandlabourmarket/peopleinwork/employmentandemployeetypes/datasets/temporaryemployeesemp07>.
### [last accessed 24/04/2021]

### This table is updated four times a year in February, May, August and November using the Quarterly Labour Force Survey.

### The data used relates to an estimate for Oct-December 2020. Data:
### Quarterly Labour Force Survey, October - December, 2020, accessible from
### the UK Data Service (<http://doi.org/10.5255/UKDA-SN-8777-3>)

### Get set up. You will need to access the data (see above)
library(dplyr)
library(tidyr)
library(sjmisc)
library(tidytab)

### Set directory. - you need to add the correct file path for your computer, where is the data saved?
  
setwd("~/LFS workshop")
getwd()

### Open data and keep relevant variables.
lfs_od20 <- haven::read_sav("UKDA-8777-spss/spss/spss25/lfsp_od20_eul_PWT20.sav")


### REVIEW QUESTIONS
### How many variables are there?
ncol(lfs_od20)

### Save a copy, keeping only the relevant variables.

mydata1 <- lfs_od20 %>%  
  select(PERSNO, PWT20, JBTP101, FTPT, INECAC05, JOBTYP, SEX)
head(mydata1)

### Examine variables.

frq(mydata1$JBTP101)
frq(mydata1$FTPT)
frq(mydata1$INECAC05)
frq(mydata1$JOBTYP)
frq(mydata1$SEX)


### REVIEW QUESTIONS
### How many cases are there?
### What does the variable inecac05 relate to?
### Why are there many missing cases on the variables: jbtp101, ftpt and jobtyp.
###[nb: missing values changed from -9 to -8 to NA, so hard to tell from frequencies]

### Apply the weight and examine the variable frequencies again.

frq(mydata1$JBTP101, weights = mydata1$PWT20)
frq(mydata1$FTPT, weights = mydata1$PWT20)
frq(mydata1$INECAC05, weights = mydata1$PWT20)
frq(mydata1$JOBTYP, weights = mydata1$PWT20)
frq(mydata1$SEX, weights = mydata1$PWT20)


### REVIEW QUESTIONS
### Do the frequencies change noticeably when the weight is applied?


### Run this code to adjust the category order and labels.

mydata1$JobTmp <- rec(mydata1$JBTP101,rec="1=3;2=4;3=1;4=2;5=5;-8,-9=6")

mydata1$JobTmp <-sjlabelled::set_labels(mydata1$JobTmp,
                                       labels = c( "Seasonal work", 
                                                   "Done under contract for a fixed period",                           
                                                   "Agency Temping", 
                                                   "Casual type of work", 
                                                   "Some other reason"))


###Create filter to select those with a weight greater than 0. 
mydata1 <- filter (mydata1, PWT20>0)

### Create a variable to indicate those working part time.

mydata1$PartTime <- rec(mydata1$FTPT,rec="2,4=1; else=0")

mydata1$PartTime <-sjlabelled::set_labels(mydata1$PartTime,
                                         labels = c("Part Time"))

### REVIEW QUESTIONS
### When making the table below, which cases are selected in the filter?

head(mydata1$JOBTYP)
head(mydata1$INECAC05)


### Create the table.
#[the labels are missed doe JobTmp, crossreference with above]
#for all
mydata1 %>% 
  filter(JOBTYP==2 & INECAC05==1) %>% 
  uncount(weights = .$PWT20) %>%  
  tab(JobTmp, PartTime)

#split by sex and part-time 


mydata1 %>% 
  filter(JOBTYP==2 & INECAC05==1 & SEX==1) %>% 
  uncount(weights = .$PWT20) %>%  
  tab(PartTime, JobTmp)

mydata1 %>% 
  filter(JOBTYP==2 & INECAC05==1 & SEX==2) %>% 
  uncount(weights = .$PWT20) %>%  
  tab(PartTime, JobTmp)


### REVIEW QUESTIONS
### How many people are temporary employees (all and part-time) in this quarter?
### How many females are in part-time temporary employment? 
### Note - you can check if your results match those in the ONS EMP07 dataset
### (<https://www.ons.gov.uk/employmentandlabourmarket/peopleinwork/employmentandemployeetypes/datasets/temporaryemployeesemp07>)


### Weight off and rerun table to get unweighted frequencies.

mydata1 %>% 
  filter(JOBTYP==2 & INECAC05==1)  %>%  
  tab(JobTmp, PartTime)


### REVIEW QUESTIONS
### How many applicable cases to we have for the above analysis?
