# LFS WORKSHOP PRACTICAL SESSION
## Exercise 2: The distribution of weekly earnings of full-time employees

### This exercise recreates ONS labour market analysis reported in the table EARN04: Gross weekly earnings of full-time employees 
### <https://www.ons.gov.uk/employmentandlabourmarket/peopleinwork/earningsandworkinghours/datasets/grossweeklyearningsoffulltimeemployeesearn04> [last accessed 24/04/2021] 
### This table is updated four times a year in February, May, August and November using the Quarterly Labour Force Survey.
### Data: Quarterly Labour Force Survey, October - December, 2020, which is accessible from the UK Data Service (<http://doi.org/10.5255/UKDA-SN-8777-3>)
library(dplyr)
library(tidyr)
library(sjmisc)
library(tidytab)
library(srvyr)

# use if needed: setwd("~/LFS Workshop")

lfs_od20 <- haven::read_sav("UKDA-8777-spss/spss/spss25/lfsp_od20_eul_PWT20.sav")

mydata2 <- lfs_od20 %>% 
  select(PERSNO, PWT20, PIWT20, GRSSWK, INECAC05, FTPT, HOURPAY, SEX)


### REVIEW QUESTIONS 1
### Why do we use a different weight from exercise 1?

  
### Select only those in fulltime employment with valid income values
##replace the * with the correct values. 
  
md <- filter(mydata2, (PIWT20>0) & (HOURPAY>=0 & HOURPAY<=100)  & (FTPT==* | FTPT==*) & (INECAC05==*) & is.na(GRSSWK)==FALSE)


### REVIEW QUESTIONS 2
### What were the correct values to complete the code?
### Note - you can use the code below to check values and value labels for variables.
head(mydata2$INECAC05)
head(mydata2$FTPT)

###create the results
md %>% 
  uncount(weights = .$PIWT20) %>% 
    summarise(Median=median(GRSSWK))

md %>% 
  uncount(weights = .$PIWT20) %>% 
  group_by(SEX) %>% 
  summarise(Mean=mean(GRSSWK))

md %>% 
  uncount(weights = .$PIWT20) %>% 
  group_by(SEX) %>% 
  summarise(Median=median(GRSSWK))

LFS_design <- md %>% 
  as_survey_design(weights = PIWT20)

LFS_design %>% 
  group_by(SEX) %>% 
  srvyr::summarise(survey_old_quantile(GRSSWK, c(.1,.25,.5,.75,.9)))

## NOTE: Note that the behavior of the quantile functions has changed in srvyr version 1.1, but the old functions are still (currently) supported as survey_old_quantile and survey_old_median if you need to replicate the old results (as seen here). 
## For more details about what has changed, see Thomas Lumley's blog post on the changes, available here: <https://notstatschat.rbind.io/2021/07/20/what-s-new-in-the-survey-package/>
## An example of the quantile function can be found on CRAN: <https://rdrr.io/cran/srvyr/man/survey_quantile.html>


## REVIEW QUESTIONS 3 
### What are median weekly earnings?
### What are earnings at the lowest decile for males and females?

### Get a frequency table of sex to examine the gender breakdown of full-time employees. 

LFS_design %>% 
  group_by(SEX) %>% 
  summarise(survey_prop())


## REVIEW QUESTIONS 4
### The ONS table associated with this report gives the estimated number of full-time employees as 21,215,000

LFS_design %>% 
  summarise(survey_total())

### Using the frequency above, we get 21,138,049
### Why is there a difference?
### What steps above need to be different to get the correct estimate of the number of full-time employees?
  

### WHAT NEXT? Move to the final exercise, which uses one of the longitudinal data sets 
### or see if you can examine earnings for temporary workers or another sub-group of interest 
### Reopen the full datafile and explore as you choose.
