function MeanSquare(sp::SurplusProcess, nexp::Int64)
       a = 0.5/(log(mean(sp.claims_data)) - mean(log(sp.claims_data)));
       b = mean(sp.claims_data)/a;
       leng = length(sp.claims_data);
       aver = mean(sp.claims_data);
       Alpha = zeros(nexp);
       P_a = zeros(nexp);
       AA=EMfit(sp.claims_data,nexp);
       for n=1:nexp;
              Alpha[n] = AA[2][n];
              P_a[n] = AA[1][n];
       end;
       
       percentile = rand(leng);
       for i=1:leng;
            percentile[i]=i/leng;
       end;
       
       QQ_1=rand(leng); 
       QQ_FG=rand(leng);
       for i=1:leng;
       
            QQ_1[i]=quantile(Distributions.Exponential(aver),percentile[i]);
            QQ_FG[i]=quantile(Distributions.Gamma(a,b),percentile[i]);
       end;
       
       w=sort(sp.claims_data);
       QQ_m=zeros(leng);
       F=zeros(leng);
       F_d=zeros(leng);
	sum1=0;
	sum2=0;
	for i=1:leng
		sum1=0;
		sum2=0;
		for j=1:nexp
			sum1 = P_a[j] *(1 - exp(-Alpha[j] * QQ_m[i])) + sum1;
			sum2 = P_a[j] * Alpha[j] * exp(-Alpha[j] * QQ_m[i]) +sum2;
		end
	        F[i] = sum1-percentile[i];
	        F_d[i] = sum2
        end;
       
        for n=1:20;
	       	for i=1:leng;
		        QQ_m[i]=QQ_m[i] - F[i]/F_d[i];
	        end;
	        for i=1:leng;
			sum1=0;
			sum2=0;
			for j=1:nexp
				sum1 = P_a[j] *(1 - exp(-Alpha[j] * QQ_m[i])) + sum1;
				sum2 = P_a[j] * Alpha[j] * exp(-Alpha[j] * QQ_m[i]) +sum2;
			end
		        F[i] = sum1-percentile[i];
		        F_d[i] = sum2;
	        end;
        end;
       	S1=0;
	S2=0;
	S3=0;
	
      for i=1:leng-2;
        S1=(QQ_1[i]-w[i])^2+S1;
        S2=(QQ_m[i]-w[i])^2+S2;
        S3=(QQ_FG[i]-w[i])^2+S3;
       end;
       Exp=S1/(leng-2);
       MixExp=S2/(leng-2);
       FG=S3/(leng-2);
       ModelName=["Exp", "MixExp", "FG"];
       Values=[Exp, MixExp, FG];
       Data=DataFrames.DataFrame(Model=ModelName, MeanSquare=Values)
       end
