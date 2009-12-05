#!/bin/bash
# include modpatch function
. ${include_modpatch}
 rpl_avme_avm()
 {
	for file_n in $1; do
	if [ -f "$file_n" ]; then
	 grep -q '<? if eq $var:OEM avme `' "$file_n" && echo2 "  'avme' chanaged to 'avm' in file: ${file_n##*/}"
	 sed -i -e 's/<? if eq $var:OEM avme `/<? if eq 1 1 `/' "$file_n"
	fi
	done
 }
 rn_files()
 {
	for file_n in $1; do
	IMGN="${file_n%/*}"
	#echo "$file" $IMGN/"$2"
	mv "$file_n" $IMGN/"$2"
	done
 }
OEML="avm" && [ -d "${DST}"/usr/www/avme ] && OEML="avme"
OEML2="avm" && [ -d "${SRC_2}"/usr/www/avme ] && OEML2="avme"
 USRWWW="usr/www/${OEMLINK}/html/de"
#--> multicountry
if [ "${FORCE_MULTI_COUNTRY}" = "y" ]; then
  for file_n in /html/de/first/basic_first.js /html/de/first/basic_first.frm; do
    if [ -f "${SRC_2}/usr/www/${OEML2}/$file_n" ] && ! [ -f "${SRC}/usr/www/${OEMLINK}/$file_n" ]; then
     cp -fdrp "${SRC_2}/usr/www/${OEML2}/$file_n" "${SRC}/usr/www/${OEMLINK}/$file_n" && echo2 "  Copy from 2nd AVM firmware: $file_n"
    fi
  done
 for file_n in basic_first_Country.js basic_first_Country.frm basic_first_Country.html; do
   file_n="/html/de/first/${file_n}"
   [ -f "${SRC_2}/usr/www/${OEML2}/$file_n" ] && cp -fdrp "${SRC_2}/usr/www/${OEML2}/$file_n" "${SRC}/usr/www/${OEMLINK}/$file_n" && echo2 "  Copy from 2nd AVM firmware: $file_n"
 done
 sed -i -e 's/CONFIG_MULTI_COUNTRY="n"/CONFIG_MULTI_COUNTRY="y"/' "${SRC}"/etc/init.d/rc.conf
 echo "-- Adding mulicountry pages from source t-home or 2nd AVM firmware ..."
 file_nLIST="menu2_system.html sitemap.html authform.html vpn.html pppoe.html first_Sip_1.html first_ISP_0.html first_ISP_3.frm"
 if [ "${OEM}" = "avm" ]; then
  rpl_avme_avm "$(find "${SRC}/usr/www/${OEMLINK}" -name *.html)" 
  rpl_avme_avm "$(find "${SRC}/usr/www/${OEMLINK}" -name *.frm)" 
 fi
 #copy default country
 [ -d "${DST}/etc/default.049" ] &&  cp -fdrp "${DST}"/etc/default.0* --target-directory=${SRC}/etc
 [ -d "${DST}/etc/default.99" ] && cp -fdrp "${DST}"/etc/default.9* --target-directory=${SRC}/etc
 if [ -n "$FBIMG_2" ]; then
  [ -d "${DST}/etc/default.049" ] &&    cp -fdrp "${SRC_2}"/etc/default.0* --target-directory=${SRC}/etc
  [ -d "${SRC_2}/etc/default.99" ] && cp -fdrp "${SRC_2}"/etc/default.9* --target-directory=${SRC}/etc
 fi
 if [ "${OEM}" = "avm" ]; then
  rn_files "$(find "${SRC}/etc" -name fx_conf.avme)" "fx_conf.${OEMLINK}"
  rn_files "$(find "${SRC}/etc" -name fx_lcr.avme)" "fx_lcr.${OEMLINK}"
 fi
 # on 7240 Firmware some pages are missing
  `cat "${SRC}/usr/www/${OEMLINK}/html/de/home/sitemap.html" | grep -q 'isMultiCountry' ` ||\
   modpatch "${SRC}/${USRWWW}" "$P_DIR/add_countrys_de.patch"
  `cat "${SRC}/usr/www/${OEMLINK}/html/de/home/sitemap.html" | grep -q 'isMultiCountry' ` ||\
  sed -i -e "/.fon., .routing./a\
<p class=\"ml10\"><a href=\"javascript:jslGoTo('fon', 'laender');\">Ländereinstellung<\/a><\/p>" "${SRC}/usr/www/${OEMLINK}/html/de/home/sitemap.html"
  `cat "${SRC}/usr/www/${OEMLINK}/html/de/menus/menu2_fon.html" | grep -q 'isMultiCountry' ` ||\
  sed -i -e "/pagename 'laender'/a\
<li class=\"<? echo \$var:classname ?>\"><img class=\"LMenuPfeil\" src=\"<? echo \$var:subpfeil ?>\"><a href=\"javascript:jslGoTo('fon','laender')\">Ländereinstellung<\/a><span class=\"PTextOnly\">Ländereinstellung<\/span><\/li>" "${SRC}/usr/www/${OEMLINK}/html/de/menus/menu2_fon.html"
  `cat "${SRC}/usr/www/${OEMLINK}/html/de/menus/menu2_fon.html" | grep -q 'isMultiCountry' ` ||\
  sed -i -e "s/pagename 'laender'/pagename laender/" "${SRC}/usr/www/${OEMLINK}/html/de/menus/menu2_fon.html"
