#!/bin/bash
# include modpatch function
. ${include_modpatch}
rm -f "${1}"/var/info.txt
echo "-- patch install script ..."
sed -i -e "/Force: factorysettings done./a\
##MARKER##" "${1}"/var/install
sed -i -e "/##MARKER##/,/Accept Firmware Version/d" "${1}"/var/install
sed -i -e '/echo ANNEX=$ANNEX/,/echo testing acceptance for device.*done/d' "${1}"/var/install
sed -i -e "s/_Temp_HWID_/$Temp_HWID/" "${1}"/var/install
Temp_HWID="${HWID}"
case "$HWID" in 
        135 | 146 | 153 ) Temp_HWID="135 | 146 | 153" ;;
esac
sed -i -e 's/if . -z "${ANNEX}".*/##### check hardware #####/' "${1}"/var/install
sed -i -e '/##### check hardware #####/{n;d}' "${1}"/var/install
sed -i -e '/##### check hardware #####/a\
echo testing acceptance for device ...\
hwrev="$(IFS="$IFS."; set $(grep HWRevision /proc/sys/urlader/environment); echo $2)"\
echo "HWRevision: $hwrev"\
case "$hwrev" in\
         _Temp_HWID_ | "" ) korrekt_version=1 ;;\
esac' "${1}"/var/install
sed -i -e "s/_Temp_HWID_/$Temp_HWID/" "${1}"/var/install
[ "${kernel_args}" != "console=ttyS0,38400" ] && kernel_args="${kernel_args} console=ttyS0,38400"
sed -i -e "/echo \"install: \/var\/tmp\/kernel.image to start/i \
echo kernel_args ${kernel_args} > \/proc\/sys\/urlader\/environment \n\
echo ${ANNEX} > \/proc\/sys\/urlader\/annex \n\
echo annex ${ANNEX} > \/proc\/sys\/urlader\/environment \n\
echo ${OEM} > \/proc\/sys\/urlader\/firmware_version \n\
echo firmware_version ${OEM} > \/proc\/sys\/urlader\/environment \n\
echo ${ANNEX} > \/proc\/sys\/urlader\/annex \n\
echo annex ${ANNEX} > \/proc\/sys\/urlader\/environment" "${1}"/var/install
if [ "${PROD}" == "7570_HN" ]; then
### 7570_HN: set mtd1 to max size and unset mtd5 
sed -i -e "/echo \"install: \/var\/tmp\/kernel.image to start/i \
### 7570_HN: set mtd1 to max size and unset mtd5  \n\
echo mtd1 0x90040000,0x90F80000 > /proc/sys/urlader/environment  \n\
echo mtd5 > /proc/sys/urlader/environment" "${1}"/var/install
fi
sed -i -e "s|^newFWver=.*$|newFWver=${AVM_VERSION}|" "${1}"/var/install
sed -i -e "s|# Versioninfo:.*$|${SP_Vesioninfo}|" "${1}"/var/install
sed -i -e "s|# Checkpoint:.*$|${SP_Checkpoint}|" "${1}"/var/install
[ ${kernel_start} ] && sed -i -e "s|kernel_start=[0-9]*$|kernel_start=${kernel_start}|" "${1}"/var/install
[ ${kernel_size} ] && sed -i -e "s|kernel_size=[0-9]*$|kernel_size=${kernel_size}|" "${1}"/var/install
[ ${urlader_size} ] && sed -i -e "s|urlader_size=[0-9]*$|urlader_size=${urlader_size}|" "${1}"/var/install

[ "$FORCE_CLEAR_FLASH" = "y" ] && sed -i -e "s|force_update=n|force_update=y|" "${1}"/var/install
#---
#sed -i -e "s|korrekt_version=.|korrekt_version=1|g" "${1}"/var/install
#sed -i -e 's|echo .sleep 1. >>/var/post_install|echo "sleep 3" >>/var/post_install|' "${1}"/var/install
#--

sed -i -e '/bin.update_led_on/i \
sed -i -e "\/var.install\/d" \/var\/post_install\
cat \/var\/post_install > \/dev\/console\
' "${1}"/var/install


#[ -f "${1}"/var.tar/var/post_install ] &&  cp "${1}"/var.tar/var/post_install "${1}"/var/post_install
! [ -f "${1}"/var/post_install ] &&  echo "#! /bin/sh" >"${1}"/var/post_install
echo "echo 'xxxxxxxxxxxxxxxxxxxx post_install xxxxxxxxxxxxxxxxxxxxx'" >>"${1}"/var/post_install
echo "/var/install" >>"${1}"/var/post_install
chmod +x "${1}"/var/post_install
chmod -R 777 "${1}"/var
exit 0

sed -i -e '/bin.update_led_on/i \
if [ "$CONFIG_HOSTNAME" == "speedport.ip" ]; then\
  rm \/var\/post_install\
  sleep 2\
  echo -->move > \/dev\/console\
  mv \/var\/p_install \/var\/post_install\
fi' "${1}"/var/install
