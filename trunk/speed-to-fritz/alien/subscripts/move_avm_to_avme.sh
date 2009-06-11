#!/bin/bash
 # include modpatch function
 . ${include_modpatch}
    if [ -d "$DST"/usr/www/avm ] ; then
	rm -fd -R "$DST"/usr/www/avme
	mv "$DST"/usr/www/avm  "$DST"/usr/www/avme && echo2 "-- Moving 1st Firmware /www/avm to /www/avme ..." 
    fi
    if [ -d "$SRC"/usr/www/avm ] ; then
	rm -fd -R "$SRC"/usr/www/avme
	mv "$SRC"/usr/www/avm  "$SRC"/usr/www/avme && echo2 "-- Moving 2nd Firmware /www/avm to /www/avme ..." 
    fi
    if [ -d "$SRC_2"/usr/www/avm ] ; then
	rm -fd -R "$SRC_2"/usr/www/avme
	mv "$SRC_2"/usr/www/avm  "$SRC_2"/usr/www/avme && echo2 "-- Moving 3rd Firmware /www/avm to /www/avme ..." 
    fi
exit 0