fi #<-- multicountry
file_nLIST="/html/de/internet/dslsnrset.frm \
/html/de/internet/dslsnrset.html \
/html/de/first/basic_first_Annex.js \
/html/de/first/basic_first_Annex.frm \
/html/de/first/basic_first_Annex.html"
 #show settings tub
 #-----------------------------------------------------------------
  for file_n in adsl.html atm.html bits.html overview.html; do
   if [ -f "${SRC}/usr/www/${OEMLINK}/html/de/internet/$file_n" ]; then 
    sed -i -e "s|<? if neq \$var:Annex A|<? if neq \$var:Annex $ANNEX|" "${SRC}/usr/www/${OEMLINK}/html/de/internet/$file_n"
#    cat "${SRC}/usr/www/${OEMLINK}/html/de/internet/$file_n" | grep -q "Annex $ANNEX" &&\
#    echo2 "  /usr/www/${OEMLINK}/html/de/internet/$file_n"
   fi
  done
 #---------------------------------------------------------------
#--> multiannex
if [ "${FORCE_DSL_MULTI_ANNEX}" = "y" ]; then
  #Make Tab Einstellungen visibel in ever case 
  for file_n in atm.html adsl.html bits.html overview.html; do
	sed -i -e 's|$var:Annex .|A B|'  "${SRC}/usr/www/${OEMLINK}/html/de/internet/$file_n"
	sed -i -e 's|<? query box:settings/expertmode/activated ?>|1|'  "${SRC}/usr/www/${OEMLINK}/html/de/internet/$file_n"
	# with Firmware-Version 54.04.99-15852 names are changed 
	# dslsnrset.* labor_dsl*
	### sed -i -e 's|uiDoLaborDSLPage()|uiDoSNRPage()|'  "${SRC}/usr/www/${OEMLINK}/html/de/internet/$file_n"
  done 
  for file_n in /html/de/first/basic_first.js /html/de/first/basic_first.frm /html/de/help/hilfe_internet_dslsnrset.html; do
    if [ -f "${SRC_2}/usr/www/${OEML2}/$file_n" ] && ! [ -f "${SRC}/usr/www/${OEMLINK}/$file_n" ]; then
     cp -fdrp "${SRC_2}/usr/www/${OEML2}/$file_n" "${SRC}/usr/www/${OEMLINK}/$file_n" && echo2 "  Copy from 2nd AVM firmware: $file_n"
    fi
  done
 sed -i -e 's/export CONFIG_ANNEX="A"/export CONFIG_ANNEX="B"/' "${SRC}"/etc/init.d/rc.conf
 sed -i -e 's/CONFIG_DSL_MULTI_ANNEX="n"/CONFIG_DSL_MULTI_ANNEX="y"/' "${SRC}"/etc/init.d/rc.conf
 sed -i -e "s/isMultiAnnex=0/isMultiAnnex=1/g" "${SRC}"/etc/init.d/rc.S
 ! [ -f "${SRC}/usr/www/${OEMLINK}/html/de/internet/dslsnrset.js" ] && modpatch "${SRC}/${USRWWW}" "$P_DIR/add_dslsnrjs_de.patch"
 if  `grep -q 'MultiAnnex' "${SRC}/usr/www/${OEMLINK}/html/de/internet/dslsnrset.js"`; then
  echo "-- Multi Annex Option is not forced, but in use becaus 1st firmware is a multiannex fimware."
 else
  echo "-- Adding timezone pages ..."
  [ "$avm_Lang" = "de" ] && ( [ -f "${SRC}"/usr/www/$OEMLINK/html/de/system/timeZone.js ] || modpatch "${SRC}/${USRWWW}" "$P_DIR/add_timezone_de.patch" )
  [ "$avm_Lang" != "de" ] && ( [ -f "${SRC}"/usr/www/$OEMLINK/html/de/system/timeZone.js ] || modpatch "${SRC}/${USRWWW}" "$P_DIR/add_timezone_en.patch" )
  for file_n in $file_nLIST; do
   [ -f "${SRC}/usr/www/${OEMLINK}/$file_n" ] && rm -f "${SRC}/usr/www/${OEMLINK}/$file_n"
  done
  echo "-- Adding multiannex pages ..."
  [ "$avm_Lang" = "de" ] && modpatch "${SRC}/${USRWWW}" "$P_DIR/add_dslsnrset_de.patch"
  [ "$avm_Lang" != "de" ] && modpatch "${SRC}/${USRWWW}" "$P_DIR/add_dslsnrset_en.patch"
  file_nLIST="$file_nLIST \
/html/de/system/timeZone.js \
/html/de/system/timeZone.frm \
/html/de/system/timeZone.html"
  if ! `grep -q 'ar7cfg.dslglobalconfig.Annex' "${SRC}"/etc/init.d/rc.conf`; then
     sed -i -e '/export ANNEX=.cat .CONFIG_ENVIRONMENT_PATH.annex./d' "${SRC}"/etc/init.d/rc.conf
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
fi' "${SRC}"/etc/init.d/rc.conf
  fi
 # for savety in some Firmwares needed
  if ! `grep -q 'export CONFIG_DSL_MULTI_ANNEX' "${SRC}"/etc/init.d/rc.conf`; then
      sed -i -e '/export CONFIG_ANNEX="B"/a\
export CONFIG_DSL_MULTI_ANNEX="y"' "${SRC}"/etc/init.d/rc.conf
  fi
  if ! `grep -q 'var.isMultiAnnex' "${SRC}"/etc/init.d/rc.S`; then
      sed -i -e '/setvariable var:FirmwareVersion/a\
isMultiAnnex=1\
echo "<? setvariable var:isMultiAnnex  XcommaX$isMultiAnnexXcommaX  ?>" >>${CONFIG_DEF}' "${SRC}"/etc/init.d/rc.S
  sed -i -e "s/XcommaX/'/g" "${SRC}"/etc/init.d/rc.S
  fi
  # do it this way so it also works with 7170 firmwares
  if ! `grep -q 'MultiAnnex' "${SRC}/usr/www/${OEMLINK}/html/de/internet/dslsnrset.js"`; then
  sed -i -e '/function uiDoSave/a\
bAnnexConfirm=false;\
annex = jslGetValue("uiPostAnnex");\
if (jslGetChecked("uiViewAnnexA") && annex!="A") {\
if (confirm(g_mldChangeAnnexQuestion)) {\
jslSetValue("uiPostAnnex", "A");\
jslEnable("uiPostAnnex");\
bAnnexConfirm=true;\
}\
}\
if (jslGetChecked("uiViewAnnexB") && annex!="B") {\
if (confirm(g_mldChangeAnnexQuestion)) {\
jslSetValue("uiPostAnnex", "B");\
jslEnable("uiPostAnnex");\
bAnnexConfirm=true;\
}\
}\
function uiDoHelp() {\
jslPopHelp("hilfe_internet_dslsnrset");\
}'  "${SRC}/usr/www/${OEMLINK}/html/de/internet/dslsnrset.js"
  sed -i -e "s/^0$/bAnnexConfirm/"  "${SRC}/usr/www/${OEMLINK}/html/de/internet/dslsnrset.js"
  sed -i -e '/function uiDoOnLoad/a\
InitAnnex();'  "${SRC}/usr/www/${OEMLINK}/html/de/internet/dslsnrset.js"
  sed -i -e '/function InitMode/i\
var g_oem = "<? query env:status/OEM ?>";\
var g_mldChangeAnnex = "Change Annex";\
var g_mldChangeOver = "Annex Changed";\
g_mldChangeAnnexQuestion=g_mldChangeAnnex;\
function InitAnnex()\
{\
annex = jslGetValue("uiPostAnnex");\
if (annex=="A")\
uiSetAnnex(0);\
else if (annex=="B")\
uiSetAnnex(1);\
}\
function uiSetAnnex(n)\
{\
jslSetChecked("uiViewAnnexA", n==0);\
jslSetChecked("uiViewAnnexB", n==1);\
}'  "${SRC}/usr/www/${OEMLINK}/html/de/internet/dslsnrset.js"
  fi
  if [ "$avm_Lang" = "de" ]; then
   sed -i -e 's/Change Annex/Sie haben die ADSL-Leitungskonfiguration geändert. Eine falsche Einstellung kann dazu führen, dass keine DSL-Verbindung mehr zustande kommt. Damit die Änderung wirksam wird muss die Box neugestartet werden. Sind Sie sicher, dass die Änderung vorgenommen werden soll?/' "${SRC}/usr/www/${OEMLINK}/html/de/internet/dslsnrset.js"
  else
   sed -i -e 's/Change Annex/You did change the DSL wire configuration. A worong setting will lead to a loss off connection. Reboot is neede that the changes can be but to ation, shold that be done?/'  "${SRC}/usr/www/${OEMLINK}/html/de/internet/dslsnrset.js"
  fi
  Unicode_ut8="n"
  `cat "${SRC}"/usr/www/${OEMLINK}/html/index.html | grep -q 'charset=utf-8' ` && Unicode_ut8="y" 
  file_nLIST="/html/de/internet/dslsnrset.html \
/html/de/first/basic_first_Annex.html \
/html/de/internet/dslsnrset.js"
  for file_n in $file_nLIST; do
    file_nname="${SRC}/usr/www/${OEMLINK}${file_n}"
    if [ "$Unicode_ut8" = "y" ] && [ "$avm_Lang" = "de" ]; then
     [ -f ${file_nname} ] && iconv --from-code=ISO-8859-1 --to-code=UTF-8 "${file_nname}" > ${file_nname}.ut8
     rm -f ${file_nname}
     [ -f ${file_nname}.ut8 ] && mv ${file_nname}.ut8 ${file_nname} && echo2 "-- $file_n changed to ut8"
    fi
  done
 fi # <-- ? 1st firmware multiannex
