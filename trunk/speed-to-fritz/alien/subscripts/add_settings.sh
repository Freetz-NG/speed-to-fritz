#!/bin/bash
# include modpatch function
. ${include_modpatch}
echo "-- Adding multiannex pages ..."
#annex settings made via GUI
if ! `grep -q 'ar7cfg.dslglobalconfig.Annex' "${1}"/etc/init.d/rc.conf`; then
     sed -i -e '/export ANNEX=.cat .CONFIG_ENVIRONMENT_PATH.annex./d' "${1}"/etc/init.d/rc.conf
     sed -i -e '/"$annex_param"/a\
if [ "${CONFIG_DSL_MULTI_ANNEX}" = "y" ] ; then\
LOADANNEX=`echo ar7cfg.dslglobalconfig.Annex | ar7cfgctl -s 2>\/dev\/null | sed s\/\\\\"\/\/g` ; # annex aus userselection?\
if [ -z "${LOADANNEX}" ] ; then\
export ANNEX=`cat $CONFIG_ENVIRONMENT_PATH\/annex` ; # annex aus /proc nehmen, nicht von Config!\
else\
export ANNEX=${LOADANNEX} ; # annex aus userselection\
fi\
else\
export ANNEX=`cat $CONFIG_ENVIRONMENT_PATH\/annex` \
fi' "${1}"/etc/init.d/rc.conf
fi
if  ! `grep -q 'id="uiViewDslPppPPPoA1' "${1}"/usr/www/$OEMLINK/html/de/internet/internet_expert.html`; then
sed -i -e '/id="uiViewDslPppVCI"/a\
<\/tr>\
<tr>\
<td>Encapsulation<\/td>\
<td>\
<input type="radio" onclick="uiDoDslPppEncaps(0)" name="DslPppEncaps" id="uiViewDslPppPPPoE">&nbsp;<label for="uiViewDslPppPPPoE">PPPoE<\/label><br>\
<input type="radio" onclick="uiDoDslPppEncaps(1)" name="DslPppEncaps" id="uiViewDslPppPPPoA1">&nbsp;<label for="uiViewDslPppPPPoA1">PPPoA LLC<\/label><br>\
<input type="radio" onclick="uiDoDslPppEncaps(2)" name="DslPppEncaps" id="uiViewDslPppPPPoA2">&nbsp;<label for="uiViewDslPppPPPoA2">PPPoA<\/label>\
<\/td>' "${1}"/usr/www/$OEMLINK/html/de/internet/internet_expert.html
fi
if   `grep -q 'uiDoDslPppAtm(1);' "${1}"/usr/www/$OEMLINK/html/de/internet/internet_expert.js`; then
sed -i -e '/uiDoDslPppAtm(1);/i\
switch (encapsType) {\
case "dslencap_pppoe": uiDoDslPppEncaps(0); break;\
case "dslencap_pppoa_llc": uiDoDslPppEncaps(1); break;\
case "dslencap_pppoa": uiDoDslPppEncaps(2); break;\
}' "${1}"/usr/www/$OEMLINK/html/de/internet/internet_expert.js
fi
if  ! `grep -q 'function uiDoDslPppEncaps' "${1}"/usr/www/$OEMLINK/html/de/internet/internet_expert.js`; then
sed -i -e '/function uiDoDslIpEncaps(n) {/i\
function uiDoDslPppEncaps (n) {\
jslSetChecked("uiViewDslPppPPPoE", (n==0));\
jslSetChecked("uiViewDslPppPPPoA1", (n==1));\
jslSetChecked("uiViewDslPppPPPoA2", (n==2));\
}' "${1}"/usr/www/$OEMLINK/html/de/internet/internet_expert.js
sed -i -e '/function uiDoDslPppAtm (n) {/a\
jslSetEnabled("uiViewDslPppPPPoE", n==1);\
jslSetEnabled("uiViewDslPppPPPoA1", n==1);\
jslSetEnabled("uiViewDslPppPPPoA2", n==1);' "${1}"/usr/www/$OEMLINK/html/de/internet/internet_expert.js
fi

if ! `grep -q 'else if (jslGetChecked("uiViewDslPppPPPoE"))' "${1}"/usr/www/$OEMLINK/html/de/internet/internet_expert.js`; then
sed -i -e '/function SaveDslPpp/,/function/{s/jslSetValue("uiPostVPI", vpi);/if (jslGetChecked("uiViewDslPppPPPoA1")) jslSetValue("uiPostEncaps", "dslencap_pppoa_llc");\
else if (jslGetChecked("uiViewDslPppPPPoA2")) jslSetValue("uiPostEncaps", "dslencap_pppoa");\
else if (jslGetChecked("uiViewDslPppPPPoE")) jslSetValue("uiPostEncaps", "dslencap_pppoe");\
else {alert(g_NoEncapsModeDefined); return false;}\
jslSetValue("uiPostAutodetect", "0");\
jslSetValue("uiPostVPI", vpi);/}' "${1}"/usr/www/$OEMLINK/html/de/internet/internet_expert.js
fi

if  ! `grep -q 'SaveGsmType()' "${1}"/usr/www/$OEMLINK/html/de/internet/internet_expert.js`; then
sed -i -e '/<.script>/i\
function SaveGsmType() {\
jslSetValue("uiPostRouterBridge", jslGetChecked("uiViewRouterBridge") ? "1":"0");\
jslEnable("uiPostRouterBridge");\
jslSetEnabled("uiPostPppIdleTimeout", true);\
jslSetEnabled("uiPostPppMode", true);\
return OnGsmDoSave();\
}' "${1}"/usr/www/$OEMLINK/html/de/internet/internet_expert.js
fi

