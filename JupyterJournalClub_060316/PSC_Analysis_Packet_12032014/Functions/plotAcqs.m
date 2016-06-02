%plotAcqs
%This script plots all the AD0 files in the current workspace, not
%including the averages
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
    currAcqString = strcat('AD0_',num2str(i),'.data');
    
    %try/catch allows there to be missing acqs and the function will just
    %skip them
    try
        eval(strcat('plot(',currAcqString,')'));
    catch err
    end
    
    %check to see if this was a parsed acq
    if exist(strcat(currAcqString(1:end-5),'_1'))
 
        for numParses = 1:10
            try
                eval(strcat('plot(',currAcqString(1:end-5),'_',num2str(numParses),'.data,''k'')'));
                hold on;
           
            catch err
            end
        end    
    end
    
    
    hold on;
end

hTitle(currFig) = title('Raw Data');
currFig = currFig + 1;