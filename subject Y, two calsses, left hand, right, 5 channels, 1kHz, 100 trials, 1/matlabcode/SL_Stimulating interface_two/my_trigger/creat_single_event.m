function creat_single_event(comName,event_name)
% creat single event for EEG data
% Author: Shuailei Zhang, Beihang University
%
% Versions:
%    v1.0: 2018-07-07
%
% Copyright  2018, Advanced Sensing Technology Laboratory, Beihang University, All Rights Reserved. 
%
% comName:      name of com, you may find it in device manager after trigger box has been accessed
% event_name:   event name you want to generate��[00 FF]
%               attention: this is a hex code, if you give a value of '10', the event name will be
%               '16'
%
%example:       creat_single_event('com3','03')
%               trigger box is connecting to com3,and you 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin<1 || nargin>2
    disp('���������������');
    return;
end
scom = serial(comName);
scom.BaudRate = 115200;
fopen(scom);
str1 = ('01 E1 01 00');
str = strcat(str1,32,event_name);
    n = find(str == ' ');   %���ҿո�
    n =[0 n length(str)+1]; %�ո������ֵ
    % ÿ�������ڿո�֮����ַ���Ϊ��ֵ��ʮ��������ʽ������ת��Ϊ��ֵ
    for i = 1 : length(n)-1 
        temp = str(n(i)+1 : n(i+1)-1);  %���ÿ�����ݵĳ��ȣ�Ϊ����ת��Ϊʮ������׼��
        if ~rem(length(temp), 2)
            b{i} = reshape(temp, 2, [])'; %��ÿ��ʮ�������ַ���ת��Ϊ��Ԫ����
        else
            break;
        end
    end
    val = hex2dec(b)';     %��ʮ�������ַ���ת��Ϊʮ���������ȴ�д�봮��
fwrite(scom, val, 'uint8', 'async'); %����д�봮��
pause(0.05)%��ʱ����ָ���ȥ�����ָ���������Ҫ����ʱ��

% STOPASYNC
% stopasync(scom)
fclose(scom)
delete(scom)
clear scom
end