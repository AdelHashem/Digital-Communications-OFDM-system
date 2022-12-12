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
                    obj.bits = [obj.bits zeros(1,4-rem(length(obj.bits)))];
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
    end
end

