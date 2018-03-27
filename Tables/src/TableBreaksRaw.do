clear all
set more off
set memory 100m
cap log close

use "$mypath\Overview_Aufbereitet.dta", clear
drop if treatment == 4

log using "$mypath\Tables\Logs\TableBreaks.log", replace

// make new variables 
gen time1 = 180-pausen1*20
gen time2 = 180-pausen2*20

gen pausendif = pausen2 - pausen1

//Make formated variables for table output
gen Task = "Slider" if slider == 1
replace Task = "Creative" if creative == 1

gen Treatment = "Control" if treatment == 1
replace Treatment = "Gift" if treatment == 2
replace Treatment = "Tournament" if treatment == 3

//tournament treatment
ttest pausendif == 0 if slider == 1 & turnier == 1
ttest pausendif == 0 if creative == 1 & turnier == 1

//gift treatment
ttest pausendif == 0 if slider == 1 & gift == 1
ttest pausendif == 0 if creative == 1 & gift == 1

//Output mean number of breaks by treatment x task
preserve
collapse (mean) pausen1 pausen2, by(Task Treatment)
drop if missing(Task) | missing(Treatment)
gsort -Task Treatment

format pausen* %9.2f

//replace pausen1 = round(pausen1,.02)
//replace pausen2 = round(pausen2,.02)
list

//tex output
replace Treatment = "Performance Bonus" if Treatment == "Tournament"
#delimit;
listtex using "$mypath\Tables\Output\Appendix\Num_Breaks.tex", replace end("\\")
	head("\begin{table}[h]%" 
	"\setlength\tabcolsep{2pt}" 
	"\caption{Average Number of Breaks Taken by Treatment and Period}" 
	"\label{tab:BreaksMeans}"
	"\begin{center}%" 
	"{\small\renewcommand{\arraystretch}{1}%" 
	"\begin{tabular}{llcc}" 
	"\hline\hline\noalign{\smallskip}" 
	"\bf Task & \bf Treatment & \bf Breaks in & \bf Breaks in \\" 
	"	 	  & 		  	  & \bf Period 1  & \bf Period 2 \\" 
	"\hline" 
	"\noalign{\smallskip}")
	foot("\hline\hline\noalign{\medskip}"
	"\end{tabular}}"
	"\begin{minipage}{\textwidth}"
	"\footnotesize {\it Note:} This table reports the average number of breaks by task, treatment, and period. " 
	"$breaks_description "
	"$treatment_description "
	"$sample_description_nonreg "
	"\end{minipage}"
	"\end{center}"
	"\end{table}");
#delimit cr

restore

//distribution of breaks by task for period 1
preserve
tab pausen1, gen(breaks)
gen task = "Slider" if slider == 1 
replace task = "Creative" if creative == 1 
collapse (sum) breaks* (count) total=treatment_id, by(task)
quietly: describe _all, varlist
foreach var in `r(varlist)'{
	if("`var'" != "task"){
		replace `var' = `var'/total*100
	}
}
drop if task == ""
drop total
gsort -task
list

file open f using "$mypath/Tables/Output/Referees/Breaks_Distribution.tex", write replace

local space \hspace{10pt}
#delimit ;
file write f
	"\begin{table}[h]%" _n
	"\setlength\tabcolsep{2pt}" _n
	"\caption{Distribution of Breaks Taken in Period 2}" _n
	"\label{tab:BreaksDistribution}" _n
	"\begin{center}%" _n
	"{\small\renewcommand{\arraystretch}{1}%" _n
	"\begin{tabular}{lcccccccccc}" _n
	"\hline\hline\noalign{\smallskip}" _n
	" & \multicolumn{10}{c}{Number of Breaks Taken} \\" _n
	" \cmidrule{2-11}" _n
	"Task & `space' 0 `space' & `space' 1 `space' & `space' 2 `space' & `space' 3 `space' & `space' 4 `space' & `space' 5 `space' & `space' 6 `space' & `space' 7 `space' & `space' 8 `space' & `space' 9 `space' \\" _n
	"\midrule" _n;
