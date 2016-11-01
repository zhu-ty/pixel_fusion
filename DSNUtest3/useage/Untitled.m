abin = bin2dec('1111 1111 0000 0000');
I = imread('p_L2.tif');
Ihh = bitand(I,abin);
imwrite(Ihh,'Ihh.tif');