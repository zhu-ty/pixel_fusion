function [pixel_value_16] = pixel_mix(pixel_value_low_11, pixel_value_high_11, low_threshold)
%PIXEL_MIX ��ϸߵͷŴ�����ĳ�����ص㣬�߷Ŵ�������2000ʧЧ
%   [in] pixel_value_low_11  - �ͷŴ�����11λ
%   [in] pixel_value_high_11 - �߷Ŵ�����11λ
%   [in] low_threshold       - �ͷŴ�����Ч��ֵ��Ĭ��Ϊ50000
%   [out]pixel_value_16      - ��ϵ�����ֵ

high_threshold = 1700;

full   = bin2dec('111 1111 1111');
maskH6 = bin2dec('111 1110 0000');
maskL6 = bin2dec('000 0011 1111');
pixel_value_16 = 0;
    if (nargin < 3)
        low_threshold = uint16(50000);
    elseif( nargin < 2)
        printf('error\n');
        return;
    end
    
    if (pixel_value_low_11 > low_threshold || pixel_value_high_11 > high_threshold)
        pixel_value_16 = bitor(pixel_value_low_11, maskL6);
        return;
    end
    
    Il_t2 = uint16(double(pixel_value_low_11) / 32);
    Il_t2 = Il_t2 - (Il_t2 - 2047);
    
    high = bitshift(bitand(Il_t2,bitxor(maskL6,full)),5);
    
    av1 = bitand(Il_t2,maskL6);
    av2 = bitshift(bitand(pixel_value_high_11,maskH6),-5);
    av = (av1 + av2) / 2;
    av = bitshift(av,5);
    
    low = bitand(pixel_value_high_11,bitxor(maskH6,full));
    
    pixel_value_16 = bitor(bitor(high,av),low);
    
    return;
end

