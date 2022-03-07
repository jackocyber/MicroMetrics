clear all
set more off
cap log close


/************************************************************************************/ 
/* Ogle in collaboration with Jack Knickrehm, Matt Lohrs, and Eva Haque Assignment 6*/
/************************************************************************************/


use INJURY.DTA, clear


*Work with Kentucky sample until last subpart of (h)
*See assignment instructions for more info about this

* generating dummy for treatment group
gen after_high=afchnge*highearn

* generating dummy for lowearn
generate lowearn = (highearn < 1) 

* generating dummy for control group
gen after_low = afchnge*lowearn 

preserve
keep if ky==1

*Remember, we need "before vs. after" and "treatment vs. control"
*'highearn' is "treament vs. control" indicator variable, 
*since low earners did not get any actual benefit from the raising of
*the cap/maximum of the workers' compensation payments,
*while 'afchnge' is "after vs. before" indicator variable.

*a. BA Model Treatment
reg ldurat after_high
outreg2 using reg-results-a.doc, replace

*b. BA Model Control
reg ldurat after_low
outreg2 using reg-results-b.doc, replace

*c. CS estimator of the difference in outcomes between the treatment and control befor
reg ldurat afchnge highearn after_high 
outreg2 using reg-results-c.doc, replace

*f Wooldridge 13.4 adding in explanatory vars male and married 
reg ldurat afchnge highearn after_high male married 
outreg2 using reg-results-d.doc, replace

*g Wooldridge 13.7
reg ldurat highearn after_high
outreg2 using reg-results-g.doc, replace


restore
keep if mi ==1


*Remember, we need "before vs. after" and "treatment vs. control"
*'highearn' is "treament vs. control" indicator variable, 
*since low earners did not get any actual benefit from the raising of
*the cap/maximum of the workers' compensation payments,
*while 'afchnge' is "after vs. before" indicator variable.

*a. BA Model Treatment
reg ldurat after_high
outreg2 using reg-results-a.doc, replace

*b. BA Model Control
reg ldurat after_low
outreg2 using reg-results-b.doc, replace

*c. CS estimator of the difference in outcomes between the treatment and control befor
reg ldurat afchnge highearn after_high 
outreg2 using reg-results-c.doc, replace

*f Wooldridge 13.4 adding in explanatory vars male and married 
reg ldurat afchnge highearn after_high male married 
outreg2 using reg-results-d.doc, replace

*g Wooldridge 13.7
reg ldurat highearn after_high
outreg2 using reg-results-g.doc, replace
*can 'restore' and then do more work with Michigan data

* Problem #2

*a
use CPS78_85.DTA, clear

reg lwage y85 educ y85educ exper expersq union female y85fem
outreg2 using reg-results-2-a.doc, replace

*b
*ii
gen y85_conf = y85*(educ-12)

reg lwage y85 educ y85_conf exper expersq union female y85fem
outreg2 using reg-results-2-b-ii.doc, replace

*iii
gen lrwage = lwage/1.65

reg lrwage y85 educ y85educ exper expersq union female y85fem
outreg2 using reg-results-2-b-iii.doc, replace

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






