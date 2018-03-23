clear all
set more off
set memory 100m
cap log close

use "$mypath\Overview_Aufbereitet.dta", clear
log using "$mypath\Tables\Logs\TableCreativeTransfer.log", replace
drop if treatment == 4

foreach i in 1 2 3{
	sum transfer`i' if treatment_id == 41
	gen std_transfer`i' = (transfer`i' - `r(mean)')/`r(sd)'
}

eststo clear

eststo: reg std_transfer2 gift_transfer std_transfer1 if creative_trans == 1, robust
eststo: reg std_transfer2 gift_transfer std_transfer1 $controls if creative_trans == 1, robust

#delimit; // #delimit: command resets the character that marks the end of a command, here ;

esttab using "$mypath\Tables\Output\Table_DiscretionaryTransfer_Effects.tex", 
	nomtitles	
	label	   
	varlabel (_cons "Intercept" std_transfer1 "Baseline Transfer" gift_transfer "Gift" )
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
	"\setlength\tabcolsep{6pt}"
	"\caption{Creative Task with Discretionary Transfers}"
	
	"\begin{center}%" 
	"{\small\renewcommand{\arraystretch}{1.2}%" 
	"\begin{tabular}{lcc}" 
	"\hline\hline\noalign{\smallskip}"
	" & \multicolumn{2}{c}{\bf Amount Transferred} \\"
	" & I & II \\")
	posthead("\hline\noalign{\smallskip}") 
	prefoot("\hline"
	" Controls & NO & YES \\"
	"\hline" ) 
	postfoot("\hline\hline\noalign{\medskip}"
	"\end{tabular}"
	"\begin{minipage}{\textwidth}"
	"\footnotesize {\it Note:} This table reports the results from the supplementary Creative Task with Discretionary Transfer treatments. "
	"In these treatments (Control and Gift), agents learned how many points (how much output) they had generated for the principal in the previous round and could then decide how many of these points to transfer to the principal. "
	"This procedure contrasts with the main experiment in that in the main experiment the output of the agents was automatically transferred to the principal as profit. "
	"This table reports the estimated OLS coefficients from a regression of standardized amount transferred in Period 2 on an indicator for \textit{Gift} treatment and standardized amount transferred in Period 1. " 
	"The treatment dummy \textit{Gift} captures the effect of an unconditional wage gift on the standardized amount transferred back to the principal. \\"
	"The estimation includes all agents from the Discretionary Transfer -- Control group as well as agents from the Discretionary Transfer -- Gift group where the principal decided to implement the gift. Agents whose principals chose not to implement the gift are not included in this analysis. "
	"$controls_list "
	"$errors_stars "
	"\end{minipage}}"
	"\end{center}"
	"\label{tab:Discretionary}"
	"\end{table}")
	replace;
			
#delimit cr	// #delimit cr: restore the carriage return delimiter inside a file
