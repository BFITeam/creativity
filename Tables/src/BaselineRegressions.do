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
	display "Test for tournament and gift having the same effect in simple task: `p_sl'"
	display "Test for gift having zero effect in simple task: `p_sl_g_0'"
	display "Test for tournament having zero effect in simple task: `p_sl_t_0'"
	display "Test for gift having effect size of 0.2 in creative task: `p_cr_2'"
	
	return local p_cr `p_cr'
	return local p_sl `p_sl'
end

gen below = ztransfer1 < 0
gen above = ztransfer1 >= 0
gen giftXcreative = gift == 1 & creative == 1
gen turnXcreative = turnier == 1 & creative == 1

eststo clear
local treatments turnier turnXslid gift giftXslid  

eststo: reg ztransfer2 `treatments' ztransfer1 ztransfer1Xslid $controls if (slider == 1 | creative == 1) & below == 1, robust
get_pvals

eststo: reg ztransfer2 `treatments' ztransfer1 ztransfer1Xslid $controls if (slider == 1 | creative == 1) & above == 1, robust
get_pvals

//output high-level regressions
#delimit ;
esttab using "$mypath\Tables\Output\Appendix\BaselineRegressions.tex", replace
	nomtitles	
	label	   
	varlabel (_cons "Constant" ztransfer1 "Period 1 Output" zeffort1 "Period 1 Output" slider "Simple Task" gift "Gift" turnier "Performance Bonus" zeffort1Xslid "Period 1 Output x Simple Task" giftXslid "Gift x Simple Task" turnXslid "Performance Bonus x Simple Task" ztransfer1Xslid "Period 1 Output x Simple Task"
	, elist(_cons "[2mm]" zeffort1 "[2mm]" slider "[2mm]" gift "[2mm]" turnier "[2mm]" feedback "[2mm]" giftXslid "[2mm]" turnXslid "[2mm]" feedXslid "[2mm]" zeffort1Xslid "[2mm]" ztransfer1 "[2mm]" ztransfer1Xslid "[2mm]"))
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
	"\caption{Treatment Effects by Above and Below Average Period 1 Output}"
	"\label{tab:BaselineReg}"
	"{\small\renewcommand{\arraystretch}{1}%" 
	"\begin{tabular}{lcc}" 
	"\hline\hline\noalign{\smallskip}"
	" & \multicolumn{2}{c}{\bf Standardized Output in Period 2} \\"
	"\cmidrule{2-3} "
	" & \bf Period 1 Output & \bf Period 1 Output \\"
	" & \bf Below Average & \bf Above Average \\"
	)
	posthead("\hline\noalign{\smallskip}")
	prefoot("\hline"
	"\noalign{\smallskip}"
	"Additional Controls & YES & YES  \\"
	"\hline"
	"\noalign{\smallskip}")
	postfoot("\hline\hline\noalign{\medskip}"
	"\end{tabular}}"
	"\begin{minipage}{\textwidth}"
	"\footnotesize {\it Note:} "
	"This table reports the estimated OLS coefficients from Equation \ref{eq:reg} split by Period 1 output. " 
	"The columns report treatment effects on the output of agents whose output was below average (the first column) and above average (the second column) in Period 1 as compared to the \textit{Control} group. " 
	"The dependent variable is standardized output in Period 2. $pooled_performance_description "
	"$treatment_coef_description " 
	"$slider_treatment_effects \\"
	"$sample_description "
	"$controls_list "
	"$errors_stars "
	"\end{minipage}"
	"\end{center}"
	"\end{table}");
#delimit cr


log close
