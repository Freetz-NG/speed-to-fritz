#!/bin/bash 
 # include modpatch function
 . ${include_modpatch}
echo "-- Adding onlinecounter pages ..."

for OEMDIR in $2; do
 if [ "$OEMDIR" = "avme" ] ; then
  html="$avm_Lang/html"
 else
  html="html"
 fi
 USRWWW="usr/www/${OEMDIR}/$html/${avm_Lang}"

 rm -f "$1"/${USRWWW}/internet/budget*
 rm -f "$1"/${USRWWW}/internet/inetstat*
#-----------------------------------------------------------------
  if [ -f "$1"/usr/www/${OEMDIR}/$html/index.html ]; then
   Unicode_ut8="n"
  `cat "$1"/usr/www/${OEMDIR}/$html/index.html | grep -q 'charset=utf-8' ` && Unicode_ut8="y" 
  #echo "ut8: $Unicode_ut8"
    PatchfileName="add_onlinecounter_de"
   [ -f "$P_DIR/${PatchfileName}_ut8.patch" ] && iconv --from-code=UTF-8 --to-code=ISO-8859-1 "$P_DIR/${PatchfileName}_ut8.patch" > "$P_DIR/${PatchfileName}.patch" 
   [ -f "$P_DIR/${PatchfileName}_ut8.patch" ] || iconv --from-code=ISO-8859-1 --to-code=UTF-8 "$P_DIR/${PatchfileName}.patch" > "$P_DIR/${PatchfileName}_ut8.patch" 
   [ "$Unicode_ut8" = "n" ] && [ "$OEMDIR" = "avm" ] && [ "$avm_Lang" = "de" ] && modpatch "$1" "$P_DIR/${PatchfileName}.patch"
   [ "$Unicode_ut8" = "y" ] && [ "$OEMDIR" = "avm" ] && [ "$avm_Lang" = "de" ] && modpatch "$1" "$P_DIR/${PatchfileName}_ut8.patch"
   #   [ "$OEMDIR" = "avme" ] && [ "$avm_Lang" = "en" ] && modpatch "$1" "$P_DIR/add_dsl_expert_en.patch"
sed -i -e '/{?de.home.home.js:305?}/a\
var volBudgetReached = "<? query box:status/hint_volume_budget_reached ?>";\
if (volBudgetReached == "1")\
strWarn = "das in Ihrem Tarif enthaltene Datenvolumen f&uuml;r diesen Monat ist aufgebraucht.";' "$1"/${USRWWW}/home/home.js 
sed -i -e "/var retstr = timestrings/a\
var g_Mega = 1000000;\n\
var g_Shift32 = 4294967296;\n\
function mb2byte(mb){ return Math.floor(g_Mega*mb); }\n\
function byte2mb(b){ return Math.round(b\/g_Mega); }\n\
function byte2low(b){ return b%g_Shift32; }\n\
function byte2high(b){ return Math.floor(b\/g_Shift32); }\n\
function highlow2byte(h,l){ return h*g_Shift32+l; }\n\
if (maxtime==0)\n\
{\n\
var maxlow = <? query connection0:settings/Budget\/VolumeLow ?>;\n\
var maxhigh = <? query connection0:settings/Budget\/VolumeHigh ?>;\n\
var reclow = <? query inetstat:status\/ThisMonth\/BytesReceivedLow ?>;\n\
var rechigh = <? query inetstat:status\/ThisMonth\/BytesReceivedHigh ?>;\n\
var sentlow = <? query inetstat:status\/ThisMonth\/BytesSentLow ?>;\n\
var senthigh = <? query inetstat:status\/ThisMonth\/BytesSentHigh ?>;\n\
var maxvol = highlow2byte(maxhigh,maxlow);\n\
var curvol = highlow2byte(rechigh,reclow) + highlow2byte(senthigh,sentlow);\n\
var maxmb = byte2mb(maxvol);\n\
var curmb = byte2mb(curvol);\n\
retstr = curmb+g_txt_von+maxmb+ \"MB\"+\".\";\n\
}" "$1"/${USRWWW}/home/home.js 


  fi
#-----------------------------------------------------------------
done
exit 0
 