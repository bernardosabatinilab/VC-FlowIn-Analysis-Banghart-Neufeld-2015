function plotMultiAcqs(acqNums)

for i = 1:length(acqNums)
    evalin('base',strcat('plot(AD0_',num2str(acqNums(i)),'_bl)'));
    evalin('base','hold on');
end

end
