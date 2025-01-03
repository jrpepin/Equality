* Figure by educat
mlogit ideal6 $IVs [pw=weight] , b(1) rrr // same mlogit as before

margins, by(educat) // Predicted Probabilities

* combine with WFA4 plot for 1 figure
marginsplot, by(educat) recast(bar) ///
	plotopts(barw(.8)) horizontal yscale(reverse) ///
	ylab(1 "Self-reliance" 2 "Provider" 3 "Homemaker" ///
	4 "Specialized" 5 "Flexible" 6 "Equally")  xsc(r(0 .6)) ///
	ytitle("") xtitle("") byopt(title ("Six Work-family arrangements")) name(WFA6, replace)


* Figure with gender essentialism - by educat
margins educat, at(attitudes = (1(1)5)) predict(outcome(1))
marginsplot, ytitle("") xtitle("") title("Self-reliance") name(SelfReliance, replace) 
margins educat, at(attitudes = (1(1)5)) predict(outcome(2))
marginsplot, ytitle("") xtitle("") title("Provider") name(Provider, replace) 
margins educat, at(attitudes = (1(1)5)) predict(outcome(3))
marginsplot, ytitle("") xtitle("") title("Homemaker") name(Homemaker, replace) 
margins educat, at(attitudes = (1(1)5)) predict(outcome(4))
marginsplot, ytitle("") title("Specialized") name(Specialized, replace) 
margins educat, at(attitudes = (1(1)5)) predict(outcome(5))
marginsplot, ytitle("") title("Flexible") name(Flexible, replace) 
margins educat, at(attitudes = (1(1)5)) predict(outcome(6))
marginsplot, ytitle("") title("Equally") name(Equally, replace) 
grc1leg SelfReliance Provider Homemaker ///
	Specialized Flexible Equally, ycommon name(figxx, replace)
