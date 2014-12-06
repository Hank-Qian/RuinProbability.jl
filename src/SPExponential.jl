function SPExp(SurplusProcess)
       leng = length(SurplusProcess.claims_data);
       aver = mean(SurplusProcess.claims_data);
       
       s = 1 - (1 - SurplusProcess.loss_ratio / SurplusProcess.expense_ratio) * leng / SurplusProcess.duration * exp(-(1 / aver - leng / SurplusProcess.duration / ( leng / SurplusProcess.duration * aver * SurplusProcess.expense_ratio / SurplusProcess.loss_ratio) * SurplusProcess.initial_capital ) / (1 / aver * leng / SurplusProcess.duration * aver * SurplusProcess.expense_ratio / SurplusProcess.loss_ratio - leng / SurplusProcess.duration));
end
#-------------------------------------------------------------------------------
# This result is generated from surplus process with exponential claims distribution and 
#claims size is distributed by poison process. 
#The function is produced by Laplace transform 
#and inverse Laplace transform from IE to IDE to the final result.   
#-------------------------------------------------------------------------------
