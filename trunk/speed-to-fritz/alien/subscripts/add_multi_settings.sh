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
# show settings (annexA/B) tub
#-----------------------------------------------------------------
for file_n in adsl.html atm.html bits.html overview.html; do
   if [ -f "${SRC}/usr/www/${OEMLINK}/html/de/internet/$file_n" ]; then 
    sed -i -e "s|<? if neq \$var:Annex A|<? if neq 0 1|" "${SRC}/usr/www/${OEMLINK}/html/de/internet/$file_n"
   fi
done
##---------------------------------------------------------------
# include, order of includes may count
. $sh_DIR/add_multicountry.sh
. $sh_DIR/add_multiannex.sh
. $sh_DIR/add_multilingual.sh

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
