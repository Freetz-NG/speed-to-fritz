#!/bin/bash
. ${include_modpatch}
cat "${1}/etc/init.d/rc.conf" | grep 'export CONFIG_.*=' | sort > 1_init.log
if [ $AVM_V_MINOR -lt 49 ]; then
 . $sh_DIR/inc_func_init
 #delete parse init section in rc.conf
 del_section "${1}/etc/init.d/rc.conf"
 #move config (init or conf ) form $2 to $1 (rc.conf)   
 copy_config ".*" "${2}" "${1}"
 #Get defaults given in  $3.init to rc.conf
 parse_copy_rcconf "CONFIG_.*" "$sh_DIR/${3}.init" "${1}"
 #remove rc.init because data ist now transfered to rc.conf
 [ -e "${1}"/etc/init.d/rc.init ] && rm -f "${1}"/etc/init.d/rc.init
 sed -i -e "s/CONFIG_MAILER2=\".*$/CONFIG_MAILER2=\"${CONFIG_MAILER2}\"/g" "${1}/etc/init.d/rc.conf"
 sed -i -e "s/CONFIG_MAILER=\".*$/CONFIG_MAILER=\"${CONFIG_MAILER}\"/g" "${1}/etc/init.d/rc.conf"
 sed -i -e "s/CONFIG_TAM=\".*$/CONFIG_TAM=\"${CONFIG_TAM}\"/g" "${1}/etc/init.d/rc.conf"
 sed -i -e "s/CONFIG_TAM_MODE=\".*$/CONFIG_TAM_MODE=\"${CONFIG_TAM_MODE}\"/g" "${1}/etc/init.d/rc.conf"
 sed -i -e "s/CONFIG_UPNP=\".*$/CONFIG_UPNP=\"${CONFIG_UPNP}\"/g" "${1}/etc/init.d/rc.conf"
