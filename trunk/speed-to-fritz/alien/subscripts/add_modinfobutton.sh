#!/bin/bash
 # include modpatch function
 . ${include_modpatch}
. $inc_DIR/includefunctions

#########################################################################
# Add mod info button on home screen                                    #
#########################################################################
#!/bin/bash
echo "-- Adding 'Info' button and display of mod related data ..."
for DIR in ${OEMLIST}; do
# if [ "$DIR" = "avme" ] ; then
#  export HTML="$DIR/$avm_Lang/html"
# else
  export HTML="$DIR/html"
# fi
    DSS="/usr/www/$HTML/de"
    DSTI="$1"${DSS}
	if [ -d ${DSTI}/help ] ; then
#------------------------------------------------------------------------------------------------
#add for .49 AVM
#popup window is only functional with local help
if [ -e "${DSTI}"/menus/menu2.html ]; then
 if [ "$ADD_MODINFOICON" = "y" ]; then
    echo "-- Adding 'Info' icon on status page..."
    cp -fdpr  $P_DIR/help1.gif  --target-directory="${DSTI}"/images
    echo2 "      ${DSS}/menus/menu2.html"
    sed -i -e "/PopHelpEx/i \
<td title=\"Mod Info\" style=\"width: 20px;\"><a href=\"javascript:jslPopHelp('modinfo')\">\n\ \
<img src=\"..\/html\/de\/images\/help1.gif\">\n\ \
<\/a><\/td>" "${DSTI}"/menus/menu2.html
 fi
    sed -i -e 's|var g_HelpPagesOnBox = new Array(|var g_ModHelpPagesOnBox = new Array(\
"modinfo",\
"hilfe_fon_anrufbeantworter",\
"hilfe_fon_dect",\
"hilfe_fon_dect_festnetznummer",\
"hilfe_fon_dect_fon1isdn",\
"hilfe_fon_editdect",\
"hilfe_fon_fon1dect",\
"hilfe_fon_listdect",\
"hilfe_fon_setupdect");\
function IsTopicModOnBox(topic) {\
var i = 0;\
while (i < g_ModHelpPagesOnBox.length) {\
if (topic == g_ModHelpPagesOnBox[i]) return true;\
i++;\
}\
return false;\
}\
var g_HelpPagesOnBox = new Array(|' "${DSTI}"/help/popup.html


    sed -i -e 's|if (g_HelpUrl != "")|var topic = "<? echo $var:pagename ?>";\
if (IsTopicModOnBox(topic))\
{\
var h1 = document.getElementById("btnBack");\
if (h1 != null) h1.disabled = (history.length==0);\
jslDisplay("uiShowOffline",true);\
var anker = "<? echo $var:anker ?>";\
if (anker != "") location.hash = anker;\
return;\
}\
if (g_HelpUrl != "")|' "${DSTI}"/help/popup.html

#    sed -i -e 's|jslDisplay("uiShowError", true);|jslDisplay("uiShowError", true);\n}|' "${DSTI}"/help/popup.html

fi

# for all versions
# add Speedportinfo 
sed -i -e "s|<? echo \$var:ProduktName ?>|<? echo \$var:ProduktName ?>  ${CLASS} W${SPNUM}V|" "${DSTI}"/home/home.html

# add Service portal link
sed -i -e 's|var url = jslGetValue("uiPostPortal");|var url = "http://www.avm.de/de/Service/Service-Portale/Service-Portal/index.php?portal=FRITZ!Box_Fon_WLAN_<Modell-Nummer>"|' "${DSTI}"/help/popup.html
sed -i -e "s|<Modell-Nummer>|${FBMOD}|" "${DSTI}"/help/popup.html

