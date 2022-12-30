function [x] = PolarDecode2(bits,K,N)

n = log2(N);
load('Q.mat','Q');
Q1 = Q(Q<=N);
F = Q1(1:N-K); %frozen pos

L = zeros(n+1,N);
ucap = zeros(n+1,N);
ns = zeros(1,2*N - 1); %The Tree

f = @(a,b) (1-2*(a<0)).*(1-2*(b<0)).*min(abs(a),abs(b));
%f = @(a,b) sign(a).*sign(b).*min(abs(a),abs(b));
g = @(a,b,c) b+(1-2*c).*a;

L(1,:) = bits;

node = 0; depth = 0;
flag = 0;
while (flag == 0)
    if depth == n
        if any(F==(node+1))
            ucap(n+1,node+1) = 0;
        else
            if L(n+1,node+1) >= 0
                ucap(n+1,node+1) = 0;
            else
                ucap(n+1,node+1) = 1;
            end
        end
        
        if node == (N-1)
            flag = 1;
        else
            node = floor(node/2); depth = depth - 1;
        end
    else
        npos = (2^depth) + node + 1;
        if ns(npos) == 0
            temp = 2^(n-depth);
            Ln = L(depth+1,temp*node+1:temp*(node+1));
            a = Ln(1:temp/2);b= Ln(temp/2+1:end);
            node = node * 2; depth = depth +1;
            temp = temp/2;
            L(depth+1,temp*node+1:temp*(node+1))= f(a,b);
            ns(npos) = 1;
        else
            if ns(npos) == 1
                temp = 2^(n-depth);
                Ln = L(depth+1,temp*node+1:temp*(node+1));
                a = Ln(1:temp/2);b= Ln(temp/2+1:end);
                lnode = 2 * node; ldepth = depth + 1;
                ltemp = temp/2;
                ucapn = ucap(ldepth+1,ltemp*lnode+1:ltemp*(lnode+1));
                node = node * 2 + 1; depth = depth +1;
                temp = temp/2;
                L(depth+1,temp*node+1:temp*(node+1))= g(a,b,ucapn);
                ns(npos) = 2;
            else
               temp = 2^(n-depth); 
               lnode = 2 * node; rnode = 2 * node +1; cdepth = depth + 1;
               
               ctemp = temp/2;
               ucapl =ucap(cdepth+1,ctemp*lnode+1:ctemp*(lnode+1));
               ucapr =ucap(cdepth+1,ctemp*rnode+1:ctemp*(rnode+1));
               ucap(depth+1,temp*node+1:temp*(node+1)) = [mod(ucapl+ucapr,2) ucapr];
               node = floor(node/2);depth =depth -1;
            end
        end
    end
    
    
end

x = ucap(n+1,Q1(N-K+1:end));


end