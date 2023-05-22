* Encoding: UTF-8.

*LFS WORKSHOP PRACTICAL SESSION
*Exercise 3: Examining Labour Market Flows using the Labour Force Survey Two-Quarter Longitudinal Dataset.

*Notes
*This exercise is based on data for July - December, 2020, which is available from the UK Data Service: SN: 8778, http://doi.org/10.5255/UKDA-SN-8778-1
*The exercise uses three different methods of examining labour market flows using the Two-Quarter Longitudinal Dataset. 
*The estimates relate to figures published by ONS on the ‘Labour market flows NSA’ sheet in dataset X02:
https://www.ons.gov.uk/employmentandlabourmarket/peopleinwork/employmentandemployeetypes/datasets/labourforcesurveyflowsestimatesx02


*Set the directory, open the data and keep the necessary variables. 
*Edit as applicable depending on where you've saved your files
 
cd "paste in the pathway to your folder with the data in".
show DIRECTORY.
GET FILE = "UKDA-8778-spss\spss\spss25\lgwt20_2q_js20_od20_eul.sav". 

SAVE 
  OUTFILE='practical3temp.sav'
/KEEP= ages2 age2 emplen1 emplen2 flow sex ilodefr1 ilodefr2 INCAC051 INCAC052 SC10MMJ1 SC10MMJ2 in792sm2 in792sm1 lgwt20.

GET FILE = "practical3temp.sav". 

*Close the original dataset if still open 

*Examine the variables. 
Frequencies ages2 age2 emplen1 emplen2 flow sex ilodefr1 ilodefr2 INCAC051 INCAC052 SC10MMJ1 SC10MMJ2 in792sm2 in792sm1.

***********************************************************************************************
*REVIEW QUESTIONS 1
What is the variable flow?  
Why do some variables have a suffix of 1 or 2? 
***********************************************************************************************

*Method 1 - use the variable flow to examine labour market flows. 

*Filter for those aged 16-64. 
USE ALL.
COMPUTE filter_$=(RANGE(AGE2,16,64)).
VARIABLE LABEL filter_$ 'RANGE(AGE2,16,64) (FILTER)'.
VALUE LABELS filter_$  0 'Not Selected' 1 'Selected'.
FORMAT filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE .

*Weight by the longitudinal weight. 
WEIGHT  BY lgwt20.

* Examine the variables flow.
VARIABLE LEVEL FLOW (NOMINAL).
  FREQUENCIES
  VARIABLES=flow
  /ORDER=  ANALYSIS .
USE ALL.
EXECUTE .

***********************************************************************************************
*REVIEW QUESTIONS  2
* How many were in employment at first quarter and in employment at final quarter? 
Note: These results are the not seasonally adjusted estimates (people aged 16-64, UK (thousands)) 

***********************************************************************************************

*Method 2: use a filter to select a group and the frequency table for flow. 

USE ALL.
COMPUTE filter_$=(ilodefr1= 1  & EMPLEN2 = 1).
VARIABLE LABEL filter_$ 'ilodefr1  & EMPLEN2 = 1 (FILTER)'.
VALUE LABELS filter_$  0 'Not Selected' 1 'Selected'.
FORMAT filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE .


WEIGHT  BY lgwt20.
FREQUENCIES
  VARIABLES=flow
  /ORDER=  ANALYSIS .


***********************************************************************************************
*REVIEW QUESTIONS 3
* What has been estimated with the filter and table above? 
Note: examine the two variables used in the filter to understand the selection.
Frequencies ilodefr1 EMPLEN2. 
***********************************************************************************************

*Method 3: Examine change using a crosstabulation of equivalent variables at time point 1 and time point 2. .
*Employee and self-employment flows. 

*Filter by age.
USE ALL.
COMPUTE filter_$=(RANGE(AGE2,16,64)).
VARIABLE LABEL filter_$ 'RANGE(AGE2,16,64) (FILTER)'.
VALUE LABELS filter_$  0 'Not Selected' 1 'Selected'.
FORMAT filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE .

WEIGHT  BY lgwt20.

*Create a simpliefed economic activity variable (with employee+ and one inactive group) for time point 1. 
RECODE
  INCAC051
  (1=1)  (2=2)  (3=1)  (4=1) (5=3) (6 thru 33 = 4) (-9 thru -8=99)   INTO  eco1 .
VARIABLE LABELS eco1 'eco1'.
VARIABLE LEVEL eco1 (NOMINAL).

VALUE LABELS eco1 
1 'Employee +' 
2 'Self-Employed'
3 'Unemployed'
4 'Inactive'
99 'NA/DNA'.
EXECUTE .

*Create an equivalnt variable for time point 2. 
RECODE
  INCAC052
  (1=1)  (2=2)  (3=1)  (4=1) (5=3) (6 thru 33 = 4) (-9 thru -8=99)   INTO  eco2 .
VARIABLE LABELS eco2 'eco2'.
VARIABLE LEVEL eco2 (NOMINAL).

VALUE LABELS eco2 
1 'Employee +' 
2 'Self-Employed'
3 'Unemployed'
4 'Inactive'
99 'NA/DNA'.
EXECUTE .

* Examine change in status using a crosstabulation of economic activity at time 1 and time 2. 
CTABLES
  /VLABELS VARIABLES=eco2 eco1 DISPLAY=DEFAULT
  /TABLE eco1 [COUNT F40.0] BY eco2
  /CATEGORIES VARIABLES=eco2 eco1 ORDER=A KEY=VALUE EMPTY=INCLUDE MISSING=EXCLUDE.

*************************************************************************************************
Alternative for those without the CTables add on:

CROSSTABS
  /TABLES=eco1 BY eco2
  /FORMAT=AVALUE TABLES
  /CELLS=COUNT
  /COUNT ROUND CELL.

***************************************************************************************************

***********************************************************************************************
*REVIEW QUESTIONS 4
* What was the flow between 1) employee and self-employed and 2) self-employed to employee? 
***********************************************************************************************

*What next? 
This is the final structured exercise. Some ideas for what to do next are:
*Use the methods above to examine flows between industry or occupation (SC10MMJ1 SC10MMJ2 in792sm2 in792sm1). 
* Open the full dataset to examine what variables in the  Two-Quarter Longitudinal Dataset.
GET FILE = "lgwt20_2q_js20_od20_eul.sav".


