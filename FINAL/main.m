close all;
clear;


% strL = ['1LB';'3LB';'4LS'];
% strH = ['1HB';'3HB';'4HS'];
% thL_ = [2000:200:2200];
% thH_ = [1400:100:1700];
% pow_c = [0.15:0.05:0.25];

strL = {'L3'};
strH = {'H3'};
thL_ = [2000];
thH_ = [63000];
pow_c = [0.2];
undefine_area = 0.5;
mul = 29.5;
%ÍÆ¼ö²ÎÊý£º2000_51200/54400/63000_0.2_0.5/28

input_folder = 'input';
output_folder = 'output';
Hmax_ = 65535;
Lmax_ = 65535;
op_step = 500;
s_strL = size(strL,2);
s_thL_ = size(thL_,2);
s_thH_ = size(thH_,2);
s_pow_c = size(pow_c,2);

path = make_dir_with_time(output_folder);

PIC_MAX_ROW = 2160;
PIC_MAX_COL = 2560;

ILs = zeros(PIC_MAX_ROW, PIC_MAX_COL, s_strL);
IHs = zeros(PIC_MAX_ROW, PIC_MAX_COL, s_strL);

for i = 1:s_strL
    ILs(:,:,i) = imread([input_folder,'/',strL{i},'.tif']);
    IHs(:,:,i) = imread([input_folder,'/',strH{i},'.tif']);
end
count = 1;
for i = 1:s_thL_
    for j = 1:s_thH_
        for k = 1:s_pow_c
            str_list = [num2str(count),'_'...
                num2str(thL_(i)),'_'...
                num2str(thH_(j)),'_'...
                num2str(pow_c(k)),'_'...
                num2str(mul),'_'...
                num2str(undefine_area)];
            count = count + 1;
            str_new_path = [path,'/',str_list];
            mkdir(str_new_path);
            for l=1:s_strL
                IL = ILs(:,:,l);
                IH = IHs(:,:,l);
                
                IL = useage_col(IL);
                IL = useage_row(IL);
                
                I_ans = image_mixer(IL,IH,thL_(i),thH_(j),...
                    pow_c(k),undefine_area,op_step,Hmax_,Lmax_,mul);
                imwrite(I_ans,[str_new_path,'/',strL{l},'_',strH{l},'_','mix.tif']);
            end
        end
    end
end