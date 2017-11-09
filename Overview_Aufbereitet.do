clear all
set more off
set memory 100m
cap log close

use "$mypath\raw_data\Overview.dta", clear
log using "$mypath\Overview_Aufbereitet.log", replace


*************************************************************************************************
* LABEL

label var date "Datum"
label var id "Personen ID"
label var no_problem "problematische Teilnehmernummer"
label var session_problem "Problematische Sessionnummer"
label var reason_problem "Grund für Problematik"
label var treatment_id "eindeutige numerische Identifikation des Treatments"
label var treatment_id2 "eindeutige Identifikation des Treatments als Character"
label var slider "Slider Dummy"
label var creative "Creative Dummy"
label var eke "EKE Dummy"
label var kek "KEK Dummy"
label var slider_fair "Slider mit Fairwage Abfrage Dummy"
label var creative_trans "Creative Task mit Transfer Dummy"
label var subject "Teilnehmernummer innerhalb der Session"
label var proposer "Arbeitgeber (0: Arbeitnehmer, 1: Arbeitgeber)"
label var score1 "Score nachbewertet Runde 1"
label var score2 "Score nachbewertet Runde 2"
label var score3 "Score nachbewertet Runde 3"
label var effort1 "Leistung Runde 1"
label var effort2 "Leistung Runde 2"
label var effort3 "Leistung Runde 3"
label var bonus_dec "Bonusentscheidung"
label var transfer1 "Transfer an AG in Runde 1 (kreative transfer Treatments)"
label var transfer2 "Transfer an AG in Runde 2 (kreative transfer Treatments)"
label var transfer3 "Transfer an AG in Runde 3 (kreative transfer Treatments)"



*************************************************************************************************
* Ausschließen falls Arbeitgeber, keine Bonus Decision, Problemkandidat oder Problemsession
drop if subject_sample==0

* Generieren zusätzlicher Variablen

replace age=. if age==0
gen age2=age^2
label var age2 "Alter quadriert"

* Überblick über die Anzahl der gültigen Teilnehmer in den jeweiligen Treatments
tab treatment_id



*************************************************************************************************
* STANDARDISIERUNGEN

* Standardisieren der Efforts

// Standardisierung von effort1, effort2, effort3 der Slidertask Beobachtungen (slidertask effort standardized with mean and sd of slidertask control group)

sum effort1 if treatment_id==11
gen zeffort1_sl = (effort1 - r(mean)) / r(sd) if slider==1

sum effort2 if treatment_id==11
gen zeffort2_sl = (effort2 - r(mean)) / r(sd) if slider==1

sum effort3 if treatment_id==11
gen zeffort3_sl = (effort3 - r(mean)) / r(sd) if slider==1


// Standardisierung von effort1, effort2, effort3 der kreativen Beobachtungen (creative task effort standardized with mean and sd of creative task control group)

sum effort1 if treatment_id==21
gen zeffort1_cr = (effort1 - r(mean)) / r(sd) if creative==1

sum effort2 if treatment_id==21
gen zeffort2_cr = (effort2 - r(mean)) / r(sd) if creative==1

sum effort3 if treatment_id==21
gen zeffort3_cr = (effort3 - r(mean)) / r(sd) if creative==1


// Standardisierung von effort1, effort2, effort3 der EKE Beobachtungen 

sum effort1 if treatment_id==11
gen zeffort1_eke = (effort1 - r(mean)) / r(sd) if eke==1

sum effort2 if treatment_id==21
gen zeffort2_eke = (effort2 - r(mean)) / r(sd) if eke==1

sum effort3 if treatment_id==11
gen zeffort3_eke = (effort3 - r(mean)) / r(sd) if eke==1


// Standardisierung von effort1, effort2, effort3 der KEK Beobachtungen 

sum effort1 if treatment_id==21
gen zeffort1_kek = (effort1 - r(mean)) / r(sd) if kek==1

sum effort2 if treatment_id==11
gen zeffort2_kek = (effort2 - r(mean)) / r(sd) if kek==1

