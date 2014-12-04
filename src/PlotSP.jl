includes("surplusprocess.jl")

function PlotSP(surplusprocess)
ppp=5000;
u=zeros(1000);
spe=zeros(1000);
spm=zeros(1000);
spf=zeros(1000);
sumpart=zeros(1000);
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

for i=1:1000;
u[i]=i*ppp;
end;
#Sum part in ruin probability
	for z=1:1000
       for i=1:(m+n);
       sumpart[z]=real(sumpart[z]+ Mk[i] * MiLe(Sk[i] * u[z]^(1/n)));
       end;
       end;



for i=1:1000;
spe[i]= 1 - (1 - loss_ratio/expense_ratio)* (leng /duration) * exp(-(1/ (aver)- (leng/duration) /( (leng/duration) * aver * (expense_ratio/loss_ratio))) * u[i])/(1/aver*(leng/duration)*aver*expense_ratio/(loss_ratio) - (leng/duration));
spm[i]=1 + N * exp(s_1 * u[i]) + p * exp( s_2 * u[i]) + q* exp(s_3 * u[i]);
spf[i]= exp(-1/b * u[i])*u[i]^((1-n)/n)*sumpart[i];
end
Dataa=DataFrames.DataFrame(X_1=spe,X_2=spm, X_3=spf,Y=u);
A=Gadfly.plot(Dataa, Gadfly.layer(x="Y", y="X_1", Gadfly.Geom.point, Gadfly.Theme(default_color=Gadfly.color("red"))
), Gadfly.layer(x="Y", y="X_2", Gadfly.Geom.point, Gadfly.Theme(default_color=Gadfly.color("black"))),Gadfly.layer(x="Y", y="X_3", Gadfly.Geom.point, Gadfly.Theme(default_color=Gadfly.color("green"))
),  Gadfly.Guide.xlabel("Simulation"), Gadfly.Guide.ylabel("Real Data"), Gadfly.Guide.title("Survival Probability"));
end
