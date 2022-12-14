* Read in data: 
insheet using assignment1-research-methods.csv, comma names clear

*Relabelling all variables
label variable calledback "Called back"
label variable recruiteriswhite "White recruiter"
label variable recruiterismale "Male recruiter"
label variable malecandidate "Male candidate"
label variable eliteschoolcandidate "Elite school candidate"
label variable bigcompanycandidate "Big company candidate"

* Run regression: 
reg calledback eliteschoolcandidate bigcompanycandidate malecandidate

* Store regression
eststo regression_called_back 

* Output table:
global tableoptions "bf(%15.2gc) sfmt(%15.2gc) se label noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01) replace r2"
esttab regression_called_back using assignment1.rtf, $tableoptions keep(eliteschoolcandidate bigcompanycandidate malecandidate _cons) 
