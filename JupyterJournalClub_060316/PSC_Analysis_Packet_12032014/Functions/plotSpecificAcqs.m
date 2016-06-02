function plotSpecificAcqs(AcqNames)
%plotSpecificAcqs
%This script plots AcqNames - a specified list of data structures in the current workspace
%This script is meant to be run after LoadAcqs. AcqNames is a structure of
%strings that denote acqusitions (ie. AcqNames = {'AD0_1' 'AD0_2' ... }


evalin('base','colors = colormap(''lines'');');

for i = 1:size(AcqNames,2)
    currAcqString = strcat(AcqNames{i},'.data');
    
    %try/catch allows there to be missing acqs and the function will just
    %skip them
    try
        evalin('base',strcat('plot(',currAcqString,'); hold on'));
        currTitle = [currAcqString(1:3) ' ' currAcqString(5:end-5)];
        title(currTitle);
    catch err
    end
end
