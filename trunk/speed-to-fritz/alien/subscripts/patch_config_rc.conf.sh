#!/bin/bash
. ${include_modpatch}
cat "${1}/etc/init.d/rc.conf" | grep 'export CONFIG_.*=' | sort > 1_init.log
#set some variabels  
echo2 "-- Adjusting config parms in:"
echo2 "      /etc/init.d/rc.conf"
echo2 "-- Changing product to ${CONFIG_PRODUKT}"
# set hostname
# Changing product, is important becaus is used for directorys
sed -i -e "s/PRODUKT=\".*$/PRODUKT=\"${CONFIG_PRODUKT}\"/g" "${1}/etc/init.d/rc.conf"
#_____________________________________________________________________________________________________________________#
[ "$CONFIG_INSTALL_TYPE" ] &&  sed -i -e "s/CONFIG_INSTALL_TYPE=\".*$/CONFIG_INSTALL_TYPE=\"${CONFIG_INSTALL_TYPE}\"/g" "${1}/etc/init.d/rc.conf"
#sed -i -e "s/CONFIG_XILINX=\".*$/CONFIG_XILINX=\"${CONFIG_XILINX}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_DECT" ] &&  sed -i -e "s/CONFIG_DECT=\".*$/CONFIG_DECT=\"${CONFIG_DECT}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_ROMSIZE" ] &&  sed -i -e "s/CONFIG_ROMSIZE=\".*$/CONFIG_ROMSIZE=\"${CONFIG_ROMSIZE}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_RAMSIZE" ] &&  sed -i -e "s/CONFIG_RAMSIZE=\".*$/CONFIG_RAMSIZE=\"${CONFIG_RAMSIZE}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_ETH_COUNT" ] &&  sed -i -e "s/CONFIG_ETH_COUNT=\".$/CONFIG_ETH_COUNT=\"${CONFIG_ETH_COUNT}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_AB_COUNT" ] &&  sed -i -e "s/CONFIG_AB_COUNT=\".*$/CONFIG_AB_COUNT=\"${CONFIG_AB_COUNT}\"/g" "${1}/etc/init.d/rc.conf"
# if Tr069 is enablt then AtA must be disabelt
[ "$CONFIG_TR069" ] ||  sed -i -e "s/CONFIG_ATA=\".*$/CONFIG_ATA=\"${CONFIG_ATA}\"/g" "${1}/etc/init.d/rc.conf"
#sed -i -e "s/CONFIG_ONLINEHELP=\".*$/CONFIG_ONLINEHELP=\"${CONFIG_ONLINEHELP}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_TR069" ] &&  sed -i -e "s/TR069=\".*$/TR069=\"${CONFIG_TR069}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_TR064" ] &&  sed -i -e "s/CONFIG_TR064=\".*$/CONFIG_TR064=\"${CONFIG_TR064}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_DECT_ONOFF" ] &&  sed -i -e "s/CONFIG_DECT_ONOFF=\".*$/CONFIG_DECT_ONOFF=\"${CONFIG_DECT_ONOFF}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_LED_NO_DSL_LED" ] &&  sed -i -e "s/CONFIG_LED_NO_DSL_LED=\".*$/CONFIG_LED_NO_DSL_LED=\"${CONFIG_LED_NO_DSL_LED}\"/g" "${1}/etc/init.d/rc.conf"
#----
sed -i -e "s|CONFIG_SERVICEPORTAL_URL=\".*$|CONFIG_SERVICEPORTAL_URL=\"${CONFIG_SERVICEPORTAL_URL}\"|g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_DSL" ] &&  sed -i -e "s/CONFIG_DSL=\".*$/CONFIG_DSL=\"${CONFIG_DSL}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_VDSL" ] &&  sed -i -e "s/CONFIG_VDSL=\".*$/CONFIG_VDSL=\"${CONFIG_VDSL}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_DSL_UR8" ] &&  sed -i -e "s/CONFIG_DSL_UR8=\".*$/CONFIG_DSL_UR8=\"${CONFIG_DSL_UR8}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_LABOR_DSL" ] &&  sed -i -e "s/CONFIG_LABOR_DSL=\".*$/CONFIG_LABOR_DSL=\"${CONFIG_LABOR_DSL}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_DSL_MULTI_ANNEX" ] &&  sed -i -e "s/CONFIG_DSL_MULTI_ANNEX=\".*$/CONFIG_DSL_MULTI_ANNEX=\"${CONFIG_DSL_MULTI_ANNEX}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_ATA_FULL" ] &&  sed -i -e "s/CONFIG_ATA_FULL=\".*$/CONFIG_ATA_FULL=\"${CONFIG_ATA_FULL}\"/g" "${1}/etc/init.d/rc.conf"
#W721
[ "$CONFIG_VINAX" ] && ! `grep -q 'CONFIG_VINAX=' "${1}/etc/init.d/rc.conf"` &&
sed -i -e "/CONFIG_DSL/a\
export CONFIG_VINAX=\"${CONFIG_VINAX}\"" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_VINAX" ] &&  sed -i -e "s/CONFIG_VINAX=\".*$/CONFIG_VINAX=\"${CONFIG_VINAX}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_VLYNQ_PARAMS" ] &&  sed -i -e "s/CONFIG_VLYNQ_PARAMS=\".*$/CONFIG_VLYNQ_PARAMS=\"${CONFIG_VLYNQ_PARAMS}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_VLYNQ" ] &&  sed -i -e "s/CONFIG_VLYNQ=\".*$/CONFIG_VLYNQ=\"${CONFIG_VLYNQ}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_VLYNQ0" ] &&  sed -i -e "s/CONFIG_VLYNQ0=\".*$/CONFIG_VLYNQ0=\"${CONFIG_VLYNQ0}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_VLYNQ1" ] &&  sed -i -e "s/CONFIG_VLYNQ1=\".*$/CONFIG_VLYNQ1=\"${CONFIG_VLYNQ1}\"/g" "${1}/etc/init.d/rc.conf"

