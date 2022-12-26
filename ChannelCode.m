classdef ChannelCode
    %CHANNELCODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        bits
    end
    
    methods
        function obj = ChannelCode(inputArg1)
            %CHANNELCODE Construct an instance of this class
            %   Detailed explanation goes here
            obj.bits = inputArg1;
        end
        
        function out = linearBlock(obj,Flag)
            %(4,7) Linear block code
            
            genmat = [1,1,0,1,0,0,0;0,1,1,0,1,0,0;1,1,1,0,0,1,0;1,0,1,0,0,0,1];
            parmat = gen2par(genmat);
            syndrom = syndtable(parmat);
            out = [];
            if Flag == "Encode"
                if rem(length(obj.bits),4) ~= 0
                    obj.bits = [obj.bits zeros(1,4-rem(length(obj.bits),4))];
                end
                for i = 1:4:length(obj.bits)
                    out = [out rem(obj.bits(i:i+3)*genmat,2)];
                end
                
            elseif Flag == "Decode"
                out  = decode(obj.bits,7,4,'linear',genmat,syndrom);
            else
                out = obj.bits;
            end
           
        end
        
        function out = PolarCode(obj,Flag)
           N = 512;
           K = 256;
           out = [];
            if Flag == "Encode"
                if rem(length(obj.bits),K) ~= 0
                    obj.bits = [obj.bits zeros(1,K-rem(length(obj.bits)))];
                end
                for i = 1:K:length(obj.bits)
                    out = [out PolarEncode(obj.bits(i:i+K-1),K,N)];
                end
            elseif Flag == "Decode"
                for i = 1:N:length(obj.bits)
                    packet = obj.bits(i:i+N-1);
                    packet(packet==1) = -1;    packet(packet==0) = 1;
                    out = [out PolarDecode(packet,K,N)];
                end
            else
               out = obj.bits; 
            end
            
        end
        
        function out = Convolutional(obj,Flag)
            n = 2;
            L = 3;
            [next_states, outputs] = Trellis_Gen(L,[5 7]);
            
            
            if Flag == "Encode"
                out = ConvEncode(obj.bits,n, next_states, outputs);
                
            elseif Flag == "Decode"
                out = viterbi_decoder3(obj.bits, next_states, outputs, L,n);
            else
                out = obj.bits;
            end
            
            
            
        end
        
        function out = Convolutional2(obj,Flag)
            n = 2;
            L = 3;
            
            
            if Flag == "Encode"
                out = ConvolutionalEncoder(obj.bits, length(obj.bits));
                
            elseif Flag == "Decode"
                out = ViterbiDecoder(obj.bits, length(obj.bits)/2);
            else
                out = obj.bits;
            end
            
            
            
        end
        
        
    end
end

