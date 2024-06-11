	**NOTE**
	
	*This do file:
	*   1. Creates ALL THE variables needed for THE analysis.


***START
capture log close
set more off



******************************
*     OUTCOME VARIABLES      * 
******************************


**PAST/CURRENT
gen past=.
**generate missings for not asked
 replace division_of_labor=. if division_of_labor==8
 **generate past
 replace past=1 if division_of_labor==1 
 replace past=2 if division_of_labor==2 
 replace past=3 if division_of_labor==3 
 replace past=4 if division_of_labor==4 
 replace past=5 if division_of_labor==5 
***label
label define pastlabel 1"Not Yet" 2"Self-reliance" 3"Provider" 4"Homemaker" 5"Sharing"
label val past pastlabel


**Generating a Past/Current variable without the Not Yet category.
**Generating variable
gen paststructure=.
replace paststructure=1 if past==2
replace paststructure=2 if past==3
replace paststructure=3 if past==4
replace paststructure=4 if past==5
**Checking
tab paststructure past
tab paststructure
tab past
tab division_of_labor, m
**Labeling
label define paststructurelabel 1"Self-reliance" 2"Provider" 3"Homemaker" 4"Sharing"
label val paststructure paststructurelabel


**PAST_SHARING
gen pastsharing=.
**generate missings for not asked
 replace sharing=. if sharing==9
 **generate past
 replace pastsharing=1 if sharing==1 
 replace pastsharing=2 if sharing==2 
 replace pastsharing=3 if sharing==3 
 replace pastsharing=4 if sharing==4 
 replace pastsharing=5 if sharing==5 
 replace pastsharing=6 if sharing==6 
***label
label define pastsharinglabel 1"Equally – Home Centered" 2"Equally – Balanced" 3"Equally – Career-centered" 4"Flexible" 5"Family centered – Primary" 6"Family centered – Secondary"
label val pastsharing pastsharinglabel


**FUTURO
gen futuro=.
**generate missings for not asked
 replace future=. if future==9
 **generate past
 replace futuro=1 if future==1 
 replace futuro=2 if future==2 
 replace futuro=3 if future==3 
 replace futuro=4 if future==4 
***label
label define futurolabel 1"Self-reliance" 2"Provider" 3"Homemaker" 4"Sharing"
label val futuro futurolabel


**FUTURO_SHARING
gen futuro_sharing=.
**generate missings for not asked 
 replace future_sharing=. if future_sharing==9
 **generate past
 replace futuro_sharing=1 if future_sharing==1 
 replace futuro_sharing=2 if future_sharing==2 
 replace futuro_sharing=3 if future_sharing==3  
 replace futuro_sharing=4 if future_sharing==4 
 replace futuro_sharing=5 if future_sharing==5 
 replace futuro_sharing=6 if future_sharing==6  
***label
label define futuro_sharinglabel 1"Equally – Home Centered" 2"Equally – Balanced" 3"Equally – Career-centered" 4"Flexible" 5"Family centered – Primary" 6"Family centered – Secondary"
label val futuro_sharing futuro_sharinglabel


**IDEAL
gen ideal=.
**generate missings for not asked
 replace ideal=. if ideal_arrangement==9
 **generate past
 replace ideal=1 if ideal_arrangement==1 
 replace ideal=2 if ideal_arrangement==2 
 replace ideal=3 if ideal_arrangement==3 
 replace ideal=4 if ideal_arrangement==4 
***label
label define ideallabel 1"Self-reliance" 2"Provider" 3"Homemaker" 4"Sharing"
label val ideal ideallabel


**IDEAL_SHARING
gen ideal_sharing=.
**generate missings for not asked 
 replace future_sharing_arrangement=. if future_sharing_arrangement==9
 **generate past
 replace ideal_sharing=1 if future_sharing_arrangement==1 
 replace ideal_sharing=2 if future_sharing_arrangement==2 
 replace ideal_sharing=3 if future_sharing_arrangement==3 
 replace ideal_sharing=4 if future_sharing_arrangement==4 
 replace ideal_sharing=5 if future_sharing_arrangement==5 
 replace ideal_sharing=6 if future_sharing_arrangement==6 
***label
label define ideal_sharinglabel 1"Equally – Home Centered" 2"Equally – Balanced" 3"Equally – Career-centered" 4"Flexible" 5"Family centered – Primary" 6"Family centered – Secondary"
label val ideal_sharing ideal_sharinglabel



****************************************
*   REDUCED/RECODED OUTCOME VARIABLES  *
****************************************


