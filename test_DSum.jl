using RuinProbability

initial_capital=0
claims_data=collect(readdlm("/Users/Hank/Documents/Text-Company data in Julia/DATA.txt"))
loss_ratio=0.51779566757834
expense_ratio=0.7068
duration= 10
sp=SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration)

SPExp(sp)

nexp=10
a = 0.5/(log(mean(sp.claims_data)) - mean(log(sp.claims_data)));
b = mean(sp.claims_data)/a;
leng = length(sp.claims_data);
aver = mean(sp.claims_data);
Alpha = zeros(nexp);
P_a = zeros(nexp);
w=sort(sp.claims_data);
AA=EMfit(sp,nexp);
for n=1:nexp;
Alpha[n] = AA[2][n];
P_a[n] = AA[1][n];
end;
percentile = zeros(leng);
for i=1:leng;
percentile[i]=i/leng;
end;

QQ_1=zeros(leng);
QQ_FG=zeros(leng);
for i=1:leng;
QQ_1[i]=quantile(Distributions.Exponential(aver),percentile[i]);
QQ_FG[i]=quantile(Distributions.Gamma(a,b),percentile[i]);
end;

S1=0;
S2=0;
S3=0;
QQ_m=zeros(leng);
for i=1:leng;
QQ_m[i]=QQ_1[i];
end;
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
QQ_m
QQ_1
pop!(QQ_FG)
pop!(QQ_1)
pop!(w)
pop!(QQ_m);

S1=abs(sum(w)-sum(QQ_1));
S2=abs(sum(w)-sum(QQ_m));
S3=abs(sum(w)-sum(QQ_FG));

Exp=S1/(leng-1);
FG=S3/(leng-1);
MixExp=S2/(leng-1);
ModelName=["Exp", "MixExp", "FG"];
Values=[Exp, MixExp, FG];
Data=DataFrames.DataFrame(Model=ModelName, DSum=Values)
Data=DataFrames.DataFrame(Model=ModelName, DSum=Values)
Data=DataFrames.DataFrame(Model=ModelName, DSum=Values)
QQ_1
QQ_m
QQ_FG
w