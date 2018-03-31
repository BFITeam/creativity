clear all
set more off
set memory 100m
cap log close

use "$mypath\Overview_Aufbereitet.dta", clear
log using "$mypath\Tables\Logs\Table_Creativity_Breakdown.log", replace
drop if treatment == 4

* Regressions for Table 6 * 

* gen rates
foreach var in original flex{
	foreach time in 1 2 3 {
		gen `var'_rate`time' = p_`var'`time' / p_valid`time'
		//sum `var'_rate`time' if creative == 1 & treatment_id2 == "creative_control"
		//replace `var'_rate`time' = (`var'_rate`time' - `r(mean)')/`r(sd)'
	}
}

eststo clear

//level regressions
eststo: reg zeffort2 turnier gift zeffort1 			$controls if creative==1, robust
eststo: reg zp_valid2 turnier gift zp_valid1 		$controls if creative==1, robust
eststo: reg zp_flex2 turnier gift zp_flex1 			$controls if creative==1, robust
eststo: reg zp_original2 turnier gift zp_original1 	$controls if creative==1, robust

//rate regressions
eststo: reg flex_rate2 turnier gift flex_rate1 			$controls if creative==1, robust
eststo: reg original_rate2 turnier gift original_rate1 	$controls if creative==1, robust


tabstat zp_valid2 if creative == 1, by(treatment_id2) stat(mean median n)
tabstat zp_flex2 if creative == 1, by(treatment_id2) stat(mean median n)
tabstat zp_original2 if creative == 1, by(treatment_id2) stat(mean median n)
tabstat flex_rate2 if creative == 1, by(treatment_id2) stat(mean median n)
tabstat original_rate2 if creative == 1, by(treatment_id2) stat(mean median n)

//raw correlations
capture log close
log using "$mypath\Tables\Logs\valid_rate_correlations.txt", text replace
reg flex_rate1 p_valid1 $controls if creative == 1 , robust
reg original_rate1 p_valid1 $controls if creative == 1 & control == 1, robust
capture log close
log using "$mypath\Tables\Logs\Table_Creativity_Breakdown.log", append

//top answers
preserve
insheet using "$mypath\raw_data\r_data\steveidea.txt", clear tab
keep id antonia*
*tostring id, replace
tempfile topanswers
save `topanswers'
restore
destring id, replace
count
merge 1:m id using `topanswers', keep(match master) 
count
eststo: reg antoniatop30r2 turnier gift antoniatop30r1 $controls if creative==1, robust

//invalid uses
gen p_invalid1 = answers1 - p_valid1	
gen p_invalid2 = answers2 - p_valid2
eststo: reg p_invalid2 turnier gift p_invalid1 $controls if creative==1, robust

//check # of "best" ideas and proportion of "best" ideas
gen total_top = antoniatop30r2 + antoniatop30r1
gen total_p12 = p_valid2 + p_valid1

//tabstat total_top total_p12 if creative == 1, stat(sum)

log close

local intercept_row Constant 
local controls_row Additional Controls
local tab_cols l

local num_regs 8
forvalues i = 1/`num_regs'{
	local tab_cols `tab_cols'c
	local intercept_row `intercept_row' & YES
	local controls_row `controls_row' & YES
}

