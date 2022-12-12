function [x] = PolarDecode(bits,K,N)

[r ,u_hat, u] = node_leaf_logic(bits , [], [], K, N, 1);
load('Q.mat','Q');
Q1 = Q(Q<=N);
x = u(Q1(N-K+1 :end));

end


function [ data ,  u_hat, u ] = node_leaf_logic( data , u_hat, u , k, n , i )
f = @(a,b) (1-2*(a<0)).*(1-2*(b<0)).*min(abs(a),abs(b));
%f = @(a,b) sign(a).*sign(b).*min(abs(a),abs(b));
g = @(a,b,c) b+(1-2*c).*a;
if(i<n) % the Node Not leaf
    %split The tree
    a = data(1 :end /2);
    b = data(end/2+1 :end);
    %left side
    left = f(a,b);
    [Uleft ,u_hat_L, u] = node_leaf_logic(left, u_hat, u, k, n, i*2);
    
    
    %right
    
    right = g(a,b,u_hat_L);
    [Uright, u_hat_R, u] = node_leaf_logic(right, u_hat, u, k, n, (i*2)+1);
 
    data =[Uleft Uright ];
    u_hat = [mod(u_hat_L + u_hat_R , 2) u_hat_R];
    
else %leaf Node
    load('Q.mat','Q');
    Q1 = Q(Q<=n);
    F = Q1(1:n-k);
    if any(F == ( i-(n-1) ) )
        u_hat = [u_hat 0] ;
        u = [u 0];
    else
        if data(1) >=0
            u_hat = [u_hat 0] ;
            u = [u 0];
        else
            u_hat = [u_hat 1] ;
            u = [u 1];
        end
    end
end




end
