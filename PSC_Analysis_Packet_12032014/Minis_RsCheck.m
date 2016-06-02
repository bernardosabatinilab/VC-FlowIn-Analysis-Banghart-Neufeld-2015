% FLOW-IN ANALYSIS
%Shay
%Last modified 12/10/13 (added columns 9-12 for PPRs)

%this script requires the dataStructure be already loaded into the
%workspace

clc;
%% This are the variables you need to fill out
AcqsPerMin = 3;
%AcqsPerMin = input('Acqs per min: '); %3 for every 20s, 6 for every 10s etc...
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
        acqsToAnalyze = FlowIn_firstAcq-(2*AcqsPerMin):FlowIn_firstAcq+(AcqsPerMin*TimePostFlowIn)-1;
    else
        Rs = dataVariables.Rs(FlowIn_firstAcq-(2*AcqsPerMin):FlowIn_lastAcq);
        acqsToAnalyze = FlowIn_firstAcq-(2*AcqsPerMin):FlowIn_lastAcq;
        display('You may have less than 5 mins of flow in. Better check');
    end
catch err
     display(err)
     display('You may have less than 5 mins of flow in. Better check');
     
     Rs = dataVariables.Rs(FlowIn_firstAcq-(2*AcqsPerMin):end);
     acqsToAnalyze = FlowIn_firstAcq-(2*AcqsPerMin):FlowIn_lastAcq;
end
%take average and std of Rs
Rs
AvgRs = mean(Rs)
deltaRs = sum(diff(Rs))/mean(Rs)*100

acqsToAnalyze
