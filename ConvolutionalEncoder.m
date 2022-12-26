function  coded_seq = ConvolutionalEncoder(bit_seq,B)
    current_state =[0 0];
    coded_seq=[];
        
    for i=1:B 
    
    next_state = [bit_seq(i) current_state];
    coded_seq = [coded_seq xor(next_state(1),next_state(3))  xor(next_state(3),xor(next_state(1),next_state(2)))];
    next_state = next_state(1:2);
    current_state=next_state;
    end 
    
    
    
    % Another way to encode
%     h1=[1 1 1] ;
%     h2=[1 0 1];
%         
%     y1 = cnv(h1,bit_seq);
%     y2 = cnv(h2,bit_seq);
% 
% 
%     coded_seq2 = [];
%     for i=1:length(bit_seq)
%         coded_seq2 = [coded_seq2 y2(i) y1(i)];
%     end
    
end
