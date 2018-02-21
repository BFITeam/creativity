clear all
set more off
set memory 100m
cap log close

use "$mypath\Overview_Aufbereitet.dta", clear
log using "$mypath\Figures\Logs\FigureRawEffects_paired.log", replace

cap program drop ttest_output
program define ttest_output
	args file_name 	diff_control ub_control lb_control ///
					diff_gift ub_gift lb_gift ///
					diff_turnier ub_turnier lb_turnier
					

	preserve
	clear
	set obs 3
	gen treatment = _n
	gen coefficient = .
	gen low = .
	gen high = .

	local i = 1
	foreach treatment in control gift turnier {
		replace coefficient = `diff_`treatment'' in `i'
		replace high = `ub_`treatment'' in `i'
		replace low = `lb_`treatment'' in `i'
		local i = `i' + 1
	}
	save "$mypath\Figures\Data\\`file_name'.dta", replace

	restore
	
end

//Results for Period 2 effects figure

ttest effort2==effort1 if treatment_id==11, level(90)
local diff_control = `r(mu_1)' - `r(mu_2)'
local ub_control = `diff_control' + invttail(59,.05)*`r(se)'
local lb_control = `diff_control' - invttail(59,.05)*`r(se)'

ttest effort2==effort1 if treatment_id==12, level(90) 
local diff_gift = `r(mu_1)' - `r(mu_2)'
local ub_gift = `diff_gift' + invttail(59,.05)*`r(se)'
local lb_gift = `diff_gift' - invttail(59,.05)*`r(se)'

ttest effort2==effort1 if treatment_id==13, level(90) 
local diff_turnier = `r(mu_1)' - `r(mu_2)'
local ub_turnier = `diff_turnier' + invttail(59,.05)*`r(se)'
local lb_turnier = `diff_turnier' - invttail(59,.05)*`r(se)'

*ttest effort2==effort1 if treatment_id==14, level(90) 

ttest_output FigurePeriod2a_paired `diff_control' `ub_control' `lb_control' `diff_gift' `ub_gift' `lb_gift' `diff_turnier' `ub_turnier' `lb_turnier'

ttest effort2==effort1 if treatment_id==21, level(90) 
local diff_control = `r(mu_1)' - `r(mu_2)'
local ub_control = `diff_control' + invttail(59,.05)*`r(se)'
local lb_control = `diff_control' - invttail(59,.05)*`r(se)'

ttest effort2==effort1 if treatment_id==22, level(90) 
local diff_gift = `r(mu_1)' - `r(mu_2)'
local ub_gift = `diff_gift' + invttail(59,.05)*`r(se)'
local lb_gift = `diff_gift' - invttail(59,.05)*`r(se)'

ttest effort2==effort1 if treatment_id==23, level(90)
local diff_turnier = `r(mu_1)' - `r(mu_2)'
local ub_turnier = `diff_turnier' + invttail(59,.05)*`r(se)'
local lb_turnier = `diff_turnier' - invttail(59,.05)*`r(se)'
 
*ttest effort2==effort1 if treatment_id==24, level(90) 

ttest_output FigurePeriod2b_paired `diff_control' `ub_control' `lb_control' `diff_gift' `ub_gift' `lb_gift' `diff_turnier' `ub_turnier' `lb_turnier'


