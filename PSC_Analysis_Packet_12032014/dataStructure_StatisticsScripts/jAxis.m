function output = jAxis(m,u,stdev)
%"Jitter Axis"
%This function creates random numbers to 'jitter' points along an axis for
%graphical purposes. 
%m is the number of random numbers you want
%u is the mean of the random numbers
%stdev is the standard deviation of the random numbers

output = u + stdev*randn(m,1);

end

