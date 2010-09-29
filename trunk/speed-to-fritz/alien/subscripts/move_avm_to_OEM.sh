#!/bin/bash
 # include modpatch function
 . ${include_modpatch}
 [ "${OEM}" = "avm" ] && exit 0
 [ "${OEM}" = "tcom" ] && exit 0
#move freenet oem dir to avm
if ! [ -d "$1/etc/default.${SORCE_PRODUKT}/avm" ]; then
 [ -d "$1/etc/default.${SORCE_PRODUKT}/freenet" ] && mv "$1/etc/default.${SORCE_PRODUKT}/freenet" "$1/etc/default.${SORCE_PRODUKT}/avm" &&\
echo "-- moved /etc/default.${CONFIG_PRODUKT}/freenet to avm"
 [ -d "$1/etc/default.${SORCE_PRODUKT}/hansenet" ] && mv "$1/etc/default.${SORCE_PRODUKT}/hanseenet" "$1/etc/default.${SORCE_PRODUKT}/avm" &&\
echo "-- moved /etc/default.${CONFIG_PRODUKT}/hansenet to avm"
fi
for webdir in ${1}/usr/www ${1}/usr/www.nas; do
 if [ -d "${webdir}" ]; then
  if ! [ -d "${webdir}/avm" ]; then
   [ -d "${webdir}/freenet" ] &&  mv "${webdir}/freenet" "${webdir}/avm" && echo "-- moved /usr/www/freenet to /usr/www/avm"
   [ -d "${webdir}/hansenet" ] &&  mv "${webdir}/hansenet" "${webdir}/avm" && echo "-- moved /usr/www/hansenet to /usr/www/avm"
  fi
  [ -d "${webdir}/${OEM}" ] ||\
  mv "${webdir}/avm" "${webdir}/${OEM}" && echo "-- moved /usr/www/avm to /usr/www/${OEM}"
 fi
done
#move avm oem dir to $OEM
[ -d "$1/etc/default.${SORCE_PRODUKT}/${OEM}" ] ||\
mv "$1/etc/default.${SORCE_PRODUKT}/avm" "$1/etc/default.${SORCE_PRODUKT}/${OEM}" &&\
echo "-- moved /etc/default.${SORCE_PRODUKT}/avm to ${OEM}"
exit 0