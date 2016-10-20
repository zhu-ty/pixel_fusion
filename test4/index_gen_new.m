clear;
close all;


thL_ = 2000;
thH_ = 1600;
pow_c = 0.2;
undefine_area = 0.5;
Hmax_ = 2047;
Lmax_ = 65535;
output_c = 300;






full   = bin2dec('111 1111 1111');
maskH5 = bin2dec('111 1100 0000');
maskL5 = bin2dec('000 0001 1111');
maskH6 = bin2dec('111 1110 0000');
maskL6 = bin2dec('000 0011 1111');

thH = thH_;
thL = bitshift(thL_,-5);
Hmax = Hmax_;
Lmax = bitshift(Lmax_,-5);

L_range = Lmax + 1 - thL;
w = zeros(Lmax+1,Hmax+1);
w_map = uint16(zeros(Lmax+1,Hmax+1));
for i = 1:Lmax+1
    for j = 1:Hmax+1
        cal = 0;
        if(i < thL && j <= thH)
            w(i,j) = 1;
            w_map(i,j) = j;
            cal = 1;
        elseif( j > thH && i >= thL)
            w(i,j) = 0;
            w_map(i,j) = bitshift(i,5);
            cal = 1;
        elseif(i >= thL && j <= thH)
            w(i,j) = (((Lmax+1 - i) / L_range) * ((thH - j)/thH)) ^ pow_c;
        else
            w(i,j) = undefine_area;
        end
        if (cal == 0)
            
%             high = bitshift(bitand(i,maskH5), 5);
%             low = bitand(j,maskL5);
%             midL = double(bitand(i,maskL6));
%             midH = double(bitshift(bitand(j,maskH6),-5));
%             mid = uint16(uint16((1 - w(i,j)) * midL) + uint16(w(i,j) * midH));
%             %mid = bitshift(bitand(mid,maskL6), 5);
%             mid = bitshift(mid, 5);
%             w_map(i,j) = high + mid + low;
            L = bitshift(i,5);
            H = j;
            w_map(i,j) = uint16(((1 - w(i,j)) * L) + w(i,j) * H);
            
        end
    end
    if(mod(i,output_c) == 0)
        fprintf('%d%%\n',uint8(i * 100 / Lmax));
    end
end

str = ['w_map_',int2str(thL_),'_',int2str(thH_),'_',num2str(pow_c),'_',num2str(undefine_area),'.mat'];
save(str,'w','w_map');

if(1)
    to_p = zeros(1,2048);
    to_p2 = zeros(1,2048);
    for i=1:2048
        x = uint16(bitshift(i * 30,-5));
        if(x == 0)
            x = 1;
        end
        to_p(1,i) = w(x,i);
        to_p2(1,i) = w_map(x,i);
    end
    
    plot(to_p);
    figure(2);
    plot(to_p2);
end
