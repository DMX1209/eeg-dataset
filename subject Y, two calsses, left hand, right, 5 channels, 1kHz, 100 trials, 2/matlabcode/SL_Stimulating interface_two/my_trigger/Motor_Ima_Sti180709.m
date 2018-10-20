function Motor_Ima_Sti180709()
%% Clear workspace
clc
clear
close all
% Turn on sync check
Screen('Preference', 'SkipSyncTests', 1);
 try 
         %% initialization
        ListenChar(2);%Shielded key input 
        HideCursor; 
        KbName('UnifyKeyNames');
        escKey = KbName('ESCAPE');
        %     SpaceKey=KbName('space');
        myScreen = max(Screen('Screens'));
        [w,h] = WindowSize(myScreen); 
        [wPtr,winRect] = Screen(myScreen,'OpenWindow',[0 0 0]);    
        %     Hz=Screen('FrameRate',wPtr);
        %     [x,y]=WindowCenter(wPtr);
        LS_photo = imread('LS.png');
        LN_photo = imread('LN.png');
        RS_photo = imread('RS.png');
        RN_photo = imread('RN.png');
        LS_photo_ptr = Screen('MakeTexture', wPtr, LS_photo);
        LN_photo_ptr = Screen('MakeTexture', wPtr, LN_photo);
        RS_photo_ptr = Screen('MakeTexture', wPtr, RS_photo);
        RN_photo_ptr = Screen('MakeTexture', wPtr, RN_photo);

%         %1-LS  2-LN 3-RS 4-RN(左L 右R 顺S 逆N)
            rand_a=[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ...
                    2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 ...
                    3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 ...
                    4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4];
%         rand_a=[1 2 3 4]; 
        num_a=length(rand_a);
        rand_num=Shuffle(rand_a);%%Random arrangement
        trail_num=1;
        com='com3';

         %% Prompt
        text = {'Please rest','Please get','prepared for','task','Begin','Finished'};
        Screen('TextSize', wPtr, 90);
        Screen('TextFont', wPtr, 'Arial');
        
        DrawFormattedText(wPtr,'Please Click SpaceKey', 'center', 'center', 255);
        Screen(wPtr,'Flip');
        KbPressWait;
        
        while trail_num<=num_a
            [ ~,~, keyCode ] = KbCheck;
            if keyCode(escKey)
                break;
            else
                % Please rest
                DrawFormattedText(wPtr, text{1}, 'center', 'center', 255);
                Screen(wPtr,'Flip');
                WaitSecs(2);

                % Please get prepared for task
                DrawFormattedText(wPtr, text{2}, 'center', 0.5*h-135, 255);
                DrawFormattedText(wPtr, text{3}, 'center', 0.5*h, 255);
                DrawFormattedText(wPtr, text{4}, 'center', 0.5*h+135, 255);
                Screen(wPtr,'Flip');
                WaitSecs(3);

                %Begin
                DrawFormattedText(wPtr, text{5}, 'center', 'center', 255);
                Screen(wPtr,'Flip');
                WaitSecs(0.5);
                if(rand_num(trail_num)==1)
                    TF=1;
                    creat_single_event(com,'01');
                else if(rand_num(trail_num)==2)
                        TF=2;
                        creat_single_event(com,'02');
                    else if(rand_num(trail_num)==3)
                            TF=3;
                            creat_single_event(com,'03');
                        else 
                            TF=4;
                            creat_single_event(com,'04');
                        end
                    end
                end

                if(TF==1)
                    Screen('DrawTexture', wPtr, LS_photo_ptr, [], [0.1*w,0.25*h,0.5*w,0.75*h], 0, [], [],[255 255 255]);
                    Screen(wPtr,'Flip');
                    WaitSecs(6);
                else if(TF==2)
                        Screen('DrawTexture', wPtr, LN_photo_ptr, [], [0.1*w,0.25*h,0.5*w,0.75*h], 0, [], [],[255 255 255]);
                        Screen(wPtr,'Flip');
                        WaitSecs(6);
                    else if(TF==3)
                            Screen('DrawTexture', wPtr, RS_photo_ptr, [], [0.5*w,0.25*h,0.9*w,0.75*h], 0, [], [],[255 255 255]);
                            Screen(wPtr,'Flip');
                            WaitSecs(6);
                        else
                            Screen('DrawTexture', wPtr, RN_photo_ptr, [], [0.5*w,0.25*h,0.9*w,0.75*h], 0, [], [],[255 255 255]);
                            Screen(wPtr,'Flip');
                            WaitSecs(6);
                        end
                    end
                end

                %Finished
                DrawFormattedText(wPtr, text{6} , 'center', 'center', 255);
                Screen(wPtr,'Flip');
                trail_num=trail_num+1;
                WaitSecs(1);
            end
        end

        ListenChar(0);%%Restore key input
        Screen('CloseAll');   
        Screen('Close');
        ShowCursor; 
catch 
        ListenChar(0);%%Restore key input
        Screen('CloseAll');
        Screen('Close');
        ShowCursor;
        psychrethrow(psychlasterror);
end
end

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
    % event_name:   event name you want to generate，[00 FF]
    %               attention: this is a hex code, if you give a value of '10', the event name will be
    %               '16'
    %
    %example:       creat_single_event('com3','03')
    %               trigger box is connecting to com3,and you 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if nargin<1 || nargin>2
        disp('输入参数个数有误');
        return;
    end
    scom = serial(comName);
    scom.BaudRate = 115200;
    fopen(scom);
    str1 = ('01 E1 01 00');
    str = strcat(str1,32,event_name);
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
    fclose(scom);
    delete(scom);
    clear scom;
end