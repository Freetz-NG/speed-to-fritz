#!/bin/bash 
 # include modpatch function
 . ${include_modpatch}
echo "-- Adding DSL expert pages ..."

for OEMDIR in $2; do
 html="html"
 USRWWW="usr/www/${OEMDIR}/$html/de"
 if ! [ -f "$1"/${USRWWW}/internet/labor_dsl.html ]; then
#-----------------------------------------------------------------
  if [ -f "$1"/usr/www/${OEMDIR}/$html/index.html ]; then
   Unicode_ut8="n"
  `cat "$1"/usr/www/${OEMDIR}/$html/index.html | grep -q 'charset=utf-8' ` && Unicode_ut8="y" 
  #echo "ut8: $Unicode_ut8"
    PatchfileName="add_dsl_expert_de"
   [ -f "$P_DIR/${PatchfileName}_ut8.patch" ] && iconv --from-code=UTF-8 --to-code=ISO-8859-1 "$P_DIR/${PatchfileName}_ut8.patch" > "$P_DIR/${PatchfileName}.patch" 
   [ -f "$P_DIR/${PatchfileName}_ut8.patch" ] || iconv --from-code=ISO-8859-1 --to-code=UTF-8 "$P_DIR/${PatchfileName}.patch" > "$P_DIR/${PatchfileName}_ut8.patch" 
   [ "$Unicode_ut8" = "n" ] && [ "$avm_Lang" = "de" ] && modpatch "$1" "$P_DIR/${PatchfileName}.patch"
   [ "$Unicode_ut8" = "y" ] && [ "$avm_Lang" = "de" ] && modpatch "$1" "$P_DIR/${PatchfileName}_ut8.patch"
  fi
  for FILE in adsl.html atm.html bits.html overview.html; do
  if [ -f "$1/${USRWWW}/internet/$FILE" ]; then 
    sed -i -e "
    s|query box:settings.expertmode.activated ?>. .1.|query box:settings/expertmode/activated ?>' '0'|
    " "$1/${USRWWW}/internet/$FILE"

    sed -i -e "
/query box:settings.expertmode.activated ?>. .0./i \
<? if eq '<? query box:settings\/expertmode\/activated ?>' '1' \`\n\
<li><a href=\"javascript:uiDoLaborDSLPage()\">Einstellungen<\/a><\/li>\n\
\` ?>\
" "$1/${USRWWW}/internet/$FILE"
  echo2 "  /${USRWWW}/internet/$FILE"
  fi
 done
#-----------------------------------------------------------------
 fi
done
exit 0
 