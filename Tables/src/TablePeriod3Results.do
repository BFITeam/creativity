clear all
set more off
set memory 100m
cap log close

use "$mypath\Overview_Aufbereitet.dta", clear
log using "$mypath\Tables\Logs\TablePeriod3Results.log", replace
drop if treatment == 4

eststo clear

//Slider I
eststo: reg ztransfer3 gift turnier ztransfer1 $controls if slider == 1, robust

//Slider II 
gen winner = turnier == 1 & bonus_recvd == 1
gen loser = turnier == 1 & bonus_recvd == 0

eststo: reg ztransfer3 gift winner loser ztransfer1 $controls if slider == 1, robust

//Creative III
eststo: reg ztransfer3 gift turnier creative_trans gift_transfer ztransfer1 $controls if creative == 1 | creative_trans == 1, robust

//Creative IV
eststo: reg ztransfer3 gift winner loser creative_trans gift_transfer ztransfer1 $controls if creative == 1 | creative_trans == 1, robust

#delimit ;
esttab using "$mypath\Tables\Output\Appendix\Period3_Results_Automated.tex", // esttab produces a pretty-looking publication-style regression table from stored estimates without much typing (alternative zu estout)
	nomtitles	// Options: mtitles (model titles to appear in table header)
	label	   // label (make use of variable labels)
	varlabel (_cons "Intercept" ztransfer1 "Baseline" zeffort1 "Baseline" gift "Gift" turnier "Tournament" winner "Tournament Winner" loser "Tournament Loser" creative_trans "Discretionary Transfer" gift_transfer "Discretionary Transfer x Gift"
	, elist(_cons "[2mm]" zeffort1 "[2mm]" gift "[2mm]" turnier "[2mm]" feedback "[2mm]" giftXslid "[2mm]" turnXslid "[2mm]" feedXslid "[2mm]" zeffort1Xslid "[2mm]" ztransfer1 "[2mm]" ztransfer1Xslid "[2mm]"))
	starlevels(* .10 ** 0.05 *** .01) 														
	stats(N r2, fmt(%9.0f %9.3f) labels("Observations"  "\$R^2$"))	// stats (specify statistics to be displayed for each model in the table footer), fmt() (
	b(%9.3f)
	se(%9.3f)
    drop (_cons ztransfer1 $controls)
	order(turnier gift creative_trans gift_transfer winner loser)
	fragment
	style(tex) 
	substitute(\_ _)
	nonumbers 
	prehead(
	"\begin{table}[h]%" 
	"\setlength\tabcolsep{2pt}"
	"\caption{Treatment Effects in Period 3}"
	
	"\begin{center}%" 
	"{\small\renewcommand{\arraystretch}{1}%" 
	"\begin{tabular}{lcccc}" 
	"\hline\hline\noalign{\smallskip}"
	" & \multicolumn{2}{c}{\bf Slider} & \multicolumn{2}{c}{\bf Creative} \\" 
	" & I & II & III & IV \\")
	posthead("\hline\noalign{\smallskip}") 
	prefoot("\noalign{\smallskip}\hline"
	" Controls  & YES & YES & YES & YES \\"
	" Baseline  & YES & YES & YES & YES \\"
	" Intercept & YES & YES & YES & YES \\"
	"\hline" ) 
	postfoot(
	"\hline\hline\noalign{\medskip}"
	"\end{tabular}"
	"\begin{minipage}{\textwidth}"
	"\footnotesize {\it Note:} This table reports the estimated OLS coefficients in Period 3. " 
	"The analysis follows the set-up laid out in Equation 1, with the exception that we estimate the equation separately for both tasks here. "
	"$pooled_trans_description "
	"The treatment dummies \textit{Gift} and \textit{Tournament} capture the effect of an unconditional monetary gift or of a tournament incentive (rewarding the top 2 performers out of 4 agents) on standardized performance. " 
	"The \textit{Discretionary Transfer} coefficent captures any difference between the Creative Task with Discretionary Transfer -- Control group and the Control group in the creative task. "
	"The \textit{Discretionary Transfer x Gift} coefficient captures the effect of an unconditional monetary gift on the standardized amount transfered to the principal. "
	"That is, the estimated effect of allowing discretionary transfers and offering a monetary gift in the creative task is equal to sum of the \textit{Discretionary Transfer x Gift} coefficient and the \textit{Discretionary Transfer} coefficient. \\"
	"$sample_description "
	"$controls_list "
	"$errors_stars "
	"\end{minipage}}"
	"\end{center}"
	"\label{tab:Period3}"
	"\end{table}")
	replace;
			
#delimit cr	// #delimit cr: restore the carriage return delimiter inside a file

log close

