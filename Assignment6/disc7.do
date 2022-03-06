clear all
set more off
cap log close


/**************************************************************************/ 
/* Practice with the Workers Compensation and Injury Data for Assignment 6*/
/**************************************************************************/


use INJURY.DTA, clear


* Caluculating the BA estimator
reg lprewage afchnge

*Work with Kentucky sample until last subpart of (h)
*See assignment instructions for more info about this

gen after_high=afchnge*highearn

preserve
keep if ky==1

*Remember, we need "before vs. after" and "treatment vs. control"
*'highearn' is "treament vs. control" indicator variable, 
*since low earners did not get any actual benefit from the raising of
*the cap/maximum of the workers' compensation payments,
*while 'afchnge' is "after vs. before" indicator variable.

reg ldurat afchnge highearn after_high



*can 'restore' and then do more work with Michigan data



/************************************************************************/ 
/* More on the famous Card and Krueger Minimum Wage study data */
/************************************************************************/


**** Effect of Min-Wage increase in NJ using PA as control
*NJ increased min wage from 4.25 to 5.05; PA remained at 4.25

*https://davidcard.berkeley.edu/papers/njmin-aer.pdf


use CK94.dta, clear

gen post = 0
replace post = 1 if wave==2

gen treat = 0
replace treat = 1 if state == 1

gen post_treat = post*treat

bys treat post: summ wage_st


reg wage_st post if treat==1
reg wage_st post if treat==0

reg wage_st treat if post==0
reg wage_st treat if post==1

reg wage_st treat post post_treat

*Create employment measure by summing number of full time employees 
* and (0.5)*number of parttime employee
gen FTE = empft + 0.5*emppt
bys state post: summ FTE

reg FTE post treat post_treat, robust
reg FTE post treat post_treat, cluster(sheet)

tab chain, gen(chain_)
*chain_3 is Roy Rogers, a fast-food restaurant company whose locations were
*centered in the Eastern United States, but which is now nearly defunct


reg FTE post treat post_treat co_owned chain_1 chain_2 chain_4, cluster(sheet)






