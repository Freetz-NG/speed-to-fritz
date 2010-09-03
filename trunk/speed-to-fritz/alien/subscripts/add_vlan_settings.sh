#!/bin/bash
# include modpatch function
. ${include_modpatch}
if [ "${RPL_AUTHFORM_WITH_81}" == "y" ]; then
 echo "-- replace authform ..."
 USRWWW="usr/www/${OEMLINK}/html/de"
 rm -f "$SRC/${USRWWW}/internet/authform.js"
 rm -f "$SRC/${USRWWW}/internet/authform.html"
 PatchfileName="add_authform"
 modpatch "$SRC/${USRWWW}" "$P_DIR/${PatchfileName}.patch"
 [ "$avm_Lang" = "de" ] &&  modpatch "$SRC/${USRWWW}" "$P_DIR/${PatchfileName}_de.patch"
fi
OEML="avm" && [ -d "${DST}"/usr/www/avme ] && OEML="avme"
OEML2="avm" && [ -d "${SRC_2}"/usr/www/avme ] && OEML2="avme"
FILELIST=" /html/de/internet/authform.frm /html/de/internet/authform.js"
if [ "${RPL_AUTHFORM_WITH_SR2}" == "y" ]; then  
 for file_n in $FILELIST ; do
     if [ -f "${SRC_2}/usr/www/${OEML}/$file_n" ]; then
      cp -fdrp "${SRC_2}/usr/www/${OEML}/$file_n" "${SRC}/usr/www/${OEMLINK}/$file_n" && echo "-- Copy from 2nd AVM firmware: $file_n"
      sed -i -e s'|{?de.first.first_ISP_..html:5?}|{?g_txt_TestInternetConn?}|' "${SRC}/usr/www/${OEMLINK}/$file_n"
     fi
 done
fi
if [ "${RPL_AUTHFORM_WITH_DST}" == "y" ]; then
 for file_n in $FILELIST ; do
     if [ -f "${DST}/usr/www/${OEML}/$file_n" ]; then
      cp -fdrp "${DST}/usr/www/${OEML}/$file_n" "${SRC}/usr/www/${OEMLINK}/$file_n" && echo "-- Copy from orignal basis firmware: $file_n"
      sed -i -e s'|{?de.first.first_ISP_..html:5?}|{?g_txt_TestInternetConn?}|' "${SRC}/usr/www/${OEMLINK}/$file_n"
     fi
 done
fi
echo "-- adding vlan settings ..."
#--------------------------------------------------------------------------------
# remove WDS autodedect courses problems 
[ -f "${SRC}/usr/www/${OEMLINK}/html/de/wlan/wds.js" ] && sed -i -e '/uiPostAutodetect/d'  "${SRC}/usr/www/${OEMLINK}/html/de/wlan/wds.js"
[ -f "${SRC}/usr/www/${OEMLINK}/html/de/wlan/wds.frm" ] && sed -i -e '/uiPostAutodetect/d'  "${SRC}/usr/www/${OEMLINK}/html/de/wlan/wds.frm"
# vlan settings
grep -q "uiPostVlanId" "${SRC}/usr/www/${OEMLINK}/html/de/first/first_ISP_3.frm" ||\
echo '<input type="hidden" name="sar:settings/vlan_id" value="<? query sar:settings/vlan_id ?>" id="uiPostVlanId" disabled>' >> "${SRC}/usr/www/${OEMLINK}/html/de/first/first_ISP_3.frm"
grep -q "uiPostVlanAktiv" "${SRC}/usr/www/${OEMLINK}/html/de/first/first_ISP_3.frm" ||\
echo '<input type="hidden" name="sar:settings/vlan_encap" value="<? query sar:settings/vlan_encap ?>" id="uiPostVlanAktiv" disabled>' >> "${SRC}/usr/www/${OEMLINK}/html/de/first/first_ISP_3.frm"
SRC_WWW_INERNET="${SRC}/usr/www/${OEMLINK}/html/de/internet"
[ -f "${SRC_WWW_INERNET}/dslsnrset.frm" ] && ! grep -q "uiPostDSLMode" "${SRC_WWW_INERNET}/dslsnrset.frm" && sed -i -e '/uiPostAnnex/a\
<Input type="hidden" name="sar:settings/DSLMode" value="<? query sar:settings/DSLMode ?>" id="uiPostDSLMode" disabled>' "${SRC_WWW_INERNET}/dslsnrset.frm"
# vlan via Kabelmodem settings more settings are in internet_expert.js, in some firmwares some are commented out
if [ "${ADD_VLAN_BRIDGE}" == "y" ]; then
 echo "-- Adding bridge vlan option settings ..."
 FILE="${SRC}/usr/www/${OEMLINK}/html/de/internet/internet_expert.js"
 if ! $(grep -q "InitVlan" "$FILE") ;then
  echo "    GUI Menu Internet --> Settings Page will be replaced."
  echo "     Some text may be unreadabel!"
  echo "     Disable VLAN Bridge option or use a differrent 2nd AVM firmware." && sleep 5
  rm -f "$FILE"
  USRWWW="usr/www/${OEMLINK}/html/de"
  PatchfileName="add_bridges_vlans"
  modpatch "$SRC/${USRWWW}" "$P_DIR/${PatchfileName}.patch"
 fi
 if [ -f "$FILE" ]; then
    sed -i -e 's|//Init|Init|g' \
