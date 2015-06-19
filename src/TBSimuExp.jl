function TBSimu(lambda_1::Number,lambda_2::Number,lambda_3::Number,EX::Number,EY::Number,u_1::Number,u_2::Number,c_1::Number,c_2::Number,T::Number)

steps=200
In_time_1=Distributions.Exponential(1/lambda_1);
In_time_2=Distributions.Exponential(1/lambda_2);
In_time_3=Distributions.Exponential(1/lambda_3)
time_1=rand(In_time_1,steps);
time_2=rand(In_time_2,steps);
time_3=rand(In_time_3,steps);
P_1=lambda_1/(lambda_1+lambda_2+lambda_3);
P_2=lambda_2/(lambda_1+lambda_2+lambda_3);
P_3=lambda_3/(lambda_1+lambda_2+lambda_3);

unif=rand(Distributions.Uniform(), steps)
X_1=Distributions.Exponential(EX);
X_2=Distributions.Exponential(EY);
x_1=rand(X_1,steps)
x_2=rand(X_2,steps)
i=0;
j=0;
t_1=0;
t_2=0;
ut_1=u_1;
ut_2=u_2;
s_1=0;
r_1=0;
nr_1=0;
s_2=0;
r_2=0;
nr_2=0;
s_or=0;
r_or=0;
nr_or=0;
s_and=0;
r_and=0;
nr_and=0;


for n=1:10000
ut_1=u_1
ut_2=u_2
t_1=0
t_2=0
i=1
j=1
while i<steps && ut_1>0 && t_1<T
if unif[i] < P_1
ut_1 = ut_1 + c_1 * time_1[i] -x_1[i]
t_1 = t_1 + time_1[i]
i=i+1
      elseif P_1 <= unif[i] < P_1 + P_2
i=i+1

elseif P_1 + P_2 <= unif[i]
ut_1 = ut_1 + c_1 * time_3[i] - x_2[i]
t_1 = t_1 + time_3[i]
i=i+1
end
end

while j<steps && ut_2>0 && t_2<T
if P_1 <= unif[j] < P_1 + P_2
		ut_2 = ut_2 + c_2 * time_2[j] - x_2[j]
t_2 = t_2 + time_2[j]
j=j+1
      elseif unif[j] < P_1
        j=j+1
		elseif P_1 + P_2 <= unif[j]
		ut_2 = ut_2 + c_2 * time_3[j] - x_2[j]
t_2 = t_2 + time_3[j]
j=j+1
end
end

 if ut_1 < 0 || ut_2 < 0
      r_or=r_or+1
    elseif ut_1>0 && ut_2>0
      nr_or=nr_or+1
    end
    if ut_1 < 0 && ut_2 < 0
      r_and=r_and+1
    elseif ut_1>0 || ut_2>0
      nr_and=nr_and+1
    end
  if ut_1<0
    r_1=r_1+1
  else
    nr_1=nr_1+1
  end
  if ut_2<0
    r_2=r_2+1
  else
    nr_2=nr_2+1
  end

time_1=rand(In_time_1,steps);
time_2=rand(In_time_2,steps);
time_3=rand(In_time_3,steps);
x_1=rand(X_1,steps)
x_2=rand(X_2,steps)
unif=rand(Uniform(),steps)
end
s_1 = r_1/(r_1+nr_1);
s_2 = r_2/(r_2+nr_2);
s_or= r_or/(r_or+nr_or);
s_and=r_and/(r_and+nr_and);


s=zeros(4);
s[1]=s_1;
s[2]=s_2;
s[3]=s_or;
s[4]=s_and;
name=["Ruin_1","Ruin_2","Ruin_or","Ruin_and"];
Data=DataFrames.DataFrame(Name=name,Ruinprobability=s);

return(Data)
end;