sum effort3 if treatment_id==21
gen zeffort3_kek = (effort3 - r(mean)) / r(sd) if kek==1


// Standardisieren von effort1, effort2, effort3 der kreativen Transfer Beobachtungen

sum effort1 if treatment_id==21				
gen zeffort1_cr_trans = (effort1 - r(mean)) / r(sd) if creative_trans==1

sum effort2 if treatment_id==21
gen zeffort2_cr_trans = (effort2 - r(mean)) / r(sd) if creative_trans==1

sum effort3 if treatment_id==21
gen zeffort3_cr_trans = (effort3 - r(mean)) / r(sd) if creative_trans==1


// Standardisieren von effort1, effort2, effort3 der Slider Beobachtungen mit Fairwage Abfrage

sum effort1 if treatment_id==11				
gen zeffort1_sl_fairw = (effort1 - r(mean)) / r(sd) if slider_fair==1

sum effort2 if treatment_id==11
gen zeffort2_sl_fairw = (effort2 - r(mean)) / r(sd) if slider_fair==1

sum effort3 if treatment_id==11
gen zeffort3_sl_fairw = (effort3 - r(mean)) / r(sd) if slider_fair==1



* Standardisieren der Scores

// Standardisieren von score1, score2, score3 der Slidertask Beobachtungen & Slidertask Fairwage Beobachtungen

sum score1 if treatment_id==11
gen zscore1_sl = (score1 - r(mean)) / r(sd) if (slider==1 | slider_fair==1)

sum score2 if treatment_id==11
gen zscore2_sl = (score2 - r(mean)) / r(sd) if (slider==1 | slider_fair==1)

sum score3 if treatment_id==11
gen zscore3_sl = (score3 - r(mean)) / r(sd) if (slider==1 | slider_fair==1)


// Standardisieren von score1, score2, score3 der kreativen Beobachtungen

sum score1 if treatment_id==21
gen zscore1_cr = (score1 - r(mean)) / r(sd) if creative==1

sum score2 if treatment_id==21
gen zscore2_cr = (score2 - r(mean)) / r(sd) if creative==1 

sum score3 if treatment_id==21
gen zscore3_cr = (score3 - r(mean)) / r(sd) if creative==1


// Standardisieren von score1, score2, score3 der kreativen Transfer Beobachtungen

sum score1 if treatment_id==21
gen zscore1_cr_trans = (score1 - r(mean)) / r(sd) if creative_trans==1

sum score2 if treatment_id==21
gen zscore2_cr_trans = (score2 - r(mean)) / r(sd) if creative_trans==1

sum score3 if treatment_id==21
gen zscore3_cr_trans = (score3 - r(mean)) / r(sd) if creative_trans==1


// Standardisieren von score1, score2, score3 der EKE Beobachtungen

sum score1 if treatment_id==31
gen zscore1_eke = (score1 - r(mean)) / r(sd) if eke==1

sum score2 if treatment_id==31
gen zscore2_eke = (score2 - r(mean)) / r(sd) if eke==1

sum score3 if treatment_id==31
gen zscore3_eke = (score3 - r(mean)) / r(sd) if eke==1


// Standardisieren von score1, score2, score3 der KEK Beobachtungen

sum score1 if treatment_id==32
gen zscore1_kek = (score1 - r(mean)) / r(sd) if kek==1

sum score2 if treatment_id==32
gen zscore2_kek = (score2 - r(mean)) / r(sd) if kek==1

sum score3 if treatment_id==32
gen zscore3_kek = (score3 - r(mean)) / r(sd) if kek==1



* Standardisieren der transfers

// Standardisieren von transfer1, transfer2, transfer3 der Slidertask Beobachtungen & Slidertask Fairwage Beobachtungen

sum transfer1 if treatment_id==11
gen ztransfer1_sl = (transfer1 - r(mean)) / r(sd) if (slider==1 | slider_fair==1)

