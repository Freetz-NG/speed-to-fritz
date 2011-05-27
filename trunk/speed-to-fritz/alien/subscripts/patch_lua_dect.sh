#!/bin/bash
. ${include_modpatch}
echo "-- fix lua 'dect' menue ..."
DIRI="$(find ${1}/usr/www/ \( -name href.lua  \) -type f -print)"
for file_n in $DIRI; do
    #echo2 "      ${DIRI}"
    [ -f "$file_n" ] && sed -i -e "s/'dect', 'handset'/'dect', 'setting'/" "$file_n"
    #echo2 "      ${DIRI}"
    [ -f "$file_n" ] && sed -i -e "/handset.lua/a\
avm3\[\"\/dect\/dect0.lua\"\] = \{'fon', 'dect0'\}\n\
avm3\[\"\/dect\/foneditdect.lua\"\] = \{'fon', 'foneditdect'\}\n\
avm3\[\"\/dect\/fonsetupdect.lua\"\] = {'fon', 'fonsetupdect'\}\n\
avm3\[\"\/dect\/fonlistdect.lua\"\] = \{'fon', 'fonlistdect'\}" "$file_n" && \
grep -q "dect0.lua" "$file_n" && echo "-- old dect menue added to: /menus/href.lua"
done

DIRI="$(find ${1}/usr/www/ \( -name menu_data.lua  \) -type f -print)"
for file_n in $DIRI; do
    #echo2 "      ${DIRI}"
    [ -f "$file_n" ] && sed -i -e "/fon_devices\/dect_setting.lua/,/menu.add_item/d" "$file_n"
    #echo2 "      ${DIRI}"
    [ -f "$file_n" ] && sed -i -e "/handset.lua/a \
text = \[\[abschalten\]\],\n\
menu = \"dect\",\n\
subpages = \{\}\n\
\}\n\
menu.add_item\{\n\
page = \"\/fon_devices\/dect_setting.lua\",\n\
text = \[\[einschalten\]\],\n\
menu = \"dect\",\n\
subpages = \{\}\n\
\}\n\
menu.add_item\{\n\
text = \[\[DECT Telefon Handteile\]\],\n\
menu = \"dect\",\n\
tabs = \{\n\
\{ page = \"\/dect\/dect0.lua\", text = \[\[Uebersicht\]\]\},\n\
\{ page = \"\/dect\/fonlistdect.lua\", text = \[\[Interne Nummern\]\]\},\n\
\{ page = \"\/dect\/fonsetupdect.lua\", text = \[\[Zuordnung\]\]\},\n\
\{ page = \"\/dect\/foneditdect.lua\", text = \[\[Anmelden\]\]\}\n\
\},\n\
--ENDE--" "$file_n" && \
 grep -q "dect0.lua" "$file_n" && echo "-- old dect menue added to: /menus/menu_data.lua"
 [ -f "$file_n" ] && sed -i -e "/--ENDE--/,/menu = .dect../d" "$file_n"
done
exit 0

echo "-- removing 'dect' from menue ..."
DIRI="$(find ${1}/usr/www/ \( -name menu_show.lua  \) -type f -print)"
for file_n in $DIRI; do
    ##echo2 "      ${DIRI}"
    sed -i -e 's/= config.DECT or.*/= false/' "$file_n"
    grep -q 'dect.. = false' "$file_n" && echo2 "    removed dect menu entry from file: ${file_n##*/}"
done

