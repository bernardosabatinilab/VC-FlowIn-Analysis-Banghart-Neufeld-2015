function acqNum = getAcqNum(AcqName)
%Returns as a double the number of the given Acq
    currNum = str2num(AcqName(5:end));
    acqNum = currNum;
end

