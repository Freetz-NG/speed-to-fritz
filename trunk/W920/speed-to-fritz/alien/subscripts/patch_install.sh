#!/bin/bash
 # include modpatch function
 . ${include_modpatch}

rm -f "${1}"/var/info.txt
#cp -fdpr  ./addon/tmp/var  --target-directory="${1}"
echo "Path: ${1}"
modpatch "${1}" "$P_DIR/add_var-install.patch"

echo "#! /bin/sh" >"${1}"/var/post_install
echo "/var/install" >>"${1}"/var/post_install
chmod +x "${1}"/var/post_install

[ "${kernel_args}" != "console=ttyS0,38400" ] && kernel_args="${kernel_args} console=ttyS0,38400"

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
sed -i -e "s|kernel_size=.*$|${SP_kernel_size}|" "${1}"/var/install

[ "$FORCE_CLEAR_FLASH" = "y" ] && sed -i -e "s|force_update=n|force_update=y|" "${1}"/var/install

chmod -R 777 "${1}"/var

exit 0
