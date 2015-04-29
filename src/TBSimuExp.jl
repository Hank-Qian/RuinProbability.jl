function TBSimu(sp::SurplusProcess, u_0::Number,years::Number,D = ASCIIString)

steps=2000;
leng=length(sp.claims_data);
aver=mean(sp.claims_data);

lambda_1=sp.duration/leng
lambda_2=sp.duration*2/leng
lambda_3=sp.duration*6/leng
In_time_1=Distributions.Exponential(lambda_1);
In_time_2=Distributions.Exponential(lambda_2);
In_time_3=Distributions.Erlang(2,lambda_3)
time_1=rand(In_time_1,steps);
time_2=rand(In_time_2,steps);
time_3=rand(In_time_3,steps);
P_1=lambda_1/(lambda_1+lambda_2+lambda_3);
P_2=lambda_2/(lambda_1+lambda_2+lambda_3);
P_3=lambda_3/(lambda_1+lambda_2+lambda_3);
T=years;
t_0=0;
r=0;
nr=0;
c = (leng / sp.duration * aver + leng / (sp.duration*12) / 2 * aver )* sp.expense_ratio / sp.loss_ratio; 
if D == "Exponential"
if sp.expense_ratio / sp.loss_ratio > 1;
unif=rand(Uniform(), steps)
X_1=Exponential(aver);
X_2=Exponential(aver/2);
x_1=rand(X_1,steps)
x_2=rand(X_2,steps)

for n=1:10000
ut=u_0
t=t_0
i=1;
while i<steps && ut>0 && t<T
if unif[i] < P_1
ut = ut + c * time_1[i] -x_1[i]
t = t + time_1[i]
i=i+1
    elseif P_1 <= unif[i] < P_1 + P_2
		ut = ut + c * time_2[i] - x_2[i]
t = t + time_2[i]
i=i+1
		elseif P_1 + P_2 <= unif[i]
		ut = ut + c * time_3[i] - x_1[i] - x_2[i]
t = t + time_3[i]
i=i+1
end
end
if t < T
r = r + 1
else
nr = nr + 1
end
time_1=rand(In_time_1,steps);
time_2=rand(In_time_2,steps);
time_3=rand(In_time_3,steps);
x_1=rand(X_1,steps)
x_2=rand(X_2,steps)
unif=rand(Uniform(),steps)
end
s = nr/(nr+r)
else sp.expense_ratio / sp.loss_ratio < 1
println("Wrong information about loss ratio and expense ratio")
end
end
return(s)
end
