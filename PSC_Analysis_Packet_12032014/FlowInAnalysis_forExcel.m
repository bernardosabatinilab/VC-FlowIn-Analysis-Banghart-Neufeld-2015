% FLOW-IN ANALYSIS
%Shay
%Last modified 12/10/13 (added columns 9-12 for PPRs)

%this script requires the dataStructure be already loaded into the
%workspace

clc;
%% This are the variables you need to fill out
CellType = input('Direct or Indirect?: ','s'); %Direct or Indirect
Compartment = input('Patch or Matrix?: ','s'); %Patch or Matrix
AcqsPerMin = input('Acqs per min: '); %3 for every 20s, 6 for every 10s etc...
blength = 4;
flength = 2;
TimePostFlowIn = 5; %This is the last time point (in minutes) that the script 
% will spit out after the flow in starts


%%
%FlowInEpoch = 4;
FlowInEpoch = FlowInEpochs(1); %This is assuming that the flow-in you want
% to analyze is the first 'FlowIn' that was inputed during the initial
% analysis.

FlowIn_firstAcq = epochAcqNums(FlowInEpoch); %pulls out the first acq in 
% in the flow in epoch

if FlowIn_firstAcq ~= epochAcqNums(end)
    FlowIn_lastAcq = epochAcqNums(FlowInEpoch+1);
else
    FlowIn_lastAcq = length(dataVariables.Peaks1);
end

%FlowIn_lastAcq = 75; %use this to define a 'hard' last acq if you deem that
%you lost the cell at a certain point during the recording.

%%Calculating Rs
try
    if (FlowIn_firstAcq+(AcqsPerMin*TimePostFlowIn)-1) <= FlowIn_lastAcq   
        Rs = dataVariables.Rs(FlowIn_firstAcq-(2*AcqsPerMin):FlowIn_firstAcq+(AcqsPerMin*TimePostFlowIn)-1);
    else
        Rs = dataVariables.Rs(FlowIn_firstAcq-(blength*AcqsPerMin):FlowIn_lastAcq);
    end
catch err
     Rs = dataVariables.Rs(FlowIn_firstAcq-(blength*AcqsPerMin):end);
end
%take average and std of Rs
AvgRs = mean(Rs);
deltaRs = sum(diff(Rs))/mean(Rs)*100;

%% Calculating Peaks1
%Take the 2 minutes prior to start of flow in as baseline
baselinePeaks1 = dataVariables.Peaks1(FlowIn_firstAcq-(blength*AcqsPerMin):FlowIn_firstAcq-1);
baselinePPRs = dataVariables.PPRs(FlowIn_firstAcq-(blength*AcqsPerMin):FlowIn_firstAcq-1);

%Take AcqsPerMin*(TimePostFlowIn) time points after start of flow in. 

%The following try-catch statement will first try to collect the first 
%'TimePostFlowIn' minutes. However, if there weren't that many data points
%collected, it will throw an error, and execute the 'catch' statement,
%which simply asks it to take all the peaks until the end of the recording.
try
    if (FlowIn_firstAcq+(AcqsPerMin*TimePostFlowIn)-1) <= FlowIn_lastAcq   
        FlowInPeaks1 = dataVariables.Peaks1(FlowIn_firstAcq:FlowIn_firstAcq+(AcqsPerMin*TimePostFlowIn)-1);
        %Line below calculates the PPRs
        FlowInPPRs = dataVariables.PPRs(FlowIn_firstAcq:FlowIn_firstAcq+(AcqsPerMin*TimePostFlowIn)-1);
    else
        %check with the user to see if they switched the epoch
        %accidently/the next epoch is still the flow in they want to
        %analyze. If it is, continue the analysis into the next epochs. If
        %not, cut off the analysis at the end of the epoch.
        extraEpoch = input('You switched to another epoch before the end. Continue analysis into the next epoch(s)? Y/N: ','s');
        if strcmpi(extraEpoch,'y')
            FlowInPeaks1 = dataVariables.Peaks1(FlowIn_firstAcq:FlowIn_firstAcq+(f1length*AcqsPerMin));
            FlowInPPRs = dataVariables.PPRs(FlowIn_firstAcq:FlowIn_firstAcq+(f1length*AcqsPerMin));
        elseif strcmpi(extraEpoch,'n')
            FlowInPeaks1 = dataVariables.Peaks1(FlowIn_firstAcq:FlowIn_lastAcq);
            FlowInPPRs = dataVariables.PPRs(FlowIn_firstAcq:FlowIn_lastAcq);
        else
            display('Did not enter ''y'' or ''n''. Run the program and try again');
        end
    end
catch err
     display(err)
     display('You ended the recording before the end you fool') %will display the error so you know when this happens.
     FlowInPeaks1 = dataVariables.Peaks1(FlowIn_firstAcq:end);
     FlowInPPRs = dataVariables.PPRs(FlowIn_firstAcq:end);
end
%take average and std of baseline
baselinePeaks1Avg = mean(baselinePeaks1);
baselinePeaks1Std = std(baselinePeaks1);

%normalize the 2 mins of baseline
baselineNorm = baselinePeaks1/baselinePeaks1Avg;

%normalize the flow in acqs
FlowInNorm = FlowInPeaks1/baselinePeaks1Avg;

%avg flow in peaks and PPRs
FlowInNormPeaks_avgWin = FlowInNorm(((TimePostFlowIn - flength)*AcqsPerMin)+1:(TimePostFlowIn*AcqsPerMin));
FlowInPPRs_avgWin = FlowInPPRs(((TimePostFlowIn - flength)*AcqsPerMin)+1:(TimePostFlowIn*AcqsPerMin));

%% Filling out the cell 
FlowInCell = cell(1,25); %Initialize the cell

%1 (c). Cell name
cellName = getCellName(eval(strcat('AD0_',num2str(FlowIn_firstAcq))));
FlowInCell{1} = cellName(2:end-2);

%2 (d). Cell Type
FlowInCell{2} = CellType;

%3 (e). Patch/Matrix
FlowInCell{3} = Compartment;

%4 (f). Avg Rs
FlowInCell{4} = AvgRs;

%5 (g). delta Rs
FlowInCell{5} = deltaRs;

%6 (h). Baseline IPSC Average (Absolute)
FlowInCell{6} = baselinePeaks1Avg;

%7 (j) FlowIn IPSC Peak Average normalized
FlowInCell{7} = mean(FlowInNormPeaks_avgWin);

%8. (k) FlowIn IPSC std
FlowInCell{8} = std(FlowInNormPeaks_avgWin);

%9 PPR baseline (2 mins)
FlowInCell{9} = mean(baselinePPRs);

%10 PPR baseline std
FlowInCell{10} = std(baselinePPRs);

%11 PPR flow in (2 mins)
FlowInCell{11} = mean(FlowInPPRs_avgWin);

%12 PPR flow in std
FlowInCell{12} = std(FlowInPPRs_avgWin);

%9-14. Baseline IPSCs Normalized
for col = 1:length(baselineNorm)
    FlowInCell{col+12} = baselineNorm(col);
end

%15-29. FlowIn IPSCs normalized
for col = 1:length(FlowInNorm)
    FlowInCell{col+12+length(baselineNorm)} = FlowInNorm(col);
end