-e 's|//jsl|jsl|g' \
-e 's|// jsl|jsl|g' \
-e 's|//var encapsType auch hier rein?|//encapsType auch hier rein?|g' \
-e 's|// var|var|g' \
-e 's|//var|var|g' \
-e 's|//uiDoVlan();|uiDoVlan();|g' \
-e 's|//g_|g_|g' \
-e 's|\*/||g' \
-e 's|/\*||g' \
-e 's|//SaveV|SaveV|g' \
-e 's|//if |if |g' "$FILE"
 fi
FILE="${SRC}/usr/www/${OEMLINK}/html/de/internet/internet_expert.html"
 if [ -f "$FILE" ]; then
 sed -i -e "/<!--div class=.backdialog. id=.uiVlan./,/<.div><.div><.div><.div><.div><.div-->/d" $FILE
 sed -i -e '/id="uiAnschlussTypeExt/i\
<div class="backdialog" id="uiVlan" style="display:none"><div class="ecklm"><div class="eckrm"><div class="ecklb"><div class="eckrb"><div class="foredialog">\
<p class="mb5"><input type="checkbox" id="uiViewVlanAktiv" onclick="uiDoVlan()">&nbsp;<label for="uiViewVlanAktiv">Externes VDSL2-Modem benutzen, VLANs aktivieren<\/label><\/p>\
<p class="ml25"><label for="uiViewVlanId">VLAN-ID<\/label>&nbsp;<input type="text" size="5" maxlength="4" class="Eingabefeld" id="uiViewVlanId"><\/p>\
<\/div><\/div><\/div><\/div><\/div><\/div>\
' "$FILE"
 fi
 [ -f "${SRC_WWW_INERNET}/internet_expert.frm" ] &&  ! grep -q "uiPostVlanAktiv" "${SRC_WWW_INERNET}/internet_expert.frm" && sed -i -e '/uiPostSarDns1/a\
<input type="hidden" name="sar:settings/vlan_encap" value="<? query sar:settings/vlan_encap ?>" id="uiPostVlanAktiv" disabled>\
<input type="hidden" name="sar:settings/vlan_id" value="<? query sar:settings/vlan_id ?>" id="uiPostVlanId" disabled>' "${SRC_WWW_INERNET}/internet_expert.frm"
 [ -f "${SRC_WWW_INERNET}/kabelmodem.js" ] && sed -i -e '/InitSpeed();/a\
 InitVlan();' "${SRC_WWW_INERNET}/kabelmodem.js"
fi
#-------------------------------
# enable some setting usual only set if OEM is avme
FILE="${SRC}/usr/www/${OEMLINK}/html/de/internet/internet_expert.html"
if [ -f "$FILE" ]; then
    sed -i -e 's|if eq $var:OEM avme|if eq avme avme|g'  "$FILE"
    grep -q 'if eq avme avme' "$FILE" && echo2 "  -- enable setting for OEM avm on: internet_expert.html"
fi
FILE="${SRC}/usr/www/${OEMLINK}/html/de/internet/authform.frm"
if [ -f "$FILE" ]; then
    sed -i -e 's|if eq $var:OEM avme|if eq avme avme|g'  "$FILE"
    grep -q 'if eq avme avme' "$FILE" && echo2 "  -- enable setting for OEM avm on: authform.frm"
fi
FILE="${SRC}/usr/www/${OEMLINK}/html/de/internet/authform.js"
if [ -f "$FILE" ]; then
    sed -i -e 's|if eq $var:OEM avme|if eq avme avme|g'  "$FILE"
    sed -i -e "s|if (oem != 'avme'|if ('avm' != 'avm'|g"  "$FILE"
    grep -q 'if eq avme avme' "$FILE" && echo2 "  -- enable setting for OEM avm on: authform.js"
fi
rpl_avme_avm()
{
	for file_n in $1; do
	if [ -f "$file_n" ]; then
	 grep -q '<? if eq $var:OEM avme `' "$file_n" && echo2 "  -- enabled all 'avme' options in file: ${file_n##*/}"
	 sed -i -e 's/<? if eq $var:OEM avme `/<? if eq 1 1 `/' "$file_n"
	fi
	done
}
if [ "${OEM}" = "avm" ]; then
  rpl_avme_avm "$(find "${SRC}/usr/www/${OEMLINK}" -name *.html)" 
  rpl_avme_avm "$(find "${SRC}/usr/www/${OEMLINK}" -name *.frm)" 
fi

exit 0