#delimit cr

local format %4.1f
file write f "Slider "
forvalues i = 1/10{
	quietly : sum breaks`i' if task == "Slider"
	file write f " & " `format' (r(mean)) "\%"
}
file write f "\\" _n

file write f "Creative "
forvalues i = 1/10{
	quietly : sum breaks`i' if task == "Creative"
	file write f " & " `format' (r(mean)) "\%"
}
file write f "\\"

#delimit ;
file write f
	"\hline\hline\noalign{\medskip}" _n
	"\end{tabular}}" _n
	"\begin{minipage}{\textwidth}" _n
	"\footnotesize {\it Note:} This table reports the distribution of the number of breaks by task. " _n 
	"To create an opportunity cost of working, we offered agents a time-out button. Each time an agent clicked the time-out botton, the computer screen was locked for 20 seconds, and 5 Taler (0.05 Euros) were added to the agent's payoff. " _n
	"The number of breaks taken refers to the number of times the time-out button is used. " _n
	"The time-out button was disabled for the final 20 seconds of each period. The maximum number of breaks therefore is 9 for participants who started their first break within the first second of the experiment and 8 for everyone else. " _n
	"$sample_description_nonreg "_n
	"\end{minipage}" _n
	"\end{center}" _n
	"\end{table}" _n;
#delimit cr

file close f 

restore
	
preserve
keep if (treatment == 1 | treatment == 2 | treatment == 3)

foreach task in slider creative{
	foreach var in effort time{
		forvalues i = 1/2{ //periods 1 and 2
			foreach treat in Tournament Gift Control {
				if("`treat'" == "Tournament") 	local prefix t
				if("`treat'" == "Gift")			local prefix g
				if("`treat'" == "Control") 		local prefix c
				
				sum `var'`i' if Treatment == "`treat'" & `task' == 1
				local `task'_`prefix'_`i'_`var' = r(mean)
				di ``task'_`prefix'_`i'_`var''
			}
		}
	}
}

clear
set obs 3


gen Treatment = ""
replace Treatment = "Performance Bonus" in 1
replace Treatment = "Gift" in 2
replace Treatment = "Control" in 3

local vars slider_effort1 slider_time1 slider_effort2 slider_time2 creative_effort1 creative_time1 creative_effort2 creative_time2

foreach var in `vars'{
	gen `var' = missing()
}

foreach task in slider creative{
	foreach var in effort time{
		forvalues i = 1/2{
			foreach treat in t g c{
				if("`treat'" == "t") local row = 1
				if("`treat'" == "g") local row = 2
				if("`treat'" == "c") local row = 3
				replace `task'_`var'`i' = ``task'_`treat'_`i'_`var'' in `row'
			}
		}
	}
}
format *effort* *time* %9.2f
list

//calculate output/time for all 
foreach task in slider creative{
	foreach treat in t g c{
		forvalues i = 1/2{
			local `task'_`treat'_`i'_opt = ``task'_`treat'_`i'_effort' / ``task'_`treat'_`i'_time'
		}
	}
}


//calculate differences period 2 - period 1 for all 
foreach task in slider creative{
	foreach treat in t g c{
		foreach var in opt effort time {
			local `task'_`treat'_dif_`var' = ``task'_`treat'_2_`var'' - ``task'_`treat'_1_`var''
		}
	}
}

//calculate the log ratio
foreach task in slider creative{
	foreach var in opt effort time {
		foreach time in 1 2 dif {
			//treatment ratio
			local `task'_tratio_`time'_`var' = log(``task'_t_`time'_`var'') - log(``task'_c_`time'_`var'')
			local `task'_tratio_`time'_`var' ``task'_tratio_`time'_`var'' //add \% here if needed
			
			//gift ratio
			local `task'_gratio_`time'_`var' = log(``task'_g_`time'_`var'') - log(``task'_c_`time'_`var'')
			local `task'_gratio_`time'_`var' ``task'_gratio_`time'_`var'' //add \% here if needed
			
		}
	}
}

//round everything
foreach task in slider creative{
	foreach treat in t g c{
		foreach var in opt effort time{
			foreach time in 1 2 dif{
				local `task'_`treat'_`time'_`var' = ``task'_`treat'_`time'_`var''
			}
		}
	}
}

