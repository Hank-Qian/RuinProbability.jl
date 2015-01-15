function PDSum(nexp::Int64)
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
for i=1:leng;
PP_1[i]=Distributions.cdf(E,w[i]);
PP_FG[i]=Distributions.cdf(FG,w[i]);
  for j=1:nexp;
PP_m[i]=PP_m[i] - P_a[j] * exp(-Alpha[j] * w[i]) ;
end;
end;
Expo = abs(sum(PP)-sum(PP_1));
MixExpo = abs(sum(PP)-sum(PP_m));
FGa = abs(sum(PP)-sum(PP_FG));
       ModelName=["Exp", "MixExp", "FG"];
       Values=[Expo, MixExpo, FGa];
       Data=DataFrames.DataFrame(Model=ModelName, PDSum=Values)
       end
