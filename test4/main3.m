clear;
close all;


strL = '1LB';
strH = '1HB';
strmap = '2000_1600_0.2_0.5';
output_folder = 'output';
gauss_diameter = 3;








if ~exist(output_folder,'dir') 
    mkdir(output_folder)         % 若不存在，在当前目录中产生一个子目录‘Figure’
end 

load(['w_map_',strmap,'.mat']);

IL = imread([strL,'.tif']);
IL = bitshift(IL,-5);

IH = imread([strH,'.tif']);
IH = bitshift(IH,-5);

height = size(IL,1);
width = size(IL,2);

I_ans = uint16(zeros(height,width));

for i = 1:height
    for j = 1:width
        I_ans(i,j) = w_map(IL(i,j) + 1,IH(i,j) + 1);
    end
end

G = fspecial('gaussian', [gauss_diameter, gauss_diameter], 2);
I_ans_gauss = imfilter(I_ans,G,'same');

clock_array = clock;
if(clock_array(2) < 10)
    str_month = ['0',int2str(clock_array(2))];
else
    str_month = int2str(clock_array(2));
end
if(clock_array(3) < 10)
    str_day = ['0',int2str(clock_array(3))];
else
    str_day = int2str(clock_array(3));
end

if(clock_array(4) < 10)
    str_hour = ['0',int2str(clock_array(4))];
else
    str_hour = int2str(clock_array(4));
end
if(clock_array(5) < 10)
    str_minute = ['0',int2str(clock_array(5))];
else
    str_minute = int2str(clock_array(5));
end
if(clock_array(6) < 10)
    str_second = ['0',int2str(clock_array(6))];
else
    str_second = int2str(clock_array(6));
end

str_f = [int2str(clock_array(1)),str_month,str_day,'_' ...
       str_hour,str_minute,str_second,'_' ...
       strL,'_',strH,'_',strmap];
mkdir([output_folder,'/',str_f]);

imwrite(I_ans,[output_folder,'/',str_f,'/','mix.tif']);
imwrite(I_ans_gauss,[output_folder,'/',str_f,'/','mix',...
    '_Gauss',int2str(gauss_diameter),'x',int2str(gauss_diameter),'.tif']);


if(0)
    figure('name','I16_new');
    imshow(I_ans);
    figure('name','I16_gauss');
    imshow(I_ans_gauss);
    figure('name','I_low');
    imshow(IL);
end

%回到最初的问题……什么样算好？
if(0)
    close all;
%     line1 = I16(1400,:);
    line2 = I_ans(1400,:);
    line3 = I_ans_gauss(1400,:);
    line4 = IL(1400,:);
    line5 = IH(1400,:);

%     figure('name','I16_old');
%     plot(line1);
    figure('name','I16_gauss');
    plot(line3);
    figure('name','I_low');
    plot(line4);
    figure('name','I_high');
    plot(line5);
    figure('name','I16_new');
    plot(line2);
end

