clear;
close all;

load('DSNU_31_2_robust.mat');

pics = {...
    'black(1).tif','black(2).tif','black(3).tif'...
    ,'(1).tif','(2).tif','(3).tif','(4).tif','(5).tif'...
    ,'(6).tif','(7).tif','(8).tif','(9).tif','(10).tif'...
    ,'(11).tif','(12).tif','(13).tif','(14).tif','(15).tif'...
    ,'(16).tif','(17).tif','(18).tif','(19).tif','(20).tif'...
    ,'light(1).tif','light(2).tif','light(3).tif','light(4).tif','light(5).tif','light(6).tif'...    
    };
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
        if(exist('aa','var'))
            a_ = aa(1, j);
            b_ = a(1, j);
            c_ = double(I_ptu(:, j)) - (b1(1, j) + b2 + b3(1, j));
            I_ptux(:,j) = uint16((-b_ + sqrt(b_^2 + 4 * a_ * c_)) / (2 * a_));

            a_ = aa(2, j);
            b_ = a(2, j);
            c_ = double(I_ptd(:, j)) - (b1(2, j) + b2 + b3(2, j));
            I_ptdx(:,j) = uint16((-b_ + sqrt(b_^2 + 4 * a_ * c_)) / (2 * a_));
        else
            I_ptux(:, j) = uint16((double(I_ptu(:, j)) - b1(1, j) - b2 - b3(1, j)) / a(1, j));
            I_ptdx(:, j) = uint16((double(I_ptd(:, j)) - b1(2, j) - b2 - b3(2, j)) / a(2, j));
        end
    end
    I(1 : PIC_MAX_ROW / 2, :) = I_ptux(:, :);
    I(PIC_MAX_ROW / 2 + 1 : end, :) = I_ptdx(:, :);
    imwrite(I, ['p/', pics{i}]);
end