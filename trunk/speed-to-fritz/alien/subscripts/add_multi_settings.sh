#!/bin/bash
# include modpatch function
. ${include_modpatch}
echo "-- Adding multiannex pages ..."
#annex settings made via GUI
echo "-- Adding settings timezone pages ..."
if [ "${CONFIG_MULTI_COUNTRY}" = "y" ]; then
 sed -i -e 's/CONFIG_MULTI_COUNTRY="n"/CONFIG_MULTI_COUNTRY="y"/' "${SRC}"/etc/init.d/rc.conf
 echo "-- Adding mulicountry pages from source 2 or 3 ..."
 FILELIST="menu2_system.html sitemap.html authform.html vpn.html pppoe.html first_Sip_1.html first_ISP_0.html first_ISP_3.frm"
 rpl_avme_avm()
 {
	for file in $1; do
	if [ -f "$file" ]; then
	 grep -q '<? if eq $var:OEM avme `' "$file" && echo2 "  'avme' chanaged to 'avm' in File: ${file##*/}"
	 sed -i -e 's/<? if eq $var:OEM avme `/<? if eq 1 1 `/' "$file"
	fi 
	done
 }
 rn_files()
 {
	for file in $1; do
	IMGN="${file%/*}"
	#echo "$file" $IMGN/"$2"
	mv "$file" $IMGN/"$2"
	done
 }
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
fi
FILELIST="/html/de/internet/vdsl_profile.js \
/html/de/help/hilfe_internet_dslsnrset.html \
/html/de/internet/vdsl_profile.html \
/html/de/internet/vdsl_profile.frm \
/html/de/internet/dslsnrset.frm \
/html/de/internet/dslsnrset.html \
/html/de/internet/dslsnrset.js \
/html/de/first/basic_first_Annex.js \
/html/de/first/basic_first_Annex.frm \
/html/de/first/basic_first_Annex.html"
 #show settings tub
 #-----------------------------------------------------------------
  for FILE in adsl.html atm.html bits.html overview.html; do
  if [ -f "${SRC}/usr/www/${OEMLINK}/html/de/internet/$FILE" ]; then 
    sed -i -e "s|<? if neq \$var:Annex A|<? if neq \$var:Annex Z|" "${SRC}/usr/www/${OEMLINK}/html/de/internet/$FILE"
    echo2 "  /usr/www/${OEMLINK}/html/de/internet/$FILE"
  fi
 done
 #-----------------------------------------------------------------

if [ "${CONFIG_DSL_MULTI_ANNEX}" = "y" ]; then
 if [ "${CONFIG_MULTI_LANGUAGE}" != "y" ]; then
 [ "$avm_Lang" = "de" ] && ( [ -f "${SRC}"/usr/www/$OEMLINK/html/de/system/timeZone.js ] || modpatch "${SRC}" "$P_DIR/add_timezone_de.patch" )
 [ "$avm_Lang" = "en" ] && ( [ -f "${SRC}"/usr/www/$OEMLINK/html/de/system/timeZone.js ] || modpatch "${SRC}" "$P_DIR/add_timezone_en.patch" )
 for file in $FILELIST; do
   rm -f "${SRC}/usr/www/${OEMLINK}/$file"
 done
 [ "$avm_Lang" = "de" ] && modpatch "${SRC}" "$P_DIR/add_dslsnrset_de.patch"
 [ "$avm_Lang" = "en" ] && modpatch "${SRC}" "$P_DIR/add_dslsnrset_en.patch"
 else
  FILELIST="$FILELIST \
/html/de/system/timeZone.js \
/html/de/system/timeZone.frm \
/html/de/system/timeZone.html"
  OEML="avm" && [ -d "${DST}"/usr/www/avme ] && OEML="avme"
  OEML2="avm" && [ -d "${SRC_2}"/usr/www/avme ] && OEML2="avme"
  for file in $FILELIST; do
   if [ -f "${SRC_2}/usr/www/${OEML2}/$file" ]; then
    cp -fdrp "${SRC_2}/usr/www/${OEML2}/$file" "${SRC}/usr/www/${OEMLINK}/$file" && echo2 "  copy from 3rd FW: $file"
   fi    
   if [ -f "${DST}/usr/www/${OEML}/$file" ]; then
    cp -fdrp "${DST}/usr/www/${OEML}/$file" "${SRC}/usr/www/${OEMLINK}/$file" && echo2 "  copy from 2nd FW: $file"
   fi
  done
 fi
