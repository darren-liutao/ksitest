@echo off
CHCP 65001
mode con cols=50 lines=20
title=swreboot
color 07
echo.
echo -----------------------------------------------
echo           Kingston Test Tool For Internal
echo -----------------------------------------------
echo              Software Reboot Test Tool
echo -----------------------------------------------
echo.

:set
echo -----------------------------------------------
set /a a=0
set /a scale=10                                    %设置默认测试次数为10000%
set /p scale=input test cycles,default=10(unit:k):%输入测试次数,单位是千%
set /a cycles=%scale%*1000
set /a boottime=60                                 %设置默认启动时间为60秒%
set /p boottime=input bootup time(unit:s):%输入启动时间，单位秒%


echo.
echo.
cls
color F0
echo -----------------------------------------------
echo            This Is SW reboot Test!
echo             Please Check Setting!
echo -----------------------------------------------
echo              Test cycles=%cycles%
echo              boot time=%boottime%s
echo -----------------------------------------------
pause
color 4E
echo.
echo -----------------------------------------------
echo Input "1|2|9" to Next Action:
echo -----------------------------------------------
echo 1.Start test
echo 2.Reset setting
echo 9.Exit
echo -----------------------------------------------
echo.

:cho
choice /c 129 /m "Please input 1|2|9"
if /i %errorlevel%==1 goto swreboot
if /i %errorlevel%==2 goto set
if /i %errorlevel%==3 goto exit

:swreboot
cls
color AF
set /a a=a+1
set /a left=%cycles%-%a%
echo -----------------------------------------------
echo             The %a%th SWreboot test!
echo -----------------------------------------------
echo            We have %left% tests left!
echo -----------------------------------------------
echo cycles^=^%a%>>record.txt          %记录测试次数到本地文件，防止测试电脑重启%
if %a% == %cycles% goto finish
adb wait-for-device
adb shell reboot                       %发送重启命令%
timeout /T %boottime% /NOBREAK         %等待机器开机%
goto swreboot

:finish
color AF
echo Test finished,Please check test cycles and platform!>>record.txt
echo You set test cycles=%cycles%!>>record.txt
echo Test finished,Please delete this file!>>record.txt
echo Test finished,Please delete this file!>>record.txt
echo Test finished,Please delete this file!>>record.txt
record.txt                                                       %自动打开次数记录文件，以便检查%
del record.txt                                                   %检查完毕后自动删除次数记录文件，方便下一次记录%

:exit

