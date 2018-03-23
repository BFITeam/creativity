clear all
set more off
set memory 100m
cap log close

log using "$mypath\Tables\Logs\TableFeedbackResults.log", replace

use "$mypath\Overview_Aufbereitet.dta", clear

capture program drop calculate_p_value
program define calculate_p_value, rclass
	args beta std_error degrees_of_freedom 

	local p_value =  2*ttail(`degrees_of_freedom',abs(`beta'/`std_error'))
	if `p_value' >.1 						local stars = "none"	
	if `p_value' >.05 & `p_value' <=.1  	local stars = "*"	
	if `p_value' >.01 & `p_value' <=.05 	local stars = "**"
	if `p_value' <=.01  					local stars = "***"

	return local p_value 	`p_value'
	return local stars		`stars'
end

eststo clear
//Period 2
gen feedXcreative = feedback * creative
eststo: reg ztransfer2 feedXslid feedXcreative gift turnier creative_trans giftXtransfer giftXslid turnXslid ztransfer1 ztransfer1Xslid $controls if (slider==1 | creative==1 | creative_trans==1), robust

local p2_slid_beta 	= _b[feedXslid]
local p2_cr_beta 	= _b[feedXcreative]

local p2_slid_se	= _se[feedXslid]
local p2_cr_se		= _se[feedXcreative]

calculate_p_value `p2_slid_beta' `p2_slid_se' e(df_r)
local p2_slid_stars `r(stars)'

calculate_p_value `p2_cr_beta' `p2_cr_se' e(df_r)
local p2_cr_stars `r(stars)'

//Period 3
eststo: reg ztransfer3 feedback gift turnier ztransfer1 $controls if slider == 1, robust
local p3_slid_beta 	= _b[feedback]
local p3_slid_se 	= _se[feedback]
calculate_p_value `p3_slid_beta' `p3_slid_se' e(df_r)
local p3_slid_stars `r(stars)'

eststo: reg ztransfer3 feedback gift turnier creative_trans gift_transfer ztransfer1 $controls if creative == 1 | creative_trans == 1, robust
local p3_cr_beta 	= _b[feedback]
local p3_cr_se 		= _se[feedback]
calculate_p_value `p3_cr_beta' `p3_cr_se' e(df_r)
local p3_slid_stars `r(stars)'

//Period 3 split positive vs negative
gen feedback_neg = feedback == 1 & feedback_pos == 0
gen turnier_win = turnier == 1 & bonus_recvd == 1
gen turnier_lose = turnier == 1 & bonus_recvd == 0
eststo: reg zeffort3 feedback_pos feedback_neg turnier_win turnier_lose gift zeffort1 $controls if slider == 1, robust 
local p3_slid_pos_beta 	= _b[feedback_pos]
local p3_slid_pos_se	= _se[feedback_pos]
calculate_p_value `p3_slid_pos_beta' `p3_slid_pos_se' e(df_r)
local p3_slid_pos_stars `r(stars)'

local p3_slid_neg_beta 	= _b[feedback_neg]
local p3_slid_neg_se	= _se[feedback_neg]
calculate_p_value `p3_slid_neg_beta' `p3_slid_neg_se' e(df_r)
local p3_slid_neg_stars `r(stars)'

eststo: reg ztransfer3 feedback_pos feedback_neg gift turnier_win turnier_lose creative_trans gift_transfer ztransfer1 $controls if creative == 1 | creative_trans == 1, robust
local p3_cr_pos_beta 	= _b[feedback_pos]
local p3_cr_pos_se	= _se[feedback_pos]
calculate_p_value `p3_cr_pos_beta' `p3_cr_pos_se' e(df_r)
local p3_cr_pos_stars `r(stars)'

local p3_cr_neg_beta 	= _b[feedback_neg]
local p3_cr_neg_se	= _se[feedback_neg]
calculate_p_value `p3_cr_neg_beta' `p3_cr_neg_se' e(df_r)
local p3_cr_neg_stars `r(stars)'



cap program drop beta_line
program define beta_line, rclass
	if ("`3'" == "none") local 3 "" 
	if ("`5'" == "none") local 5 "" 
	
	di "`1' & " %4.3f (`2') "`3' & " %4.3f (`4') "`5' \\" 
	return local line "`1' & " %4.3f (`2') "`3' & " %4.3f (`4') "`5' \\" 