***Reducing past sharing categories. 
**Generate
gen pastsharing3=.
replace pastsharing3=1 if pastsharing==1 | pastsharing==2 | pastsharing==3
replace pastsharing3=2 if sharing==4 
replace pastsharing3=3 if sharing==5 | pastsharing==6
**Check missings
tab pastsharing3 pastsharing
**Label
label define pastsharing3label 1"Equally" 2"Flexible" 3"Specialized" 
label val pastsharing3 pastsharing3label
**Check
tab pastsharing3
tab pastsharing3, nolab


***Generating a sharing variable with those who shared equally.
**Generate
gen sharedequally=.
replace sharedequally=1 if pastsharing3==1 
replace sharedequally=0 if pastsharing3==2 | pastsharing3==3 | paststructure==1 | paststructure==2 | paststructure==3 
tab sharedequally
**Label
label define sharedequallylab  1"Sharing Equally" 0"Not sharing equally" 
label val sharedequally sharedequallylab
**Check
tab sharedequally
tab sharedequally, nolab


***Reducing ideal sharing categories. 
**Generate
gen idealsharing3=.
replace idealsharing3=1 if ideal_sharing==1 | ideal_sharing==2 | ideal_sharing==3
replace idealsharing3=2 if ideal_sharing==4 
replace idealsharing3=3 if ideal_sharing==5 | ideal_sharing==6
**Check missings
tab idealsharing3 ideal_sharing
**Label
label define idealsharing3label 1"Equally" 2"Flexible" 3"Specialized" 
label val idealsharing3 idealsharing3label
**Check
tab idealsharing3
tab idealsharing3, nolab


***Reducing future sharing categories. 
**Generate
gen futuresharing3=.
replace futuresharing3=1 if futuro_sharing==1 | futuro_sharing==2 | futuro_sharing==3
replace futuresharing3=2 if futuro_sharing==4 
replace futuresharing3=3 if futuro_sharing==5 | futuro_sharing==6
**Check missings
tab futuresharing3 futuro_sharing
**Label
label define futuresharing3label 1"Equally" 2"Flexible" 3"Specialized" 
label val futuresharing3 futuresharing3label
**Check
tab futuresharing3
tab futuresharing3, nolab


**Generating a variable combining PAST and FUTURE.
gen structure=.
replace structure=1 if paststructure==1 | futuro==1 
replace structure=2 if paststructure==2 | futuro==2
replace structure=3 if paststructure==3 | futuro==3
replace structure=4 if paststructure==4 | futuro==4   
tab structure
**Label
label define structurelabel  1"Self-reliance" 2"Provider" 3"Homemaker" 4"Sharing"
label val structure structurelabel
**Check
tab structure
tab structure, nolab


***IDEAL SCENARIO WITH ALL SHARING OPTIONS
**Generate
gen theideal=.
replace theideal=1 if ideal==1 
replace theideal=2 if ideal==2
replace theideal=3 if ideal==3
replace theideal=4 if idealsharing3==1 
replace theideal=5 if idealsharing3==2 
replace theideal=6 if idealsharing3==3   
**Check missings
tab theideal ideal
**Label
label define theideallabel 1"Self-reliance" 2"Provider" 3"Homemaker" 4"Sharing-Equally" 5"Sharing-Flexible" 6"Sharing-Specialized" 
label val theideal theideallabel
**Check
tab theideal
tab theideal, nolab


***PAST SCENARIO WITH ALL SHARING OPTIONS
gen thepast=.
replace thepast=1 if paststructure==1
replace thepast=2 if paststructure==2
replace thepast=3 if paststructure==3
replace thepast=4 if pastsharing3==1
replace thepast=5 if pastsharing3==2
replace thepast=6 if pastsharing3==3
**Checking
tab thepast paststructure
tab thepast, m
**Labeling
label define thepastlabel 1"Self-reliance" 2"Provider" 3"Homemaker" 4"Sharing-Equally" 5"Sharing-Flexible" 6"Sharing-Specialized"
label val thepast thepastlabel
**Check
tab thepast
tab thepast, nolab


***FUTURE SCENARIO WITH ALL SHARING OPTIONS
gen thefuture=.
replace thefuture=1 if futuro==1
replace thefuture=2 if futuro==2
replace thefuture=3 if futuro==3
replace thefuture=4 if futuresharing3==1
replace thefuture=5 if futuresharing3==2
replace thefuture=6 if futuresharing3==3
**Checking
tab thefuture futuro
tab thefuture, m
**Labeling
label define thefuturelabel 1"Self-reliance" 2"Provider" 3"Homemaker" 4"Sharing-Equally" 5"Sharing-Flexible" 6"Sharing-Specialized"
label val thefuture thefuturelabel
**Check
tab thefuture
tab thefuture, nolab


