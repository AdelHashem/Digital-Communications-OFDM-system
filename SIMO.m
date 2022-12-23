clc;
clear variables;

frames = 100; % frames / Eb/No value
Nsymbols = 15; % OFDM Symbos / Frame
M = 4; %QPSK
L = 50;
x = 0:3:40;
BER = [];
c = 1;
for EbNo = 0:3:40
    error = 0;
    total = 0;
    
    for i = 1:1:frames
        [err, tot] = OFDMframeSIMO(Nsymbols,L,M,EbNo,"LinearBlock");
        error = error + err;
        total = total + tot;
    end
    BER(c) = error / total;
    c = c + 1
    
end

figure
plot(x,log10(BER),'b--o')
title(['BER VS Eb/No ' 'LinearBlock - QPSK']);
xlabel('Eb/No (db)')
ylabel('BER (log10)')