sum transfer2 if treatment_id==11
gen ztransfer2_sl = (transfer2 - r(mean)) / r(sd) if (slider==1 | slider_fair==1)

sum transfer3 if treatment_id==11
gen ztransfer3_sl = (transfer3 - r(mean)) / r(sd) if (slider==1 | slider_fair==1)


// Standardisieren von transfer1, transfer2, transfer3 der kreativen Beobachtungen

sum transfer1 if treatment_id==21
gen ztransfer1_cr = (transfer1 - r(mean)) / r(sd) if creative==1

sum transfer2 if treatment_id==21
gen ztransfer2_cr = (transfer2 - r(mean)) / r(sd) if creative==1

sum transfer3 if treatment_id==21
gen ztransfer3_cr = (transfer3 - r(mean)) / r(sd) if creative==1


// Standardisieren von transfer1, transfer2, transfer3 der kreativen Transfer Beobachtungen

sum transfer1 if treatment_id==21
gen ztransfer1_cr_trans = (transfer1 - r(mean)) / r(sd) if (creative_trans==1)

sum transfer2 if treatment_id==21
gen ztransfer2_cr_trans = (transfer2 - r(mean)) / r(sd) if (creative_trans==1)

sum transfer3 if treatment_id==21
gen ztransfer3_cr_trans = (transfer3 - r(mean)) / r(sd) if (creative_trans==1)

// Standardisieren von transfer1, transfer2, transfer3 der EKE Beobachtungen

sum transfer1 if treatment_id==11
gen ztransfer1_eke = (transfer1 - r(mean)) / r(sd) if eke==1

sum transfer2 if treatment_id==21
gen ztransfer2_eke = (transfer2 - r(mean)) / r(sd) if eke==1

sum transfer3 if treatment_id==11
gen ztransfer3_eke = (transfer3 - r(mean)) / r(sd) if eke==1


// Standardisieren von transfer1, transfer2, transfer3 der KEK Beobachtungen

sum transfer1 if treatment_id==21
gen ztransfer1_kek = (transfer1 - r(mean)) / r(sd) if kek==1

sum transfer2 if treatment_id==11
gen ztransfer2_kek = (transfer2 - r(mean)) / r(sd) if kek==1

sum transfer3 if treatment_id==21
gen ztransfer3_kek = (transfer3 - r(mean)) / r(sd) if kek==1



* Standardisieren der einzelnen Punktekategorien bei der kreativen Aufgabe

// Standardisieren von p_valid, p_flex & p_original der kreativen Beobachtungen

sum p_valid1 if treatment_id==21
gen zp_valid1=(p_valid1-r(mean))/r(sd) if creative==1

sum p_valid2 if treatment_id==21
gen zp_valid2=(p_valid2-r(mean))/r(sd) if creative==1

sum p_valid3 if treatment_id==21
gen zp_valid3=(p_valid3-r(mean))/r(sd) if creative==1

sum p_flex1 if treatment_id==21
gen zp_flex1=(p_flex1-r(mean))/r(sd) if creative==1

sum p_flex2 if treatment_id==21
gen zp_flex2=(p_flex2-r(mean))/r(sd) if creative==1

sum p_flex3 if treatment_id==21
gen zp_flex3=(p_flex3-r(mean))/r(sd) if creative==1

sum p_original1 if treatment_id==21
gen zp_original1=(p_original1-r(mean))/r(sd) if creative==1

sum p_original2 if treatment_id==21
gen zp_original2=(p_original2-r(mean))/r(sd) if creative==1

sum p_original3 if treatment_id==21
gen zp_original3=(p_original3-r(mean))/r(sd) if creative==1


// Standardisieren von p_valid, p_flex & p_original der kreativen Transfer Beobachtungen

sum p_valid1 if treatment_id==41
gen zp_valid1_trans=(p_valid1-r(mean))/r(sd) if creative_trans==1

sum p_valid2 if treatment_id==41
gen zp_valid2_trans=(p_valid2-r(mean))/r(sd) if creative_trans==1

