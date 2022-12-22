classdef Modulation
    %MODULATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        data
    end
    
    methods
        function obj = Modulation()
            %MODULATION Construct an instance of this class
            %   Detailed explanation goes here
        end
        
        function out = splitdata(obj,data,n)
            index = 1;
            if rem(length(data),n) ~= 0
               data = [data zeros(1,n - rem(length(data),n))]; 
            end
            out = zeros(1,length(data)/n);
            for i=1:n:length(data)
                out(index) = bi2de(flip(data(i:i+n-1)));
                index = index + 1;
            end
        end
        
        function out = QPSK(obj,data,selector)
            % Mod & Demod The QPSK
            % i/p: selector ['Mod','Demod']
            MapTable = [0 0;0 1;1 1;1 0];
            Map = 1/sqrt(2).*[-1-1j -1+1j 1-1j 1+1j]; 
            
            if selector == "Mod"
                data = obj.splitdata(data,2);
                out = Map(data+1);
            elseif selector == "Demod"
                be = real(data);
                be(be >= 0) = 1; be(be < 0) = 0;
                bo = imag(data);
                bo(bo >= 0) = 1; bo(bo < 0) = 0;
                b=[be;bo];
                out = b(:)';
                
            else
                out = data;
            end
            
            
        end
        function out = QAM16(obj,data,selector)
            % Mod & Demod The 16QAM
            % i/p: selector ['Mod','Demod']
            MapTable = [0 0 0 0;0 0 0 1;0 0 1 0;0 0 1 1;0 1 0 0;0 1 0 1;0 1 1 0;0 1 1 1;1 0 0 0;1 0 0 1;1 0 1 0;1 0 1 1;1 1 0 0;1 1 0 1;1 1 1 0;1 1 1 1];
            Map = 1/sqrt(10).*[-3-3j -3-1j -3+3j -3+1j -1-3j -1-1j -1+3j -1+1j 3-3j 3-1j 3+3j 3+1j 1-3j 1-1j 1+3j 1+1j];

            if selector == "Mod"
                data = obj.splitdata(data,4);
                out = Map(data+1);
            elseif selector == "Demod"
                out = [];
                for k = 1:1:length(data)
                    be = real(data(k));
                    bo = imag(data(k));
                    if (be > 1.5/(sqrt(10)))
                        be = [1 0];
                    elseif (be > 0)
                        be = [1 1];
                    elseif (be < -1.5/(sqrt(10)))
                        be = [0 0];
                    else
                        be = [0 1];
                    end
                    if (bo > 1.5/(sqrt(10)))
                        bo = [1 0];
                    elseif (bo > 0)
                        bo = [1 1];
                    elseif (bo < -1.5/(sqrt(10)))
                        bo = [0 0];
                    else
                        bo = [0 1];
                    end
                    b=[be bo];
                    out =[out b];    
                end
            end
                    
                    
                    
                end
                
                
                
            
        
    end
end
