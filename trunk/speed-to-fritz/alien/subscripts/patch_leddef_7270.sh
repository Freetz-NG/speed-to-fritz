#!/bin/bash
 . ${include_modpatch}
SR1="$1" 


# change DECT text for infoled 
#if [ "$avm_Lang" != "en" ] ; then
 for OEMDIR in ${OEMLIST}; do
#  if [ "$OEMDIR" = "avme" ] ; then
#   export HTML="$OEMDIR/$avm_Lang/html"
#  else
   export HTML="$OEMDIR/html"
#  fi
    if [ -e "$SR1"/usr/www/${HTML}/de/system/infoled.inc ]; then
     echo2 "-- Change TextBlinkDECT in: /usr/www/${HTML}/de/system/infoled.inc"
     [ "$OEMDIR" = "avm" ] && [ "$avm_Lang" = "de" ] && sed -i -e "s/^.*TextBlinkDECT.*$/<? setvariable var:TextBlinkDECT 'Die INFO-LED leuchtet immer wenn DECT aktiviert ist.' ?>/" "$SR1"/usr/www/${HTML}/de/system/infoled.inc
     [ "$OEMDIR" = "avme" ] && [ "$avm_Lang" = "en" ] && sed -i -e "s/^.*TextBlinkDECT.*$/<? setvariable var:TextBlinkDECT 'DECT activated' ?>/" "$SR1"/usr/www/${HTML}/de/system/infoled.inc
    fi
 done
#fi

# Map ISDN LED to ab LED (config of original FRITZ!Box and replace it by Speedport's LED config)  

if ! `cat "${SR1}"/etc/init.d/rc.S | grep -q 'MAP isdn,0 TO ab,1'` ; then
sed -i -e 's|ln -s /dev/new_led /var/led|ln -s /dev/new_led /var/led\
case $OEM in\
 tcom\|avm)\
 echo "STATES isdn,0 = 0 -> 2, 1 -> 4" >/dev/new_led\
 echo "MAP isdn,0 TO ab,1" >/dev/new_led\
 echo "STATES ab,1 = 1 -> 18, 0 -> 2, 4 -> 1" >/dev/new_led\
 ;;\
 avme)\
 ;;\
esac\
if /bin/testvalue /var/flash/dect_misc 1 0 0; then\
echo "SET dect,0 = 0" >/dev/new_led\
else\
echo "SET dect,0 = 15" >/dev/new_led\
fi|' "${SR1}/etc/init.d/rc.S"
fi

if  [ -e "${SR1}/etc/led.conf" ]; then

# W920 without copy of t-com led.conf, 
# this is more secure for future changes 

sed -i -e "/error,0.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF power.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF rot.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF budget.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF internet.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF info.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF cpmac.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF wlan.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF ab.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF voip_con.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF pppoe.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF adsl.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF update.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF tam.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF blockring.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF missedcall.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF stick_surf.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF buget.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF usb.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF ata.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF isdn.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF dect.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF null.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF tr69.*$/d" "${SR1}/etc/led.conf"

sed -i -e "/MAP ab,2.*$/d" "${SR1}/etc/led.conf"

sed -i -e "/MAP stick_surf.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/MAP budget.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/MAP tr69.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/MAP ata.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/MAP adsl.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/SET power.*$/d" "${SR1}/etc/led.conf"


