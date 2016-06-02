%getEpochNums
%This script uses the avg Acqs to extrac the number of the first acq taken
%in that epoch, using the first position. It returns the answer as the
%variable epochAcqNums

acqAvg = dir('AD0*p1avg.mat*');
acqAvgNames = {acqAvg(:).name};
epochAcqNums = cell(1,size(acqAvgNames,2));

for i = 1:size(acqAvgNames,2)
    
    tempString = eval(strcat('AD0_e',num2str(i),'p1avg.UserData.name'));
    epochAcqNums{i} = tempString;

end


