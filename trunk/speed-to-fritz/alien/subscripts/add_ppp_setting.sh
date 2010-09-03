#!/bin/bash
# include modpatch function
. ${include_modpatch}
echo "-- adding ppp setting to pages ..."
SRCWWW="${SRC}/usr/www/$OEMLINK/html/de/internet"
if  ! `grep -q 'id="uiViewDslPppAtmAuto' ${SRCWWW}/internet_expert.html`; then
sed -i -e 'N;/id="uiDslPpp"/a\
<!--label-->' ${SRCWWW}/internet_expert.html
sed -i -e 'N;/<!--label-->/a\
<p class="mb5"><input type="radio" name="DslPppAtm" onclick="uiDoDslPppAtm(0)" id="uiViewDslPppAtmAuto">&nbsp;<label for="uiViewDslPppAtmAuto">ATM Auto<\/label><\/p>\
<p class="mb5"><input type="radio" name="DslPppAtm" onclick="uiDoDslPppAtm(1)" id="uiViewDslPppAtmManu">&nbsp;<label for="uiViewDslPppAtmManu">ATM Einstellungen<\/label><\/p>\
' ${SRCWWW}/internet_expert.html
sed -i -e 'N;/id="uiDslModemATMSettings"/a\
<p class="mb5"><input type="radio" name="DslModemAtm" onclick="uiDoDslModemAtm(0)" id="uiViewDslModemAtmAuto">&nbsp;<label for="uiViewDslModemAtmAuto">ATM Auto<\/label><\/p>\
<p class="mb5"><input type="radio" name="DslModemAtm" onclick="uiDoDslModemAtm(1)" id="uiViewDslModemAtmManu">&nbsp;<label for="uiViewDslModemAtmManu">ATM Einstellungen<\/label><\/p>\
' ${SRCWWW}/internet_expert.html
sed -i -e '/<!--label-->/d' ${SRCWWW}/internet_expert.html
fi
if  ! `grep -q 'id="uiViewDslPppPPPoA1' ${SRCWWW}/internet_expert.html`; then
sed -i -e '/id="uiViewDslPppVCI"/a\
<\/tr>\
<tr>\
<td>Encapsulation<\/td>\
<td>\
<input type="radio" onclick="uiDoDslPppEncaps(0)" name="DslPppEncaps" id="uiViewDslPppPPPoE">&nbsp;<label for="uiViewDslPppPPPoE">PPPoE<\/label><br>\
<input type="radio" onclick="uiDoDslPppEncaps(1)" name="DslPppEncaps" id="uiViewDslPppPPPoA1">&nbsp;<label for="uiViewDslPppPPPoA1">PPPoA LLC<\/label><br>\
<input type="radio" onclick="uiDoDslPppEncaps(2)" name="DslPppEncaps" id="uiViewDslPppPPPoA2">&nbsp;<label for="uiViewDslPppPPPoA2">PPPoA<\/label>\
<\/td>' ${SRCWWW}/internet_expert.html
fi
sed -i -e 's|uiDoDslModemAtm(jslGetValue("uiPostAutodetect");|uiDoDslModemAtm(jslGetValue("uiPostAutodetect") == "1" ? 0 : 1);|' ${SRCWWW}/internet_expert.js
sed -i -e 's|uiDoDslModemAtm(1)|uiDoDslModemAtm(jslGetValue("uiPostAutodetect")|' ${SRCWWW}/internet_expert.js