echo2 "-- Patching files:"
if [ "$avm_Lang" = "de" ]; then
echo2 "      ${DSS}/home/home.html"
sed -i -e 's|^.*rbb.refresh.*$|<div class="backdialog"><div class="ecklm"><div class="eckrm"><div class="rundrb"><div class="rundlb"><div class="forebuttons">\
<input type="button" onclick="uiDoInfo()" value="Info" class=Pushbutton>\
<input type="button" onclick="uiDoHelp()" value="Hilfe" class="Pushbutton" id="buttonHilfe">\
<input type="button" onclick="uiDoRefresh()" value="Aktualisieren" class=Pushbutton>\
</div></div></div></div></div></div>|' "${DSTI}/home/home.html"
else
echo2 "      ${DSS}/home/home.html"
sed -i -e 's|^.*rbb.refresh.*$|<div class="backdialog"><div class="ecklm"><div class="eckrm"><div class="rundrb"><div class="rundlb"><div class="forebuttons">\
<input type="button" onclick="uiDoInfo()" value="Info" class=Pushbutton>\
<input type="button" onclick="uiDoHelp()" value="Help" class="Pushbutton" id="buttonHilfe">\
<input type="button" onclick="uiDoRefresh()" value="Refresh" class=Pushbutton>\
</div></div></div></div></div></div>|' "${DSTI}/home/home.html"
fi

echo2 "      ${DSS}/home/home.js"
sed -i -e "/<\/script>/i \
function uiDoInfo() {\n\tjslPopHelp(\"modinfo\");\n}" "${DSTI}/home/home.js"
#<input type="button" onclick="uiDoInfo()" value="Info" class=Pushbutton>\
#<input type="button" onclick="<a href="javascript:jslPopHelp(\'modinfo\')">" value="Info" class=Pushbutton>\


DSTF="${DSTI}"/help/modinfo.html

echo2 "     ${DSS}/help/modinfo.html"


touch "${DSTF}"
#echo "1---------------------------------------------------------------------------------------------------------------------------------"

