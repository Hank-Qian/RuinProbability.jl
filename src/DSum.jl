function DSum(sp::SurplusProcess, nexp::Int64)
       using RuinProbability
initial_capital=10000.0
claims_data=collect(readdlm("/Users/Hank/Documents/Text-company data in Julia/DATA.txt"))
loss_ratio=0.51779566757834
expense_ratio=0.7068
duration= 10
nexp=9
SP=SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration)
w=sort(sp.claims_data);
Alpha = zeros(nexp);
P_a = zeros(nexp);
a = 0.5/(log(mean(sp.claims_data)) - mean(log(sp.claims_data)));
b = mean(sp.claims_data)/a;	
leng = length(sp.claims_data);
aver = mean(sp.claims_data);
AA=EMfit(sp,nexp);
for n=1:nexp;
Alpha[n] = AA[2][n];
P_a[n] = AA[1][n];
end;
PP= zeros(leng);
for i=1:leng;
PP[i]=i/leng;
end;
PP_1=zeros(leng);
PP_m=ones(leng);
PP_FG=zeros(leng);
E=Distributions.Exponential(aver);
FG=Distributions.Gamma(a,b);
for i=1:leng
PP_1[i]=Distributions.cdf(E,w[i])
PP_FG[i]=Distributions.cdf(FG,w[i])
  for j=1:nexp
PP_m[i]=PP_m[i] - P_a[j] * exp(-Alpha[j] * w[i]) 
end
end
Exp = abs(1-sum(PP_1))
MixExp = abs(1-sum(PP_m))
FG = abs(1-sum(PP_FG))
       ModelName=["Exp", "MixExp", "FG"];
       Values=[Exp, MixExp, FG];
       Data=DataFrames.DataFrame(Model=ModelName, PDSum=Values)
       end