#delimit; // #delimit: command resets the character that marks the end of a command, here ;
esttab using "$mypath\Tables\Output\Table_Creativity_Breakdown.tex", 
	label	   // label (make use of variable labels)
	nomtitles
	rename(zeffort1 "Period1" zp_valid1 "Period1" zp_flex1 "Period1" zp_original1 "Period1" flex_rate1 "Period1" original_rate1 "Period1" antoniatop30r1 "Period1" p_invalid1 "Period1")
	varlabels("Period1" "Period 1 Output" _cons Constant turnier "Performance Bonus")
	starlevels(* .10 ** 0.05 *** .01) 														
	stats(N r2, fmt(%9.0f %9.3f) labels("Observations"  "\$R^2$"))	// stats (specify statistics to be displayed for each model in the table footer), fmt() (
	b(%9.3f)
	se(%9.3f)
	drop($controls)
	nonumbers
	substitute(\' ')
	fragment
	replace
	prehead("\begin{landscape}"
	"\begin{table}[h]%" 
	"\captionsetup{justification=centering}"
	"\setlength\tabcolsep{2pt}"
	"\caption{Dimensions of Creativity: Treatment Effects on Output in Period 2}"
	"\label{tab:CreativityBreakdown}"
	"\begin{center}%" 
	"{\small\renewcommand{\arraystretch}{1}%" 
	"\begin{tabular}{`tab_cols'}" 
	"\hline\hline\noalign{\smallskip}"
	" & \multicolumn{`num_regs'}{c}{\textbf{Creative Task}} \\"
	" & \textit{Score} & \textit{Validity} & \textit{Flexibility} & \textit{Originality} & \textit{Flexibility} & \textit{Originality} & \textit{Best} & \textit{Invalid} \\"
	" &					& 					&						&					&	\textit{Rate}		&	\textit{Rate}		&	\textit{Answers}		&	\textit{Answers} \\" 
	" & I & II & III & IV & V & VI & VII & VIII \\")
	prefoot(
	"\midrule"
	" `controls_row' \\"
	"\midrule" ) 
	postfoot("\hline\hline\noalign{\medskip}"
	"\end{tabular}}"
	"\begin{minipage}{\textwidth}"
	"\footnotesize {\it Note:} This table reports the estimated OLS coefficients from Equation \ref{eq:reg} using only observations from the creative task. "
	"$treatment_coef_description "
	"The dependent variable in Column I is the standardized creativity score in Period 2. "
	"Please refer to section $creative_score_section for a description of the scoring procedure. "
	"In Columns II, III, and IV, the dependent variables are the three different standardized subdimensions of the creativity score (validity, flexibility, and originality). "
	"Columns V and VI display treatment effects on the unstandardized flexibility and originality rate. "
	"The flexibility (originality) rate equals flexibility (originality) points divided by the number of validity points. Subjects with zero valid answers are dropped from these two regressions. "
	"Column VII reports the results for a subjective assessment of idea quality (unstandardized). To create this variable, an evaluator blind to the treatments was instructed to indicate for each idea whether they considered it to be a ``best$close_latex_quote or ``outstanding$close_latex_quote idea. "
	"Column VIII reports results for the number of invalid uses (unstandardized). \\"
	"$sample_description "
	"$controls_list "
	"$errors_stars "
	"\end{minipage}"
	"\end{center}"
	"\end{table}"
	"\end{landscape}");
#delimit cr



log using "$mypath\Tables\Logs\Creativity_Breakdown_nocontrols.log", replace

//level regressions
reg zeffort2 turnier gift zeffort1 			if creative==1, robust
reg zp_valid2 turnier gift zp_valid1 		if creative==1, robust
reg zp_flex2 turnier gift zp_flex1 			if creative==1, robust
reg zp_original2 turnier gift zp_original1 	if creative==1, robust

//rate regressions
reg flex_rate2 turnier gift flex_rate1 			if creative==1, robust
reg original_rate2 turnier gift original_rate1 	if creative==1, robust

//top answers
reg antoniatop30r2 turnier gift antoniatop30r1 if creative==1, robust

//invalid uses
reg p_invalid2 turnier gift p_invalid1 if creative==1, robust


tabstat score1 , by(treatment_id2) stat(mean)
tabstat p_valid1 , by(treatment_id2) stat(mean)
tabstat p_invalid1 , by(treatment_id2) stat(mean)
tabstat p_valid1 , by(treatment_id2) stat(mean)

log close

log using "$mypath\Tables\Logs\Creativity_Dimensions_Means.log", replace

use "$mypath\Overview_Aufbereitet.dta", clear
drop if treatment == 4

//gen 1<%<8 number, the unusual uses but not very unusual (1 to 8% original)
gen original_uu1 = p_original1 - 2*original_1_1
gen original_uu2 = p_original2 - 2*original_2_1
gen original_vu1 = original_1_1
gen original_vu2 = original_2_1

gen p_invalid1 = answers1 - p_valid1	
gen p_invalid2 = answers2 - p_valid2

rename turnier tournament

