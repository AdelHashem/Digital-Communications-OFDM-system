function  decoded_seq = ViterbiDecoder(rec_sample_seq, B)

    bits=[];
    for col = 1:B
         word1 = rec_sample_seq(col*2-2+1:col*2);
         word2=double(string(word1(1))+string(word1(2)));
         bits=[bits word2];
    end

    s1= [1 1];
    t1= [2 3]; 
    path1= [ 00 11 ];
    w1 = xor(floor(path1(1)/10),floor(bits(1)/10)) + xor(mod(path1(1),10),mod(bits(1),10));
    w2 = xor(floor(path1(2)/10),floor(bits(1)/10)) + xor(mod(path1(2),10),mod(bits(1),10));
    weights1 = [w1 w2];

    s2=[2 2 3 3];
    t2=[4 5 6 7];
    path2= [ 00 11 01 10 ];
    w1 = xor(floor(path2(1)/10),floor(bits(2)/10)) + xor(mod(path2(1),10),mod(bits(2),10));
    w2 = xor(floor(path2(2)/10),floor(bits(2)/10)) + xor(mod(path2(2),10),mod(bits(2),10));
    w3 = xor(floor(path2(3)/10),floor(bits(2)/10)) + xor(mod(path2(3),10),mod(bits(2),10));
    w4 = xor(floor(path2(4)/10),floor(bits(2)/10)) + xor(mod(path2(4),10),mod(bits(2),10));
    weights2 = [w1 w2 w3 w4];
    weights = [weights1 weights2];
    path = [path1 path2];


    s3= [4 4 5 5 6 6 7 7];
    t3= [8 9 10 11 8 9 10 11];
    path3= [ 00 11 01 10 11 00 10 01 ];
    w1 = xor(floor(path3(1)/10),floor(bits(3)/10)) + xor(mod(path3(1),10),mod(bits(3),10));
    w2 = xor(floor(path3(2)/10),floor(bits(3)/10)) + xor(mod(path3(2),10),mod(bits(3),10));
    w3 = xor(floor(path3(3)/10),floor(bits(3)/10)) + xor(mod(path3(3),10),mod(bits(3),10));
    w4 = xor(floor(path3(4)/10),floor(bits(3)/10)) + xor(mod(path3(4),10),mod(bits(3),10));
    w5 = xor(floor(path3(5)/10),floor(bits(3)/10)) + xor(mod(path3(5),10),mod(bits(3),10));
    w6 = xor(floor(path3(6)/10),floor(bits(3)/10)) + xor(mod(path3(6),10),mod(bits(3),10));
    w7 = xor(floor(path3(7)/10),floor(bits(3)/10)) + xor(mod(path3(7),10),mod(bits(3),10));
    w8 = xor(floor(path3(8)/10),floor(bits(3)/10)) + xor(mod(path3(8),10),mod(bits(3),10));
    weights3 = [w1 w2 w3 w4 w5 w6 w7 w8];


    weights=[weights weights3];
    s=[s1 s2 s3];
    t=[t1 t2 t3];

    for i=4:B

       s3= s3 + 4;
       t3= t3 +4;
       w1 = xor(floor(path3(1)/10),floor(bits(i)/10)) + xor(mod(path3(1),10),mod(bits(i),10));
       w2 = xor(floor(path3(2)/10),floor(bits(i)/10)) + xor(mod(path3(2),10),mod(bits(i),10));
       w3 = xor(floor(path3(3)/10),floor(bits(i)/10)) + xor(mod(path3(3),10),mod(bits(i),10));
       w4 = xor(floor(path3(4)/10),floor(bits(i)/10)) + xor(mod(path3(4),10),mod(bits(i),10));
       w5 = xor(floor(path3(5)/10),floor(bits(i)/10)) + xor(mod(path3(5),10),mod(bits(i),10));
       w6 = xor(floor(path3(6)/10),floor(bits(i)/10)) + xor(mod(path3(6),10),mod(bits(i),10));
       w7 = xor(floor(path3(7)/10),floor(bits(i)/10)) + xor(mod(path3(7),10),mod(bits(i),10));
       w8 = xor(floor(path3(8)/10),floor(bits(i)/10)) + xor(mod(path3(8),10),mod(bits(i),10));
       weights4 = [w1 w2 w3 w4 w5 w6 w7 w8];   
       weights = [weights weights4];
       s = [s s3];
       t = [t t3];
    end

    G = digraph (s,t,weights);
    [P1,d1] = shortestpath(G,1,t(end)-3);
    [P2,d2] = shortestpath(G,1,t(end)-2);
    [P3,d3] = shortestpath(G,1,t(end)-1);
    [P4,d4] = shortestpath(G,1,t(end));
    
    minpath=min([d1,d2,d3,d4]);

    if d1 == minpath
        shortest_path= P1;
    end
    if d2 == minpath
        shortest_path= P2;
    end
    if d3 == minpath
        shortest_path= P3;
    end
    if d4 == minpath
        shortest_path= P4;
    end
   
    length_shortest_path=length(shortest_path);
    decoded_seq=zeros(1,length_shortest_path-1);

    for i=2:length_shortest_path
        if mod(shortest_path(i),2)==0
            decoded_seq(i)=0;
        else 
            decoded_seq(i)=1;
        end
    end

    decoded_seq=(decoded_seq(2:end));

end

