#Ruin Probability

##Introduction

Ruin theory plays a significant role for insurance companies in recent years. The main application about ruin theory is calculating the probability of the event of when and how ruin of an insurance company occurs at first time. It is an important method to evaluate the probability of insurance company bankrupting, for avoiding the unpredictable loss by adjusting the company strategy of how to set up the initial investment and premium rate. It is not the simple mathematical imagination, it is an available way to measure the random process by complicated computation. It is not the theorytical assumption, it has the practical usage.

In this document, the ruin theory is based on the classical model, known as the [Cramér–Lundberg model](http://en.wikipedia.org/wiki/Ruin_theory) (or classical compound-Poisson risk model, classical risk process or Poisson risk process). And next chapter will discuss about the model in details. Here just display some basic information about the ruin model. The classical model is related to three variables- Initial capital, premium rate and claims data. In usual, premium rate is determined by loss ratio (it is from the loss triangle) and expense ratio. But it still can be defined as different value in the model to keep the ruin probability below a certain value. The claims data should be the real data in the company which is displayed by the occured claims in different years.  According to the random process calculating, the initial capital and the premium rate are the certain value, they are esay to be defined. But the claims data is a random process, there needs two processes to estimate the claims data. One is the compound-Poisson process which defines when the claims occur (frequency of claims occurring), the time between the two claims is called as inter-arrival time, which is exponential distributed in the compound-Poisson process with same parameter. The other process is fitting process, which is determined how much the claims occur (claims size). The fitting distributions should be determined by the claims data. Although there are many options to fit the claims into different distributions, they can be evaluated by QQ-plot, PP-plot and 2-norm.
  
The calculation can be briefly introduced here. The core methods in the computation are deriving the Intergral equation to Differential-integral equation, then using the Laplace transform and inverse Laplace transform to get the result. It is not complicated when deal with some simple fitting distributions such as exponential distribution, but complex fitting distributions are not easy to get the final equation. In Julia, the expressions of the survival probability (survival probability + ruin probability = 1) are the explicit solutions, although it is calculated by the numerical methods. 

##Basic Preliminaries

Here are some basic definitions about Ruin theory:

**Definition 1  **  *Surplus Process*
The standard mathematical model of  an insurance company, namely $U(t)$, is given by
\begin{equation}
U(t) = U_0 + ct - \sum_{i=0}^{N(t)}X_{i}
\end{equation}
Where $U(t)$ is company capital at the time t, $U_0$ is initial capital at the time 0, $c$ is the premium rate which tells us the amount of premium that it will collect in a unit time, and $\{{X_i}\}_{i\le1}^{N(t)}$ is defined as a set of non-negative independent and identically distributed random variables. The random variable $X_i$ represents the individual claim amount for the i-th claim, having Cumulative Distribution Function $F_{X}(x)$ with PDF $f_{X}(x)=\frac{d}{dx}F_{X}(x)$ and finite mean $E(x)<\infty$.
 
 As mentioned before, the claims number $N(t)$ is countable process which is defined as the **Poisson Process**.  
 
 **Definition 2** *Poisson Process*
 The counting process$\{N(t)\}_{t\geq0}$ is said to be Poisson Process with parameter $\lambda>0$, if
$N(0) = 0,$
$N(t)$ has independent and stationary increments,
The unmber of the events in any interval of length $t$ is Poisson distrubuted, tat is for $0\leq s\leq t$,
\begin{equation}
\mathbb{P}[N(t+s) - N(s) = n] = e^{-\lambda t} \frac{(\lambda t)^{n}}{n!}, n=0, 1, 2...
\end{equation}

Here it is easy to see the time between two claims can be described as $\mathbb{P}[N(t+s) - N(s) = n] = e^{-\lambda t} \frac{(\lambda t)^{0}}{0!}=e^{-\lambda t}$, then it is clear to see the inter-arrival time of Poisson process distributes as **Exponential distribution**.

**Definition 3** *Fitting Distribution*
The claims data can be fitted as such certain distributions. As normal, we need to discuss the claims data is heavy tailed or light tailed, but in "RuinProbability" package, there are just three types of distributions for the fitting. And here just provides the Probability density Functions.
**Exponential distribution:** 
$f(x;\lambda) = \lambda e^{-\lambda t}, x \geq0$
**Mixture exponential distribution:** 
$f(x;\lambda_i, c_i)_{1 \leq i \leq n} =\sum_{i=1}^{n}c_i\lambda_ie^{-\lambda_i t}, x\geq 0  $
**Fractional Gamma distribution**
$f(x;k,\theta)=\dfrac{x^{k-1}e^{-\frac{x}{\theta}}}{\theta^k \Gamma(k)},  x, k, \theta \geq 0$
Where $\Gamma(k)=\int_{0}^{\infty}x^{k-1}e^{-x}dx$, which is Gamma function.
The fitting methods can be MLE or EM.

**Definition 4** *Ruin Probability*
The probability of ruin in infinite time is defined as

 - *Time of ruin:*
\begin{equation}
T_{u}=\inf\limits_{t\geq0}\{t:U(t)<0\mid U(0)=u\}.
\end{equation}
$T_{u}$ denote the first time about the capital of the company eventually falls below zero.

 - *The probability of ruin*
\begin{equation}
\Psi(u)=\mathbb P(U(t)<0, \exists t>0\mid U(0)=u)
\end{equation}
or
\begin{equation}
\Psi(u)=\mathbb P(T_{u}<\infty \mid U(0)=u).
\end{equation}
Note that:

1. $\mathbb P(T_{u}=\infty)$ means the ruin never happen,

2. Considering inter-arrival times $\tau_{i}$ and amount of claims $X_{i}$ are independent,

3. The net profit condition $c-\lambda u>0$,
4. Survival probability ( Non-ruin probability) can be denoted as $\Phi(u)=1-\Psi(u)$.







##Parameters in "RuinProbability"
When users are using "RuinProbability" package, they need to input some basic information about the companies to calculate the ruin probability. The information will be saved in "SurplusProcess.jl" after input, then users can define a new Datatype SP = SurplusProcess( initial_capital, claims_data, loss_ratio, expense_ratio, duration) to use the survival functions.

According to the Surplus Process model in **Definition 1**, the basic information should include:

**initial_capital**
It also can be described as initial investment, it is $U_0$ in the Surplus Process, and it is the only variable in the survival function. Users can adjust the initial_capital to keep the survival probability under some certain level.

**claims_data**
The claims_data can be input by setting up an Array{Float64,1} in Julia manually or from an external file that the data belongs to the same type( Array{Float64,1}). The claims_data should only be an array of numbers without any strings. 

**loss_ratio** and **expense_ratio**
For insurance, the loss ratio is the ratio of total losses incurred (paid and reserved) in claims plus adjustment expenses divided by the total premiums earned. For example, if an insurance company pays 40 pounds in claims for every 100 pounds in collected premiums, then its loss ratio is 40%. Loss ratio can be found in the global loss triangle form. 

The percentage of premium is used to pay all the costs of acquiring, writing, and servicing insurance and reinsurance. These expenses include shareholder service, salaries for money managers and administrative staff, and operating cost, among many others.

**duration**
If the claims_data is from 2002 to 2012, then the duration is 10.

There is another core parameter needed to be introduced. In "RuinProbability" package, the **premium rate** will be calculated by the Surplus Process information automatically. The **computing steps** are shown as below:

 1. Calculate the expectation of the claims, denoted as $\mathbb E(X)$,
 2. Calculate the claims number parameter( Poisson parameter), the average of the number of claims occur in a unit time, denoted as $\lambda = \mathbb E(N)$ ,
 3. Calculate the average amount of claims in a unit time, denoted as $\lambda * \mathbb E(X)$,
 4. Then the premium rate can be defined as 
 $c=\dfrac{\lambda*\mathbb E(X)}{Loss\_ratio}*(1- Expense\_ratio)$

##Mathematical Parts

**IDE**

**Laplace Transform** and **Inverse Laplace Transform**

**Definition 5**
The **Laplace transform** of a function $f(t)$, defined for all real numbers $t\geqslant0$, is the function $\hat{f}(s)$, defined by:
\begin{equation}
\hat{f}(s)=\mathcal{L}\{f(t)\}(s)=\int_{0}^{\infty}e^{-st}f(t)dt,
\end{equation}
where parameter $s=\sigma+i\omega$ is a complex number with real numbers $\sigma$ and $\omega$
There are two examples will be used in the following calculation.

 - The Laplace transform of the differentiation of a function $f'(t)$ is
   \begin{equation} s\hat{f}(s)-f(0) \end{equation}
 - The Laplace transform of the convolution of $f(t)$ and $g(t)$:
  $(f*g)(t)=\int_{0}^{t}f(\tau)g(t-\tau)d\tau$ $\quad$ is  $\quad \hat{f}(s)\hat{g}(s).$

as mentioned previous, the IDE is\begin{equation}(-c\frac{d}{du}+\lambda)\Phi(u)=\lambda\int_{0}^{u}\Phi(u-y)dF(y)\end{equation}
For applying Laplace transform directly, the IDE is denoted as:
\begin{align*}
&\quad\quad(-c\frac{d}{du}+\lambda)\Phi(u)=\lambda\int_{0}^{u}\Phi(u-y)dF(y)\\
&\Longleftrightarrow c\frac{d}{du}\Phi(u)=\lambda\Phi(u)-\lambda\int_{0}^{u}\Phi(u-y)dF(y)\\
&\Longleftrightarrow \Phi'(u)=\dfrac{\lambda}{c}\Phi(u)-\dfrac{\lambda}{c}\int_{0}^{u}\Phi(u-y)dF(y)
\end{align*} 
The Laplace transform can be deduced as

\begin{equation}
s\hat{\Phi}(s)-\Phi(0)=\dfrac{\lambda}{c}\hat{\Phi}(s)-\dfrac{\lambda}{c}\int_{0}^{u}\Phi(u-y)f(y)dy
\end{equation}
From this expression, if put in a certain density function, then it can be solved by Laplace transform. In "RuinProbability", there are exponential distribution and mixture three exponential distribution, and the PDFs are $f_e(x)=\alpha e^{-\alpha x}$ and $f_m(x)=C_{1}\alpha_{1} e^{-\alpha_{1}x}+C_{2} e^{-\alpha_{2}x}+C_{3}\alpha_{3} e^{-\alpha_{3}x}$ respectively. The processes of the function deducing are almost same, so here just shows density function belongs to the mixture three exponential distribution. After input the PDF into the expression, the function of Laplace transform will be:
\begin{align}
&\hat{\Phi}(s)=\Phi(0)\dfrac{c}{sc-\lambda+\dfrac{\lambda\alpha_{1}\omega_{1}}{\alpha_{1}+s}+\dfrac{\lambda\alpha_{2}\omega_{2}}{\alpha_{2}+s}+\dfrac{\lambda\alpha_{3}\omega_{3}}{\alpha_{3}+s}}\\
&\Longleftrightarrow\\
&\hat{\Phi}(s)=\dfrac{m}{s}+\dfrac{n}{s-s_{1}}+\dfrac{p}{s-s_{2}}+\dfrac{q}{s-s_{3}}.
\end{align}
Which can be easily run inverse Laplace transform. Then let denominator be $DEN$,
\begin{align*}
DEN=& s^{4}c\\
+& s^{3}(c(\alpha_{1}+\alpha_{2}+\alpha_{3})-\lambda)\\
+& s^{2}(c(\alpha_{1}\alpha_{2}+\alpha_{1}\alpha_{3}+\alpha_{2}\alpha_{3})-(\alpha_{1}+\alpha_{2}+\alpha_{3})\lambda+(\alpha_{1}\omega_{1}+\alpha_{2}\omega_{2}+\alpha_{3}\omega_{3})\lambda)\\
+& s(c\alpha_{1}\alpha_{2}\alpha_{3}-(\alpha_{1}\alpha_{2}+\alpha_{1}\alpha_{3}+\alpha_{2}\alpha_{3})\lambda\\
&+(\alpha_{1}\omega_{1}(\alpha_{2}+\alpha_{3})+\alpha_{2}\omega_{2}(\alpha_{1}+\alpha_{3})+\alpha_{3}\omega_{3}(\alpha_{1}+\alpha_{2})\lambda)\\
&DEN=cs(s^{3}+As^{2}+Bs+D),
\end{align*}
where
\begin{align*}
& A=(c(\alpha_{1}+\alpha_{2}+\alpha_{3})-\lambda)/c\\
&B=\dfrac{(c(\alpha_{1}\alpha_{2}+\alpha_{1}\alpha_{3}+\alpha_{2}\alpha_{3})-(\alpha_{1}+\alpha_{2}+\alpha_{3})\lambda+(\alpha_{1}\omega_{1}+\alpha_{2}\omega_{2}+\alpha_{3}\omega_{3})\lambda)}{c}\\
& D=\frac{1}{c}(c\alpha_{1}\alpha_{2}\alpha_{3}-(\alpha_{1}\alpha_{2}+\alpha_{1}\alpha_{3}+\alpha_{2}\alpha_{3})\lambda\\
&+(\alpha_{1}\omega_{1}(\alpha_{2}+\alpha_{3})+\alpha_{2}\omega_{2}(\alpha_{1}+\alpha_{3})+\alpha_{3}\omega_{3}(\alpha_{1}+\alpha_{2})\lambda)
\end{align*}
According to the Hazewinkel, Michiel(2001), we can find out the root of the cubic function
\begin{align*}
\Delta=\alpha^{2}+\beta^{3}<0,
\end{align*}
where
\begin{align*}
&\alpha=\dfrac{-A^{3}}{27}+\dfrac{-D}{2}+\dfrac{AB}{6}\\
&\beta=\dfrac{B}{3}+\dfrac{-A^{2}}{9}.
\end{align*}
The cubic roots are
\begin{align*}
& s_{1}=-\dfrac{A}{3}+2\sqrt{-\beta}cos(\dfrac{arccos(\dfrac{\alpha}{(-\beta)^{3/2}})}{3})\\
& s_{2}=-\dfrac{A}{3}+2\sqrt{-\beta}cos(\dfrac{arccos(\dfrac{\alpha}{(-\beta)^{3/2}})+2\pi}{3})\\
& s_{3}=-\dfrac{A}{3}+2\sqrt{-\beta}cos(\dfrac{arccos(\dfrac{\alpha}{(-\beta)^{3/2}})-2\pi}{3})
\end{align*}
With the roots in cubic function, the parameters $m,n,p,q$ can be denoted as
\begin{align*}
& m+n+p+q=\Phi(0)\\
& m(s_{1}+s_{2}+s_{3})+(s_{2}+s_{3})n+(s_{1}+s_{3})p+(s_{1}+s_{2})q=-\Phi(0)(\alpha_{1}+\alpha_{2}+\alpha_{3})\\
&(s_{1}s_{2}+s_{1}s_{3}+s_{2}s_{3})m+s_{2}s_{3}n+s_{1}s_{3}p+s_{1}s_{2}q=\Phi(0)(\alpha_{1}\alpha_{2}+\alpha_{1}\alpha_{3}+\alpha_{2}\alpha_{3})\\
& s_{1}s_{2}s_{3}m=-\Phi(0)\alpha_{1}\alpha_{2}\alpha_{3}
\end{align*}
After factoring and decomposition, we have
\begin{align*}
& m=\dfrac{-\Phi(0)\alpha_{1}\alpha_{2}\alpha_{3}}{s_{1}s_{2}s_{3}}\\
& p=\dfrac{1}{(s_{2}-s_{1})(s_{3}-s_{2})}(\Phi(0)(-s_{2}(\alpha_{1}+\alpha_{2}+\alpha_{3})-s_{2}^{2}-(\alpha_{1}\alpha_{2}+\alpha_{1}\alpha_{3}+\alpha_{2}\alpha_{3}))+s_{1}s_{3}m)\\
& n=\dfrac{1}{s_{3}-s_{1}}(-\Phi(0)(\alpha_{1}+\alpha_{2}+\alpha_{3})-ms_{3}-(s_{1}+s_{2})\Phi(0)-(s_{3}-s_{2})p)\\
& q= \Phi(0)-m-n-p
\end{align*}
So the solution under the three exponential distribution model is
\begin{align}
\Phi(u)=1+ne^{s_{1}u}+pe^{s_{2}u}+qe^{s_{3}u},
\end{align}
where
\begin{align*}
&\Phi(\infty)=1\\
& m=\dfrac{-\Phi(0)\alpha_{1}\alpha_{2}\alpha_{3}}{s_{1}s_{2}s_{3}}\\
& p=\dfrac{1}{(s_{2}-s_{1})(s_{3}-s_{2})}(\Phi(0)(-s_{2}(\alpha_{1}+\alpha_{2}+\alpha_{3})-s_{2}^{2}-(\alpha_{1}\alpha_{2}+\alpha_{1}\alpha_{3}+\alpha_{2}\alpha_{3}))+s_{1}s_{3}m)\\
& n=\dfrac{1}{s_{3}-s_{1}}(-\Phi(0)(\alpha_{1}+\alpha_{2}+\alpha_{3})-ms_{3}-(s_{1}+s_{2})\Phi(0)-(s_{3}-s_{2})p)\\
& q= \Phi(0)-m-n-p\\
&
s_{1}=-\dfrac{A}{3}+2\sqrt{-\beta}cos(\dfrac{arccos(\dfrac{\alpha}{(-\beta)^{3/2}})}{3})\\
& s_{2}=-\dfrac{A}{3}+2\sqrt{-\beta}cos(\dfrac{arccos(\dfrac{\alpha}{(-\beta)^{3/2}}+2\pi)}{3})\\
& s_{3}=-\dfrac{A}{3}+2\sqrt{-\beta}cos(\dfrac{arccos(\dfrac{\alpha}{(-\beta)^{3/2}}-2\pi)}{3})\\
&\alpha=\dfrac{-A^{3}}{27}+\dfrac{-D}{2}+\dfrac{AB}{6}\\
&\beta=\dfrac{B}{3}+\dfrac{-A^{2}}{9}\\
& A=(c(\alpha_{1}+\alpha_{2}+\alpha_{3})-\lambda)/c\\
& B=\dfrac{(c(\alpha_{1}\alpha_{2}+\alpha_{1}\alpha_{3}+\alpha_{2}\alpha_{3})-(\alpha_{1}+\alpha_{2}+\alpha_{3})\lambda+(\alpha_{1}\omega_{1}+\alpha_{2}\omega_{2}+\alpha_{3}\omega_{3})\lambda)}{c}\\
& D=\frac{1}{c}(c\alpha_{1}\alpha_{2}\alpha_{3}-(\alpha_{1}\alpha_{2}+\alpha_{1}\alpha_{3}+\alpha_{2}\alpha_{3})\lambda\\
&+(\alpha_{1}\omega_{1}(\alpha_{2}+\alpha_{3})+\alpha_{2}\omega_{2}(\alpha_{1}+\alpha_{3})+\alpha_{3}\omega_{3}(\alpha_{1}+\alpha_{2}))\lambda).
\end{align*}
And for exponential distribution model, the equation will be deduced as the same way as mixture three exponential distribution model. So here just presents the result of the exponential distribution model. Now start with the equation after doing Laplace transform,
\begin{align}
\hat{\Phi}(s)=\Phi(0)(\dfrac{A}{s}+\dfrac{B}{s-\dfrac{\lambda }{c}+\alpha}),
\end{align}
where $A=\dfrac{\alpha c}{\alpha c-\lambda}$ and 
$B=\dfrac{-\lambda}{\alpha c-\lambda}$
According to the upper equation, now we can easily do the inverse Laplace transform to get the explicit solution.
\begin{align}
\Phi(u)=1-\Phi(0)\dfrac{\lambda}{\alpha c-\lambda}e^{-(\alpha-\frac{\lambda}{c})u}
\end{align}

In "RuinProbability", there are the results of the explicit solutions under certain models, not only the numerical solutions.

