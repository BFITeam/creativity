


//assert file path is set
assert("$mypath" != "")

//analysis globals
global controls age age2 sex ferienzeit pruefungszeit wiwi recht nawi gewi mannheim

//footnote globals
global creative_score_section 3.1
global pooled_performance_description Output refers to the number of correctly positioned sliders in the simple task and to the creativity score in the creative task (please refer to section $creative_score_section for a description of the scoring procedure in the creative task). 
global pooled_trans_description Output is measured as the number of correctly positioned sliders in the simple task, as the creativity score in the creative task (please refer to section $creative_score_section for a description of the scoring procedure in the creative task), and as the amount transferred in the discretionary transfer task. 

global slider_description In the simple task, agents are evaluated by the number of correctly positioned sliders.
global creative_description In the creative task, agends are evaluated by the creativity score (please refer to section $creative_score_section for a description of the scoring procedure in the creative task). 

global ctdt_description In the supplementary gift treatment and the supplementary control treatment, agents learned how much output they had generated for the principal in the previous round and could then decide how much of that output to transfer to the principal. 
global ctdt_contrast This procedure contrasts with the main experiment in that in the main experiment all of each agent's output was automatically transferred to the principal as payoff. 
global ctdt_gift_coef_description The treatment dummy \textit{Gift} captures the effect of a performance-independent wage gift for all on the standardized amount transferred back to the principal.
global ctdt_sample The estimations include all agents from the \textit{Creative Task with Discretionary Transfers -- Control} group as well as agents from the \textit{Creative Task with Discretionary Transfers -- Gift} treatment group for which the principal decided to implement the gift. Agents whose principals chose not to implement the gift are not included in this analysis.
global ctdt_regression This table reports the estimated OLS coefficients from a regression of the standardized amount transferred in Period 2 on an indicator for \textit{Gift} treatment and on the standardized amount transferred in Period 1.

global slider_treatment_effects The interaction effects measure the difference in treatment effects between the creative and the simple task. 
global slider_treatment_effects $slider_treatment_effects The treatment effects on the slider task equal the sum of the main treatment effect (\textit{Gift} or \textit{Performance Bonus}) and its associated interaction effect (\textit{Gift x Simple Task} and \textit{Performance Bonus x Simple Task}). 


global treatment_coef_description The treatment dummies \textit{Gift} and \textit{Performance Bonus} capture the effect of a performance-independent wage gift for all or of a performance-dependent performance bonus (rewarding the top two performers out of four agents) on standardized output in the creative task. 
global treatment_description In the \textit{Gift} and \textit{Performance Bonus} treatment groups, the principals could choose to implement a performance-independent wage gift for all or a performance-dependent performance bonus (rewarding the top two performers out of their four agents) between Periods 1 and 2. 
global Gift_description In the \textit{Gift} treatment group, the principals could choose to implement a performance-independent wage gift for all between Periods 1 and 2.
global Tournament_description In the Performance Bonus treatment group, the principals could choose to implement a performance bonus incentive (rewarding the top two performers out of their four agents) between Periods 1 and 2.

global reward_sample Agents whose principal did not implement a reward are not included in this analysis. 
global sample_description Each estimation includes all agents from the \textit{Control} group and agents from treatment groups for which the principal decided to implement the performance bonus or gift. $reward_sample
global sample_description_nonreg The sample includes all agents from the \textit{Control} group and agents from treatment groups for which the principal decided to implement the performance bonus or gift. $reward_sample
global Gift_sample_description Each estimation includes all agents from the \textit{Control} group and agents from \textit{Gift} treatment groups for which the principal decided to implement the gift. $reward_sample
global Tournament_sample_description Each estimation includes all agents from the \textit{Control} group and agents from \textit{Performance Bonus} treatment groups for which the principal decided to implement the performance bonus. $reward_sample

global controls_list Additional control variables are age, age squared, sex, location, field of study, and a set of time fixed effects (semester period, semester break, exam period). 
global errors_stars Heteroscedastic-robust standard errors are reported in parentheses. Significance levels are denoted as follows: * p < 0.1, ** p < 0.05, *** p < 0.01.

global breaks_description To create an opportunity cost of working, we offered agents a time-out button. Each time an agent clicked the time-out button, the computer screen was locked for 20 seconds, and 5 Taler were added to the agent's payoff. Breaks refer to uses of the time-out button. 

//make output directory, remove old copy if it exists and make new ones
capture log close

foreach folder in Output Logs {
	capture {
		cd "$mypath/Tables//`folder'"
	}
	if _rc == 0 {
		cd "$mypath/Tables"
 		if "`c(os)'" == "Windows" {
			!rmdir `folder' /s /q
		}
		if "`c(os)'" == "MacOSX" {
			!rm -rf `folder'
		}
	}

	cd "$mypath/Tables"
	mkdir `folder'
	
	if "`folder'" == "Output"{
		cd "$mypath/Tables/Output"
		mkdir Appendix
		mkdir Referees
	}
}


//make tables

cd "$mypath/Tables"

foreach file in BalanceTable_TTest Table_Main_Period2_Results TableCreativeTransfer Table_Creativity_Breakdown ///
				TableBreaksRaw TableFeedbackResults TablePeriod3Results Transfer_Statistics Reciprocity BaselineRegressions {
	do "$mypath/Tables/src/`file'.do" 
}