**Generating a variable combining IDEAL and FUTURE.
gen structure2=.
replace structure2=1 if ideal==1 | futuro==1 
replace structure2=2 if ideal==2 | futuro==2
replace structure2=3 if ideal==3 | futuro==3
replace structure2=4 if ideal==4 | futuro==4   
tab structure2 futuro
**Label
label define structure2label  1"Self-reliance" 2"Provider" 3"Homemaker" 4"Sharing"
label val structure2 structure2label
**Check
tab structure2
tab structure2, nolab


**Variable indicatador ideal/futuro
gen idealfuturo=.
replace idealfuturo=1 if ideal!=. 
replace idealfuturo=2 if futuro!=. 
tab idealfuturo


**Generating a variable combining PAST and FUTURE SHARING
gen sharingtype=.
replace sharingtype=1 if pastsharing3==1 | futuresharing3==1 
replace sharingtype=2 if pastsharing3==2 | futuresharing3==2
replace sharingtype=3 if pastsharing3==3 | futuresharing3==3
tab pastsharing3
tab futuresharing3
tab sharingtype
**Label
label define sharingtypelabel  1"Equally" 2"Flexible" 3"Specialized" 
label val sharingtype sharingtypelabel
**Check
tab sharingtype
tab sharingtype, nolab
**47% equally, 29% specialized, 23% flexible.


**Generating a variable combining IDEAL and FUTURE SHARING
gen sharingtype2=.
replace sharingtype2=1 if idealsharing3==1 | futuresharing3==1 
replace sharingtype2=2 if idealsharing3==2 | futuresharing3==2
replace sharingtype2=3 if idealsharing3==3 | futuresharing3==3
tab idealsharing3
tab futuresharing3
tab sharingtype2
**Label
label define sharingtype2label  1"Equally" 2"Flexible" 3"Specialized" 
label val sharingtype2 sharingtype2label
**Check
tab sharingtype2
tab sharingtype2, nolab
**51% equally, 29% flexible, 20% specialized.
** When talking about ideal scenarios specalized sharing decreases/ is less prefered.


**Generating a dummy sharing variable for past/present sharing

**** Generating a sharing in the past
gen shared=.
replace shared=1 if paststructure==4 
replace shared=0 if paststructure==1 | paststructure==2 | paststructure==3  
tab shared
**Label
label define sharedlab  1"Sharing" 0"Not sharing" 
label val shared sharedlab
**Check
tab shared
tab shared, nolab


**************************
*  DEMOGRAPHIC VARIABLES *
**************************


***Age
gen age = 2019 - birthyr


***Age categories
gen agecat=.
replace agecat=1 if age<=30
replace agecat=2 if age> 30 & age<=40
replace agecat=3 if age> 40 & age<=50
replace agecat=4 if age> 50 & age<=60
replace agecat=5 if age> 60 
tab age agecat
label define agecatlabel  1"30 or less" 2"31-40" 3"41-50" 4"51-60" 5"60 or more"
label val agecat agecatlabel


***Non linear age
gen age2=age^2
gen age3=age^3
gen age4=age^4
gen age5=age^5


**Recoding race.
gen race2=.
replace race2=1 if race==1 
replace race2=2 if race==2 
replace race2=3 if race==3 
replace race2=4 if race==4 | race==5 | race==6 | race==7 | race==8
tab race2 race
label define race2label  1"White" 2"Black" 3"Hispanic" 4"Other"
label val race2 race2label


**Recoding marital status.
gen married=.
replace married=1 if marstat==1 
replace married=0 if marstat==2 |  marstat==3 |  marstat==4 |   marstat==5 |  marstat==6  
tab married marstat
label define marriedlabel  1"Married" 0"Not married"
label val married marriedlabel


***Gender // Female dummy
tab gender, m
tab gender, m nol
recode gender 1=0 2=1, gen(female)
tab gender female, m
label var female "Female dummy"


***Education
tab educ, m
tab educ, m nol
recode educ 1/2=1 3/4=2 5=3 6=4, gen(educat)
tab educ educat, m
label var educat "Education (recode)"
label define educatlab 1 "No college" 2 "Less than 4-year deg" ///
	3 "4-year degree" 4 "Post-grad"
label values educat educatlab


***Family income
tab faminc_new, m
tab faminc_new, m nol
tab faminc_new if faminc<97
tab faminc_new if faminc<97 [aw=weight]
recode faminc_new 1/2=1 3/4=2 5/8=3 9/16=4 97=., gen(incat)
tab faminc_new incat, m
label variable incat "Family income"
label define incatlab 1 "Less than $20,000" 2 "$20,000 - $39,999" ///
	3 "$40,000 - $79,999" 4 "80,000 or more"