#[ "$CONFIG_FONBOOK2" ] &&  sed -i -e "s/CONFIG_FONBOOK2=\".*$/CONFIG_FONBOOK2=\"${CONFIG_FONBOOK2}\"/g" "${1}/etc/init.d/rc.conf"
#[ "$CONFIG_T38" ] &&  sed -i -e "s/CONFIG_T38=\".*$/CONFIG_T38=\"${CONFIG_T38}\"/g" "${1}/etc/init.d/rc.conf"
#[ "$CONFIG_AURA" ] &&  sed -i -e "s/CONFIG_AURA=\".*$/CONFIG_AURA=\"${CONFIG_AURA}\"/g" "${1}/etc/init.d/rc.conf"
#[ "$CONFIG_AUDIO" ] &&  sed -i -e "s/CONFIG_AUDIO=\".*$/CONFIG_AUDIO=\"${CONFIG_AUDIO}\"/g" "${1}/etc/init.d/rc.conf"
#[ "$CONFIG_WLAN_TCOM_PRIO" ] &&  sed -i -e "s/CONFIG_WLAN_TCOM_PRIO=\".*$/CONFIG_WLAN_TCOM_PRIO=\"${CONFIG_WLAN_TCOM_PRIO}\"/g" "${1}/etc/init.d/rc.conf"
#[ "$CONFIG_MEDIACLI" ] &&  sed -i -e "s/CONFIG_MEDIACLI=\".*$/CONFIG_MEDIACLI=\"${CONFIG_MEDIACLI}\"/g" "${1}/etc/init.d/rc.conf"
#[ "$CONFIG_FAXSUPPORT" ] &&  sed -i -e "s/CONFIG_FAXSUPPORT=\".*$/CONFIG_FAXSUPPORT=\"${CONFIG_FAXSUPPORT}\"/g" "${1}/etc/init.d/rc.conf"
#[ "$CONFIG_SAMBA" ] &&  sed -i -e "s/CONFIG_SAMBA=\".*$/CONFIG_SAMBA=\"${CONFIG_SAMBA}\"/g" "${1}/etc/init.d/rc.conf"
#[ "$CONFIG_JFFS2" ] &&  sed -i -e "s/CONFIG_JFFS2=\".*$/CONFIG_JFFS2=\"${CONFIG_JFFS2}\"/g" "${1}/etc/init.d/rc.conf"
#[ "$CONFIG_FAX2MAIL" ] &&  sed -i -e "s/CONFIG_FAX2MAIL=\".*$/CONFIG_FAX2MAIL=\"${CONFIG_FAX2MAIL}\"/g" "${1}/etc/init.d/rc.conf"
#[ "$CONFIG_TAM_MODE" ] &&  sed -i -e "s/CONFIG_TAM_MODE=\".*$/CONFIG_TAM_MODE=\"${CONFIG_TAM_MODE}\"/g" "${1}/etc/init.d/rc.conf"
#[ "$CONFIG_IGD" ] &&  sed -i -e "s/CONFIG_IGD=\".*$/CONFIG_IGD=\"${CONFIG_IGD}\"/g" "${1}/etc/init.d/rc.conf"
#[ "$CONFIG_UPNP" ] &&  sed -i -e "s/CONFIG_UPNP=\".*$/CONFIG_UPNP=\"${CONFIG_UPNP}\"/g" "${1}/etc/init.d/rc.conf"
#[ "$CONFIG_MAILER2" ] &&  sed -i -e "s/CONFIG_MAILER2=\".*$/CONFIG_MAILER2=\"${CONFIG_MAILER2}\"/g" "${1}/etc/init.d/rc.conf"
#[ "$CONFIG_ECO" ] &&  sed -i -e "s/CONFIG_ECO=\".*$/CONFIG_ECO=\"${CONFIG_ECO}\"/g" "${1}/etc/init.d/rc.conf"
##[ "$CONFIG_STOREUSRCFG" ] &&  sed -i -e "s/CONFIG_STOREUSRCFG=\".*$/CONFIG_STOREUSRCFG=\"${CONFIG_STOREUSRCFG}\"/g" "${1}/etc/init.d/rc.conf"
#[ "$CONFIG_TAM" ] &&  sed -i -e "s/CONFIG_TAM=\".*$/CONFIG_TAM=\"${CONFIG_TAM}\"/g" "${1}/etc/init.d/rc.conf"
#[ "$CONFIG_ACCESSORY_URL" ] &&  sed -i -e "s/CONFIG_ACCESSORY_URL=\".*$/CONFIG_ACCESSORY_URL=\"${CONFIG_ACCESSORY_URL}\"/g" "${1}/etc/init.d/rc.conf"

