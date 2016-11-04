clear;
close all;

load('DSNU_51.mat');

pics = {'(1).tif','(2).tif','(3).tif','(4).tif','(5).tif','L2.tif'};
npics = size(pics, 2);

PIC_MAX_ROW = 2160;
PIC_MAX_COL = 2560;

for i = 1 : npics
    I = imread(pics{i});
    I_ptu = I(1 : PIC_MAX_ROW / 2, :);
    I_ptux = I_ptu;
    I_ptd = I(PIC_MAX_ROW / 2 + 1 : end, :);
    I_ptdx = I_ptd;
    for j = 1 : PIC_MAX_COL
        I_ptux(:, j) = uint16((double(I_ptu(:, j)) - b1(1, j) - b2 - b3(1, j)) / a(1, j));
        I_ptdx(:, j) = uint16((double(I_ptd(:, j)) - b1(2, j) - b2 - b3(2, j)) / a(2, j));
    end
    I(1 : PIC_MAX_ROW / 2, :) = I_ptux(:, :);
    I(PIC_MAX_ROW / 2 + 1 : end, :) = I_ptdx(:, :);
    imwrite(I, ['p_', pics{i}]);
end