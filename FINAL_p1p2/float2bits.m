function [bits] = float2bits(float, n)
%FLOAT2BITS ��0.5~1.99������ȡΪnλ������С������ת��С��

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

