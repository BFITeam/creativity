clear all
set more off
set memory 100m
cap log close

use "$mypath\Overview_Aufbereitet.dta", clear
log using "$mypath\Figures\Logs\FigureGiftEffects_Aufbereitet.log", replace


reg zeffort2 zeffort1 gift if (treatment_id==11 | treatment_id==12), level(90) robust

local gift_slider_coef = _b[gift] 
local gift_slider_ub = _b[gift] + _se[gift]*invttail(e(df_r),.05)
local gift_slider_lb = _b[gift] - _se[gift]*invttail(e(df_r),.05)

reg zeffort2 zeffort1 gift if (treatment_id==21 | treatment_id==22), level(90) robust

local gift_creative_coef = _b[gift] 
local gift_creative_ub = _b[gift] + _se[gift]*invttail(e(df_r),.05)
local gift_creative_lb = _b[gift] - _se[gift]*invttail(e(df_r),.05)

reg ztransfer2 ztransfer1 giftXtransfer if (treatment_id==41 | treatment_id==42), level(90) robust

local gift_transfer_coef = _b[giftXtransfer] 
local gift_transfer_ub = _b[giftXtransfer] + _se[giftXtransfer]*invttail(e(df_r),.05)
local gift_transfer_lb = _b[giftXtransfer] - _se[giftXtransfer]*invttail(e(df_r),.05)
di "(`gift_transfer_coef',`gift_transfer_ub',`gift_transfer_lb')"

clear
set obs 3
gen treatment = _n
gen coefficient = .
gen low = .
gen high = .

local i = 1
foreach var in slider creative transfer {
	replace coefficient = `gift_`var'_coef' in `i'
	replace low = `gift_`var'_lb' in `i'
	replace high = `gift_`var'_ub' in `i'
	
	local i = `i' + 1
}

save "$mypath\Figures\Data\FigureGiftEffects_Aufbereitet.dta", replace

graph twoway (bar coefficient treatment, fcolor(emidblue) barwidth(0.8))(rcap high low treatment, lwidth(thick)), 	///
	ytitle("Effect Sizes in Standard Deviation Units") ///
	xlabel( 1 `" "Gift Treatment" "Simple Task" "(Main Treatment)" "' 2 `" "Gift Treatment" "Creative Task" "(Main Treatment)" "' 3 `" "Gift Treatment" "Creative Task with" "Discretionary Transfers" "(Supplementary Treatment)" "', noticks) 	///
	xtitle(" ") ylabel(-0.2 (0.2) 0.6) subtitle("") legend(order(2 "90% Confidence Interval"))  ///
	saving("$mypath\Figures\Graphs\Figure5.gph", replace) 
	graph export "$mypath\Figures\Graphs\Figure5_new.pdf", logo(off) replace


log close
set more on

