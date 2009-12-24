#!/bin/bash
 . $include_modpatch
for DIR in ${OEMLIST}; do
    HTML="$DIR/html"
    DSTI="usr/www/$HTML/de"
    if [ -d "$1"/${DSTI} ] ; then
#-------------------------------------------------------------------------------------------------------
# if `cat "$1/$DSTI/menus/menu2_internet.html" | grep -q 'userlist'` ; then
	echo2 "   -- Removing lines from:"
	echo2 "      $DSTI/menus/menu2.inc"
	sed -i -e "/^.*Kindersicherung.*$/d" "$1"/$DSTI/menus/menu2.inc
	echo2 "      $DSTI/menus/menu2_internet.inc"
	sed -i -e "/^.*Kindersicherung.*$/d" "$1"/$DSTI/menus/menu2_internet.inc
 
	for EXT in frm html js; do
		echo2 "      $DSTI/internet/internet.$EXT"
		sed -i -e "s/'userlist'/'inetstat'/g"  "$1"/$DSTI/internet/internet.$EXT
	done

	echo2 "      $DSTI/internet/inetstat.js"
	sed -i -e "/^.*userlist.*$/d" "$1"/$DSTI/internet/inetstat.js

	echo2 "      $DSTI/menus/menu2_internet.html"
	sed -i -e "/^.*class7 'LSubitem'.*$/,/^.*useradd2.*$/d"  "$1"/$DSTI/menus/menu2_internet.html
	sed -i -e "/^.*'userlist'.*$/d" "$1"/$DSTI/menus/menu2_internet.html
	sed -i -e "s/class7/class4/"  "$1"/$DSTI/menus/menu2_internet.html
	#sed -i -e "/^.*var:class7.*$/d" "$1"/$DSTI/menus/menu2_internet.html
	#sed -i -e "/^<? if eq <? .* ?> pppoe \`$/{N;/^<? if eq <? .* ?> pppoe \`\n. ?>*$/d}" "$1"/$DSTI/menus/menu2_internet.html
	#sed -i -e "/^.*var:class5 'LSubitem'.*$/i <? if eq <? query connection0:settings/type ?> pppoe \`\n<? if eq \$var:pagename internet \`<? setvariable var:class4 'LSubitemaktiv' ?>\` ?>\n\` ?>" "$1"/$DSTI/menus/menu2_internet.html

	echo2 "      $DSTI/menus/menu2_homehome.html"
	sed -i -e "/^.* userlist .*$/,/^.*'userlist'.*$/d" "$1"/$DSTI/menus/menu2_homehome.html
	sed -i -e "/^.*LSubitem.*$/{N;/^.*LSubitem.*\n. ?>*$/d}" "$1"/$DSTI/menus/menu2_homehome.html

	echo2 "      $DSTI/help/home.inc"
	sed -i -e "/^.*Kindersicherung.*$/d" "$1"/$DSTI/help/home.inc
	echo2 "      $DSTI/help/home.html"
	sed -i -e "/^.*hilfe_kindersicherung.*$/d" "$1"/$DSTI/help/home.html

	echo2 "   -- Removing files:"

	for FFILE in `ls "$1"/$DSTI/help/hilfe_kindersicherung_*.html` ; do 
		FILE="${FFILE##*/}" 
		echo2 "      $DSTI/help/${FILE}"
		rm -f "$1"/$DSTI/help/${FILE}
	done

	for FFILE in `ls "$1"/$DSTI/internet/pp_user.*` ; do 
		FILE="${FFILE##*/}" 
		echo2 "      $DSTI/internet/${FILE}"
		rm -f "$1"/$DSTI/internet/${FILE}
	done

	for FFILE in `ls "$1"/$DSTI/internet/user*.*` ; do 
		FILE="${FFILE##*/}" 
		echo2 "      $DSTI/internet/${FILE}"
		rm -f "$1"/$DSTI/internet/${FILE}
	done

	for FFILE in `ls "$1"/$DSTI/home/user*.*` ; do 
		FILE="${FFILE##*/}" 
		echo2 "      $DSTI/home/${FILE}"
		rm -f "$1"/$DSTI/home/${FILE}
	done

#fi
#-------------------------------------------------------------------------------------------------------
    fi
done
	echo2 "   -- Removing directory:"
	echo2 "      /usr/www/kids"
	rm -rf "$1"/usr/www/kids

	sed -i -e "/mknod .var.flash.user.cfg c/,/mknod .var.flash.userstat.cfg c/d" "$1/etc/init.d/rc.S"
exit 0
