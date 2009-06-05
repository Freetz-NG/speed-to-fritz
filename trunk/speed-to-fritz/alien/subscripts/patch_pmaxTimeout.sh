#!/bin/bash
 . $include_modpatch
 echo "-- Increase timeout for autodisconnect ..."
for DIR in ${OEMLIST}; do
    DSTI="${1}"/usr/www/$DIR/html/de/internet/authform.js
    if [ -f ${DSTI} ] ; then
#------------------------------------------------------------------
sed -i -e "s/900/3600/" "$DSTI"
grep -q 'var g_maxTimeout=3600;' "$DSTI" && echo2 "     timeout set to 3600 in $DIR/html/de/internet/authform.js" 
#------------------------------------------------------------------
    fi
done
