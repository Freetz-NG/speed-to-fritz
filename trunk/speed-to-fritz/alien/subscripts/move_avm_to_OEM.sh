#!/bin/bash
 # include modpatch function
 . ${include_modpatch}
 [ "${OEM}" = "avm" ] && exit 0
 [ "${OEM}" = "tcom" ] && exit 0
#move freenet oem dir to avm
if ! [ -d "$1/etc/default.${SORCE_PRODUKT}/avm" ]; then
 [ -d "$1/etc/default.${SORCE_PRODUKT}/freenet" ] && mv "$1/etc/default.${SORCE_PRODUKT}/freenet" "$1/etc/default.${SORCE_PRODUKT}/avm" &&\
echo "  -- moved /etc/default.${CONFIG_PRODUKT}/freenet to avm"
fi
if ! [ -d "$1/usr/www/avm" ]; then
 [ -d "$1/usr/www/freenet" ] &&  mv "$1/usr/www/freenet" "$1/usr/www/avm" && echo "  -- moved /usr/www/freenet to /usr/www/avm"
fi
#move avm oem dir to $OEM
[ -d "$1/etc/default.${SORCE_PRODUKT}/${OEM}" ] ||\
mv "$1/etc/default.${SORCE_PRODUKT}/avm" "$1/etc/default.${SORCE_PRODUKT}/${OEM}" &&\
echo "  -- moved /etc/default.${SORCE_PRODUKT}/avm to ${OEM}"
[ -d "$1/usr/www/${OEM}" ] ||\
mv "$1/usr/www/avm" "$1/usr/www/${OEM}" && echo "  -- moved /usr/www/avm to /usr/www/${OEM}"
exit 0

