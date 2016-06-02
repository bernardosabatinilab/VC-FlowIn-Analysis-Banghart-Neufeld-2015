function posAcqNames = getPosAcqNames(pos)

posAvgNames = evalin('base',strcat('who(''AD0*p',num2str(pos),'avg'')'));
posAcqNames = cell(1);

index = 1;

for iFile = 1:size(posAvgNames,1)
    currEpochAcqs = evalin('base',strcat(posAvgNames{iFile},'.UserData.Components'));
    
    
    %loop through the acqs in this avg
    for jAcq = 1:(size(currEpochAcqs,2))
        %add .mat to the retrived acq name
        posAcqNames{index} = currEpochAcqs{jAcq};
        
        index = index + 1;
    end
end

end