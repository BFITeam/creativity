
//assert file path is set
assert("$mypath" != "")

//make output directory, remove old copy if it exists and make new ones
clear
capture log close

foreach folder in Logs Data Graphs {
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
	
}

foreach file in FigureRawEffects_Paired FigureGiftEffects_Aufbereitet {
	do "$mypath/Figures/`file'.do" 
}
