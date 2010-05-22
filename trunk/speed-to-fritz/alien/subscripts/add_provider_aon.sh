#!/bin/bash
# include modpatch function
. ${include_modpatch}
FILELIST="/html/de/first/provider.js"

for FILE in $FILELIST; do
  if [ -f "${SRC}/usr/www/${OEMLINK}/$FILE" ]; then 
    if  ! [ grep -q "AON" "${SRC}/usr/www/${OEMLINK}/$FILE" ];then
	sed -i -e '/<? if neq $var:OEM freenet `/i\
if(szProvider== "AON") return szProvider;' "${SRC}/usr/www/${OEMLINK}/$FILE"
	sed -i -e '/return otherprovider;/i\
if (id == "AON") return "aon";' "${SRC}/usr/www/${OEMLINK}/$FILE"
    grep -q "AON" "${SRC}/usr/www/${OEMLINK}/$FILE" && echo "-- Added provider AON" 
    fi
  fi
done
exit 0