sed -i -e 's|DEF error,1 = 3,0,0,all|DEF error,1 = 3,0,0,all\
DEF error,0 = 1,73417228930,0,all\
DOUBLE error,0 TO error,1\
DEF power,0 = 0,1,0,power\
DEF power,1 = 0,1,0,power\
DEF info,0 = 4,21,1,info\
DEF info,1 = 4,21,1,info\
DEF info,2 = 4,21,1,info\
DEF info,3 = 4,21,1,info\
DEF info,4 = 4,21,1,info\
DEF cpmac,3 = 99,0,2,lan4\
DEF cpmac,2 = 99,1,3,lan3\
DEF cpmac,1 = 99,2,4,lan2\
DEF cpmac,0 = 99,3,5,lan\
DEF wlan,0 = 0,28,6,wlan\
DEF ab,1 = 0,27,7,festnetz\
DEF ab,2 = 0,27,7,festnetz\
DEF ab,3 = 0,27,7,festnetz\
DEF voip_con,0 = 0,9,8,voip_con\
DEF voip_con,1 = 0,9,8,voip_con\
DEF pppoe,0 = 0,17,9,dsl\
DEF pppoe,1 = 0,17,9,dsl\
DEF adsl,0 = 0,32,10,adsl\
DEF adsl,1 = 0,32,10,adsl\
DEF update,0 = 0,36,11,update\
DEF tam,0 = 99,32,12,tam\
DEF tam,1 = 99,32,12,tam\
DEF blockring,0 = 99,32,13,blockring\
DEF missedcall,0 = 99,32,14,missedcall\
DEF stick_surf,0 = 99,32,15,stick_surf\
DEF stick_surf,1 = 99,32,15,stick_surf\
DEF stick_surf,2 = 99,32,15,stick_surf\
DEF stick_surf,3 = 99,32,15,stick_surf\
DEF usb,0 = 99,32,16,usb\
DEF usb,1 = 99,32,16,usb\
DEF budget,0 = 99,32,17,budget\
DEF ata,0 = 99,32,18,ata\
DEF isdn,0 = 99,32,19,isdn\
DEF isdn,1 = 99,32,19,isdn\
DEF isdn,2 = 99,32,19,isdn\
DEF dect,0 = 99,32,20,dect\
DEF null,0 = 99,32,21,null_device\
DEF tr69,0 = 99,32,22,tr69\
DEF tr69,1 = 99,32,22,tr69\
DEF tr69,2 = 99,32,22,tr69\
DEF tr69,3 = 99,32,22,tr69\
DEF tr69,4 = 99,32,22,tr69\
DEF internet,0 = 99,32,23,internet\
DEF internet,1 = 99,32,23,internet\
DEF rot_eins,0 = 0,35,24,rot1\
DEF rot_zwei,0 = 0,36,25,rot2\
DEF rot_drei,0 = 0,32,26,rot3\
DEF rot_vier,0 = 0,22,27,rot4\
DEF rot_fuenf,0 = 0,21,28,rot5\
MAP ab,2 TO null,0\
MAP budget,0 TO info,1\
MAP ata,0 TO update,0\
MAP stick_surf,0 TO info,4\
MAP internet,0 TO pppoe,0\
MAP internet,1 TO pppoe,1\
SET power,0 = 1|' "${SR1}/etc/led.conf"
else

#dirty workaround for now, LED's arn't reassigned, no driver for W920 with the firmware in use now  
sed -i -e 's|new_led|led|' "${SR1}/etc/init.d/rc.S"
sed -i -e 's|new_led|led|' "${SR1}/etc/init.d/rc.wlan"

#cp -fr $2/bin/update_led_on ${SR1}/bin/update_led_on
#cp -fr $2/bin/update_led_off ${SR1}/bin/update_led_off

fi
exit 0

AVM verwendet ab: "fritz_box-labor-12657"

led_modul_Fritz_Box_7270: module license '
(C) Copyright 2008 by AVM
' taintskernel.
[avm_led] register_chrdev_region()
[led_gpio_bit_driver_init] gpio 1 name power
[led_gpio_bit_driver_init] gpio 9 name internet
[led_gpio_bit_driver_init] gpio 27 name festnetz
[led_gpio_bit_driver_init] gpio 28 name wlan
[led_gpio_bit_driver_init] gpio 17 name dual1
[led_gpio_bit_driver_init] gpio 35 name dual2
#---------------------------------------------------

