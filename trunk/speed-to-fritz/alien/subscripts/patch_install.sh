#!/bin/bash
# include modpatch function
. ${include_modpatch}
rm -f "${1}"/var/info.txt
#rm -f "${1}"/var/install
#modpatch "${1}" "$P_DIR/add_var-install.patch"
#cp -fdpr  ./addon/tmp/var  --target-directory="${1}"
#echo "Path: ${1}/var/install"
echo "--patch install script ..."
sed -i -e "/Force: factorysettings done./a\
##MARKER##" "${1}"/var/install
sed -i -e "/##MARKER##/,/Accept Firmware Version/d" "${1}"/var/install
sed -i -e '/echo ANNEX=$ANNEX/,/echo testing acceptance for device.*done/d' "${1}"/var/install
Temp_HWID="${HWID}"
case "$HWID" in 
        135 | 146 | 153 ) Temp_HWID="135 | 146 | 153" ;; 
esac
sed -i -e 's/if . -z "${ANNEX}".*/##### check hardware #####/' "${1}"/var/install
sed -i -e '/##### check hardware #####/{n;d}' "${1}"/var/install
sed -i -e '/##### check hardware #####/a\
echo testing acceptance for device ...\
/etc/version\
hwrev=`echo $(grep HWRevision < ${CONFIG_ENVIRONMENT_PATH}/environment | tr -d [:alpha:],[:blank:])`\
hwrev=${hwrev%%.*}\
echo "HWRevision: $hwrev"\
case "$hwrev" in\
         _Temp_HWID_ | "" ) korrekt_version=1 ;;\
esac' "${1}"/var/install
sed -i -e "s/_Temp_HWID_/$Temp_HWID/" "${1}"/var/install

echo "#! /bin/sh" >"${1}"/var/post_install
echo "/var/install" >>"${1}"/var/post_install
chmod +x "${1}"/var/post_install

[ "${kernel_args}" != "console=ttyS0,38400" ] && kernel_args="${kernel_args} idle=4 console=ttyS0,38400"

sed -i -e "/echo \"echo language > \/proc\/sys\/urlader\/environment\"/a \
echo \"echo kernel_args ${kernel_args} > \/proc\/sys\/urlader\/environment\" >>\/var\/post_install \n\
echo \"echo ${ANNEX} > \/proc\/sys\/urlader\/annex\" >>\/var\/post_install \n\
echo \"echo annex ${ANNEX} > \/proc\/sys\/urlader\/environment\" >>\/var\/post_install \n\
echo \"echo ${OEM} > \/proc\/sys\/urlader\/firmware_version\" >>\/var\/post_install \n\
echo \"echo firmware_version ${OEM} > \/proc\/sys\/urlader\/environment\" >>\/var\/post_install \n\
echo \"echo ${ANNEX} > \/proc\/sys\/urlader\/annex\" >>\/var\/post_install \n\
echo \"echo annex ${ANNEX} > \/proc\/sys\/urlader\/environment\" >>\/var\/post_install" "${1}"/var/install

sed -i -e "s|^newFWver=.*$|newFWver=${AVM_VERSION}|" "${1}"/var/install
sed -i -e "s|# Versioninfo:.*$|${SP_Vesioninfo}|" "${1}"/var/install
sed -i -e "s|# Checkpoint:.*$|${SP_Checkpoint}|" "${1}"/var/install
sed -i -e "s|kernel_size=[1-9].*$|${SP_kernel_size}|" "${1}"/var/install

[ ${kernel_start} ] && sed -i -e "s|kernel_start=.*$|kernel_start=${kernel_start}|" "${1}"/var/install
[ ${urlader_size} ] && sed -i -e "s|urlader_size=.*$|urlader_size=${urlader_size}|" "${1}"/var/install

[ "$FORCE_CLEAR_FLASH" = "y" ] && sed -i -e "s|force_update=n|force_update=y|" "${1}"/var/install

chmod -R 777 "${1}"/var

exit 0
sed -i -e '/##### check hardware #####/a\
hwrev=`echo $(grep HWRevision < ${CONFIG_ENVIRONMENT_PATH}/environment)`\
hwrev=${hwrev%%.*}\
case "$hwrev" in\
         _Temp_HWID_ ) korrekt_version=1 ;;\
esac\
if ["$hwrev" == "" ]; then\
korrekt_version=1' "${1}"/var/install
sed -i -e "s/_Temp_HWID_/$Temp_HWID/" "${1}"/var/install
