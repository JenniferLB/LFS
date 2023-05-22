* Encoding: UTF-8.

*LFS WORKSHOP PRACTICAL SESSION

**********************************************************
*Exercise 1: estimates of temporary employment
*This exercise recreates ONS labour market analysis reported in the table EMP07 Temporary Employees
*https://www.ons.gov.uk/employmentandlabourmarket/peopleinwork/employmentandemployeetypes/datasets/temporaryemployeesemp07. [last accessed 05/01/2022]
This table is updated four times a year in February, May, August and November using the Quarterly Labour Force Survey. 
*The data used relates to an estimate for Oct-December 2020.
*Data: Quarterly Labour Force Survey, October - December, 2020, accessible from the UK Data Service 


**START HERE
*Open the data  (lfsp_od20_eul_pwt20.sav) and save a copy to work with e.g.(lfsp_od20_eul_pwt20_Practical1.sav). 

***********************************************************************************************
*REVIEW QUESTIONS 
*How many variables are there?
***********************************************************************************************
*Examine variables. 
FREQUENCIES jbtp101 ftpt inecac05 jobtyp sex.

***********************************************************************************************
*REVIEW QUESTIONS 
*How many cases are there?
*What does the variable inecac05 relate to?
*Why are there many missing cases on the variables: jbtp101, ftpt and jobtyp. 
***********************************************************************************************
*Apply the weight and examine the variable frequencies again. 
weight by PWT20.
FREQUENCIES jbtp101 ftpt inecac05 jobtyp sex.

***********************************************************************************************
*REVIEW QUESTIONS 
*Do the frequencies change noticeably when the weight is applied? 
*********************************************************************************************** 
*run this code to adjust the category order and labels. 
recode  jbtp101 (3=1) (4=2) (1=3) (2=4) (5=5) (-8,-9=6) into JobTmp.
value labels JobTmp
1 'Seasonal work'
2 'Done under contract for a fixed period'
3 'Agency Temping'
4 'Casual type of work'
5 'Some other reason'
6 'Missing -8 & -9'.

*Create and apply a filter to select those with a weight greater than 0. 
USE ALL.
COMPUTE filter_$=(PWT20>0).
VARIABLE LABELS filter_$ 'PWT20>0 (FILTER)'.
VALUE LABELS filter_$  0 'Not Selected' 1 'Selected'.
FORMAT filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE .

*Create a variable to indicate those working part time.
recode ftpt (2,4=1) Into PartTime.
value labels PartTime
1 'Part Time'.

*Select relevant cases. 
select if (jobtyp=2) and (inecac05=1).
execute.

***********************************************************************************************
*REVIEW QUESTIONS 
Which cases are selected using the above code? - if not sure, use the command below to check:

Frequencies jobtyp inecac05.

***********************************************************************************************.

*Create the table.
CTABLES
  /VLABELS VARIABLES=JobTmp PartTime sex DISPLAY=DEFAULT
  /TABLE sex BY JobTmp [C][COUNT F40.0] + JobTmp [C] > PartTime [C][COUNT F40.0]
  /CATEGORIES VARIABLES=JobTmp [6, 1, 2, 3, 4, 5, OTHERNM] EMPTY=INCLUDE TOTAL=YES POSITION=AFTER
  /CATEGORIES VARIABLES=PartTime ORDER=A KEY=VALUE EMPTY=INCLUDE
  /CATEGORIES VARIABLES=sex ORDER=A KEY=VALUE EMPTY=INCLUDE TOTAL=YES POSITION=AFTER MISSING=INCLUDE.

***********************************************************************************************
*REVIEW QUESTIONS  
*How many people are temporary employees (all and part-time) in this quarter?  
*How many females are in part-time temporary employment? 
Note - you can check if your results match those in the ONS EMP07 dataset 
(https://www.ons.gov.uk/employmentandlabourmarket/peopleinwork/employmentandemployeetypes/datasets/temporaryemployeesemp07)
***********************************************************************************************

*Weight off and rerun table to get unweighted frequencies. 
Weight Off.

CTABLES
  /VLABELS VARIABLES=JobTmp PartTime sex DISPLAY=DEFAULT
  /TABLE sex BY JobTmp [C][COUNT F40.0] + JobTmp [C] > PartTime [C][COUNT F40.0]
  /CATEGORIES VARIABLES=JobTmp [6, 1, 2, 3, 4, 5, OTHERNM] EMPTY=INCLUDE TOTAL=YES POSITION=AFTER
  /CATEGORIES VARIABLES=PartTime ORDER=A KEY=VALUE EMPTY=INCLUDE
  /CATEGORIES VARIABLES=sex ORDER=A KEY=VALUE EMPTY=INCLUDE TOTAL=YES POSITION=AFTER MISSING=INCLUDE.
***********************************************************************************************
*REVIEW QUESTIONS  
*How many applicable cases do we have for the above analysis?   
***********************************************************************************************