end

beta_line "Feedback" `p2_slid_beta' `p2_slid_stars' `p2_cr_beta' `p2_cr_stars'
local p2_beta_line `r(line)'

beta_line "Feedback" `p3_slid_beta' `p3_slid_stars' `p3_cr_beta' `p3_cr_stars'
local p3_beta_line `r(line)'

beta_line "Positive Relative" `p3_slid_pos_beta' `p3_slid_pos_stars' `p3_cr_pos_beta' `p3_cr_pos_stars'
local p3_pos_beta_line `r(line)'

beta_line "Negative Relative" `p3_slid_neg_beta' `p3_slid_neg_stars' `p3_cr_neg_beta' `p3_cr_neg_stars'
local p3_neg_beta_line `r(line)'


cap program drop se_line
program define se_line, rclass
	di "`1' & (" %4.3f (`2') ") & (" %4.3f (`3') ") \\" 
	return local line "`1' & (" %4.3f (`2') ") & (" %4.3f (`3') ") \\" 
end

se_line "Period 2" `p2_slid_se' `p2_cr_se'
local p2_se_line `r(line)'

se_line "Period 3" `p3_slid_se' `p3_cr_se'
local p3_se_line `r(line)'

se_line "Feedback Period 3" `p3_slid_pos_se' `p3_cr_pos_se'
local p3_pos_se_line `r(line)'

se_line "Feedback Period 3" `p3_slid_neg_se' `p3_cr_neg_se'
local p3_neg_se_line `r(line)'

//write output
cap file close f 
file open f using "$mypath/Tables/Output/Appendix/Feedback_Results_Automated.tex", write replace

#delimit ;
file write f 
	"\begin{table}[h]%" _n
	"\setlength\tabcolsep{2pt}" _n
	"\caption{Period 2 and Period 3 Effects of the Feedback Treatment}" _n
	"\begin{center}%" _n
	"{\small\renewcommand{\arraystretch}{1}%" _n
	"\begin{tabular}{lcc}" _n
	"\hline\hline\noalign{\smallskip}" _n
	" & \bf Slider Task & \bf Creative Task \\" _n
	"\hline\noalign{\smallskip}" _n
	"\noalign{\smallskip}" _n
	"`p2_beta_line'" _n
	"`p2_se_line'" _n
	"\noalign{\smallskip}\hline" _n
	"\noalign{\smallskip}" _n
	"`p3_beta_line'" _n
	"`p3_se_line'" _n
	"\noalign{\smallskip}\hline" _n
	"\noalign{\smallskip}" _n
	"`p3_pos_beta_line'" _n
	"`p3_pos_se_line'" _n
	"\noalign{\smallskip}" _n
	"`p3_neg_beta_line'" _n
	"`p3_neg_se_line'" _n	
	"\noalign{\smallskip}\hline" _n
	"\noalign{\smallskip}" _n
	" Controls  & YES & YES \\" _n
	" Baseline  & YES & YES \\" _n
	" Intercept & YES & YES \\" _n
	"\hline\hline\noalign{\medskip}" _n
	"\end{tabular}" _n
	"\begin{minipage}{\textwidth}" _n
	"\footnotesize {\it Note:}  This table reports the estimated OLS coefficients for the Feedback treatment in Periods 2 and 3. "_n
	"$pooled_trans_description " _n
	"Period 3 effects are also presented separately for those agents who learned that they were or were not among the top two performers. " _n
	"Feedback effects for Period 2 are estimated using the same specification that we used in Table \ref{tab:EQ_Pooled_Results}, Column III. " _n
	"For the analysis presented here, we added observations from the two Creative Task with Discretionary Transfers treatments. " _n
	"Post-treatment effects for Period 3 are estimated using the same specifications as presented in Table \ref{tab:Period3} (pooled and split up by positive or negative feedback). " _n
	"For the Period 3 analysis, regressions are done separately for each task. \\" _n
	"$sample_description " _n
	"$controls_list " _n
	"$errors_stars " _n
	"\end{minipage}}" _n
	"\end{center}" _n
	"\label{tab:Feedback}" _n
	"\end{table}";

#delimit cr
file close f

log close
