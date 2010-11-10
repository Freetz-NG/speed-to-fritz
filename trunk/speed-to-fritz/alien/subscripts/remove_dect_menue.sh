#!/bin/bash
. ${include_modpatch}
echo "-- removing 'dect' from menue ..."
DIRI="$(find ${1}/usr/www/ \( -name menu_show.lua  \) -type f -print)"
for file_n in $DIRI; do
    ##echo2 "      ${DIRI}"
    sed -i -e 's/= config.DECT or.*/= false/' "$file_n"
    grep -q 'dect.. = false' "$file_n" && echo2 "    removed dect menu entry from file: ${file_n##*/}"
done
exit 0
