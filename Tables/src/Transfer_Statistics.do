clear all
set more off
set memory 100m
cap log close

use "$mypath\Overview_Aufbereitet.dta", clear
drop if treatment == 4

log using "$mypath\Tables\Logs\Transfer_Stats.log", replace

//in-text calculations
gen transferdif = transfer2 - transfer1
//dif between period 1 and 2 for gift
ttest transferdif = 0 if creative_trans == 1 & gift_transfer == 1
//dif between control and gift
ranksum transferdif if creative_trans == 1, by(gift_transfer )
ttest transferdif if creative_trans == 1, by(gift_transfer )

/*
eststo clear
eststo: reg ztransfer2 gift_transfer ztransfer1 if creative_trans == 1, robust
eststo: reg zscore2 gift_transfer zscore1 if creative_trans == 1, robust
//eststo: reg transfer2 gift transfer1, robust

//output high-level regressions
#delimit ;
esttab using "$mypath\Tables\Output\Referees\Transfer_Breakdown.tex", replace
	nomtitles	
	label	   
	rename(zscore1 baseline ztransfer1 baseline transfer1 baseline)
	varlabel (_cons "Constant" baseline "Period 1 Output" gift_transfer "Gift" )
	starlevels(* .10 ** 0.05 *** .01) 														
	stats(N r2, fmt(%9.0f %9.3f) labels("Observations"  "\$R^2$"))	// stats (specify statistics to be displayed for each model in the table footer), fmt() (
	b(%9.3f)
	se(%9.3f)
    drop ( )
	fragment
	style(tex) 
	substitute(\_ _)
	nonumbers 
	prehead(
	"\begin{table}[h]%" 
	"\setlength\tabcolsep{2pt}"
	"\caption{Treatment Effects in Creative Task with Discretionary Transfer}"
	"\begin{center}%" 
	"{\small\renewcommand{\arraystretch}{1}%" 
	"\begin{tabular}{lcc}" 
	"\hline\hline\noalign{\smallskip}"
	" & \bf Standardized Transfer & \bf Standardized Effort \\"
	" & \bf Period 2 & \bf Period 2 \\"
	)
	prefoot("\hline"
	"\noalign{\smallskip}"
	"Controls & NO & NO  \\"
	"\hline"
	"\noalign{\smallskip}")
	postfoot("\hline\hline\noalign{\medskip}"
	"\end{tabular}}"
	"\begin{minipage}{\textwidth}"
	"\footnotesize {\it Note:} This table reports OLS estimates of treatment effects in the Creative Task with Discretionary Transfers. " 
	"$ctdt_description "
	"Standardized Transfered is the amount transferred back to the principal. "
	"$creative_description "
	"Standardized Effort Period 2 refers to this outcome metric. "
	"Basline refers to the value of the dependent variable in Period 1. \\"
	"$Gift_sample_description "
	"$errors_stars "
	"\end{minipage}"
	"\end{center}"
	"\end{table}");
#delimit cr
*/
bysort gift_transfer: summarize score1
bysort gift_transfer: summarize score2

//summary stats by if transfered maximum
gen p1_max_trans = effort1 == transfer1 & effort1 != 0 if creative_trans == 1
gen p2_max_trans = effort2 == transfer2 & effort1 != 0 if creative_trans == 1

gen pct_trans1 = transfer1/effort1 * 100 if creative_trans == 1
//replace pct_trans1 = 0 if effort1 == 0
gen pct_trans2 = transfer2/effort2 * 100 if creative_trans == 1
//replace pct_trans2 = 0 if effort2 == 0
sum pct_trans1 if pct_trans1 != 100 & effort1 != 0

local space_amt 15

