using RuinProbability

initial_capital=10000.0
claims_data=collect(readdlm("/Users/Hank/Documents/Text-Aspen data in Julia/DATA.txt"))
loss_ratio=0.51779566757834
expense_ratio=0.7068
duration= 10
sp=SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration)

function SimulationExp(sp::SurplusProcess,u_0::Number,years::Number)
leng=length(sp.claims_data);
aver=mean(sp.claims_data);
In_time=Exponential(duration/leng);
x=Exponential(mean(sp.claims_data));
claim=rand(x,1000);
time=rand(In_time,1000);
T=years;
t_0=0;
r=0;
nr=0;
for n=1:1000;
ut=u_0;
t=t_0;
for i=1:10000;
if ut>0 && t<T;
ut = ut + leng / duration * aver *expense_ratio / loss_ratio * time[i] - claim[i];
t = t + time[i];
end;
end;
if t < T;
r = r + 1;
else;
nr = nr + 1;
end;
time=rand(In_time,1000);
claim=rand(x,1000);
end;
1-r/(r+nr)
end