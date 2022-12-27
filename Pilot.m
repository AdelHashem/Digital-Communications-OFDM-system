function H_est = Pilot(h,EbNo,Nfft,cp,M)
symbols(1:1024) = 3+3i;

sig_ifft = ifft(symbols,Nfft).*sqrt(1024);

sig = cpAdd(sig_ifft,cp);

r = channel(sig,h,EbNo,M,"Fading");

r = cpRem(r,cp,Nfft);

H_est = (fft(r)./sqrt(1024))./ symbols;


end