#  for EXT in frm js html; do
#    FILE="${SRC}/usr/www/${OEMLINK}/html/de/internet/labor_dsl.$EXT"
#    FILE_2="${SRC}/usr/www/${OEMLINK}/html/de/internet/dslsnrset.$EXT"
#    [ -f $FILE_2 ] && mv -f $FILE_2 $FILE
#  done
fi # <-- Multiannex 
#----------------------------------------------------------------------------------------------------
# --> multilanguage
if [ "${FORCE_MULTI_LANGUAGE}" = "y" ]; then
 # on 7240 Firmware some pages are missing
  `cat "${SRC}/usr/www/${OEMLINK}/html/de/home/sitemap.html" | grep -q 'isMultiLanguage' ` ||\
   modpatch "${SRC}/${USRWWW}" "$P_DIR/add_language_de.patch"
  `cat "${SRC}/usr/www/${OEMLINK}/html/de/home/sitemap.html" | grep -q 'isMultiLanguage' ` ||\
  sed -i -e "/.system., .timeZone./a\
<p class=\"ml10\"><a href=\"javascript:jslGoTo('system', 'language');\">Sprache<\/a><\/p>" "${SRC}/usr/www/${OEMLINK}/html/de/home/sitemap.html"
  `cat "${SRC}/usr/www/${OEMLINK}/html/de/menus/menu2_system.html" | grep -q 'isMultiLanguage' ` ||\
  sed -i -e "/'system','timeZone'/a\
<? setvariable var:classname 'LSubitem' ?>\n\
<? if eq \$var:pagename language \`<? setvariable var:classname 'LSubitemaktiv' ?>\` ?>\n\
<li class=\"<? echo \$var:classname ?>\"><img class=\"LMenuPfeil\" src=\"<? echo \$var:subpfeil ?>\"><a href=\"javascript:jslGoTo('system','language')\">Sprache<\/a><span class=\"PTextOnly\">Sprache<\/span><\/li>" "${SRC}/usr/www/${OEMLINK}/html/de/menus/menu2_system.html"
  #if file exist in 2nd or 3rd firmware use this file instead
   for file_n in /html/de/first/basic_first.js /html/de/first/basic_first.frm; do
    if [ -f "${SRC_2}/usr/www/${OEML2}/$file_n" ] && ! [ -f "${SRC}/usr/www/${OEMLINK}/$file_n" ]; then
     cp -fdrp "${SRC_2}/usr/www/${OEML2}/$file_n" "${SRC}/usr/www/${OEMLINK}/$file_n" && echo2 "  Copy from 2nd AVM firmware: $file_n"
    fi
   done
   for file_n in basic_first_Language.js basic_first_Language.frm basic_first_Language.html; do
   file_n="/html/de/first/${file_n}"
    [ -f "${SRC_2}/usr/www/${OEML2}/$file_n" ] && cp -fdrp "${SRC_2}/usr/www/${OEML2}/$file_n" "${SRC}/usr/www/${OEMLINK}/$file_n" && echo2 "  Copy from 2nd AVM firmware: $file_n"
   done
   [ -f "${SRC}"/etc/htmltext_de.db ] || echo -e "-- \033[1mAttention:\033[0m 1st Firmware is not usabel for multilingual!" && sleep 5
   sed -i -e 's/CONFIG_MULTI_LANGUAGE="n"/CONFIG_MULTI_LANGUAGE="y"/' "${SRC}"/etc/init.d/rc.conf
   echo "-- Adding mulilingual pages from t-Home or 2nd AVM firmware ..."
   #copy language datbase
   #LanguageList="en it es fr"
    [ "${REMOVE_EN}" != "y" ] && LanguageList="en "
    [ "${REMOVE_IT}" != "y" ] && LanguageList+="it "
    [ "${REMOVE_ES}" != "y" ] && LanguageList+="es "
    [ "${REMOVE_FR}" != "y" ] && LanguageList+="fr "
   for DIR in $LanguageList; do
    if [ -d "${DST}/etc/default.${DEST_PRODUKT}/${OEML}/$DIR" ]; then
     cp -fdrp "${DST}/etc/default.${DEST_PRODUKT}/${OEML}/$DIR" "${SRC}/etc/default.${CONFIG_PRODUKT}/${OEMLINK}/$DIR" && echo2 "  Copy language directory from t-Home firmware: $DIR"
    fi 
    if [ -d "${SRC_2}/etc/default.${SORCE_2_PRODUKT}/${OEML2}/$DIR" ]; then
     cp -fdrp "${SRC_2}/etc/default.${SORCE_2_PRODUKT}/${OEML2}/$DIR" "${SRC}/etc/default.${CONFIG_PRODUKT}/${OEMLINK}/$DIR" && echo2 "  Copy language directory from 2nd AVM firmware: $DIR"
    fi 
    if [ -d "${DST}/usr/share/tam/msg/default/$DIR" ]; then
     cp -fdrp "${DST}/usr/share/tam/msg/default/$DIR" "${SRC}/usr/share/tam/msg/default/$DIR" && echo2 "  Copy TAM language directory from t-Home firmware: $DIR"
    fi 
    if [ -d "${SRC_2}/usr/share/tam/msg/default/$DIR" ]; then
     cp -fdrp "${SRC_2}/usr/share/tam/msg/default/$DIR" "${SRC}/usr/share/tam/msg/default/$DIR" && echo2 "  Copy TAM language directory from 2nd AVM firmware: $DIR"
    fi 
    if [ -d "${SRC}/usr/share/tam/msg/default/de" ]; then
     for FILE in `ls "${SRC}/usr/share/tam/msg/default/de"`; do
      if [ -f "${SRC}/usr/share/tam/msg/default/de/${FILE}" ]; then
       if ! [ -f "${SRC}/usr/share/tam/msg/default/$DIR/${FILE}" ]; then
        cp -fdrp "${SRC}/usr/share/tam/msg/default/de/$FILE" --target-directory="${SRC}/usr/share/tam/msg/default/$DIR" && echo2 "  Copy TAM language directory from t-Home firmware: $DIR"
       fi
      fi
     done
    fi
    FileList="/usr/share/telefon/tam-$DIR.html /usr/share/telefon/fax-$DIR.html /usr/share/telefon/tam-$DIR.txt /usr/share/telefon/fax-$DIR.txt"
    for Langufile in $FileList; do
     if [ -f "${DST}/$Langufile" ]; then
      cp -fdrp "${DST}/$Langufile" "${SRC}/$Langufile" && echo2 "  Copy: $Langufile"
     fi 
     if [ -f "${SRC_2}/$Langufile" ]; then
      cp -fdrp "${SRC_2}/$Langufile" "${SRC}/$Langufile" && echo2 "  Copy: $Langufile"
     fi 
    done
   done
   #LanguageList="en it es fr"
   for lang in $LanguageList; do
    if ! [ -f "${SRC}"/etc/htmltext_$lang.db ];then
     [ -f "${SRC}"/etc/htmltext_de.db ] && [ -f "${SRC_2}"/etc/htmltext_$lang.db ] && cp -fdrp "${SRC_2}"/etc/htmltext_$lang.db --target-directory="${SRC}"/etc &&\
     echo -e "-- \033[1mWarning:\033[0m 2nd AVM firmware database $lang is used, some text may be missing." && sleep 2
     [ -f "${SRC}"/etc/htmltext_de.db ] && [ -f "${DST}"/etc/htmltext_$lang.db ] && cp -fdrp "${DST}"/etc/htmltext_$lang.db --target-directory="${SRC}"/etc &&\
     echo -e "-- \033[1mWarning:\033[0m t-Home firmware database $lang is used, some text may be missing." && sleep 2
    fi
   done
   FileList="root_ca.pem root_ca_ta.pem root_ca_mnet.pem"
   for ca_file in $FileList; do
     [ -f "${DST}/etc/default.${DEST_PRODUKT}/${OEML}/$ca_file" ] && cp -f "${DST}/etc/default.${DEST_PRODUKT}/${OEML}/$ca_file" "${SRC}/etc/default.${CONFIG_PRODUKT}/${OEMLINK}/$ca_file" && echo2 "  Copy: $ca_file"
     [ -f "${SRC_2}/etc/default.${SORCE_2_PRODUKT}/${OEML2}/$ca_file" ] && cp -f "${SRC_2}/etc/default.${SORCE_2_PRODUKT}/${OEML2}/$ca_file" "${SRC}/etc/default.${CONFIG_PRODUKT}/${OEMLINK}/$ca_file" && echo2 "  Copy: $ca_file"
   done 

