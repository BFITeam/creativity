capture program drop calculate_p_value
program define calculate_p_value, rclass
	args beta std_error degrees_of_freedom 

	local p_value =  2*ttail(`degrees_of_freedom',abs(`beta'/`std_error'))
	if `p_value' >.1 						local stars = ""	
	if `p_value' >.05 & `p_value' <=.1  	local stars = "*"	
	if `p_value' >.01 & `p_value' <=.05 	local stars = "**"
	if `p_value' <=.01  					local stars = "***"

	return local p_value 	`p_value'
	return local stars		`stars'
end
