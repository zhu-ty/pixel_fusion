close all;
clear;

data = 'DSNU_31_p1p2_robust-use-.mat';
%xls = 'data.xlsx';
PIC_MAX_ROW = 2160;
PIC_MAX_COL = 2560;

load(data);

op = cell(PIC_MAX_COL, 4);
b = bitshift(uint16(round((b12 + b32 + b22 - 8192) ./ a2)),-5);

for i = 1:PIC_MAX_COL
    tmp = dec2hex(bin2dec(num2str(float2bits(1/a2(1,i),16))));
    op(i,1) = {tmp};
    tmp = dec2hex(bin2dec(num2str(float2bits(1/a2(2,i),16))));
    op(i,2) = {tmp};
    op(i,3) = {dec2hex(b(1,i))};
    op(i,4) = {dec2hex(b(2,i))};
end


fp = fopen('c.csv','wt');
for i = 1:size(op,1)
    for j = 1:size(op,2)
        fprintf(fp,'%s,',['0x',op{i,j}]);
    end
    fprintf(fp,'\n');
end
fclose(fp);
%xlswrite(xls,op,'sheet1','A2:B2561');