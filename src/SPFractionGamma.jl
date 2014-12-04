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
