#!/bin/bash
# include modpatch function
. $include_modpatch
#echo "-- Adding Header ..."
for DIR in ${OEMLIST}; do
    HTML="$DIR/html"
    DSTI="$SRC"/usr/www/$HTML/de
    if [ -d ${DSTI}/images ] ; then
	[ -f $P_DIR/fw_header980.gif ] && [ -f "$SRC"/usr/www/${HTML}/de/images/fw_header980.gif ] && cp -fdpr  $P_DIR/fw_header980.gif  --target-directory="$SRC"/usr/www/${HTML}/de/images &&\
	 echo "-- Added header: /usr/www/${HTML}/de/images/fw_header980.gif"
	[ -f $P_DIR/fw_header.gif ] && [ -f "$SRC"/usr/www/${HTML}/de/images/fw_header.gif ] && cp -fdpr  $P_DIR/fw_header.gif  --target-directory="$SRC"/usr/www/${HTML}/de/images &&\
	echo "-- Added header: /usr/www/${HTML}/de/images/fw_header.gif"
	# 17675
	[ -f $P_DIR/kopfbalken.gif ] && [ -f "$SRC"/usr/www/${HTML}/de/images/kopfbalken.gif ] && cp -fdpr  $P_DIR/kopfbalken.gif  --target-directory="$SRC"/usr/www/${HTML}/de/images &&\
	echo "-- Added header: /usr/www/$DIR/css/default/images/kopfbalken.gif"
	[ -f $P_DIR/kopfbalken_mitte.gif ] && [ -f "$SRC"/usr/www/$DIR/css/default/images/kopfbalken_mitte.gif ] && cp -fdpr  $P_DIR/kopfbalken_mitte.gif  --target-directory="$SRC"/usr/www/$DIR/css/default/images &&\
	echo "-- Added header: /usr/www/$DIR/css/default/images/kopfbalken_mitte.gif"
    fi
done
exit 0

