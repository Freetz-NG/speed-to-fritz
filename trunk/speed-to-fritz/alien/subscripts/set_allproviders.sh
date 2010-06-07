#!/bin/bash
# include modpatch function
. ${include_modpatch}
echo "-- Set all provoders ..."

FILELIST="/html/de/internet/authform.html /de/fon/sip1.js /de/fon/siplist.js"

for FILE in $FILELIST; do
  if [ -f "${SRC}/usr/www/${OEMLINK}/$FILE" ]; then 
    sed -i -e 's/$var:allprovider 1/ 1 1/' "${SRC}/usr/www/${OEMLINK}/$FILE"
    sed -i -e 's/$var:OEM avme/avme avme/' "${SRC}/usr/www/${OEMLINK}/$FILE"
    sed -i -e "s/<? setvariable var:showtcom 0 ?>/<? setvariable var:showtcom 1 ?>/g" "${SRC}/usr/www/${OEMLINK}/$FILE"
    sed -i -e "s/<? setvariable var:allprovider 0 ?>/<? setvariable var:allprovider 1 ?>/g" "${SRC}/usr/www/${OEMLINK}/$FILE"
    echo2 "  /usr/www/${OEMLINK}/$FILE"
  fi
done
exit 0
