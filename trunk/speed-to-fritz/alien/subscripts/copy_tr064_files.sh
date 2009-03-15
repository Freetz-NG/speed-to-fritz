#!/bin/bash
 . $include_modpatch
# copy missing files in OEM dir 
for DIR in ${OEMLIST}; do
 if [ -d "${DST}/etc/default.${DEST_PRODUKT}/${DIR}" ]; then
  for FILE in $(ls "${DST}/etc/default.${DEST_PRODUKT}/${DIR}"); do
    if [ -f "${DST}/etc/default.${DEST_PRODUKT}/${DIR}/${FILE}" ]; then
     if ! [ -f "${SRC}/etc/default.${CONFIG_PRODUKT}/${OEMLINK}/$FILE" ]; then
      cp -fdrp "${DST}/etc/default.${DEST_PRODUKT}"/${DIR}/$FILE "${SRC}/etc/default.${CONFIG_PRODUKT}/${OEMLINK}/$FILE" && echo2 "  copy file from 2nd FW: $FILE"
     fi
    fi 
  done
 fi
done 
#copy net*

if [ "$avm_Lang" = "en" ] ; then
TR064TXT1="Autommatc setup is aloud within the LAN (TR-064)"
TR064TXT2="This setting make it possible to to settings of the Box from a connected PC, one needs a comatible program for the FRITZ!Box and a connection to the configurationssystem for the automatic setup thrugh the sevice provider."
else
TR064TXT1="Automatische Einrichtung aus dem lokalen Netzwerk zulassen (TR-064)"
TR064TXT2="Diese Einstellung ermoeglicht es vom PC aus, mit kompatiblen Programmen in der FRITZ!Box eine Verbindung zum Konfigurationssystem fuer die automatische Einrichtung durch den Dienstanbieter einzurichten."
fi

if [ -f "${SRC}/usr/www/avm/html/de/system/net.html" ]; then
if ! [ $(grep -q 'Tr064' "${SRC}/usr/www/avm/html/de/system/net.html" ) ]; then 
echo "-- Adding TR064 setup pages..."
sed -i -e '/FWChange/a\
<\/div><\/div><\/div><\/div><\/div><\/div>\
\` ?>\
<? if eq $var:isTr064 1 \`\
<div class="backdialog" id="uiSetTr064" style="display:none"><div class="ecklm"><div class="eckrm"><div class="ecklb"><div class="eckrb"><div class="foredialog">\
<p class="pCheck25"><input type="checkbox" id="uiViewSetTr064">&nbsp;<label for="uiViewSetTr064">TR064TXT1<\/label><\/p>\
<p class="ml25">TR064TXT2<\/p>' "${SRC}/usr/www/avm/html/de/system/net.html"
sed -i -e "s|TR064TXT1|${TR064TXT1}|" -e "s|TR064TXT2|${TR064TXT2}|" "${SRC}/usr/www/avm/html/de/system/net.html"

echo '<input type="hidden" name="tr064:settings/enabled" value="<? query tr064:settings/enabled ?>" id="uiPostSetTr064" disabled>' >> "${SRC}/usr/www/avm/html/de/system/net.frm"
echo '<input type="hidden" name="logic:command/reboot" value="1" id="uiPostReboot" disabled>' >> "${SRC}/usr/www/avm/html/de/system/net.frm"

sed -i -e '/function uiDoAdressen ()/i\
function IsISPFreenet(){\
username="<? query connection0:pppoe:settings\/username ?>";\
if (username.substring(0, 5)=="frn6\/") {\
return true;\
}else\
return false;\
}' "${SRC}/usr/www/avm/html/de/system/net.js"
#show menue so as it would be oem avme
sed -i -e 's/g_Variante!="avm"/g_Variante!="axm"/' "${SRC}/usr/www/avm/html/de/system/net.js"

sed -i -e '/function DoTabsProviderDienst() /,/function DoTabsIP() / {s/jslDisplay("uiExpert", true);/<? if eq $var:isTr064 1 \`\
jslSetChecked("uiViewSetTr064", jslGetValue("uiPostSetTr064") == "1");\
jslDisplay("uiSetTr064", true);\
\` ?>\
jslDisplay("uiExpert", true);/}' "${SRC}/usr/www/avm/html/de/system/net.js"

sed -i -e '/function doClientsPage() {/i\
<? if eq $var:isTr064 1 \`\
var g_confirmTr064Off = "Tr064 OFF (deaktivieren und neu starten)";\
var g_confirmTr064On = "Tr064 ON (aktivieren und neu starten) ";\
var g_oldTr064Val = "<? query tr064:settings\/enabled ?>";\
\` ?>' "${SRC}/usr/www/avm/html/de/system/net.js"


sed -i -e '/function uiDoSave() /,/jslSetValue/ {s/if (g_tabNr == "2") {/if (g_tabNr == "2") {\
<? if eq $var:isTr064 1 \`\
var newTr064Val = jslGetChecked("uiViewSetTr064") ? "1":"0";\
if (newTr064Val != g_oldTr064Val)\
{\
if (newTr064Val == "1")\
{\
alert(g_confirmTr064On);\
}\
else\
{\
if (!confirm(g_confirmTr064Off)) return;\
}\
jslSetValue("uiPostSetTr064", newTr064Val);\
jslEnable("uiPostSetTr064");\
jslEnable("uiPostReboot");\
jslSetValue("uiPostGetPage", "\.\.\/html\/reboot.html");\
}\
\` ?>/}' "${SRC}/usr/www/avm/html/de/system/net.js"

fi
fi
#only for tests
#cp -fdrp "${SRC_2}/usr/www/avme" "${SRC_2}/usr/www/avm"

