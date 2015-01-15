function Simulation(sp::SurplusProcess, u_0::Number,years::Number,D = ASCIIString)
leng=length(sp.claims_data);
aver=mean(sp.claims_data);
In_time=Distributions.Exponential(sp.duration/leng);
x=Distributions.Exponential(mean(sp.claims_data));
claim=rand(x,3000);
time=rand(In_time,3000);
T=years;
t_0=0;
r=0;
nr=0;
c = leng / sp.duration * aver; 
if D == "Exponential"
if c > aver
for n=1:10000;
ut=u_0;
t=t_0;
i=0;
while i<3000 && ut>0 && t<T;
i = i + 1;
ut = ut + leng / sp.duration * aver * sp.expense_ratio / sp.loss_ratio * time[i] - claim[i];
t = t + time[i];
end;
if t < T;
r = r + 1;
else;
nr = nr + 1;
end;
time=rand(In_time,3000);
claim=rand(x,3000);
end;
s = nr/(r+nr);
else c < aver
println("Wrong information about loss ratio and expense ratio")
end
end
  
if D == "MixExponential"
if c > aver
steps=3000
In_time=Exponential(leng/sp.duration)
unif=rand(Uniform(), steps)
Alpha = zeros(3);
P_a = zeros(3);
AA=EMfit(sp,3);
for n=1:3;
Alpha[n] = AA[2][n];
P_a[n] = AA[1][n];
end;
X_1=Exponential(1/Alpha[1])
X_2=Exponential(1/Alpha[2])
X_3=Exponential(1/Alpha[3])
time=rand(In_time,steps)
x_1=rand(X_1,steps)
x_2=rand(X_2,steps)
x_3=rand(X_3,steps)
T=years
t_0=0
r=0
nr=0
for n=1:100
ut=u_0
t=t_0
i=0;
while i<steps && ut>0 && t<T
i = i + 1
if unif[i] < P_a[1]
ut = ut + c * time[i] -x_1[i]
t = t + time[i]
    elseif P_a[1] <= unif[i] < P_a[1] + P_a[2]
		ut = ut + c * time[i] - x_2[i]
t = t + time[i]
		elseif P_a[1] + P_a[2] <= unif[i]
		ut = ut + c * time[i] - x_3[i]
t = t + time[i]
end
end
if t < T
r = r + 1
else
nr = nr + 1
end
time=rand(In_time,steps)
x_1=rand(X_1,steps)
x_2=rand(X_2,steps)
x_3=rand(X_3,steps)
unif=rand(Uniform(),steps)
end
s = nr/(nr+r)
else c < aver
println("Wrong information about loss ratio and expense ratio")
end
end 
  return(s)
end
