#!/bin/bash
#echo "----------------------------------------------------------------------------------------------"
export HOMEDIR="`pwd`"
cp -f $HOMEDIR/Config.in $HOMEDIR/rpllist.1
#sed -i -e 's/#.*//' -e '/^$/ d' -e "/TYPE/,/FILEENDE/{/.*/d}" "$HOMEDIR/rpllist.1"
# format text
sed -i -e '/### FIRMWARE_CONFIG_ENDE ###/,/### FILE_ENDE ###/ {/.*/d}' -e 's/^.*default//' -e 's/^.*config //' -e 's/^ //' -e '/string/d' -e '/mainmenu/d' -e '/comment/d' -e 's/#.*//' -e 's/^ .//' -e '/^$/ d' "$HOMEDIR/rpllist.1"
#remonve withe space before ende of line
sed -i -e 's/[ ^I]*$//'  "$HOMEDIR/rpllist.1"
cp $HOMEDIR/rpllist.1 $HOMEDIR/rpllist.2
rm -f $HOMEDIR/replacelink.lst
echo "#Only edit every second line to replace a link! Start 'import_link.sh' to insert the changes into Config.in'" > "$HOMEDIR/replacelink.lst"
echo "#---" >> "$HOMEDIR/replacelink.lst"
touch $HOMEDIR/replacelink.lst
sed -i -e 's|="|\n|g' "$HOMEDIR/rpllist.2"
sed -i -e 's|"||g' "$HOMEDIR/rpllist.2"
OIFS="$IFS"
IFS=$'\n'
set -f   # cf. help set
lines=( $(< "$HOMEDIR/rpllist.2" ) )
set +f
IFS="$OIFS"
#echo "Anzahl: ${#lines[@]}"
#printf "%s\n" "${lines[@]}" | nl
#echo "--------------"
for ((i=0; i < "${#lines[@]}"; i++)); do 
    echo "${lines[${i}]}" >> "$HOMEDIR/replacelink.lst"
    echo "${lines[${i}]}" >> "$HOMEDIR/replacelink.lst"
done
rm -f $HOMEDIR/rpllist.1
rm -f $HOMEDIR/rpllist.2
#echo "----------------------------------------------------------------------------------------------"
#echo "done"
#sleep 2
exit 0
