function IndependentCase(lambda_1::Number,lambda_2::Number,EX::Number,EY::Number,u_1::Number,u_2::Number,T::Number)

steps=2000;
c_1=lambda_1*EX
c_2=lambda_2*EY
In_time_1=Distributions.Exponential(lambda_1)
In_time_2=Distributions.Exponential(lambda_2)
X=Distributions.Exponential(EX)
Y=Distributions.Exponential(EY)
claim_X=rand(X,steps)
claim_y=rand(Y,steps)
time_1=rand(In_time_1,steps)
time_2=rand(In_time_2,steps)
unif=rand(Uniform(), steps)
i=0
j=0
t_1=0
t_2=0
ut_1=u_1
ut_2=u_2
s_1=0
r_1=0
nr_1=0
s_2=0
r_2=0
nr_2=0

while i<steps && ut_1>0 && t_1<T;
i = i + 1;
ut_1 = ut_1 + c_1* time_1[i] - claim_X[i];
t_1 = t_1 + time_1[i];
end;
if t_2 < T;
r_1 = r_1 + 1;
else
nr_1 = nr_1 + 1;
end
time_1=rand(In_time_1,steps);
claim_X=rand(X,steps);
end;
s_1 = r_1/(r_1+nr_1);


while j<steps && ut_2>0 && t_2<T;
j = j+ 1;
ut_2 = ut_2 + c_2* time_2[i] - claim_Y[i];
t_2 = t_2 + time_2[i];
end;
if t_2 < T;
r_2 = r_2 + 1;
else
nr_2 = nr_2 + 1;
end
time_2=rand(In_time_2,steps);
claim_Y=rand(Y,steps);
end;
s_2 = r_2/(r_2+nr_2);
s=zeros(2)
s[1]=s_1
s[2]=s_2
name=["Ruin1","Ruin2"]
Data=DataFrames.DataFrame(Name=name,Ruinprobability=s]

return(Data)
end



end
