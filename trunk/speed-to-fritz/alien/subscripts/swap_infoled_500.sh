#!/bin/bash
#swap info led 0,1 with tr69 led  
sed -i -e 's|DEF tr69,0 = 2,6,1,tr69|DEF tr69,0 = 99,32,16,tr69|' "${1}/etc/led.conf"
sed -i -e 's|DEF info,0 = 99,32,16,info|DEF info,0 = 2,6,1,info|' "${1}/etc/led.conf"
sed -i -e 's|DEF info,1 = 99,32,16,info|DEF info,1 = 2,6,1,info|' "${1}/etc/led.conf"
sed -i -e 's|DEF info,2 = 99,32,16,info|DEF info,2 = 2,6,1,info|' "${1}/etc/led.conf"
sed -i -e 's|DEF info,3 = 99,32,16,info|DEF info,3 = 2,6,1,info|' "${1}/etc/led.conf"
sed -i -e 's|DEF info,4 = 99,32,16,info|DEF info,4 = 2,6,1,info|' "${1}/etc/led.conf"

echo "DEF tam,0 = 99,32,21,tam" >>"${1}/etc/led.conf"
# map tam info to power
echo "MAP tam,0 TO power,1" >>"${1}/etc/led.conf"

#map stick_surf to info4, missed call to ata and adsl
echo "MAP stick_surf,0 TO info,4" >>"${1}/etc/led.conf"
#echo "MAP missedcall,0 TO ata,1" >>"${1}/etc/led.conf"
#echo "MAP missedcall,0 TO adsl,1" >>"${1}/etc/led.conf"


# Map ISDN LED to ab LED (config of original FRITZ!Box and replace it by Speedport's LED config)  

if ! `cat "${1}"/etc/init.d/rc.S | grep -q 'MAP isdn,0 TO ab,1'` ; then
sed -i -e 's|ln -s /dev/new_led /var/led|ln -s /dev/new_led /var/led\
case $OEM in\
 tcom\|avm)\
 echo "STATES isdn,0 = 0 -> 2, 1 -> 4" >/dev/new_led\
 echo "MAP isdn,0 TO ab,1" >/dev/new_led\
 echo "STATES ab,1 = 1 -> 18, 0 -> 2, 4 -> 1" >/dev/new_led\
 ;;\
 avme)\
 ;;\
esac|' "${1}/etc/init.d/rc.S"
fi



exit 0
