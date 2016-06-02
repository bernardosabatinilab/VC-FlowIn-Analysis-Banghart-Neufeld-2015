% FLOW-IN ANALYSIS
%Shay
% NEED TO DO THIS: now the flow in averages are averages of the 4th and 5th
% minute of each flow in epoch (before, it was the last two minutes of each
% epoch)

%Last modified 12/10/13 (added columns 9-12 for PPRs)

%this script requires the dataStructure be already loaded into the
%workspace

clc;
%% This are the variables you need to fill out
CellType = input('Direct or Indirect?: ','s'); %Direct or Indirect
Compartment = input('Patch or Matrix?: ','s'); %Patch or Matrix
AcqsPerMin = input('Acqs per min: '); %3 for every 20s, 6 for every 10s etc...
TimePostFlowIn = 5; %This is the last time point (in minutes) that the script 
% will spit out after the flow in starts


%%
%FlowInEpoch = 4;
FlowInEpoch1 = FlowInEpochs(1);
FlowInEpoch2 = FlowInEpochs(2);

%% First and Last Acqs of each flow in

%defining the first Acq of each flow in
FlowIn1_firstAcq = epochAcqNums(FlowInEpoch1);
FlowIn2_firstAcq = epochAcqNums(FlowInEpoch2);%pulls out the first acq in 

% defining the last Acq of each flowin
if FlowIn1_firstAcq ~= epochAcqNums(end)
    FlowIn1_lastAcq = epochAcqNums(FlowInEpoch1+1) - 1;
else
    FlowIn1_lastAcq = length(dataVariables.Peaks1);
end


if FlowIn2_firstAcq ~= epochAcqNums(end)
    FlowIn2_lastAcq = epochAcqNums(FlowInEpoch2+1) - 1;
else
    FlowIn2_lastAcq = length(dataVariables.Peaks1);
end

%% Calculating Rs

try
    if (FlowIn2_firstAcq+(AcqsPerMin*TimePostFlowIn)-1) <= FlowIn2_lastAcq   
        Rs = dataVariables.Rs(FlowIn1_firstAcq-(2*AcqsPerMin):FlowIn2_firstAcq+(AcqsPerMin*TimePostFlowIn)-1);
    else
        Rs = dataVariables.Rs(FlowIn1_firstAcq-(2*AcqsPerMin):FlowIn2_lastAcq);
    end
catch err
     Rs = dataVariables.Rs(FlowIn1_firstAcq-(2*AcqsPerMin):end);
end
%take average and std of Rs
AvgRs = mean(Rs);
deltaRs = sum(diff(Rs))/mean(Rs)*100;

%% Calculate the baseline
%Take the 2 minutes prior to start of flow in as baseline
baselinePeaks1 = dataVariables.Peaks1(FlowIn1_firstAcq-(2*AcqsPerMin):FlowIn1_firstAcq-1);
baselinePPRs = dataVariables.PPRs(FlowIn1_firstAcq-(2*AcqsPerMin):FlowIn1_firstAcq-1);

%% Calculating Peaks1 for first flow in
%the 4th and 5th minutes of each peak

