#!/bin/bash
UPDTAM="$2"
#Source 1
SR1="$1" 
 . ${include_modpatch}
echo "-- Adding DECT handsets setup pages ..."

for DIR in ${OEMLIST}; do
 if [ "$DIR" = "avme" ] ; then
  html="$avm_Lang/html"
 else
  html="html"
 fi
 DSTI="${SR1}"/usr/www/${DIR}/${html}/${avm_Lang}
 DST="/usr/www/${DIR}/${html}/${avm_Lang}"

 if [ -d ${DSTI} ] ; then
#start----------------------------------------------------------------------------------
echo2 "   -- Copying all files from: ./addon/$avm_Lang/fon_dect:"
#for FILE in `ls ./addon/$avm_Lang/fon_dect`; do
# echo2 "      ${DST}/fon/$FILE"
#	cp -fp ./addon/$avm_Lang/fon_dect/$FILE "${DSTI}"/fon/$FILE
#done
[ "$avm_Lang" = "en" ] && modpatch "$SR1" "$P_DIR/add_dect_en.patch"
[ "$avm_Lang" = "de" ] && modpatch "$SR1" "$P_DIR/add_dect_de.patch"
#the folowing patch must be after the above line becase it patches a file added by add_dect_**.patch
sed -i -e "/var bits = (String.fromCharCode(bits + 48));/d" "$SR1"/${DST}/fon/fon1dect.js
[ $TCOM_V_MINOR -gt 38 ] && sed -i -e 's/jslSetValue("uiPostHandsets", bits);/var bits = (String.fromCharCode(bits + 48));\
jslSetValue("uiPostHandsets", bits);/' "$SR1"/${DST}/fon/fon1dect.js
#add tabs for nebenstelle on fondeviceses page    
DIRI2="/usr/www/${html}/${avm_Lang}/home" 
if ! [ -f "${SR1}"/$DIRI2/fondevices.html ]; then
   DIRI2="/usr/www/${html}/${avm_Lang}/fon"
fi
if  [ -f "${SR1}"/$DIRI2/fondevices.html ]; then
    sed -i -e '/uiDoMsn()/a \
<li><a href="javascript:uiDoEditDevice( 0, 0, 0)">Nebenstelle 1<\/a><\/li> \
<li><a href="javascript:uiDoEditDevice( 0, 1, 0)">Nebenstelle 2<\/a><\/li> \
<li><a href="javascript:uiDoEditDevice( 1, 0, 11)">S0 Buss Int.<\/a><\/li>' "${SR1}"/$DIRI2/fondevices.html
fi
echo2 "   -- Copying DECT related help files:"
[ "$avm_Lang" = "en" ] && modpatch "$SR1" "$P_DIR/add_decthelp_en.patch"
[ "$avm_Lang" = "de" ] && modpatch "$SR1" "$P_DIR/add_decthelp_de.patch"
#original helpfile copy
#echo2 "      ${DST}/help/hilfe_fon_setupdect.html"
#cp -fp ./addon/$avm_Lang/help/hilfe_fon_setupdect.html "${DSTI}"/help/hilfe_fon_setupdect.html
#echo2 "      ${DST}/help/hilfe_fon_editdect.html"
#cp -fp ./addon/$avm_Lang/help/hilfe_fon_editdect.html "${DSTI}"/help/hilfe_fon_editdect.html
#echo2 "      ${DST}/help/hilfe_fon_fon1dect.html"
#cp -fp ./addon/$avm_Lang/help/hilfe_fon_editdect.html "${DSTI}"/help/hilfe_fon_fon1dect.html
#echo2 "      ${DST}/help/hilfe_fon_dect.html"
#cp -fp ./addon/$avm_Lang/help/hilfe_fon_dect.html "${DSTI}"/help/hilfe_fon_dect.html
#echo2 "      ${DST}/help/hilfe_fon_dect_festnetzrufnummer.html"
#cp -fp ./addon/$avm_Lang/help/hilfe_fon_dect_festnetzrufnummer.html "${DSTI}"/help/hilfe_fon_dect_festnetzrufnummer.html
#echo2 "      ${DST}/help/hilfe_fon_dect_fon1isdn.html"
#cp -fp ./addon/$avm_Lang/help/hilfe_fon_dect_fon1isdn.html "${DSTI}"/help/hilfe_fon_dect_fon1isdn.html
#echo2 "      ${DST}/help/hilfe_fon_listdect.html"
#cp -fp ./addon/$avm_Lang/help/hilfe_fon_listdect.html "${DSTI}"/help/hilfe_fon_listdect.html

#change  Menue entry for Telefoniegeraete to Festnetz in: ${DST}/menus/menu2_fon.inc
echo2 "   -- Patching files"
	echo2 "      ${DST}/menus/menu2_fon.inc"
