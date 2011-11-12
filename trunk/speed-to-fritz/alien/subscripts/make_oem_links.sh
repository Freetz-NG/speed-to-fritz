#!/bin/bash
 # include modpatch function
 . ${include_modpatch}
 echo "-- add oem links ..."
 oems="all"
 ! [ "$DONT_LINK_OENDIRS" == "y" ] && ! [ "$PATCH_OEM" == "y" ] && oems=$OEMLINKS
 for DIR in $oems; do
  #echo "--->DIR: $DIR"
  for wwwdir in usr/www usr/www.nas; do
    webdir="${1}/${wwwdir}"
    if [ -d ${webdir}/$DIR ] ; then
    	    [ "$DIR" != "$OEM" ] && rm -fr ${webdir}/${DIR} && echo2 "-- removed directory: $wwwdir/$DIR"
	    [ -L ${webdir}/$DIR ] && [ "$DIR" != "$OEM" ] && rm -fr ${webdir}/${DIR} && echo2 "   removed link: $wwwdir/$DIR"
    fi
	    #add link for all, solve freetz OPenVPN Problem
	    [ -d ${webdir}/$OEM ] && [ "$DIR" != "$OEM" ] && ln -sf ${webdir}/$OEM ${webdir}/$DIR && echo2 "   added link: $wwwdir/$DIR"
	    [ ! -L "${1}/etc/default.${CONFIG_PRODUKT}/$DIR" ] && ln -s /etc/default.${CONFIG_PRODUKT}/${OEM} "${1}/etc/default.${CONFIG_PRODUKT}/$DIR"
  done
 done
exit 0
