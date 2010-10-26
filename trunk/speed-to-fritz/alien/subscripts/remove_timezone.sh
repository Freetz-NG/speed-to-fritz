#!/bin/bash
echo "-- removing timezone menue entry ..."
#new lua type pages on 18577
DIRI="$(find ${1}/usr/www/ \( -name menu_show.lua  \) -type f -print)"
for file_n in $DIRI; do
    ##echo2 "      ${DIRI}"
    find ${1}/usr/www/ -name timezone.lua | grep -q "timezone.lua" ||\
    sed -i -e 's/system.timezone.lua.. = box.query..env:status.OEM.. == .avme./system\/timezone\.lua\"\] = false/' "$file_n"
    grep -q 'system.timezone.lua.. = false' "$file_n" && echo2 "    removed timezone page in file: ${file_n##*/}"
done
#old menues add or remove timezone entry
echo "-- adding timezone pages ..."
[ "$avm_Lang" = "de" ] && ( [ -f "${SRC}"/usr/www/$OEMLINK/html/de/system/timeZone.js ] || modpatch "${SRC}/${USRWWW}" "$P_DIR/add_timezone_de.patch" )
[ "$avm_Lang" != "de" ] && ( [ -f "${SRC}"/usr/www/$OEMLINK/html/de/system/timeZone.js ] || modpatch "${SRC}/${USRWWW}" "$P_DIR/add_timezone_en.patch" )
DIRI="$(find ${1}/usr/www/ \( -name menu2_system.html  \) -type f -print)"
for file_n in $DIRI; do
    find ${1}/usr/www/ -name timeZone.js | grep -q "timeZone.js" ||\
    sed -i -e "/system...timeZone/d" "$file_n"
    grep -q 'system...timeZone' "$file_n" || echo2 "    removed timezone page in file: ${file_n##*/}"
done
exit 0

