%Shay
%Last modified 9/21/13

%this script requires the dataStructure be already loaded into the
%workspace
%this script averages the last 2 minutes before LE flow in (baseline) and
%the last 2 minutse of the LE epoch (defined manually below).
%

clc;

LEepoch = 2;
getEpochAcqNums;

LE_firstAcq = epochAcqNums(LEepoch);

baseline = dataVariables.Peaks1(LE_firstAcq-7:LE_firstAcq-1);
LE = dataVariables.Peaks1(end-6:end);
baselineAvg = mean(baseline);
baselineStd = std(baseline);

baselineNorm = baseline/baselineAvg;
LENorm = LE/baselineAvg;

baselineNormAvg = mean(baselineNorm)
baselineNormStd = std(baselineNorm)
LEavg = mean(LENorm)
LEstd = std(LENorm)


