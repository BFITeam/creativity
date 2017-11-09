clear all
set more off
set memory 100m
cap log close

use "$mypath\Overview_Aufbereitet.dta", clear
log using "$mypath\Tables\Logs\Table_Main_Period2_Results.log", replace
drop if treatment == 4

cap program drop get_pvals
program define get_pvals, rclass
	
	test turnier == gift
	local p_cr = round(`r(p)',.00001)
	if(`p_cr' == 0) local p_cr 0.000
	test turnXslid == giftXslid
	local p_sl = round(`r(p)',.00001)
	if(`p_sl' == 0) local p_sl 0.000
	
	return local p_cr `p_cr'
	return local p_sl `p_sl'
end


* Nummer 1
local treatments turnier turnXslid gift giftXslid
eststo clear	// eststo clear drops all estimation sets stored by eststo
eststo:  reg ztransfer2 `treatments' if feedback==0 & (slider==1 | creative==1), robust
get_pvals
local p_1_cr `r(p_cr)'
local p_1_sl `r(p_sl)'

eststo:  reg ztransfer2 `treatments' ztransfer1 ztransfer1Xslid if feedback==0 & (slider==1 | creative==1), robust
get_pvals
local p_2_cr `r(p_cr)'
local p_2_sl `r(p_sl)'
test gift + giftXslid = 0

eststo:  reg ztransfer2 `treatments' ztransfer1 ztransfer1Xslid $controls if (slider==1 | creative==1), robust
get_pvals
local p_3_cr `r(p_cr)'
local p_3_sl `r(p_sl)'
test gift = giftXslid
*eststo:  reg ztransfer2 gift turnier feedback creative_trans giftXtransfer giftXslid turnXslid feedXslid ztransfer1 ztransfer1Xslid age age2 sex ferienzeit pruefungszeit wiwi recht nawi gewi mannheim if (slider==1 | creative==1 | creative_trans==1), robust
test gift + giftXslid == 0 
test gift == 0.2
local p_format %9.3f
#delimit; // #delimit: command resets the character that marks the end of a command, here ;

esttab using "$mypath\Tables\Output\Table_Main_Period2_Results.tex", // esttab produces a pretty-looking publication-style regression table from stored estimates without much typing (alternative zu estout)
	nomtitles	// Options: mtitles (model titles to appear in table header)
	label	   // label (make use of variable labels)
	varlabel (_cons "Intercept" ztransfer1 "Baseline" zeffort1 "Baseline" gift "Gift" turnier "Tournament" zeffort1Xslid "Baseline x Slider-Task" giftXslid "Gift x Slider-Task" turnXslid "Tournament x Slider-Task" ztransfer1Xslid "Baseline x Slider-Task"
	, elist(_cons "[2mm]" zeffort1 "[2mm]" gift "[2mm]" turnier "[2mm]" feedback "[2mm]" giftXslid "[2mm]" turnXslid "[2mm]" feedXslid "[2mm]" zeffort1Xslid "[2mm]" ztransfer1 "[2mm]" ztransfer1Xslid "[2mm]"))
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
	"\setlength\tabcolsep{2pt}"
	"\caption{Treatment Effects in Period 2}"
	
	"\begin{center}%" 
	"{\small\renewcommand{\arraystretch}{1}%" 
	"\begin{tabular}{lccc}" 
	"\hline\hline\noalign{\smallskip}"
	" & I & II & III \\")
	posthead("\hline\noalign{\smallskip}") 
	prefoot("\noalign{\smallskip}\hline"
	" Controls & NO & NO & YES \\"
	"\hline" ) 
	postfoot(
	"\hline\hline\noalign{\medskip}"
	"\end{tabular}"
	"\begin{minipage}{\textwidth}"
	"\footnotesize {\it Note:} This table reports the estimated OLS coefficients from Equation \ref{eq:reg}. " 
	"The dependent variable is standardized performance in Period 2. $pooled_performance_description "
	"The treatment dummies \textit{Gift} and \textit{Tournament} capture the effect of an unconditional monetary gift or of a tournament incentive (rewarding the top 2 performers out of 4 agents) on standardized performance in the creative task. " 
	"The interaction effects measure the difference in treatment effects between the creative and the slider task. "
	"The treatment effects on the slider task are equal to the sum of the main treatment effect (\textit{Gift} or \textit{Tournament}) and its associated interaction effect (\textit{Gift x Slider} and \textit{Tournament x Slider}). \\"
	"$sample_description "
	"$controls_list "
	"$errors_stars "
	"\end{minipage}}"
	"\end{center}"
	"\label{tab:EQ_Pooled_Results}"
	"\end{table}")
	replace;
			
#delimit cr	// #delimit cr: restore the carriage return delimiter inside a file

//sniptit to add p values for test for differenc between treatments within tasks
di "Difference in treatment & `p_1_cr' & `p_2_cr' & `p_3_cr' \\"
di "effect for creative task & `p_1_sl' & `p_2_sl' & `p_3_sl' \\"


log close