if ! `cat "${DSTI}"/menus/menu2_fon.inc | grep -q 'var:txt15'` ; then
 if ! `cat "${DSTI}"/menus/menu2_fon.inc | grep -q 'dectmsn'` ; then
  echo2 "      /usr/www/all/html/de/menus/menu2_fon.html"
  sed -i -e "/^.* dectmsn .*$/a \
<? if eq \$var:pagename dect0 \`<? setvariable var:classname 'LSubitemaktiv' ?>\` ?>\n\
<? if eq \$var:pagename foneditdect \`<? setvariable var:classname 'LSubitemaktiv' ?>\` ?>\n\
<? if eq \$var:pagename fonsetupdect \`<? setvariable var:classname 'LSubitemaktiv' ?>\` ?>\n\
<? if eq \$var:pagename fonlistdect \`<? setvariable var:classname 'LSubitemaktiv' ?>\` ?>\n\
<? if eq \$var:pagename fon1isdn \`<? setvariable var:classname 'LSubitemaktiv' ?>\` ?>" "${DSTI}"/menus/menu2_fon.html
 else
	echo2 "      txt15 oder dect Telefoniegeraete Menueintrag nicht vorhanden!"
 fi
fi
	sed -i -e "s/var:txt15.*$/var:txt15 \"Festnetz\" ?>/g" "${DSTI}"/menus/menu2_fon.inc

#einen Menuepunkt DECT-Endgeraete aufruf anpassen 
echo2 "-- Add Menue Entry DECT:"


echo2 "      ${DST}/menus/menu2_fon.html"
if ! `cat "${DSTI}"/menus/menu2_fon.html | grep -q 'var:txt15'` ; then
sed -i -e "/^.*\$var:txt08.*$/a \
<? setvariable var:classname 'LSubitem' ?>\n\
<? if eq \$var:pagename dect0 \`<? setvariable var:classname 'LSubitemaktiv' ?>\` ?>\n\
<? if eq \$var:pagename foneditdect \`<? setvariable var:classname 'LSubitemaktiv' ?>\` ?>\n\
<? if eq \$var:pagename fonsetupdect \`<? setvariable var:classname 'LSubitemaktiv' ?>\` ?>\n\
<? if eq \$var:pagename fonlistdect \`<? setvariable var:classname 'LSubitemaktiv' ?>\` ?>\n\
<? if eq \$var:pagename fon1isdn \`<? setvariable var:classname 'LSubitemaktiv' ?>\` ?>\n\
\t<li class=\"<? echo \$var:classname ?>\"><img src=\"<? echo \$var:subpfeil ?>\"> <a href=\"javascript:jslGoTo('fon','dect0')\"><? echo '\$var:txt14' ?><\/a><\/li>" "${DSTI}"/menus/menu2_fon.html

else

sed -i -e "/^.*\$var:txt15.*$/a \
<? setvariable var:classname 'LSubitem' ?>\n\
<? if eq \$var:pagename dect0 \`<? setvariable var:classname 'LSubitemaktiv' ?>\` ?>\n\
<? if eq \$var:pagename foneditdect \`<? setvariable var:classname 'LSubitemaktiv' ?>\` ?>\n\
<? if eq \$var:pagename fonsetupdect \`<? setvariable var:classname 'LSubitemaktiv' ?>\` ?>\n\
<? if eq \$var:pagename fonlistdect \`<? setvariable var:classname 'LSubitemaktiv' ?>\` ?>\n\
<? if eq \$var:pagename fon1isdn \`<? setvariable var:classname 'LSubitemaktiv' ?>\` ?>\n\
\t<li class=\"<? echo \$var:classname ?>\"><img src=\"<? echo \$var:subpfeil ?>\"> <a href=\"javascript:jslGoTo('fon','dect0')\"><? echo '\$var:txt14' ?><\/a><\/li>" "${DSTI}"/menus/menu2_fon.html

fi

echo2 "      ${DST}/help/home.html"
if ! `cat "${DSTI}"/help/home.html | grep -q 'hilfe_fon_voiperweitert'` ; then
	echo2 "!!!!!!!!!!!!!!!!!!!String 'hilfe_fon_voiperweitert' not found!!!!!!!!!!!!!!!!!!!"
fi

sed -i -e "/hilfe_fon_voiperweitert/a \
\\\t\t\t\t\t<a href=\"javascript:jslGoTo('help','hilfe_fon_dect')\"><? echo \$var:Text69 ?><\/a><br>\n\
\t\t\t\t\t<a href=\"javascript:jslGoTo('help','hilfe_fon_dect_fon1isdn')\"><? echo \$var:Text48 ?><\/a><br>\n\
\t\t\t\t\t<a href=\"javascript:jslGoTo('help','hilfe_fon_dect_festnetzrufnummer')\"><? echo \$var:Text21 ?><\/a><br>" "${DSTI}"/help/home.html


#end----------------------------------------------------------------------------------
fi
done
