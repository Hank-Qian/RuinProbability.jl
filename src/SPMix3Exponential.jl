function SPMixExp(surplusprocess) 
       Alpha=zeros(3);
       P_a=zeros(3);
       leng = length(claims_data);
       aver = mean(claims_data);
       for n=1:3;
              Alpha[n]=EMfit(claims_data)[2][n];
              P_a[n]= EMfit(claims_data)[1][n];
       end;
       A=(((leng/duration)*aver*expense_ratio/(loss_ratio))
        * (Alpha[1] + Alpha[2] + Alpha[3]) - (leng/duration))/ ((leng/duration)*aver*expense_ratio/(loss_ratio));
       B=(((leng/duration)*aver*expense_ratio/(loss_ratio))
        * (Alpha[1] * Alpha[2] + Alpha[3] * Alpha[2] + Alpha[1] * Alpha[3]) - (Alpha[1] + Alpha[2] + Alpha[3]) * (leng/duration) + (Alpha[1] * P_a[1] + Alpha[2] * P_a[2] + Alpha[3] * P_a[3]) * (leng/duration)) / ((leng/duration)*aver*expense_ratio/(loss_ratio));
       C=(((leng/duration)*aver*expense_ratio/(loss_ratio))
        * Alpha[1] * Alpha[2] * Alpha[3] - (Alpha[1] * Alpha[2] + Alpha[1] * Alpha[3] + Alpha[3] * Alpha[2]) * (leng/duration) + (Alpha[1] * P_a[1] * (Alpha[2] + Alpha[3]) + Alpha[2] * P_a[2] * (Alpha[1] + Alpha[3]) + Alpha[3] * P_a[3] * (Alpha[1] + Alpha[2])) * (leng/duration)) / ((leng/duration)*aver*expense_ratio/(loss_ratio));
       a= -(A^3)/27 + -C/2 + A*B/6;
       b= B/3 + -(A^2)/9;
       s_1= -A/3 + 2 * sqrt(-b) * cos(acos(a/(-b)^(3/2))/3);
       s_2= -A/3 + 2 * sqrt(-b) * cos((acos(a/(-b)^(3/2) )+ 2pi)/3);
       s_3= -A/3 + 2 * sqrt(-b) * cos((acos(a/(-b)^(3/2) )- 2pi)/3);
       M=-((1- loss_ratio/expense_ratio) * Alpha[1] * Alpha[2] * Alpha[3]) / (s_1 * s_2 * s_3);
       p=(1/((s_2 - s_1) * (s_3 - s_2))) * ((1- loss_ratio/expense_ratio) * (-s_2 * (Alpha[1] + Alpha[2] + Alpha[3]) - (s_2)^2 - (Alpha[1] * Alpha[2] + Alpha[1] * Alpha[3] + Alpha[3] * Alpha[2])) + s_1 * s_3 * M);
       N= (1/(s_3 - s_1)) * (-(1- loss_ratio/expense_ratio) * (Alpha[1] + Alpha[2] + Alpha[3]) - M * s_3 - (s_1 + s_2) * (1- loss_ratio/expense_ratio) - (s_3-s_2) * p);
       q=(1- loss_ratio/expense_ratio) - M - N - p;
       sm=1 + N * exp(s_1 * initial_capital) + p * exp( s_2 * initial_capital) + q* exp(s_3 * initial_capital);
end
#-------------------------------------------------------------------------------
# This result is generated from surplus process with mixture three exponential claims distribution and claims size is distributed by poison process. The function is produced by Laplace transform and inverse Laplace transform from IE to IDE to the final result.
#-------------------------------------------------------------------------------