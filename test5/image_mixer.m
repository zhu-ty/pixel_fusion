function [I_ans] = image_mixer(IL, IH, thL_, thH_, pow_c, undefine_c, output_step, Hmax_, Lmax_)
%IMAGE_MIXER 混合IH与IL，两者有效位数均为高11位
%   Hmax和thH均对低11位生效(0-2047)
%   Lmax和thL均对高11位生效(0-2048-65535)
%   但是IH与IL均为高11位生效(0-2048-65535)
%   请注意区分

thH = thH_;
thL = bitshift(thL_,-5);
Hmax = Hmax_;
Lmax = bitshift(Lmax_,-5);
already_have = 0;
str = ['w_map_',int2str(thL_),'_',int2str(thH_),'_',num2str(pow_c),'_',num2str(undefine_c),'.mat'];
if(exist(str,'file'))
    already_have = 1;
end
if(~already_have)
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
                w(i,j) = undefine_c;
            end
            if (cal == 0)
                L = bitshift(i,5);
                H = j;
                w_map(i,j) = uint16(((1 - w(i,j)) * L) + w(i,j) * H);
            end
        end
        if(mod(i,output_step) == 0)
            fprintf('%d%%\n',uint8(i * 100 / Lmax));
        end
    end
    save(str,'w','w_map');
    fprintf('\n');
else
    load(str);
end
IL = bitshift(IL,-5);
IH = bitshift(IH,-5);

height = size(IL,1);
width = size(IL,2);

I_ans = uint16(zeros(height,width));

for i = 1:height
    for j = 1:width
        I_ans(i,j) = w_map(IL(i,j) + 1,IH(i,j) + 1);
    end
end

end

