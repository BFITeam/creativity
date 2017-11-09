clear all
set more off
set memory 100m
cap log close

use "$mypath\Overview_Aufbereitet.dta", clear
drop if treatment == 4

log using "$mypath\Tables\Logs\BaselineRegressions.log", replace

gen below = zeffort1 < 0
gen above = zeffort1 >= 0

eststo clear
eststo: reg zeffort2 turnier gift zeffort1 $controls if slider == 1 & below == 1, robust
eststo: reg zeffort2 turnier gift zeffort1 $controls if slider == 1 & above == 1, robust

//output high-level regressions
#delimit ;
esttab using "$mypath\Tables\Output\Referees\BaselineRegressions.tex", replace
	nomtitles	
	label	   
	varlabel (_cons "Intercept" zeffort1 "Baseline" gift "Gift" turnier "Tournament")
	starlevels(* .10 ** 0.05 *** .01) 														
	stats(N r2, fmt(%9.0f %9.3f) labels("Observations"  "\$R^2$"))	// stats (specify statistics to be displayed for each model in the table footer), fmt() (
	b(%9.3f)
	se(%9.3f)
    drop ($controls)
	fragment
	style(tex) 
	substitute(\_ _)
	nonumbers 
	prehead(
	"\begin{table}[h]%" 
	"\captionsetup{justification=centering}"
	"\setlength\tabcolsep{2pt}"
	"\begin{center}%"
	"\caption{Treatment Effects by Above and Below Average Baseline Performance \\ on the Slider Task}"
	"\label{tab:BaselineReg}"
	"{\small\renewcommand{\arraystretch}{1}%" 
	"\begin{tabular}{lcc}" 
	"\hline\hline\noalign{\smallskip}"
	" & \multicolumn{2}{c}{\bf Standardized Performance in Period 2} \\"
	"\cline{2-3} "
	" & \bf Baseline Performance & \bf Baseline Performance \\"
	" & \bf Below Average & \bf Above Average \\"
	)
	posthead("\hline\noalign{\smallskip}")
	prefoot("\hline"
	"\noalign{\smallskip}"
	"Controls & YES & YES  \\"
	"\hline"
	"\noalign{\smallskip}")
	postfoot("\hline\hline\noalign{\medskip}"
	"\end{tabular}}"
	"\begin{minipage}{\textwidth}"
	"\footnotesize {\it Note:} This table reports OLS estimates of treatment effects in the slider task by baseline performance. " 
	"Columns I and II report treatment effects on the performance of agents whose performance was below (Column I) and above (Column II) average in period 1 (as compared to the control group). " 
	"$slider_description "
	"The dependent variable is standardized performance in Period 2. \\"
	"$sample_description "
	"$controls_list "
	"$errors_stars "
	"\end{minipage}"
	"\end{center}"
	"\end{table}");
#delimit cr


log close