/*
* Regressions for Period 3 Figure *

ttest effort3==effort1 if treatment_id==11, level(90) 
local diff_control = `r(mu_1)' - `r(mu_2)'
local ub_control = `diff_control' + invttail(59,.05)*`r(se)'
local lb_control = `diff_control' - invttail(59,.05)*`r(se)'

ttest effort3==effort1 if treatment_id==12, level(90) 
local diff_gift = `r(mu_1)' - `r(mu_2)'
local ub_gift = `diff_gift' + invttail(59,.05)*`r(se)'
local lb_gift = `diff_gift' - invttail(59,.05)*`r(se)'

ttest effort3==effort1 if treatment_id==13, level(90) 
local diff_turnier = `r(mu_1)' - `r(mu_2)'
local ub_turnier = `diff_turnier' + invttail(59,.05)*`r(se)'
local lb_turnier = `diff_turnier' - invttail(59,.05)*`r(se)'

*ttest effort3==effort1 if treatment_id==14, level(90)

ttest_output FigurePeriod3a_paired `diff_control' `ub_control' `lb_control' `diff_gift' `ub_gift' `lb_gift' `diff_turnier' `ub_turnier' `lb_turnier'
 

ttest effort3==effort1 if treatment_id==21, level(90) 
local diff_control = `r(mu_1)' - `r(mu_2)'
local ub_control = `diff_control' + invttail(59,.05)*`r(se)'
local lb_control = `diff_control' - invttail(59,.05)*`r(se)'

ttest effort3==effort1 if treatment_id==22, level(90) 
local diff_gift = `r(mu_1)' - `r(mu_2)'
local ub_gift = `diff_gift' + invttail(59,.05)*`r(se)'
local lb_gift = `diff_gift' - invttail(59,.05)*`r(se)'

ttest effort3==effort1 if treatment_id==23, level(90)
local diff_turnier = `r(mu_1)' - `r(mu_2)'
local ub_turnier = `diff_turnier' + invttail(59,.05)*`r(se)'
local lb_turnier = `diff_turnier' - invttail(59,.05)*`r(se)'
 
*ttest effort3==effort1 if treatment_id==24, level(90) 																

ttest_output FigurePeriod3b_paired `diff_control' `ub_control' `lb_control' `diff_gift' `ub_gift' `lb_gift' `diff_turnier' `ub_turnier' `lb_turnier'
*/

***************
//Make Graphs**
***************

//Period 2

use "$mypath\Figures\Data\FigurePeriod2a_paired.dta", clear

drop if treatment==4

graph twoway (bar coefficient treatment, fcolor(emidblue) barwidth(0.8))(rcap high low treatment, lwidth(thick)), 	///
	xlabel( 1 "Control" 2 "Gift" 3 "Performance Bonus", noticks) 	///
	ytitle("Difference between Round 2 and 1") xtitle(" ") ylabel(-4 (2) 14) subtitle("Slider Task") legend(order(2 "90% Confidence Interval"))  ///
	saving("$mypath\Figures\Graphs\Figure4a_paired_final2.gph", replace) 
	graph export "$mypath\Figures\Graphs\Figure4a_paired_final2.pdf", logo(off) replace

use "$mypath\Figures\Data\FigurePeriod2b_paired.dta", clear

drop if treatment==4

graph twoway (bar coefficient treatment, fcolor(emidblue) barwidth(0.8))(rcap high low treatment, lwidth(thick)), 	///
	xlabel( 1 "Control" 2 "Gift" 3 "Performance Bonus", noticks) 	///
	ytitle("Difference between Round 2 and 1") xtitle(" ") ylabel(-4 (2) 14) subtitle("Creative Task") legend(order(2 "90% Confidence Interval"))  ///
	saving("$mypath\Figures\Graphs\Figure4b_paired_final2.gph", replace) 
	graph export "$mypath\Figures\Graphs\Figure4b_paired_final2.pdf", logo(off) replace

/*
//Period 3

use "$mypath\Figures\Data\FigurePeriod3a_paired.dta", clear

drop if treatment==4

graph twoway (bar coefficient treatment, fcolor(emidblue) barwidth(0.8))(rcap high low treatment, lwidth(thick)), 	///
	xlabel( 1 "Control" 2 "Gift" 3 "Tournament", noticks) 	///
	ytitle("Difference between Round 3 and 1") xtitle(" ") ylabel(-4 (2) 6) subtitle("Slider Task") legend(order(2 "90% Confidence Interval"))  ///
	saving("$mypath\Figures\Graphs\FigurePeriod3a_paired.gph", replace) 
	graph export "$mypath\Figures\Graphs\FigurePeriod3a_paired.ps", logo(off) replace

use "$mypath\Figures\Data\FigurePeriod3b_paired.dta", clear

drop if treatment==4

graph twoway (bar coefficient treatment, fcolor(emidblue) barwidth(0.8))(rcap high low treatment, lwidth(thick)), 	///
	xlabel( 1 "Control" 2 "Gift" 3 "Tournament", noticks) 	///
	ytitle("Difference between Round 3 and 1") xtitle(" ") ylabel(-4 (2) 6) subtitle("Creative Task") legend(order(2 "90% Confidence Interval"))  ///
	saving("$mypath\Figures\Graphs\FigurePeriod3b_paired.gph", replace) 
	graph export "$mypath\Figures\Graphs\FigurePeriod3b_paired.ps", logo(off) replace
*/



log close
set more on
