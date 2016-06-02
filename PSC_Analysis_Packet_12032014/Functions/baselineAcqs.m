%baselineAcqs

%This script creates new baselined acqs. Right now it just uses the values
%of 2000:4000 as the 're-baseline' average region. You can also uncomment
%line 7 to prompt a use to enter an array.

%BLregion = input('Enter region to calculate baseline (begin:end):');
BLregion = 2000:4000; %Set as default value for our current expts.

acqNum = cell(1,length(acqNames));

%this just extracts the number associated with each acqName (since there
%might be one missing in strange cases. I'm not actually sure this is
%neccesary in the current version of the code. In fact, I feel like it
%would be better to use acqNum to cycle through instead of 1:maxAcq. But I
%feel like I tried that in the past and there was some problem. 
for i = 1:length(acqNames)
    acqNum{i} = str2num(acqNames(i).name(5:end-4));
end
maxAcq = max([acqNum{:}]);

for i = 1:maxAcq
    %this if statement was initially written for my original uncaging
    %pulses, which were 1min and I parsed them into 2500ms acqs and named
    %them AD0_1_1, AD0_1_2 etc... 
    %This script as a hard code limit of going through an acq parsed a
    %maximum of 10 times. (iParse=1:10). I imagine this is mostly defunct
    %anyways now.
    if exist(strcat('AD0_',num2str(i),'_1'))
        for iParse = 1:10
            currAcqString = strcat('AD0_',num2str(i),'_',num2str(iParse),'.data');
            try
            bl = mean(eval(strcat(currAcqString,'([',num2str(BLregion),'])')));
            eval(strcat('AD0_',num2str(i),'_',num2str(iParse), ...
                '_bl = AD0_',num2str(i),'_',num2str(iParse),'.data - bl;'));
            catch err
            end
        end
    %if an acq is not parsed (like most) it will do the following.
    elseif exist(strcat('AD0_',num2str(i)))
        currAcqString = strcat('AD0_',num2str(i),'.data');
        bl = mean(eval(strcat(currAcqString,'([',num2str(BLregion),'])')));
        eval(strcat('AD0_',num2str(i),'_bl = AD0_',num2str(i),'.data - bl;'));
    end
end