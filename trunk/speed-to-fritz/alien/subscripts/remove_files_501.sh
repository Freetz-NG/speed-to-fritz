#!/bin/bash
 . ${include_modpatch}
echo2 "  -- removing files ..."
for DIR in ${OEMLISt}; do
# if [ "$DIR" = "avme" ] ; then
#  export HTML="$DIR/$avm_Lang/html"
# else
  export HTML="$DIR/html"
# fi
    DSTI="${1}"/usr/www/$HTML
    if [ -d ${DSTI} ]; then
#-----------------------------------------
echo "-- /usr/www/$HTML/$avm_Lang/..."


rm -fd -R ${1}/usr/www/$HTML/$avm_Lang/software
rm -fd -R ${1}/usr/www/$HTML/$avm_Lang/usb
rm -fd -R ${1}/usr/www/$HTML/$avm_Lang/tr69_autoconfig
rm -fd -R ${1}/usr/www/$HTML/$avm_Lang/dect

rm -rf  ${1}/usr/www/$HTML/$avm_Lang/menus/menu2_usb*
rm -rf  ${1}/usr/www/$HTML/$avm_Lang/menus/menu2_usb.inc
rm -rf  ${1}/usr/www/$HTML/$avm_Lang/menus/menu2_software*
rm -rf  ${1}/usr/www/$HTML/$avm_Lang/menus/menu2_tr69*

rm -rf  ${1}/usr/www/$HTML/$avm_Lang/home/fon1Dect*
rm -rf  ${1}/usr/www/$HTML/$avm_Lang/home/usb*
rm -rf  ${1}/usr/www/$HTML/$avm_Lang/home/fon1tam*
rm -rf  ${1}/usr/www/$HTML/$avm_Lang/home/tam*
rm -rf  ${1}/usr/www/$HTML/$avm_Lang/home/fonab*
rm -rf  ${1}/usr/www/$HTML/$avm_Lang/home/isdn*
rm -rf  ${1}/usr/www/$HTML/$avm_Lang/home/fonlistisdn*
rm -rf  ${1}/usr/www/$HTML/$avm_Lang/home/fon1isdn*
rm -rf  ${1}/usr/www/$HTML/$avm_Lang/home/buchsend*
rm -rf  ${1}/usr/www/$HTML/$avm_Lang/fon/fon1Dect*
rm -rf  ${1}/usr/www/$HTML/$avm_Lang/fon/usb*
rm -rf  ${1}/usr/www/$HTML/$avm_Lang/fon/fon1tam*
rm -rf  ${1}/usr/www/$HTML/$avm_Lang/fon/tam*
rm -rf  ${1}/usr/www/$HTML/$avm_Lang/fon/fonab*
rm -rf  ${1}/usr/www/$HTML/$avm_Lang/fon/isdn*
rm -rf  ${1}/usr/www/$HTML/$avm_Lang/fon/fonlistisdn*
rm -rf  ${1}/usr/www/$HTML/$avm_Lang/fon/fon1isdn*
rm -rf  ${1}/usr/www/$HTML/$avm_Lang/fon/buchsend*

#rm -rf  ${1}/usr/www/$HTML/$avm_Lang/fon/mini*
#rm -rf  ${1}/usr/www/$HTML/$avm_Lang/home/mini*
#rm -rf  ${1}/usr/www/$HTML/$avm_Lang/home/fon1mini*
#rm -rf  ${1}/usr/www/$HTML/$avm_Lang/fon/fon1mini*

rm -rf  ${1}/usr/www/$HTML/$avm_Lang/fon_config/fon_config_Isdn*

rm -rf  ${1}/usr/www/$HTML/tam.html




#[ ${REMOVE_KIDS} = "y" ] && rm -fd -R ${1}/usr/www/kids
#annexb firmware to big, remove more
if [ $TCOM_V_MINOR -eq 38 ] && [ $AVM_V_MINOR -eq 33 ]; then

rm -fd -R ${1}/usr/www/$HTML/$avm_Lang/tools
rm -fd -R ${1}/usr/www/$HTML/$avm_Lang/first
#rm -fd -R ${1}/usr/www/$HTML/$avm_Lang/fon_config
rm -fd -R ${1}/usr/www/kids
rm -fd -R ${1}/usr/www/$HTML/tools

fi
#---------------------------------------------
    fi

#[ ${OEM} != ${DIR} ] && echo "-- Remove /etc/default.${CONFIG_PRODUKT}/$DIR"
[ ${OEM} != ${DIR} ] && rm -fd -R ${1}/etc/default.${CONFIG_PRODUKT}/$DIR

done


rm -rf ${1}/sbin/wlan_cal
rm -rf ${1}/sbin/tracking
rm -rf ${1}/sbin/finalize_env
rm -rf ${1}/sbin/printserv
rm -rf ${1}/sbin/hotplug

rm -rf ${1}/bin/usbhostchange

rm -rf ${1}/usr/share/ctlmgr/libctlusb*
rm -rf ${1}/usr/share/ctlmgr/libtr069*
rm -rf ${1}/usr/share/ctlmgr/libdect*
rm -rf ${1}/usr/share/ctlmgr/libtam*
rm -rf ${1}/usr/share/telefon/libtam*
rm -rf ${1}/usr/share/telefon/tam*

#rm -rf ${1}/usr/share/telefon/libmini*


rm -rf -R ${1}/usr/share/tam

rm -rf ${1}/usr/bin/tr069fwupdate

rm -rf ${1}/etc/default.049/fx_conf.default.1
rm -rf ${1}/etc/default.049/fx_lcr.default.1
rm -rf ${1}/etc/default.049/fx_lcr.aol

rm -rf ${1}/etc/usbclass.tab  
rm -rf ${1}/etc/usbdevice.tab  

rm -fd -R ${1}/etc/hotplug

rm -rf  ${1}/lib/modules/2.6.13.1-ohio/modules.usbmap

rm -fd -R ${1}/lib/modules/2.6.13.1-ohio/kernel/drivers/scsi
rm -fd -R ${1}/lib/modules/2.6.13.1-ohio/kernel/drivers/usb
rm -fd -R ${1}/lib/modules/2.6.13.1-ohio/kernel/drivers/cdrom
rm -fd -R ${1}/lib/modules/2.6.13.1-ohio/kernel/drivers/char/audio
rm -fd -R ${1}/lib/modules/2.6.13.1-ohio/kernel/drivers/char/flash_update
rm -fd -R ${1}/lib/modules/2.6.13.1-ohio/kernel/fs




exit 0
