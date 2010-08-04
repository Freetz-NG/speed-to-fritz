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

#newer version in use form 10576 on
echo "#!/bin/sh" >"${SR1}/bin/update_led_off"
echo "echo \"SET info,0 = 0\">/var/led" >>"${SR1}/bin/update_led_off"

echo "#!/bin/sh" >"${SR1}/bin/update_led_on"
echo "echo \"SET info,0 = 18\">/var/led" >>"${SR1}/bin/update_led_on"


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

# W500, W701 or W900 without copy of base led.conf, 
# this is more secure for future changes as the skrit upto now 

sed -i -e "/DEF error,1.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DOUBLE error,0.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF power.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF tr69.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF cpmac.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF wlan.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF ab.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF voip_con.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF pppoe.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF adsl.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF ata.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF usb.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF blockring.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF missedcall.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF budget.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF info.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF internet.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF isdn.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF stick_surf.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF null.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF tam.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF dect.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/DEF fax.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/MAP budget.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/MAP ab,2.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/SET power.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/MAP stick_surf.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/MAP ata.*$/d" "${SR1}/etc/led.conf"
sed -i -e "/MAP adsl.*$/d" "${SR1}/etc/led.conf"


sed -i -e 's|DEF error,0.*,all|DEF error,0 = 1,128,0,all\
DEF error,1 = 3,127,0,all\
DOUBLE error,0 TO error,1\
DEF power,0 = 0,7,0,power\
DEF power,1 = 0,7,0,power\
DEF tr69,0 = 99,32,1,tr69\
DEF tr69,1 = 99,32,1,tr69\
DEF tr69,2 = 99,32,1,tr69\
DEF tr69,3 = 99,32,1,tr69\
DEF tr69,4 = 99,32,1,tr69\
DEF cpmac,3 = 99,0,2,lan4\
DEF cpmac,2 = 99,1,3,lan3\
DEF cpmac,1 = 99,2,4,lan2\
DEF cpmac,0 = 99,3,5,lan\
DEF wlan,0 = 2,5,6,wlan\
DEF ab,1 = 2,4,7,festnetz\
DEF ab,2 = 2,4,7,festnetz\
DEF ab,3 = 2,4,7,festnetz\
DEF voip_con,0 = 2,3,8,voip_con\
DEF voip_con,1 = 2,3,8,voip_con\
DEF pppoe,0 = 2,2,9,dsl\
DEF pppoe,1 = 2,2,9,dsl\
DEF adsl,0 = 2,1,10,adsl\
DEF adsl,1 = 2,1,10,adsl\
DEF ata,0 = 2,0,11,ata\
DEF usb,0 = 99,32,12,usb\
DEF usb,1 = 99,32,12,usb\
DEF blockring,0 = 99,32,13,blockring\
DEF missedcall,0 = 99,32,14,missedcall\
DEF budget,0 = 99,32,15,budget\
DEF info,0 = 2,6,16,info\
DEF info,1 = 2,6,16,info\
DEF info,2 = 2,6,16,info\
DEF info,3 = 2,6,16,info\
DEF info,4 = 2,6,16,info\
DEF internet,0 = 99,32,17,internet\
DEF internet,1 = 99,32,17,internet\
DEF isdn,0 = 99,32,18,isdn\
DEF isdn,1 = 99,32,18,isdn\
DEF isdn,2 = 99,32,18,isdn\
DEF stick_surf,0 = 99,32,19,stick_surf\
DEF stick_surf,1 = 99,32,19,stick_surf\
DEF stick_surf,2 = 99,32,19,stick_surf\
DEF stick_surf,3 = 99,32,19,stick_surf\
DEF null,0 = 99,32,20,null_device\
DEF tam,0 = 99,32,21,tam\
DEF tam,1 = 99,32,21,tam\
DEF dect,0 = 99,32,22,dect\
DEF fax,0 = 99,32,23,fax\
MAP budget,0 TO info,1\
MAP ab,2 TO null,0\
SET power,0 = 1\
MAP stick_surf,0 TO info,4|' "${SR1}/etc/led.conf"

exit 0

