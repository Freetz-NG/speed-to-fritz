#!/bin/bash
for DIR in ${OEM}; do
# if [ "$DIR" = "avme" ] ; then
#  html="$avm_Lang/html"
# else
  html="html"
# fi
    DSTI="${1}"/usr/www/${DIR}/${html}/de/system/update_OnClick_1.js
    if [ -f ${DSTI} ] ; then
sed -i -e "/<div id=\"uiUpdate\" style=\"display:none\">[ \t]*$/,/^\t<\/div>[ \t]*$/d" "${DSTI}"
sed -i -e "/^[ \t]*<ul class=\"tabs\">/,/^[ \t]*<\/ul>/d" "${DSTI}"
sed -i -e "s/id=\"uiManuell\" style=\"display:none\"/id=\"uiManuell\"/" "${DSTI}"
sed -i -e "/Tabs(0)/d" "${DSTI}"
sed -i -e "/function Tabs (n) {$/,/^}$/d" "${DSTI}"
sed -i -e "/function uiStartFWSearch () {$/,/^}$/d" "${DSTI}"
sed -i -e "/uiBtn_StartFWSearch/d" "${DSTI}" 
sed -i -e "/var g_tab/d" "${DSTI}"
sed -i -e "s/g_tab == 0 ? \"hilfe_system_update_automatic\"://" "${DSTI}"
   fi
done

exit 0
