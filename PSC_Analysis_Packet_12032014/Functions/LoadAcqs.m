%LoadAcqs
%This script loads all the AD0 files in a user chosen directory into the
%current work space;

%load specific acqs
acqPath = uigetdir;
%change current folder to where the data is

cd(acqPath);
acqNames = dir('AD0*.mat');

for iFile = 1:size(acqNames,1)
    
    %I added in this try/catch thing when I stumbled upon a case where a
    %single acq couldn't load for some reason, and it was really annoying
    %that it didn't continue to load the rest. so now it does - 7/8/13
    
    try 
        load(acqNames(iFile).name);
    catch err
     
    end
end


%Shay
%6/22/13
