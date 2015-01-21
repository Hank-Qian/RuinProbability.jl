Exp="Exponential";
MixExp="MixExponential";
FG="FracGamma";

function Simulation(u_0::Number,years::Number,D = ASCIIString)
  Simulationn(SP::SurplusProcess,u_0::Number,years::Number,D = ASCIIString)
end
function EMfit(nexp::Number)
  EMfitt(SP::SurplusProcess,nexp::Number)
end
function PDSum(nexp::Int64)
  PDSumm(SP::SurplusProcess, nexp::Int64)
end
function PPPlot(nexp::Int64)
  PPPlott(SP::SurplusProcess, nexp::Int64)
end
function PlotSP(samples::Number)
  PlotSPP(sp::SurplusProcess,samples::Number)
end
function QQPlot(nexp::Int64)
  QQPlott(sp::SurplusProcess, nexp::Int64)
end
function SurPro(D::ASCIIString)
  SurProo(sp::SurplusProcess, D::ASCIIString)
end

