%plotAcqs
%This script plots all the AD0 files in the current workspace, not
%including the averages, AND NOT INCLUDING THE UNPARSED ACQS (only parsed
%in black)
%This script is meant to be run after LoadAcqs

if ~exist('currFig')
    currFig = 1;
end


acqNum = cell(1,length(acqNames));


for i = 1:length(acqNames)
    acqNum{i} = str2num(acqNames(i).name(5:end-4));
end

acqNumSorted = sort([acqNum{:}]);

maxAcq = max(acqNumSorted);

% un-baselined plot
figure(currFig)
for i = acqNumSorted
    currAcqString = strcat('AD0_',num2str(i),'_bl');
    %check to see if this was a parsed acq
    if exist(strcat(currAcqString(1:end-3),'_1'))
        for numParses = 1:10
            try
                eval(strcat('plot(',currAcqString(1:end-3),'_',num2str(numParses),'_bl,''k'')'));
                hold on;
                
            catch err
            end
        end
    else
        %try/catch allows there to be missing acqs and the function will just
        %skip them
        try
            eval(strcat('plot(',currAcqString,')'));
        catch err
        end
        
    end
    
    
    
    hold on;
end

hTitle(currFig) = title('Baselined Data');
currFig = currFig+1;