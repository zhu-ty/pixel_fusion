clear;
close all;

I = imread('7L_7H_mix.tif');
%1346,700,
%1575,1003,

part = I(1346:1575,700:1003);
imwrite(part,'part.tif');
% I_fft = fftshift(fft2(part));
% 
% %I_show = (abs(I_fft)-min(min(abs(I_fft))))/(max(max(abs(I_fft)))-min(min(abs(I_fft))))*255;
% %figure(1);
% %imshow(I_show);
% 
% for i = 1:50
%    I_fft(:,i) = 0;
%    I_fft(i,:) = 0;
% end
% 
% for i = 254:304
%    I_fft(:,i) = 0;
%    I_fft(i,:) = 0;
% end
% % I_show = (abs(I_fft)-min(min(abs(I_fft))))/(max(max(abs(I_fft)))-min(min(abs(I_fft))))*255;
% % figure(1);
% % imshow(I_show);
% 
% I_fft_f = uint16(abs(ifft2(I_fft)));
% 
% imwrite(I_fft_f,'part_fft.tif');
% 
% % col_ = I(:,1470);
% % plot(col_);
% % col2 = col_(600:1000);
% % a = abs(fft(col2));
% % plot(col2);
% % figure(2);
% % plot(a);
% %频谱特性一般……有待继续尝试
% 
% close all;
% dia = 5;
% G = fspecial('gaussian', [dia, dia], 2);
% G1 = G;
% for i = 1:dia
%     G1(i,:) = G(round(dia/2),:);
% end
% G1 = G1 ./ (sum(sum(G1)));
% %I_ans_gauss = imfilter(I_ans,G,'same');
% I2 = imfilter(I,G1,'same');
% imwrite(I2,'i2.tif');



% close all;
% dia = 5;
% G1 = ones(dia,dia);
% 
% G1 = G1 ./ (sum(sum(G1)));
% %I_ans_gauss = imfilter(I_ans,G,'same');
% I2 = imfilter(I,G1,'same');
% imwrite(I2,'i2.tif');]

close all;
dia = 7;
G1 = zeros(dia,dia);

G1((dia - 1) /2 + 1,:) = 1;
G1(:,2:4) = 1;

G1 = G1 ./ (sum(sum(G1)));
%I_ans_gauss = imfilter(I_ans,G,'same');
I2 = imfilter(I,G1,'same');
imwrite(I2,'i23.tif');