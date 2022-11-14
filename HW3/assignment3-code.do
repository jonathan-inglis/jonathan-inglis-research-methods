*Importing data
insheet using sports-and-education.csv, comma names clear

label variable academicquality "Academic quality"
label variable athleticquality "Athletic quality"
label variable nearbigmarket "Near big market"
label variable alumnidonations2018 "Alumni donations in 2018"
label variable ranked2017 "Ranked in 2017"

*Creating balance table for covariates
global balanceopts "prehead(\begin{tabular}{l*{6}{c}}) postfoot(\end{tabular}) noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01)"

estpost ttest academicquality athleticquality nearbigmarket, by(ranked2017) unequal welch
esttab using balance_test.tex, cell("mu_1(f(3)) mu_2(f(3)) b(f(3) star)") wide label collabels("Control" "Treatment" "Difference") noobs $balanceopts mlabels(none) eqlabels(none) replace mgroups(none)

*Creating a simple linear regression propensity score model
reg ranked2017 academicquality athleticquality nearbigmarket

*Store regression
eststo ranked_reg_1

*Outputting results of propensity score regression
global tableoptions "bf(%15.2gc) sfmt(%15.2gc) prehead(\begin{tabular}{l*{14}{c}}) postfoot(\end{tabular}) se label noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01) replace r2"
esttab ranked_reg_1 using table2.tex, $tableoptions keep(academicquality athleticquality nearbigmarket) 

*Dropping academic quality (non-significant)
reg ranked2017 athleticquality nearbigmarket

*Store regression
eststo ranked_reg_2

*Outputting results of propensity score regression
global tableoptions "bf(%15.2gc) sfmt(%15.2gc) prehead(\begin{tabular}{l*{14}{c}}) postfoot(\end{tabular}) se label noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01) replace r2"
esttab ranked_reg_2 using table3.tex, $tableoptions keep(athleticquality nearbigmarket) 

*Predicting probability of treatment
. logit ranked2017 athleticquality nearbigmarket
. predict propensity_score, pr

*Propensity score stacked histogram
set scheme s1color 
twoway histogram propensity_score, start(0) width(0.05) bc(red%30) freq || histogram propensity_score if ranked2017==0, start(0) width(0.05) bc(blue%30) freq legend(order(1 "Treatment (Ranked)" 2 "Control (Unranked)"))

*Dropping observations that lie within regions of no overlap
drop if propensity_score<0.15
drop if propensity_score>0.80

*Grouping observations into "blocks" based on propensity scores, block size 4
. sort propensity_score
. gen block = floor(_n/4)

label variable block "Block #"

*Fixed effects regression to estimate treatment effect of being ranked
reg alumnidonations2018 athleticquality academicquality nearbigmarket ranked2017 i.block

*Store regression
eststo alumni_donations_reg

*Outputting results of fixed effects regression
global tableoptions "bf(%15.2gc) sfmt(%15.2gc) prehead(\begin{tabular}{l*{14}{c}}) postfoot(\end{tabular}) se label noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01) replace r2"
esttab alumni_donations_reg using table4.tex, $tableoptions keep(athleticquality academicquality nearbigmarket ranked2017 _cons)