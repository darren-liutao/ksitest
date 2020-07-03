echo off
mode con cols=50 lines=20
color 4A
title=readdisturb

adb root
adb push readdisturb  /data
adb wait-for-device
adb shell chmod 777 /data/readdisturb
adb shell ./data/readdisturb &
adb pull /sdcard/readdisturb_log.txt

color AF
echo read disturb test is completed!
pause
