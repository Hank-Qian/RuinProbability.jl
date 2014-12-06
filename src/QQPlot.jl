function QQPlot(claims_data)
       a = 0.5/(log(mean(claims_data)) - mean(log(claims_data)));
       b = mean(claims_data)/a;
       leng = length(claims_data);
       aver = mean(claims_data);
       Alpha = zeros(3);
       P_a = zeros(3);
       
       for n = 1:3;
              Alpha[n] = EMfit(claims_data)[2][n];
              P_a[n] = EMfit(claims_data)[1][n];
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
       
       w=sort(claims_data);
       QQ_3=zeros(leng);
       F=zeros(leng);
       F_d=zeros(leng);
       
       for i=1:leng;
              F[i] = P_a[1] *(1 - exp(-Alpha[1] * QQ_3[i])) + P_a[2] * (1 - exp(-Alpha[2] * QQ_3[i])) + P_a[3] * (1 - exp(-Alpha[3] * QQ_3 [i])) -percentile[i];
              F_d[i] = P_a[1] * Alpha[1]  * exp(-Alpha[1] * QQ_3[i]) + P_a[2] * Alpha[2]  * exp(-Alpha[2] * QQ_3 [i]) + P_a[3] * Alpha[3]  * exp(-Alpha[3] * QQ_3 [i]);
       end;
       
       for n=1:10;
       		for i=1:leng;
                	QQ_3[i]=QQ_3[i] - F[i]/F_d[i];
                end;
                for i=1:leng;
	                F[i] = P_a[1] *(1 - exp(-Alpha[1] * QQ_3[i])) + P_a[2] * (1 - exp(-Alpha[2] * QQ_3[i])) + P_a[3] * (1 - exp(-Alpha[3] * QQ_3 [i])) - percentile[i];
	                F_d[i] = P_a[1] * Alpha[1]  * exp(-Alpha[1] * QQ_3[i]) + P_a[2] * Alpha[2]  * exp(-Alpha[2] * QQ_3 [i]) + P_a[3] * Alpha[3]  * exp(-Alpha[3] * QQ_3 [i]);
	        end;
        end ;
        
	S1=zeros(leng);
	S2=zeros(leng);
	S3=zeros(leng-1);
	
      for i=1:leng-1
        S1[i]=(QQ_1[i]-w[i])^2+S1[i]
        S3[i]=(QQ_3[i]-w[i])^2+S2[i]
        S2[i]=(QQ_FG[i]-w[i])^2+S3[i]
       end
       
       Data=DataFrames.DataFrame(X_1=QQ_1,X_2=QQ_3,X_3=QQ_FG, Y=w);
       
       Gadfly.plot(Data, Gadfly.layer(x="X_1", y="Y", Gadfly.Geom.point, Gadfly.Theme(default_color=Gadfly.color("red"))
       ),Gadfly.layer(x="X_2", y="Y", Gadfly.Geom.point, Gadfly.Theme(default_color=Gadfly.color("blue"))
       ),Gadfly.layer(x="X_3", y="Y", Gadfly.Geom.point, Gadfly.Theme(default_color=Gadfly.color("green"))
       ),Gadfly.layer(x="Y", y="Y", Gadfly.Geom.line, Gadfly.Theme(default_color=Gadfly.color("black"))),  Gadfly.Guide.xlabel("Simulation"), Gadfly.Guide.ylabel("Real Data"), Gadfly.Guide.title("QQ-Plot"));
       
       sum(S1);
       sum(S2);
       sum(S3);
end
