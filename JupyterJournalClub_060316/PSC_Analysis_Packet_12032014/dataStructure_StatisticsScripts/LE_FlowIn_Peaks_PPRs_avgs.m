%Shay
%Last modified 10/27/13
%this is an offshoot of LE_FlowIn_baselineANDdrugAvgs

%this script requires the dataStructure be already loaded into the
%workspace
%this script averages Peaks1 and PPRs for the last 2 minutes before LE 
%flow in (baseline) and the last 2 minutse of the 
%LE epoch (defined manually below).
%

clc;

LEepoch = 2;
getEpochAcqNums;

LE_firstAcq = epochAcqNums(LEepoch);

%% Calculating Peaks1
baselinePeaks1 = dataVariables.Peaks1(LE_firstAcq-7:LE_firstAcq-1);
LEPeaks1 = dataVariables.Peaks1(end-6:end);
%LEPeaks1 = dataVariables.Peaks1(29:34);
baselinePeaks1Avg = mean(baselinePeaks1);
baselinePeaks1Std = std(baselinePeaks1);

baselineNorm = baselinePeaks1/baselinePeaks1Avg;
LENorm = LEPeaks1/baselinePeaks1Avg;

baselineNormAvg = mean(baselineNorm);
baselineNormStd = std(baselineNorm);

LEPeak1avg = mean(LENorm)
LEPeak1std = std(LENorm)

%% Calculating PPRs
baselinePPRs = dataVariables.PPRs(LE_firstAcq-7:LE_firstAcq-1);
baselinePPRsAvg = mean(baselinePPRs)
baselinePPRsStd = std(baselinePPRs)

LEPPRs = dataVariables.PPRs(end-6:end);
%LEPPRs = dataVariables.PPRs(29:34);
LEPPRsAvg = mean(LEPPRs)
LEPPRsStd = std(LEPPRs)





