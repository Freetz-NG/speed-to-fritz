#!/bin/bash
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
     cp -fdrp "${SRC_2}/usr/www/${OEML2}/$file_n" "${SRC}/usr/www/${OEMLINK}/$file_n" && echo2 "    copy from 2nd AVM firmware: $file_n"
    fi
   done
   for file_n in basic_first_Language.js basic_first_Language.frm basic_first_Language.html; do
   file_n="/html/de/first/${file_n}"
    [ -f "${SRC_2}/usr/www/${OEML2}/$file_n" ] && cp -fdrp "${SRC_2}/usr/www/${OEML2}/$file_n" "${SRC}/usr/www/${OEMLINK}/$file_n" && echo2 "    copy from 2nd AVM firmware: $file_n"
   done
   [ -f "${SRC}"/etc/htmltext_de.db ] || echo -e "-- \033[1mAttention:\033[0m 1st Firmware is not usabel for multilingual!" && sleep 5
   sed -i -e 's/CONFIG_MULTI_LANGUAGE="n"/CONFIG_MULTI_LANGUAGE="y"/' "${SRC}"/etc/init.d/rc.conf
   echo "-- adding mulilingual pages from basis or 2nd AVM firmware ..."
   #copy language database
   #LanguageList="en it es fr"
    [ "${REMOVE_EN}" != "y" ] && LanguageList="en "
    [ "${REMOVE_IT}" != "y" ] && LanguageList+="it "
    [ "${REMOVE_ES}" != "y" ] && LanguageList+="es "
    [ "${REMOVE_FR}" != "y" ] && LanguageList+="fr "
   for DIR in $LanguageList; do
    if [ -d "${DST}/etc/default.${DEST_PRODUKT}/${OEML}/$DIR" ]; then
     cp -fdrp "${DST}/etc/default.${DEST_PRODUKT}/${OEML}/$DIR" "${SRC}/etc/default.${CONFIG_PRODUKT}/${OEMLINK}/$DIR" && echo2 "    copy language directory from basis firmware: $DIR"
    fi 
    if [ -d "${SRC_2}/etc/default.${SORCE_2_PRODUKT}/${OEML2}/$DIR" ]; then
     cp -fdrp "${SRC_2}/etc/default.${SORCE_2_PRODUKT}/${OEML2}/$DIR" "${SRC}/etc/default.${CONFIG_PRODUKT}/${OEMLINK}/$DIR" && echo2 "    copy language directory from 2nd AVM firmware: $DIR"
    fi 
    if [ -d "${DST}/usr/share/tam/msg/default/$DIR" ]; then
     cp -fdrp "${DST}/usr/share/tam/msg/default/$DIR" "${SRC}/usr/share/tam/msg/default/$DIR" && echo2 "    copy TAM language directory from basis firmware: $DIR"
    fi 
    if [ -d "${SRC_2}/usr/share/tam/msg/default/$DIR" ]; then
     cp -fdrp "${SRC_2}/usr/share/tam/msg/default/$DIR" "${SRC}/usr/share/tam/msg/default/$DIR" && echo2 "    copy TAM language directory from 2nd AVM firmware: $DIR"
    fi 
    Language=`grep language ${SRC_2}/etc/default.language`
    avm_2_Lang=`echo ${Language##language} | tr -d ' '`
    if [ "$DIR" != "$avm_2_Lang" ]; then
     if [ -d "${SRC}/usr/share/tam/msg/default/$avm_2_Lang" ]; then
      for file_n in `ls "${SRC}/usr/share/tam/msg/default/de"`; do
       if [ -f "${SRC}/usr/share/tam/msg/default/$avm_2_Lang/${file_n}" ]; then
        if ! [ -f "${SRC}/usr/share/tam/msg/default/$DIR/${file_n}" ]; then
         cp -fdrp "${SRC}/usr/share/tam/msg/default/$avm_2_Lang/$file_n" "${SRC}/usr/share/tam/msg/default/$DIR/$file_n" &&\
         echo2 "   copy TAM default $avm_2_Lang language file from basis firmware to: $DIR/${file_n##*/}"
        fi
       fi
      done
     fi
    fi
    FileList="/usr/share/telefon/tam-$DIR.html /usr/share/telefon/fax-$DIR.html /usr/share/telefon/tam-$DIR.txt /usr/share/telefon/fax-$DIR.txt"
    for Langufile in $FileList; do
     if [ -f "${DST}/$Langufile" ]; then
      cp -fdrp "${DST}/$Langufile" "${SRC}/$Langufile" && echo2 "    copy: $Langufile"
     fi 
     if [ -f "${SRC_2}/$Langufile" ]; then
      cp -fdrp "${SRC_2}/$Langufile" "${SRC}/$Langufile" && echo2 "    copy: $Langufile"
     fi 
    done
   done
   #LanguageList="en it es fr"
   for lang in $LanguageList; do
    if ! [ -f "${SRC}"/etc/htmltext_$lang.db ];then
     [ -f "${SRC}"/etc/htmltext_de.db ] && [ -f "${SRC_2}"/etc/htmltext_$lang.db ] && cp -fdrp "${SRC_2}"/etc/htmltext_$lang.db --target-directory="${SRC}"/etc &&\
     echo -e "-- \033[1mWarning:\033[0m 2nd AVM firmware database $lang is used, some text may be missing." && sleep 2
     [ -f "${SRC}"/etc/htmltext_de.db ] && [ -f "${DST}"/etc/htmltext_$lang.db ] && cp -fdrp "${DST}"/etc/htmltext_$lang.db --target-directory="${SRC}"/etc &&\
     echo -e "-- \033[1mWarning:\033[0m basis firmware database $lang is used, some text may be missing." && sleep 2
    fi
   done
   FileList="root_ca.pem root_ca_ta.pem root_ca_mnet.pem"
   for ca_file in $FileList; do
     [ -f "${DST}/etc/default.${DEST_PRODUKT}/${OEML}/$ca_file" ] && cp -f "${DST}/etc/default.${DEST_PRODUKT}/${OEML}/$ca_file" "${SRC}/etc/default.${CONFIG_PRODUKT}/${OEMLINK}/$ca_file" && echo2 "    copy: $ca_file"
     [ -f "${SRC_2}/etc/default.${SORCE_2_PRODUKT}/${OEML2}/$ca_file" ] && cp -f "${SRC_2}/etc/default.${SORCE_2_PRODUKT}/${OEML2}/$ca_file" "${SRC}/etc/default.${CONFIG_PRODUKT}/${OEMLINK}/$ca_file" && echo2 "    copy: $ca_file"
   done 
fi # <-- multilanguage
