clear;
close all;
load('hl16.mat');

full   = bin2dec('111 1111 1111');
maskH6 = bin2dec('111 1110 0000');
maskL6 = bin2dec('000 0011 1111');

%剔除Ih的干扰：原则A：Ih达到1700，原则B：Il很大（初步认为大于50000）
thL = 50000;
thH = 1700;

%Iht = Ih - 2^11;
%Ih = Ih - Iht;

% G2 = fspecial('gaussian', [9 9], 2);
% Ih = imfilter(Ih,G2,'same');

%Il_t2 = bitshift(Il,-5);
Il_t2 = uint16(double(Il) / 32);
Il_t2 = Il_t2 - (Il_t2 - 2047);

%Il有可能大于11位？？？
high = bitshift(bitand(Il_t2,bitxor(maskL6,full)),5);

%计算低亮的自适应比例
Il_less_thL = double(Il - (Il - thL));
Ih_less_thH = double(Ih - (Ih - thH));
%w为Ih占比
%目前考虑用上凸型曲线
%!!!!!!!!!!!!!!!!
w = ((Il_less_thL - thL) / thL) .* ((Ih_less_thH - thH) / thH);
w = w.^0.15;

avl = double(bitand(Il_t2,maskL6));
avh = double(bitshift(bitand(Ih,maskH6),-5));
av = uint16((1 - w) .* avl + w .* avh);
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
figure('name','I16_old');
imshow(I16);
figure('name','I16_new');
imshow(I16_ans);
figure('name','I16_gauss');
imshow(I16_ans_gauss);
figure('name','I_low');
imshow(Il);


%回到最初的问题……什么样算好？
if(1)
    close all;
    line1 = I16(1400,:);
    line2 = I16_ans(1400,:);
    line3 = I16_ans_gauss(1400,:);
    line4 = Il(1400,:);
    line5 = Ih(1400,:);

    figure('name','I16_old');
    plot(line1);
    figure('name','I16_gauss');
    plot(line3);
    figure('name','I_low');
    plot(line4);
    figure('name','I_high');
    plot(line5);
    figure('name','I16_new');
    plot(line2);
end