@echo off
CHCP 65001
mode con cols=50 lines=20
title=sleepawake
echo.
echo -----------------------------------------------
echo           Kingston Test Tool For Internal
echo -----------------------------------------------
echo                Sleep/Awake Test Tool
echo -----------------------------------------------
echo.


:set
color 07
echo -----------------------------------------------
set /a a=0
set /a scale=10                                    %设置默认测试次数为10000%
set /p scale=Input test cycles,default=10(unit:k):%输入测试次数,单位是千%
set /a cycles=%scale%*1000
set /a sleeptime=15                                  %设置默认唤醒时间5秒%
set /p sleeptime=Input sleep time,default=15(unit:s):%输入休眠时间，单位秒%
set /a awaketime=15                                  %设置默认休眠时间5秒%
set /p awaketime=Input awake time,default=15(unit:s):%输入唤醒时间，单位秒%

echo.
echo.
cls
color F0
echo -----------------------------------------------
echo            This Is Sleep/Awake Test!
echo             Please Check Setting!
echo -----------------------------------------------
echo              Test cycles=%cycles%
echo              Sleep time=%sleeptime%s
echo              Awake time=%awaketime%s
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
if /i %errorlevel%==1 goto sleepawake
if /i %errorlevel%==2 goto set
if /i %errorlevel%==3 goto exit

:sleepawake
cls
color FA
set /a a=a+1
set /a left=%cycles%-%a%
echo -----------------------------------------------
echo            The %a%th Sleep/Awake test!
echo -----------------------------------------------
echo            We have %left% tests left!
echo -----------------------------------------------
echo cycles^=^%a%>>record.txt            %记录测试次数到本地文件，防止测试电脑重启%
if %a% == %cycles% goto finish
adb wait-for-device
adb shell input keyevent 26              %模拟点击平台电源键，唤醒平台%
echo.
echo -----------------------------------------------
echo                   Awakening
echo -----------------------------------------------
timeout /T %sleeptime% /NOBREAK          %平台唤醒的时间%
adb shell input keyevent 26              %模拟点击平台电源键，休眠平台%
color 0A
echo -----------------------------------------------
echo                   Sleeping
echo -----------------------------------------------
timeout /T %awaketime% /NOBREAK          %平台休眠的时间%
goto sleepawake




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