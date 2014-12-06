function SPExp(sp::SurplusProcess)
       leng = length(sp.claims_data);
       aver = mean(sp.claims_data);
       
       s = 1 - (1 - sp.loss_ratio / sp.expense_ratio) * leng / sp.duration * exp(-(1 / aver - leng / sp.duration / ( leng / sp.duration * aver * sp.expense_ratio / sp.loss_ratio) * sp.initial_capital ) / (1 / aver * leng / sp.duration * aver * sp.expense_ratio / sp.loss_ratio - leng / sp.duration));
end
#-------------------------------------------------------------------------------
# This result is generated from surplus process with exponential claims distribution and 
#claims size is distributed by poison process. 
#The function is produced by Laplace transform 
#and inverse Laplace transform from IE to IDE to the final result.   
#-------------------------------------------------------------------------------
