clear all
set more off
set memory 100m
cap log close

use "$mypath\Overview_Aufbereitet.dta", clear
drop if treatment == 4

log using "$mypath\Tables\Logs\BaselineRegressions.log", replace

cap program drop get_pvals
program define get_pvals, rclass
	
	test turnier == gift
	local p_cr = round(`r(p)',.00001)
	if(`p_cr' == 0) local p_cr 0.000
	
	test turnier + turnXslid == gift + giftXslid
	local p_sl = round(`r(p)',.00001)
	if(`p_sl' == 0) local p_sl 0.000
	
	test gift + giftXslid == 0 
	local p_sl_g_0 = round(`r(p)',.00001)
	if(`p_sl_g_0' == 0) local p_sl_g_0 0.000
	
	test turnier + turnXslid == 0 
	local p_sl_t_0 = round(`r(p)',.00001)
	if(`p_sl_t_0' == 0) local p_sl_t_0 0.000
	
	local gift_slider_point_est = _b[gift] + _b[giftXslid]
	test gift == `gift_slider_point_est'
	local p_cr_2 = round(`r(p)',.00001)
	if(`p_cr_2' == 0) local p_cr_2 0.000
	
	display "Test for tournament and gift having the same effect in creative task: `p_cr'"
	display "Test for tournament and gift having the same effect in slider task: `p_sl'"
	display "Test for gift having zero effect in slider task: `p_sl_g_0'"
	display "Test for tournament having zero effect in slider task: `p_sl_t_0'"
	display "Test for gift having effect size of 0.2 in creative task: `p_cr_2'"
	
	return local p_cr `p_cr'
	return local p_sl `p_sl'
end

gen below = ztransfer1 < 0
gen above = ztransfer1 >= 0
gen giftXcreative = gift == 1 & creative == 1
gen turnXcreative = turnier == 1 & creative == 1

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
