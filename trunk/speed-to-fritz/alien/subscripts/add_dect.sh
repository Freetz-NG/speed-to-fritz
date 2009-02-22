#!/bin/bash

OEMLIST="$3"
#Source 2
SR2="$2"
#Source 1
SR1="$1" 
 # include modpatch function
 . ${include_modpatch}
echo "-- Adding DECT handsets setup pages..."

# copy missing files if not existent

for OEMDIR in $OEMLIST; do
 if [ "$avm_Lang" = "en" ] ; then
  TextHandteile="DECT-handsets"
  TextDectPin="DECT-Basis PIN"
  TextDectSetPin="setup PIN"
  TextNebenstelle="Extetion"
  DECTEinstellungen="DECT-settings"
  DECT="DECT"
  html="html"
 else
  TextHandteile="DECT-Handteile"
  TextDectPin="DECT-Basisstation PIN"
  TextDectSetPin="PIN setzen"
  TextNebenstelle="Nebenstelle"
  DECTEinstellungen="DECT-Einstellungen"
  DECT="DECT"
  html="html"
 fi
 USRWWW="usr/www/${OEMDIR}/$html/de"
 Unicode_ut8="n"
 `cat "$SR1"/usr/www/${OEMDIR}/$html/index.html | grep -q 'charset=utf-8' ` && Unicode_ut8="y" 
 # echo "ut8: $Unicode_ut8"
 #normal condition patching menues for dect
 if [ -d "$SR1/usr/www/${OEMDIR}" ]; then
  if [ ! -d "$SR1"/${USRWWW}/dect ]; then
    mkdir  "$SR1/${USRWWW}/dect"
  fi
  [ "$ADD_7150_DECTMNUE" = "y" ] && [ "$avm_Lang" = "de" ] && . "$sh_DIR/add_dect_7150.inc"
  [ "$ADD_7150_DECTMNUE" = "y" ] && [ "$avm_Lang" = "en" ] && . "$sh_DIR/add_dect_7150_en.inc"
  ##add dect menue pages
  #    for FILE in `ls ./addon/$avm_Lang/fon_dect`; do
  #	[ -n "$VERBOSITY" ] && echo "      /${USRWWW}/fon/$FILE"
  #	cp -p ./addon/$avm_Lang/fon_dect/$FILE "$SR1"/${USRWWW}/fon/$FILE
  #    done
  if [ "$ADD_OLD_DECTMENU" = "y" ]; then
      PatchfileName="add_dect_de"
   [ -f "$P_DIR/${PatchfileName}_ut8.patch" ] && iconv --from-code=UTF-8 --to-code=ISO-8859-1 "$P_DIR/${PatchfileName}_ut8.patch" > "$P_DIR/${PatchfileName}.patch" 
   [ -f "$P_DIR/${PatchfileName}_ut8.patch" ] || iconv --from-code=ISO-8859-1 --to-code=UTF-8 "$P_DIR/${PatchfileName}.patch" > "$P_DIR/${PatchfileName}_ut8.patch" 
   [ "$Unicode_ut8" = "n" ] && [ "$avm_Lang" = "de" ] && modpatch "$SR1" "$P_DIR/${PatchfileName}.patch"
   [ "$Unicode_ut8" = "y" ] && [ "$avm_Lang" = "de" ] && modpatch "$SR1" "$P_DIR/${PatchfileName}_ut8.patch"
   [ "$avm_Lang" = "en" ] && modpatch "$SR1" "$P_DIR/add_dect_en.patch"
   #the folowing patch must be after the above line becase it patches a file added by add_dect_**.patch
   sed -i -e "/var bits = (String.fromCharCode(bits + 48));/d" "$SR1"/${USRWWW}/fon/fon1dect.js
   [ -f "$SR1/${USRWWW}/fon/fon1dect.js" ] && [ "$ADD_OLD_DECTMENU" = "y" ] || echo "worong firmware combinations!" >"${HOMEDIR}/${ERR_LOGFILE}"
   [ $TCOM_V_MINOR -gt 38 ] && sed -i -e 's/jslSetValue("uiPostHandsets", bits);/var bits = (String.fromCharCode(bits + 48));\
jslSetValue("uiPostHandsets", bits);/' "$SR1"/${USRWWW}/fon/fon1dect.js
   #add dect menue entrys for old menutype
     DIRI="$SR1"/${USRWWW}/menus
    if ! `cat ${DIRI}/menu2_fon.html | grep -q "('fon','dect0')"` ; then
    sed -i -e "/^.*'fondevices'.*$/a \
<? setvariable var:classname 'LSubitem' ?>\n\
<? if eq \$var:pagename dect0 \`<? setvariable var:classname 'LSubitemaktiv' ?>\` ?>\n\
<? if eq \$var:pagename foneditdect \`<? setvariable var:classname 'LSubitemaktiv' ?>\` ?>\n\
<? if eq \$var:pagename fonsetupdect \`<? setvariable var:classname 'LSubitemaktiv' ?>\` ?>\n\
<? if eq \$var:pagename fonlistdect \`<? setvariable var:classname 'LSubitemaktiv' ?>\` ?>\n\
<? if eq \$var:pagename fon1isdn \`<? setvariable var:classname 'LSubitemaktiv' ?>\` ?>\n\
<li class=\"<? echo \$var:classname ?>\"><img class=\"LMenuPfeil\" src=\"<? echo \$var:subpfeil ?>\"><a href=\"javascript:jslGoTo('fon','dect0')\">${TextHandteile}<\/a><span class=\"PTextOnly\">${TextHandteile}<\/span><\/li>" "${DIRI}"/menu2_fon.html
   fi
  fi

  # 7170 mod dect is missing
  if [ "$FBMOD" = "7170" ] ; then
 echo "-- FBBOX mode: 7170"
 # add some dect specific text variablels to diverse include files 
 echo "<? setvariable var:TextMenuDECT \"DECT\" ?>" >>"$SR1/${USRWWW}/menus/menu2.inc"
 echo "<? setvariable var:TextSetting \"setting\" ?>" >>"$SR1/${USRWWW}/menus/menu2_konfig.inc"
 echo "<? setvariable var:TextHandset \"handset\" ?>" >>"$SR1/${USRWWW}/menus/menu2_konfig.inc"
 echo "<input type=\"hidden\" name=\"var:FromMenuDect\" value=\"<? echo $var:FromMenuDect ?>\" id=\"uiFromMenuDect\">" >>"$SR1/${USRWWW}/home/fon1Mini.frm"
 echo "<input type=\"hidden\" name=\"var:FromMenuDect\" value=\"<? echo $var:FromMenuDect ?>\" id=\"uiFromMenuDect\">" >>"$SR1/${USRWWW}/home/fondevices.frm"
 echo "<input type=\"hidden\" name=\"dect:command/Unsubscribe\" value=\"0\" id=\"uiPostUnsubscribe\" disabled>" >>"$SR1/${USRWWW}/home/fondevices.frm" 
 echo "<input type=\"hidden\" name=\"dect:command/PIN\" value=\"\" id=\"uiPostDectPIN\" disabled>" >>"$SR1/${USRWWW}/home/fondevices.frm"
 echo "<input type=\"hidden\" name=\"var:FromMenuDect\" value=\"<? echo $var:FromMenuDect ?>\" id=\"uiFromMenuDect\">" >>"$SR1/${USRWWW}/menus/klingelsperre_mimi.frm"
 echo "<? setvariable var:Text27 '${TextHandteile}' ?>" >>"$SR1/${USRWWW}/home/fondevices.inc"
 echo "<? setvariable var:Text30 'Name' ?>" >>"$SR1/${USRWWW}/home/fondevices.inc"
 echo "<? setvariable var:TextDectPin '${TextDectPin}' ?>" >>"$SR1/${USRWWW}/home/fondevices.inc"
 echo "<? setvariable var:TextDectSetPin '${TextDectSetPin}' ?>" >>"$SR1/${USRWWW}/home/fondevices.inc"

 #add Dect PIN  on "fondevices" page (not used becaus seting of dect pin is not usable up to now)

