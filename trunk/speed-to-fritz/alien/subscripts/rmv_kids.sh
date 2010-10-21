#!/bin/bash
 . $include_modpatch
for DIR in ${OEM}; do
    HTML="$DIR/html"
    DSTI="usr/www/$HTML/de"
    if [ -d "$1"/${DSTI} ] ; then
#-------------------------------------------------------------------------------------------------------
 if [ -f "$1"/$DSTI/menus/menu2.inc ]; then
	echo2 "  -- removing lines from:"
	echo2 "      $DSTI/menus/menu2.inc"
	sed -i -e "/^.*Kindersicherung.*$/d" "$1"/$DSTI/menus/menu2.inc
 fi
 if [ -f "$1"/$DSTI/menus/menu2_internet.inc ]; then
	echo2 "      $DSTI/menus/menu2_internet.inc"
	sed -i -e "/^.*Kindersicherung.*$/d" "$1"/$DSTI/menus/menu2_internet.inc
 fi
	for EXT in frm html js; do
		echo2 "      $DSTI/internet/internet.$EXT"
		sed -i -e "s/'userlist'/'inetstat'/g"  "$1"/$DSTI/internet/internet.$EXT
	done
 if [ -f "$1"/$DSTI/internet/inetstat.js ]; then
	echo2 "      $DSTI/internet/inetstat.js"
	sed -i -e "/^.*userlist.*$/d" "$1"/$DSTI/internet/inetstat.js
 fi
 if [ -f "$1"/$DSTI/menus/menu2_homehome.html ]; then
	echo2 "      $DSTI/menus/menu2_internet.html"
	sed -i -e "/^<li class=.<? echo .var:class7 ?>.>/d" "$1"/$DSTI/menus/menu2_internet.html
	sed -i -e "/^.*user.*$/d" "$1"/$DSTI/menus/menu2_internet.html
	echo2 "      $DSTI/menus/menu2_homehome.html"
	sed -i -e "/^.* userlist .*$/,/^.*'userlist'.*$/d" "$1"/$DSTI/menus/menu2_homehome.html
	sed -i -e "/^.*LSubitem.*$/{N;/^.*LSubitem.*\n. ?>*$/d}" "$1"/$DSTI/menus/menu2_homehome.html
 fi
 if [ -f "$1"/$DSTI/help/home.inc ]; then
	echo2 "      $DSTI/help/home.inc"
	sed -i -e "/^.*Kindersicherung.*$/d" "$1"/$DSTI/help/home.inc
	echo2 "      $DSTI/help/home.html"
	sed -i -e "/^.*hilfe_kindersicherung.*$/d" "$1"/$DSTI/help/home.html
 fi
 echo2 "  -- removing files:"
 for FFILE in `ls "$1"/$DSTI/help/hilfe_kindersicherung_*.html` ; do 
	FILE="${FFILE##*/}"
	[ -f "$1"/$DSTI/help/${FILE} ] && rm -f "$1"/$DSTI/help/${FILE} && echo2 "      $DSTI/help/${FILE}"
 done
 for EXT in hrml js frm ; do 
		FFILE="$1/$DSTI/internet/pp_user.$EXT"
		FILE="${FFILE##*/}"
		[ -f "$1"/$DSTI/internet/${FILE} ] && rm -f "$1"/$DSTI/internet/${FILE} && echo2 "      $DSTI/internet/${FILE}"

		FFILE="$1/$DSTI/internet/userlist.$EXT"
		FILE="${FFILE##*/}"
		[ -f "$1"/$DSTI/internet/${FILE} ] && rm -f "$1"/$DSTI/internet/${FILE} && echo2 "      $DSTI/internet/${FILE}"

		FFILE="$1/$DSTI/internet/.$EXT"
		FILE="${FFILE##*/}"
		[ -f "$1"/$DSTI/internet/${FILE} ] && rm -f "$1"/$DSTI/internet/${FILE} && echo2 "      $DSTI/internet/${FILE}"

		FFILE="$1/$DSTI/home/userlist.$EXT"
		FILE="${FFILE##*/}"
		[ -f "$1"/$DSTI/home/${FILE} ] && rm -f "$1"/$DSTI/home/${FILE} && echo2 "      $DSTI/home/${FILE}"

		FFILE="$1/$DSTI/home/useradd2.$EXT"
		FILE="${FFILE##*/}" 
		[ -f "$1"/$DSTI/home/${FILE} ] && rm -f "$1"/$DSTI/home/${FILE} && echo2 "      $DSTI/home/${FILE}"
 done
#-------------------------------------------------------------------------------------------------------
    fi
done
	echo2 "  -- removing directory:"
	echo2 "      /usr/www/kids"
	rm -rf "$1"/usr/www/kids

	sed -i -e "/mknod .var.flash.user.cfg c/,/mknod .var.flash.userstat.cfg c/d" "$1/etc/init.d/rc.S"
exit 0