fi # <-- multilanguage
if [ "${FORCE_LANGUAGE}" != "de" ]; then
   #[ -f "${SRC}"/etc/htmltext_de.db ] || echo -e "-- \033[1mAttention:\033[0m 1st Firmware is not usabel for force language!" && sleep 7
   [ "${FORCE_LANGUAGE}" != "" ] && [ -f "${DST}"/etc/htmltext_${FORCE_LANGUAGE}.db ] && cp -fdrp "${DST}"/etc/htmltext_${FORCE_LANGUAGE}.db --target-directory="${SRC}"/etc && echo2 "  Copy: database ${FORCE_LANGUAGE}"
   [ "${FORCE_LANGUAGE}" != "" ] && [ -f "${SRC_2}"/etc/htmltext_${FORCE_LANGUAGE}.db ] && cp -fdrp "${SRC_2}"/etc/htmltext_${FORCE_LANGUAGE}.db --target-directory="${SRC}"/etc && echo2 "  Copy: database ${FORCE_LANGUAGE}"
fi

if [ "${REMOVE_SOME_LANGUAGE}" = "y" ]; then
    [ "${REMOVE_EN}" = "y" ] && LanguageList="en "
    [ "${REMOVE_DE}" = "y" ] && LanguageList+="de "
    [ "${REMOVE_IT}" = "y" ] && LanguageList+="it "
    [ "${REMOVE_ES}" = "y" ] && LanguageList+="es "
    [ "${REMOVE_FR}" = "y" ] && LanguageList+="fr "
   for DIR in $LanguageList; do
    if [ "${DIR}" != "$FORCE_LANGUAGE" ]; then
     rm -fdR "${SRC}/etc/default.${CONFIG_PRODUKT}/${OEM}/$DIR" && echo2 "  Removed language directory: $DIR"
     rm -fr "${SRC}/etc/htmltext_$DIR.db" && echo -e "-- Language database $DIR removed."
     rm -fdR "${SRC}/usr/share/tam/msg/default/$DIR" && echo2 "  Removed TAM language directory: $DIR"
     FileList="/usr/share/telefon/tam-$DIR.html /usr/share/telefon/fax-$DIR.html /usr/share/telefon/tam-$DIR.txt /usr/share/telefon/fax-$DIR.txt"
     for Langufile in $FileList; do
       rm -f "${SRC}/$Langufile" && echo2 "  Removed: $Langufile"
     done
    fi
   done
