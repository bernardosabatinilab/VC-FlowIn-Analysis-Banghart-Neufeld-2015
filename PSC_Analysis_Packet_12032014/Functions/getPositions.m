function positions = getPositions()

%This function returns an array of numbers that are the positions that were
%recorded in the current directory. Must be run after LoadAcqs.


%get all the average names
acqAvg = dir('AD0*p*avg.mat*');
acqAvgNames = {acqAvg(:).name};

%initialize array
repeatedPositions = zeros(1,size(acqAvgNames,2));

for i = 1:size(acqAvgNames,2)
    
    %extract the position
    beginPos = strfind(acqAvgNames{i},'p')+1;
    endPos = strfind(acqAvgNames{i},'avg')-1;
    
    %assign the position to repeatedPositions
    repeatedPositions(i) = str2num(acqAvgNames{i}(beginPos:endPos));
    
end

%use unique to only list the unique positions (there will be repeated ones
%for each epoch most likely)
positions = unique(repeatedPositions);

end

%Shay
%7/5/2013



    