if [ "$avm_Lang" = "de" ]; then
cat << 'EOF' >> "${DSTF}"
<div class="Hilfe">
<div class="backtitel"><div class="rundrt"><div class="rundlt"><div class="ecklb"><div class="eckrb"><div class="foretitel">Informationen</div></div></div></div></div></div>
<div class="backdialog"><div class="ecklm"><div class="eckrm"><div class="ecklb"><div class="eckrb"><div class="foredialog">
<p>Die Firmware des <b>MODEL</b> wurde durch den <b>Speed2fritz-Mod</b> verändert. Im folgenden erhalten Sie Informationen über die verwendeten Skript- und Firmware-Versionen.</p>
<h2>Verwendete Skript-Version</h2>
<p>Verwendet wurde das Skript <b>'speed2fritz'</b> in der Version vom <b>VERSION</b>. Folgende Optionen wurden verwendet:</p>
<ul>
<li><b>Branding:</b> Das Branding der Box wurde vom Skript auf den Wert <b>'OEM'</b> gesetzt.</li>
<li><b>Hostname:</b> Der Hostname der Box wurde auf <b>'HOSTNAME'</b> eingestellt.</li>
<li><b>Auto Konfiguration TR69:</b> Das automatische Einrichten durch den Dienstanbieter ist <b>AUTOCONF </b>ATACONF.</li>
<li><b>LAN Auto Konfiguration TR64:</b> Das automatische Einrichten durch den Dienstanbieter aus dem lokalen Netz vom PC aus ist <b>LANTR64TEXT</b>.</li>
<li><b>Kompatibilität:</b> Der Produktname wurde <b>PREFIX</b> erweitert.</li>
<li>Die Statusseite zeigt den AVM Produktnamen plus <b>MODEL</b></li>
<li><b>TelefonMenü:</b> Die Menüführung für die Einrichtung von Telefongeräten wurde <b>FONMENU</b>.</li>
ADD_7150_DECTMNUE
ADD_DSL_EXPERT_MNUE
USE_OWN_DSL
FORCE_TCOM_DSL
FORCE_TCOM_FON
MOVE_ALL_XXX
FORCE_CLEAR_FLASH
<li><b>'DasOertliche.de'-Patch:</b> Der Patch zur Rückwärtssuche der Anrufernummer bei 'DasOertliche.de' wurde <b>PATCH</b>.</li>
<li><b>Annex:</b> Annex der Box wurde auf <b>'ANNEX'</b> eingestellt.(Wurde nur wirksam, wenn per Webinterface oder unter LINUX mit push Option upgedatet wurde.)</li>
</ul>
<p></p>
<h2>Verwendete Firmware-Versionen</h2>
<p>Zur Erstellung der Weboberfläche und zur Vervollständigung von Systemfunktionen, wurden folgende Firmware-Images von TCOM und AVM verwendet:</p>
<ul>
<li><b>TCOM Image:</b> Das Image der Telekom liefert die Hardwaretreiber der Box und ist genau auf die Telekom-Hardware 
abgestimmt.	Verwendet wurde das Image-File <b>'IMG0_TCOM'</b>.</li>
<li><b>AVM Systemimage:</b> Dieses Image wird verwendet, um Systemfunktionen und auch die AVM-Weboberfläche 
zu ergänzen. Das Image stammt von einer AVM-Hardware, die in der Funktion der Telekom-Hardware ähnlich ist und die 
dieselbe Kernel-Version verwendet. Verwendet wurde das Image-File <b>'IMG1_AVM'</b>.</li>
<li><b>AVM WebUI-Image:</b> Verwendet wurde das Image-File <b>'IMG2_AVM'</b>.</li>
<li><b>Kernel-Update:</b> Der AVM Kernel wurde <b>XCHANGE_KERNEL</b>.</li>
</ul>
<p></p>
<h2>Allgemeine Hinweise und Disclaimer</h2>
<p>Die aktuelle Skriptversion finden Sie <a href="http://www.ip-phone-forum.de/showpost.php?p=1009138&postcount=1" target="_blank">im IP-Phone-Forum</a>.
Die Doku dazu finden Sie ebenfalls <a href="http://wiki.ip-phone-forum.de/skript:speedport2fritz" target="_blank">dort</a>, wie auch eine aktuelle <a href="http://wiki.ip-phone-forum.de/skript:speed2fritzfaq" target="_blank">FAQ-Liste</a>.</p>
<p>Die Anwendung dieser Modifikation erfolgt auf eigene Gefahr. Sie verlieren dadurch Ihren Supportanspruch gegenüber dem Hersteller. 
Die Autoren von 'Speed2Fritz' lehnen jegliche Haftung für Schäden ab, die durch die Installation des Skripts oder der modifizierten Firmware entstehen.</p>
<p></p>
<p>2006-2009</p>
</div></div></div></div></div></div>
<? include ../html/de/help/rback.html ?>
</div>
EOF


