function averageWaveform = avgAcqs(acqNums)

firstAcq = evalin('base',strcat('AD0_',num2str(acqNums(1)),'_bl'));

averageWaveform = zeros(1,length(firstAcq));

for index = 1:length(firstAcq)
    dataPoints = zeros(1,length(acqNums));
    for iAcq = 1:length(acqNums)
        dataPoints(iAcq) = evalin('base',strcat('AD0_',num2str(acqNums(iAcq)),'_bl(', ...
            num2str(index),')'));
    end
    averageWaveform(index) = mean(dataPoints);
end

end

    



