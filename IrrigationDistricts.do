/*I've saved this file in my Teaching Folder. So this File path will not work 
for you. You'll need to create your own file path*/
use /*
	*/"U:/pp557/BARSDATAFINAL", replace

	* Only keep data for Irrigation Districts
keep if govttypecode == 18
tab year
*
foreach var of varlist _all {

	*recode 0 to missing
	capture confirm string var `var'
	if _rc {
		replace `var' = . if `var' == 0
	} 
	* Drop missing values
	capture assert missing(`var')
	if !_rc {
		drop `var'
	}
}
