function SPMixExp(sp::SurplusProcess,nexp::Int64) 
       Alpha = zeros(3);
	P_a = zeros(3);
	
       leng = length(sp.claims_data);
       aver = mean(sp.claims_data);
       AA=EMfit(sp.claims_data,nexp);
       for n=1:3;
              Alpha[n] = AA[2][n];
              P_a[n] = AA[1][n];
       end;
       A = ((leng / sp.duration * aver * sp.expense_ratio / sp.loss_ratio) * (Alpha[1] + Alpha[2] + Alpha[3]) – leng / sp.duration) / (leng / sp.duration * aver * sp.expense_ratio / sp.loss_ratio) ;
       B = ((leng / sp.duration * aver * sp.expense_ratio / sp.loss_ratio) * (Alpha[1] * Alpha[2] + Alpha[3] * Alpha[2] + Alpha[1] * Alpha[3]) - (Alpha[1] + Alpha[2] + Alpha[3]) * leng / sp.duration + (Alpha[1] * P_a[1] + Alpha[2] * P_a[2] + Alpha[3] * P_a[3]) * leng / sp.duration) / (leng / sp.duration * aver * sp.expense_ratio / sp.loss_ratio);
       C = ((leng / sp.duration * aver * sp.expense_ratio / sp.loss_ratio) * Alpha[1] * Alpha[2] * Alpha[3] - (Alpha[1] * Alpha[2] + Alpha[1] * Alpha[3] + Alpha[3] * Alpha[2]) * leng / sp.duration + (Alpha[1] * P_a[1] * (Alpha[2] + Alpha[3]) + Alpha[2] * P_a[2] * (Alpha[1] + Alpha[3]) + Alpha[3] * P_a[3] * (Alpha[1] + Alpha[2])) * leng / sp.duration) / (leng / sp.duration * aver * sp.expense_ratio / sp.loss_ratio);
        
       a = -(A^3)/27 + -C/2 + A*B/6;
       b = B/3 + -(A^2)/9;
       
       s_1 = -A/3 + 2 * sqrt(-b) * cos(acos(a/(-b)^(3/2))/3);
       s_2 = -A/3 + 2 * sqrt(-b) * cos((acos(a/(-b)^(3/2) )+ 2pi)/3);
       s_3 = -A/3 + 2 * sqrt(-b) * cos((acos(a/(-b)^(3/2) )- 2pi)/3);
       
       M = -(( 1- sp.loss_ratio / sp.expense_ratio) * Alpha[1] * Alpha[2] * Alpha[3]) / (s_1 * s_2 * s_3);
       p = 1 / ((s_2 - s_1) * (s_3 - s_2)) * ((1- sp.loss_ratio / sp.expense_ratio) * (-s_2 * (Alpha[1] + Alpha[2] + Alpha[3]) - s_2^2 - (Alpha[1] * Alpha[2] + Alpha[1] * Alpha[3] + Alpha[3] * Alpha[2])) + s_1 * s_3 * M);
       N = 1/(s_3 - s_1) * (-(1- sp.loss_ratio / sp.expense_ratio) * (Alpha[1] + Alpha[2] + Alpha[3]) - M * s_3 - (s_1 + s_2) * (1- sp.loss_ratio / sp.expense_ratio) - (s_3-s_2) * p);
       q = (1- sp.loss_ratio / sp.expense_ratio) - M - N - p;
       sm = 1 + N * exp(s_1 * sp.initial_capital) + p * exp( s_2 * sp.initial_capital) + q* exp(s_3 * sp.initial_capital);
end
#-------------------------------------------------------------------------------
# This result is generated from surplus process with mixture three exponential claims distribution and claims size is distributed by poison process. The function is produced by Laplace transform and inverse Laplace transform from IE to IDE to the final result.
#-------------------------------------------------------------------------------
