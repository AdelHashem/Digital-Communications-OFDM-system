function [output] = channel(signal,h,EbNodb,M)
signal = conv(h,signal);  % comment this line for AGWN Only

Eb = 1 / log2(M);
EbNo_linear=10^(EbNodb/10);
% Calculating Noise PSD (No) corresponding to Eb/No
No=Eb/EbNo_linear;
Noise=sqrt(No/2)*(randn(length(signal),1)+1i*randn(length(signal),1));
output = Noise' + signal ;


end

