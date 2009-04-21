#!/bin/bash
 # include modpatch function
 . ${include_modpatch}
for DIR in ${OEMLIST}; do
    if [ -d "$1"/usr/www/$DIR ] ; then
	[ "$DIR" = "all" ] && rm -fd -R "$1"/usr/www/$OEM
	[ "$DIR" = "all" ] && mv "$1"/usr/www/all  "$1"/usr/www/$OEM && echo2 "-- Moving /www/all to /www/$OEM ..." 
        [ "$DIR" != "$OEM" ] && rm -fd -R "$1"/usr/www/${DIR} && echo2 "-- Removed directory: www/$DIR"
    fi
    [ -L "$1"/usr/www/$DIR ] && [ "$DIR" != "$OEM" ] && rm -fd -R "$1"/usr/www/${DIR} && echo2 "-- Removed link: www/'$DIR'"
done
#add link for all, should solve freetz OPenVPN Problem
[ -d "$1"/usr/www/$OEMLINK ] && ln -sf /usr/www/$OEMLINK "$1/usr/www/all"

exit 0




