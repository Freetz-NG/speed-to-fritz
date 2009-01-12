#!/bin/bash
USRWWW="usr/www/${OEMDIR}/$html/${avm_Lang}"
#normal condition patching menues for dect
if [ -d "$SR1/usr/www/${OEMDIR}" ]; then
  #build link files used on .56 7150 type dect menu
  for FILE in "dect0" "fon1dect" "fonlistdect" "foneditdect" "fonsetupdect"  ; do
    for EXT in "frm" "html" "inc" "js"  ; do
	DSTF="$SR1/${USRWWW}/home/${FILE}.${EXT}"
	rm -f "${DSTF}"
	touch "${DSTF}"
	echo2 "-> $FILE.$EXT"
    	echo "<? include ../html/\$var:lang/fon/$FILE.$EXT ?>" >"${DSTF}"
    done
  done
      PatchfileName="add_7150_dect_de"
   [ -f "$P_DIR/${PatchfileName}_ut8.patch" ] && iconv --from-code=UTF-8 --to-code=ISO-8859-1 "$P_DIR/${PatchfileName}_ut8.patch" > "$P_DIR/${PatchfileName}.patch" 
   [ -f "$P_DIR/${PatchfileName}_ut8.patch" ] || iconv --from-code=ISO-8859-1 --to-code=UTF-8 "$P_DIR/${PatchfileName}.patch" > "$P_DIR/${PatchfileName}_ut8.patch" 
   [ "$Unicode_ut8" = "n" ] && [ "$OEMDIR" = "avm" ] && [ "$avm_Lang" = "de" ] && modpatch "$SR1" "$P_DIR/${PatchfileName}.patch"
   [ "$Unicode_ut8" = "y" ] && [ "$OEMDIR" = "avm" ] && [ "$avm_Lang" = "de" ] && modpatch "$SR1" "$P_DIR/${PatchfileName}_ut8.patch"
