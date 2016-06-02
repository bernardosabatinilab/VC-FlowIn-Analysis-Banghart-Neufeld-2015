%getEpochAcqNums
%This script uses the avg Acqs to extrac the number of the first acq taken
%in that epoch. It has to be run after
%getEpochNames

epochAcqNums = zeros(1,size(epochAcqNames,2));

for i = 1:size(epochAcqNames,2)
    currNum = str2num(epochAcqNames{i}(5:end));
    epochAcqNums(i) = currNum;
end


%Shay
%7/5/2013