*Importing data
insheet using crime-iv.csv, comma names clear

label variable defendantid "Defendant ID"
label variable republicanjudge "Republican Judge"
label variable severityofcrime "Severity of crime"
label variable monthsinjail "Months in jail"
label variable recidivates "Recidivates"

*Creating balance table for covariates
global balanceopts "prehead(\begin{tabular}{l*{6}{c}}) postfoot(\end{tabular}) noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01)"

estpost ttest severityofcrime, by(republicanjudge) unequal welch
esttab using balance_test.tex, cell("mu_1(f(3)) mu_2(f(3)) b(f(3) star)") wide label collabels("Democratic Judge" "Republican Judge" "Difference") noobs $balanceopts mlabels(none) eqlabels(none) replace mgroups(none)

*Creating a first-stage IV regression
reg monthsinjail republicanjudge severityofcrime

*Store regression
eststo first_stage_reg

*Outputting results of first-stage IV regression
global tableoptions "bf(%15.2gc) sfmt(%15.2gc) prehead(\begin{tabular}{l*{14}{c}}) postfoot(\end{tabular}) se label noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01) replace r2"
esttab first_stage_reg using table1.tex, $tableoptions keep(republicanjudge severityofcrime _cons)

*Creating the "reduced form" IV regression
reg recidivates republicanjudge severityofcrime

*Store regression
eststo reduced_form_reg

*Outputting results of "reduced form" IV regression
global tableoptions "bf(%15.2gc) sfmt(%15.2gc) prehead(\begin{tabular}{l*{14}{c}}) postfoot(\end{tabular}) se label noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01) replace r2"
esttab reduced_form_reg using table2.tex, $tableoptions keep(republicanjudge severityofcrime _cons)

ssc install ivreg2

*Creating the overall IV regression
ivreg2 recidivates (monthsinjail=republicanjudge) severityofcrime
eststo overall_iv_reg

*Outputting results of overall IV regression
global tableoptions "bf(%15.2gc) sfmt(%15.2gc) prehead(\begin{tabular}{l*{14}{c}}) postfoot(\end{tabular}) se label noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01) replace r2"
esttab overall_iv_reg using table3.tex, $tableoptions keep(severityofcrime monthsinjail _cons)