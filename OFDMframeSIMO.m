function [error,Total] = OFDMframeSIMO(noSymobl,L,M,EbNo,chCoding,ch,selc)
%OFDMFRAME Summary of this function goes here
%   Detailed explanation goes here
Nfft = 1024;
cp = L + 1;
k = log2(M);
if chCoding == "Polar" 
    Nbits = 1024;
elseif chCoding == "Convolutional"
    Nbits = 1024;    
elseif chCoding == "LinearBlock"
    Nbits = 1168;
    
else
    Nbits = 1168;
end


if M == 4
    modu = "QPSK";
elseif M == 16
    modu = "16QAM";
    Nbits = Nbits * 2;
elseif M == 64
    modu = "64QAM";
    Nbits = Nbits * 3;
else
    modu = "QPSK";
end

K = log2(M);


error = 0;
Total = 0;
%h = (1/sqrt(2*L)) * (randn(1,L) + 1i * rand(1,L)); % Fading Ch (Cont for the Frame)
%h2 = (1/sqrt(2*L)) * (randn(1,L) + 1i * rand(1,L)); % Fading Ch2 (Cont for the Frame)
for symbol = 1:1:noSymobl
   if rem(symbol-1,10) == 0
       h = (1/sqrt(2*L)) * (randn(1,L) + 1i * rand(1,L)); % Fading Ch (changing every 10 symbols)
       h2 = (1/sqrt(2*L)) * (randn(1,L) + 1i * rand(1,L)); % Fading Ch2 (changing every 10 symbols)
       H_est = Pilot(h,EbNo,Nfft,cp,M);
       H_est2 = Pilot(h2,EbNo,Nfft,cp,M);
       
   else
       % 1168 bit after LinearBlock(4,7) coding we get 2044
       % bit_seq = GenerateBits(1168);
       bit_seq = GenerateBits(Nbits);

       Coding = ChannelCode(bit_seq);
       %coded  = Coding.linearBlock("Encode");
       if chCoding == "Polar"
          coded  = Coding.PolarCode("Encode");
          
       elseif chCoding == "Convolutional"
           coded  = Coding.Convolutional("Encode");
       else
           coded  = Coding.linearBlock("Encode");
       end
       % we Mod 2044 bit with QPSK, We Get 1022 symbol
       mod = Modulation();
       
       if modu == "QPSK"
        mod_bits = mod.QPSK(coded,"Mod");
       elseif modu == "16QAM"
           mod_bits = mod.QAM16(coded,"Mod");
       else
           mod_bits = mod.QAM64(coded,"Mod");
       end
       
       
       % pading the i/p of ifft to reach 1024 carrier
       if rem(length(mod_bits),1024) ~=0
           mod_bits = [mod_bits zeros(1,Nfft - rem(length(mod_bits),Nfft))];
       end

       data1 =ifft(mod_bits,Nfft).* sqrt(Nfft);
       
       % Add the Cyclic prefix
       data  = cpAdd(data1,cp);
       
       % CHANNEL
       r = channel(data,h,EbNo,M,ch);
       r2 = channel(data,h2,EbNo,M,ch);
       
       % RECIVER
       r = cpRem(r,cp,Nfft); % remove the Cyclic prefix
       r2 = cpRem(r2,cp,Nfft); % remove the Cyclic prefix
       if ch == "Fading"
           if selc == "SC"
              r_est = (fft(r)./sqrt(Nfft)) ./ H_est;
              r_est2 = (fft(r2)./sqrt(Nfft)) ./ H_est2;
           else %MRC
               r_est = (fft(r)./sqrt(Nfft)) .* conj(H_est);
               
               r_est = r_est + ((fft(r2)./sqrt(Nfft)) .* conj(H_est2));
               r_est = r_est ./ (H_est.* conj(H_est) + H_est2.*conj(H_est2));

           end
       else
           r_est = (fft(r)./sqrt(Nfft));
           r_est2 = (fft(r2)./sqrt(Nfft));
       end
       
       
       if selc == "SC"
           pw = 0;
           pw2 = 0;
           for i = 1 : 1024
               pw = pw + r_est(i).^2;
               pw2 = pw2 + r_est2(i).^2;
           end
           
           if pw2 > pw
               r_est = r_est2;
           end
           
       end
       
       if modu == "QPSK"
        demoded = mod.QPSK(r_est(1:Nfft),"Demod");
       elseif modu == "16QAM"
           demoded = mod.QAM16(r_est(1:Nfft),"Demod");
       else
           demoded = mod.QAM64(r_est(1:Nfft),"Demod");
       end
       if chCoding == "Polar"
           Coding = ChannelCode(demoded);
           rec = Coding.PolarCode("Decode");
           
       elseif chCoding == "Convolutional"
           Coding = ChannelCode(demoded);
           rec = Coding.Convolutional("Decode");
       else
           Coding = ChannelCode(demoded(1:2044*k/2));
           rec = Coding.linearBlock("Decode");
       end
       
       %Coding = ChannelCode(demoded);
       %
       
       error = error + biterr(bit_seq,rec);
       Total = Total + length(bit_seq);
   end
end
end