%FlowInPeaks1_1 = dataVariables.Peaks1(FlowIn1_firstAcq:FlowIn1_lastAcq);
%FlowInPPRs_1 = dataVariables.PPRs(FlowIn1_firstAcq:FlowIn1_lastAcq);
try
    if (FlowIn1_firstAcq+(AcqsPerMin*TimePostFlowIn)-1) <= FlowIn1_lastAcq   
        FlowInPeaks1_1 = dataVariables.Peaks1(FlowIn1_firstAcq:FlowIn1_firstAcq+(AcqsPerMin*TimePostFlowIn)-1);
        %Line below calculates the PPRs
        FlowInPPRs_1 = dataVariables.PPRs(FlowIn1_firstAcq:FlowIn1_firstAcq+(AcqsPerMin*TimePostFlowIn)-1);
        
        %Calculate the 4th and 5th minutes of the first flow in. These
        %peaks will be averaged and used as the %baseline in the output
        %cell. Note that the number 2 means that 2 minutes will be
        %averaged. 
        FlowInPeaks1_1_avgWindow = FlowInPeaks1_1(((TimePostFlowIn - 2)*AcqsPerMin + 1):(TimePostFlowIn*AcqsPerMin));
    else
        %check with the user to see if they switched the epoch
        %accidently/the next epoch is still the flow in they want to
        %analyze. If it is, continue the analysis into the next epochs. If
        %not, cut off the analysis at the end of the epoch.
        extraEpoch = input('You switched to another epoch before 5 minutes. Continue analysis into the next epoch(s)? Y/N: ','s');
        if strcmpi(extraEpoch,'y')
            FlowInPeaks1_1 = dataVariables.Peaks1(FlowIn1_firstAcq:FlowIn1_firstAcq+(5*AcqsPerMin));
            FlowInPPRs_1 = dataVariables.PPRs(FlowIn1_firstAcq:FlowIn1_firstAcq+(5*AcqsPerMin));
            FlowInPeaks1_1_avgWindow = dataVariables.Peaks1(((FlowIn1_firstAcq + (TimePostFlowIn - 2)*AcqsPerMin)):(FlowIn1_firstAcq + TimePostFlowIn*AcqsPerMin - 1));
        elseif strcmpi(extraEpoch,'n')
            FlowInPeaks1_1 = dataVariables.Peaks1(FlowIn1_firstAcq:FlowIn1_lastAcq);
            FlowInPPRs_1 = dataVariables.PPRs(FlowIn1_firstAcq:FlowIn1_lastAcq);
            FlowInPeaks1_1_avgWindow = FlowInPeaks1_1(((TimePostFlowIn - 2)*AcqsPerMin + 1):end);
        else
            display('Did not enter ''y'' or ''n''. Run the program and try again');
        end
    end
catch err
     display(err)
     display('You ended the recording before 5 minutes you fool') %will display the error so you know when this happens.
     FlowInPeaks1_1 = dataVariables.Peaks1(FlowIn1_firstAcq:end);
     FlowInPPRs_1 = dataVariables.PPRs(FlowIn1_firstAcq:end);
     FlowInPeaks1_1_avgWindow = FlowInPeaks1_1(((TimePostFlowIn - 2)*AcqsPerMin + 1):end);
end
% 
%% Calculate the Peaks for the second flow in

%The following try-catch statement will first try to collect the first 
%'TimePostFlowIn' minutes. However, if there weren't that many data points
%collected, it will throw an error, and execute the 'catch' statement,
%which simply asks it to take all the peaks until the end of the recording.
try
    if (FlowIn2_firstAcq+(AcqsPerMin*TimePostFlowIn)-1) <= FlowIn2_lastAcq   
        FlowInPeaks1_2 = dataVariables.Peaks1(FlowIn2_firstAcq:FlowIn2_firstAcq+(AcqsPerMin*TimePostFlowIn)-1);
        %Line below calculates the PPRs
        FlowInPPRs_2 = dataVariables.PPRs(FlowIn2_firstAcq:FlowIn2_firstAcq+(AcqsPerMin*TimePostFlowIn)-1);
        %Calculate the 4th and 5th minutes of the second flow in. These
        %peaks will be averaged and used as the %baseline in the output
        %cell. Note that the number 2 means that 2 minutes will be
        %averaged. 
        FlowInPeaks1_2_avgWindow = FlowInPeaks1_2(((TimePostFlowIn - 2)*AcqsPerMin + 1):(TimePostFlowIn*AcqsPerMin));
    else
        %check with the user to see if they switched the epoch
        %accidently/the next epoch is still the flow in they want to
        %analyze. If it is, continue the analysis into the next epochs. If
        %not, cut off the analysis at the end of the epoch.
        extraEpoch = input('You switched to another epoch (or ended the recording) before 5 minutes of the last flow in. Continue analysis into the next epoch(s)? Y/N: ','s');
        if strcmpi(extraEpoch,'y')
            FlowInPeaks1_2 = dataVariables.Peaks1(FlowIn2_firstAcq:FlowIn2_firstAcq+(5*AcqsPerMin));
            FlowInPPRs_2 = dataVariables.PPRs(FlowIn2_firstAcq:FlowIn2_firstAcq+(5*AcqsPerMin));
            FlowInPeaks1_2_avgWindow = dataVariables.Peaks1(((FlowIn1_firstAcq + (TimePostFlowIn - 2)*AcqsPerMin)):(FlowIn1_firstAcq + TimePostFlowIn*AcqsPerMin - 1));
        elseif strcmpi(extraEpoch,'n')
            FlowInPeaks1_2 = dataVariables.Peaks1(FlowIn2_firstAcq:FlowIn2_lastAcq);
            FlowInPPRs_2 = dataVariables.PPRs(FlowIn2_firstAcq:FlowIn2_lastAcq);
            FlowInPeaks1_2_avgWindow = FlowInPeaks1_1(((TimePostFlowIn - 2)*AcqsPerMin + 1):end);
        else
            display('Did not enter ''y'' or ''n''. Run the program and try again');
        end
    end
