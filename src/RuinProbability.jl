module RuinProbability

       using DataFrames;
       using Distributions;
       using Gadfly;
       using Polynomial;
       
       export surplusprocess, 
              SPExp, 
              SPMixExp, 
              SPFG, 
              QQPlot,  
              EMfit, 
              PlotSP

#-------------------------------------------------------------------------------
# SPExp: survival probability under exponential distribution
# SPMixExp: survival probability under mixture three exponential distribution
# QQPlot: QQplot comparison between two different claims models
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# User needs to input some basic information about the company.
# For example, user needs to type:
# initial_capital=10000
# claims_data=Array ( which can be plugin by collecting from text file, and the data should be only a row without title)
# loss_ratio=0.67
# expense_rati=0.2
# duration=10 ( the unit of duration is year)
#-------------------------------------------------------------------------------
       include("SurplusProcess.jl")
       include("SPExponential.jl")
       include("SPMix3Exponential.jl")
       include("QQPlot.jl")
       include("EMfit.jl")
       include("SPFractionGamma.jl")
       include("PlotSP.jl")


end # module

