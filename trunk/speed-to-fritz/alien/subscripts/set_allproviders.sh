#!/bin/bash
# include modpatch function
. ${include_modpatch}
echo "-- Set all provoders ..."

FILELIST="/html/de/internet/authform.html"

for FILE in $FILELIST; do
  if [ -f "${SRC}/usr/www/${OEMLINK}/$FILE" ]; then 
    sed -i -e 's/$var:allprovider 1/ 1 1/' "${SRC}/usr/www/${OEMLINK}/$FILE"
    sed -i -e 's/$var:OEM avme/avme avme/' "${SRC}/usr/www/${OEMLINK}/$FILE"
    echo2 "  /usr/www/${OEMLINK}/$FILE"
  fi
done
exit 0