#W722
[ "$CONFIG_USB_HOST_TI" ] &&  sed -i -e "s/CONFIG_USB_HOST_TI=\".*$/CONFIG_USB_HOST_TI=\"${CONFIG_USB_HOST_TI}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_USB_STORAGE_SPINDOWN" ] &&  sed -i -e "s/CONFIG_USB_STORAGE_SPINDOWN=\".*$/CONFIG_USB_STORAGE_SPINDOWN=\"${CONFIG_USB_STORAGE_SPINDOWN}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_USB_INTERNAL_HUB" ] &&  sed -i -e "s/CONFIG_USB_INTERNAL_HUB=\".*$/CONFIG_USB_INTERNAL_HUB=\"${CONFIG_USB_INTERNAL_HUB}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_USB" ] &&  sed -i -e "s/CONFIG_USB=\".*$/CONFIG_USB=\"${CONFIG_USB}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_CAPI_MIPS" ] &&  sed -i -e "s/CONFIG_CAPI_MIPS=\".*$/CONFIG_CAPI_MIPS=\"${CONFIG_CAPI_MIPS}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_CAPI_UBIK" ] &&  sed -i -e "s/CONFIG_CAPI_UBIK=\".*$/CONFIG_CAPI_UBIK=\"${CONFIG_CAPI_UBIK}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_CAPI" ] &&  sed -i -e "s/CONFIG_CAPI=\".*$/CONFIG_CAPI=\"${CONFIG_CAPI}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_WLAN_TCOM_PRIO" ] &&  sed -i -e "s/CONFIG_WLAN_TCOM_PRIO=\".*$/CONFIG_WLAN_TCOM_PRIO=\"${CONFIG_WLAN_TCOM_PRIO}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_WLAN_WDS" ] &&  sed -i -e "s/CONFIG_WLAN_WDS=\".*$/CONFIG_WLAN_WDS=\"${CONFIG_WLAN_WDS}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_WLAN_TXPOWER" ] &&  sed -i -e "s/CONFIG_WLAN_TXPOWER=\".*$/CONFIG_WLAN_TXPOWER=\"${CONFIG_WLAN_TXPOWER}\"/g" "${1}/etc/init.d/rc.conf"
#[ "$" ] &&  sed -i -e "s/=\".*$/=\"${}\"/g" "${1}/etc/init.d/rc.conf"

