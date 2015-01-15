function SurProo(D::ASCIIString)
       leng = length(SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).claims_data);
       aver = mean(SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).claims_data);
       c = leng / SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).duration * aver; 
       if D == "Exponential"
       if c > aver
       s = 1 - (1 - SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).loss_ratio / SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).expense_ratio) * leng / SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).duration * exp(-(1 / aver - leng / SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).duration / ( leng / SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).duration * aver * SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).expense_ratio / SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).loss_ratio)) * SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).initial_capital) / (1 / aver * leng / SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).duration * aver * SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).expense_ratio / SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).loss_ratio - leng / SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).duration);
       else c < aver
       println("Wrong information about loss ratio and expense ratio")
       end
       end
       if D == "MixExponential"
       Alpha = zeros(3);
	     P_a = zeros(3);
	     if c > aver
       AA=EMfit(sp,3);
       for n=1:3;
              Alpha[n] = AA[2][n];
              P_a[n] = AA[1][n];
       end;
       A = ((leng / SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).duration * aver * SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).expense_ratio / SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).loss_ratio) * (Alpha[1] + Alpha[2] + Alpha[3]) - leng / SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).duration) / (leng / SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).duration * aver * SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).expense_ratio / SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).loss_ratio) ;
       B = ((leng / SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).duration * aver * SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).expense_ratio / SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).loss_ratio) * (Alpha[1] * Alpha[2] + Alpha[3] * Alpha[2] + Alpha[1] * Alpha[3]) - (Alpha[1] + Alpha[2] + Alpha[3]) * leng / SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).duration + (Alpha[1] * P_a[1] + Alpha[2] * P_a[2] + Alpha[3] * P_a[3]) * leng / SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).duration) / (leng / SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).duration * aver * SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).expense_ratio / SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).loss_ratio);
       C = ((leng / SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).duration * aver * SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).expense_ratio / SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).loss_ratio) * Alpha[1] * Alpha[2] * Alpha[3] - (Alpha[1] * Alpha[2] + Alpha[1] * Alpha[3] + Alpha[3] * Alpha[2]) * leng / SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).duration + (Alpha[1] * P_a[1] * (Alpha[2] + Alpha[3]) + Alpha[2] * P_a[2] * (Alpha[1] + Alpha[3]) + Alpha[3] * P_a[3] * (Alpha[1] + Alpha[2])) * leng / SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).duration) / (leng / SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).duration * aver * SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).expense_ratio / SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).loss_ratio);
        
       a = -(A^3)/27 + -C/2 + A*B/6;
       b = B/3 + -(A^2)/9;
       
       s_1 = -A/3 + 2 * sqrt(-b) * cos(acos(a/(-b)^(3/2))/3);
       s_2 = -A/3 + 2 * sqrt(-b) * cos((acos(a/(-b)^(3/2) )+ 2pi)/3);
       s_3 = -A/3 + 2 * sqrt(-b) * cos((acos(a/(-b)^(3/2) )- 2pi)/3);
       
       M = -(( 1- SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).loss_ratio / SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).expense_ratio) * Alpha[1] * Alpha[2] * Alpha[3]) / (s_1 * s_2 * s_3);
       p = 1 / ((s_2 - s_1) * (s_3 - s_2)) * ((1- SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).loss_ratio / SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).expense_ratio) * (-s_2 * (Alpha[1] + Alpha[2] + Alpha[3]) - s_2^2 - (Alpha[1] * Alpha[2] + Alpha[1] * Alpha[3] + Alpha[3] * Alpha[2])) + s_1 * s_3 * M);
       N = 1/(s_3 - s_1) * (-(1- SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).loss_ratio / SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).expense_ratio) * (Alpha[1] + Alpha[2] + Alpha[3]) - M * s_3 - (s_1 + s_2) * (1- SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).loss_ratio / SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).expense_ratio) - (s_3-s_2) * p);
       q = (1- SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).loss_ratio / SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).expense_ratio) - M - N - p;
       s = 1 + N * exp(s_1 * SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).initial_capital) + p * exp( s_2 * SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).initial_capital) + q* exp(s_3 * SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).initial_capital);
       else c < aver
       println("Wrong information about loss ratio and expense ratio")
       end
       end
       
  if D == "FracGamma"
  if c > aver
       a = 0.5/(log(mean(SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).claims_data)) - mean(log(SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).claims_data)));
       b = mean(SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).claims_data)/a;

       m = 0;
       n = 0;
  a_0 = a;
  for i = 1:100;
    if a < 10;
    a = a * 10;
    elseif a >= 10;
    m = integer(a);
    n = integer(a / a_0);
    end;
  end;
  aver = mean(SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).claims_data);
  leng = length(SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).claims_data);
  poli = zeros(m+n+1);
  poli[1] = leng / SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).duration * aver * SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).expense_ratio / SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).loss_ratio;
  poli[n+1] = -(leng / SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).duration * aver * SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).expense_ratio / SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).loss_ratio * (1 / b) + leng / SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).duration);
  poli[m+n+1] = leng / SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).duration * (1 / b)^(m / n);
  Sk = Polynomial.roots(Polynomial.Poly(poli));
  f(x) = (1 - SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).loss_ratio / SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).expense_ratio) * x^m;
  Mk = Array(Complex{Float64},m+n);
  product = 1;
  
  for i = 1:(m+n);
    product = 1;
    for z = 1:(m+n);
      if z != i ;
      product = product * (Sk[i]-Sk[z]);
      else;
      product = product;
      end;
    end;
    Mk[i]= f(Sk[i])/product;
  end;
  function MiLe(z);
  sn=0;
  for k=1:10000;
    sn = z^(k-1) / gamma(1 / n * (k-1) + (1 / n)) + sn;
  end;
  return sn;
  end;
  sumpart=0;
  for i = 1:(m+n);
    sumpart = sumpart + Mk[i] * MiLe(Sk[i] * SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).initial_capital^(1 / n));
  end;
  s = real(exp(-1 / b * SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).initial_capital) * SurplusProcess(initial_capital, claims_data, loss_ratio, expense_ratio, duration).initial_capital^((1-n)/n) * sumpart);
       else c < aver
       println("Wrong information about loss ratio and expense ratio")
       end
       end
       return(s)
       end

  



