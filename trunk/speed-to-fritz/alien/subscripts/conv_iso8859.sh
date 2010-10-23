#!/bin/bash
 . $include_modpatch
for DIR in ${OEMLINKS}; do
# if [ "$DIR" = "avme" ] ; then
#  export HTML="$DIR/$avm_Lang/html"
# else
  export HTML="$DIR/html"
# fi
    DSTI="usr/www/$HTML/de/fon_config"

    if [ -d "$1"/${DSTI} ]; then
#--------------------------------------
#bug in 11945
sed -i -e 's|^.*<!-- ../fon_config/fon_config_3fxi.js -->|<!-- ../fon_config/fon_config_3fxi.js -->|' "$1"/${DSTI}/fon_config_3fxi.js
echo "-- ut8 Bugfix for fon menu on .inc files:"
for FFILE in `ls "$1"/${DSTI}/*.inc` ; do 
    FILE="${FFILE##*/}" 
    echo2 "      $DSTI/${FILE}"
iconv --from-code=UTF-8 --to-code=ISO-8859-1 "$1"/${DSTI}/$FILE > "$1"/${DSTI}/${FILE}_88 
rm -f  "$1"/${DSTI}/$FILE
mv "$1"/${DSTI}/${FILE}_88 "$1"/${DSTI}/${FILE}
done
#-------------------------------------
 fi
done