#W920
[ "$CONFIG_VINAX_TRACE" ] && ! `grep -q 'CONFIG_VINAX_TRACE=' "${1}/etc/init.d/rc.conf"` &&\
sed -i -e "/CONFIG_VINAX/a\
export CONFIG_VINAX_TRACE=\"${CONFIG_VINAX_TRACE}\"" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_VINAX_TRACE" ] &&  sed -i -e "s/CONFIG_VINAX_TRACE=\".*$/CONFIG_VINAX_TRACE=\"${CONFIG_VINAX_TRACE}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_LIBZ" ] &&  sed -i -e "s/CONFIG_LIBZ=\".*$/CONFIG_LIBZ=\"${CONFIG_LIBZ}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_MULTI_LANGUAGE" ] &&  sed -i -e "s/CONFIG_MULTI_LANGUAGE=\".*$/CONFIG_MULTI_LANGUAGE=\"${CONFIG_MULTI_LANGUAGE}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_MULTI_COUNTRY" ] &&  sed -i -e "s/CONFIG_MULTI_COUNTRY=\".*$/CONFIG_MULTI_COUNTRY=\"${CONFIG_MULTI_COUNTRY}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_DIAGNOSE_LEVEL" ] &&  sed -i -e "s/CONFIG_DIAGNOSE_LEVEL=\".*$/CONFIG_DIAGNOSE_LEVEL=\"${CONFIG_DIAGNOSE_LEVEL}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_PROV_DEFAULT" ] &&  sed -i -e "s/CONFIG_PROV_DEFAULT=\".*$/CONFIG_PROV_DEFAULT=\"${CONFIG_PROV_DEFAULT}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_BOX_FEEDBACK" ] &&  sed -i -e "s/CONFIG_BOX_FEEDBACK=\".*$/CONFIG_BOX_FEEDBACK=\"${CONFIG_BOX_FEEDBACK}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_TAM_ONRAM" ] &&  sed -i -e "s/CONFIG_TAM_ONRAM=\".*$/CONFIG_TAM_ONRAM=\"${CONFIG_TAM_ONRAM}\"/g" "${1}/etc/init.d/rc.conf"
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
#W500
[ "$CONFIG_ETH_COUNT" ] &&  sed -i -e "s/CONFIG_ETH_COUNT=\".*$/CONFIG_ETH_COUNT=\"${CONFIG_ETH_COUNT}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_EXPERT" ] &&  sed -i -e "s/CONFIG_EXPERT=\".*$/CONFIG_EXPERT=\"${CONFIG_EXPERT}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_FONGUI2" ] &&  sed -i -e "s/CONFIG_FONGUI2=\".*$/CONFIG_FONGUI2=\"${CONFIG_FONGUI2}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_IPONE" ] &&  sed -i -e "s/CONFIG_IPONE=\".*$/CONFIG_IPONE=\"${CONFIG_IPONE}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_UPNP" ] &&  sed -i -e "s/CONFIG_UPNP=\".*$/CONFIG_UPNP=\"${CONFIG_UPNP}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_FON_HD" ] &&  sed -i -e "s/CONFIG_FON_HD=\".*$/CONFIG_FON_HD=\"${CONFIG_FON_HD}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_CAPI_TE" ] &&  sed -i -e "s/CONFIG_CAPI_TE=\".*$/CONFIG_CAPI_TE=\"${CONFIG_CAPI_TE}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_CAPI_XILINX" ] &&  sed -i -e "s/CONFIG_CAPI_XILINX=\".*$/CONFIG_CAPI_XILINX=\"${CONFIG_CAPI_XILINX}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_USB_HOST_AVM" ] &&  sed -i -e "s/CONFIG_USB_HOST_AVM=\".*$/CONFIG_USB_HOST_AVM=\"${CONFIG_USB_HOST_AVM}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_WLAN_WMM" ] &&  sed -i -e "s/CONFIG_WLAN_WMM=\".*$/CONFIG_WLAN_WMM=\"${CONFIG_WLAN_WMM}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_WLAN_WPS" ] &&  sed -i -e "s/CONFIG_WLAN_WPS=\".*$/CONFIG_WLAN_WPS=\"${CONFIG_WLAN_WPS}\"/g" "${1}/etc/init.d/rc.conf"
#7270v3
[ "$CONFIG_DECT_14488" ] &&  sed -i -e "s/CONFIG_DECT_14488=\".*$/CONFIG_DECT_14488=\"${CONFIG_DECT_14488}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_CAPI_POTS" ] &&  sed -i -e "s/CONFIG_CAPI_POTS=\".*$/CONFIG_CAPI_POTS=\"${CONFIG_CAPI_POTS}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_PLUGIN" ] &&  sed -i -e "s/CONFIG_PLUGIN=\".*$/CONFIG_PLUGIN=\"${CONFIG_PLUGIN}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_PROV_DEFAULT" ] &&  sed -i -e "s/CONFIG_PROV_DEFAULT=\".*$/CONFIG_PROV_DEFAULT=\"${CONFIG_PROV_DEFAULT}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_FON_IPPHONE" ] &&  sed -i -e "s/CONFIG_FON_IPPHONE=\".*$/CONFIG_FON_IPPHONE=\"${CONFIG_FON_IPPHONE}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_VERSION_MAJOR" ] &&  sed -i -e "s/CONFIG_VERSION_MAJOR=\".*$/CONFIG_VERSION_MAJOR=\"${CONFIG_VERSION_MAJOR}\"/g" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_ATA_NOPASSTHROUGH" ] &&  sed -i -e "s/CONFIG_ATA_NOPASSTHROUGH=\".*$/CONFIG_ATA_NOPASSTHROUGH=\"${CONFIG_ATA_NOPASSTHROUGH}\"/g" "${1}/etc/init.d/rc.conf"

