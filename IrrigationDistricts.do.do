/*I've saved this file in my Teaching Folder. So this File path will not work for you. You'll need to create your own file path*/
use "/Users/skioko/Dropbox/Teaching/Daniel J Evans/557 FINANCIAL MKS/..../Assignments/BARS:FIT/BARS Data/BARSDATAFINAL.dta"

/*Total Revenues in $ Millions*/
gen totalf_totalrev_mills = totalf_totalrev/1000000

/*Summarize Total Revenue by Year*/
tabstat totalf_totalrev_mills, statistics( mean count ) by(year)

/*Summarize Total Revenue by Government Code*/
tabstat totalf_totalrev_mills, statistics( mean count ) by(govttypecode)

/*Summarize Total Revenue by Government Type*/
tabstat totalf_totalrev_mills, statistics( mean count ) by(govttype)

/*Summarize Total Revenue by Government Type and Year (5 being Library Districts)*/
tabstat totalf_totalrev_mills if govttypecode==5, statistics( mean count ) by(name)

/*Estimate Tax Revenue as a percent of Total Revenue - Total Funds*/
gen totalfunds_taxshare = totalf_totaltax/totalf_totalrev
tabstat totalfunds_taxshare, statistics( mean count ) by(year)
tabstat totalfunds_taxshare, statistics( mean count ) by(govttype)
tabstat totalfunds_taxshare if govttypecode==5, statistics( mean count ) by(name)
tabstat totalfunds_taxshare if govttypecode==5, statistics( mean count ) by(year)

/*Estimate Growth in Tax Revenue*/
gen growth_totalfunds_tax = (totalf_totaltax/L.totalf_totaltax)-1
tabstat growth_totalfunds_tax, statistics( mean count ) by(year)
tabstat growth_totalfunds_tax, statistics( mean count ) by(govttype)
tabstat growth_totalfunds_tax if govttypecode==9, statistics( mean count ) by(name)
tabstat growth_totalfunds_tax if govttypecode==9, statistics( mean count ) by(year)
/*There are likely obvious outliers when you do some estimates. Be sure to review the raw data (either in Stata or on the FIT platform)
to understand why this government reported a large increase decrease in revenues from any source*/

/*Estimate General Fund Cash a percent of Expenditures*/
gen gf_cash_exp_ratio = gf_unreservcash_end/gf_expendtotal
tabstat gf_cash_exp_ratio, statistics( mean count ) by(year)
tabstat gf_cash_exp_ratio, statistics( mean count ) by(govttype)
tabstat gf_cash_exp_ratio if govttypecode==9, statistics( mean count ) by(name)
tabstat gf_cash_exp_ratio if govttypecode==9, statistics( mean count ) by(year)
