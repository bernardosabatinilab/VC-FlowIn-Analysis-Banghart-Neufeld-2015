%this script runs with the IPSC_Estim_FlowIn_Analysis script to calculate
%baseline and flow in avgs.


clc;

%Determine which epoch corresponds to SNC80 and DAMGO flowins
SNC80_epoch = FlowInEpochs(1);
DAMGO_epoch = FlowInEpochs(2);

%determine with acq corresponds to the new epoch
SNC80_firstAcq = epochAcqNums(SNC80_epoch);
DAMGO_firstAcq = epochAcqNums(DAMGO_epoch);

%I forgot to add the PPRs as a field of dataVariables (this has now been
%fixed) so I need to calculate the PPRs first using Peaks2_bl and Peaks1.
%Then I can extract that appropriate PPRs.

%calculating PPRs
PPRs = dataVariables.Peaks2_bl./dataVariables.Peaks1;

%take the 6 acqs before SNC80 for baseline, and the 6 acqs before DAMGO for
%SNC-80

%peaks
baselinePeak = dataVariables.Peaks1(SNC80_firstAcq-7:SNC80_firstAcq-1);
SNC80Peak = dataVariables.Peaks1(DAMGO_firstAcq-7:DAMGO_firstAcq-1);
%PPRs
baselinePPR = PPRs(SNC80_firstAcq-7:SNC80_firstAcq-1);
SNC80PPR = PPRs(DAMGO_firstAcq-7:DAMGO_firstAcq-1);

%Calculate baseline averages
baselineAvg = mean(baselinePeak);
baselineStd = std(baselinePeak);

%Normalize IPSC peaks to baseline average
SNC80Peak_Norm = SNC80Peak/baselineAvg;
%Calculating normalized avg and std
SNC80Peak_avg = mean(SNC80Peak_Norm)
SNC80Peak_std = std(SNC80Peak_Norm)

%calculate avg and std for PPRs
baselinePPR_avg = mean(baselinePPR)
baselinePPR_std = std(baselinePPR)
SNC80PPR_avg = mean(SNC80PPR)
SNC80PPR_std = std(SNC80PPR)
