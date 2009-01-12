#!/bin/bash
 . ${include_modpatch}
 # include modpatch function
echo2 "-- Removing system help to reduce image size ..."
for DIR in ${OEMLIST}; do
 if [ "$DIR" = "avme" ] ; then
  export HTML="$DIR/$avm_Lang/html"
 else
  export HTML="$DIR/html"
 fi
    DSTI="${1}"/usr/www/$HTML/${avm_Lang}
    if [ -d ${DSTI} ] ; then
#------------------------------------------------------------------------------
for DIR in first fon fon_config home internet menus system tools wlan; do
if [ -d "${DSTI}/${DIR}" ]; then

	for FILE in `ls ${DSTI}/${DIR}/*.html`; do
	  HTMLFILE="${FILE##*/}"
		if `cat ${DSTI}/${DIR}/${HTMLFILE} | grep -q 'onclick="uiDoHelp()"'` ; then
			echo2 "-- Removing help button from: /usr/www/$HTML/${avm_Lang}/${DIR}/${HTMLFILE}"
			sed -i -e "/onclick=\"uiDoHelp()\"/d" "${DSTI}/${DIR}/${HTMLFILE}"
		fi
	done
fi
done

for FILE in `ls ${DSTI}/menus/menu2_*.html`; do
	MENUFILE="${FILE##*/}"
	if `cat ${DSTI}/menus/${MENUFILE} | grep -q 'menuHilfe'` ; then
		echo2 "-- Removing help item from: /usr/www/$HTML/${avm_Lang}/menus/${MENUFILE}"
		sed -i -e "/.*menuHilfe.*/d" ${DSTI}/menus/${MENUFILE}
	fi
done
#echo2 "-- Emptying directory:"
for FILE in `ls ${DSTI}/help`; do
	if [ ${FILE} != modinfo.html ] && [ ${FILE} != popup.html ] && [ ${FILE} != rback.html ]; then
		echo2 "-- Delite: /usr/www/$HTML/${avm_Lang}/help/${FILE}"
		rm -f ${DSTI}/help/${FILE}
	fi
done

sed -i -e "/.*jslGoTo('help','home').*/d" ${DSTI}/help/rback.html
#------------------------------------------------------------------------------
    fi
done

exit 0

