function [bits] = float2bits(float, n)
%FLOAT2BITS 将0.5~1.99的数截取为n位二进制小数，再转回小数

bits = zeros(1,n);
bits_float = 0;
for i = 1 : n
    if(float >= 2 ^ -(i - 1))
        bits_float = bits_float + 2 ^ -(i - 1);
        float = float - 2 ^ -(i - 1);
        bits(i) = 1;
    end
end


end

