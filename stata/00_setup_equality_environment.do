*-------------------------------------------------------------------------------
* EQUALITY PROJECT
* setup_equality_environment.do

*-------------------------------------------------------------------------------

* Use setup_example.do to set your local filepath macros. 
* This file should be named named setup_<username>.do
* and saved in the base project directory.
* <username> must match exactly your Windows/MacOSX username

* Always open this .do file directly (don't open Stata and then open this .do 
* file in order for Stata to automatically set the project working.

********************************************************************************
* Setup project macros
********************************************************************************
global eq_base_code "`c(pwd)'" 	/// Creating macro of project working directory

********************************************************************************
* Setup personal file paths
********************************************************************************

// Create a home directory macro, depending on OS.
if ("`c(os)'" == "Windows") {
    local temp_drive : env HOMEDRIVE
    local temp_dir : env HOMEPATH
    global homedir "`temp_drive'`temp_dir'"
    macro drop _temp_drive _temp_dir`
}
else {
    if ("`c(os)'" == "MacOSX") | ("`c(os)'" == "Unix") {
        global homedir : env HOME
    }
    else {
        display "Unknown operating system:  `c(os)'"
        exit
    }
}


// Checks that the setup file exists and runs it.
capture confirm file "setup_`c(username)'.do"
if _rc==0 {
    do setup_`c(username)'
      }
  else {
    display as error "The file setup_`c(username)'.do does not exist"
	exit
  }

// We require a logdir for the project be set.
if ("$logdir" == "") {
    display as error "logdir macro not set."
    exit
}

set maxvar 5500

********************************************************************************
* Check for package dependencies 
********************************************************************************
* This checks for packages that the user should install prior to running the project do files.

// fre: https://ideas.repec.org/c/boc/bocode/s456835.html
capture : which fre
if (_rc) {
    display as error in smcl `"Please install package {it:fre} from SSC in order to run these do-files;"' _newline ///
        `"you can do so by clicking this link: {stata "ssc install fre":auto-install fre}"'
    exit 199
}


// missings: https://ideas.repec.org/c/boc/bocode/s458071.html
capture : which missings
if (_rc) {
    display as error in smcl `"Please install package {it:missings} from SSC in order to run these do-files;"' _newline ///
        `"you can do so by clicking this link: {stata "ssc install missings":auto-install missings}"'
    exit 199
}

// grc1leg: http://www.stata.com/users/vwiggins/
capture : which grc1leg
if (_rc) {
    display as error in smcl `"Please install package {it:grc1leg} from SSC in order to run these do-files;"' _newline ///
        `"you can do so by clicking this link: {stata "ssc install grc1leg":auto-install grc1leg}"'
    exit 199
}

********************************************************************************
* .do file settings 
********************************************************************************
version 18
set varabbrev off // don't allow  variable name abbreviation 
