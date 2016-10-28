function [ path ] = make_dir_with_time(elder_dir_str)
%MAKE_DIRWITH_TIME 此处显示有关此函数的摘要
%   此处显示详细说明

clock_array = clock;
if(clock_array(2) < 10)
    str_month = ['0',int2str(clock_array(2))];
else
    str_month = int2str(clock_array(2));
end
if(clock_array(3) < 10)
    str_day = ['0',int2str(clock_array(3))];
else
    str_day = int2str(clock_array(3));
end

if(clock_array(4) < 10)
    str_hour = ['0',int2str(clock_array(4))];
else
    str_hour = int2str(clock_array(4));
end
if(clock_array(5) < 10)
    str_minute = ['0',int2str(clock_array(5))];
else
    str_minute = int2str(clock_array(5));
end
if(clock_array(6) < 10)
    str_second = ['0',int2str(clock_array(6))];
else
    str_second = int2str(clock_array(6));
end

str_f = [int2str(clock_array(1)),str_month,str_day,'_' ...
       str_hour,str_minute,str_second];
path = [elder_dir_str,'/',str_f];

mkdir(path);
end

