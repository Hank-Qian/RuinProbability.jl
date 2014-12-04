type surplusprocess
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

function SPExp(surplusprocess)
       leng = length(claims_data);
       aver = mean(claims_data);
       s= 1 - (1 - loss_ratio/expense_ratio)* (leng /duration) * exp(-(1/ (aver)- (leng/duration) /( (leng/duration) * aver * (expense_ratio/loss_ratio))) * initial_capital)/(1/aver*(leng/duration)*aver*expense_ratio/(loss_ratio) - (leng/duration));
end
#-------------------------------------------------------------------------------
# This result is generated from surplus process with exponential claims distribution and claims size is distributed by poison process. The function is produced by Laplace transform and inverse Laplace transform from IE to IDE to the final result.   
#-------------------------------------------------------------------------------
