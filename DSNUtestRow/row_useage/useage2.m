clear;
close all;

load('DSNU_ROW_30_2.mat');
load('DSNU_ROW_30_1_p1p2.mat');
thr = 3000;

pics = {'(1).tif','(2).tif','p_31_2_robust_L2.tif'};
npics = size(pics, 2);

PIC_MAX_ROW = 2160;
PIC_MAX_COL = 2560;

for i = 1 : npics
    I = imread(pics{i});
    I_x = double(I);
    for j = 1 : PIC_MAX_ROW
        for k = 1:PIC_MAX_COL
            if(I(j,k) < thr)
                I_x(j,k) = uint16((double(I(j, k)) - b1(j, 1) - b2 - b3(j, 1)) / a(j, 1));
            else
                I_x(j,k) = uint16((double(I(j, k)) - b12(j, 1) - b22 - b32(j, 1)) / a2(j, 1));
            end
        end
    end
    I = uint16(I_x);
    imwrite(I, ['p_row_30_2_p1p2_3000_', pics{i}]);
end