#-------------------------------------------------------------------------------- 
FN="$SR1/${USRWWW}/home/fondevices.html"
sed -i -e "/<div id=\"uiShowFonTable\" style=\"display:none\">/i\
<\/div>" "$FN"
sed -i -e '/"DeviceIsdnDefauft"/a\
<? repeat [ 0 5 ] `\
<script type="text\/javascript">document.write(TrDevice( "DeviceFonDect$0", $0, "2", "<? query dect:settings\/Handset$0\/Name ?>", " ","0", "<? query dect:settings\/Handset$0\/Subscribed ?>"));<\/script>\
` ?>' "$FN"
#sed -i -e '/"DeviceABExt$0", $0,/a\
#<? repeat [ 0 5 ] `\
#<script type="text\/javascript">document.write(TrDeviceEx( "DeviceFonDect$0", $0, "2", "<? query dect:settings\/Handset$0\/Name ?>", "<? query telcfg:settings\/MSN\/NTDefault ?>","0", "<? query dect:settings\/Handset$0\/Subscribed ?>"));<\/script>\
#` ?>' "$FN"
sed -i -e 's/ 0 2 / 0 1 /' "$FN"
FN="$SR1/${USRWWW}/fon_config/fon_config_fondevices.html"
sed -i -e '/"DeviceIsdnDefauft", 0, "1"/a\
<? repeat [ 0 5 ] `\
<script type="text\/javascript">document.write(TrDevice( "DeviceFonDect$0", $0, "2", "<? query dect:settings\/Handset$0\/Name ?>", " ","0", "<? query dect:settings\/Handset$0\/Subscribed ?>"));<\/script>\
` ?>' "$FN"
sed -i -e 's/ 0 2 / 0 1 /' "$FN"
FN="$SR1/${USRWWW}/fon_config/fon_config_Start.html"
sed -i -e '/txtPhoneInfoText+=g_txtISDNTelefon;/a\
txtPhoneInfoText+=", "+g_txtDectHG;' "$FN"
FN="$SR1/${USRWWW}/fon_config/fon_config_Start.js"
sed -i -e '/var g_txtISDNTelefon/i\
var g_txtDectHG="Schnurlostelefone (DECT)";' "$FN"
FN="$SR1/${USRWWW}/fon_config/fon_config_fondevices.frm"
echo '<? repeat [ 0 5 ] `' >>"$FN"
echo '<input type="hidden" name="dect:settings/Handset$0/Subscribed" value="<? query dect:settings/Handset$0/Subscribed ?>" id="uiPostHandset$0Subscribe" disabled>' >>"$FN"
echo '<input type="hidden" name="dect:settings/Handset$0/Type" value="<? query dect:settings/Handset$0/Type ?>" id="uiPostHandset$0Type" disabled>' >>"$FN"
echo '<input type="hidden" name="dect:settings/Handset$0/Name" value="<? query dect:settings/Handset$0/Name ?>" id="uiPostHandset$0Notation" disabled>' >>"$FN"
echo '` ?>' >>"$FN"
echo '<? repeat [ 0 4 ] `' >>"$FN"
echo '<input type="hidden" name="dect:settings/MSN$0/MSN" value="<? query dect:settings/MSN$0/MSN ?>" id="uiPostDectMsn$0" disabled>' >>"$FN"
echo '<input type="hidden" name="dect:settings/MSN$0/Handsets" value="<? querytext dect:settings/MSN$0/Handsets ?>" id="uiPostDectHandsets$0" disabled>' >>"$FN"
echo '` ?>' >>"$FN"
echo '<input type="hidden" name="dect:settings/RingOnAllMSNs" value="<? query dect:settings/RingOnAllMSNs ?>" id="uiPostDectRingAllMsns" disabled>' >>"$FN"
echo '<input type="hidden" name="dect:command/Unsubscribe" value="" id="uiPostUnsubscribeDect" disabled>' >>"$FN"
echo '<Input type="hidden" name="var:DectID" value="<? echo $var:DectID ?>" id="uiPostDectID">' >>"$FN"
FN="$SR1/${USRWWW}/home/fondevices.frm"
echo '<? repeat [ 0 5 ] `' >>"$FN"
echo '<input type="hidden" name="dect:settings/Handset$0/Subscribed" value="<? query dect:settings/Handset$0/Subscribed ?>" id="uiPostHandset$0Subscribe" disabled />' >>"$FN"
echo '<input type="hidden" name="dect:settings/Handset$0/Type" value="<? query dect:settings/Handset$0/Type ?>" id="uiPostHandset$0Type" disabled />' >>"$FN"
echo '<input type="hidden" name="dect:settings/Handset$0/Name" value="<? query dect:settings/Handset$0/Name ?>" id="uiPostHandset$0Notation" disabled />' >>"$FN"
echo '` ?>' >>"$FN"
echo '<? repeat [ 0 4 ] `' >>"$FN"
echo '<input type="hidden" name="dect:settings/MSN$0/MSN" value="<? query dect:settings/MSN$0/MSN ?>" id="uiPostDectMsn$0" disabled />' >>"$FN"
echo '<input type="hidden" name="dect:settings/MSN$0/Handsets" value="<? querytext dect:settings/MSN$0/Handsets ?>" id="uiPostDectHandsets$0" disabled />' >>"$FN"
echo '` ?>' >>"$FN"
echo '<input type="hidden" name="dect:settings/RingOnAllMSNs" value="<? query dect:settings/RingOnAllMSNs ?>" id="uiPostDectRingAllMsns" disabled />' >>"$FN"
echo '<input type="hidden" name="dect:command/Unsubscribe" value="" id="uiPostUnsubscribeDect" disabled />' >>"$FN"
echo '<Input type="hidden" name="var:DectID" value="<? echo $var:DectID ?>" id="uiPostDectID">' >>"$FN"
if [ "$Unicode_ut8" = "n" ]; then 
FN="$SR1/${USRWWW}/help/home.html"
sed -i -e "/<h2>B<\/h2>/i\
<P><a href=\"javascript:opener.jslPopHelp('hilfe_fon_dect')\">DECT-Engeräte<\/a><\/P>" "$FN"
sed -i -e "/<h2>E<\/h2>/i\
<P><a href=\"javascript:opener.jslPopHelp('hilfe_budget')\">Dynamic DNS<\/a><\/P>" "$FN"
sed -i -e "/<h2>T<\/h2>/i\
<P><a href=\"javascript:opener.jslPopHelp('hilfe_fon_dect')\">Schnurlostelefone (DECT)<\/a><\/P>" "$FN"
sed -i -e "/<h2>V<\/h2>/i\
<P><a href=\"javascript:opener.jslPopHelp('hilfe_client')\">U-APSD<\/a><\/P>" "$FN"
sed -i -e "/WLAN-Netzwerkger/i\
<P><a href=\"javascript:opener.jslPopHelp('hilfe_client')\">WLAN-Netzwerkgeräte<\/a><\/P>" "$FN"
sed -i -e "/WLAN-Verschl.sselung/a\
<P><a href=\"javascript:opener.jslPopHelp('hilfe_client')\">WLAN-Verschlüsselung<\/a><\/P>" "$FN"
sed -i -e "/<h2>Z<\/h2>/a\
<P><a href=\"javascript:opener.jslPopHelp('hilfe_hilfe_dyndns')\">DSL-Einstellungen<\/a><\/P>" "$FN"
sed -i -e "/zusï¿½tzliche Programme/a\
<P><a href=\"hilfe_wlan_repeater_sicherheit.html\">Repeater, Verschlüsselung<\/a><\/P>" "$FN"
else
FN="$SR1/${USRWWW}/help/home.html"
sed -i -e "/<h2>B<\/h2>/i\
<P><a href=\"javascript:opener.jslPopHelp('hilfe_fon_dect')\">DECT-EngerÃ¤te<\/a><\/P>" "$FN"
sed -i -e "/<h2>E<\/h2>/i\
<P><a href=\"javascript:opener.jslPopHelp('hilfe_budget')\">Dynamic DNS<\/a><\/P>" "$FN"
sed -i -e "/<h2>T<\/h2>/i\
<P><a href=\"javascript:opener.jslPopHelp('hilfe_fon_dect')\">Schnurlostelefone (DECT)<\/a><\/P>" "$FN"
sed -i -e "/<h2>V<\/h2>/i\
<P><a href=\"javascript:opener.jslPopHelp('hilfe_client')\">U-APSD<\/a><\/P>" "$FN"
sed -i -e "/WLAN-Netzwerkger/i\
<P><a href=\"javascript:opener.jslPopHelp('hilfe_client')\">WLAN-NetzwerkgerÃ¤te<\/a><\/P>" "$FN"
sed -i -e "/WLAN-Verschl.sselung/a\
<P><a href=\"javascript:opener.jslPopHelp('hilfe_client')\">WLAN-VerschlÃ¼sselung<\/a><\/P>" "$FN"
sed -i -e "/<h2>Z<\/h2>/a\
<P><a href=\"javascript:opener.jslPopHelp('hilfe_hilfe_dyndns')\">DSL-Einstellungen<\/a><\/P>" "$FN"
sed -i -e "/zusï¿½tzliche Programme/a\
<P><a href=\"hilfe_wlan_repeater_sicherheit.html\">Repeater, VerschlÃ¼sselung<\/a><\/P>" "$FN"
fi
FN="$SR1/${USRWWW}/home/fondevices.js"
sed -i -e 's|var mCount|//var mCount|' "$FN"
sed -i -e '/var g_txt_Device_AB = "Anrufbeantworter";/a\
var g_txtDect = "Schnurlostelefon (DECT) ";' "$FN"
sed -i -e '/var g_txt_Type_Mini/a\
var g_txt_Type_Dect = "Schnurlostelefon (DECT)";' "$FN"
sed -i -e '/case "1"/a\
case "2" : strRetCode ="DECT";break;' "$FN"
sed -i -e '/<? repeat . 0 2 . `/i\
for ( var j=0;j<6;j++) {\
if ((jslGetValue("uiPostHandset"+j+"Subscribe") == "1") && (jslGetValue("uiPostHandset"+j+"Notation") != "")) {\
jslDisplay( "uiDeviceFonDect"+j,true);\
g_FonDeviceFound = true;\
}\
}' "$FN"
sed -i -e 's/ 0 2 / 0 1 /' "$FN"
sed -i -e 's|fon1.ect", "fondevices|dect0", "fondevices|' "$FN"
sed -i -e '/if ((jslGetValue("uiPostIsdnName"+j) == "") || (jslGetValue("uiPostIsdnNummer"+j) == "")) return false;/a\
}\
for (var k=0; k<5; k++) {\
if (jslGetValue("uiPostHandset"+k+"Subscribe") == "0") return false;\
if ((jslGetValue("uiPostHandset"+k+"Subscribe") == "1") && (jslGetValue("uiPostHandset"+k+"Notation") == ""))return false;' "$FN"
sed -i -e '/<\/script>/i\
function RingToAll( nValue) {\
for ( var i=0;i<5;i++) {\
if ( IsHandsetConfigured( i, nValue) == false) return false;\
}\
return true;\
}\
function IsHandsetConfigured( nPos, wert) {\
var oldHandset = jslGetValue( "uiPostDectHandsets"+nPos).charCodeAt(0) - 48;\
if ( (oldHandset & wert) == wert) return true;\
return false;\
}' "$FN"