//variable name headers
local combined_headers1 \bf Treatment & \bf Output & \bf Time Worked & \bf Output per Second && \bf Output & \bf Time Worked & \bf Output per Second \\
local combined_headers2 		& & \bf (out of 180s) & \bf of Time Worked & & & \bf (out of 180s) & \bf of Time Worked \\
local p2_headers \bf Treatment & \bf Output Period 2 & \bf Time Worked Period 2 & \bf Output per Time Worked && \bf Output Period 2 & \bf Time Worked Period 2 & \bf Output per Time Worked \\
local p1_headers \bf Treatment & \bf Output Period 1 & \bf Time Worked Period 1 & \bf Output per Time Worked && \bf Output Period 1 & \bf Time Worked Period 1 & \bf Output per Time Worked \\
local dd_headers1 \bf Treatment & \bf Difference in & \bf Difference in & \bf Difference in 		 && \bf Difference in & \bf Difference in & \bf Difference in 		 \\
local dd_headers2  			& \bf Output 		& \bf Time Worked 	& \bf Output per Time Worked && \bf Output 		& \bf Time Worked 	& \bf Output per Time Worked \\

//slider/creative headers
local task_header & \multicolumn{3}{c}{\bf Slider Task} & & \multicolumn{3}{c}{\bf Creative Task} \\ \cline{2-4} \cline{6-8}

