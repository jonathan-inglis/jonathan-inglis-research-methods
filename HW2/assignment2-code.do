*Importing data
insheet using vaping-ban-panel.csv, comma names clear

*Labelling states as treated vs. non-treated
bysort stateid : egen ever_banned=max(vapingban)

*Labelling as pre- and post-policy change
gen post = year>=2021

*Creating interaction term
gen interaction = year*ever_banned

label variable lunghospitalizations "Lung Hospitalizations"
label variable ever_banned "Treated"
label variable interaction "Year*Treated (interaction)"
label variable year "Year"

*Regression to test for parallel trends (interaction term)
reg lunghospitalizations year ever_banned interaction if year<2021

*Store regression
eststo parallel_reg

*Outputting results of parallel trends regression
global tableoptions "bf(%15.2gc) sfmt(%15.2gc) se label noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01) replace r2"
esttab parallel_reg using Assignment-2-Table-1.rtf, $tableoptions keep(year ever_banned interaction _cons)

*Creating canonical DnD plot
collapse (mean) lunghospitalizations, by(year ever_banned)
twoway (line lunghospitalizations year if ever_banned==1) (line lunghospitalizations year if ever_banned==0), xline(2021) legend(label(1 Treated) label(2 Control)) ytitle("(Mean) Lung hospitalizations")

insheet using vaping-ban-panel.csv, comma names clear

*Labelling states as treated vs. non-treated
bysort stateid : egen ever_banned=max(vapingban)

label variable vapingban "Vaping ban"
label variable lunghospitalizations "Lung Hospitalizations"
label variable ever_banned "Treated"
label variable stateid "State"
label variable year "Year"

*Fixed effects regression
reg lunghospitalizations vapingban i.stateid i.year

*Store regression
eststo fixed_reg

*Outputting results of fixed effects regression
global tableoptions "bf(%15.2gc) sfmt(%15.2gc) se label noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01) replace r2"
esttab fixed_reg using Assignment-2-Table-2.rtf, $tableoptions keep(vapingban _cons) 