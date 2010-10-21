#!/bin/bash
 . $include_modpatch
for DIR in ${OEM}; do
# if [ "$DIR" = "avme" ] ; then
#  html="$avm_Lang/html"
# else
  html="html"
# fi
    DSTI="${1}"/usr/www/${DIR}/${html}/de/fon/foncalls.js
    if [ -f ${DSTI} ] ; then
 echo "-- applying bug fix for FRITZ!Fon 7150 Firmware 38.04.27 ..."
 echo2 "  -- patching file:"
 echo2 "      /usr/www/${DIR}/${html}/de/fon/foncalls.js"
     sed -i -e "s/g_txtmld_/g_txtMld_/g" "${DSTI}"
   fi
done

exit 0

