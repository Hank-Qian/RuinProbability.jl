type SurplusProcess
       initial_capital::Number;
       claims_data::Array{Float64,1};
       loss_ratio::Float64;
       expense_ratio::Float64;
       duration::Number;
end
#-------------------------------------------------------------------------------
# User needs to input some basic information about the company.
# For example, user needs to type:
# initial_capital=10000
# claims_data=Array ( which can be plugin by collecting from text file, and the data should be only a row without title)
# loss_ratio=0.67
# expense_rati=0.2
# duration=10 ( the unit of duration is year)
#-------------------------------------------------------------------------------
