RuinProbability
===============
This [Julia language](http://julialang.org) package is based on ruin theory in acturail field.
The ruin model is defined as [Cramér–Lundberg model](http://matthewhr.wordpress.com/2012/12/11/cramer-lundberg-model/). Claims data is fitted by exponential distribution and mixture three exponential distribution, claims size is generated by Possion process and the inter_arrival time distributes exponential distribution. It will extend to more models in the future. 
##############
Installation
===============
Pkg.add("RuinProbability")
##############
Usgae
==============
There are three functions in the model now. And the functions are related to the information which is inputed by user. For calculating the ruin probability, user needs to input some basic parameters:
##############
initial_capital =
##############
loss_ratio = 
##############
expense_ratio =
##############
duration =
##############
and input the claims_data = by excel or text as well, which can be push into the Julia from outernal file. The format of the claims_data should be a row of data without the title.
Then the function will be work if enter:
SPExp(initial_capital, claims_data, loss_ratio, 	expense_ratio, duration)
SPMixExp(		initial_capital, claims_data, loss_ratio, expense_ratio, duration)
QQPlot(claims_data)

