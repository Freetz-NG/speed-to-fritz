#!/bin/bash
 # include modpatch function
 . ${include_modpatch}
#move freenet oem dir to avm
if ! [ -d "$1/etc/default.${SORCE_PRODUKT}/avm" ]; then
 [ -d "$1/etc/default.${SORCE_PRODUKT}/freenet" ] && mv "$1/etc/default.${SORCE_PRODUKT}/freenet" "$1/etc/default.${SORCE_PRODUKT}/avm"
fi
for webdir in ${1}/usr/www ${1}/usr/www.nas; do
 if ! [ -d "${webdir}/avm" ]; then
  [ -d "${webdir}/freenet" ] &&  mv "${webdir}/freenet" "${webdir}/avm"
 fi
 for DIR in ${OEMLIST}; do
    if [ -d ${webdir}/$DIR ] ; then
	[ "$DIR" = "all" ] && rm -fd -R ${webdir}/$OEM
	[ "$DIR" = "all" ] && mv ${webdir}/all  ${webdir}/$OEM && echo2 "-- Moving /www/all to /www/$OEM ..." 
        [ "$DIR" != "$OEM" ] && rm -fd -R ${webdir}/${DIR} && echo2 "-- Removed directory: www/$DIR"
    fi
    [ -L ${webdir}/$DIR ] && [ "$DIR" != "$OEM" ] && rm -fd -R ${webdir}/${DIR} && echo2 "-- Removed link: www/'$DIR'"
 done
 #add link for all, should solve freetz OPenVPN Problem
 [ -d ${webdir}/$OEMLINK ] && ln -sf ${webdir}/$OEMLINK ${webdir}/all
done
exit 0