fi
#set some variabels  
echo2 "-- Adjusting config parms in:"
echo2 "      /etc/init.d/rc.conf"
echo2 "-- Changing product to ${CONFIG_PRODUKT}"
# set hostname
# Changing product, is important becaus is used for directorys
sed -i -e "s/PRODUKT=\".*$/PRODUKT=\"${CONFIG_PRODUKT}\"/g" "${1}/etc/init.d/rc.conf"
#_____________________________________________________________________________________________________________________#
sed -i -e "s/CONFIG_INSTALL_TYPE=\".*$/CONFIG_INSTALL_TYPE=\"${CONFIG_INSTALL_TYPE}\"/g" "${1}/etc/init.d/rc.conf"
#sed -i -e "s/CONFIG_XILINX=\".*$/CONFIG_XILINX=\"${CONFIG_XILINX}\"/g" "${1}/etc/init.d/rc.conf"
sed -i -e "s/CONFIG_DECT=\".*$/CONFIG_DECT=\"${CONFIG_DECT}\"/g" "${1}/etc/init.d/rc.conf"
sed -i -e "s/CONFIG_ROMSIZE=\".*$/CONFIG_ROMSIZE=\"${CONFIG_ROMSIZE}\"/g" "${1}/etc/init.d/rc.conf"
sed -i -e "s/CONFIG_RAMSIZE=\".*$/CONFIG_RAMSIZE=\"${CONFIG_RAMSIZE}\"/g" "${1}/etc/init.d/rc.conf"
sed -i -e "s/CONFIG_ETH_COUNT=\".$/CONFIG_ETH_COUNT=\"${CONFIG_ETH_COUNT}\"/g" "${1}/etc/init.d/rc.conf"
sed -i -e "s/CONFIG_AB_COUNT=\".*$/CONFIG_AB_COUNT=\"${CONFIG_AB_COUNT}\"/g" "${1}/etc/init.d/rc.conf"
# if Tr069 is enablt then AtA must be disabelt
[ "$CONFIG_TR069" ] ||  sed -i -e "s/CONFIG_ATA=\".*$/CONFIG_ATA=\"${CONFIG_ATA}\"/g" "${1}/etc/init.d/rc.conf"
#sed -i -e "s/CONFIG_ONLINEHELP=\".*$/CONFIG_ONLINEHELP=\"${CONFIG_ONLINEHELP}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_TR069" ] &&  sed -i -e "s/TR069=\".*$/TR069=\"${CONFIG_TR069}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_TR064" ] &&  sed -i -e "s/CONFIG_TR064=\".*$/CONFIG_TR064=\"${CONFIG_TR064}\"/g" "${1}/etc/init.d/rc.conf"
sed -i -e "s/CONFIG_DECT_ONOFF=\".*$/CONFIG_DECT_ONOFF=\"${CONFIG_DECT_ONOFF}\"/g" "${1}/etc/init.d/rc.conf"
sed -i -e "s/CONFIG_LED_NO_DSL_LED=\".*$/CONFIG_LED_NO_DSL_LED=\"${CONFIG_LED_NO_DSL_LED}\"/g" "${1}/etc/init.d/rc.conf"
#----
sed -i -e "s|CONFIG_SERVICEPORTAL_URL=\".*$|CONFIG_SERVICEPORTAL_URL=\"${CONFIG_SERVICEPORTAL_URL}\"|g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_DSL" ] &&  sed -i -e "s/CONFIG_DSL=\".*$/CONFIG_DSL=\"${CONFIG_DSL}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_VDSL" ] &&  sed -i -e "s/CONFIG_VDSL=\".*$/CONFIG_VDSL=\"${CONFIG_VDSL}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_DSL_UR8" ] &&  sed -i -e "s/CONFIG_DSL_UR8=\".*$/CONFIG_DSL_UR8=\"${CONFIG_DSL_UR8}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_LABOR_DSL" ] &&  sed -i -e "s/CONFIG_LABOR_DSL=\".*$/CONFIG_LABOR_DSL=\"${CONFIG_LABOR_DSL}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_DSL_MULTI_ANNEX" ] &&  sed -i -e "s/CONFIG_DSL_MULTI_ANNEX=\".*$/CONFIG_DSL_MULTI_ANNEX=\"${CONFIG_DSL_MULTI_ANNEX}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_ATA_FULL" ] &&  sed -i -e "s/CONFIG_ATA_FULL=\".*$/CONFIG_ATA_FULL=\"${CONFIG_ATA_FULL}\"/g" "${1}/etc/init.d/rc.conf"
#W721
[ "$CONFIG_VINAX" ] &&  sed -i -e "s/CONFIG_VINAX=\".*$/CONFIG_VINAX=\"${CONFIG_VINAX}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_VLYNQ_PARAMS" ] &&  sed -i -e "s/CONFIG_VLYNQ_PARAMS=\".*$/CONFIG_VLYNQ_PARAMS=\"${CONFIG_VLYNQ_PARAMS}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_VLYNQ" ] &&  sed -i -e "s/CONFIG_VLYNQ=\".*$/CONFIG_VLYNQ=\"${CONFIG_VLYNQ}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_VLYNQ0" ] &&  sed -i -e "s/CONFIG_VLYNQ0=\".*$/CONFIG_VLYNQ0=\"${CONFIG_VLYNQ0}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_VLYNQ1" ] &&  sed -i -e "s/CONFIG_VLYNQ1=\".*$/CONFIG_VLYNQ1=\"${CONFIG_VLYNQ1}\"/g" "${1}/etc/init.d/rc.conf"
#W920
[ "$CONFIG_VINAX_TRACE" ] &&  sed -i -e "s/CONFIG_VINAX_TRACE=\".*$/CONFIG_VINAX_TRACE=\"${CONFIG_VINAX_TRACE}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_LIBZ" ] &&  sed -i -e "s/CONFIG_LIBZ=\".*$/CONFIG_LIBZ=\"${CONFIG_LIBZ}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_DSL_MULTI_LANGUAGE" ] &&  sed -i -e "s/CONFIG_DSL_MULTI_LANGUAGE=\".*$/CONFIG_DSL_MULTI_LANGUAGE=\"${CONFIG_DSL_MULTI_LANGUAGE}\"/g" "${1}/etc/init.d/rc.conf"
#W503
[ "$CONFIG_MEDIASRV" ] &&  sed -i -e "s/CONFIG_MEDIASRV=\".*$/CONFIG_MEDIASRV=\"${CONFIG_MEDIASRV}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_CAPI_NT" ] &&  sed -i -e "s/CONFIG_CAPI_NT=\".*$/CONFIG_CAPI_NT=\"${CONFIG_CAPI_NT}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_REMOTE_HTTPS" ] &&  sed -i -e "s/CONFIG_REMOTE_HTTPS=\".*$/CONFIG_REMOTE_HTTPS=\"${CONFIG_REMOTE_HTTPS}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_DECT_MONI" ] &&  sed -i -e "s/CONFIG_DECT_MONI=\".*$/CONFIG_DECT_MONI=\"${CONFIG_DECT_MONI}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_DECT2" ] &&  sed -i -e "s/CONFIG_DECT2=\".*$/CONFIG_DECT2=\"${CONFIG_DECT2}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_USB_HOST" ] &&  sed -i -e "s/CONFIG_USB_HOST=\".*$/CONFIG_USB_HOST=\"${CONFIG_USB_HOST}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_USB_STORAGE" ] &&  sed -i -e "s/CONFIG_USB_STORAGE=\".*$/CONFIG_USB_STORAGE=\"${CONFIG_USB_STORAGE}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_USB_WLAN_AUTH" ] &&  sed -i -e "s/CONFIG_USB_WLAN_AUTH=\".*$/CONFIG_USB_WLAN_AUTH=\"${CONFIG_USB_WLAN_AUTH}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_USB_PRINT_SERV" ] &&  sed -i -e "s/CONFIG_USB_PRINT_SERV=\".*$/CONFIG_USB_PRINT_SERV=\"${CONFIG_USB_PRINT_SERV}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_VOL_COUNTER" ] &&  sed -i -e "s/CONFIG_VOL_COUNTER=\".*$/CONFIG_VOL_COUNTER=\"${CONFIG_VOL_COUNTER}\"/g" "${1}/etc/init.d/rc.conf"

#[ "$" ] &&  sed -i -e "s/=\".*$/=\"${}\"/g" "${1}/etc/init.d/rc.conf"

# set hostname
[ "$HOSTNAME" ] &&  echo2 "-- Setting 'HOSTNAME=${HOSTNAME}'"
[ "$HOSTNAME" ] &&  sed -i -e "s/HOSTNAME=\".*$/HOSTNAME=\"${HOSTNAME}\"/g" "${1}/etc/init.d/rc.conf"
# Changing productname
[ "$NEWNAME" ] &&  echo2 "-- Change Productname to: ${NEWNAME}"
[ "$NEWNAME" ] &&  sed -i -e "s/PRODUKT_NAME=\".*$/PRODUKT_NAME=\"${NEWNAME}\"/g" "${1}/etc/init.d/rc.conf"
#---------------
cat "${1}/etc/init.d/rc.conf" | grep 'export CONFIG_.*=' | sort > 2_init.log
diff 1_init.log 2_init.log | grep 'export CONFIG_.*=' > 0_init.diff
rm *init.log
exit 0