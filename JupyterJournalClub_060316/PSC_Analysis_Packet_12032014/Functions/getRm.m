function rm = getRm(acq)
%This function searches through the headerstring of 'acq' and extracts the
%Rm value in the AD0 channel and returns it

    skipChars = length('state.phys.cellParams.rm0=');
    beginRm = strfind(acq.UserData.headerString,'state.phys.cellParams.rm0=');
    endRm = strfind(acq.UserData.headerString(beginRm+skipChars:end),'state');
    
    
    strRm = acq.UserData.headerString(beginRm+skipChars:beginRm+skipChars+endRm-2);
    
    rm = str2num(strRm);
end

