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
            elseif Flag == "Decode2"
            mtable=[0,0,0,0;0,0,0,1;0,0,1,0;0,0,1,1;0,1,0,0;0,1,0,1;0,1,1,0;0,1,1,1;1,0,0,0;1,0,0,1;1,0,1,0;1,0,1,1;1,1,0,0;1,1,0,1;1,1,1,0;1,1,1,1];
                genmat = [1,1,0,1,0,0,0;0,1,1,0,1,0,0;1,1,1,0,0,1,0;1,0,1,0,0,0,1];
                vec4=[0,0,0,0];
                %padbits=[obj.bits 0];
                %% creating codewords table and syndrome
                for i=1:16
                    for j=1:4
                        vec4(j)=mtable(i,j);
                    end
                    cwtable(i,:)=mod(vec4*genmat,2);
                end
                parmat = gen2par(genmat);
                syndrom = syndtable(parmat);
                
                
                %% decoding
                
                
                %out  = decode(m,7,4,'linear',genmat,syndrom);
                rcodeword=[0,0,0,0,0,0,0];
                for s=1:length(obj.bits)-1 %loop to split the recieved bits into blocks
                    if rem(s,7)==1
                        rcodeword=obj.bits(s:s+6);
                    else
                        continue;
                    end
                    errorvec1=mod(rcodeword*parmat',2);% getting error vector
                    erlen=length(errorvec1);
                    erind=0;
                    for k=erlen:-1:1 %loop to convert error vector into index
                        erind=erind+errorvec1(k)*(2^(erlen-k));
                    end
                    erindreal=erind+1;
                    
                    errorest=syndrom(erindreal,:);%getting the syndrome from syndrome table
                    true_codeword=mod(rcodeword+errorest,2);%adding syndrome to the codeword
                    for i=1:16 %getting real message from the codeword table
                        for j=1:7
                            vec5(j)=cwtable(i,j);
                        end
                        if vec5==true_codeword
                            realmessage=mtable(i,:);
                            break;
                        end
                    end
                    if s==1 %putting real message together in one vector
                        out=realmessage;
                    else
                        out=[out realmessage];
                    end
                end

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
                    out = [out PolarDecode2(packet,K,N)];
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

