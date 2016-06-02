function positions = getEpochs()

%This function returns an array of numbers that are the epochs that were
%recorded in the current directory. Must be run after LoadAcqs.


%get all the average names
acqAvg = dir('AD0*p*avg.mat*');
acqAvgNames = {acqAvg(:).name};

%initialize array
repeatedEpochs = zeros(1,size(acqAvgNames,2));

for i = 1:size(acqAvgNames,2)
    
    %extract the position
    beginEpoch = strfind(acqAvgNames{i},'e')+1;
    endEpoch = strfind(acqAvgNames{i},'p')-1;
    
    %assign the position to repeatedPositions
    repeatedEpochs(i) = str2num(acqAvgNames{i}(beginEpoch:endEpoch));
    
end

%use unique to only list the unique positions (there will be repeated ones
%for each epoch most likely)
positions = unique(repeatedEpochs);

end

%Shay
%7/5/2013