fi
#set default datadase link if de is not avalabel
if ! [ -f "${SRC}/etc/htmltext_de.db" ] ; then
    [ -L "${SRC}/etc/htmltext.db" ] && rm -fd -R "${SRC}/etc/htmltext.db"
    ln -s /etc/htmltext_$FORCE_LANGUAGE.db  "${SRC}/etc/htmltext.db"
fi
#-------------------------------
# enable some setting usual only set if OEM is avme
# should be moved to a extra script 
FILE="${SRC}/usr/www/${OEMLINK}/html/de/internet/internet_expert.html"
if [ -f "$FILE" ]; then
    sed -i -e 's|if eq $var:OEM avme|if eq avme avme|g'  "$FILE"
    grep -q 'if eq avme avme' "$FILE" && echo2 "-- enable setting for OEM avm on: internet_expert.html"
fi
FILE="${SRC}/usr/www/${OEMLINK}/html/de/internet/internet_expert.js"
if [ -f "$FILE" ]; then
    sed -i -e 's|//Init|Init|g' "$FILE"
    sed -i -e 's|//jsl|jsl|g' "$FILE"
    sed -i -e 's|// jsl|jsl|g' "$FILE"
fi
FILE="${SRC}/usr/www/${OEMLINK}/html/de/internet/authform.frm"
if [ -f "$FILE" ]; then
    sed -i -e 's|if eq $var:OEM avme|if eq avme avme|g'  "$FILE"
    grep -q 'if eq avme avme' "$FILE" && echo2 "-- enable setting for OEM avm on: authform.frm"
fi
FILE="${SRC}/usr/www/${OEMLINK}/html/de/internet/authform.js"
if [ -f "$FILE" ]; then
    sed -i -e 's|if eq $var:OEM avme|if eq avme avme|g'  "$FILE"
    sed -i -e "s|if (oem != 'avme'|if ('avm' != 'avm'|g"  "$FILE"
    grep -q 'if eq avme avme' "$FILE" && echo2 "-- enable setting for OEM avm on: authform.js"
fi
# add Annex option also for oem avm
#if [ -f "${SRC}/usr/www/${OEMLINK}/html/logincheck.html" ]; then
#    sed -i -e 's|if (oem == "avme") {|if ( "avme" == "avme") {|'  "${SRC}/usr/www/${OEMLINK}/html/logincheck.html"
#    grep -q '( "avme" == "avme")' "${SRC}/usr/www/${OEMLINK}/html/logincheck.html" && echo2 "-- enable select ANNEX for OEM avm"
#    sed -i -e 's|var AnnexSet="1";|AnnexSet="<? query sar:settings\/IsAnnexSet ?>";|'  "${SRC}/usr/www/${OEMLINK}/html/logincheck.html"
#fi
exit 0
