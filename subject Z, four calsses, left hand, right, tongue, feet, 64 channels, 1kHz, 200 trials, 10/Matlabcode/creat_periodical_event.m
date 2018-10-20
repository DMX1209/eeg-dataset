function creat_periodical_event(comName,event_name,time_interval)
% creat periodical event for EEG data
% Author: Shuailei Zhang, Beihang University
%
% Versions:
%    v1.0: 2018-07-07
%
% Copyright  2018, Advanced Sensing Technology Laboratory, Beihang University, All Rights Reserved. 
%
% comName:      name of com, you may find it in device manager after trigger box has been accessed
% event_name:   event name you want to generate，[00 FF]
%               attention: this is a hex code, if you give a value of '10', the event name will be
%               '16'
%time_interval: time interval to create a event target, unit:ms,[0 FFFF]
%example:       creat_periodical_event('com3','08',3000)
%               trigger box is connecting to com3,and one target('08') per 3000ms

%attention:	once the event target open periodical generation, 
%		it can be interrept by other operation but will 
%		not stop until trigger box was shut down.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin<1 || nargin>3
    disp('输入参数个数有误');
    return;
end
time_interval = dec2hex(time_interval);%十进制转化为十六进制
switch (length(time_interval))    
    case 2
        time_interval = strcat(time_interval(1),time_interval(2),32,0,0)
    case 3
        time_interval = strcat('0',time_interval);
        time_interval = strcat(time_interval(3),time_interval(4),32,time_interval(1),time_interval(2));
    case 4
        time_interval = strcat(time_interval(3),time_interval(4),32,time_interval(1),time_interval(2));
end
    
scom = serial(comName);
scom.BaudRate = 115200;
fopen(scom);
str1 = ('01 E7 04 00 01');
str = strcat(str1,32,event_name,time_interval);
    n = find(str == ' ');   %查找空格
    n =[0 n length(str)+1]; %空格的索引值
    % 每两个相邻空格之间的字符串为数值的十六进制形式，将其转化为数值
    for i = 1 : length(n)-1 
        temp = str(n(i)+1 : n(i+1)-1);  %获得每段数据的长度，为数据转换为十进制做准备
        if ~rem(length(temp), 2)
            b{i} = reshape(temp, 2, [])'; %将每段十六进制字符串转化为单元数组
        else
            break;
        end
    end
    val = hex2dec(b)';     %将十六进制字符串转化为十进制数，等待写入串口
fwrite(scom, val, 'uint8', 'async'); %数据写入串口
pause(0.05)%延时，将指令发出去，如果指令过长还需要增加时间

% STOPASYNC
% stopasync(scom)
fclose(scom)
delete(scom)
clear scom