local format %9.2f
//data rows
foreach time in 1 2 dif  {
	foreach treat in t g c tratio gratio{
		//local first_letter = substr("`treat'",1,1)
		if("`treat'" == "t") local treat_str Performance Bonus
		if("`treat'" == "g") local treat_str Gift
		if("`treat'" == "c") local treat_str Control
		if("`treat'" == "tratio") local treat_str Performance Bonus
		if("`treat'" == "gratio") local treat_str Gift
		
		local p`time'_`treat'_row "`treat_str' &" `format' (`slider_`treat'_`time'_effort') " &" `format' ( `slider_`treat'_`time'_time') " &" `format' ( `slider_`treat'_`time'_opt') "&&" `format' ( `creative_`treat'_`time'_effort') "&" `format' ( `creative_`treat'_`time'_time') "&" `format' ( `creative_`treat'_`time'_opt') " \\ "
	}
}
/*
//full tables by treatment
foreach treat in t g{
	if("`treat'" == "t") local treat_str Tournament
	if("`treat'" == "g") local treat_str Gift
	
	cap file close f
	file open f using "$mypath/Tables/Output/Breaks_Raw_`treat_str'.tex", write replace
	#delimit; 
	file write f 
		"\begin{landscape}" _n
		"\begin{table}[h]%" _n
		"\setlength\tabcolsep{2pt}" _n
		"\caption{Descriptive Statistics on Raw Output and Breaks Taken (`treat_str')}" _n
		"\begin{center}%" _n
		"{\small\renewcommand{\arraystretch}{1}%" _n
		"\begin{tabular}{lccccccc}" _n
		"\hline\hline\noalign{\smallskip}" _n
		" & \multicolumn{7}{c}{\bf Period 1} \\" _n
		"`task_header'" _n
		"`p1_headers'" _n
		"\hline" _n
		"`p1_`treat'_row'" _n
		"`p1_c_row'" _n
		"`p1_`treat'ratio_row'" _n
		" \\" _n
		" & \multicolumn{7}{c}{\bf Period 2} \\" _n
		"`task_header'" _n
		"`p2_headers'" _n
		"\hline" _n
		"`p2_`treat'_row'" _n
		"`p2_c_row'" _n
		"`p2_`treat'ratio_row'" _n
		" \\" _n
		" & \multicolumn{7}{c}{\bf Difference Between Period 2 and Period 1} \\" _n
		"`task_header'" _n
		"`dd_headers1'" _n
		"`dd_headers2'" _n
		"\hline" _n
		"`pdif_`treat'_row'" _n
		"`pdif_c_row'" _n
		"`pdif_`treat'ratio_row'" _n
		"\hline\hline\noalign{\medskip}" _n
		"\end{tabular}}" _n
		"\begin{minipage}{1.2\textwidth}" _n
		"\footnotesize {\it Note:} This table reports raw, unstandardized, average output, time spent working, and output per time worked. " _n 
		"$pooled_performance_description " _n
		"Time worked is the total time (180 seconds) less the number of breaks times the length of breaks (20 seconds). " _n
		"Output per second of worktime is the ratio of those two quantities. " _n
		"$breaks_description " _n
		"Log Difference is the log of the treatment group statistic less the log of the control group statistic. Log differences provide a better sense of relative effect sizes. " _n
		"Panel one reports these statistics for Period 1 and panel two reports them for Period 2. Note that penel two ignores baseline differences in performance. " _n
		"The third panel reports the change between periods by calculating the raw difference Period 2 less Period 1. " _n
		"$`treat_str'_description " _n
		"$`treat_str'_sample_description " _n
		"\end{minipage}" _n
		"\end{center}" _n
		"\end{table}" _n
		"\end{landscape}";
	#delimit cr
	file close f 
}
*/
//combined table, just period 2, both treatments
cap file close f
file open f using "$mypath/Tables/Output/Appendix/Breaks_Raw_Combined.tex", write replace
#delimit; 
file write f 
	"\begin{landscape}" _n
	"\begin{table}[h]%" _n
	"\setlength\tabcolsep{2pt}" _n
	"\caption{Descriptive Statistics on Raw Output and Breaks Taken in Period 2}" _n
	"\label{tab:BreaksBreakdown}" _n
	"\begin{center}%" _n
	"{\small\renewcommand{\arraystretch}{1}%" _n
	"\begin{tabular}{lccccccc}" _n
	"\hline\hline\noalign{\smallskip}" _n
	"`task_header'" _n
	"`combined_headers1'" _n
	"`combined_headers2'" _n
	"\hline" _n
	"`p2_t_row'" _n
	"`p2_g_row'" _n
	"`p2_c_row'" _n
	" \\" _n
	" \multicolumn{3}{l}{\textit{Log Difference}} \\" _n
	"\hspace{10pt} `p2_tratio_row'" _n
	//" (Tournament - Control) 	& \\" _n
	"\hspace{10pt} `p2_gratio_row'" _n
	//" (Gift - Control) 		& \\" _n
	"\hline\hline\noalign{\medskip}" _n
	"\end{tabular}}" _n
	"\begin{minipage}{1.2\textwidth}" _n
	"\footnotesize {\it Note:} This table reports raw, unstandardized, average output, time spent working, and output per second of time worked. " _n 
	"$pooled_performance_description " _n
	"Time worked is the total time (180 seconds) less the number of breaks times the length of breaks (20 seconds). " _n
	"Output per second of time worked is the ratio of those two quantities. " _n
	"$breaks_description " _n
	"Log Difference is the log of the treatment group statistic less the log of the control group statistic. Log differences provide a sense of relative effect sizes. " _n
	"Numbers may not add up due to rounding. " _n
	"For simplicity, this analysis ignores differences in Period 1 output. " _n
	"$treatment_description " _n
	"$sample_description "_n
	"\end{minipage}" _n
	"\end{center}" _n
	"\end{table}" _n
	"\end{landscape}";
#delimit cr
file close f 

restore