catch err
     display(err)
     display('You ended the recording before 5 minutes you fool') %will display the error so you know when this happens.
     FlowInPeaks1_2 = dataVariables.Peaks1(FlowIn2_firstAcq:end);
     FlowInPPRs_2 = dataVariables.PPRs(FlowIn2_firstAcq:end);
     FlowInPeaks1_2_avgWindow = FlowInPeaks1_1(((TimePostFlowIn - 2)*AcqsPerMin + 1):end);
end

%% Averages and shit

%take average and std of baseline
baselinePeaks1Avg = mean(baselinePeaks1);
baselinePeaks1Std = std(baselinePeaks1);

%normalize the 2 mins of baseline
baselineNorm = baselinePeaks1/baselinePeaks1Avg;

%normalize the flow in acqs
FlowInNorm1 = FlowInPeaks1_1/baselinePeaks1Avg;
FlowInNorm1_avgWindow = FlowInPeaks1_1_avgWindow/baselinePeaks1Avg;

FlowInNorm2 = FlowInPeaks1_2/baselinePeaks1Avg;
FlowInNorm2_avgWindow = FlowInPeaks1_2_avgWindow/baselinePeaks1Avg;

%% Filling out the cell 
FlowInCell = cell(1,25); %Initialize the cell

%1 (c). Cell name
cellName = getCellName(eval(strcat('AD0_',num2str(FlowIn1_firstAcq))));
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

%7 (j) FlowIn1 IPSC Peak Average normalized
FlowInCell{7} = mean(FlowInNorm1_avgWindow);

%8. (k) FlowIn1 IPSC std
FlowInCell{8} = std(FlowInNorm1_avgWindow);

%9-10 FlowIn 2 IPSC Norm and std
    FlowInCell{9} = mean(FlowInNorm2_avgWindow);
    FlowInCell{10} = std(FlowInNorm2_avgWindow);

%11 PPR baseline (2 mins)
FlowInCell{11} = mean(baselinePPRs);

%12 PPR baseline std
FlowInCell{12} = std(baselinePPRs);

%13 PPR flow in 1  (2 mins)
FlowInCell{13} = mean(FlowInPPRs_1);

%14 PPR flow in 1  std
FlowInCell{14} = std(FlowInPPRs_1);

%15 PPR flow in 2  (2 mins)
FlowInCell{15} = mean(FlowInPPRs_2);

%16 PPR flow in 2  std
FlowInCell{16} = std(FlowInPPRs_2);

%9-14. Baseline IPSCs Normalized
for col = 1:length(baselineNorm)
    FlowInCell{col+16} = baselineNorm(col);
end

%15-29. FlowIn1 IPSCs normalized
for col = 1:length(FlowInNorm1)
    FlowInCell{col+16+length(baselineNorm)} = FlowInNorm1(col);
end

%the rest. FlowIn2 IPSCs normalized
for col = 1:length(FlowInNorm2)
    FlowInCell{col+16+length(baselineNorm) + length(FlowInNorm1)} = FlowInNorm2(col);
end
