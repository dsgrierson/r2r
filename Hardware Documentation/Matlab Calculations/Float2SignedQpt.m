function [FxdPtStruct] = Float2SignedQpt(num,epsilon)
%% Calculate the Fixed Point Approximation of a Float
% in a Given Q Fixed Point Format for a specified precision
% returned in a structure with th the below member variables
% FxdPt is the fixed point (integer number)
% QI is required # integer bits
% QF is required # of fractional bits for input epsilon
% WL is the required word lenght for the variable

	absnum = abs(num);
  	FxdPtStruct.QI = floor(log2(absnum)+2);
    FxdPtStruct.QF = ceil(log2(1/epsilon));
	FxdPtStruct.FxdPt = floor(num*2^FxdPtStruct.QF);	%// num * 2^(QF)
    FxdPtStruct.WL = FxdPtStruct.QI + FxdPtStruct.QF;
	disp('QPT_ERR_OK');	%// all worked ok - conversion successful
    disp(sprintf('%f converted to fixed point = %d in a Q%d.%d format',num,FxdPtStruct.FxdPt,FxdPtStruct.QI,FxdPtStruct.QF))
    disp(sprintf('and requires a Word Length of %d bits',FxdPtStruct.WL))
end