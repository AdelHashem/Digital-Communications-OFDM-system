function [next_states, outputs] = Trellis_Gen(L,polynomial)
states = 2^(L-1);
current = 0: states-1;
%% next states
next_states = zeros(2, length(current));
%shift every state by 0  ex:  if  in state (11) 3 in dec become (01) 1 in
%dec
next_states(1, :) = bitshift(current, -1);

next_states(2, :) = bitshift(current, -1) + 2^(L-2);  %shift by 1

%% outputs
col = length(polynomial); % number of output bits
decimal = oct2dec(polynomial);
outputs = zeros(2, length(current));
temp = outputs;

for i = col-1 : -1 : 0
    % anding current state with a single polynomial value
    temp(1,:) = bitand(current, decimal(col -i));
    temp(2,:) = bitand(current+ (states), decimal(col -i));
    
    % convert the output into binary form(array of 0s and 1s)
    % add the ones ( if odd  -> 1)
    %              ( if even -> 0)
    temp(1, :) = mod(sum(de2bi(temp(1,:)), 2), 2);
    temp(2, :) = mod(sum(de2bi(temp(2,:)), 2), 2);
    
    % shift the first output column to the left by "num_out_columns-1"
    % times, each shift to the left in the binary system is a
    % multiplication by 2 in decimal system
    if i == 0
        outputs = outputs + temp;
    else
        outputs = outputs + temp*2*i;
    end
end






end