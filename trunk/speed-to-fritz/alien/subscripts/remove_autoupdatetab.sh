#!/bin/bash
 # include modpatch function
 . ${include_modpatch}

echo "-- Removing 'Tab0' from updatepage ..."
for DIR in ${OEMLIST}; do
# if [ "$DIR" = "avme" ] ; then
#  export HTML="$DIR/$avm_Lang/html"
# else
  export HTML="$DIR/html"
# fi
    DSTI="${1}"/usr/www/$HTML
    if [ -d ${DSTI} ] ; then
    DIRI="/usr/www/${HTML}/de/system" 

    if  [ -f "$1"$DIRI/update_OnClick_1.js ]; then
    #    [ -n "$VERBOSITY" ] && echo2 "   -- Patching files:"
    echo2 "      ${DIRI}/update_OnClick_1.js"
    #remove auto insall Tab on Install page
    sed -i -e "s/Tabs(0);/Tabs(1);/" "$1"${DIRI}/update_OnClick_1.js
    #new version labor 10173
    sed -i -e 's/Tabs(jslGetValue("uiPostTab").*;/Tabs(1);/' "$1"${DIRI}/update_OnClick_1.js
    sed -i -e "/Tabs(0)/d" "$1"${DIRI}/update_OnClick_1.html
    fi
 fi
done

exit 0

