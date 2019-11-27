/*I've saved this file in my Teaching Folder. So this File path will not work 
for you. You'll need to create your own file path*/
cd "U:/pp557"
use "BARSDATAFINAL", replace

* Only keep data for Irrigation Districts
keep if govttypecode == 18

* Get rid of columns not applicable to our data type 
* Loop through all variables in the data set
foreach var of varlist _all {

	* Is the variable a string? 0 = yes a string
	capture confirm string var `var'
	* If _rc is not zero then it is not a string and is likely a number
	if _rc {
		*recode 0 to missing
		qui replace `var' = . if `var' == 0
	} 
	
	* Check if all values of the variable are missing 0 = all missing
	capture assert missing(`var')
	* If 
	if !_rc {
		* Drop missing values
		qui drop `var'
	}
	
}

* Turn missings back to 0s - Needed to prevent problems with calculations on 
* actual zeroes
foreach var of varlist _all {
	* Is the variable a string? 0 = yes a string
	capture confirm string var `var'
	* If _rc is not zero then it is not a string and is likely a number
	if _rc {
		*recode missing back to 0
		qui replace `var' = 0 if `var' == .
	} 
}


* Calculate Cash Balance Sufficiency
* Cash / (Total Expenditures)
gen cash_balance = 365 * (totalf_endbal_total / /*
		*/	(totalf_expendtotal +  totalf_debtserv))

* Calculate change in cash position
* (Ending Cash - Beginning Cash) / Beginning Cash
gen cash_position = (totalf_endbal_total - totalf_beginbal_total) / /*
		*/ totalf_beginbal_total

* Calculate Enterprise Self-Sufficiency
* (Revenues - (Debt Service + Expenditures)) / Revenues
gen ent_self_suff = (ef_totalrev - (ef_debtserv + ef_expendtotal)) / /*
	*/ ef_totalrev

* Debt Load
* Debt Service / Revenues
gen debt_load = totalf_debtserv / totalf_totalrev

* List of generated ratios:
local ratios "cash_balance cash_position ent_self_suff debt_load"
local cols "C H M R"
local mats "sum2013 sum2014 sum2015 sum2016 sum2017 sum2018 sumtotal"
local row = 4

* Open the excel file for saving
putexcel set "ratio_summary.xlsx", modify


* get the relevant statistics
forvalues k=1(1)4 {
	local v : word `k' of `ratios'
	local c : word `k' of `cols'
	
	tabstat `v', by(year) statistics(mean q) save

	mat sum2013 = r(Stat1)'
	mat sum2014 = r(Stat2)'
	mat sum2015 = r(Stat3)'
	mat sum2016 = r(Stat4)'
	mat sum2017 = r(Stat5)'
	mat sum2018 = r(Stat6)'
	mat sumtotal = r(StatTotal)'

	
	foreach mx in `mats' {
		putexcel C`row' = matrix(`mx')
		local row = `row' + 1
	}
	local row = `row' + 3
}


putexcel close