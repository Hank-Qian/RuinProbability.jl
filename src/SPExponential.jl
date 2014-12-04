include("surplusprocess.jl")

function SPExp(surplusprocess)
       leng = length(claims_data);
       aver = mean(claims_data);
       s= 1 - (1 - loss_ratio/expense_ratio)* (leng /duration) * exp(-(1/ (aver)- (leng/duration) /( (leng/duration) * aver * (expense_ratio/loss_ratio))) * initial_capital)/(1/aver*(leng/duration)*aver*expense_ratio/(loss_ratio) - (leng/duration));
end
#-------------------------------------------------------------------------------
# This result is generated from surplus process with exponential claims distribution and claims size is distributed by poison process. The function is produced by Laplace transform and inverse Laplace transform from IE to IDE to the final result.   
#-------------------------------------------------------------------------------
