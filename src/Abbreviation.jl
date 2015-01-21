Exp="Exponential";
MixExp="MixExponential";
FG="FracGamma";

function Simulation(u_0::Number,years::Number,D = ASCIIString)
  Simulationn(SP,u_0::Number,years::Number,D = ASCIIString)
end
function EMfit(nexp::Number)
  EMfitt(SP,nexp::Number)
end
function PDSum(nexp::Int64)
  PDSumm(SP, nexp::Int64)
end
function PPPlot(nexp::Int64)
  PPPlott(SP, nexp::Int64)
end
function PlotSP(samples::Number)
  PlotSPP(SP,samples::Number)
end
function QQPlot(nexp::Int64)
  QQPlott(SP, nexp::Int64)
end
function SurPro(D::ASCIIString)
  SurProo(SP, D::ASCIIString)
end

