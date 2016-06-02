%Load acqs

%Enter positions of uncaging sweeps
%Take those positions, parse them into appropriate number of sweeps

%plot raw
%baseline
%plot baseline
%plot Rs, Rm

%calculate peaks
%plot peaks

%plot 2 min baseline average followed by uncaging stims




clear all;
close all;

%load acqs from folder, plot them all (unbaselined and baselined)
%choose a region to calculate peak
LoadAcqs;


%The following parses the uncaging sweeps into 2 second bits containging
%the estim stimulus (using the function parseAcq). Change the variables
%EstimsinSweep and EstimLength to change the number of times it parses, and
%the length of each parse respectively. The uncage estims are renamed
%AD0_23_1, AD0_23_2 etc.. if AD0_23 was an uncaging sweep. They are remade
%into structures like everything else with a data field. The only other
%field that is copied over is the UserData.headerString, since that is what
%has the Rs, Rm etc..

UncagePositions = input('Positions of Uncaging Sweeps: ');
parse = input('Parse this position? (Y/N): ','s');
if strcmpi(parse,'Y');
    
    for iPos = 1:length(UncagePositions)
        posAcqNames = getPosAcqNames(UncagePositions(iPos));
        
        for jAcq = 1:length(posAcqNames)
            
            EstimsInSweep = [1,200000,400000];
            EstimLength = 20000;
            
            uncagingEstims = eval(strcat('parseAcq(',posAcqNames{jAcq}, ...
                ',EstimsInSweep,EstimLength)'));
            for kEstim = 1:length(uncagingEstims)
                %create new structure, add the estim sweep into the data field
                evalin('base',strcat(posAcqNames{jAcq},'_', ...
                    num2str(kEstim),'.data = uncagingEstims{kEstim}'));
                %copy the headerString into the new structure
                evalin('base',strcat(posAcqNames{jAcq},'_',num2str(kEstim), ...
                    '.UserData.headerString =',posAcqNames{iPos}, ...
                    '.UserData.headerString'));
            end
        end
    end
    
end

plotAcqs;
baselineAcqs;
plotAcqsBl;

%% Extracting Rs, Rm, Cm, leak Current and Peak
blAcqs = who('*_bl');
j = 1;
k = 1;
Rs = zeros(1,length(blAcqs));
Rm = zeros(1,length(blAcqs));
Cm = zeros(1,length(blAcqs));
Ihold = zeros(1,length(blAcqs));
peak1 = zeros(1,length(blAcqs));
peak2 = zeros(1,length(blAcqs));

peakRegion1 = input('Enter first peak region: ');
peakRegion2 = input('Enter second peak region: ');

for iAcq = 1:length(blAcqs)
    if exist(strcat('AD0_',num2str(iAcq),'_1'))
        for iParse = 1:length(EstimsInSweep)
            Rs(j) = eval(strcat('getRs(AD0_',num2str(iAcq),')'));
            Rm(j) = eval(strcat('getRm(AD0_',num2str(iAcq),')'));
            Cm(j) = eval(strcat('getCm(AD0_',num2str(iAcq),')'));
            Ihold(j)= eval(strcat('getIhold(AD0_',num2str(iAcq),')'));
            peak1(j) = eval(strcat('mean(AD0_',num2str(iAcq),'_',num2str(iParse), ...
                '_bl(peakRegion1))'));
            peak2(j) = eval(strcat('mean(AD0_',num2str(iAcq),'_',num2str(iParse), ...
                '_bl(peakRegion2))'));
            j = j + 1;
            uncageTracker(k) = j;
            k = k + 1;
        end
    elseif exist(strcat('AD0_',num2str(iAcq)))
        Rs(j) = eval(strcat('getRs(AD0_',num2str(iAcq),')'));
        Rm(j) = eval(strcat('getRm(AD0_',num2str(iAcq),')'));
        Cm(j) = eval(strcat('getCm(AD0_',num2str(iAcq),')'));
        Ihold(j)= eval(strcat('getIhold(AD0_',num2str(iAcq),')'));
        peak1(j) = eval(strcat('mean(AD0_',num2str(iAcq), ...
            '_bl(peakRegion1))'));
        peak2(j) = eval(strcat('mean(AD0_',num2str(iAcq), ...
            '_bl(peakRegion2))'));
        j = j + 1;
    else
    end
end


%%
figure(currFig)
plot(Rs,'.');
hTitle(currFig) = title('Rs');
currFig = currFig + 1;

figure(currFig)
plot(Rm,'.');
hTitle(currFig) = title('Rm');
currFig = currFig + 1;

figure(currFig)
plot(Cm,'.');
hTitle(currFig) = title('Cm');
currFig = currFig + 1;

figure(currFig)
plot(Ihold,'.');
hTitle(currFig) = title('Holding Current');
currFig = currFig + 1;

figure(currFig)
plot(peak1,'.');
hTitle(currFig) = title('IPSC Peaks');
hold on

% %for 60s uncaging acqs (uses the uncageTracker variable)
% plot(uncageTracker,peak1(uncageTracker),'.r');

%% for 20s acqs
posAcqNames = getPosAcqNames(UncagePositions);
for iAcq = 1:length(posAcqNames)
    uncageAcq(iAcq) = getAcqNum(posAcqNames{iAcq});
end
plot(uncageAcq(2:end),peak1(uncageAcq(2:end)),'.r');

currFig = currFig + 1;

%Paired Pulse Ratios
PPRs = peak2./peak1;
figure(currFig)
plot(PPRs,'.');
hTitle(currFig) = title('Paired Pulse Ratios');
hold on

% %for 60s acq
% plot(uncageTracker,PPRs(uncageTracker),'.r');
%for 20s acqs

for iAcq = 1:length(posAcqNames)
    uncageAcq(iAcq) = getAcqNum(posAcqNames{iAcq});
end
plot(uncageAcq(2:end),PPRs(uncageAcq(2:end)),'.r');


%%
UncagingAnalysis_44seconds;

%%
saveFigs = input('Save current figures now? (Y/N): ','s');
if strcmpi(saveFigs,'Y');
    SaveCurrFigsTif(hTitle)
end

%%
dataVariables = struct;
dataVariables.CellName = getCellName(AD0_1); 
dataVariables.Rs = Rs;
dataVariables.Rm = Rm;
dataVariables.Cm = Cm;
dataVariables.Ihold = Ihold;
dataVariables.Peaks1 = peak1;
dataVariables.Peaks2 = peak2;
dataVariables.UncagingSweeps = posAcqNames;
save('dataVariables');