sum p_valid3 if treatment_id==41
gen zp_valid3_trans=(p_valid3-r(mean))/r(sd) if creative_trans==1

sum p_flex1 if treatment_id==41
gen zp_flex1_trans=(p_flex1-r(mean))/r(sd) if creative_trans==1

sum p_flex2 if treatment_id==41
gen zp_flex2_trans=(p_flex2-r(mean))/r(sd) if creative_trans==1

sum p_flex3 if treatment_id==41
gen zp_flex3_trans=(p_flex3-r(mean))/r(sd) if creative_trans==1

sum p_original1 if treatment_id==41
gen zp_original1_trans=(p_original1-r(mean))/r(sd) if creative_trans==1

sum p_original2 if treatment_id==41
gen zp_original2_trans=(p_original2-r(mean))/r(sd) if creative_trans==1

sum p_original3 if treatment_id==41
gen zp_original3_trans=(p_original3-r(mean))/r(sd) if creative_trans==1

/*
sum originality_points_sum_1_10 if treatment_id==21
gen zp_original1_10=(originality_points_sum_1_10-r(mean))/r(sd) if creative==1
sum originality_points_sum_1_5 if treatment_id==21
gen zp_original1_5=(originality_points_sum_1_5-r(mean))/r(sd) if creative==1
sum originality_points_sum_1_1 if treatment_id==21
gen zp_original1_1=(originality_points_sum_1_1-r(mean))/r(sd) if creative==1


sum originality_points_sum_2_10 if treatment_id==21
gen zp_original2_10=(originality_points_sum_2_10-r(mean))/r(sd) if creative==1
sum originality_points_sum_2_5 if treatment_id==21
gen zp_original2_5=(originality_points_sum_2_5-r(mean))/r(sd) if creative==1
sum originality_points_sum_2_1 if treatment_id==21
gen zp_original2_1=(originality_points_sum_2_1-r(mean))/r(sd) if creative==1
*/






*************************************************************************************************
* DIFFERENZENBERECHNUNG

* Differenzen berechnen der Efforts je nach Treatment

gen diff1 = effort2-effort1
gen diff2 = effort3-effort2
gen diff3 = effort3-effort1
label var diff1 `"effort2 - effort1"'
label var diff2 `"effort3 - effort2"'
label var diff3 `"effort3 - effort1"'

gen zdiff1_sl = zeffort2_sl-zeffort1_sl
gen zdiff2_sl = zeffort3_sl-zeffort2_sl
gen zdiff3_sl = zeffort3_sl-zeffort1_sl
label var zdiff1_sl `"zeffort2_sl - zeffort1_sl"'
label var zdiff2_sl `"zeffort3_sl - zeffort2_sl"'
label var zdiff3_sl `"zeffort3_sl - zeffort1_sl"'

gen zdiff1_cr = zeffort2_cr-zeffort1_cr
gen zdiff2_cr = zeffort3_cr-zeffort2_cr
gen zdiff3_cr = zeffort3_cr-zeffort1_cr
label var zdiff1_cr `"zeffort2_cr - zeffort1_cr"'
label var zdiff2_cr `"zeffort3_cr - zeffort2_cr"'
label var zdiff3_cr `"zeffort3_cr - zeffort1_cr"'

gen zdiff1_eke = zeffort2_eke-zeffort1_eke
gen zdiff2_eke = zeffort3_eke-zeffort2_eke
gen zdiff3_eke = zeffort3_eke-zeffort1_eke
label var zdiff1_eke `"zeffort2_eke - zeffort1_eke"'
label var zdiff2_eke `"zeffort3_eke - zeffort2_eke"'
label var zdiff3_eke `"zeffort3_eke - zeffort1_eke"'

