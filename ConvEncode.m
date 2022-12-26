function [x] = ConvEncode(bits,n, next, out)
x = [];
state = 0; %initial state
for i = 1:length(bits)
    temp = out(bits(i)+1 , state+1);
    state = next(bits(i)+1 ,state + 1);
    x = [x flip(de2bi(temp,n))];
end
end