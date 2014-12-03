module RuinProbability

       using DataFrames;
       using Distributions;
       using Gadfly;
       using Polynomial;
export SPExp, SPMixExp, SPFG, QQPlot,  surplusprocess, EMfit

#-------------------------------------------------------------------------------
# SPExp: survival probability under exponential distribution
# SPMixExp: survival probability under mixture three exponential distribution
# QQPlot: QQplot comparison between two different claims models
#-------------------------------------------------------------------------------
type surplusprocess
       initial_capital::Number;
       claims_data::Array{Float64,1};
       loss_ratio::Float64;
       expense_ratio::Float64;
       duration::Number;
end
#-------------------------------------------------------------------------------
# User needs to input some basic information about the company.
# For example, user needs to type:
# initial_capital=10000
# claims_data=Array ( which can be plugin by collecting from text file, and the data should be only a row without title)
# loss_ratio=0.67
# expense_rati=0.2
# duration=10 ( the unit of duration is year)
#-------------------------------------------------------------------------------
include("SPExponential.jl");
include("SPMix3Exponential.jl");
include("QQPlot.jl");
include("EMfit");
include("SPFG");
end # module


function EMfit(claims_data)
       Theta = [100000. 100000. 100000.];
       P = [0.5 0.4 0.1];
       w = zeros(344,3);
       Q = zeros(344,3);
       A = zeros(344,3);
       sumQ = zeros(1,3); 
       sumA = zeros(1,3);
       
       for n = 1:300;
              for j =1:3;
                     for i =1:344;
                     
                            w[i,j] = P[j] * (1 / Theta[1,j]) * exp(-claims_data[i] / Theta[1,j]) / (P[1] * (1 / Theta[1,1]) * exp(-claims_data[i] / Theta[1,1]) + P[1,2] * (1 / Theta[1,2]) * 
                            exp(-claims_data[i] / Theta[1,2]) + P[3] * (1 / Theta[1,3]) * exp (-claims_data[i] / Theta[1,3]))
                     end;
              end;
              for m=1:3;
                     for k=1:344;
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


function QQPlot(claims_data)
       for n=1:3;
              Alpha[n]=EMfit(claims_data)[2][n]
              P_a[n]= EMfit(claims_data)[1][n]
       end;
       w=rand(Distributions.Exponential(aver),100000);
       percentile=rand(344);
       for i=1:344;
            percentile[i]=i/344;
       end;
       QQ_1=rand(344); 
       for i=1:344;
            QQ_1[i]=quantile(w,percentile[i]);
       end;
       w=sort(claims_data);
       QQ_3=zeros(344);
       F=zeros(344);
       F_d=zeros(344);
       for i=1:344;
              F[i]=P_a[1] *(1 - exp(-Alpha[1] * QQ_3[i]))+ P_a[2] * (1 - exp(-Alpha[2] * QQ_3[i])) + P_a[3] * (1 - exp(-Alpha[3] * QQ_3 [i])) -percentile[i];
              F_d[i]= P_a[1] * Alpha[1]  * exp(-Alpha[1] * QQ_3[i]) + P_a[2] * Alpha[2]  * exp(-Alpha[2] * QQ_3 [i]) + P_a[3] * Alpha[3]  * exp(-Alpha[3] * QQ_3 [i]);
       end;
              for n=1:10;
                     for i=1:344;
                     QQ_3[i]=QQ_3[i] - F[i]/F_d[i];
                     end;
                     for i=1:344;
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
function SPFG(surplusprocess)
#Gamma Distribution Fitting by MLE
a = 0.5/(log(mean(claims_data)) - mean(log(claims_data)));
b = mean(claims_data)/a;
#claims are distributed Gamma(a,b)
#Set Gamma parameter ‘a’ to rational number m/n
m=0;
n=0;
a_0=a;
for i=1:100;
if a<10;
a= a*10;
elseif a >= 10;
m=integer(a);
n= integer(a/a_0);
end;
end;
#Calculate Sk roots from special equation
aver = mean(claims_data);
leng = length(claims_data);
poli=zeros(m+n+1);
poli[1]= (leng/duration)*aver*expense_ratio/(loss_ratio);
poli[n+1]=-((leng/duration)*aver*(expense_ratio/loss_ratio)*(1/b)+(leng /duration));
poli[m+n+1]= (leng/duration)*(1/b)^(m/n);
Sk=Polynomial.roots(Polynomial.Poly(poli));
#This function is to compute parameters Mk
f(x)= (1 - loss_ratio/expense_ratio)*x^m;
Mk=Array(Complex{Float64},m+n);
product=1;
for i= 1:(m+n);
product= 1;
for z= 1:(m+n);
if z != i ;
product= product * (Sk[i]-Sk[z]);
else;
product= product;
end;
end;
Mk[i]= f(Sk[i])/product;
end;
#Special function for gamma distribution
function MiLe(z);
s=0;
for k=1:10000;
s = (z^(k-1))/gamma((1/n)*(k-1) + (1/n))+s;
end;
return s;
end;

#Sum part in fractional gamma distribution ruin probability
sumpart=0;
for i=1:(m+n);
sumpart=sumpart+ Mk[i] * MiLe(Sk[i] * initial_capital^(1/n));
end;
#Ruin probability of fractional Gamma
S = exp(-1/b * initial_capital)*initial_capital^((1-n)/n)*sumpart;
return real(S);
end
