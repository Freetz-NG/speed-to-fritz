#!/bin/bash
# include modpatch function
. ${include_modpatch}
echo "-- removing 'Tab0' from updatepage ..."
DIRI="$(find ${1}/usr/www/ \( -name update_OnClick_1.js  \) -type f -print)"
for file_n in $DIRI; do
##    echo2 "      ${DIRI}"
    #remove auto insall Tab on Install page,  and 18577
    grep -q "Tabs(0);" "$file_n" && \
    sed -i -e "s/Tabs(0);/Tabs(1);/" "$file_n"
    #new version labor 10173
    sed -i -e 's/Tabs(jslGetValue("uiPostTab").*;/Tabs(1);/' "$file_n"
    sed -i -e "/Tabs(0)/d" "$file_n"
    grep -q "Tabs(0);" "$file_n" && echo2 "  removed Tab0 from file: ${file_n##*/}"
done
exit 0
