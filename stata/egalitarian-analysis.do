	**NOTE**
	
	*This do file:
	*   1. Runs the analyses present in the paper.


	
******************************
*         WEIGHTS           * 
****************************** 

	
svyset caseid [pweight=weight], vce(linearized) singleunit(missing)


******************************
*         FOOTNOTE           * 
****************************** 


******** Age differences between CURRENT/PAST and FUTURE categories

** Current/Past category
sum age if paststructure==1 | paststructure==2 | paststructure==3 | paststructure==4 [aw=weight]
** Age 53

** Future category
sum age if futuro==1 | futuro==2 | futuro==3 | futuro==4 [aw=weight]
** Age 38	
	
	
******************************
*          TABLE 1           * 
****************************** 


******** Gender Attitudes (Overall and by gender)

** Male primacy
tab maleprimacy gender [aw=weight], column nofreq 
svy: tab  maleprimacy gender , column pea

** Gender essentialism
tab essentialism gender [aw=weight], column nofreq 
svy: tab essentialism gender, column pea


******** Discrepancies from current to ideal arrangements

** Overall
tab paststructure ideal [aw=weight], row nofreq
svy: tab paststructure ideal, column pea

** Men
tab paststructure ideal if female==0 [aw=weight], row nofreq
svy: tab paststructure ideal if female==0, column pea

** Women
tab paststructure ideal if female==1 [aw=weight], row nofreq
svy: tab paststructure ideal if female==1 , column pea

	
******************************
*          TABLE 2           * 
****************************** 


******** Overall current, ideal and future

 
tab paststructure [aw=weight]

tab ideal [aw=weight]

tab futuro [aw=weight]
  
tab pastsharing3 [aw=weight]

tab idealsharing3 [aw=weight] 

tab futuresharing3 [aw=weight] 


******** Current, ideal, future by gender


tab past gender if past!=1 [aw=weight], column nofreq 
svy: tab past gender if past!=1 , column pea

tab ideal gender [aw=weight], column nofreq 
svy: tab ideal gender , column pea

tab futuro gender [aw=weight], column nofreq 
svy: tab futuro gender , column pea


******** Current, ideal, future SHARING by gender


tab pastsharing3 gender [aw=weight], column nofreq 
svy: tab pastsharing3 gender, column pea
tab pastsharing3 gender [aw=weight], column

tab idealsharing3 gender [aw=weight], column nofreq 
svy: tab idealsharing3 gender, column pea
tab idealsharing3 gender [aw=weight], column 

tab futuresharing3 gender [aw=weight], column nofreq 
svy: tab futuresharing3 gender, column pea
tab futuresharing3 gender [aw=weight], column 


******** Current, ideal, future by education


tab past educat if past!=1 [aw=weight], column nofreq
tab past educat if gender==1 & past!=1 [aw=weight], column nofreq
tab past educat if gender==2 & past!=1 [aw=weight], column nofreq

tab ideal educat [aw=weight], column nofreq
tab ideal educat if gender==1 [aw=weight], column nofreq
tab ideal educat if gender==2 [aw=weight], column nofreq

tab futuro educat [aw=weight], column nofreq
tab futuro educat if gender==1 [aw=weight], column nofreq
tab futuro educat if gender==2 [aw=weight], column nofreq


******** Current, ideal, future SHARING by education


tab pastsharing3 educat [aw=weight], column nofreq 
svy: tab pastsharing3 educat, column pea
tab pastsharing3 educat [aw=weight], column

tab idealsharing3 educat [aw=weight], column nofreq 
svy: tab idealsharing3 educat, column pea
tab idealsharing3 educat [aw=weight], column 

tab futuresharing3 educat [aw=weight], column nofreq 
svy: tab futuresharing3 educat, column pea
tab futuresharing3 educat [aw=weight], column 


******** Discrepancies between current and ideal arrangments


**Overall
tab paststructure ideal [aw=weight], row nofreq
svy: tab paststructure ideal, column pea

**Men
tab paststructure ideal if female==0 [aw=weight], row nofreq
svy: tab paststructure ideal if female==0, column pea

**Women
tab paststructure ideal if female==1 [aw=weight], row nofreq
svy: tab paststructure ideal if female==1 , column pea

**By education
tab paststructure ideal if educat==1 [aw=weight], row nofreq
tab paststructure ideal if educat==2 [aw=weight], row nofreq
tab paststructure ideal if educat==3 [aw=weight], row nofreq
tab paststructure ideal if educat==4 [aw=weight], row nofreq


******** Discrepancies between current and ideal SHARING arrangments


**Overall
tab change pastsharing3[aw=weight], colum nofreq

**By gender
tab change pastsharing3 if female==1 [aw=weight], colum nofreq
tab change pastsharing3 if female==0 [aw=weight], colum nofreq

**By education
tab change pastsharing3 if educat==1 [aw=weight], colum nofreq
tab change pastsharing3 if educat==2 [aw=weight], colum nofreq
tab change pastsharing3 if educat==3 [aw=weight], colum nofreq
tab change pastsharing3 if educat==4 [aw=weight], colum nofreq


******************************
*          TABLE 3           * 
****************************** 


** Installing estout
ssc install estout, replace

*** Model 1: Multinomial Logistic Regression of Ideal Arrangement
** A function of gender attitudes, sociodemographic characteristics and current arrangment
mlogit ideal essential maleprimacy i.female i.educat i.race2 age i.married i.child18 ib4.paststructure [pw=weight] , b(4) 
estimates store c1
esttab c1 using Model1.doc, label se r2 rtf  


*** Model 2: Logistic Regression of Sharing
** A function of gender attitudes, sociodemographic characteristics and current arrangment
logit shared essential maleprimacy i.female i.educat i.race2 age i.married i.child18 [pw=weight] 
estimates store c2
esttab c2 using Model2.doc, label se r2 rtf  


******************************
*          TABLE 4           * 
****************************** 


*** Model 3: Logistic Regression of Equally Sharing
** A function of gender attitudes and sociodemographic characteristics 
logit sharedequally essential maleprimacy i.female i.educat i.race2 age i.married i.child18 [pw=weight] 
estimates store c3
esttab c3 using Model3.doc, label se r2 rtf 


*** Model 4: Multinomial Logistic Regression of Ideal Sharing
** A function of gender attitudes and sociodemographic characteristics 
mlogit idealsharing3 essential maleprimacy i.female i.educat i.race2 age i.married i.child18 [pw=weight], b(3)
estimates store m4
esttab m4 using Model4.doc, label se r2 rtf 



