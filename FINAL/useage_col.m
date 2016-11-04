function [I] = useage_col(I)

load('DSNU_31_2_robust-use-.mat');

PIC_MAX_ROW = 2160;
PIC_MAX_COL = 2560;

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