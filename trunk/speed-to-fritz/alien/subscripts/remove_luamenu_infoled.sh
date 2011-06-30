#!/bin/bash
. ${include_modpatch}
echo "-- removing menue infoled ..."
#new lua type pages
DIRI="$(find ${1}/usr/www/ \( -name menu_show.lua  \) -type f -print)"
for file_n in $DIRI; do
    #echo "----> $file_n"
    echo 'menu.show_page["/system/infoled.lua"] = false' >> "$file_n"
    grep -q 'infoled.lua.. = false' "$file_n" && echo2 "    removed menue infoled from file: ${file_n##*/}"
done
