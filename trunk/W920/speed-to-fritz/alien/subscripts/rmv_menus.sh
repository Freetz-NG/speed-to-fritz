#!/bin/bash
[ "$CONFIG_IsdnNT" = "0" ] && echo "-- Removing 'internal S0', from setup page ..."
[ "$CONFIG_IsdnTE" = "0" ] && echo "-- Removing 'external ISDN', from setup page ..."
[ "$CONFIG_Usb" = "0" ] && echo "-- Removing 'USB' from setup page ..."
[ "$CONFIG_AB_COUNT" = "2" ] && echo "-- Removing 'internal FON 3', from setup page ..."
[ "$CONFIG_ETH_COUNT" = "1" ] && echo "-- Removing 'ETH 2-4', from setup page ..."
[ "$ATA_ONLY" = "y" ] && echo "-- Disable ADSL Option, from setup page ..."

for DIR in ${OEMLIST}; do
# if [ "$DIR" = "avme" ] ; then
#  export HTML="$DIR/$avm_Lang/html"
# else
  export HTML="$DIR/html"
# fi
    DSTI="${1}"/usr/www/$HTML
    if [ -d ${DSTI} ] ; then
     [ "$CONFIG_Usb" = "0" ] && $sh_DIR/rmv_usb "$1"
     [ "$CONFIG_IsdnNT" = "0" ] &&   $sh_DIR/rmv_isdn_s0 "$1"
     [ "$CONFIG_IsdnTE" = "0" ] &&   $sh_DIR/rmv_isdn_msn "$1"
     [ "$CONFIG_AB_COUNT" = "2" ] &&   $sh_DIR/rmv_fon3 "$1" "$2"
     [ "$CONFIG_ETH_COUNT" = "1" ] &&   $sh_DIR/rmv_eth234 "$1"
     [ "$ATA_ONLY" = "y" ] && $sh_DIR/rmv_adsl "$1"
          #enable all providers
     [ -f "${DSTI}/de/fon/sip1.js" ] && sed -i -e "s/<? setvariable var:showtcom 0 ?>/<? setvariable var:showtcom 1 ?>/g" "${DSTI}/de/fon/sip1.js"
     [ -f "${DSTI}/de/fon/siplist.js" ] && sed -i -e "s/<? setvariable var:showtcom 0 ?>/<? setvariable var:showtcom 1 ?>/g" "${DSTI}/de/fon/siplist.js"
     [ -f "${DSTI}/de/internet/authform.html" ] && sed -i -e "s/<? setvariable var:allprovider 0 ?>/<? setvariable var:allprovider 1 ?>/g" "${DSTI}/de/internet/authform.html"
     #remove Progamme menu entry
 #    [ -f "${DSTI}/de/menus/menu2.inc" ] && sed -i -e "s/<? setvariable var:TextMenuSoftware \"Programme\" ?>\\n//g" "${DSTI}/de/menus/menu2.inc"
 #    [ -f "${DSTI}/de/home/sitemap.html" ] && sed -i -e "/'software', 'extern'/d" "${DSTI}/de/home/sitemap.html"
    fi
done

exit 0
