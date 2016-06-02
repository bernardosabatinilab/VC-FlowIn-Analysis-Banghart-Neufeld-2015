%getEpochAcqNames
%This script uses the avg Acqs to extract the number of the first acq taken
%in that epoch, using the first position. It returns the answer to the
%workspace as the variable epochAcqNames
%This function searches through all the positions to find the first acq
%taken in each epoch.

%retrieve the epoch and position numbers
epochs = getEpochs;
positions = getPositions;

acqAvgs = dir('AD0*p*avg.mat*');
acqAvgNames = {acqAvgs(:).name};
epochAcqNames = cell(1,length(epochs));



for i = epochs
%initialize old num to some really big number
oldNum = 1000000000;
    for j = positions
        if exist(strcat('AD0_e',num2str(i),'p',num2str(j),'avg'),'var')
            
            tempString = eval(strcat('AD0_e',num2str(i),'p',num2str(j),'avg.UserData.name'));
            newNum = str2double(tempString(5:end));
            
            if newNum < oldNum
                epochAcqNames{i} = tempString;
            end
            
        oldNum = newNum;
        end
    end
end

%Shay
%7/5/2013

