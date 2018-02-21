use "$mypath\Originality_Cutoffs\Overview.dta", clear

drop if treatment == 4
drop if subject_sample!=1

rename (originality_points_sum_*) (original_*)

keep id original_*
save "$mypath\originality_cutoffs.dta", replace
