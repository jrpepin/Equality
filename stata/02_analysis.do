*-------------------------------------------------------------------------------
* EQUALITY PROJECT
* 	prog: 	Inés Martínez Echagüe & Joanna Pepin
*	input:	egalitarian-dataset.dta
*	output:	none
*	title:	Measures & Sample
*-------------------------------------------------------------------------------

* SET SURVEY DESIGN ------------------------------------------------------------
svyset caseid [pweight=weight], vce(linearized) singleunit(missing)


********************************************************************************
* Table 01 
********************************************************************************

dtable i.ideal i.wfaNow i.married i.educat i.racecat i.incat age attitudes   ///
    if flag==1, svy by(female) column(by(hide))                              ///
nformat(%7.2f fvproportion mean sd)                                          ///
sample(, statistics(freq) place(seplabels)) sformat("(N=%s)" frequency)      ///
factor(ideal wfaNow married educat racecat incat ,                           ///
    statistics(fvproportion))                                                ///
title(Table 01. Descriptive statistics of the analytic sample)               ///
note(Source: YouGov original survey, 2018. Weighted proportions and means.   ///
S.D. in parentheses)                                                         ///
export($results/table1.html, replace)              