cap program drop summary_row
program define summary_row, rclass
	local space_amt 15
	if ("`3'" == "") local format %4.1f
	else if ("`3'" == "percent"){
		local format %4.0f
		local sign "\%"
	}
	if ("`2'" == "Observations"){
		local format %4.0f
		sum `1' if gift_transfer == 0 & creative_trans == 1
		local scaler_c = 1/r(mean)*r(N)
		sum `1' if gift_transfer == 1 & creative_trans == 1
		local scaler_g = 1/r(mean)*r(N)
		
	}
	else {
		local scaler_c = 1
		local scaler_g = 1
	}

	sum `1' if gift_transfer == 0 & creative_trans == 1
	local c = r(mean)*`scaler_c'
	
	sum `1' if gift_transfer == 1 & creative_trans == 1
	local g = r(mean)*`scaler_g'
	
	sum `1' if gift_transfer == 0 & p1_max_trans == 1 & creative_trans == 1
	local c_max = r(mean)
	
	sum `1' if gift_transfer == 1 & p1_max_trans == 1 & creative_trans == 1
	local g_max = r(mean)
	
	sum `1' if gift_transfer == 0 & p1_max_trans == 0 & creative_trans == 1
	local c_not_max = r(mean)
	
	sum `1' if gift_transfer == 1 & p1_max_trans == 0 & creative_trans == 1
	local g_not_max = r(mean)
	
	local row " `2' & " `format' (`c') "`sign' & " `format' (`g') "`sign' && \hspace{`space_amt'pt} " `format' (`c_max') "`sign' & " `format' (`g_max') "`sign' && \hspace{`space_amt'pt} " `format' (`c_not_max') "`sign' & " `format' (`g_not_max') "`sign' \\"  
	return local row `row'
end 

summary_row effort1 "Output Period 1"
local effort1_row `r(row)'
summary_row effort2 "Output Period 2"
local effort2_row `r(row)'

summary_row transfer1 "Transfer Period 1"
local transfer1_row `r(row)'
summary_row transfer2 "Transfer Period 2"
local transfer2_row `r(row)'

summary_row pct_trans1 "Percentage of Output " percent
local pct_trans1_row `r(row)'
summary_row pct_trans2 "Percentage of Output " percent
local pct_trans2_row `r(row)'

gen trans_treat_split = ""
replace trans_treat_split = "max_control" if gift_transfer == 0 & p1_max_trans == 1 & creative_trans == 1
replace trans_treat_split = "max_gift" if gift_transfer == 1 & p1_max_trans == 1 & creative_trans == 1
replace trans_treat_split = "min_control" if gift_transfer == 0 & p1_max_trans == 0 & creative_trans == 1
replace trans_treat_split = "min_gift" if gift_transfer == 1 & p1_max_trans == 0 & creative_trans == 1

bysort trans_treat_split : gen counter = _N
summary_row counter "Observations"
local count_row `r(row)'
di "`count_row'"

/*
bysort gift : sum score1
bysort gift : sum score2
bysort gift : sum transfer1
bysort gift : sum transfer2
bysort gift_transfer : sum pct_trans1
bysort gift_transfer : sum pct_trans2

gen trans_treat_split = ""
replace trans_treat_split = "max_control" if gift_transfer == 0 & p1_max_trans == 1
replace trans_treat_split = "max_gift" if gift_transfer == 1 & p1_max_trans == 1
replace trans_treat_split = "min_control" if gift_transfer == 0 & p1_max_trans == 0
replace trans_treat_split = "min_gift" if gift_transfer == 1 & p1_max_trans == 0


bysort trans_treat_split : sum score1
bysort trans_treat_split : sum score2

bysort trans_treat_split : sum transfer1
bysort trans_treat_split : sum transfer2

bysort trans_treat_split : sum pct_trans1
bysort trans_treat_split : sum pct_trans2
*/
cap file close f
file open f using "$mypath\Tables\Output\Appendix\Transfer_summary_stats.tex", write replace

#delimit ;
file write f 
	"\begin{table}[h]%" _n
	"\captionsetup{justification=centering}" _n
	"\setlength\tabcolsep{2pt}" _n
	"\caption{Summary Statistics by Amount Transferred in the Creative task with Discretionary Transfers Treatments}" _n
	"\label{tab:TransferStats}" _n
	"\begin{center}%"  _n
	"{\small\renewcommand{\arraystretch}{1}%"  _n
	"\begin{tabular}{lcccccccc}"  _n
	"\hline\hline\noalign{\smallskip}" _n
	" \bf 		 	& \multicolumn{2}{c}{\bf All Agents} && \multicolumn{2}{c}{\bf Agents who do transfer all} && \multicolumn{2}{c}{\bf Agents who do not transfer all} \\" _n
	" 				& \multicolumn{2}{c}{} && \multicolumn{2}{c}{\bf of their output in Period 1} && \multicolumn{2}{c}{\bf of their output in Period 1} \\" _n
	"\cline{2-3} \cline{5-6} \cline{8-9}"  _n
	"				& \bf Control & \bf Gift && \bf \hspace{`space_amt'pt} Control & \bf Gift && \hspace{`space_amt'pt}  \bf Control & \bf Gift \\"
	"\hline"  _n
	"\noalign{\smallskip}" _n
	"`effort1_row'" _n
	"`effort2_row'" _n
	"`transfer1_row'" _n
	"`transfer2_row'" _n
	"`pct_trans1_row'" _n
	" Transferred Period 1 & \\" _n
	"`pct_trans2_row'" _n
	" Transferred Period 2 & \\" _n
	"`count_row'" _n
	"\hline\hline\noalign{\medskip}" _n
	"\end{tabular}}" _n
	"\begin{minipage}{\textwidth}" _n
	"\footnotesize {\it Note:} This table reports mean values by treatment and by whether or not the agent transferred all of their output to the principal in Period 1. "  _n
	"$ctdt_description "
	"$ctdt_contrast "
	"Note that the estimations in this table are based on the value of output that was communicated to the agents during the experiment, which relied on originality ratings from our pre-test. " _n 
	"The value of output that we use in our main analysis was calculated using an updated originality rating scale. "
	"\textit{Output} refers to the creativity score in the creative task (please refer to Section $creative_score_section for a description of the scoring procedure in the creative task). "
	"\textit{Transfer} refers to the amount of output that the agent transfers to the principal. " _n
	"Agents with a creativity score of 0 and who, therefore, cannot transfer any amount are included in the final two columns. \\" _n
	"$ctdt_sample  " _n
	"\end{minipage}" _n
	"\end{center}" _n
	"\end{table}" _n;
