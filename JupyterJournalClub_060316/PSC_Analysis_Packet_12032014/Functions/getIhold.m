function im = getIhold(acq)
%This function searches through the headerstring of 'acq' and extracts the
%Cm value in the AD0 channel and returns it

    skipChars = length('state.phys.cellParams.im0=');
    beginIm = strfind(acq.UserData.headerString,'state.phys.cellParams.im0=');
    endIm = strfind(acq.UserData.headerString(beginIm+skipChars:end),'state');
    
    
    strCm = acq.UserData.headerString(beginIm+skipChars:beginIm+skipChars+endIm-2);
    
    im = str2num(strCm);
end