sed -i -e '/<\/script>/i\
function DectDeviceInfoEntry ( UserNId, FonControlUserId, isSubscribed) {\
this.nUserNId = UserNId;\
this.nFonControlUserId = FonControlUserId;\
this.bisSubscribed = isSubscribed;\
}\
var g_DectDeviceInfoList= new Array();\
var g_DectDeviceInfoListCnt=0;\
function AddDectDeviceInfo(dectID, isSubscribed, UserId)\
{\
g_DectDeviceInfoList[dectID]= new DectDeviceInfoEntry( dectID,UserId,isSubscribed);\
g_DectDeviceInfoListCnt++;\
}\
function GetDectDeviceNId(FonControlUserId)\
{\
for ( var j=0; j<g_DectDeviceInfoListCnt; j++) {\
if(g_DectDeviceInfoList[j].nFonControlUserId==FonControlUserId)\
return g_DectDeviceInfoList[j].nUserNId;\
}\
return null;\
}\
function uiDoDeleteDectDevice(id)\
{\
if (!confirm(g_mldDelete)) return;\
nId=GetDectDeviceNId(id);\
if(nId==null)\
{\
}\
else\
{\
var nSubscribedDeviceCount = 0;\
<? multiquery dect:settings/Handset/list(Subscribed) `\
if ( "$2" == "1") nSubscribedDeviceCount++;\
` ?>\
if (nSubscribedDeviceCount > 0)\
nSubscribedDeviceCount--;\
jslSetValue("uiDectDeviceCount", nSubscribedDeviceCount);\
jslSetValue( "uiPostUnsubscribe", nId);\
jslEnable( "uiPostUnsubscribe");\
jslSubmitFormEx(g_menu, "fondevices", "fondevices");\
}\
}\
function uiOnDectSetPin(){\
pin=jslGetValue("uiPinInput");\
if (pin.length != 4 || !valIsZahl(pin) ) {alert(g_mldPin); return;}\
jslCopyValue("uiPostDectPIN", "uiPinInput");\
jslEnable("uiPostDectPIN")\
jslFormSubmitEx("fon", "fondevices");\
}' "$SR1"/${USRWWW}/home/fondevices.js
 
 

 #add Dect info on "home" page
    sed -i -e "/function RufumleitungDisplay() {/i\
function DectStateTitle(asLink) {\n\
var str = \"\";\n\
if (asLink) str += \"<a href=\\\\\"javascript:jslGoTo('dect', 'setting');\\\\\">\";\n\
str += \"DECT\";\n\
if (asLink) str += \"</a>\";\n\
return str;\n\
}\n\
function DectLed() {\n\
var str = \"<img src=\\\\\"..\/html\/de\/images\/led_gray.gif\\\\\">\";\n\
<? if eq '<? query dect:settings\/enabled ?>' '1' \`\n\
str = \"<img src=\\\\\"..\/html\/de\/images\/led_green.gif\\\\\">\";\n\
\` ?>\n\
return str;\n\
}\n\
\n\
function DectStateDisplay() {\n\
var g_countDect2 = 0;\n\
<? if eq '<? query dect:settings\/enabled ?>' '0' \`\n\
return \"aus\";\n\
\` ?>\n\
//g_countDect2\n\
<? multiquery dect:settings\/Handset\/list(Subscribed) \`\n\
if ( \"\$2\" == \"1\") g_countDect2++;\n\
\` ?>\n\
var str = new Array(\" Schnurlostelefon\",\" angemeldet\");\n\
switch (g_countDect2)\n\
{\n\
case 0: return \"an, kein\" + str.join(\"\");\n\
case 1: return \"an, ein\" + str.join(\"\");\n\
default: return \"an, \"+g_countDect2+str.join(\"e\");\n\
}\n\
}" "$SR1"/${USRWWW}/home/home.js



    sed -i -e '/var g_tamActive =/a\
var mCount = "<? query telcfg:settings/Foncontrol ?>";' "$SR1"/${USRWWW}/home/home.js

 #add infoled on main web page
    sed -i -e '/case "11":/a\
case "12": str += "Bei aktiviertem DECT"; break;' "$SR1"/${USRWWW}/home/home.js
 #add dect info on main web page