label values incat incatlab


 

************************
*       ATTITUDES      *    
************************


**************************** FREE MARKET

***When it comes to how much people are paid, I find society to be fair
clonevar socfair=society_fair
recode socfair 8=.
tab socfair society_fair, m

***One of the biggest problems in this country is that we don't give everyone 
***an equal chance
clonevar eqchance=equal_chance
tab eqchance equal_chance, m

***Private enterprise is the best way to solve America's economic problems
clonevar freemarket=free_market
recode freemarket 8=.
tab freemarket free_market, m


**************************** GENDER


***Men and women are innately different in interests and skills.
**Testing gender essentialism, in general.
clonevar essential=essentialism
recode essential 8=.
tab essential essentialism, m


** 3 category essentialism
gen essential3=.
replace essential3=1 if essentialism==1 | essentialism==2
replace essential3=2 if essentialism==3
replace essential3=3 if essentialism==4 | essentialism==5
tab essential essential3, m
label define essential3label  1"Disagree" 2"Neither" 3"Agree"
label val essential3 essential3label


***When jobs are scarce, men have more right to a job than women.
**Testing male primacy in the workplace/public sphere.
clonevar maleprimacy=scarce
tab maleprimacy scarce, m


** 3 category laborforce
gen laborforce=.
replace laborforce=1 if maleprimacy==1 | maleprimacy==2
replace laborforce=2 if maleprimacy==3
replace laborforce=3 if maleprimacy==4 | maleprimacy==5
tab maleprimacy laborforce, m
label define laborforcelabel  1"Disagree" 2"Neither" 3"Agree"
label val laborforce laborforcelabel


***On the whole, men make better business executives than women do.
**Testing gender essentialism in the workplace/public sphere.
clonevar men_lead=menlead
tab menlead men_lead, m


***In general, fathers are as well-suited to look after their children as mothers.
***Testing gender essentialism in the private sphere.
clonevar fathercare=fathers
tab fathercare fathers, m


***The husband should make the important decisions in the family.
***Testing male primacy in the private sphere.
clonevar decision=decisions
tab decisions decision, m


***Fathers should work fewer hours and spend more time with their families.
***Testing gender essentialism in relation to fathers' work.
clonevar fathertime=time
tab time fathertime, m


**************************** TESTING ATTITUDE SCALES


ssc install sumscale


*** Testing some sum scales to study the (in)consistency of the different components of gender attitudes.
*Sum of essential men_lead maleprimacy (Testing the three components of gender attitudes)
sumscale, f1(essential men_lead maleprimacy) // alpha is .77.
rename Factor1_average gendercomp
label var gendercomp "essential menlead maleprimacy with alpha .77"


*Sum of men_lead maleprimacy (Testing male primacy and essentialism measures in the public sphere, it makes sense that alpha is bigger)
sumscale, f2 (men_lead maleprimacy) // alpha is .80.
rename Factor2_average mprimacyscale
label var mprimacyscale "menlead maleprimacy with alpha .8"


*Sum of men_lead essential (Testing essentialist attitudes, in general and in the public sphere)
sumscale, f4 (men_lead essential) // alpha is .70.
rename Factor4_average essentialworkplace
label var essentialworkplace "menlead essential with alpha .7"


*Sum of maleprimacy decision  
sumscale, f6 (maleprimacy decision) // alpha is .67 // Male primacy in the public and private sphere are related but not exactly the same.
rename Factor6_average primacysphere
label var primacysphere "maleprimacy decision with alpha .67"



************************
*       CHANGE         *  
************************


***Generating a variable for those who changed between past and ideal arrangements
gen change=0 if past==ideal+1
replace change=1 if past!=(ideal+1) & past!=1
***check missings
tab change
tab past if past==1
tab past
tab futuro


** analyzing change by gender
tab change gender [aw=weight], colum nofreq
tab change past if gender==1 [aw=weight], colum nofreq
tab change past if gender==2 [aw=weight], colum nofreq


** analyzing change by education
tab change educat[aw=weight], colum nofreq


** analyzing change by gender and education
tab change educat if gender==1 [aw=weight], colum nofreq
tab change educat if gender==2 [aw=weight], colum nofreq
// it is not particularly interesting -- for women around 40% all education levels 
// for men around 30% all education levels except BA that grows to 40%, i wonder what that means


** analyzing change by current arrangement and past sharing
tab change past[aw=weight], colum nofreq
tab change pastsharing3[aw=weight], colum nofreq