fi
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
  sed -i -e 's/CONFIG_DSL_MULTI_ANNEX="n"/CONFIG_DSL_MULTI_ANNEX="y"/' "${SRC}"/etc/init.d/rc.conf

USRWWW="usr/www/${OEMLINK}/html/de"
if [ "${CONFIG_MULTI_LANGUAGE}" = "y" ]; then
 sed -i -e 's/CONFIG_MULTI_LANGUAGE="n"/CONFIG_MULTI_LANGUAGE="y"/' "${SRC}"/etc/init.d/rc.conf
 echo "-- Adding mulilingual pages from source 2 or 3 ..."
 #copy language datbase
 LanguageList="de en it es fr" #de dont copy de as well
 for DIR in $LanguageList; do
    if [ -d "${DST}/etc/default.${DEST_PRODUKT}"/${OEML}/$DIR ]; then
     cp -fdrp "${DST}/etc/default.${DEST_PRODUKT}"/${OEML}/$DIR "${SRC}/etc/default.${CONFIG_PRODUKT}/${OEMLINK}/$DIR" && echo2 "  copy directory from 2nd FW: $DIR"
    fi 
    if [ -d "${SRC_2}/etc/default.${SORCE_2_PRODUKT}"/${OEML2}/$DIR ]; then
     cp -fdrp "${SRC_2}/etc/default.${SORCE_2_PRODUKT}"/${OEML2}/$DIR "${SRC}/etc/default.${CONFIG_PRODUKT}/${OEMLINK}/$DIR" && echo2 "  copy directory from 3nd FW: $DIR"
    fi 
 done
 LanguageList="en it es fr" #de dont copy de as well
 for DIR in $LanguageList; do
    [ -f "${DST}"/etc/htmltext_$DIR.db ] && cp -fdrp "${DST}"/etc/htmltext_$DIR.db --target-directory="${SRC}"/etc && echo2 "  copy: database $DIR"
    [ -f "${SRC_2}"/etc/htmltext_$DIR.db ] && cp -fdrp "${SRC_2}"/etc/htmltext_$DIR.db --target-directory="${SRC}"/etc && echo2 "  copy: database $DIR"
 done
fi
if [ "${FORCE_LANGUAGE}" != "de" ]; then
 [ "${FORCE_LANGUAGE}" != "" ] && [ -f "${DST}"/etc/htmltext_${FORCE_LANGUAGE}.db ] && cp -fdrp "${DST}"/etc/htmltext_${FORCE_LANGUAGE}.db --target-directory="${SRC}"/etc && echo2 "  copy: database ${FORCE_LANGUAGE}"
 [ "${FORCE_LANGUAGE}" != "" ] && [ -f "${SRC_2}"/etc/htmltext_${FORCE_LANGUAGE}.db ] && cp -fdrp "${SRC_2}"/etc/htmltext_${FORCE_LANGUAGE}.db --target-directory="${SRC}"/etc && echo2 "  copy: database ${FORCE_LANGUAGE}"
fi
#if ! `grep -q 'id="uiTempLang"' "${SRC}"/usr/www/$OEMLINK/html/de/first/basic_first.frm`; then
#echo '<input type="hidden" name="var:lang" value="<? echo $var:lang ?>" id="uiTempLang">' >> "${SRC}"/usr/www/$OEMLINK/html/de/first/basic_first.frm
#fi

exit 0
