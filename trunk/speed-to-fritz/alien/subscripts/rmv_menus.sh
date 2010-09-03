#!/bin/bash
[ "$CONFIG_IsdnNT" = "0" ] && echo "-- removing 'internal S0', from setup page ..."
[ "$CONFIG_IsdnTE" = "0" ] && echo "-- removing 'external ISDN', from setup page ..."
[ "$CONFIG_Usb" = "0" ] && echo "-- removing 'USB' from setup page ..."
[ "$CONFIG_AB_COUNT" = "2" ] && echo "-- removing 'internal FON 3', from setup page ..."
[ "$CONFIG_ETH_COUNT" = "1" ] && echo "-- removing 'ETH 2-4', from setup page ..."
[ "$ATA_ONLY" = "y" ] && echo "-- disable ADSL Option, from setup page ..."
#[ "$CONFIG_DECT" = "n" ] && echo "-- Removing 'DECT' from setup page ..."

for DIR in ${OEMLIST}; do
  export HTML="$DIR/html"
    DSTI="${1}"/usr/www/$HTML
    if [ -d ${DSTI} ] ; then
     [ "$CONFIG_Usb" = "0" ] && $sh_DIR/rmv_usb "$1"
     [ "$CONFIG_IsdnNT" = "0" ] &&   $sh_DIR/rmv_isdn_s0 "$1"
     [ "$CONFIG_IsdnTE" = "0" ] &&   $sh_DIR/rmv_isdn_msn "$1"
     [ "$CONFIG_AB_COUNT" = "2" ] &&   $sh_DIR/rmv_fon3 "$1" "$2"
     [ "$CONFIG_ETH_COUNT" = "1" ] &&   $sh_DIR/rmv_eth234 "$1"
#     [ "$CONFIG_DECT" = "n" ] && $sh_DIR/rmv_dect "$1"
     [ "$ATA_ONLY" = "y" ] && $sh_DIR/rmv_adsl "$1"
    fi
done

exit 0
