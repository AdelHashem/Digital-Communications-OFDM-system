function [x] = PolarEncode(bits,K,N)
n = log2(N);
load('Q.mat','Q');
Q1 = Q(Q<=N);
u = zeros(1,N);
% frozen Position :N-k  assign first N-k from Q1 to zero in u 
u(Q1(N-K+1:end)) = bits; % massage Position

count = 1 ;% # of elements working on

for i = n-1:-1:0
   for j = 1:2 * count:N
       v1 = u(j:j+count-1);
       v2 = u(j+count:j+ count *2-1);
       u(j:j+2*count-1) = [mod(v1+v2,2) v2];
   end
   count = count * 2;
end
x = u;
end