sed -i -e 's|uiDoDslPppAtm(1);|uiDoDslPppAtm(jslGetValue("uiPostAutodetect") == "1" ? 0 : 1);|' ${SRCWWW}/internet_expert.js
if !  `grep -q 'switch (encapsType)' ${SRCWWW}/internet_expert.js`; then
sed -i -e '/uiDoDslPppAtm(1);/i\
switch (encapsType) {\
case "dslencap_pppoe": uiDoDslPppEncaps(0); break;\
case "dslencap_pppoa_llc": uiDoDslPppEncaps(1); break;\
case "dslencap_pppoa": uiDoDslPppEncaps(2); break;\
}' ${SRCWWW}/internet_expert.js
fi
if  ! `grep -q 'jslSetChecked("uiViewDslPppAtmAuto", (n==0));' ${SRCWWW}/internet_expert.js`; then
sed -i -e '/function uiDoDslModemAtm (n) {/a\
jslSetChecked("uiViewDslModemAtmAuto", (n==0));\
jslSetChecked("uiViewDslModemAtmManu", (n==1));\
' ${SRCWWW}/internet_expert.js
sed -i -e '/function uiDoDslPppAtm (n) {/a\
jslSetChecked("uiViewDslPppAtmAuto", (n==0));\
jslSetChecked("uiViewDslPppAtmManu", (n==1));\
jslSetEnabled("uiViewDslPppPPPoE", n==1);\
jslSetEnabled("uiViewDslPppPPPoA1", n==1);\
jslSetEnabled("uiViewDslPppPPPoA2", n==1);\
' ${SRCWWW}/internet_expert.js
sed -i -e '/jslSetValue("uiPostFullBridge", jslGetChecked("uiViewFullBridge") ? "0":"1");/i\
jslSetValue("uiPostAutodetect", "0");\
}' ${SRCWWW}/internet_expert.js
#------
sed -i -e '/function SaveDslModem() {/{n;n;d}' ${SRCWWW}/internet_expert.js
sed -i -e 'N;/function SaveDslModem() {/a\
if (jslGetChecked("uiViewDslModemAtmAuto")) {\
jslSetValue("uiPostAutodetect", "1");\
} else {' ${SRCWWW}/internet_expert.js
sed -i -e '/jslCopyValue("uiViewDslModemVCI", "uiPostVCI");/{n;d}' ${SRCWWW}/internet_expert.js
sed -i -e '/jslCopyValue("uiViewDslModemVCI", "uiPostVCI");/a\
uiDoDslModemAtm(jslGetValue("uiPostAutodetect") == "1" ? 0 : 1);' ${SRCWWW}/internet_expert.js
fi
if  ! `grep -q 'function uiDoDslPppEncaps (n) {' ${SRCWWW}/internet_expert.js`; then
sed -i -e '/function uiDoDslModemAtm (n) {/i\
function uiDoDslPppEncaps (n) {\
jslSetChecked("uiViewDslPppPPPoE", (n==0));\
jslSetChecked("uiViewDslPppPPPoA1", (n==1));\
jslSetChecked("uiViewDslPppPPPoA2", (n==2));\
}' ${SRCWWW}/internet_expert.js
fi
if  ! `grep -q 'function uiDoDslIpEncaps(n) {' ${SRCWWW}/internet_expert.js`; then
sed -i -e '/function uiDoDslIpEncaps(n) {/i\
function uiDoDslPppEncaps (n) {\
jslSetChecked("uiViewDslPppPPPoE", (n==0));\
jslSetChecked("uiViewDslPppPPPoA1", (n==1));\
jslSetChecked("uiViewDslPppPPPoA2", (n==2));\
}' ${SRCWWW}/internet_expert.js
sed -i -e '/function uiDoDslPppAtm (n) {/a\
jslSetEnabled("uiViewDslPppPPPoE", n==1);\
jslSetEnabled("uiViewDslPppPPPoA1", n==1);\
jslSetEnabled("uiViewDslPppPPPoA2", n==1);' ${SRCWWW}/internet_expert.js
fi

if ! `grep -q 'else if (jslGetChecked("uiViewDslPppPPPoE"))' ${SRCWWW}/internet_expert.js`; then
sed -i -e '/function SaveDslPpp/,/function/{s/jslSetValue("uiPostVPI", vpi);/if (jslGetChecked("uiViewDslPppPPPoA1")) jslSetValue("uiPostEncaps", "dslencap_pppoa_llc");\
else if (jslGetChecked("uiViewDslPppPPPoA2")) jslSetValue("uiPostEncaps", "dslencap_pppoa");\
else if (jslGetChecked("uiViewDslPppPPPoE")) jslSetValue("uiPostEncaps", "dslencap_pppoe");\
else {alert(g_NoEncapsModeDefined); return false;}\
jslSetValue("uiPostAutodetect", "0");\
jslSetValue("uiPostVPI", vpi);/}' ${SRCWWW}/internet_expert.js
fi

if  ! `grep -q 'SaveGsmType()' ${SRCWWW}/internet_expert.js`; then
sed -i -e '/<.script>/i\
function SaveGsmType() {\
jslSetValue("uiPostRouterBridge", jslGetChecked("uiViewRouterBridge") ? "1":"0");\
jslEnable("uiPostRouterBridge");\
jslSetEnabled("uiPostPppIdleTimeout", true);\
jslSetEnabled("uiPostPppMode", true);\
return OnGsmDoSave();\
}' ${SRCWWW}/internet_expert.js
fi
exit 0
# macht probleme 
if  ! `grep -q 'id="if (jslGetChecked(.uiViewDslPppAtmAuto.)) {' ${SRCWWW}/internet_expert.js`; then
sed -i -e '/if (provider != "congstar" && provider != "O2") {/a\
if (jslGetChecked("uiViewDslPppAtmAuto")) {\
jslSetValue("uiPostAutodetect", "1");\
jslSetValue("uiPostEncaps", "dslencap_pppoe");\
} else {' ${SRCWWW}/internet_expert.js
grep -q 'if (jslGetChecked("uiViewDslPppAtmAuto")) {' ${SRCWWW}/internet_expert.js && \
sed -i -e '/jslSetValue("uiPostTraffic", jslGetChecked("uiViewTraffic") ? "1":"0");/i\
}' ${SRCWWW}/internet_expert.js
fi

