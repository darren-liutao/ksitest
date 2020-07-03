@echo off
CHCP 65001
mode con cols=50 lines=20
title=bigfile
color 0F
echo.
echo -----------------------------------------------
echo           Kingston Test Tool For Internal
echo -----------------------------------------------
echo               Big File R/W Test Tool
echo -----------------------------------------------
echo.

::if exist "D:\1GB.test"(
::    goto set
::    )
rem 判断是否存在测试文件，如果不存在则在本地电脑D盘创建一个大小为1GB的测试文件
if not exist "D:\1GB.test" (
fsutil file createnew D:\1GB.test 1073741824
goto set
    )

:set
set /a a=0
set /a fs=120                                                    %一次读写约用时120s%
set /a t=72                                                      %设置默认测试时间72小时%
set /p t=Input test time,default=72(unit:hours):%输入测试时间%
set /a cycles=%t%*60*60/fs                                       %把测试时间转换成测试次数%
set /a writecount=%cycles%*1024

echo.
echo.
cls
color F0
echo -----------------------------------------------
echo           This Is Big File R/W Test!
echo             Please Check Setting!
echo -----------------------------------------------
echo              Test time≈%t%hours
echo        Total data count=%writecount%MB=%cycles%GB
echo             Total test cycles=%cycles%
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
if /i %errorlevel%==1 goto bigfile
if /i %errorlevel%==2 goto set
if /i %errorlevel%==3 goto exit

:bigfile
cls
color AF
set /a a=a+1
set /a testleft=%cycles%-%a%
set /a dataleft=%testleft%*1024
echo -----------------------------------------------
echo            The %a%th big file test!
echo -----------------------------------------------
echo            Total test cycles =%cycles%
echo            We have %testleft% tests left!
echo -----------------------------------------------
echo         Total data count=%writecount%MB=%cycles%GB
echo           We have %dataleft%MB=%testleft%GB left!
echo -----------------------------------------------
echo.
echo -----------------------------------------------
echo                   WRITING
echo -----------------------------------------------
adb wait-for-device
adb push D:\1GB.test /storage/sdcard0/test/%a%big.test        %写入1KB文件到emmc%
echo.
echo -----------------------------------------------
echo                   READING
echo -----------------------------------------------
adb pull /storage/sdcard0/test/%a%big.test                    %从eMMC中读出1KB文件%
adb shell rm -r /storage/sdcard0/test                            %从eMMC中删除测试文件，防止平台空间占满%                    
del %a%big.test                                               %从电脑中删除读出文件，防止电脑硬盘占满%
echo cycles^=^%a%>>record.txt                                    %记录测试次数，防止测试电脑重启%
if %a%==%cycles%‬ goto finish                                     %设置测试到指定次数后退出测试%
goto bigfile


:finish
color AF
echo Test finished,Please check test cycles and platform!>>record.txt
echo You set test cycles=%cycles%!>>record.txt
echo Test finished,Please delete this file!>>record.txt
echo Test finished,Please delete this file!>>record.txt
echo Test finished,Please delete this file!>>record.txt
record.txt                                                       %自动打开次数记录文件，以便检查%
del record.txt                                                   %检查完毕后自动删除次数记录文件，方便下一次记录%
del D:\1GB.test                                                  %测试结束后自动删除测试文件%

:exit