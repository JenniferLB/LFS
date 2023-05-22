*LFS WORKSHOP PRACTICAL SESSION
*Exercise 3: Examining Labour Market Flows using the Labour Force Survey Two-Quarter Longitudinal Dataset.

*Notes
*This exercise is based on data for July - December, 2020, which is available from the UK Data Service: SN: 8778, http://doi.org/10.5255/UKDA-SN-8778-1
*The exercise uses three different methods of examining labour market flows using the Two-Quarter Longitudinal Dataset. 
*The estimates relate to figures published by ONS on the `Labour market flows NSA' sheet in dataset X02:
//www.ons.gov.uk/employmentandlabourmarket/peopleinwork/employmentandemployeetypes/datasets/labourforcesurveyflowsestimatesx02
// clear memory
clear all

*Set the directory, open the data and keep the necessary variables. 
cd "P:\desktop"


use "UKDA-8778-stata\stata\stata13\lgwt20_2q_js20_od20_eul.dta"



keep AGES2 AGE2 LGWT20 EMPLEN1 EMPLEN2 flow SEX ILODEFR1 ILODEFR2 INCAC051 INCAC052 SC10MMJ1 SC10MMJ2 In792sm2 In792sm1
save "lfs_od20_practical3_temp", replace


*Examine the variables. 
tab1 AGES2 AGE2 EMPLEN1 EMPLEN2 flow SEX ILODEFR1 ILODEFR2 ///
	 INCAC051 INCAC052 SC10MMJ1 SC10MMJ2 In792sm2 In792sm1

***********************************************************************************************
*REVIEW QUESTIONS 1
// What is the variable flow?  
// Why do some variables have a suffix of 1 or 2? 
***********************************************************************************************

*Method 1 - use the variable flow to examine labour market flows. 

*Filter for those aged 16-64. 
keep if AGE2>15 & AGE2 < 65

* Examine the variables flow.
table flow [fw=LGWT20], nformat (%20.0f)

***********************************************************************************************
*REVIEW QUESTIONS  2
* How many were in employment at first quarter and in employment at final quarter? 
* Note: These results are the not seasonally adjusted estimates (people aged 16-64, UK (thousands)) 

***********************************************************************************************

*Method 2: use a filter to select a group and the frequency table for flow. 

table flow [fw=LGWT20] if ILODEFR1==1  & EMPLEN2==1

***********************************************************************************************
*REVIEW QUESTIONS 3
* What has been estimated with the filter and table above? 
// Note: examine the two variables used in the filter to understand the selection.
table ILODEFR1 [fw=LGWT20]
table EMPLEN2 [fw=LGWT20]
***********************************************************************************************

*Method 3: Examine change using a crosstabulation of equivalent variables at time point 1 and time point 2. .
*Employee and self-employment flows. 

*Filter by age (repeat code if necessary).
keep if AGE2>15 & AGE2 < 65

*Create a simpliefed economic activity variable (with employee+ and one inactive group) for time point 1. 
recode INCAC051   ///
  (1 3 4=1 "Employee +")  (2=2 "Self-Employed") (5=3 "Unemployed") /// 
  (6/34 = 4 "Inactive") (-9/-8=99 "NA/DNA"), gen(eco1)
label variable eco1 "eco1"

*Create an equivalnt variable for time point 2. 
recode INCAC052 ///
  (1 3 4=1 "Employee +")  (2=2 "Self-Employed") (5=3 "Unemployed") /// 
  (6/34 = 4 "Inactive") (-9/-8=99 "NA/DNA"), gen(eco2)
label variable eco2 "eco2"

* Examine change in status using a crosstabulation of economic activity at time 1 and time 2.
table (eco1) (eco2) [fw=LGWT20], nformat (%20.0f)

***********************************************************************************************
*REVIEW QUESTIONS 4
* What was the flow between 1) employee and self-employed and 2) self-employed to employee? 
***********************************************************************************************

*What next? 
*This is the final structured exercise. Some ideas for what to do next are:
*Use the methods above to examine flows between industry or occupation (SC10MMJ1 SC10MMJ2 in792sm2 in792sm1). 
* Open the full dataset to examine what variables in the  Two-Quarter Longitudinal Dataset.

