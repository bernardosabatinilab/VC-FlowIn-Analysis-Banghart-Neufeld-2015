%plotAcqs
%This script plots all the AD0 files in the current workspace, not
%including the averages
%This script is meant to be run after LoadAcqs

currFig = 1;

acqNum = cell(1,length(acqNames));

for i = 1:length(acqNames)
    acqNum{i} = str2num(acqNames(i).name(5:end-4));
end

maxAcq = max([acqNum{:}]);

% un-baselined plot
figure(currFig)
for i = 1:maxAcq
    currAcqString = strcat('AD0_',num2str(i),'.data');
    eval(strcat('plot(',currAcqString,')'));
    hold on;
end

%figure details
hTitle(currFig) = title('All Acqs not baselined');
%titles{currFig} = get(hTitle,'String');

%increment figure counter
currFig = currFig + 1;



%% baselined plot
figure(currFig)
for i = 1:maxAcq
    currAcqBlString = strcat('AD0_',num2str(i),'_bl');
    eval(strcat('plot(',currAcqBlString,')'));
    hold on;
end
hTitle(currFig) = title('All acqs baslined');
%titles{currFig} = get(hTitle,'String');
currFig = currFig+1;



%% extracting the series and membrane resistances
Rs = zeros(1,maxAcq);
Rm = zeros(1,maxAcq);

for i = 1:maxAcq
    currAcqStr = strcat('AD0_',num2str(i));
    Rs(i) = getRs(eval(currAcqStr));
    Rm(i) = getRm(eval(currAcqStr));
end

%% plotting series resistance
figure(currFig)
plot(Rs,'.k');
hTitle(currFig) = title('Series Resistance');
%titles{currFig} = get(hTitle,'String');
currFig = currFig + 1;

%% plotting membrane resistance
figure(currFig)
plot(Rm,'.k');
hTitle(currFig) = title('Membrane Resistance');
%titles{currFig} = get(hTitle,'String');
currFig = currFig + 1;

