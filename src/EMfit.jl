function EMfit(claims_data)
leng=length(claims_data);

       Theta = [100000. 100000. 100000.];
       P = [0.5 0.4 0.1];
       w = zeros(leng,3);
       Q = zeros(leng,3);
       A = zeros(leng,3);
       sumQ = zeros(1,3); 
       sumA = zeros(1,3);
       
       for n = 1:300;
              for j =1:3;
                     for i =1:leng;
                     
                            w[i,j] = P[j] * (1 / Theta[1,j]) * exp(-claims_data[i] / Theta[1,j]) / (P[1] * (1 / Theta[1,1]) * exp(-claims_data[i] / Theta[1,1]) + P[1,2] * (1 / Theta[1,2]) * 
                            exp(-claims_data[i] / Theta[1,2]) + P[3] * (1 / Theta[1,3]) * exp (-claims_data[i] / Theta[1,3]))
                     end;
              end;
              for m=1:3;
                     for k=1:leng;
                            Q[k,m] = w[k,m] * claims_data[k];
                            A[k,m] = w[k,m];
                     end;
                     Theta[1,m] = sum(Q[:,m]) / sum(A[:,m]); 
                     P[1,m] = sum(A[:,m]) / 344;
              end;
       end;
       Alpha=zeros(3);
       P_a=zeros(3);
       for n=1:3;
              Alpha[n]=1/Theta[n];
              P_a[n]=P[n];
       end;
       return (P_a, Alpha);
       end
