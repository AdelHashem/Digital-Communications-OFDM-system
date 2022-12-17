function [r] = cpRem(signal,cpN,Nfft)
%CPREM Summary of this function goes here
%   Detailed explanation goes here
r = signal(cpN+1:cpN+Nfft);
end

