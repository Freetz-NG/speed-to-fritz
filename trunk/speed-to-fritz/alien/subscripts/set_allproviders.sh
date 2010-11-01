#!/bin/bash
# include modpatch function
. ${include_modpatch}
echo "-- set all provoders ..."
DIRI="$(find ${1}/usr/www/ \( -name authform.html -o -name sip1.js -o -name siplist.js \) -type f -print)"
for file_n in $DIRI; do
    ##echo2 "      ${file_n}"
    sed -i -e 's/$var:allprovider 1/ 1 1/' "$file_n"
##    sed -i -e 's/$var:OEM avme/avme avme/' "$file_n"
    sed -i -e "s/<? setvariable var:showtcom 0 ?>/<? setvariable var:showtcom 1 ?>/g" "$file_n"
    sed -i -e "s/<? setvariable var:allprovider 0 ?>/<? setvariable var:allprovider 1 ?>/g" "$file_n"
    grep -q "setvariable var:showtcom 1" "$file_n" && echo2 "  show tcom set in file: ${file_n##*/}"
    grep -q "setvariable var:allprovider 1" "$file_n" && echo2 "  allproviders set in file: ${file_n##*/}"
done
exit 0