gen zdiff1_kek = zeffort2_kek-zeffort1_kek
gen zdiff2_kek = zeffort3_kek-zeffort2_kek
gen zdiff3_kek = zeffort3_kek-zeffort1_kek
label var zdiff1_kek `"zeffort2_kek - zeffort1_kek"'
label var zdiff2_kek `"zeffort3_kek - zeffort2_kek"'
label var zdiff3_kek `"zeffort3_kek - zeffort1_kek"'

gen zdiff1_cr_trans = zeffort2_cr_trans-zeffort1_cr_trans
gen zdiff2_cr_trans = zeffort3_cr_trans-zeffort2_cr_trans
gen zdiff3_cr_trans = zeffort3_cr_trans-zeffort1_cr_trans
label var zdiff1_cr_trans `"zeffort2_cr_trans - zeffort1_cr_trans"'
label var zdiff2_cr_trans `"zeffort3_cr_trans - zeffort2_cr_trans"'
label var zdiff3_cr_trans `"zeffort3_cr_trans - zeffort1_cr_trans"'



* Differenzen berechnen für einzelne Punktkategorien bei der kreativen Aufgabe

gen diff1_valid = p_valid2 - p_valid1
gen diff2_valid = p_valid3 - p_valid2
gen diff3_valid = p_valid3 - p_valid1
label var diff1_valid `"p_valid2 - p_valid1"'
label var diff2_valid `"p_valid3 - p_valid2"'
label var diff3_valid `"p_valid3 - p_valid1"'

gen diff1_flex = p_flex2 - p_flex1
gen diff2_flex = p_flex3 - p_flex2
gen diff3_flex = p_flex3 - p_flex1
label var diff1_flex `"p_flex2 - p_flex1"'
label var diff2_flex `"p_flex3 - p_flex2"'
label var diff3_flex `"p_flex3 - p_flex1"'

gen diff1_original = p_original2 - p_original1
gen diff2_original = p_original3 - p_original2
gen diff3_original = p_original3 - p_original1
label var diff1_original `"p_original2 - p_original1"'
label var diff2_original `"p_original3 - p_original2"'
label var diff3_original `"p_original3 - p_original1"'



* Einheitliche Variable für standardisierte effort1-3, score1-3 und transfer1-3

gen zeffort1 = .

replace zeffort1 = zeffort1_sl if slider==1
replace zeffort1 = zeffort1_cr if creative==1
replace zeffort1 = zeffort1_eke if eke==1
replace zeffort1 = zeffort1_kek if kek==1
replace zeffort1 = zeffort1_cr_trans if creative_trans==1
replace zeffort1 = zeffort1_sl_fairw if slider_fair==1

gen zeffort2 = .

replace zeffort2 = zeffort2_sl if slider==1
replace zeffort2 = zeffort2_cr if creative==1
replace zeffort2 = zeffort2_eke if eke==1
replace zeffort2 = zeffort2_kek if kek==1
replace zeffort2 = zeffort2_cr_trans if creative_trans==1
replace zeffort2 = zeffort2_sl_fairw if slider_fair==1

gen zeffort3 = .

replace zeffort3 = zeffort3_sl if slider==1
replace zeffort3 = zeffort3_cr if creative==1
replace zeffort3 = zeffort3_eke if eke==1
replace zeffort3 = zeffort3_kek if kek==1
replace zeffort3 = zeffort3_cr_trans if creative_trans==1
replace zeffort3 = zeffort3_sl_fairw if slider_fair==1



gen zscore1 = .
replace zscore1 = zscore1_sl if (slider==1 | slider_fair==1)
replace zscore1 = zscore1_cr if creative==1
replace zscore1 = zscore1_cr_trans if creative_trans==1
replace zscore1 = zscore1_eke if eke==1
replace zscore1 = zscore1_kek if kek==1

gen zscore2 = .
replace zscore2 = zscore2_sl if (slider==1 | slider_fair==1)
replace zscore2 = zscore2_cr if creative==1
replace zscore2 = zscore2_cr_trans if creative_trans==1
replace zscore2 = zscore2_eke if eke==1
replace zscore2 = zscore2_kek if kek==1

gen zscore3 = .
replace zscore3 = zscore3_sl if (slider==1 | slider_fair==1)
replace zscore3 = zscore3_cr if creative==1
replace zscore3 = zscore3_cr_trans if creative_trans==1
replace zscore3 = zscore3_eke if eke==1
replace zscore3 = zscore3_kek if kek==1



gen ztransfer1 = .
replace ztransfer1 = ztransfer1_sl if (slider==1 | slider_fair==1)
replace ztransfer1 = ztransfer1_cr if creative==1 
replace ztransfer1 = ztransfer1_cr_trans if creative_trans==1
replace ztransfer1 = ztransfer1_eke if eke==1
replace ztransfer1 = ztransfer1_kek if kek==1

gen ztransfer2 = .
replace ztransfer2 = ztransfer2_sl if (slider==1 | slider_fair==1)
replace ztransfer2 = ztransfer2_cr if creative==1
replace ztransfer2 = ztransfer2_cr_trans if creative_trans==1
replace ztransfer2 = ztransfer2_eke if eke==1
replace ztransfer2 = ztransfer2_kek if kek==1

gen ztransfer3 = .
replace ztransfer3 = ztransfer3_sl if (slider==1 | slider_fair==1)
replace ztransfer3 = ztransfer3_cr if creative==1
replace ztransfer3 = ztransfer3_cr_trans if creative_trans==1
replace ztransfer3 = ztransfer3_eke if eke==1
replace ztransfer3 = ztransfer3_kek if kek==1



gen zdiff1 = zeffort2 - zeffort1
gen zdiff2 = zeffort3 - zeffort2
gen zdiff3 = zeffort3 - zeffort1
label var zdiff1 `"zeffort2 - zeffort1"'
label var zdiff2 `"zeffort3 - zeffort2"'
label var zdiff3 `"zeffort3 - zeffort1"'

