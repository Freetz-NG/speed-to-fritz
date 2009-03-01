#!/bin/bash
echo "----------------------------------------------------------------------------------------------"
export HOMEDIR="`pwd`"
sed -i -e 's/#.*//' "$HOMEDIR/replacelink.lst"
declare -a lines
OIFS="$IFS"
IFS=$'\n'
set -f   # cf. help set
lines=( $(< "$HOMEDIR/replacelink.lst" ) )
set +f
IFS="$OIFS"
#echo "Anzahl: ${#lines[@]}"
#printf "%s\n" "${lines[@]}" | nl
#echo "--------------"
rm -f "$HOMEDIR/replaceerror.log"
for ((i=0; i < "${#lines[@]}"; i++)); do 
   ii=$i; ((i++));
   #echo "indexed:${lines[${ii}]}"
   #echo "indexed:${lines[${i}]}"
    sed -i -e "s|${lines[${ii}]}|${lines[${i}]}|" "$HOMEDIR/Config.in"
    grep -q "${lines[${i}]}" "$HOMEDIR/Config.in" || echo "Line ${i}, '${lines[${i}]}' Error not replaced!" >> "$HOMEDIR/replaceerror.log"
done
#less -p '\$\(< file\)'
[ -f "$HOMEDIR/replaceerror.log" ] && cat "$HOMEDIR/replaceerror.log" | more
echo "----------------------------------------------------------------------------------------------"
echo "done"
sleep 2