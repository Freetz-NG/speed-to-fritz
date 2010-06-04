#!/bin/bash
grep -q "Telekom-Anlagen benoetigen hochtakten" "${SRC}/etc/init.d/rc.S" || sed -i -e '/bin.run_clock -c .dev.tffs -d/i\
## Telekom-Anlagen benoetigen hochtakten (unabhaengig von ECO) !\
echo MODE=pd_speed_on >\/dev\/avm_power\
' "${SRC}/etc/init.d/rc.S"
grep -q ".var.flash.websrv_ssl_cert.pem c" "${SRC}/etc/init.d/rc.S" || sed -i -e '/mknod .var.flash.aura-usb/a\
mknod \/var\/flash\/websrv_ssl_cert.pem c $tffs_major $((0xCA))' "${SRC}/etc/init.d/rc.S"
grep -q ".var.flash.configd c" "${SRC}/etc/init.d/rc.S" || sed -i -e '/mknod .var.flash.aura-usb/a\
mknod \/var\/flash\/configd c $tffs_major $((0xA1))' "${SRC}/etc/init.d/rc.S"
grep -q "copy_provider_default" "${SRC}/etc/init.d/rc.S" || sed -i -e '/Defaults fuellen/a\
## Laden der Provider-defaults (statisch eingebunden vor rc.conf)\
##########################################################################################\
## P-Defaults - ingnoriert derzeit bei der WE auswahl eventuelle laufzeitparameter\
##########################################################################################\
copy_provider_default()\
{\
local DIR=\/var\/flash\/provider_default\
mkdir -p $DIR\
mknod $DIR\/$1 c $tffs_major $2\
if checkempty \/var\/flash\/$1 && ! checkempty $DIR\/$1 ; then\
echo "P-Defaults: cp $1"\
cat $DIR\/$1 >\/var\/flash\/$1\
fi\
}\
provider_default_config()\
{\
## In state of factory defaults ar7.cfg is always empty\
if ! checkempty \/var\/flash\/ar7.cfg ; then\
echo "P-Defaults: do nothing"\
return\
fi\
local DIR=\/var\/flash\/provider_default\
mkdir -p $DIR\
## mindestens der OEM wird benoetigt (fuer *cfgconv,*cfgctl)\
. \/etc\/init.d\/rc.conf\
if ! [ "${CONFIG_PROV_DEFAULT}" = "y" ] ; then\
## nicht ausf?hren, falls enthalten, jedoch aber zur laufzeit deaktiviert\
echo "P-Defaults: not configured - skip."\
return\
fi\
echo "P-Defaults: and action..."\
mknod $DIR\/ar7.cfg.diff c $tffs_major $((0x1f))\
if ! checkempty $DIR\/ar7.cfg.diff ; then\
echo "P-Defaults: merge ar7.cfg"\
allcfgconv -C ar7 -e -m $DIR\/ar7.cfg.diff\
local LANGUAGE="`echo provider_default.language | ar7cfgctl -s 2>\/dev\/null | sed s\/\\\\"\/\/g`"\
if [ "$LANGUAGE" != "" ] ; then\
if ! setlanguage $LANGUAGE ; then\
echo "P-Defaults: setlanguage failed"\
fi\
fi\
local COUNTRY="`echo provider_default.country | ar7cfgctl -s 2>\/dev\/null | sed s\/\\\\"\/\/g`"\
if [ "$COUNTRY" != "" ] ; then\
if ! setcountry $COUNTRY ; then\
echo "P-Defaults: setcountry failed"\
fi\
fi\
fi\
mknod $DIR\/voip.cfg.diff c $tffs_major $((0x22))\
if checkempty \/var\/flash\/voip.cfg && ! checkempty $DIR\/voip.cfg.diff ; then\
echo "P-Defaults: merge voip.cfg"\
allcfgconv -C voip -e -m $DIR\/voip.cfg.diff\
fi\
mknod $DIR\/wlan.cfg.diff c $tffs_major $((0x23))\
if checkempty \/var\/flash\/wlan.cfg && ! checkempty $DIR\/wlan.cfg.diff ; then\
echo "P-Defaults: merge wlan.cfg"\
wlancfgconv -e -m $DIR\/wlan.cfg.diff\
fi\
mknod $DIR\/usb.cfg.diff c $tffs_major $((0x4a))\
if checkempty \/var\/flash\/usb.cfg && ! checkempty $DIR\/usb.cfg.diff ; then\
echo "P-Defaults: merge usb.cfg"\
usbcfgconv -e -m $DIR\/usb.cfg.diff\
fi\
mknod $DIR\/tr069.cfg.diff c $tffs_major $((0x27))\
if checkempty \/var\/flash\/tr069.cfg && ! checkempty $DIR\/tr069.cfg.diff ; then\
echo "P-Defaults: merge tr069.cfg"\
allcfgconv -C tr069 -e -m $DIR\/tr069.cfg.diff\
fi\
mknod $DIR\/vpn.cfg.diff c $tffs_major $((0x26))\
if checkempty \/var\/flash\/vpn.cfg && ! checkempty $DIR\/vpn.cfg.diff ; then\
echo "P-Defaults: merge vpn.cfg"\
allcfgconv -C vpn -e -m $DIR\/vpn.cfg.diff\
fi\
mknod $DIR\/user.cfg.diff c $tffs_major $((0x28))\
if checkempty \/var\/flash\/user.cfg && ! checkempty $DIR\/user.cfg.diff ; then\
echo "P-Defaults: merge user.cfg"\
allcfgconv -C user -e -m $DIR\/user.cfg.diff\
fi\
copy_provider_default fx_cg $((0x34))\
copy_provider_default fx_conf $((0x31))\
copy_provider_default fx_lcr $((0x32))\
copy_provider_default telefon_misc $((0x35))\
copy_provider_default phonebook $((0x3e))\
copy_provider_default calllog $((0x3d))\
copy_provider_default dect_misc $((0x44))\
copy_provider_default fonctrl $((0x3f))\
copy_provider_default dect_eeprom $((0x45))\
copy_provider_default dmgr_handset_user $((0x46))\
copy_provider_default umts.cfg $((0x4c))\
copy_provider_default configd $((0x4f))\
echo "P-Defaults: ...done."\
}\
provider_default_config\
## P-Defaults - ende\
' "${SRC}/etc/init.d/rc.S"
