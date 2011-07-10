#!/bin/bash
# include modpatch function
. ${include_modpatch}
 rpl_avme_avm()
 {
	for file_n in $1; do
	if [ -f "$file_n" ]; then
	 grep -q '<? if eq $var:OEM avme `' "$file_n" && echo2 "    enabled all 'avme' options in file: ${file_n##*/}"
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

. $inc_DIR/includefunctions

readConfig "MULTI_COUNTRY" "AVM_TMP_MULTI_COUNTRY" "${SRC}/etc/init.d"
readConfig "DSL_MULTI_ANNEX" "AVM_TMP_MULTI_ANNEX" "${SRC}/etc/init.d"
readConfig "MULTI_LANGUAGE" "AVM_TMP_MULTI_LANGUAGE" "${SRC}/etc/init.d"

readConfig "MULTI_COUNTRY" "TCOM_TMP_MULTI_COUNTRY" "${DST}/etc/init.d"
readConfig "DSL_MULTI_ANNEX" "TCOM_TMP_MULTI_ANNEX" "${DST}/etc/init.d"
readConfig "MULTI_LANGUAGE" "TCOM_TMP_MULTI_LANGUAGE" "${DST}/etc/init.d"

readConfig "MULTI_COUNTRY" "SRC_2_TMP_MULTI_COUNTRY" "${SRC_2}/etc/init.d"
readConfig "DSL_MULTI_ANNEX" "SRC_2_TMP_MULTI_ANNEX" "${SRC_2}/etc/init.d"
readConfig "MULTI_LANGUAGE" "SRC_2_TMP_MULTI_LANGUAGE" "${SRC_2}/etc/init.d"

[ "$TCOM_TMP_MULTI_COUNTRY" = "y" ] && echo "-- 1st base firmware is multicountry"
[ "$TCOM_TMP_MULTI_ANNEX" = "y" ] && echo "-- 1st base firmware is multiannex"
[ "$TCOM_TMP_MULTI_LANGUAGE" = "y" ] && echo "-- 1st base firmware is multilingual"

[ "$AVM_TMP_MULTI_COUNTRY" = "y" ] && echo "-- 2nd firmware is multicountry"
[ "$AVM_TMP_MULTI_ANNEX" = "y" ] && echo "-- 2nd firmware is multiannex"
[ "$AVM_TMP_MULTI_LANGUAGE" = "y" ] && echo "-- 2nd firmware is multilingual"

[ "$SRC_2_TMP_MULTI_COUNTRY" = "y" ] && echo "-- 3rd firmware is multicountry"
[ "$SRC_2_TMP_MULTI_ANNEX" = "y" ] && echo "-- 3rd firmware is multiannex"
[ "$SRC_2_TMP_MULTI_LANGUAGE" = "y" ] && echo "-- 3rd firmware is multilingual"

[ "$AVM_TMP_MULTI_COUNTRY" != "y" ] && . $sh_DIR/remove_timezone.sh
[ "$AVM_TMP_MULTI_COUNTRY" != "y" ] && echo "-- add multicontry" && . $sh_DIR/add_multicountry.sh
[ "$AVM_TMP_MULTI_ANNEX" != "y" ] && echo "-- add multiannex" && . $sh_DIR/add_multiannex.sh
[ "$AVM_TMP_MULTI_LANGUAGE" != "y" ] && echo "-- add multilingual" && . $sh_DIR/add_multilingual.sh
#export CONFIG_MULTI_COUNTRY="y"

# include, order of includes may count

if [ "${FORCE_LANGUAGE}" != "de" ]; then
   #[ -f "${SRC}"/etc/htmltext_de.db ] || echo -e "-- \033[1mAttention:\033[0m 1st Firmware is not usabel for force language!" && sleep 7
   [ "${FORCE_LANGUAGE}" != "" ] && [ -f "${DST}"/etc/htmltext_${FORCE_LANGUAGE}.db ] && cp -fdrp "${DST}"/etc/htmltext_${FORCE_LANGUAGE}.db --target-directory="${SRC}"/etc && echo2 "    copy: database ${FORCE_LANGUAGE}"
   [ "${FORCE_LANGUAGE}" != "" ] && [ -f "${SRC_2}"/etc/htmltext_${FORCE_LANGUAGE}.db ] && cp -fdrp "${SRC_2}"/etc/htmltext_${FORCE_LANGUAGE}.db --target-directory="${SRC}"/etc && echo2 "    copy: database ${FORCE_LANGUAGE}"
fi

if [ "${REMOVE_SOME_LANGUAGE}" = "y" ]; then
    [ "${REMOVE_EN}" = "y" ] && LanguageList="en "
    [ "${REMOVE_DE}" = "y" ] && LanguageList+="de "
    [ "${REMOVE_IT}" = "y" ] && LanguageList+="it "
    [ "${REMOVE_ES}" = "y" ] && LanguageList+="es "
    [ "${REMOVE_FR}" = "y" ] && LanguageList+="fr "
   for DIR in $LanguageList; do
    if [ "${DIR}" != "$FORCE_LANGUAGE" ]; then
     rm -fdR "${SRC}/etc/default.${CONFIG_PRODUKT}/${OEM}/$DIR" && echo2 "    removed language directory: $DIR"
     rm -fr "${SRC}/etc/htmltext_$DIR.db" && echo -e "    language database $DIR removed."
     rm -fdR "${SRC}/usr/share/tam/msg/default/$DIR" && echo2 "    removed TAM language directory: $DIR"
     FileList="/usr/share/telefon/tam-$DIR.html /usr/share/telefon/fax-$DIR.html /usr/share/telefon/tam-$DIR.txt /usr/share/telefon/fax-$DIR.txt"
     for Langufile in $FileList; do
       rm -f "${SRC}/$Langufile" && echo2 "    removed: $Langufile"
     done
    fi
   done
fi
#set default database link if de is not avalabel
if ! [ -f "${SRC}/etc/htmltext_de.db" ] ; then
    [ -L "${SRC}/etc/htmltext.db" ] && rm -fd -R "${SRC}/etc/htmltext.db"
    ln -s /etc/htmltext_$FORCE_LANGUAGE.db  "${SRC}/etc/htmltext.db"
fi
exit 0
