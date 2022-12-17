function [output] = cpAdd(signal,L)
output = [signal(end - L+1:end) signal];
end