sed -i -e '/DslStateDisplay()/a\
<\/tr>\
<tr>\
<td class="tdName"><script type="text\/javascript">document.write(DectStateTitle(true));<\/script><\/td>\
<td class="tdLed"><script type="text\/javascript">document.write(DectLed());<\/script><\/td>\
<td><script type="text\/javascript">document.write(DectStateDisplay());<\/script><\/td>' "$SR1"/${USRWWW}/home/home.html

 #add dect menue entrys
 DIRI="$SR1"/${USRWWW}/menus
 if ! `cat ${DIRI}/menu2_konfig.html | grep -q "('dect',"` ; then
  sed -i -e "/^.*('wlan','wlan').*$/a \
\` ?>\n\
<li class=\"LMenuitem\"><img class=\"LMenuPfeil\" src=\"<? echo \$var:aktivpfeil ?>\"><a href=\"javascript:jslGoTo('dect','setting')\">${DECT}<\/a><span class=\"PTextOnly\">${DECT}<\/span><\/li>\n\
<!-- wlan:settings\/ap_enabled = '<? query wlan:settings\/ap_enabled ?>' -->\n\
<? setvariable var:showDect 1 ?>\n\
<? if eq <? query dect:settings\/enabled ?> 1 '<? setvariable var:showDect 1 ?>' ?>\n\
<? setvariable var:classsetting 'LSubitem' ?>\n\
<? if eq $var:pagename setting \`<? setvariable var:classsetting 'LSubitemaktiv' ?>\` ?>\n\
<? setvariable var:classhandset 'LSubitem' ?>\n\
<? if eq $var:pagename handset \`<? setvariable var:classhandset 'LSubitemaktiv' ?>\` ?>\n\
<? if eq $var:showDect 0 \`\n\
<li class=\"\$var:classsetting\"><img class=\"LMenuPfeil\" src=\"\$var:subpfeil\"><a href=\"javascript:jslGoTo('dect','setting')\">${DECTEinstellungen}<\/a><span class=\"PTextOnly\">${DECTEinstellungen}<\/span><\/li>" "${DIRI}"/menu2_konfig.html
 fi
