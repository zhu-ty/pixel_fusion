function [I] = useage_row(I)

load('DSNU_ROW_30_2-use-.mat');
load('DSNU_ROW_30_1_p1p2-use-.mat');

PIC_MAX_ROW = 2160;
PIC_MAX_COL = 2560;
thr = 4000;

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