elif [ "$avm_Lang" = "en" ]; then
cat << 'EOF' >> "${DSTF}"
<div class="Hilfe">
<div class="backtitel"><div class="rundrt"><div class="rundlt"><div class="ecklb"><div class="eckrb"><div class="foretitel">Information</div></div></div></div></div></div>
<div class="backdialog"><div class="ecklm"><div class="eckrm"><div class="ecklb"><div class="eckrb"><div class="foredialog">
<p>The user interface of <b>MODEL</b> has been modified with <b>Speed2Fritz-Mod</b>. The following Script- and Firmware Versions have been used.</p>
<h2>Script Version used:</h2>
<p> <b>'speed2fritz'</b> version <b>VERSION</b> has been used.</p> 
<ul>
<li>Used options:</li>
<ul>
<li><b>Branding:</b> Branding has been set to <b>'OEM'</b>.</li>
<li><b>Host name:</b> Host name has been set to <b>'HOSTNAME'</b>.</li>
<li><b>Auto Configuration TR69:</b> Auto Configuration via ISP <b>AUTOCONF </b>ATACONF.</li>
<li><b>LAN auto Configuration TR64:</b> Internal LAN auto Configuration via ISP <b>LANTR64TEXT</b>.</li>
<li><b>Compatibility:</b>  has <b>PREFIX</b> been added to the Product name.</li>
<li>Status Page shows AVM Product name <b>plus hardware type</b>.</li>
<li><b>Telefon-Menue:</b> Setup menu for telephones has been <b>FONMENU</b>.</li>
ADD_7150_DECTMNUE
ADD_DSL_EXPERT_MNUE
USE_OWN_DSL
FORCE_TCOM_DSL
FORCE_TCOM_FON
MOVE_ALL_XXX
FORCE_CLEAR_FLASH
<li><b>'DasOertliche.de'-Patch:</b> The patch for reverse look up of the callers phone number has been <b>PATCH</b>.</li>
<li><b>Annex:</b> Annex has been set to <b>'ANNEX'</b> (This is only true if the update ware done via web interface or Linux FTP and the push Option.)</li>
<li></ul>
<p></p>
<h2>Used Firmware-Versions</h2>
<p>Following Firmware Images from TCOM and AVM have been used for the WEB-GUI and to enable system functionality:</p>
<ul>
<li><b>TCOM image:</b> The Telekom Image is used for the basic driver functions as it is designed for Telekom Hardware.	Image-File <b>'IMG0_TCOM'</b> has been used.</li>
<li><b>AVM System Image:</b> This image is used to complete system functions and also the AVM WEB-GUI. The image comes from an AVM Hardware that is common to the Telekom Hardware and uses same Kernel version. <b>'IMG1_AVM'</b>.</li> Image has been used.
<li><b>AVM WebUI-Image:</b> For Speedport W 900V the WEB-GUI may be copied from a separate Image, that is also supporting the special ISDN functionality of this box. <b>'IMG2_AVM'</b>.</li> image has been used.
<li><b>Kernel-Update:</b> AVM Firmware kernel has been <b>XCHANGE_KERNEL</b> with t-com kernel.</li>
</ul>
<p></p>
<h2>Standard terms and conditions and and Disclaimer</h2>
<p>The actual Script Version can be found on <a href="http://www.ip-phone-forum.de/showpost.php?p=1009138&postcount=1" target="_blank">IP-Phone-Forum</a>.
The manual also can be found <a href="http://wiki.ip-phone-forum.de/skript:speedport2fritz" target="_blank">here</a>, and also an actual <a href="http://wiki.ip-phone-forum.de/skript:speed2fritzfaq" target="_blank">FAQ-Liste</a>.</p>
<p>Using this modification is on your own risk. All guarantee and entitlement to the manufacturer for support is lost.
The authors of 'Speed2Fritz' refuses any accountability for all damage occurred from the use of the script or a modified Firmware.</p>
<p></p>
<p>2006/2009</p>
</div></div></div></div></div></div>
<? include ../html/de/help/rback.html ?>
</div>
EOF
fi
chmod 755 "${DSTF}"

readConfig "HOSTNAME" "HOSTNAME" "${1}/etc/init.d"

readConfig "DSL_MULTI_ANNEX" "DSL_MULTI_ANNEX" "${1}/etc/init.d"

sed -i -e "s/MODEL/${CLASS} W ${SPNUM}V/" "${DSTF}"
sed -i -e "s/VERSION/${SKRIPT_DATE}/" "${DSTF}"
sed -i -e "s/OEM/${OEM}/" "${DSTF}"
sed -i -e "s/HOSTNAME/${HOSTNAME}/" "${DSTF}"
sed -i -e "s/IMG0_TCOM/${SPIMG}/" "${DSTF}"
sed -i -e "s/IMG1_AVM/${FBIMG}/" "${DSTF}"
[ "$DSL_MULTI_ANNEX" = "y" ] && sed -i -e "s/ANNEX/Multi/" "${DSTF}"
[ "$ATA_ONLY" = "n" ] && sed -i -e "s/ANNEX/${ANNEX}/" "${DSTF}"

[ -n "$FBIMG_2" ] && sed -i -e "s/IMG2_AVM/${FBIMG_2}/" "${DSTF}" || sed -i -e "/<li><b>AVM WebUI-Image:/,/<\/li>/d" "${DSTF}"