FN="$SR1/${USRWWW}/fon_config/fon_config_fondevices.js"
sed -i -e 's|var mCount|//var mCount|' "$FN"
sed -i -e '/var g_txt_Type_Mini/a\
var g_txt_Type_Dect = "Schnurlostelefon (DECT)";' "$FN"
sed -i -e '/case "1"/a\
case "2" : strRetCode ="DECT";break;' "$FN"
sed -i -e '/<? repeat . 0 2 . `/i\
for ( var j=0;j<6;j++) {\
if ((jslGetValue("uiPostHandset"+j+"Subscribe") == "1") && (jslGetValue("uiPostHandset"+j+"Notation") != "")) {\
jslDisplay( "uiDeviceFonDect"+j,true);\
g_FonDeviceFound = true;\
}\
}' "$FN"
sed -i -e 's/ 0 2 / 0 1 /' "$FN"
#sed -i -e '/function NoUnconfiguredPortsExists() {/a\
#for (var k=0; k<5; k++) {\
#if (jslGetValue("uiPostHandset"+k+"Subscribe") == "0") return false;\
#if ((jslGetValue("uiPostHandset"+k+"Subscribe") == "1") && (jslGetValue("uiPostHandset"+k+"Notation") == ""))return false;' "$FN"

sed -i -e '/if ((jslGetValue("uiPostIsdnName"+j) == "") || (jslGetValue("uiPostIsdnNummer"+j) == "")) return false;/a\
}\
for (var k=0; k<5; k++) {\
if (jslGetValue("uiPostHandset"+k+"Subscribe") == "0") return false;\
if ((jslGetValue("uiPostHandset"+k+"Subscribe") == "1") && (jslGetValue("uiPostHandset"+k+"Notation") == ""))return false;' "$FN"


