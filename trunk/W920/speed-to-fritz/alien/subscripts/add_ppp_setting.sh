#!/bin/bash
# include modpatch function
. ${include_modpatch}
echo "-- Adding ppp setting to pages ..."
if  ! `grep -q 'id="uiViewDslPppPPPoA1' "${SRC}"/usr/www/$OEMLINK/html/de/internet/internet_expert.html`; then
sed -i -e '/id="uiViewDslPppVCI"/a\
<\/tr>\
<tr>\
<td>Encapsulation<\/td>\
<td>\
<input type="radio" onclick="uiDoDslPppEncaps(0)" name="DslPppEncaps" id="uiViewDslPppPPPoE">&nbsp;<label for="uiViewDslPppPPPoE">PPPoE<\/label><br>\
<input type="radio" onclick="uiDoDslPppEncaps(1)" name="DslPppEncaps" id="uiViewDslPppPPPoA1">&nbsp;<label for="uiViewDslPppPPPoA1">PPPoA LLC<\/label><br>\
<input type="radio" onclick="uiDoDslPppEncaps(2)" name="DslPppEncaps" id="uiViewDslPppPPPoA2">&nbsp;<label for="uiViewDslPppPPPoA2">PPPoA<\/label>\
<\/td>' "${SRC}"/usr/www/$OEMLINK/html/de/internet/internet_expert.html
fi
if   `grep -q 'uiDoDslPppAtm(1);' "${SRC}"/usr/www/$OEMLINK/html/de/internet/internet_expert.js`; then
sed -i -e '/uiDoDslPppAtm(1);/i\
switch (encapsType) {\
case "dslencap_pppoe": uiDoDslPppEncaps(0); break;\
case "dslencap_pppoa_llc": uiDoDslPppEncaps(1); break;\
case "dslencap_pppoa": uiDoDslPppEncaps(2); break;\
}' "${SRC}"/usr/www/$OEMLINK/html/de/internet/internet_expert.js
fi
if  ! `grep -q 'function uiDoDslPppEncaps' "${SRC}"/usr/www/$OEMLINK/html/de/internet/internet_expert.js`; then
sed -i -e '/function uiDoDslIpEncaps(n) {/i\
function uiDoDslPppEncaps (n) {\
jslSetChecked("uiViewDslPppPPPoE", (n==0));\
jslSetChecked("uiViewDslPppPPPoA1", (n==1));\
jslSetChecked("uiViewDslPppPPPoA2", (n==2));\
}' "${SRC}"/usr/www/$OEMLINK/html/de/internet/internet_expert.js
sed -i -e '/function uiDoDslPppAtm (n) {/a\
jslSetEnabled("uiViewDslPppPPPoE", n==1);\
jslSetEnabled("uiViewDslPppPPPoA1", n==1);\
jslSetEnabled("uiViewDslPppPPPoA2", n==1);' "${SRC}"/usr/www/$OEMLINK/html/de/internet/internet_expert.js
fi

if ! `grep -q 'else if (jslGetChecked("uiViewDslPppPPPoE"))' "${SRC}"/usr/www/$OEMLINK/html/de/internet/internet_expert.js`; then
sed -i -e '/function SaveDslPpp/,/function/{s/jslSetValue("uiPostVPI", vpi);/if (jslGetChecked("uiViewDslPppPPPoA1")) jslSetValue("uiPostEncaps", "dslencap_pppoa_llc");\
else if (jslGetChecked("uiViewDslPppPPPoA2")) jslSetValue("uiPostEncaps", "dslencap_pppoa");\
else if (jslGetChecked("uiViewDslPppPPPoE")) jslSetValue("uiPostEncaps", "dslencap_pppoe");\
else {alert(g_NoEncapsModeDefined); return false;}\
jslSetValue("uiPostAutodetect", "0");\
jslSetValue("uiPostVPI", vpi);/}' "${SRC}"/usr/www/$OEMLINK/html/de/internet/internet_expert.js
fi

if  ! `grep -q 'SaveGsmType()' "${SRC}"/usr/www/$OEMLINK/html/de/internet/internet_expert.js`; then
sed -i -e '/<.script>/i\
function SaveGsmType() {\
jslSetValue("uiPostRouterBridge", jslGetChecked("uiViewRouterBridge") ? "1":"0");\
jslEnable("uiPostRouterBridge");\
jslSetEnabled("uiPostPppIdleTimeout", true);\
jslSetEnabled("uiPostPppMode", true);\
return OnGsmDoSave();\
}' "${SRC}"/usr/www/$OEMLINK/html/de/internet/internet_expert.js
fi