gen zdiffscore1 = zscore2 - zscore1
gen zdiffscore2 = zscore3 - zscore2
gen zdiffscore3 = zscore3 - zscore1
label var zdiffscore1 `"zscore2 - zscore1"'
label var zdiffscore2 `"zscore3 - zscore2"'
label var zdiffscore3 `"zscore3 - zscore1"'

gen zdifftransfer1 = ztransfer2 - ztransfer1
gen zdifftransfer2 = ztransfer3 - ztransfer2
gen zdifftransfer3 = ztransfer3 - ztransfer1
label var zdifftransfer1 `"ztransfer2 - ztransfer1"'
label var zdifftransfer2 `"ztransfer3 - ztransfer2"'
label var zdifftransfer3 `"ztransfer3 - ztransfer1"'


*************************************************************************************************
* INTERAKTIONSTERME

gen giftXslid      = gift*slider
gen turnXslid      = turnier*slider
gen feedXslid      = feedback*slider
gen zeffort1Xslid  = zeffort1*slider
gen zscore1Xslid  = zeffort1*slider
gen ztransfer1Xslid  = zeffort1*slider
gen giftXtransfer  = gift_transfer*creative_trans

gen max_trans      = 0
replace max_trans  = 1 if (transfer1==effort1)

* Übersicht Mean Efforts differenziert nach Max_Trans
sum effort1 if (gift_transfer==1 & max_trans==0)
sum effort1 if (gift_transfer==1 & max_trans==1)
sum effort2 if (gift_transfer==1 & max_trans==0)
sum effort2 if (gift_transfer==1 & max_trans==1)
sum effort3 if (gift_transfer==1 & max_trans==0)
sum effort3 if (gift_transfer==1 & max_trans==1)

gen gift_transXmax_trans = gift_transfer*max_trans


gen invalid1 = answers1-p_valid1
gen invalid2 = answers2-p_valid2


sum invalid1 if treatment_id==21
gen zinvalid1 = (invalid1 - r(mean)) / r(sd) if creative==1

sum invalid2 if treatment_id==21
gen zinvalid2 = (invalid2 - r(mean)) / r(sd) if creative==1