W920
DEF error,0 = 1,73417228930,0,all
DEF error,1 = 3,0,0,all
DOUBLE error,0 TO error,1
DEF power,0 = 0,1,0,power
DEF power,1 = 0,1,0,power
DEF tr69,0 = 4,21,1,tr69
DEF tr69,1 = 4,21,1,tr69
DEF tr69,2 = 4,21,1,tr69
DEF tr69,3 = 4,21,1,tr69
DEF tr69,4 = 4,21,1,tr69
DEF cpmac,3 = 99,0,2,lan4
DEF cpmac,2 = 99,1,3,lan3
DEF cpmac,1 = 99,2,4,lan2
DEF cpmac,0 = 99,3,5,lan
DEF wlan,0 = 0,28,6,wlan
DEF ab,1 = 0,27,7,festnetz
DEF ab,2 = 0,27,7,festnetz
DEF ab,3 = 0,27,7,festnetz
DEF voip_con,0 = 0,9,8,voip_con
DEF voip_con,1 = 0,9,8,voip_con
DEF pppoe,0 = 0,17,9,dsl
DEF pppoe,1 = 0,17,9,dsl
DEF adsl,0 = 0,32,10,adsl
DEF adsl,1 = 0,32,10,adsl
DEF update,0 = 0,36,11,update
DEF tam,0 = 99,32,12,tam
DEF tam,1 = 99,32,12,tam
DEF blockring,0 = 99,32,13,blockring
DEF missedcall,0 = 99,32,14,missedcall
DEF stick_surf,0 = 99,32,15,stick_surf
DEF stick_surf,1 = 99,32,15,stick_surf
DEF stick_surf,2 = 99,32,15,stick_surf
DEF stick_surf,3 = 99,32,15,stick_surf
DEF usb,0 = 99,32,16,usb
DEF usb,1 = 99,32,16,usb
DEF budget,0 = 99,32,17,budget
DEF ata,0 = 99,32,18,ata
DEF isdn,0 = 99,32,19,isdn
DEF isdn,1 = 99,32,19,isdn
DEF isdn,2 = 99,32,19,isdn
DEF dect,0 = 99,32,20,dect
DEF null,0 = 99,32,21,null_device
MAP ab,2 TO null,0
SET power,0 = 1

7270
DEF error,0 = 1,107783258754,0,all
DEF error,1 = 3,0,0,all
DOUBLE error,0 TO error,1
DEF power,0 = 0,1,0,power
DEF power,1 = 0,1,0,power
DEF internet,0 = 0,9,1,internet
DEF internet,1 = 0,9,1,internet
DEF ab,1 = 0,27,2,festnetz
DEF ab,2 = 0,27,2,festnetz
DEF ab,3 = 0,27,2,festnetz
DEF wlan,0 = 0,28,3,wlan
DEF info,0 = 0,17,4,info
DEF info,1 = 0,17,4,info
DEF info,2 = 0,17,4,info
DEF info,3 = 0,17,4,info
DEF info,4 = 0,17,4,info
DEF rot_eins,0 = 0,35,5,rot1
DEF rot_zwei,0 = 0,36,6,rot2
DEF rot_drei,0 = 0,32,7,rot3
DEF rot_vier,0 = 0,22,8,rot4
DEF rot_fuenf,0 = 0,21,9,rot5
DEF tam,0 = 99,32,10,tam
DEF tam,1 = 99,32,10,tam
DEF pppoe,0 = 99,32,11,dsl
DEF pppoe,1 = 99,32,11,dsl
DEF blockring,0 = 99,32,12,blockring
DEF missedcall,0 = 99,32,13,missedcall
DEF stick_surf,0 = 99,32,14,stick_surf
DEF stick_surf,1 = 99,32,14,stick_surf
DEF stick_surf,2 = 99,32,14,stick_surf
DEF stick_surf,3 = 99,32,14,stick_surf
DEF cpmac,0 = 99,32,15,lan_all
DEF cpmac,1 = 99,32,15,lan_all
DEF cpmac,2 = 99,32,15,lan_all
DEF cpmac,3 = 99,32,15,lan_all
DEF cpmac,4 = 99,32,15,lan_all
DEF usb,0 = 99,32,16,usb
DEF usb,1 = 99,32,16,usb
DEF budget,0 = 99,32,17,budget
DEF adsl,0 = 99,32,18,adsl
DEF adsl,1 = 99,32,18,adsl
DEF ata,0 = 99,32,19,ata
DEF tr69,0 = 99,32,20,tr69
DEF tr69,1 = 99,32,20,tr69
DEF tr69,2 = 99,32,20,tr69
DEF tr69,3 = 99,32,20,tr69
DEF tr69,4 = 99,32,20,tr69
DEF voip_con,0 = 99,32,21,voip_con
DEF voip_con,1 = 99,32,21,voip_con
DEF isdn,0 = 99,32,22,isdn
DEF isdn,1 = 99,32,22,isdn
DEF isdn,2 = 99,32,22,isdn
DEF dect,0 = 99,32,23,dect
DEF null,0 = 99,32,24,null_device
MAP budget,0 TO info,1
MAP ata,0 TO power,1
MAP adsl,0 TO power,0
MAP stick_surf,0 TO info,4
SET power,0 = 1
