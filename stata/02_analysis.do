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
mlogit ideal $IVs [pw=weight] , b(1) rrr

margins, by(female) // Predicted Probabilities

* WFA4 plot
marginsplot, by(female) recast(bar) plotopts(barw(.8)) horizontal yscale(reverse) ///
ylab(1 "Self-reliance" 2 "Provider" 3 "Homemaker" 4 "Sharing") ///
ytitle("") xtitle("") byopt(title ("Four Work-family arrangements")) name(WFA4, replace)
 
margins, dydx(*) // AME

margins, dydx(female) // AME
marginsplot, recast(bar) plotopts(barw(.8)) ///
xlab(1 "Self-reliance" 2 "Provider" 3 "Homemaker" 4 "Sharing")


* Sub-sample of sharing people
mlogit share3 $IVs [pw=weight] , b(3) rrr

margins, by(female) // Predicted Probabilities
marginsplot, by(female) recast(bar) plotopts(barw(.8))
// sends wrong message -- looks like equal sharing really popular

********************************************************************************
* All 6 categories at the same time
********************************************************************************
mlogit ideal6 $IVs [pw=weight] , b(6) rrr

margins, by(female) // Predicted Probabilities

* combine with WFA4 plot for 1 figure
marginsplot, by(female) recast(bar) ///
	plotopts(barw(.8)) horizontal yscale(reverse) ///
	ylab(1 "Self-reliance" 2 "Provider" 3 "Homemaker" ///
	4 "Specialized" 5 "Flexible" 6 "Equally")  xsc(r(0 .6)) ///
	ytitle("") xtitle("") byopt(title ("Six Work-family arrangements")) name(WFA6, replace)
	
* Figure 1
grc1leg WFA4 WFA6, col(1) iscale(1) name(fig1, replace)
graph export $results/fig1.png, width(650) height(600) replace                  // FIGURE 1


* Figure with gender essentialism
mlogit ideal6 $IVs [pw=weight] , b(1) rrr // same mlogit as before

margins, at(attitudes = (1(1)5)) predict(outcome(1))
marginsplot, ytitle("") xtitle("") title("Self-reliance") name(SelfReliance, replace) 
margins, at(attitudes = (1(1)5)) predict(outcome(2))
marginsplot, ytitle("") xtitle("") title("Provider") name(Provider, replace) 
margins, at(attitudes = (1(1)5)) predict(outcome(3))
marginsplot, ytitle("") xtitle("") title("Homemaker") name(Homemaker, replace) 
margins, at(attitudes = (1(1)5)) predict(outcome(4))
marginsplot, ytitle("") xtitle("") title("Specialized") name(Specialized, replace) 
margins, at(attitudes = (1(1)5)) predict(outcome(5))
marginsplot, ytitle("") title("Flexible") name(Flexible, replace) 
margins, at(attitudes = (1(1)5)) predict(outcome(6))
marginsplot, ytitle("") xtitle("") title("Equally") name(Equally, replace) 
graph combine SelfReliance Provider Homemaker ///
	Specialized Flexible Equally, ycommon     ///
	title("Predicted probability") ///
	subtitle("by gender essentialism") ///
	name(fig2, replace)                                                         // FIGURE 2
	
graph export $results/fig2.png, width(600) height(600) replace


* Figure with gender essentialism - by gender
mlogit ideal6 $IVs [pw=weight] , b(1) rrr // same mlogit as before

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

* AME by gender and attitudes
margins, at(attitudes = (1(1)5))  dydx(female) predict(outcome(1)) 
marginsplot, recast(bar) plotopts(barw(.8)) ///
ytitle("") xtitle("") title("Self-reliance") name(SelfReliance_AME, replace) 

margins, at(attitudes = (1(1)5))  dydx(female) predict(outcome(2)) 
marginsplot, recast(bar) plotopts(barw(.8)) ///
ytitle("") xtitle("") title("Provider") name(Provider_AME, replace) 

margins, at(attitudes = (1(1)5))  dydx(female) predict(outcome(3)) 
marginsplot, recast(bar) plotopts(barw(.8)) ///
ytitle("") xtitle("") title("Homemaker") name(Homemaker_AME, replace) 

margins, at(attitudes = (1(1)5))  dydx(female) predict(outcome(4)) 
marginsplot, recast(bar) plotopts(barw(.8)) ///
ytitle("") xtitle("") title("Specialized") name(Specialized_AME, replace) 

margins, at(attitudes = (1(1)5))  dydx(female) predict(outcome(5)) 
marginsplot, recast(bar) plotopts(barw(.8)) ///
ytitle("") title("Flexible") name(Flexible_AME, replace) 

margins, at(attitudes = (1(1)5))  dydx(female) predict(outcome(6)) 
marginsplot, recast(bar) plotopts(barw(.8)) ///
ytitle("") xtitle("") title("Equally") name(Equally_AME, replace) 

graph combine SelfReliance_AME Provider_AME Homemaker_AME ///
	Specialized_AME Flexible_AME Equally_AME, ycommon     ///
	title("Average Marginal Effects")  ///
	subtitle("by gender and gender essentialism") name(fig3, replace)

graph export $results/fig3.png, width(600) height(600) replace                  // Figure 3
