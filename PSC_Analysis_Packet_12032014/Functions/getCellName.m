function cellName = getCellName(acq)
%This function searches through the headerstring of 'acq' and extracts the
%baseName string and returns it

    skipChars = length('state.files.baseName=');
    beginName = strfind(acq.UserData.headerString,'state.files.baseName=');
    endName = strfind(acq.UserData.headerString(beginName+skipChars:end),'state');
    
    
    cellName = acq.UserData.headerString(beginName+skipChars:beginName+skipChars+endName-2);
end


