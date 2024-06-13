*-------------------------------------------------------------------------------
* EQUALITY PROJECT
* 	prog: 	Inés Martínez Echagüe & Joanna Pepin
*	input:	egalitarian-dataset.dta
*	output:	none
*	title:	Measures & Sample
*-------------------------------------------------------------------------------

********************************************************************************
* SETUP 
********************************************************************************

clear all
*log using "$logdir/equality_measures&sample.log", replace

version                 // Shows current Stata version
display "$S_DATE"       // Shows the current date
cd      "$projcode"     // Change directory to project directory

* Import the data
use "$datadir/egalitarian-dataset.dta" 

********************************************************************************
* MEASURES
********************************************************************************

* DVs  -------------------------------------------------------------------------
/* 
* division_of_labor
Which of the following options best describes how would you have liked to 
structure your work and family life? Please choose your ideal situation, 
regardless of whether this matches what actually happened.

// not yet made plans (ideal)
If respondent chooses option #1 for the division_of_labor question:

* future
Which of the following options best describes how you would like to structure 
your work and family life in the future? 

* future_sharing
If respondent chooses option #4 for the ideal_arrangement question: 
How would you like to have shared those activities with your partner? 
Please choose the option that best fits your ideal arrangement with your partner

// already WFA (ideal)
If respondent chooses any option other than option #1 for the division_of_labor 
question: 

* ideal_arrangement
Which of the following options best describes how would you have liked to 
structure your work and family life? Please choose your ideal situation, 
regardless of whether this matches what actually happened.

* future_sharing_arrangement
If respondent chooses option #4 for the ideal_arrangement 
How would you like to have shared those activities with your partner? 
Please choose the option that best fits your ideal arrangement with your partner
*/

*CURRENT WFA
fre division_of_labor

cap drop wfaNow
gen      wfaNow=.
replace  wfaNow=0 if division_of_labor ==1
replace  wfaNow=1 if division_of_labor >=2 & division_of_labor <=5
***label
label define wfaNowlabel 0"No WFA" 1"WFA"
label val wfaNow wfaNowlabel

*IDEAL
cap drop ideal
gen      ideal=.
replace  ideal=1 if ideal_arrangement==1  | future == 1
replace  ideal=2 if ideal_arrangement==2  | future == 2
replace  ideal=3 if ideal_arrangement==3  | future == 3
replace  ideal=4 if ideal_arrangement==4  | future == 4
***label
label define ideallabel 1"Self-reliance" 2"Provider" 3"Homemaker" 4"Sharing"
label val ideal ideallabel

*IDEAL SHARING
cap drop share
gen      share=.
replace  share=1 if future_sharing==1 | future_sharing_arrangement == 1
replace  share=2 if future_sharing==2 | future_sharing_arrangement == 2
replace  share=3 if future_sharing==3 | future_sharing_arrangement == 3
replace  share=4 if future_sharing==4 | future_sharing_arrangement == 4
replace  share=5 if future_sharing==5 | future_sharing_arrangement == 5
replace  share=6 if future_sharing==6 | future_sharing_arrangement == 6
***label
label define ideal_sharinglabel                                              ///
	1"Equally – Home Centered" 		2"Equally – Balanced"                    ///
	3"Equally – Career-centered" 	4"Flexible"                              ///
	5"Family centered – Primary"    6"Family centered – Secondary"
label val share ideal_sharinglabel

* Demographic Vars  ------------------------------------------------------------

*AGE
fre birthyr

cap drop age
gen age = 2019 - birthyr

cap drop agecat
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
cap drop age2
gen age2=age^2
gen age3=age^3
gen age4=age^4
gen age5=age^5

*RACE
fre race

cap drop racecat
gen racecat=.
replace racecat=1 if race==1 
replace racecat=2 if race==2 
replace racecat=3 if race==3 
replace racecat=4 if race>=4
tab racecat race
label define racecatlabel  1"White" 2"Black" 3"Hispanic" 4"Other"
label val racecat racecatlabel

*MARITAL STATUS
fre marstat

cap drop married
gen married=.
replace married=1 if marstat==1 
replace married=0 if marstat!=1 
tab married marstat
label define marriedlabel  1"Married" 0"Not married"
label val married marriedlabel

*GENDER (female dummy)
fre gender

cap drop female
recode gender 1=0 2=1, gen(female)
tab gender female, m
label var female "Female dummy"

*EDUCATION
fre educ

cap drop educat
recode educ 1/2=1 3/4=2 5=3 6=4, gen(educat)
tab educ educat, m
label var educat "Education (recode)"
label define educatlab 	1 "No college"    2 "Less than 4-year deg"           ///
						3 "4-year degree" 4 "Post-grad"
label values educat educatlab

*FAMILY INCOME
fre faminc_new

fre faminc_new
fre faminc_new if faminc_new<97 [aw=weight]

cap drop incat
recode faminc_new 1/2=1 3/4=2 5/8=3 9/16=4 97=., gen(incat)
tab faminc_new incat, m
label variable incat "Family income"
label define incatlab 1 "Less than $20,000" 2 "$20,000 - $39,999"            ///
	3 "$40,000 - $79,999" 4 "80,000 or more"
label values incat incatlab


* GENDER ATTITUDE SCALES -------------------------------------------------------
** Men and women are innately different in interests and skills.
** When jobs are scarce, men have more right to a job than women.
** On the whole, men make better business executives than women do.
** In general, fathers are as well-suited to look after their children as mothers.
** The husband should make the important decisions in the family.
** Fathers should work fewer hours and spend more time with their families.

fre essentialism scarce menlead fathers decisions time

// 1 missing case
replace essentialism=. if essentialism==8 

// Testing scales
 *** all vars
alpha essentialism scarce menlead fathers decisions time,                    ///
	reverse(fathers time) item  
	
*** remove time
alpha essentialism scarce menlead fathers decisions,                         ///
	reverse(fathers) item 
	
*** remove time & fathers
cap drop attitudes
alpha essentialism scarce menlead decisions, item gen(attitudes) // alpha is .81

* END --------------------------------------------------------------------------

*log close