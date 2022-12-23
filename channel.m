function [output] = channel(signal,h,EbNodb,M)
SNR = EbNodb + 10*log10(log2(M));
%h = (1/sqrt(2*L)) * (randn(1,L) + 1i * rand(1,L));
signal = conv(h,signal);  % comment this line for AGWN Only
noise = awgn(signal,SNR,'measured');
output = noise;
end

