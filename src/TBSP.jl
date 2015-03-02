function TBSP(SP::SurplusProcess, u_0::Number)

leng=length(SP.claims_data);
aver=mean(SP.claims_data);
lambda_1=SP.duration/leng
lambda_2=SP.duration*2/leng
lambda_3=SP.duration*6/leng
P_1=1/lambda_1/(1/lambda_1+1/lambda_2+1/lambda_3);
P_2=1/lambda_2/(1/lambda_1+1/lambda_2+1/lambda_3);
P_3=1/lambda_3/(1/lambda_1+1/lambda_2+1/lambda_3);
c=SP.expense_ratio/SP.loss_ratio*lambda*aver
z_1=0
z_2=-aver^(-1)
z_3=(lambda*aver-c)/c/aver
z_4=1/(2*c*aver)*(lambda*aver-c-(8*c*aver*1/lambda_3+(c-lambda*aver)^2)^(1/2))
z_5=1/(2*c*aver)*(lambda*aver-c+(8*c*aver*lambda_3+(c-lambda*aver)^2)^(1/2))
q(z)=1+aver*lambda_3*(lambda+1/lambda_3-c/aver)*z+aver^2*lambda_3*(lambda-2*c/aver)*z^2-c*aver^2*lambda_3*z^3
a_11=(c*z_2-lambda)
a_12=(c*z_3-lambda)
a_13=(c*z_4-lambda)
a_21=c*(z_2)^2-lambda-(1/lambda_3-c)/aver
a_22=c*(z_3)^2-lambda-(1/lambda_3-c)/aver
a_23=c*(z_4)^2-lambda-(1/lambda_3-c)/aver
a_31=(c*z_2-lambda+1/lambda_3)*q(z_2)
a_32=(c*z_3-lambda+1/lambda_3)*q(z_3)
a_33=(c*z_4-lambda+1/lambda_3)*q(z_4)
b_1=lambda
b_2=1/lambda_3/aver
b_3=1/lambda_1+1/lambda_2
C_1=1
C_2=((b_1/a_12-b_3/a_32)/(a_13/a_12-a_33/a_32)-(b_1/a_12-b_2/a_22)/(a_13/a_12-a_23/a_22))/((a_11/a_12-a_31/a_32)/(a_13/a_12-a_33/a_32)-(a_11/1_12-a_21/a_22)/(a_13/a_12-a_23/a_22))
C_4=((b_1/a_12-b_3/a_32)-(a_11/a_12-a_31/a_32)*C_2)/(a_13/a_12-a_33/a_32)
C_3=(b_1-a_13*C_4-a_11*C_2)/a_12
a_31*C_2+a_32*C_3+a_33*C_4-b_3
a_21*C_2+a_22*C_3+a_23*C_4-b_2


A=[a_11 a_12 a_13;
   a_21 a_22 a_23;
   a_31 a_32 a_33]
b=[b_1;b_2;b_3]

A*C
C=A^(-1)*b

s=C_1 + C_2 *q(z_2) * exp(z_2 * u_0) + C_3 * q(z_3) * exp(z_3 * u_0) + C_4 * q(z_4) * exp(z_4 * u_0)

return(s)
end
