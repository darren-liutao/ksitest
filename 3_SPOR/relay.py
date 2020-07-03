#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import time
import os
import random

looptime=10000        #循环次数
ontime=60            #开机时间,单位s
offtime=5            #两次测试间隔时间，单位s
route1=1             #继电器线路1,控制电源
route2=2             #继电器线路2,控制开机键
path = os.getcwd()
Usbexe = path+"\\USBRelay\\TestApp\\CommandApp_USBRelay.exe"
relayNumber=' 3X9XI' #继电器编码，通过TestAPP文件下GuiApp_Chinese.exe程序查找设备获得。 
	
for i in range(looptime):	
    poweron=random.randint(3,ontime)                                   #设置随机上电时间    
    os.system(Usbexe+relayNumber+" open "+str(route1))                 #接通电源
    time.sleep(3)                                                      #延迟3s
    os.system(Usbexe+relayNumber+" open "+str(route2))                 #按下电源键
    time.sleep(3)                                                      #开机键按住3s
    os.system(Usbexe+relayNumber+" close "+str(route2))                #松开开机键
    time.sleep(poweron)                                                #随机上电3-60秒
    print("第",i+1,"次测试完成！","本次上电时间为:",poweron,"秒")         #打印上电时间
    os.system(Usbexe+relayNumber+" close "+str(route1))                #断开电源
    time.sleep(offtime)                                                #两次测试间隔时间