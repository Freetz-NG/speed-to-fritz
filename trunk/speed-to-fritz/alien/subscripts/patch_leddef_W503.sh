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


if ! [ -f "${SRC}"/lib/modules/$KernelVersion/kernel/drivers/char/led_module.ko ]; then
# W503 only for .58 firmware
cat <<EOF > "${SR1}/etc/led.conf"
DEF error,0 = 1,402784896,0,all
DEF error,1 = 3,0,0,all
DOUBLE error,0 TO error,1
DEF power,0 = 0,32,0,power
DEF power,1 = 0,32,0,power
DEF info,0 = 4,21,1,info
DEF info,1 = 4,21,1,info
DEF info,2 = 4,21,1,info
DEF info,3 = 4,21,1,info
DEF info,4 = 4,21,1,info
DEF internet,0 = 0,17,2,internet
DEF internet,1 = 0,17,2,internet
DEF wlan,0 = 0,28,3,wlan
DEF voip_con,0 = 0,9,4,voip_con
DEF voip_con,1 = 0,9,4,voip_con
DEF ab,1 = 0,27,5,festnetz
DEF ab,2 = 0,27,5,festnetz
DEF ab,3 = 0,27,5,festnetz
DEF update,0 = 99,32,6,update
DEF rot_eins,0 = 99,32,7,rot1
DEF rot_zwei,0 = 99,32,7,rot2
DEF rot_drei,0 = 99,32,7,rot3
DEF rot_vier,0 = 99,32,7,rot4
DEF rot_fuenf,0 = 99,32,7,rot5
DEF pppoe,0 = 99,32,8,dsl
DEF pppoe,1 = 99,32,8,dsl
DEF adsl,0 = 99,32,9,adsl
DEF adsl,1 = 99,32,9,adsl
DEF ata,0 = 99,32,10,ata
DEF tr69,0 = 99,32,11,tr69
DEF tr69,1 = 99,32,11,tr69
DEF tr69,2 = 99,32,11,tr69
DEF tr69,3 = 99,32,11,tr69
DEF tr69,4 = 99,32,11,tr69
DEF tam,0 = 99,32,12,tam
DEF tam,1 = 99,32,12,tam
DEF usb,0 = 99,32,13,usb
DEF usb,1 = 99,32,13,usb
DEF cpmac,0 = 99,32,14,lan_all
DEF cpmac,1 = 99,32,14,lan_all
DEF cpmac,2 = 99,32,14,lan_all
DEF cpmac,3 = 99,32,14,lan_all
DEF cpmac,4 = 99,32,14,lan_all
DEF blockring,0 = 99,32,15,blockring
DEF missedcall,0 = 99,32,16,missedcall
DEF budget,0 = 99,32,17,budget
DEF isdn,0 = 99,32,19,isdn
DEF isdn,1 = 99,32,19,isdn
DEF isdn,2 = 99,32,19,isdn
DEF stick_surf,0 = 99,32,20,stick_surf
DEF stick_surf,1 = 99,32,20,stick_surf
DEF stick_surf,2 = 99,32,20,stick_surf
DEF stick_surf,3 = 99,32,20,stick_surf
DEF null,0 = 99,32,21,null_device
DEF dect,0 = 99,32,23,dect
DEF null,0 = 99,32,24,null_device
MAP ab,2 TO null,0
MAP adsl,0 TO power,0
MAP budget,0 TO info,1
MAP ata,0 TO power,1
MAP stick_surf,0 TO info,4
SET power,0 = 1
EOF
else
#grep -q 'mknod .dev.led c' "${SR1}/etc/init.d/rc.S" ||\
#sed -i -e '/modprobe led_module/a\
#temp=`grep led \/proc\/devices`\
#led_c_major=${temp%%led}\
#mknod \/dev\/led c $led_c_major 0\
#' "${SR1}/etc/init.d/rc.S"

## dirty workaround for now, LED's arn't reassigned, no driver for W920 with the firmware in use now  
sed -i -e 's|new_led|led|' "${SR1}/etc/init.d/rc.S"
sed -i -e 's|new_led|led|' "${SR1}/etc/init.d/rc.wlan"
fi
exit 0