echo "-- Adding settings timezone pages ..."

 html="html"
 USRWWW="usr/www/${OEMLINK}/$html/de"
 if ! [ -f "$1"/${USRWWW}/first/basic_first_Annex.js ]; then
#-----------------------------------------------------------------
  for FILE in adsl.html atm.html bits.html overview.html; do
  if [ -f "$1/${USRWWW}/internet/$FILE" ]; then 
    sed -i -e "s|<? if neq \$var:Annex A|<? if eq 'A' 'A'|" "$1/${USRWWW}/internet/$FILE"
  echo2 "  /${USRWWW}/internet/$FILE"
  fi
 done
#-----------------------------------------------------------------
 fi
FILELIST="menu2_system.html \
sitemap.html \
authform.html \
vpn.html \
pppoe.html \
first_Sip_1.html \
first_ISP_0.html"
rpl_avme_avm()
{
	for file in $1; do
	if [ -f "$file" ]; then
	 grep -q '<? if eq $var:OEM avme `' "$file" && echo2 "  'avme' chanaged to 'avm' in File: ${file##*/}"
	 sed -i -e 's/<? if eq $var:OEM avme `/<? if eq 1 1 `/' "$file"
	fi 
	done
}
rpl_avme_avm "$(find "$1/usr/www/${OEMLINK}" -name *.html)" 
#rpl_avme_avm "$(find "$1/usr/www/${OEMLINK}" -name *.js)" 
	      
if ! `grep -q 'id="uiTempLang"' "${1}"/usr/www/$OEMLINK/html/de/first/basic_first.frm`; then
echo '<input type="hidden" name="var:lang" value="<? echo $var:lang ?>" id="uiTempLang">' >> "${1}"/usr/www/$OEMLINK/html/de/first/basic_first.frm
fi

#[ -f "${1}"/usr/www/$OEMLINK/html/de/first/basic_first_Annex.js ] || modpatch "$1" "$P_DIR/add_annex.patch"
FILELIST="/html/de/internet/vdsl_profile.js \
/html/de/internet/vdsl_profile.html \
/html/de/system/timeZone.js \
/html/de/system/timeZone.frm \
/html/de/system/timeZone.html \
/html/de/internet/dslsnrset.frm \
/html/de/internet/dslsnrset.html \
/html/de/internet/dslsnrset.js \
/html/de/first/basic_first_Annex.js \
/html/de/first/basic_first_Annex.frm \
/html/de/first/basic_first_Annex.html"

OEML="avm"
[ -d "${DST}"/usr/www/avme ] && OEML="avme"
OEML2="avm"
[ -d "${SRC_2}"/usr/www/avme ] && OEML2="avme"
for file in $FILELIST; do
    if [ -f "${DST}/usr/www/${OEML}/$file" ]; then
     cp -fdrp "${DST}/usr/www/${OEML}/$file" "${SRC}/usr/www/${OEMLINK}/$file" && echo2 "  copy: $file"
    fi 
done
for file in $FILELIST; do
    if [ -f "${SRC_2}/usr/www/${OEML2}/$file" ]; then
     cp -fdrp "${SRC_2}/usr/www/${OEML2}/$file" "${SRC}/usr/www/${OEMLINK}/$file" && echo2 "  copy: $file"
    fi 
done

if [ "${CONFIG_MULTI_LANGUAGE}" = "y" ]; then
 echo "-- Adding mulilingual pages from source 2 or 3 ..."
 #copy language datbase
 LanguageList="de en it sp fr" #de dont copy de as well
 for DIR in $LanguageList; do
    if [ -d "${DST}/etc/default.${DEST_PRODUKT}"/${OEML}/$DIR ]; then
     cp -fdrp "${DST}/etc/default.${DEST_PRODUKT}"/${OEML}/$DIR "${SRC}/etc/default.${CONFIG_PRODUKT}/${OEMLINK}/$DIR" && echo2 "  copy directory: $DIR"
    fi 
    if [ -d "${DST}/etc/default.${SORCE_2_PRODUKT}"/${OEML2}/$DIR ]; then
     cp -fdrp "${DST}/etc/default.${SORCE_2_PRODUKT}"/${OEML2}/$DIR "${SRC}/etc/default.${CONFIG_PRODUKT}/${OEMLINK}/$DIR" && echo2 "  copy directory: $DIR"
    fi 
 done
 LanguageList="en it sp fr" #de dont copy de as well
 for DIR in $LanguageList; do
    [ -f "${DST}"/etc/htmltext_$DIR.db ] && cp -fdrp "${DST}"/etc/htmltext_$DIR.db --target-directory="${SRC}"/etc && echo2 "  copy: database $DIR"
    [ -f "${SRC_2}"/etc/htmltext_$DIR.db ] && cp -fdrp "${SRC_2}"/etc/htmltext_$DIR.db --target-directory="${SRC}"/etc && echo2 "  copy: database $DIR"
 done
fi
#copy default country
cp -fr "${DST}"/etc/default.0* --target-directory=${SRC}/etc
cp -fr "${DST}"/etc/default.9* --target-directory=${SRC}/etc
rn_files()
{
	for file in $1; do
	IMGN="${file%/*}"
	#echo "$file" $IMGN/"$2"
	mv "$file" $IMGN/"$2"
	done
}
rn_files "$(find "${SRC}/etc" -name fx_conf.avme)" "fx_conf.default"
rn_files "$(find "${SRC}/etc" -name fx_lcr.avme)" "fx_lcr.default"

exit 0
