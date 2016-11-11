close all;
clear;

data = 'DSNU_ROW_30_1_p1p2-use-.mat';
xls = 'ROW_more_4096.csv';
PIC_MAX_ROW = 2160;
PIC_MAX_COL = 2560;

load(data);


if(~exist('a2','var'))
    op = cell(PIC_MAX_ROW, 2);
    b = bitshift(uint16(round((b1 + b3 + b2 + 256) ./ a)),-5);

    for i = 1:PIC_MAX_ROW
        tmp = dec2hex(bin2dec(num2str(float2bits(1/a(i),16))));
        op(i,1) = {tmp};
        op(i,2) = {dec2hex(b(i,1))};
    end
else
    op = cell(PIC_MAX_ROW, 2);
    b = bitshift(uint16(round((b12 + b32 + b22 + 256) ./ a2)),-5);

    for i = 1:PIC_MAX_ROW
        tmp = dec2hex(bin2dec(num2str(float2bits(1/a2(i),16))));
        op(i,1) = {tmp};
        op(i,2) = {dec2hex(b(i,1))};
    end 
end



fp = fopen(xls,'wt');
for i = 1:size(op,1)
    for j = 1:size(op,2)
        fprintf(fp,'%s,',['0x',op{i,j}]);
    end
    fprintf(fp,'\n');
end
fclose(fp);