#!/bin/bash
 . ${include_modpatch}
 # include modpatch function
echo2 "  -- removing system help to reduce image size ..."
for DIR in ${OEMLIST}; do
# if [ "$DIR" = "avme" ] ; then
#  export HTML="$DIR/$avm_Lang/html"
# else
  export HTML="$DIR/html"
# fi
    DSTI="${1}"/usr/www/$HTML/de
    DSTX="${1}"/usr/www/$DIR/help
    if [ -d ${DSTX} ] ; then
	echo "removing files $DSTX/hilfe* $DSTX/rechtliche*"
	rm -f $DSTX/hilfe* $DSTX/rechtliche*
	[ -f ${DSTX}/home.html ] && sed -i -e 's/local g_txt/local g_txt_removed/' ${DSTX}/home.html
    else
    if [ -d ${DSTI} ] ; then
#------------------------------------------------------------------------------
for DIR in first fon fon_config home internet menus system tools wlan; do
if [ -d "${DSTI}/${DIR}" ]; then
	for FILE in `ls ${DSTI}/${DIR}/|grep '\.html$'`; do
#	for FILE in `ls ${DSTI}/${DIR}/*.html`; do
	  HTMLFILE="${FILE##*/}"
		if `cat ${DSTI}/${DIR}/${HTMLFILE} | grep -q 'onclick="uiDoHelp()"'` ; then
			echo2 "  -- removing help button from: /usr/www/$HTML/de/${DIR}/${HTMLFILE}"
			sed -i -e "/onclick=\"uiDoHelp()\"/d" "${DSTI}/${DIR}/${HTMLFILE}"
		fi
	done
fi
done

for FILE in `ls ${DSTI}/menus/menu2_*.html`; do
	MENUFILE="${FILE##*/}"
	if `cat ${DSTI}/menus/${MENUFILE} | grep -q 'menuHilfe'` ; then
		echo2 "  -- removing help item from: /usr/www/$HTML/de/menus/${MENUFILE}"
		sed -i -e "/.*menuHilfe.*/d" ${DSTI}/menus/${MENUFILE}
	fi
done
#echo2 "  -- emptying directory:"
for FILE in `ls ${DSTI}/help`; do
	if [ ${FILE} != modinfo.html ] && [ ${FILE} != popup.html ] && [ ${FILE} != rback.html ]; then
		echo2 "  -- delete: /usr/www/$HTML/de/help/${FILE}"
		rm -f ${DSTI}/help/${FILE}
	fi
done

sed -i -e "/.*jslGoTo('help','home').*/d" ${DSTI}/help/rback.html
#------------------------------------------------------------------------------
    fi
    fi
done

exit 0