*************************************************************************************************
* REGRESSIONEN

*Referee
eststo: quietly reg zinvalid2 zinvalid1 gift turnier if treatment_id>20 & treatment_id<24, r
eststo: quietly reg zp_valid2 zp_valid1 gift turnier if treatment_id>20 & treatment_id<24, r
eststo: quietly reg zp_flex2 zp_flex1 gift turnier if treatment_id>20 & treatment_id<24, r
*eststo: quietly reg zp_original2_10 zp_original1_10 gift turnier if treatment_id>20 & treatment_id<24, r
*eststo: quietly reg zp_original2_5 zp_original1_5 gift turnier if treatment_id>20 & treatment_id<24, r
*eststo: quietly reg zp_original2_1 zp_original1_1 gift turnier if treatment_id>20 & treatment_id<24, r

eststo clear




* Sample Slider Task
reg zeffort2 zeffort1 gift turnier feedback if slider==1, robust
reg zeffort3 zeffort1 gift turnier feedback if slider==1, robust



* Sample Creative Task All
reg zeffort2 zeffort1 gift gift_transfer turnier feedback if (creative==1 | creative_trans==1), robust
reg zeffort3 zeffort1 gift gift_transfer turnier feedback if (creative==1 | creative_trans==1), robust
reg ztransfer2 ztransfer1 gift gift_transfer turnier feedback if (creative==1 | creative_trans==1), robust
reg ztransfer3 ztransfer1 gift gift_transfer turnier feedback if (creative==1 | creative_trans==1), robust

* Sample Creative Task All, getrennt nach maximalem Transfer in Runde1 
reg zeffort2 zeffort1 gift_transfer if ((creative==1 | creative_trans==1) & max_trans==0), robust
reg zeffort3 zeffort1 gift_transfer if ((creative==1 | creative_trans==1) & max_trans==0), robust
reg zeffort2 zeffort1 gift_transfer if ((creative==1 | creative_trans==1) & max_trans==1), robust
reg zeffort3 zeffort1 gift_transfer if ((creative==1 | creative_trans==1) & max_trans==1), robust

reg zeffort2 zeffort1 max_trans gift_transfer gift_transXmax_trans if (creative==1 | creative_trans==1), robust
reg zeffort3 zeffort1 max_trans gift_transfer gift_transXmax_trans if (creative==1 | creative_trans==1), robust



* Sample Creative Transfer Treatments
reg zeffort2 zeffort1 gift_transfer if creative_trans==1, robust
reg zeffort3 zeffort1 gift_transfer if creative_trans==1, robust
reg ztransfer2 ztransfer1 gift_transfer if creative_trans==1, robust
reg ztransfer3 ztransfer1 gift_transfer if creative_trans==1, robust

* Sample Creative Transfer Treatments, getrennt nach maximalem Transfer in Runde1 
reg zeffort2 zeffort1 gift_transfer if (creative_trans==1 & max_trans==0), robust
reg zeffort3 zeffort1 gift_transfer if (creative_trans==1 & max_trans==0), robust
reg zeffort2 zeffort1 gift_transfer if (creative_trans==1 & max_trans==1), robust
reg zeffort3 zeffort1 gift_transfer if (creative_trans==1 & max_trans==1), robust

reg zeffort2 zeffort1 max_trans gift_transfer gift_transXmax_trans if creative_trans==1, robust
reg zeffort3 zeffort1 max_trans gift_transfer gift_transXmax_trans if creative_trans==1, robust



* Sample All (Slider, Slider Fairwage, Creative Task & Creative Transfer Task)


reg zeffort2 zeffort1 gift turnier feedback creative_trans slider_fair zeffort1Xslid giftXslid turnXslid feedXslid giftXtransfer if (slider==1 | creative==1 | creative_trans==1 | slider_fair==1), robust
reg zeffort3 zeffort1 gift turnier feedback creative_trans slider_fair zeffort1Xslid giftXslid turnXslid feedXslid giftXtransfer if (slider==1 | creative==1 | creative_trans==1 | slider_fair==1), robust

