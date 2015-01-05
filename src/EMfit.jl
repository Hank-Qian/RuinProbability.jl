function EMfit(sp::SurplusProcess,nexp::Number)
       maxc=sort(sp.claims_data)[end];
       leng=length(sp.claims_data);
       Theta = rand(0.5*maxc:0.8*maxc,nexp);
       P = ones(nexp)/nexp;
       w = zeros(leng,nexp);
       Q = zeros(leng,nexp);
       A = zeros(leng,nexp);
       sumQ = zeros(1,nexp); 
       sumA = zeros(1,nexp);
       De=0;
       
       for n = 1:300;
              for j = 1:nexp;
                     for i = 1:leng;
                     De=0;
                            for z = 1:nexp
                            De = P[z] * (1 / Theta[z]) * exp(-sp.claims_data[i] / Theta[z]) + De
                            end;
                     w[i,j] = P[j] * (1 / Theta[j]) * exp(-sp.claims_data[i] / Theta[j]) / De
                     end;
              end;
              for m = 1:nexp;
                     for k=1:leng;
                     Q[k,m] = w[k,m] * sp.claims_data[k];
                     A[k,m] = w[k,m];
                     end;
              Theta[m] = sum(Q[:,m]) / sum(A[:,m]); 
              P[m] = sum(A[:,m]) / leng;
              end;
       end;
      
       Alpha=zeros(nexp);
       P_a=zeros(nexp);
       for n=1:nexp;
              Alpha[n]=1/Theta[n];
              P_a[n]=P[n];
       end;
       return (P_a, Alpha);
       end
