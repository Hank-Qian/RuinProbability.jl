using Plotly
using Distributions
using DataFrames
Plotly.signin("hankqian", "pp0anmtgqm")
initial_capital=10000.0
claims_data=collect(readdlm("/Users/Hank/Documents/Text-Aspen data in Julia/DATA.txt"))
loss_ratio=0.51779566757834
expense_ratio=0.7068
duration= 10
nexp=3

function EMfit(claims_data,nexp::Number)
       maxc=sort(claims_data)[end];
       leng=length(claims_data);
       Theta = rand(0.5*maxc:0.8*maxc,nexp);
       P = ones(nexp)/nexp;
       w = zeros(leng,nexp);
       Q = zeros(leng,nexp);
       A = zeros(leng,nexp);
       sumQ = zeros(1,nexp);
       sumA = zeros(1,nexp);
       De=0;

       for n = 1:300;
              for j = 1:nexp;
                     for i = 1:leng;
                     De=0;
                            for z = 1:nexp
                            De = P[z] * (1 / Theta[z]) * exp(-claims_data[i] / Theta[z]) + De
                            end;
                     w[i,j] = P[j] * (1 / Theta[j]) * exp(-claims_data[i] / Theta[j]) / De
                     end;
              end;
              for m = 1:nexp;
                     for k=1:leng;
                     Q[k,m] = w[k,m] * claims_data[k];
                     A[k,m] = w[k,m];
                     end;
              Theta[m] = sum(Q[:,m]) / sum(A[:,m]);
              P[m] = sum(A[:,m]) / leng;
              end;
       end;

       Alpha=zeros(nexp);
       P_a=zeros(nexp);
       for n=1:nexp;
              Alpha[n]=1/Theta[n];
              P_a[n]=P[n];
       end;
       return (P_a, Alpha);
       end
       a = 0.5/(log(mean(claims_data)) - mean(log(claims_data)));
       b = mean(claims_data)/a;
       leng = length(claims_data);
       aver = mean(claims_data);
       Alpha = zeros(nexp);
       P_a = zeros(nexp);
       AA=EMfit(claims_data,nexp);
       for n=1:nexp;
              Alpha[n] = AA[2][n];
              P_a[n] = AA[1][n];
       end;

       percentile = rand(leng);
       for i=1:leng;
            percentile[i]=i/leng;
       end;

       QQ_1=rand(leng-1);
       QQ_FG=rand(leng-1);
       for i=1:leng-1;

            QQ_1[i]=quantile(Distributions.Exponential(aver),percentile[i]);
            QQ_FG[i]=quantile(Distributions.Gamma(a,b),percentile[i]);
       end;

       w=sort(claims_data);
       QQ_m=zeros(leng-1);
       F=zeros(leng-1);
       F_d=zeros(leng-1);
	sum1=0;
	sum2=0;
	for i=1:leng-1
	sum1=0;
	sum2=0;
	for j=1:nexp
	sum1 = P_a[j] *(1 - exp(-Alpha[j] * QQ_m[i])) + sum1;
	sum2 = P_a[j] * Alpha[j] * exp(-Alpha[j] * QQ_m[i]) +sum2
	end
              F[i] = sum1-percentile[i];
              F_d[i] = sum2
       end;

       for n=1:10;
       		for i=1:leng-1;
                	QQ_m[i]=QQ_m[i] - F[i]/F_d[i];
                end;
                for i=1:leng-1;
	sum1=0;
	sum2=0;
	for j=1:nexp
	sum1 = P_a[j] *(1 - exp(-Alpha[j] * QQ_m[i])) + sum1;
	sum2 = P_a[j] * Alpha[j] * exp(-Alpha[j] * QQ_m[i]) +sum2
	end
              F[i] = sum1-percentile[i];
              F_d[i] = sum2
       end;
       end ;
Exponential = [
  "x" => QQ_1,
  "y" => w,
  "mode" => "markers",
  "type" => "scatter"]
Mixture_Exponential = [
  "x" => QQ_m,
  "y" => w,
  "mode" => "markers",
  "type" => "scatter"]
Fractional_Gamma = [
  "x" => QQ_FG,
  "y" => w,
  "mode" => "markers",
  "type" => "scatter"]
Real_data = [
  "x" => w,
  "y" => w,
  "mode" => "lines",
  "type" => "scatter"]

       Data=[Exponential, Mixture_Exponential, Fractional_Gamma, Real_data];
QQ_1

layout = [
  "title" => "QQPLot",
  "autosize" => false,
  "width" => 500,
  "height" => 500,
  "margin" => ["l" => 65, "r" => 50, "b" => 65, "t" => 90]]
response = Plotly.plot(Data, ["layout" => layout, "filename" => "line-scatter", "fileopt" => "overwrite"])
response["url"]

