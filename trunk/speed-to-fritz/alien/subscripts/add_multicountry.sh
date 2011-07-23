#!/bin/bash
echo "-- adding mulicountry pages from source basis or 2nd AVM firmware ..."
#--> multicountry SRC_2
if [ "${FORCE_MULTI_COUNTRY_SRC2}" = "y" ]; then
  for file_n in /html/de/first/basic_first.js /html/de/first/basic_first.frm; do
    if [ -f "${SRC_2}/usr/www/${OEML2}/$file_n" ] && ! [ -f "${SRC}/usr/www/${OEMLINK}/$file_n" ]; then
     cp -fdrp "${SRC_2}/usr/www/${OEML2}/$file_n" "${SRC}/usr/www/${OEMLINK}/$file_n" && echo2 "    copy from 2nd AVM firmware: $file_n"
    fi
  done
 for file_n in basic_first_Country.js basic_first_Country.frm basic_first_Country.html; do
   file_n="/html/de/first/${file_n}"
   [ -f "${SRC_2}/usr/www/${OEML2}/$file_n" ] && cp -fdrp "${SRC_2}/usr/www/${OEML2}/$file_n" "${SRC}/usr/www/${OEMLINK}/$file_n" && echo2 "    copy from 2nd AVM firmware: $file_n"
 done
 echo "-- adding mulicountry pages from 2nd AVM firmware ..."
 #copy default country
 if [ -n "$FBIMG_2" ]; then
  [ -d "${SRC_2}/etc/default.049" ] && cp -fdrp "${SRC_2}"/etc/default.0* --target-directory=${SRC}/etc
  [ -d "${SRC_2}/etc/default.99" ] && cp -fdrp "${SRC_2}"/etc/default.9* --target-directory=${SRC}/etc
 fi
fi #<-- multicountry SRC_2
#--> multicountry 
if [ "${FORCE_MULTI_COUNTRY}" = "y" ]; then
  for file_n in /html/de/first/basic_first.js /html/de/first/basic_first.frm; do
    if [ -f "${DST}/usr/www/${OEML}/$file_n" ] && ! [ -f "${SRC}/usr/www/${OEMLINK}/$file_n" ]; then
     cp -fdrp "${DST}/usr/www/${OEML}/$file_n" "${SRC}/usr/www/${OEMLINK}/$file_n" && echo2 "    copy from 2nd AVM firmware: $file_n"
    fi
  done
 for file_n in basic_first_Country.js basic_first_Country.frm basic_first_Country.html; do
   file_n="/html/de/first/${file_n}"
   [ -f "${DST}/usr/www/${OEML}/$file_n" ] && cp -fdrp "${DST}/usr/www/${OEML}/$file_n" "${SRC}/usr/www/${OEMLINK}/$file_n" && echo2 "    copy from base firmware: $file_n"
 done
 echo "-- adding mulicountry pages from source basis firmware ..."
 #copy default country
 [ -d "${DST}/etc/default.049" ] &&  cp -fdrp "${DST}"/etc/default.0* --target-directory=${SRC}/etc
 [ -d "${DST}/etc/default.99" ] && cp -fdrp "${DST}"/etc/default.9* --target-directory=${SRC}/etc
fi #<-- multicountry

if [ "${FORCE_MULTI_COUNTRY_SRC2}" = "y" ] || [ "${FORCE_MULTI_COUNTRY}" = "y" ]; then
 echo "-- fix mulicountry menue entrys ..."
 sed -i -e 's/CONFIG_MULTI_COUNTRY="n"/CONFIG_MULTI_COUNTRY="y"/' "${SRC}"/etc/init.d/rc.conf
 ##file_nLIST="menu2_system.html sitemap.html authform.html vpn.html pppoe.html first_Sip_1.html first_ISP_0.html first_ISP_3.frm"
 if [ "${OEM}" = "avm" ]; then
  rpl_avme_avm "$(find "${SRC}/usr/www/${OEMLINK}" -name *.html)" 
  rpl_avme_avm "$(find "${SRC}/usr/www/${OEMLINK}" -name *.frm)" 
 fi
 if [ "${OEM}" = "avm" ]; then
  rn_files "$(find "${SRC}/etc" -name fx_conf.avme)" "fx_conf.${OEMLINK}"
  rn_files "$(find "${SRC}/etc" -name fx_lcr.avme)" "fx_lcr.${OEMLINK}"
 fi
 if [ "${OEM}" = "avme" ]; then
  rn_files "$(find "${SRC}/etc" -name fx_conf.avm)" "fx_conf.${OEMLINK}"
  rn_files "$(find "${SRC}/etc" -name fx_lcr.avm)" "fx_lcr.${OEMLINK}"
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
fi #<-- multicountry both
