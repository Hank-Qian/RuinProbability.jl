function QQPlot(claims_data)
leng=length(claims_data)
       for n=1:3;
              Alpha[n]=EMfit(claims_data)[2][n]
              P_a[n]= EMfit(claims_data)[1][n]
       end;
       w=rand(Distributions.Exponential(aver),100000);
       percentile=rand(leng);
       for i=1:leng;
            percentile[i]=i/leng;
       end;
       QQ_1=rand(leng); 
       for i=1:leng;
            QQ_1[i]=quantile(w,percentile[i]);
       end;
       w=sort(claims_data);
       QQ_3=zeros(leng);
       F=zeros(leng);
       F_d=zeros(leng);
       for i=1:leng;
              F[i]=P_a[1] *(1 - exp(-Alpha[1] * QQ_3[i]))+ P_a[2] * (1 - exp(-Alpha[2] * QQ_3[i])) + P_a[3] * (1 - exp(-Alpha[3] * QQ_3 [i])) -percentile[i];
              F_d[i]= P_a[1] * Alpha[1]  * exp(-Alpha[1] * QQ_3[i]) + P_a[2] * Alpha[2]  * exp(-Alpha[2] * QQ_3 [i]) + P_a[3] * Alpha[3]  * exp(-Alpha[3] * QQ_3 [i]);
       end;
              for n=1:10;
                     for i=1:leng;
                     QQ_3[i]=QQ_3[i] - F[i]/F_d[i];
                     end;
                     for i=1:leng;
                     F[i]=P_a[1] *(1 - exp(-Alpha[1] * QQ_3[i]))+ P_a[2] * (1 - exp(-Alpha[2] * QQ_3[i])) + P_a[3] * (1 - exp(-Alpha[3] * QQ_3 [i])) -percentile[i];
                     F_d[i]= P_a[1] * Alpha[1]  * exp(-Alpha[1] * QQ_3[i]) + P_a[2] * Alpha[2]  * exp(-Alpha[2] * QQ_3 [i]) + P_a[3] * Alpha[3]  * exp(-Alpha[3] * QQ_3 [i]);
                     end;
              end ;
       Data=DataFrames.DataFrame(X_1=QQ_1,X_3=QQ_3, Y=w);
       Gadfly.plot(Data, Gadfly.layer(x="X_1", y="Y", Gadfly.Geom.point, Gadfly.Theme(default_color=Gadfly.color("red"))
       ), Gadfly.layer(x="X_3", y="Y",Gadfly.Geom.point),Gadfly.layer(x="Y", y="Y", Gadfly.Geom.line, Gadfly.Theme(default_color=Gadfly.color("black"))),  Gadfly.Guide.xlabel("Simulation"), Gadfly.Guide.ylabel("Real Data"), Gadfly.Guide.title("QQ-Plot"));
end
#-------------------------------------------------------------------------------
# QQPlot presents the evaluation of the fitting. In this QQPlot function, it will provide the comparison between two different claims distributions.
#-------------------------------------------------------------------------------