# #additional pages
# cp -fdfp ./addon/tmp/$SPMOD/$avm_Lang/tam.html "$SR1"/usr/www/${OEMDIR}/$html 
# cp -fdfp ./addon/tmp/$SPMOD/$avm_Lang/dect.html "$SR1"/usr/www/${OEMDIR}/$html 

 #add missing menue
    PatchfileName="add_dect_on-off_de"
   [ -f "$P_DIR/${PatchfileName}_ut8.patch" ] && iconv --from-code=UTF-8 --to-code=ISO-8859-1 "$P_DIR/${PatchfileName}_ut8.patch" > "$P_DIR/${PatchfileName}.patch" 
   [ -f "$P_DIR/${PatchfileName}_ut8.patch" ] || iconv --from-code=ISO-8859-1 --to-code=UTF-8 "$P_DIR/${PatchfileName}.patch" > "$P_DIR/${PatchfileName}_ut8.patch" 
   [ "$Unicode_ut8" = "n" ] && [ "$avm_Lang" = "de" ] && modpatch "$SR1" "$P_DIR/${PatchfileName}.patch"
   [ "$Unicode_ut8" = "y" ] && [ "$avm_Lang" = "de" ] && modpatch "$SR1" "$P_DIR/${PatchfileName}_ut8.patch"
 [ "$avm_Lang" = "en" ] && modpatch "$SR1" "$P_DIR/add_dect_on-off_en.patch"
# DIRI=$1/${USRWWW}/menus
# [ -f ${DIRI}/menu2_dect.html ] || cp -fdfp ./addon/tmp/$SPMOD/$avm_Lang/menus/* "${DIRI}"
# DIRI=$1/${USRWWW}/dect
# [ -f ${DIRI}/settings.html ] || cp -fdfp ./addon/tmp/$SPMOD/$avm_Lang/dect/* "${DIRI}"

 #add dect info to infoled page
# [ -f ${DIRI}/infoled.js ] || cp -fdfp ./addon/tmp/$SPMOD/$avm_Lang/system/infoled.* "${DIRI}"
 DIRI=$SR1/${USRWWW}/system
 if ! `cat ${DIRI}/infoled.html | grep -q 'option value="12"'` ; then
  [ "$avm_Lang" = "de" ] && sed -i -e "/option value=.11/a \
<option value=\"12\">leuchtet bei aktivem DECT<\/option>" "${DIRI}/infoled.html"
  [ "$avm_Lang" = "en" ] && sed -i -e "/option value=.11/a \
<option value=\"12\">Is flashing if DECT is activ<\/option>" "${DIRI}/infoled.html"
 fi