if [ "$avm_Lang" = "de" ]; then
#////////////////////////////////////////////////////////////////
[ "$ADD_OLD_DECTMENU" = "y" ] && sed -i -e "s|ADD_OLD_DECTMENU|<li><b>DECT-Menü:</b> Die Menüführung für DECT Handteile wurde mit der altern Variante <b>erweitert</b>.</li>|" "${DSTF}" 
[ "$ADD_OLD_DECTMENU" = "y" ] || sed -i -e "s|ADD_OLD_DECTMENU||" "${DSTF}"
[ "$ADD_7150_DECTMNUE" = "y" ] && sed -i -e "s|ADD_7150_DECTMNUE|<li><b>DECT-Menü:</b> Die Menüführung für DECT Handteile wurde mit der neueren Variante <b>erweitert</b>.</li>|" "${DSTF}" 
[ "$ADD_7150_DECTMNUE" = "y" ] || sed -i -e "s|ADD_7150_DECTMNUE||" "${DSTF}"
[ "$ADD_DSL_EXPERT_MNUE" = "y" ] && sed -i -e "s|ADD_DSL_EXPERT_MNUE|<li><b>DSL-Experten Menü:</b> Die Menüführung für die DSL Einstellungen wurde <b>erweitert</b>.</li>|" "${DSTF}" 
[ "$ADD_DSL_EXPERT_MNUE" = "y" ] || sed -i -e "s|ADD_DSL_EXPERT_MNUE||" "${DSTF}"
[ "$USE_OWN_DSL" = "y" ] && sed -i -e "s|USE_OWN_DSL|<li><b>DSL-Treiber:</b> Der DSL Treiber wurde durch einen eigenen <b>ersetzt</b>.</li>|" "${DSTF}"
[ "$USE_OWN_DSL" = "y" ] || sed -i -e "s|USE_OWN_DSL||" "${DSTF}"
[ "$FORCE_TCOM_DSL" = "y" ] && sed -i -e "s|FORCE_TCOM_DSL|<li><b>DSL-Treiber:</b> Der DSL Treiber wurde aus der t-com Firmware <b>verwendet</b>.</li>|" "${DSTF}"
[ "$FORCE_TCOM_DSL" = "y" ] || sed -i -e "s|FORCE_TCOM_DSL||" "${DSTF}"
[ "$FORCE_TCOM_FON" = "y" ] && sed -i -e "s|FORCE_TCOM_FON|<li><b>FON-Treiber:</b> Der Telefon Treiber wurde aus der t-com Firmware <b>verwendet</b>.</li>|" "${DSTF}"
[ "$FORCE_TCOM_FON" = "y" ] || sed -i -e "s|FORCE_TCOM_FON||" "${DSTF}"
[ "$MOVE_ALL_XXX" = "y" ] && sed -i -e "s|MOVE_ALL_XXX|<li><b>Freetz-Kompatibilität:</b> Das Verzeichnis www/all wurde auf www/$OEM <b>umbenannt</b>.</li>|" "${DSTF}" 
[ "$MOVE_ALL_XXX" = "y" ] || sed -i -e "s|MOVE_ALL_XXX||" "${DSTF}"
[ "$FORCE_CLEAR_FLASH" = "y" ] && sed -i -e "s|FORCE_CLEAR_FLASH|<li><b>Werkseinstellung:</b> Diese Firmware führte beim Laden über die Updatefunktion einen automatischen Werksreset durch.</li>|" "${DSTF}" 
[ "$FORCE_CLEAR_FLASH" = "y" ] || sed -i -e "s|FORCE_CLEAR_FLASH||" "${DSTF}"
[ "$ATA_ONLY" = "y" ] && sed -i -e "s/^.*ANNEX.*$/<li><b>Annex:<\/b> Annex ist nicht in Verwendung, Box ist im <b>'ATA'<\/b> Mod, LAN1 wird als Uplink verwendet\. <\/li>/" "${DSTF}"
[ "$CONFIG_TR069" = "y" ] && sed -i -e "s/ATACONF/und ATA abgeschaltet/" "${DSTF}"
[ "$CONFIG_TR069" = "y" ] && sed -i -e "s/AUTOCONF/zugelassen/" "${DSTF}"  
[ "$CONFIG_TR069" = "y" ] || sed -i -e "s/ATACONF//" "${DSTF}"
[ "$CONFIG_TR069" = "y" ] || sed -i -e "s/AUTOCONF/ausgeschaltet/" "${DSTF}"
[ "$CONFIG_TR064" = "y" ] && sed -i -e "s/LANTR64TEXT/zugelassen/" "${DSTF}"
[ "$CONFIG_TR064" = "y" ] || sed -i -e "s/LANTR64TEXT/ausgeschaltet/" "${DSTF}"
[ -n "$NEWNAME" ] && sed -i -e "s/PREFIX/'${NEWNAME}'/" "${DSTF}"
[ -n "$NEWNAME" ] || sed -i -e "s/PREFIX/nicht/" "${DSTF}"
[ "$DO_LOOKUP_PATCH" = "y" ] && sed -i -e "s/PATCH/angewendet/" "${DSTF}"
[ "$DO_LOOKUP_PATCH" = "y" ] || sed -i -e "s/PATCH/nicht angewendet/" "${DSTF}"
[ "$REMOVE_MENU_ITEM" = "y" ] && sed -i -e "s/FONMENU/angepasst/" "${DSTF}"
[ "$REMOVE_MENU_ITEM" = "y" ] || sed -i -e "s/FONMENU/nicht angepasst/" "${DSTF}"
[ "$SPMOD" = "501" -o "$SPMOD" = "500" ] && sed -i -e "/<li><b>Telefon-Menü:/,/<\/li>/d" "${DSTF}"
[ "$XCHANGE_KERNEL" = "y" ] && sed -i -e "s/XCHANGE_KERNEL/ mit dem der t-com Firmware ersetzt /" "${DSTF}"
[ "$XCHANGE_KERNEL" = "y" ] || sed -i -e "s/XCHANGE_KERNEL/beibehalten /" "${DSTF}"

