*-------------------------------------------------------------------------------
* EQUALITY PROJECT
* 	prog: 	Inés Martínez Echagüe & Joanna Pepin
*	input:	egalitarian-dataset.dta (processed)
*	output:	none
*	title:	Measures & Sample
*-------------------------------------------------------------------------------

// This file uses the processed data from 01_measures_and_sample.do

* SET SURVEY DESIGN ------------------------------------------------------------
svyset caseid [pweight=weight], vce(linearized) singleunit(missing)


********************************************************************************
* Table 01 
********************************************************************************
global catvars "i.ideal i.wfaNow i.married i.parent i.educat i.racecat i.incat" 
global numvars "age attitudes" 


dtable  $catvars $numvars                                                    ///
    if flag==1, svy by(female) column(by(hide))                              ///
nformat(%7.2f fvproportion mean sd)                                          ///
sample(, statistics(freq) place(seplabels)) sformat("(N=%s)" frequency)      ///
factor($catvars, statistics(fvproportion))                                   ///
title(Table 01. Descriptive statistics of the analytic sample)               ///
note(Source: YouGov original survey, 2018. Weighted proportions and means.   ///
S.D. in parentheses)                                                         ///
export($results/table1.html, replace)              

********************************************************************************
* Table 012
********************************************************************************
// later - change to AME

global IVs "i.female i.wfaNow i.married i.parent i.educat i.racecat i.incat age attitudes"


* Original 4 categories
mlogit ideal $IVs [pw=weight] , b(4) rrr

margins, by(female) // Predicted Probabilities
marginsplot, by(female) recast(bar) plotopts(barw(.8))

margins, dydx(*) // AME

margins, dydx(female) // AME
marginsplot, recast(bar) plotopts(barw(.8)) ///
xlab(1 "Self-reliance" 2 "Provider" 3 "Homemaker" 4 "Sharing")


* Sub-sample of sharing people
mlogit share3 $IVs [pw=weight] , b(3) rrr

margins, by(female) // Predicted Probabilities
marginsplot, by(female) recast(bar) plotopts(barw(.8))



* All 6 categories at the same time
mlogit ideal6 $IVs [pw=weight] , b(6) rrr

margins, by(female) // Predicted Probabilities
marginsplot, by(female) recast(bar) plotopts(barw(.8))



