#!/bin/bash
# include modpatch function
. ${include_modpatch}
if [ "${ADD_VDSL_PROFILE}" = "y" ]; then
 echo "-- adding vdsl profile pages ..."
 DIRI="$(find ${1}/usr/www/ \( -name adsl.html -o -name dslsnrset.html -o -name atm.html -o -name bits.html -o -name overview.html -o -name feedback.html -o -name vdsl_profile.html \) -type f -print)"
 #-----------------------------------------------------------------
 for file_n in $DIRI; do
    [ "${file_n##*/}" == "bits.html" ] &&\
    sed -i -e 's|<li class="tabs_on"><div class="activtab">.*</div></li>|<li class="tabs_on"><div class="activtab">Vdsl Profile</div></li>|g' "$file_n"
  sed -i -e '/uiDoBitsPage()/a\
<li><a href="javascript:uiDoVdslProfilePage()">Vdsl Profile</a></li>'  "$file_n"
  sed -i -e "/uiDoFeedbackPage()/d" "$file_n"
    grep -q "Vdsl Profile" "$file_n" && echo2 "    added tab 'Vdsl Profile' in file:${file_n##*/}"
 done 

cat >> "${1}/usr/www/${OEMLINK}/html/de/internet/awatch.js" << EOF
function uiDoVdslProfilePage() {
jslGoTo("internet", "vdsl_profile");
}
EOF
 if ! [ -f "${1}/usr/www/${OEMLINK}/html/de/internet/vdsl_profile.html" ]; then
  for file_n in vdsl_profile.html vdsl_profile.js vdsl_profile.frm; do
   [ -f "${1}/usr/www/${OEMLINK}/html/de/internet/$file_n" ] && rm -f "${1}/usr/www/${OEMLINK}/html/de/internet/$file_n"
  done
  touch "${1}/usr/www/${OEMLINK}/html/de/internet/vdsl_profile.frm"
  USRWWW="usr/www/${OEMLINK}/html/de"
  [ "$avm_Lang" = "de" ] && modpatch "${1}/${USRWWW}" "$P_DIR/add_vdslprofile_de.patch"
  [ "$avm_Lang" != "de" ] && modpatch "${1}/${USRWWW}" "$P_DIR/add_vdslprofile_en.patch"
 fi

sed -i -e '/Trellis="on"/i\
local profil_conf=`ctlmgr_ctl r sar settings/UsNoiseBits`\
local trellis_conf=`ctlmgr_ctl r sar settings/RFI_mode`\
' "${1}/etc/init.d/rc.vdsl.sh"

sed -i -e 's|#Profile="30A"|[ $profil_conf == "1" ] \&\& Profile="30A"|' "${1}/etc/init.d/rc.vdsl.sh"
sed -i -e 's|#Trellis="off"|[ $trellis_conf == "1" ] \&\& Trellis="off"|' "${1}/etc/init.d/rc.vdsl.sh"
fi

exit 0