fi
#7170 end ------------
#add tabs for nebenstelle on fondeviceses page    
    sed -i -e "/uiDoMsn()/a\
<li><a href=\"javascript:uiDoEditDevice( 0, 0, 0)\">${TextNebenstelle} 1<\/a><\/li>\
<li><a href=\"javascript:uiDoEditDevice( 0, 1, 0)\">${TextNebenstelle} 2<\/a><\/li>\
<li><a href=\"javascript:uiDoEditDevice( 1, 0, 11)\">S0 Buss Int.<\/a><\/li>" "$SR1"/${USRWWW}/home/fondevices.html
#remove tabs again if this model is without S0
[ "$CONFIG_IsdnNT" = "0" ] && sed -i -e '/<li><a href="javascript:uiDoEditDevice( 1, 0, 11)">S0 Buss Int.<\/a><\/li>/d' "$SR1"/${USRWWW}/home/fondevices.html
#remove tabs again if this model is without intenal Fon
[ "$CONFIG_AB_COUNT" = "0" ] && sed -i -e '/<li><a href="javascript:uiDoEditDevice( 0, ., 0)">/d' "$SR1"/${USRWWW}/home/fondevices.html
  
 if [ "$REMOVE_HELP" = "n" ]; then
    PatchfileName="add_decthelp_de"
   [ -f "$P_DIR/${PatchfileName}_ut8.patch" ] && iconv --from-code=UTF-8 --to-code=ISO-8859-1 "$P_DIR/${PatchfileName}_ut8.patch" > "$P_DIR/${PatchfileName}.patch" 
   [ -f "$P_DIR/${PatchfileName}_ut8.patch" ] || iconv --from-code=ISO-8859-1 --to-code=UTF-8 "$P_DIR/${PatchfileName}.patch" > "$P_DIR/${PatchfileName}_ut8.patch" 
   [ "$Unicode_ut8" = "n" ] && [ "$avm_Lang" = "de" ] && modpatch "$SR1" "$P_DIR/${PatchfileName}.patch"
   [ "$Unicode_ut8" = "y" ] && [ "$avm_Lang" = "de" ] && modpatch "$SR1" "$P_DIR/${PatchfileName}_ut8.patch"
     [ "$avm_Lang" = "en" ] && modpatch "$SR1" "$P_DIR/add_decthelp_en.patch"


#    [ -n "$VERBOSITY" ] && echo "      /${USRWWW}/help/hilfe_fon_setupdect.html"
#    cp -fp ./addon/$avm_Lang/help/hilfe_fon_setupdect.html "$SR1"/${USRWWW}/help/hilfe_fon_setupdect.html
#    [ -n "$VERBOSITY" ] && echo "      /${USRWWW}/help/hilfe_fon_editdect.html"
#    cp -fp ./addon/$avm_Lang/help/hilfe_fon_editdect.html "$SR1"/${USRWWW}/help/hilfe_fon_editdect.html
#    [ -n "$VERBOSITY" ] && echo "      /${USRWWW}/help/hilfe_fon_fon1dect.html"
#    cp -fp ./addon/$avm_Lang/help/hilfe_fon_editdect.html "$SR1"/${USRWWW}/help/hilfe_fon_fon1dect.html
#
#    [ -n "$VERBOSITY" ] && echo "      /${USRWWW}/help/hilfe_fon_dect.html"
#    cp -fp ./addon/$avm_Lang/help/hilfe_fon_dect.html "$SR1"/${USRWWW}/help/hilfe_fon_dect.html
#    [ -n "$VERBOSITY" ] && echo "      /${USRWWW}/help/hilfe_fon_dect_festnetzrufnummer.html"
#    cp -fp ./addon/$avm_Lang/help/hilfe_fon_dect_festnetzrufnummer.html "$SR1"/${USRWWW}/help/hilfe_fon_dect_festnetzrufnummer.html
#    [ -n "$VERBOSITY" ] && echo "      /${USRWWW}/help/hilfe_fon_dect_fon1isdn.html"
#    cp -fp ./addon/$avm_Lang/help/hilfe_fon_dect_fon1isdn.html "$SR1"/${USRWWW}/help/hilfe_fon_dect_fon1isdn.html
#    [ -n "$VERBOSITY" ] && echo "      /${USRWWW}/help/hilfe_fon_listdect.html"
#    cp -fp ./addon/$avm_Lang/help/hilfe_fon_listdect.html "$SR1"/${USRWWW}/help/hilfe_fon_listdect.html

  fi

 fi
done


exit 0
 