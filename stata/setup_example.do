* This is an example setup file. You should create your own setup file named
* setup_username.do that replaces the directories for project code, log files,
* etc to the location for these files on your computer. 
* This file should be saved in the $code directory.

* STANDARD PROJECT MACROS-------------------------------------------------------
global projcode 		"$homedir/GitHub/Equality"
global logdir 			"$homedir/logs/equality"
global tempdir 			"$homedir/Dropbox/Data/temp"

// Where you want produced tables, html or putdoc output files to go (NOT SHARED)
global results 			"$projcode/output/results"

* PROJECT SPECIFIC MACROS-------------------------------------------------------
global yougov           "$homedir/Dropbox/Data/YouGov" // where the data are saved
global code             "$projcode/stata"              // where the .do files are saved
global datakeep         "$projcode/output/data"        // where processed data are saved
