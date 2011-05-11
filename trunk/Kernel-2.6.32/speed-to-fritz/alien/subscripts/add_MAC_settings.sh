#!/bin/bash 
# include modpatch function
. ${include_modpatch}
for OEMDIR in $2; do
 html="html"
 USRWWW="usr/www/${OEMDIR}/$html/de"
  EXPERTP="$1/${USRWWW}/internet/internet_expert.js"
  if [ -f "${EXPERTP}" ]; then 
    if  ! `grep -q 'uiPostMac' "${EXPERTP}"`; then
#-----------------------------------------------------------------
    sed -i -e '/jslSetEnabled("buttonSave", n==0/i \
jslDisplay("uiMac", n==12);' "${EXPERTP}"
    sed -i -e '/jslSetValue("uiPostEncaps","dslencap_ether");/i \
jslEnable("uiPostMac");' "${EXPERTP}"
    sed -i -e '/jslCopyValue("uiViewWanIpDns1","uiPostSarDns1");/,/}/ {s/InitTraffic();/var mac = jslGetValue("uiPostMac");\
if (mac.length==17) {\
for (i=0; i<6; i++) jslSetValue("uiViewMac"+i, mac.substr(i*3,2));\
}\
InitTraffic();/}' "${EXPERTP}"
    sed -i -e '/jslCopyValue("uiPostSarDns1", "uiViewWanIpDns1");/,/jslEnable("uiPostTraffic");/ {s/if (changed .. !WanRouterAlert()) return false;/ \
for (i=0; i<6; i++) {\
var part = jslGetValue("uiViewMac"+i);\
if (!part.match(\/^[\\dA-F]{2}$\/i)) {alert(g_mldMacPart); document.getElementById("uiViewMac"+i).focus(); return false;}\
}\
if (parseInt(jslGetValue("uiViewMac0"),16).toString(2).matchmatch\/)) {alert(g_mldMacMulti); document.getElementById("uiViewMac0").focus(); return false;}\
if (changed \&\& !WanRouterAlert()) return false;\
var mac = "";\
for (i=0; i<6; i++) {\
mac += jslGetValue("uiViewMac"+i)+((i<5) ? ":" : "");\
}\
jslSetValue("uiPostMac", mac);/}' "${EXPERTP}"
    sed -i -e 's|matchmatch|match(/1$|' "${EXPERTP}"
    if  `grep -q 'uiPostMac' "${EXPERTP}"`; then
     echo "-- added MAC settings to page:"
     echo2 "  /${USRWWW}/internet/internet_expert.js"
    fi

    sed -i -e 's/id="uiViewAnschlussDsl">/id="uiViewAnschlussDsl">\&nbsp;/' "$1/${USRWWW}/internet/internet_expert.html"
    sed -i -e 's/id="uiViewAnschlussWan">/id="uiViewAnschlussWan">\&nbsp;/' "$1/${USRWWW}/internet/internet_expert.html"
#-----------------------------------------------------------------
    fi
  fi
done
exit 0

#sed -i -e '/von /,/bis/ {s/wie normal/wie normal/}' "$1/${USRWWW}/internet/internet_expert.js"
