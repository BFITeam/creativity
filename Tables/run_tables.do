


//assert file path is set
assert("$mypath" != "")

//analysis globals
global controls age age2 sex ferienzeit pruefungszeit wiwi recht nawi gewi mannheim

//footnote globals
global creative_score_section 3.1
global pooled_performance_description Performance refers to the number of correctly positioned sliders in the slider task and to the creativity score in the creative task (please refer to section $creative_score_section for a description of the scoring procedure). 
global pooled_trans_description Performance is measured as the number of correctly positioned sliders in the slider task, as the creativity score in the creative task (please refer to section $creative_score_section for a description of the scoring procedure), and as the amount transferred in the discretionary transfer task. 

global slider_description In the slider task, agents are evaluated by the number of correctly positioned sliders.
global creative_description In the creative task, agends are evaluated by the creativity score (please refer to section $creative_score_section for a description of the scoring procedure). 
global ctdt_description In the Creative Task with Discretionary Transfer activity, participants complete the creative task. At the end of each period, they see how many Taler they earned and may transfer up to that amount to their principal. 

global treatment_coef_description The treatment dummies \textit{Gift} and \textit{Performance Bonus} capture the effect of an unconditional wage gift or of a performance bonus (rewarding the top two performers out of four agents) on standardized performance in the creative task. 
global treatment_description In the Gift and Performance Bonus treatment groups, the principals could choose to implement an unconditional wage gift or a performance bonus (rewarding the top two performers out of their four agents) between Periods 1 and 2. 
global Gift_description In the Gift treatment group, the principals could choose to implement an unconditional wage gift between Periods 1 and 2.
global Tournament_description In the Performance Bonus treatment group, the principals could choose to implement a performance bonus incentive (rewarding the top two performers out of their four agents) between Periods 1 and 2.

global reward_sample Agents whose principal did not implement a reward scheme are not included in this analysis. 
global sample_description Each estimation includes all agents from the Control group and agents from treatment groups where the principal decided to implement the performance bonus or gift. $reward_sample
global sample_description_nonreg The sample includes all agents from the Control group and agents from treatment groups where the principal decided to implement the performance bonus or gift. $reward_sample
global Gift_sample_description Each estimation includes all agents from the Control group and agents from Gift treatment groups where the principal decided to institute the gift. $reward_sample
global Tournament_sample_description Each estimation includes all agents from the Control group and agents from Performance Bonus treatment groups where the principal decided to institute the performance bonus. $reward_sample

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