#delimit cr
file close f

eststo clear
eststo: reg ztransfer2 gift_transfer ztransfer1 if p1_max_trans == 0 & creative_trans == 1, robust
reg ztransfer2 ztransfer1 gift_transfer if p1_max_trans == 0 & creative_trans == 1
estimates store not_max
eststo: reg ztransfer2 gift_transfer ztransfer1 if p1_max_trans == 1 & creative_trans == 1, robust
reg ztransfer2 ztransfer1 gift_transfer if p1_max_trans == 1 & creative_trans == 1
estimates store max


//main regression results
reg ztransfer2 turnier turnXslid gift giftXslid ztransfer1 ztransfer1Xslid $controls if (slider==1 | creative==1)
estimates store main

//main creative transfer results
foreach i in 1 2 3{
	sum transfer`i' if treatment_id == 41
	gen std_transfer`i' = (transfer`i' - `r(mean)')/`r(sd)'
}
reg std_transfer2 gift_transfer std_transfer1 if creative_trans == 1
estimates store main_ctdt

//check equality of various coefficients
suest max not_max, robust
test [max_mean]gift_transfer == [not_max_mean]gift_transfer

suest max main_ctdt, robust
test [max_mean]gift_transfer == [main_ctdt_mean]gift

suest not_max main_ctdt, robust
test [not_max_mean]gift_transfer == [main_ctdt_mean]gift

//output high-level regressions
#delimit ;
esttab using "$mypath\Tables\Output\Appendix\Transfer_by_max_transfer.tex", replace
	nomtitles	
	label	   
	varlabel (_cons "Constant" ztransfer1 "Period 1 Transfer" gift_transfer "Gift" )
	starlevels(* .10 ** 0.05 *** .01) 														
	stats(N r2, fmt(%9.0f %9.3f) labels("Observations"  "\$R^2$"))	// stats (specify statistics to be displayed for each model in the table footer), fmt() (
	b(%9.3f)
	se(%9.3f)
    drop ( )
	fragment
	style(tex) 
	substitute(\_ _)
	nonumbers 
	prehead(
	"\begin{table}[h]%" 
	"\captionsetup{justification=centering}"
	"\setlength\tabcolsep{2pt}"
	"\caption{Treatment Effects in the Creative Task with Discretionary Transfers Treatments on Period 2 Output by Amount Transferred in Period 1}"
	"\label{tab:TransferSplit}"
	"\begin{center}%" 
	"{\small\renewcommand{\arraystretch}{1}%" 
	"\begin{tabular}{lcc}" 
	"\hline\hline\noalign{\smallskip}"
	" & \multicolumn{2}{c}{\bf Standardized Transfer in Period 2} \\"
	"\cline{2-3} "
	" & \bf \hspace{5pt} Agents who do not transfer all \hspace{5pt} & \hspace{5pt} \bf Agents who do transfer all \hspace{5pt} \\"
	" & \bf of their output in Period 1 & \bf of their output in Period 1 \\"
	)
	posthead("\hline\noalign{\smallskip}")
	prefoot("\hline"
	"\noalign{\smallskip}"
	"Additional Controls & NO & NO  \\"
	"\hline"
	"\noalign{\smallskip}")
	postfoot("\hline\hline\noalign{\medskip}"
	"\end{tabular}}"
	"\begin{minipage}{\textwidth}"
	"\footnotesize {\it Note:} This table reports the results from the supplementary \textit{Creative Task with Discretionary Transfer -- Gift} treatment and its associated \textit{Creative Task with Discretionary Transfer -- Control} group. "
	"Regressions are split up by whether agents transferred all of their output in Period 1. "
	"Treatment effects are estimated using the same specification that we used in Table \ref{tab:Discretionary}, Column I. "
	"$ctdt_description "
	"$ctdt_contrast "
	"$ctdt_regression " 
	"$ctdt_gift_coef_description "
	"Agents with a creativity score of 0 and who, therefore, cannot transfer any amount are included in the first column. \\"
	"$ctdt_sample "
	"$errors_stars "
	"\end{minipage}"
	"\end{center}"
	"\end{table}");
#delimit cr

log close
