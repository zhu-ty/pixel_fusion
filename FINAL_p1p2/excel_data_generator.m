close all;
clear;

data = 'DSNU_31_2_robust-use-.mat';
xls = 'd.csv';
PIC_MAX_ROW = 2160;
PIC_MAX_COL = 2560;

load(data);




if(~exist('a2','var'))
    if(size(a,1) > 100)
        turn = PIC_MAX_ROW;
    else
        turn = PIC_MAX_COL;
    end
    op = cell(turn, 4);
    b = bitshift(uint16(round((b1 + b3 + b2 - 8192) ./ a)),-5);

    for i = 1:PIC_MAX_COL
        tmp = dec2hex(bin2dec(num2str(float2bits(1/a(1,i),16))));
        op(i,1) = {tmp};
        tmp = dec2hex(bin2dec(num2str(float2bits(1/a(2,i),16))));
        op(i,2) = {tmp};
        op(i,3) = {dec2hex(b(1,i))};
        op(i,4) = {dec2hex(b(2,i))};
    end 
else
    if(size(a2,1) > 100)
        turn = PIC_MAX_ROW;
    else
        turn = PIC_MAX_COL;
    end
    op = cell(turn, 4);
    b = bitshift(uint16(round((b12 + b32 + b22 - 8192) ./ a2)),-5);

    for i = 1:PIC_MAX_COL
        tmp = dec2hex(bin2dec(num2str(float2bits(1/a2(1,i),16))));
        op(i,1) = {tmp};
        tmp = dec2hex(bin2dec(num2str(float2bits(1/a2(2,i),16))));
        op(i,2) = {tmp};
        op(i,3) = {dec2hex(b(1,i))};
        op(i,4) = {dec2hex(b(2,i))};
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
%xlswrite(xls,op,'sheet1','A2:B2561');