function [output] = channel(signal,h,EbNodb,M,ch)
if ch == "Fading"
    signal = conv(h,signal);
end
  

Eb = 1 / log2(M);
EbNo_linear=10^(EbNodb/10);
% Calculating Noise PSD (No) corresponding to Eb/No
No=Eb/EbNo_linear;
Noise=sqrt(No/2)*(randn(length(signal),1)+1i*randn(length(signal),1));
output = Noise' + signal ;


end

