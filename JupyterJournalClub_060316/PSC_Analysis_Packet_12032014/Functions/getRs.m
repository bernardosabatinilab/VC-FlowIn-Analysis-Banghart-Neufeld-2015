function rs = getRs(acq)
%This function searches through the headerstring of 'acq' and extracts the
%Rs value in the AD0 channel and returns it

    skipChars = length('state.phys.cellParams.rs0=');
    beginRs = strfind(acq.UserData.headerString,'state.phys.cellParams.rs0=');
    endRs = strfind(acq.UserData.headerString(beginRs+skipChars:end),'state');
    
    
    strRs = acq.UserData.headerString(beginRs+skipChars:beginRs+skipChars+endRs-2);
    
    rs = str2num(strRs);
end

