*LFS WORKSHOP PRACTICAL SESSION
*Exercise 2: The distribution of weekly earnings of full-time employees

*This exercise recreates ONS labour market analysis reported in the table EARN04: Gross weekly earnings of full-time employees
*https://www.ons.gov.uk/employmentandlabourmarket/peopleinwork/earningsandworkinghours/datasets/grossweeklyearningsoffulltimeemployeesearn04 
*This table is updated four times a year in February, May, August and November using the Quarterly Labour Force Survey. 
*Data: Quarterly Labour Force Survey, October - December, 2020, which is accessible from the UK Data Servic (http://doi.org/10.5255/UKDA-SN-8777-3)

*Open data, keeping only the necessary variables (to use the set data command you may need to set the directory e.g. cd "XXXX\LFS workshop\UKDA-8777-spss\spss\spss25".

clear all

// Set directory. - you need to add the correct file path for your computer, where is the data saved?.

cd "P:\desktop"
use "UKDA-8777-stata\stata\stata13\lfsp_od20_eul_pwt20.dta"
save "lfs_od20_practical2_temp", replace


// Apply the weight
svyset [pw=PIWT20]

// Create and apply a filter to select those with a weight greater than 0,				
// those in fulltime employment ****with valid income values*****
// Replace the three asterixs (*) with relevant values to complete the syntax below. 
keep if PIWT20>0 & HOURPAY>=0 & HOURPAY<=100 & INECAC05==1 & (FTPT==1 | FTPT==3)

// Note - you can use the code below to check values and value labels for variables.
codebook INECAC05 FTPT


***********************************************************************************************
// REVIEW QUESTIONS 2
// what were the correct values to complete the code?

***********************************************************************************************
* Custom Tables
// set GRSSWK value -9 and -8 to stata missing value
recode GRSSWK (-9 = .a) (-8 = .b)
		
table SEX, statistic(mean GRSSWK)  statistic(median GRSSWK) ///
			statistic(p10 GRSSWK) statistic(q1 GRSSWK) ///
			statistic(q3 GRSSWK) statistic(p90 GRSSWK) nformat(%9.0fc) 

	
***********************************************************************************************
*REVIEW QUESTIONS 3
*what are median weekly earnings?
*what are earnings at the lowest decile for males and females? 
***********************************************************************************************
* Get a frequency table of sex to examine the gender breakdown of fulltime employees. 
table SEX
table SEX[fw=PIWT20], nformat (%20.0f)
***********************************************************************************************
*REVIEW QUESTIONS 4
*The ONS table associated with this report gives the estimated number of fulltime employees as 21,215,000. 
*Using the frequency above, we get 213, 138, 049. Why is there a difference? What steps above need to be different to get the correct estimate of the number of fulltime employees?
***********************************************************************************************

*WHAT NEXT?
*Move to the final exercise, which uses one of the longitundial datasets
* Or see if you can examine earnings for temporary workers or another sub-group of interest
*Reopen the full datafile and using GET FILE ="lfsp_od20_eul_pwt20.sav". and explore as you choose 

