close all;
clear;
str = 'L3_H3_mix.tif';
%str = 'L_H_mix.tif';
I = imread(str);
K1=imfilter(I,fspecial('average',[3 3]),'same');
imwrite(K1,['avg3_',str]);
K1=imfilter(I,fspecial('gaussian',[3 3],2),'same');
%imwrite(K1,['gau3_',str]);
K1=imfilter(I,fspecial('gaussian',[3 3],0.6),'same');
%imwrite(K1,['gau30.6_',str]);