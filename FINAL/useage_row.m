function [I] = useage_row(I)

load('DSNU_ROW_30_2.mat');

PIC_MAX_ROW = 2160;
PIC_MAX_COL = 2560;

I_x = double(I);
for j = 1 : PIC_MAX_ROW
    if(exist('aa','var'))
        a_ = aa(j, 1);
        b_ = a(j, 1);
        c_ = I_x(j, :) - (b1(j, 1) + b2 + b3(j, 1));
        I_x(j, :) = uint16((-b_ + sqrt(b_^2 + 4 * a_ * c_)) / (2 * a_));
    else
        I_x(j, :) = uint16((double(I(j, :)) - b1(j, 1) - b2 - b3(j, 1)) / a(j, 1));
    end
end
I = uint16(I_x);