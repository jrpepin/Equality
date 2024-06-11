*-------------------------------------------------------------------------------
* EQUALITY PROJECT
* 	prog: 	Inés Martínez Echagüe & Joanna Pepin
*	input:	egalitarian-dataset.dta
*	output:	none
*	title:	Measures & Sample
*-------------------------------------------------------------------------------

* SETUP ------------------------------------------------------------------------
clear
log using "$logdir/equality_measures&sample.log", replace

version                 // Shows current Stata version
display "$S_DATE"       // Shows the current date
cd      "$projcode"     // Change directory to project directory

* Import the data
use "$datadir/egalitarian-dataset.dta" 

* MEASURES ---------------------------------------------------------------------

browse // look at the data in the editor


* END --------------------------------------------------------------------------

log close