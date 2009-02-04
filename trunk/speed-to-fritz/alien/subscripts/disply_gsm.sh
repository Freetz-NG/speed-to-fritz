#!/bin/bash 
 # include modpatch function
 . ${include_modpatch}
echo "-- Enabel GSM Display if existant on internet pages ..."

for OEMDIR in $2; do
# if [ "$OEMDIR" = "avme" ] ; then
#  html="$avm_Lang/html"
# else
  html="html"
# fi
 USRWWW="usr/www/${OEMDIR}/$html/de"
#-----------------------------------------------------------------
  if [ -f "$1"/usr/www/${OEMDIR}/$html/index.html ]; then
    sed -i -e '/function uiDoOnLoad() {/a\
jslDisplay("uiShowGSM", true);' "$1/${USRWWW}/home/home.js"
    sed -i -e 's|$var:isUsbGsm|1|' "$1/${USRWWW}/menus/menu2_internet.html"
    sed -i -e 's|<? query gsm:settings/PinEmpty ?>|0|' "$1/${USRWWW}/menus/menu2_internet.html"
  echo2 "  /${USRWWW}/home/home.js"
  fi
#-----------------------------------------------------------------
done
exit 0
 