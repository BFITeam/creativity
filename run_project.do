 
 
global mypath = "C:\Users\gtierney\Dropbox (Personal)\creativity"

//build dataset
do "$mypath/Overview_Aufbereitet.do"

//make tables
do "$mypath/Tables/run_tables.do"

//make figures
do "$mypath/Figures/run_figures.do"

//run R code 
/* 	Includes: 
		bar chart of raw effect sizes by reward decision and task
		material for referees on baseline effects
		replication of main results
	
	Requires the following libraries to be installed:
		require(foreign)
		require(reshape)
		require(plyr)
		require(sandwich)
		require(lmtest)
		require(car)
		require(plm)
		require(np)
		require(quantreg)
		require(lme4)
		require(coin)
*/

cd "$mypath/R_files"
shell R CMD BATCH 170130_Referee_Do_R.r
capture erase .Rdata
capture erase 170130_Referee_Do_R.r.Rout