reg zscore2 zscore1 gift turnier feedback creative_trans slider_fair zscore1Xslid giftXslid turnXslid feedXslid giftXtransfer if (slider==1 | creative==1 | creative_trans==1 | slider_fair==1), robust
reg zscore3 zscore1 gift turnier feedback creative_trans slider_fair zscore1Xslid giftXslid turnXslid feedXslid giftXtransfer if (slider==1 | creative==1 | creative_trans==1 | slider_fair==1), robust

reg ztransfer2 ztransfer1 gift turnier feedback creative_trans slider_fair ztransfer1Xslid giftXslid turnXslid feedXslid giftXtransfer if (slider==1 | creative==1 | creative_trans==1 | slider_fair==1), robust
reg ztransfer3 ztransfer1 gift turnier feedback creative_trans slider_fair ztransfer1Xslid giftXslid turnXslid feedXslid giftXtransfer if (slider==1 | creative==1 | creative_trans==1 | slider_fair==1), robust

reg zdiff1 zeffort1 gift turnier feedback creative_trans slider_fair zeffort1Xslid giftXslid turnXslid feedXslid giftXtransfer if (slider==1 | creative==1 | creative_trans==1 | slider_fair==1), robust
reg zdiff3 zeffort1 gift turnier feedback creative_trans slider_fair zeffort1Xslid giftXslid turnXslid feedXslid giftXtransfer if (slider==1 | creative==1 | creative_trans==1 | slider_fair==1), robust



************************************************************************************************
* Erstellung Dummies Over-/Underpaid

gen fairwage_overpaid = 0 
replace fairwage_overpaid = 1 if (fairwage==1 | fairwage==2)
gen fairwage_underpaid = 0
replace fairwage_underpaid = 1 if (fairwage==4 | fairwage==5)
gen fairwage_ok = 0
replace fairwage_ok = 1 if fairwage==3

replace fairwage_overpaid =  . if fairwage == .
replace fairwage_ok =  . if fairwage == .
replace fairwage_underpaid =  . if fairwage == .


* Erstellung Interatkionsterme

gen overpaidXslider_fair = fairwage_overpaid*slider_fair

gen underpaidXslider_fair = fairwage_underpaid*slider_fair

gen underpaidXgiftXtrans = fairwage_underpaid*giftXtransfer

gen overpaidXgiftXtrans = fairwage_overpai*giftXtransfer

* Regression Fairwage Slider only

reg zeffort2 zeffort1 fairwage_overpaid fairwage_underpaid if (slider_fair==1), robust
reg zeffort3 zeffort1 fairwage_overpaid fairwage_underpaid if (slider_fair==1), robust

* Regression Fairwage Creative only

reg zeffort2 zeffort1 giftXtrans fairwage_overpaid fairwage_underpaid overpaidXgiftXtrans underpaidXgiftXtrans if (creative_trans==1), robust
reg zeffort3 zeffort1 giftXtrans fairwage_overpaid fairwage_underpaid overpaidXgiftXtrans underpaidXgiftXtrans if (creative_trans==1), robust

reg ztransfer2 ztransfer1 giftXtrans fairwage_overpaid fairwage_underpaid overpaidXgiftXtrans underpaidXgiftXtrans if (creative_trans==1), robust
reg ztransfer3 ztransfer1 giftXtrans fairwage_overpaid fairwage_underpaid overpaidXgiftXtrans underpaidXgiftXtrans if (creative_trans==1), robust

*************************************************************************************************
* Location Dummy
gen heidelberg = 1 if mannheim==2
replace heidelberg = 0 if heidelberg== .
replace mannheim = 0 if heidelberg==1
********************************************

merge 1:1 id using "$mypath\originality_cutoffs.dta", nogen

save "$mypath\raw_data\Overview_Aufbereitet.dta", replace

log close
set more on