#charset=utf-8
Unicode_ut8="n"
`cat "${1}"/usr/www/$HTML/index.html | grep -q 'charset=utf-8' ` && Unicode_ut8="y" 
#echo "2---------------------------------------------------------------------------------------------------------------------------------"
       if [ "$Unicode_ut8" = "y" ]; then 
#echo "3---------------------------------------------------------------------------------------------------------------------------------"
	[ -f "${DSTF}" ] && iconv --from-code=ISO-8859-1 --to-code=UTF-8 "${DSTF}" > "${DSTF}ut8"
	rm "${DSTF}"
	mv "${DSTF}ut8" "${DSTF}"
	chmod 755 "${DSTF}"
       fi

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
else
[ "$ADD_OLD_DECTMENU" = "y" ] && sed -i -e "s|ADD_OLD_DECTMENU|<li><b>DECT-Menu:</b> Older setup menu for DECT telephones has been <b>added</b>.</li>|" "${DSTF}" 
[ "$ADD_OLD_DECTMENU" = "y" ] || sed -i -e "s|ADD_OLD_DECTMENU||" "${DSTF}"
[ "$ADD_7150_DECTMNUE" = "y" ] && sed -i -e "s|ADD_7150_DECTMNUE|<li><b>DECT-Menu:</b> New setup setup menu for DECT has been <b>added</b>.</li>|" "${DSTF}" 
[ "$ADD_7150_DECTMNUE" = "y" ] || sed -i -e "s|ADD_7150_DECTMNUE||" "${DSTF}"
[ "$ADD_DSL_EXPERT_MNUE" = "y" ] && sed -i -e "s|ADD_DSL_EXPERT_MNUE|<li><b>DSL-Expert Menu:</b> Setup menu for  DSL has been <b>added</b>.</li>|" "${DSTF}" 
[ "$ADD_DSL_EXPERT_MNUE" = "y" ] || sed -i -e "s|ADD_DSL_EXPERT_MNUE||" "${DSTF}"
[ "$USE_OWN_DSL" = "y" ] && sed -i -e "s|USE_OWN_DSL|<li><b>DSL-Driver:</b> DSL driver has been <b>replaced</b> with own.</li>|" "${DSTF}" 
[ "$USE_OWN_DSL" = "y" ] || sed -i -e "s|USE_OWN_DSL||" "${DSTF}"
[ "$FORCE_TCOM_DSL" = "y" ] && sed -i -e "s|FORCE_TCOM_DSL|<li><b>DSL-Driver:</b> DSL driver was taken from <b>T-com</b> Firmware.</li>|" "${DSTF}" 
[ "$FORCE_TCOM_DSL" = "y" ] || sed -i -e "s|FORCE_TCOM_DSL||" "${DSTF}"
[ "$FORCE_TCOM_FON" = "y" ] && sed -i -e "s|FORCE_TCOM_FON|<li><b>FON-Driver:</b> FON driver was taken from <b>T-com</b> Firmware.</li>|" "${DSTF}" 
[ "$FORCE_TCOM_FON" = "y" ] || sed -i -e "s|FORCE_TCOM_FON||" "${DSTF}"
[ "$MOVE_ALL_XXX" = "y" ] && sed -i -e "s|MOVE_ALL_XXX|<li><b>Freetz-Compatibility:</b> directory www/all has been <b>changed</b> to www/$OEM.</li>|" "${DSTF}" 
[ "$MOVE_ALL_XXX" = "y" ] || sed -i -e "s|MOVE_ALL_XXX||" "${DSTF}"
[ "$FORCE_CLEAR_FLASH" = "y" ] && sed -i -e "s|FORCE_CLEAR_FLASH|<li><b>Factory-setting:</b> This Firmware did invoke a factory reset, when the update was made.</li>|" "${DSTF}" 
[ "$FORCE_CLEAR_FLASH" = "y" ] || sed -i -e "s|FORCE_CLEAR_FLASH||" "${DSTF}"
[ "$ATA_ONLY" = "y" ] && sed -i -e "s/^.*ANNEX.*$/<li><b>Annex:<\/b> Annex is not in use, Box is in <b>'ATA'<\/b> mode, LAN1 is used as up link\. <\/li>/" "${DSTF}"
[ "$CONFIG_TR069" = "y" ] && sed -i -e "s/AUTOCONF/is set to on/" "${DSTF}" 
[ "$CONFIG_TR069" = "y" ] && sed -i -e "s/ATACONF/ ATA is disabled/" "${DSTF}"
[ "$CONFIG_TR069" = "y" ] || sed -i -e "s/AUTOCONF/is set to off/" "${DSTF}" 
[ "$CONFIG_TR069" = "y" ] || sed -i -e "s/ATACONF//" "${DSTF}"
[ "$CONFIG_TR064" = "y" ] && sed -i -e "s/LANTR64TEXT/is set to on/" "${DSTF}" 
[ "$CONFIG_TR064" = "y" ] || sed -i -e "s/LANTR64TEXT/is set to off/" "${DSTF}"
[ -n "$NEWNAME" ] && sed -i -e "s/PREFIX/'${NEWNAME}'/" "${DSTF}"
[ -n "$NEWNAME" ] || sed -i -e "s/PREFIX/not/" "${DSTF}"
[ "$DO_LOOKUP_PATCH" = "y" ] && sed -i -e "s/PATCH/executed/" "${DSTF}" 
[ "$DO_LOOKUP_PATCH" = "y" ] || sed -i -e "s/PATCH/not executed/" "${DSTF}"
[ "$REMOVE_MENU_ITEM" = "y" ] && sed -i -e "s/FONMENU/adapted/" "${DSTF}" 
[ "$REMOVE_MENU_ITEM" = "y" ] || sed -i -e "s/FONMENU/not adapted/" "${DSTF}"
[ "$XCHANGE_KERNEL" = "y" ] && sed -i -e "s/XCHANGE_KERNEL/ exchanged /" "${DSTF}" 
[ "$XCHANGE_KERNEL" = "y" ] || sed -i -e "s/XCHANGE_KERNEL/not exchanged /" "${DSTF}"
#////////////////////////////////////////////////////////////////
fi
#-------------------------------------------------------------------------------------------------------------------
fi
done

exit 0

