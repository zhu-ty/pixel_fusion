clear;
close all;
thH = 1700;
thL = 2000;
MAX_sub_thL = 65536 - thL;
w = zeros(65536,2048);
for i = 1:65536
    for j = 1:2048
        if(i < thL && j <= thH)
            w(i,j) = 1;
        elseif( j > thH && i >= thL)
            w(i,j) = 0;
        elseif(i >= thL && j <= thH)
            w(i,j) = (((65536 - i) / MAX_sub_thL) * ((thH - j)/thH))^0.2;
        else
            w(i,j) = 0.5;
        end
    end
    if(mod(i,1000) == 0)
        fprintf('%d\n',i);
    end
end

to_p = zeros(1,2048);
for i=1:2048
    to_p(1,i) = w(i*30,i);
end

plot(to_p);
    