#!/bin/bash
echo "!-------------------------------------------------------------------------!"
hw=
while ! [ "$hw" ]; do
 KEY=
 while [ "$KEY" != "y" ]; do
  echo
  echo -n "   MT-D (y/n)? "; read -n 1 -s YESNO; echo
  [ "$YESNO" = "y" ] || [ "$YESNO" = "n" ] &&  KEY="y" || echo "wrong key!"
 done
 if [ "$YESNO" = "y" ]; then 
    hw="01.01"
 else
    KEY=
    while [ "$KEY" != "y" ]; do
	echo
	echo -n "   MT-F (y/n)? "; read -n 1 -s YESNO; echo
	[ "$YESNO" = "y" ] || [ "$YESNO" = "n" ] &&  KEY="y" || echo "wrong key!"
    done
    if [ "$YESNO" = "y" ]; then
	hw="03.01"
    else
	KEY=
	while [ "$KEY" != "y" ]; do
	    echo
	    echo -n "   C3 (y/n)? "; read -n 1 -s YESNO; echo
	    [ "$YESNO" = "y" ] || [ "$YESNO" = "n" ] &&  KEY="y" || echo "wrong key!"
	done
	[ "$YESNO" = "y" ] && hw="04.01"
    fi
 fi
done
KEY=
while [ "$KEY" != "y" ]; do
	    echo
	    echo -n "   Voreistellung (02.45,avm,de,049,75.04.91.19965) verwenden (y/n)? "; read -n 1 -s YESNO; echo
	    [ "$YESNO" = "y" ] || [ "$YESNO" = "n" ] &&  KEY="y" || echo "wrong key!"
done
if [ "$YESNO" = "y" ]; then
    sw=02.45
    oem=avm
    lang=de
    country=049
    fw=75.04.91.19965
else
    IFS=','
    echo -e "Bitte fuenf Parameter, getrennt durch Komma eingeben:\n\
02.45, Softwareversion derzeit am MT in Verwendung\n\
avm, irgend ein gueltiger OEM zB: avme, avm, 1und1,...\n\
de, Sprache zB: de, en\n\
049, Landeskennug\n\
75.04.91.19965, Firmwaeversion\n\
Beispiel: 02.45,avm,de,049,75.04.91.19965\n"
    read sw oem country fw
fi
echo -e "Eingabe war: $sw $oem $country $fw\n\
Firmware wird gesucht ...\n"
#hw="01.01" #Fuer das MT-D
#hw="03.01" #Fuer das MT-F
#hw="04.01" #Fuer das C3
lang=de
macaddr=0...
dladr="http://update.avm.de/cgi-bin/cati?hw=${hw}&sw=${sw}&oem=${oem}&lang=${lang}&country=${country}&fw=${fw}&macaddr=${macaddr}"
#echo $dladr
wget -nv $dladr --output-document=.url
URL=`cat ./.url`
#echo $URL
if [ "NO UPDATE FOUND" != "$URL" ]; then
    URL=`echo $URL | tr -d 'URL=' | tr -d '"'`
    IMG_REQ="${URL##*/}"
    ! [ -f ./"$IMG_REQ" ] && wget $URL
    with_new_ext=${IMG_REQ%.*}.image
    #echo $IMG_REQ
    #echo $with_new_ext
    mv ./$IMG_REQ ./$with_new_ext
fi
rm ./.url
sleep 10
exit 0
