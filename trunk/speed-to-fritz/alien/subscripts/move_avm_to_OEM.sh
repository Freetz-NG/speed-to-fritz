#!/bin/bash
# include modpatch function
. ${include_modpatch}
[ "${OEM}" = "tcom" ] && exit 0
#oems in this list are oems with firmwares misseing avme or avm as oem
#order of oem's may be important if a firmware has more as one oem
#move freenet hansenet avm or avme oem dir to $OEM
for oem_dir in freenet hansenet avm avme; do
  ! [ -d "$1/etc/default.${SORCE_PRODUKT}/$OEM" ] &&\
  [ -d "$1/etc/default.${SORCE_PRODUKT}/$oem_dir" ] && mv "$1/etc/default.${SORCE_PRODUKT}/$oem_dir" "$1/etc/default.${SORCE_PRODUKT}/$OEM" &&\
  echo "-- moved /etc/default.${CONFIG_PRODUKT}/$oem_dir to $OEM"
 ##echo "---->OEM: $OEM"
 for wwwdir in usr/www usr/www.nas; do
  webdir="${1}/${wwwdir}"
  [ -d "${webdir}" ] && \
   ! [ -d "${webdir}/${OEM}" ] && \
    [ -d "${webdir}/$oem_dir" ] &&  mv "${webdir}/$oem_dir" "${webdir}/${OEM}" && echo "   moved $wwwdir/$oem_dir to $wwwdir/${OEM}"
 done
done
exit 0