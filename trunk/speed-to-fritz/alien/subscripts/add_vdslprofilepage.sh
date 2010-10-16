#!/bin/bash
# include modpatch function
. ${include_modpatch}
if [ "${ADD_VDSL_PROFILE}" = "y" ]; then
 echo "-- adding vdsl profile pages ..."

  for file_n in atm.html adsl.html bits.html overview.html; do
  sed -i -e '/uiDoSNRPage()/a\
<li><a href="javascript:uiDoVdslProfilePage()">Vdsl Profile</a></li>'  "${SRC}/usr/www/${OEMLINK}/html/de/internet/$file_n"
  done 

cat >> "${SRC}/usr/www/${OEMLINK}/html/de/internet/awatch.js" << EOF
function uiDoVdslProfilePage() {
jslGoTo("internet", "vdsl_profile");
}
EOF
 if ! [ -f "${SRC}/usr/www/${OEMLINK}/html/de/internet/vdsl_profile.html" ]; then
  for file_n in vdsl_profile.html vdsl_profile.js vdsl_profile.frm; do
   [ -f "${SRC}/usr/www/${OEMLINK}/html/de/internet/$file_n" ] && rm -f "${SRC}/usr/www/${OEMLINK}/html/de/internet/$file_n"
  done
  touch "${SRC}/usr/www/${OEMLINK}/html/de/internet/vdsl_profile.frm"
  USRWWW="usr/www/${OEMLINK}/html/de"
  [ "$avm_Lang" = "de" ] && modpatch "${SRC}/${USRWWW}" "$P_DIR/add_vdslprofile_de.patch"
  [ "$avm_Lang" != "de" ] && modpatch "${SRC}/${USRWWW}" "$P_DIR/add_vdslprofile_en.patch"
 fi
fi

sed -i -e '/Trellis="on"/i\
local profil_conf=`ctlmgr_ctl r sar settings/UsNoiseBits`\
local trellis_conf=`ctlmgr_ctl r sar settings/RFI_mode`\
' "${SRC}/etc/init.d/rc.vdsl.sh"

sed -i -e 's|#Profile="30A"|[ $profil_conf == "1" ] \&\& Profile="30A"|' "${SRC}/etc/init.d/rc.vdsl.sh"
sed -i -e 's|#Trellis="off"|[ $trellis_conf == "1" ] \&\& Trellis="off"|' "${SRC}/etc/init.d/rc.vdsl.sh"


exit 0

