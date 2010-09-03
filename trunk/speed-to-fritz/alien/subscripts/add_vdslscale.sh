#!/bin/bash
 . $include_modpatch
    echo "-- add missing VDSL scale images"
for DIR in $2; do
# if [ "$DIR" = "avme" ] ; then
#  html="$avm_Lang/html"
# else
  html="html"
# fi
    DIRI="usr/www/$DIR/$html/de"
    TREE="$DIRI/images"
	if [ -d "$1"/$TREE ]; then
	    cp -fdpr  $P_DIR/bitSnr_carriers_vdsl.gif  --target-directory="$1/${TREE}"
	    cp -fdpr  $P_DIR/bitSnr_frequencies_vdsl.gif  --target-directory="$1/${TREE}"
	fi
done
exit 0
