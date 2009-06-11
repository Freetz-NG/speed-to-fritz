#!/bin/bash
 # include modpatch function
 . ${include_modpatch}
 [ "${OEM}" = "avm" ] && exit 0
 [ "${OEM}" = "tcom" ] && exit 0
    if [ -d "${DST}"/usr/www/avm ] ; then
	rm -fd -R "${DST}"/usr/www/${OEM}
	mv "${DST}"/usr/www/avm  "${DST}"/usr/www/${OEM} && echo2 "-- Moving 1st Firmware /www/avm to /www/${OEM} ..." 
    fi
    if [ -d "${SRC}"/usr/www/avm ] ; then
	rm -fd -R "${SRC}"/usr/www/${OEM}
	mv "${SRC}"/usr/www/avm  "${SRC}"/usr/www/${OEM} && echo2 "-- Moving 2nd Firmware /www/avm to /www/${OEM} ..." 
    fi
    if [ -d "${SRC_2}"/usr/www/avm ] ; then
	rm -fd -R "${SRC_2}"/usr/www/${OEM}
	mv "${SRC_2}"/usr/www/avm  "${SRC_2}"/usr/www/${OEM} && echo2 "-- Moving 3rd Firmware /www/avm to /www/${OEM} ..." 
    fi
exit 0