FN="$SR1/${USRWWW}/fon_config/fon_config_End.frm"
sed -i -e '/<!-- end of neq ConfigSaved else -->/i\
<!-- DECT Device List -->\
<? repeat [ 0 5 ] `\
<input type="hidden" name="dect:settings/Handset$10/Subscribed" value="<? query dect:settings/Handset$10/Subscribed ?>" id="uiPostDectSubscribed$10" disabled>\
<input type="hidden" name="dect:settings/Handset$10/Name" value="<? query dect:settings/Handset$10/Name ?>" id="uiPostDectName$10" disabled>\
` ?>\
<!-- DECT Device List end -->' "$FN" 
FN="$SR1/${USRWWW}/fon_config/fon_config_End.js"
sed -i -e '/<\/script>/i\
function uiDisplayDectID(index) {\
var str="";\
str += (parseInt(index)+1);\
return str;\
}\
function uiDistributeDectMsns() {\
var varText = "<? echo `$var:ShowCallInNo` ?>";\
var ar_Reset = new Array(true,true,true,true,true);\
var arInCallNo = varText.split( ";", 10);\
for ( var i=0; i<(arInCallNo.length-1);i+=2) {\
var nNewDectPos = getDectMsnPos(arInCallNo[i], true);\
if ( nNewDectPos != (-1)) {\
var nDectID = parseInt(jslGetValue("uiDectID"));\
if ( uiIsDectMsn( arInCallNo[i]) == true) {\
var nNewSettings = uiNewHandsetSetting(nNewDectPos,nDectID);\
if ( nNewSettings != (-1)) {\
jslSetValue("uiPostDectHandsets"+nNewDectPos, String.fromCharCode((48+nNewSettings)));\
jslEnable( "uiPostDectHandsets"+nNewDectPos);\
}\
} else {\
jslSetValue( "uiPostDectMsn"+nNewDectPos, arInCallNo[i]);\
jslSetValue( "uiPostDectHandsets"+nNewDectPos, String.fromCharCode((48+Math.pow(2, nDectID))));\
jslEnable("uiPostDectMsn"+nNewDectPos);\
jslEnable("uiPostDectHandsets"+nNewDectPos);\
}\
ar_Reset[nNewDectPos] = false;\
}\
}\
for ( var j=0;j<5;j++) {\
if ( ar_Reset[j] == true) {\
var nBitValue = Math.pow(2, parseInt(jslGetValue("uiDectID")));\
if ( IsHandsetConfigured( j, nBitValue)) {\
var oldHandset = jslGetValue( "uiPostDectHandsets"+j).charCodeAt(0) - nBitValue;\
jslSetValue( "uiPostDectHandsets"+j, String.fromCharCode(oldHandset));\
jslEnable("uiPostDectHandsets"+j);\
}\
}\
}\
}\
function uiIsDectMsn( msn) {\
for ( var i=0;i<5;i++) {\
if ( msn == jslGetValue("uiPostDectMsn"+i)) return true;\
}\
return false;\
}\
function getDectMsnPos( wert, orNew) {\
for ( var i=0;i<5;i++) {\
if ( wert == jslGetValue("uiPostDectMsn"+i)) return i;\
}\
if ( orNew == true) {\
for ( var j=0;j<5;j++) {\
if ( jslGetValue("uiPostDectMsn"+j) == "") return j;\
}\
}\
return (-1);\
}\
function IsHandsetConfigured( nPos, wert) {\
var oldHandset = jslGetValue( "uiPostDectHandsets"+nPos).charCodeAt(0) - 48;\
if ( (oldHandset & wert) == wert) return true;\
return false;\
}\
function uiNewHandsetSetting( nPos, dectID) {\
var oldHandset = jslGetValue( "uiPostDectHandsets"+nPos).charCodeAt(0) - 48;\
var newHandset = Math.pow(2, dectID);\
if ( (oldHandset & newHandset) != newHandset) {\
newHandset += oldHandset;\
} else {\
newHandset = (-1);\
}\
return newHandset;\
}' "$FN"
sed -i -e '/if ((jslGetValue("uiPostIsdnName"+j) == "") || (jslGetValue( "uiPostIsdnNumber"+j) == "")) {return true;}/a\
}\
for ( var k=1;k<6;k++) {\
if (jslGetValue("uiPostDectSubscribed"+k) == "0") {return true;}\
if (jslGetValue( "uiPostDectName"+k) == "") {return true;}' "$FN"
sed -i -e 's/extensionNo = ./extensionNo = 2/' "$FN"
FN="$SR1/${USRWWW}/fon_config/fon_config_1.js"
sed -i -e '/g_NameList.5. = new String(\"internes Faxger/a\
<? if neq $var:DeviceType AABB `\
<? if neq $var:DeviceType FFaxx `\
for ( var j = 0; j < 5; j++) {\
if (jslGetValue("uiPostHandset"+j+"Subscribe") == "0") {\
g_curDectPort = j;\
break;\
}\
}\
jslAddOption("uiViewPort", "20", g_txtDect, false);\
if (firstPort == "") {\
firstPort = "20";\
}\
if(firstNotation==-1)\
firstNotation = 4;\
g_NameList[4] = new String(g_txtDect + (g_curDectPort+1));\
` ?>\
` ?>' "$FN"
sed -i -e "s/FFaxx/'Fax'/" "$FN"
sed -i -e "s/AABB/'AB'/" "$FN"
sed -i -e 's/Zeichen sind:\\x0a `~/Zeichen sind: `~/' "$FN"
sed -i -e 's/<>\/?";/<>\/und?";/' "$FN"
sed -i -e '/var g_txt_Device_AB/a\
var g_txtDect = "Schnurlostelefon (DECT) ";' "$FN"
#-------------------------------------------------------------------------------- 
fi
