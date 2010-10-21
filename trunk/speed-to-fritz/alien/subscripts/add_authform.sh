#!/bin/bash
# include modpatch function
. ${include_modpatch}
if [ "${RPL_AUTHFORM_WITH_81}" == "y" ]; then
 echo "-- replace authform ..."
 USRWWW="usr/www/${OEMLINK}/html/de"
 rm -f "$SRC/${USRWWW}/internet/authform.js"
 rm -f "$SRC/${USRWWW}/internet/authform.html"
 PatchfileName="add_authform"
 modpatch "$SRC/${USRWWW}" "$P_DIR/${PatchfileName}.patch"
 [ "$avm_Lang" = "de" ] &&  modpatch "$SRC/${USRWWW}" "$P_DIR/${PatchfileName}_de.patch"
fi
OEML="avm" && [ -d "${DST}"/usr/www/avme ] && OEML="avme"
OEML2="avm" && [ -d "${SRC_2}"/usr/www/avme ] && OEML2="avme"
FILELIST=" /html/de/internet/authform.html /html/de/internet/authform.frm /html/de/internet/authform.js"
if [ "${RPL_AUTHFORM_WITH_SR2}" == "y" ]; then  
 for file_n in $FILELIST ; do
     if [ -f "${SRC_2}/usr/www/${OEML}/$file_n" ]; then
      cp -fdrp "${SRC_2}/usr/www/${OEML}/$file_n" "${SRC}/usr/www/${OEMLINK}/$file_n" && echo "-- Copy from 2nd AVM firmware: $file_n"
      sed -i -e s'|{?de.first.first_ISP_..html:5?}|{?g_txt_TestInternetConn?}|' "${SRC}/usr/www/${OEMLINK}/$file_n"
     fi
 done
fi
if [ "${RPL_AUTHFORM_WITH_DST}" == "y" ]; then
 for file_n in $FILELIST ; do
     if [ -f "${DST}/usr/www/${OEML}/$file_n" ]; then
      cp -fdrp "${DST}/usr/www/${OEML}/$file_n" "${SRC}/usr/www/${OEMLINK}/$file_n" && echo "-- Copy from orignal basis firmware: $file_n"
      sed -i -e s'|{?de.first.first_ISP_..html:5?}|{?g_txt_TestInternetConn?}|' "${SRC}/usr/www/${OEMLINK}/$file_n"
     fi
 done
fi

exit 0

