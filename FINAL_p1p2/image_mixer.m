function [I_ans] = image_mixer(IL, IH, thL_, thH_, pow_c, undefine_c, output_step, Hmax_, Lmax_, mul)
%IMAGE_MIXER 混合IH与IL，两者有效位数均为高11位
%   Hmax和thH均对高11位生效(0-2048-65535)
%   Lmax和thL均对高11位生效(0-2048-65535)
%   但是IH与IL均为高11位生效(0-2048-65535)
%   请注意区分
% 推荐值：
% thL_ = 2000;
% thH_ = 51200;
% pow_c = 0.2;
% undefine_c = 0.5;
% output_step = 500;
% Hmax_ = 65535;
% Lmax_ = 65535;
% mul = 30(取决于两个增益差距）

thH = bitshift(thH_,-5);
thL = bitshift(thL_,-5);
Hmax = bitshift(Hmax_,-5);
Lmax = bitshift(Lmax_,-5);
already_have = 0;
str = ['w_map_',int2str(thL_),'_',int2str(thH_),'_',num2str(pow_c),...
    '_',num2str(undefine_c),'_',num2str(mul),'.mat'];
if(exist(str,'file'))
    already_have = 1;
end
if(~already_have)
    L_range = Lmax + 1 - thL;
    H_range = thH;
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
                w_map(i,j) = i * mul;
                cal = 1;
            elseif(i >= thL && j <= thH)
                tmp1 = ((Lmax+1 - i) / L_range);
                tmp2 = ((thH - j)/thH);
                %tmp1 = round(tmp1,2);
                %tmp2 = round(tmp2,2); 
                w(i,j) = (tmp1 * tmp2) ^ pow_c;
                %w(i,j) = round(w(i,j),2);
            else
                w(i,j) = undefine_c;
            end
            if (cal == 0)
                L = i * mul;
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

