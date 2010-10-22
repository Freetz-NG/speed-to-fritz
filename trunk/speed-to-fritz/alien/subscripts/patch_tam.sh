#!/bin/bash
 . $include_modpatch
for DIR in ${OEMLINKS}; do
 if [ "$DIR" = "avme" ] ; then
  html="$avm_Lang/html"
 else
  html="html"
 fi
    DSTI="${1}"/usr/www/${DIR}/${html}/${avm_Lang}/fon/tamlist.js
    if [ -f ${DSTI} ] ; then
     if ! `cat ${DSTI} | grep -q 'jslEnable("uiPostDisplay"+nr);'` ; then
 echo "-- applying bug fix remove tam  ..."
 echo2 "  -- patching file:"
 echo2 "      /usr/www/${DIR}/${html}/${avm_Lang}/fon/tamlist.js"
     sed -i -e '/jslSetValue("uiPostDisplay"+nr, "0");/a\
jslEnable("uiPostDisplay"+nr);' "${DSTI}"
    fi
   fi
done

exit 0
