%clear;
%load('w_2000_1700.mat');
close all;
%load('hl16.mat');
high11 = bin2dec('1111 1111 1110 0000');
Il = imread('3LB.tif');
Il = bitand(Il,high11);
%Il格式"1111 1111 1110 0000"

Ih = imread('3HB.tif');
Ih = bitshift(Ih,-5);
%Ih格式"0000 0111 1111 1111"

full   = bin2dec('111 1111 1111');
maskH6 = bin2dec('111 1110 0000');
maskL6 = bin2dec('000 0011 1111');

%Il_t2 = bitshift(Il,-5);
Il_t2 = uint16(double(Il) / 32);
Il_t2 = Il_t2 - (Il_t2 - 2047);

%Il有可能大于11位？？？
high = bitshift(bitand(Il_t2,bitxor(maskL6,full)),5);

IH_MAX = uint16(2^11 - 1);
IL_MAX = uint16(2^16 - 1);

%黑科技得w_use

Ilp1 = Il+1;
Ihp1 = Ih+1;
w_use = zeros(size(Il,1),size(Il,2));
for i = 1:size(Il,1)
    for j = 1:size(Il,2)
    w_use(i,j) = w(Ilp1(i,j),Ihp1(i,j));
    end
    if(mod(i,300) == 0)
        fprintf('%d\n',i);
    end
end
%w_use = w(Ilp1(:,:),Ihp1(:,:));

avl = double(bitand(Il_t2,maskL6));
avh = double(bitshift(bitand(Ih,maskH6),-5));
av = uint16(uint16((1 - w_use) .* avl) + uint16(w_use .* avh));
av = bitand(av,maskL6);
av = bitshift(av,5);

low = bitand(Ih,bitxor(maskH6,full));

I16_ans = bitor(bitor(high,av),low);



% 单行处理 
% I16_ans = zeros(2160,2560);
% 
% %for i = 1:2160
% i = 1400;
%     for j = 1:2560
%         I16_ans(i,j) = pixel_mix(Il(i,j),Ih(i,j));
%     end
%     if(mod(i,300) == 0)
%         printf('%d\n',i);
%     end
% %end

G = fspecial('gaussian', [9 9], 2);
I16_ans_gauss = imfilter(I16_ans,G,'same');
% figure('name','I16_old');
% imshow(I16);

imwrite(I16_ans,'拼接.tif');imwrite(I16_ans_gauss,'拼接9x9高斯模糊.tif');

if(0)
    figure('name','I16_new');
    imshow(I16_ans);
    figure('name','I16_gauss');
    imshow(I16_ans_gauss);
    figure('name','I_low');
    imshow(Il);
    
end

%回到最初的问题……什么样算好？
if(0)
    close all;
%     line1 = I16(1400,:);
    line2 = I16_ans(1400,:);
    line3 = I16_ans_gauss(1400,:);
    line4 = Il(1400,:);
    line5 = Ih(1400,:);

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