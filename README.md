# Digital-Communications-OFDM-system
In the Digital Communications project, you will investigate the performance of an OFDM-based  communication system

## Channel coding: (As methods in ChannelCode.m)
- [X] PolarCode
- [x] LinearBlock ~~(the Decoder (Matlab Fun))~~ (The function decoder matlab and emplemnted decoder)
- [x] ConvolutionalCode (ConvolutionalCode() A flexible func can be designed for any L&n ConvolutionalCode2() fixed n = 2, L=2 faster for our case)
## Symbol mapper: (As methods in Modulation.m)
- [x] QPSK
- [x] 16QAM
- [x] 64QAM
## Pilot:
- [x] implemented ~~(Not Sure)~~ -Verified by Dr. Karmoose
## Cyclic prefix
- [x] Add Cyclic prefix
- [x] Remove Cyclic prefix
## channel
- [x] AWGN (channel.m)
- [x] Multi-path fading (we get h(fixed for one frame) then make the conv and add the noise in channel.m for both SISO & SIMO)
## MIMO setups:
- [X] SISO (QPSK-LinearBlock) (run SISO.m)
- [X] SIMO (QPSK-LinearBlock) (run SIMO.m)  -we can Now Use the Selection Combining & The MRC (Just edit the selc to "MRC" Or "SC") the Algorithm was explained by DR.Karmoose