foreach time in 1 2 {
	foreach cutoff in 1 5 10{
		cap gen original_`cutoff'_`time' = original_`time'_`cutoff'
	}
}

cap program drop creative_means
program define creative_means, rclass
	args treat time
	local format %3.2f
	if("`treat'" == "control") local group Control
	else if("`treat'" == "tournament") local group Tournament
	else if("`treat'" == "gift") local group Gift
	
	
	local line `time' 
	foreach var in p_valid p_flex p_original p_invalid original_10_ original_5_ original_1_ {
		sum `var'`time' if `treat' == 1 & creative == 1
		local `var' = r(mean)
	}
	
	return local line "`group' & `time' & " `format' (`p_valid') " & " `format' (`p_flex') " & " `format' (`p_original') " & " `format' (`p_invalid') " & " `format' (`original_10_')  " & " `format' (`original_5_')  " & " `format' (`original_1_') " \\"
end

foreach treat in control tournament gift{
	foreach time in 1 2 {
		creative_means `treat' `time'
		local `treat'`time' `r(line)'
	}
}


file open f using "$mypath\Tables\Output\Referees\Creativity_Dimensions_Means.tex", write replace
#delimit ;
file write f 
	"\begin{landscape}" _n
	"\begin{table}[h]%" _n
	"\setlength\tabcolsep{2pt}"
	"\caption{Creativity Subimension Means}" _n
	"\label{CreativityDimensionsMeans}" _n
	"\begin{center}%" _n
	"{\small\renewcommand{\arraystretch}{1}%" _n
	"\begin{tabular}{lcccccccc}" _n
	"\hline\hline\noalign{\smallskip}" _n
	" \bf Treatment & \bf Period &  \bf Validity & \bf Flexibility & \bf Originality & \bf Invalid & \bf Original Answers & \bf Original Answers & \bf Original Answers \\" _n
	" 				& 			&  				& 					&				& \bf Uses 	& \bf 10\% Cutoff & \bf 5\% Cutoff & \bf 1\% Cutoff \\" _n	
	"\hline" _n
	"\noalign{\smallskip}" _n
	"`control1'" _n
	"`control2'" _n
	"`tournament1'" _n
	"`tournament2'" _n
	"`gift1'" _n
	"`gift2'" _n
	"\hline\hline\noalign{\medskip}" _n
	"\end{tabular}}" _n
	"\begin{minipage}{1.4\textwidth}" _n
	"\footnotesize {\it Note:} This table reports mean values by treatment and period for various dimensions of the creativity score."  _n
	"Validity, Flexibility, and Originality are the subdimensions of the creativity score. " _n
	"The Original Answers columns report the number of answers the participants gave that were also given by fewer than 10/5/1\% of other participants. " _n 
	"$sample_description_nonreg " _n
	"\end{minipage}" _n
	"\end{center}" _n
	"\end{table}" _n
	"\end{landscape}" _n;
#delimit cr
file close f


//make new originality scores
gen original_o10_v5_1 = original_1_10 + original_1_5
gen original_o10_v5_2 = original_2_10 + original_2_5

gen original_o10_v1_1 = original_1_10 + original_1_1
gen original_o10_v1_2 = original_2_10 + original_2_1

gen original_o5_v1_1 = original_1_5 + original_1_1
gen original_o5_v1_2 = original_2_5 + original_2_1

//make new originality rates
foreach time in 1 2{
	foreach var in original_o10_v5 original_o10_v1 original_o5_v1 {
		gen `var'_`time'_rate = `var'_`time'/p_valid`time'
	}
}

//standardize orginality variables
foreach time in 1 2{
	//raw originality counts
	foreach cutoff in 1 5 10{
		sum original_`time'_`cutoff' if creative == 1 & control == 1
		gen zoriginal_`time'_`cutoff' = (original_`time'_`cutoff' - r(mean))/r(sd)
	}
	//originality scores
	foreach o in 5 10{
		foreach v in 1 5{
			capture sum original_o`o'_v`v'_`time' if creative == 1 & control == 1
			capture gen zoriginal_o`o'_v`v'_`time' = (original_o`o'_v`v'_`time' - r(mean))/r(sd)
		}
	}
}



//regressions w/o valid2 
eststo clear
reg p_flex2 tournament gift p_flex1 $controls if creative == 1, robust
reg p_original2 tournament gift p_original1 $controls if creative == 1, robust

reg original_2_10 tournament gift original_1_10 $controls if creative == 1, robust
reg original_2_5 tournament gift original_1_5 $controls if creative == 1, robust

//eststo: reg original_o10_v5_2 tournament gift original_o10_v5_1 $controls if creative == 1, robust
eststo: reg original_o10_v1_2 tournament gift original_o10_v1_1 $controls if creative == 1, robust
eststo: reg original_o5_v1_2 tournament gift original_o5_v1_1 $controls if creative == 1, robust
eststo: reg original_2_1 tournament gift original_1_1 $controls if creative == 1, robust

reg invalid2 tournament gift invalid1 $controls if creative == 1, robust

eststo: reg original_o10_v5_2_rate tournament gift original_o10_v5_1_rate $controls if creative == 1, robust
eststo: reg original_o10_v1_2_rate tournament gift original_o10_v1_1_rate $controls if creative == 1, robust
eststo: reg original_o5_v1_2_rate tournament gift original_o5_v1_1_rate $controls if creative == 1, robust


local intercept_row Constant 
local controls_row Additional Controls
local tab_cols l

local num_regs 6
forvalues i = 1/`num_regs'{
	local tab_cols `tab_cols'c
	local intercept_row `intercept_row' & YES
	local controls_row `controls_row' & YES
}

#delimit; // #delimit: command resets the character that marks the end of a command, here ;
esttab using "$mypath\Tables\Output\Referees\Creativity_Valid_Robustness.tex", 
	label	   // label (make use of variable labels)
	nomtitles
	rename(effort1 "Period1" p_valid1 "Period1" p_flex1 "Period1" p_original1 "Period1" flex_rate1 "Period1" original_1_10 "Period1" original_1_5 "Period1" original_1_1 "Period1" invalid1 "Period1" ///
			original_o5_v1_1 "Period1" original_o10_v1_1 "Period1" original_o10_v5_1 "Period1" original_o5_v1_1_rate "Period1" original_o10_v1_1_rate "Period1" original_o10_v5_1_rate "Period1")
	varlabels("Period1" "Period 1 Output" _cons Constant tournament "Performance Bonus")
	starlevels(* .10 ** 0.05 *** .01) 														
	stats(N r2, fmt(%9.0f %9.3f) labels("Observations"  "\$R^2$"))	// stats (specify statistics to be displayed for each model in the table footer), fmt() (
	b(%9.3f)
	se(%9.3f)
	drop($controls _cons)
	nonumbers
	fragment
	replace
	prehead(	
		"\begin{landscape}" 
		"\begin{table}[h]%" 
		"\setlength\tabcolsep{2pt}"
		"\caption{Treatment Effects on Originality - Different Originality Rating Cutoffs}" 
		"\label{tab:CreativityRobustness}" 
		"\begin{center}%"  
		"{\small\renewcommand{\arraystretch}{.9}%"  
		"\begin{tabular}{`tab_cols'}"  
		"\hline\hline\noalign{\smallskip}" 
		" & \bf Originality Score & \bf Originality Score & \bf Originality Score & \bf Originality Rate & \bf Originality Rate & \bf Originality Rate \\" 
		" & \bf 10\% Cutoff       & \bf 5\% Cutoff 		  & \bf 1\% Cutoff 		  & \bf 10\% Cutoff		 & \bf 5\% Cutoff		& \bf 1\% Cutoff \\" 	
		"\hline"  
		"\noalign{\smallskip}" )
	posthead("")
	prefoot(
	"\midrule"
	" `controls_row' \\"
	"\midrule" )
	postfoot(
		"\hline\hline\noalign{\medskip}" 
		"\end{tabular}}" 
		"\begin{minipage}{\textwidth}" 
		"\footnotesize {\it Note:} The table reports OLS estimates of treatment effects on originality scores. " 
		"The originality score used in the main analysis is taken from the Torrence Test of Creative Thinking and awards 1 point for every answer that was given by less than 8\% of other participants and one additional bonus point for answers that were given by less than 1\% of other participants. "
		"In this table, the 8\% cutoff was varied to be either 10\%, 5\%, or 1\%. " 
		"The first three columns use the standardized originality score as the dependent variable. " 
		"The last three columns present the originality rate. "  
		"The rate controls for the number of valid answers given and was created by dividing the raw originality score by the number of valid answers given in each period. \\" 
		"$sample_description " 
		"$controls_list " 
		"$errors_stars " 
		"\end{minipage}" 
		"\end{center}" 
		"\end{table}" 
		"\end{landscape}");
#delimit cr
/*
//regressions w/ valid2
eststo clear
eststo: reg p_flex2 tournament gift p_flex1 p_valid2 $controls if creative == 1, robust
eststo: reg p_original2 tournament gift p_original1 p_valid2 $controls if creative == 1, robust

reg original_2_10 tournament gift original_1_10 p_valid2 $controls if creative == 1, robust
reg original_2_5 tournament gift original_1_5 p_valid2 $controls if creative == 1, robust

//eststo: reg original_o10_v5_2 tournament gift original_o10_v5_1 p_valid2 $controls if creative == 1, robust
eststo: reg original_o10_v1_2 tournament gift original_o10_v1_1 p_valid2 $controls if creative == 1, robust
eststo: reg original_o5_v1_2 tournament gift original_o5_v1_1 p_valid2 $controls if creative == 1, robust
eststo: reg original_2_1 tournament gift original_1_1 p_valid2 $controls if creative == 1, robust

eststo: reg invalid2 tournament gift invalid1 p_valid2 $controls if creative == 1, robust

eststo: reg original_o10_v5_2_rate tournament gift original_o10_v5_1_rate $controls p_valid2 if creative == 1, robust
eststo: reg original_o10_v1_2_rate tournament gift original_o10_v1_1_rate $controls p_valid2 if creative == 1, robust
eststo: reg original_o5_v1_2_rate tournament gift original_o5_v1_1_rate $controls p_valid2 if creative == 1, robust

#delimit; // #delimit: command resets the character that marks the end of a command, here ;
esttab using "$mypath\Tables\Output\Creativity_YesValid.tex", 
	label	   // label (make use of variable labels)
	nomtitles
	rename(effort1 "Period1" p_valid1 "Period1" p_flex1 "Period1" p_original1 "Period1" flex_rate1 "Period1" original_1_10 "Period1" original_1_5 "Period1" original_1_1 "Period1" invalid1 "Period1" ///
	original_o5_v1_1 "Period1" original_o10_v1_1 "Period1" original_o10_v5_1 "Period1" original_o5_v1_1_rate "Period1" original_o10_v1_1_rate "Period1" original_o10_v5_1_rate "Period1")
	varlabels("Period1" "Period 1 Output" _cons Constant tournament Tournament p_valid2 "Valid Period 2")
	starlevels(* .10 ** 0.05 *** .01) 														
	stats(N r2, fmt(%9.0f %9.3f) labels("Observations"  "\$R^2$"))	// stats (specify statistics to be displayed for each model in the table footer), fmt() (
	b(%9.3f)
	se(%9.3f)
	drop($controls _cons)
	nonumbers
	fragment
	replace
	prehead("\bf Panel 2 & & & & \\")
	posthead("\noalign{\smallskip}")
	prefoot(
	"\hline"
	" `controls_row' \\"
	"\hline" ); 
#delimit cr



file open f using "$mypath\Tables\Output\Referees\Creativity_Valid_Robustness.tex", write replace
#delimit ;
file write f 
	"\begin{landscape}" _n
	"\begin{table}[h]%" _n
	"\setlength\tabcolsep{2pt}"
	"\caption{Treatment Effects on Originality - Different Originality Rating Cutoffs}" _n
	"\begin{center}%"  _n
	"{\small\renewcommand{\arraystretch}{.9}%"  _n
	"\begin{tabular}{`tab_cols'}"  _n
	"\hline\hline\noalign{\smallskip}" _n
	" & \bf Originality Score & \bf Originality Score & \bf Originality Score & \bf Originality Rate & \bf Originality Rate & \bf Originality Rate \\" _n
	" & \bf 10\% Cutoff       & \bf 5\% Cutoff 		  & \bf 1\% Cutoff 		  & \bf 10\% Cutoff		 & \bf 5\% Cutoff		& \bf 1\% Cutoff \\" _n	
	"\hline"  _n
	"\noalign{\smallskip}" _n
	"\input{Tables/Output/Creativity_NoValid.tex}" _n
	"\hline\hline\noalign{\medskip}" _n
	"\end{tabular}}" _n
	"\begin{minipage}{\textwidth}" _n
	"\footnotesize {\it Note:} The table reports OLS estimates of treatment effects on standardized originality scores. " _n
	"The originality score used in the main analysis is taken from the Torrence Test of Creative Thinking and awards 1 point for every answer that was given by less than 8\% of other participants and one additional bonus point for answers that were given by less than 1\% of other participants. "
	"In this table, the 8\% cutoff was varied to be either 10\%, 5\%, or 1\%. " _n
	"The first three columns use the standardized originality score as the dependent variable. " _n
	"The last three columns present the originality rate. " _n 
	"The rate controls for the number of valid answers given and was created by dividing the raw originality score by the number of valid answers given in each period. \\" _n
	"$sample_description " _n
	"$controls_list " _n
	"$errors_stars " _n
	"\end{minipage}" _n
	"\end{center}" _n
	"\end{table}" _n
	"\end{landscape}" _n;
#delimit cr
file close f
*/
log close
