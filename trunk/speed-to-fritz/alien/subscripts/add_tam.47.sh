#!/bin/bash


UPDTAM="$2"
#Source 1
SR1="$1" 
 # include modpatch function
 . ${include_modpatch}

for DIR in ${OEMLIST}; do
 if [ "$DIR" = "avme" ] ; then
  html="$avm_Lang/html"
 else
  html="html"
 fi
 DSTI="${SR1}"/usr/www/${DIR}/${html}/${avm_Lang}
 DST=/usr/www/${DIR}/${html}/${avm_Lang}
 if [ -d ${DSTI} ] ; then
#start----------------------------------------------------------------------------------

echo2 "  -- copying TAM related help files:"
echo2 "      ${DST}/help/hilfe_fon_anrufbeantworter.html"
# chmod 755 "${DSTI}"/help/hilfe_fon_anrufbeantworter.html
# remove must be becaue of the following add trough modpatch add_tamhelp_en.47.patch
rm -f "${DSTI}"/help/hilfe_fon_anrufbeantworter.html
#cp -fp ./addon/$avm_Lang/help/hilfe_fon_anrufbeantworter.html "${DSTI}"/help/hilfe_fon_anrufbeantworter.html
[ "$avm_Lang" = "en" ] && modpatch "$DSTI" "$P_DIR/add_tamhelp_en.47.patch"
[ "$avm_Lang" = "de" ] && modpatch "$DSTI" "$P_DIR/add_tamhelp_de.47.patch"
#original line
#cp -fp ./addon/$avm_Lang/help/hilfe_fon_anrufbeantworter.html "${DSTI}"/help/hilfe_fon_anrufbeantworter.html
echo2 "  -- copying 'fonab.*' and 'tam.*' files:"
[ "$avm_Lang" = "en" ] && modpatch "$DSTI" "$P_DIR/add_tam_en.47.patch"
[ "$avm_Lang" = "de" ] && modpatch "$DSTI" "$P_DIR/add_tam_de.47.patch"
# cp fonab.* tam.*
#original lines
#for FILE in `ls ./addon/$avm_Lang/fon`; do
#	echo2 "      ${DST}/fon/$FILE"
#	cp -fp ./addon/$avm_Lang/fon/$FILE "${DSTI}"/fon/$FILE
#	chmod 755 "${DSTI}"/fon/$FILE
#done

echo2 "  -- patching files (adding features for TAM):"
echo2 "      ${DST}/help/home.html"
sed -i -e "/^.*\$var:Text59.*$/a \
\\\t\t\t\t\t<a href=\"javascript:jslGoTo('help','hilfe_fon_anrufbeantworter')\"><? echo \$var:Text70 ?><\/a><br>" "${DSTI}"/help/home.html

echo2 "      ${DST}/menus/menu2_fon.html"
sed -i -e "/^.*\$var:txt12.*$/a \
<? setvariable var:classname 'LSubitem' ?>\n\
<? if eq \$var:pagename tam \`<? setvariable var:classname 'LSubitemaktiv' ?>\` ?>\n\
\t<li class=\"<? echo \$var:classname ?>\"><img src=\"<? echo \$var:subpfeil ?>\"> <a href=\"javascript:jslGoTo('fon','tam')\"><? echo '\$var:txt13' ?><\/a><\/li>" "${DSTI}"/menus/menu2_fon.html

if [ "$UPDTAM" = "n" ]; then
echo2 "      ${DST}/fon/fonlist.html"
sed -i -e "/^[\t]*<\/table>$/i \
\\\t\t\t<tr>\n\t\t\t\t<td class=\"c1\">4<\/td>\n\
\t\t\t\t<td class=\"c2\">Anrufbeantworter <? if eq '<? query tam:settings/TAM0/Active ?>' '1' 'aktiv' 'nicht aktiv' ?><\/td>\n\
\t\t\t\t<td class=\"c3\"><script type=\"text\/javascript\">document.write(uiNummerDisplay(\"<? query tam:settings/MSN0 ?>\"));<\/script><\/td>\n\
\t\t\t\t<td class=\"c4\" style=\"text-align: right;\"><button type=\"button\" id=\"uiViewEdit4\" onclick=\"uiEditAb()\" title=\"<? echo \$var:Text7 ?>\" style=\"width: 30px\">\n\
\t\t\t\t\t<img src=\"\.\.\/html\/<? echo \$var:lang ?>\/images\/bearbeiten.gif\" align=\"bottom\" width=\"16\" height=\"16\" hspace=\"4\">\n\
\t\t\t\t<\/button><\/td>\n\t\t\t<\/tr>" "${DSTI}"/fon/fonlist.html
fi
#end----------------------------------------------------------------------------------
fi
done

exit 0
