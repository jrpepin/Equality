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
* Table 02
********************************************************************************
// later - change tables to AMEs

global IVs "i.female i.wfaNow i.married i.parent i.educat i.racecat i.incat age attitudes"


* Original 4 categories
mlogit ideal $IVs [pw=weight] , b(4) rrr

margins, by(female) // Predicted Probabilities

* Figure 1?
marginsplot, by(female) recast(bar) plotopts(barw(.8)) horizontal yscale(reverse) ///
ylab(1 "Self-reliance" 2 "Provider" 3 "Homemaker" 4 "Sharing")

margins, dydx(*) // AME

margins, dydx(female) // AME
marginsplot, recast(bar) plotopts(barw(.8)) ///
xlab(1 "Self-reliance" 2 "Provider" 3 "Homemaker" 4 "Sharing")


* Sub-sample of sharing people
mlogit share3 $IVs [pw=weight] , b(3) rrr

margins, by(female) // Predicted Probabilities
marginsplot, by(female) recast(bar) plotopts(barw(.8))
// sends wrong message -- looks like equal sharing really popular

* All 6 categories at the same time
mlogit ideal6 $IVs [pw=weight] , b(6) rrr

margins, by(female) // Predicted Probabilities

* Figure 2? maybe combine with plot 1 for 1 figure?
marginsplot, by(female) recast(bar) ///
	plotopts(barw(.8)) horizontal yscale(reverse) ///
	ylab(1 "Self-reliance" 2 "Provider" 3 "Homemaker" ///
	4 "Specialized" 5 "Flexible" 6 "Equally")

* Figure 2/3
mlogit ideal6 $IVs [pw=weight] , b(6) rrr // same mlogit as before

margins, at(attitudes = (1(1)5)) predict(outcome(1))
marginsplot, ytitle("") title("Self-reliance") name(SelfReliance, replace) 
margins, at(attitudes = (1(1)5)) predict(outcome(2))
marginsplot, ytitle("") title("Provider") name(Provider, replace) 
margins, at(attitudes = (1(1)5)) predict(outcome(3))
marginsplot, ytitle("") title("Homemaker") name(Homemaker, replace) 
margins, at(attitudes = (1(1)5)) predict(outcome(4))
marginsplot, ytitle("") title("Specialized") name(Specialized, replace) 
margins, at(attitudes = (1(1)5)) predict(outcome(5))
marginsplot, ytitle("") title("Flexible") name(Flexible, replace) 
margins, at(attitudes = (1(1)5)) predict(outcome(6))
marginsplot, ytitle("") title("Equally") name(Equally, replace) 
graph combine SelfReliance Provider Homemaker ///
	Specialized Flexible Equally, ycommon name(fig3, replace)

* Figure 2/3
mlogit ideal6 $IVs [pw=weight] , b(6) rrr // same mlogit as before

margins female, at(attitudes = (1(1)5)) predict(outcome(1))
marginsplot, ytitle("") xtitle("") title("Self-reliance") name(SelfReliance, replace) 
margins female, at(attitudes = (1(1)5)) predict(outcome(2))
marginsplot, ytitle("") xtitle("") title("Provider") name(Provider, replace) 
margins female, at(attitudes = (1(1)5)) predict(outcome(3))
marginsplot, ytitle("") xtitle("") title("Homemaker") name(Homemaker, replace) 
margins female, at(attitudes = (1(1)5)) predict(outcome(4))
marginsplot, ytitle("") title("Specialized") name(Specialized, replace) 
margins female, at(attitudes = (1(1)5)) predict(outcome(5))
marginsplot, ytitle("") title("Flexible") name(Flexible, replace) 
margins female, at(attitudes = (1(1)5)) predict(outcome(6))
marginsplot, ytitle("") title("Equally") name(Equally, replace) 
grc1leg SelfReliance Provider Homemaker ///
	Specialized Flexible Equally, ycommon name(fig3, replace)

