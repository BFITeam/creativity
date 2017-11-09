 
 
global mypath = "C:\Users\gtierney\Dropbox (Personal)\creativity"

//build dataset
do "$mypath/Overview_Aufbereitet.do"

//make tables
do "$mypath/Tables/run_tables.do"

//make figures
do "$mypath/Figures/run_figures.do"
