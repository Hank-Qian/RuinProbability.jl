using RuinProbability
initial_capital=10000.0
claims_data=collect(readdlm("/Users/Hank/Documents/Text-Aspen data in Julia/DATA.txt"))
loss_ratio=0.51779566757834
expense_ratio=0.7068
duration= 10
SP=SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration)
EMfit(claims_data,3)
QQPlot(SP,3)
MeanSquare(SP,3)
MeanSquare(SP,4)