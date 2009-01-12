#!/bin/bash
#swap info led 0-4 with wlan led  
sed -i -e 's|DEF wlan,0 = 0,9,4,wlan|DEF wlan,0 = 99,32,17,wlan|' "${1}/etc/led.conf"
sed -i -e 's|DEF info,0 = 99,32,17,info|DEF info,0 = 0,9,4,info|' "${1}/etc/led.conf"
sed -i -e 's|DEF info,1 = 99,32,17,info|DEF info,1 = 0,9,4,info|' "${1}/etc/led.conf"
sed -i -e 's|DEF info,2 = 99,32,17,info|DEF info,2 = 0,9,4,info|' "${1}/etc/led.conf"
sed -i -e 's|DEF info,3 = 99,32,17,info|DEF info,3 = 0,9,4,info|' "${1}/etc/led.conf"
sed -i -e 's|DEF info,4 = 99,32,17,info|DEF info,4 = 0,9,4,info|' "${1}/etc/led.conf"
exit 0
