#!/bin/bash
# include modpatch function
. ${include_modpatch}
echo "-- removing 'Tab0' from updatepage ..."
DIRI="$(find ${1}/usr/www/ \( -name update_OnClick_1.js  \) -type f -print)"
for file_n in $DIRI; do
    ##echo2 "      ${DIRI}"
    #remove auto insall Tab on Install page
    grep -q "Tabs(0);" "$file_n" && \
    sed -i -e "s/Tabs(0);/Tabs(1);/" "$file_n"
    #new version labor 10173
    sed -i -e 's/Tabs(jslGetValue("uiPostTab").*;/Tabs(1);/' "$file_n"
    sed -i -e "/Tabs(0)/d" "$file_n"
    grep -q "Tabs(0);" "$file_n" && echo2 "  removed Tab0 from file: ${file_n##*/}"
done

#new lua type pages on 18577
DIRI="$(find ${1}/usr/www/ \( -name menu_show.lua  \) -type f -print)"
for file_n in $DIRI; do
    echo2 "      ${DIRI}"
    grep -q 'menu.show_page...system.update.lua.. = false' "$file_n" || \
    sed -i -e '/menu.show_page...system.update_file.lua.. = expert_mode/a\
menu.show_page\["\/system\/update.lua"\] = false' "$file_n"
    grep -q 'menu.show_page...system.update.lua.. = false' "$file_n" && echo2 "    removed Online-Update tab from file: ${file_n##*/}"
done
exit 0
#example for tabs
menu.exists_page\["system\/update.lua?tab=1"\] = true\
menu.show_page\["system\/update.lua?tab=1"\] = true\
