function cm = getCm(acq)
%This function searches through the headerstring of 'acq' and extracts the
%Cm value in the AD0 channel and returns it

    skipChars = length('state.phys.cellParams.cm0=');
    beginCm = strfind(acq.UserData.headerString,'state.phys.cellParams.cm0=');
    endCm = strfind(acq.UserData.headerString(beginCm+skipChars:end),'state');
    
    
    strCm = acq.UserData.headerString(beginCm+skipChars:beginCm+skipChars+endCm-2);
    
    cm = str2num(strCm);
end

