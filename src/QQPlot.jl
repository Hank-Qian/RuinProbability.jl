function QQPlot(sp::SurplusProcess, nexp::Int64)
	Gadfly.set_default_plot_size(20Gadfly.cm, 20Gadfly.cm);
       a = 0.5/(log(mean(sp.claims_data)) - mean(log(sp.claims_data)));
       b = mean(sp.claims_data)/a;
       leng = length(sp.claims_data);
       aver = mean(sp.claims_data);
       Alpha = zeros(nexp);
       P_a = zeros(nexp);
       AA=EMfit(sp,nexp);
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
	sum2 = P_a[j] * Alpha[j] * exp(-Alpha[j] * QQ_m[i]) +sum2
	end
              F[i] = sum1-percentile[i];
              F_d[i] = sum2
       end;
       
       for n=1:10;
       		for i=1:leng;
                	QQ_m[i]=QQ_m[i] - F[i]/F_d[i];
                end;
                for i=1:leng;
	sum1=0;
	sum2=0;
	for j=1:nexp
	sum1 = P_a[j] *(1 - exp(-Alpha[j] * QQ_m[i])) + sum1;
	sum2 = P_a[j] * Alpha[j] * exp(-Alpha[j] * QQ_m[i]) +sum2
	end
              F[i] = sum1-percentile[i];
              F_d[i] = sum2
       end;
       end ;
       pop!(QQ_1);
       pop!(QQ_m);
       pop!(QQ_FG);
       pop!(w);

       Data=DataFrames.DataFrame(X_1=QQ_1,X_2=QQ_m,X_3=QQ_FG, Y=w);
       
       CCC=Gadfly.plot(Data, Gadfly.layer(x="Y", y="X_1", Gadfly.Geom.point, Gadfly.Theme(default_color=Gadfly.color("red"))
       ),Gadfly.layer(x="Y", y="X_2", Gadfly.Geom.point, Gadfly.Theme(default_color=Gadfly.color("blue"))
       ),Gadfly.layer(x="Y", y="X_3", Gadfly.Geom.point, Gadfly.Theme(default_color=Gadfly.color("green"))
       ),Gadfly.layer(x="Y", y="Y", Gadfly.Geom.line, Gadfly.Theme(default_color=Gadfly.color("black"))),  Gadfly.Guide.xlabel("Simulation"), Gadfly.Guide.ylabel("Real Data"), Gadfly.Guide.title("QQ-Plot"));
     
end