[ "$CONFIG_DECT_14488" ] &&  ! `grep -q 'CONFIG_DECT_14488=' "${1}/etc/init.d/rc.conf"` && sed -i -e "/CONFIG_MAILER2/i\
export CONFIG_DECT_14488=\"${CONFIG_DECT_14488}\"" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_CAPI_POTS" ] &&  ! `grep -q 'CONFIG_CAPI_POTS=' "${1}/etc/init.d/rc.conf"` && sed -i -e "/CONFIG_MAILER2/i\
export CONFIG_CAPI_POTS=\"${CONFIG_CAPI_POTS}\"" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_PLUGIN" ] &&  ! `grep -q 'CONFIG_PLUGIN=' "${1}/etc/init.d/rc.conf"` && sed -i -e "/CONFIG_MAILER2/i\
export CONFIG_PLUGIN=\"${CONFIG_PLUGIN}\"" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_PROV_DEFAULT" ] &&  ! `grep -q 'CONFIG_PROV_DEFAULT=' "${1}/etc/init.d/rc.conf"` && sed -i -e "/CONFIG_MAILER2/i\
export CONFIG_PROV_DEFAULT=\"${CONFIG_PROV_DEFAULT}\"" "${1}/etc/init.d/rc.conf"
[ "$CONFIG_FON_IPPHONE" ] &&  ! `grep -q 'CONFIG_FON_IPPHONE=' "${1}/etc/init.d/rc.conf"` && sed -i -e "/CONFIG_MAILER2/i\
export CONFIG_FON_IPPHONE=\"${CONFIG_FON_IPPHONE}\"" "${1}/etc/init.d/rc.conf"

#[ "$" ] &&  ! `grep -q '=' "${1}/etc/init.d/rc.conf"` && sed -i -e "/CONFIG_DSL/a\
#export =\"${}\"/" "${1}/etc/init.d/rc.conf"
#[ "$" ] &&  sed -i -e "s/=\".*$/=\"${}\"/g" "${1}/etc/init.d/rc.conf"

# set hostname
[ "$HOSTNAME" ] &&  echo2 "-- Setting 'HOSTNAME=${HOSTNAME}'"
[ "$HOSTNAME" ] &&  sed -i -e "s/HOSTNAME=\".*$/HOSTNAME=\"${HOSTNAME}\"/g" "${1}/etc/init.d/rc.conf"
# Changing productname
[ "$NEWNAME" ] &&  echo2 "-- Change Productname to: ${NEWNAME}"
[ "$NEWNAME" ] &&  sed -i -e "s/PRODUKT_NAME=\".*$/PRODUKT_NAME=\"${NEWNAME}\"/g" "${1}/etc/init.d/rc.conf"
# override environment settings for Hardwardware ID
#sed -i -e "s/HWRevision=\$i/HWRevision=${HWID}/" "${SRC}/etc/init.d/rc.conf"
#---------------
cat "${1}/etc/init.d/rc.conf" | grep 'export CONFIG_.*=' | sort > 2_init.log
diff 1_init.log 2_init.log | grep 'export CONFIG_.*=' > 0_init.diff
rm *init.log
exit 0