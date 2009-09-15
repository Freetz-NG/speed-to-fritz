#!/bin/bash
# include modpatch function
. ${include_modpatch}
if [ "${ADD_VDSL_PROFILE}" = "y" ]; then
 echo "-- Adding vdsl profile pages ..."

#  for file_n in /html/de//internet/feedback.js /html/de/internet/feedback.html /html/de/internet/feedback.frm\
# /html/de/home/feedback.js /html/de/home/feedback.html /html/de/home/feedback.frm; do
#    rm -f "${SRC}/usr/www/${OEMLINK}/$file_n" && echo2 "  Removed file: $file_n"
#  done
  for file_n in atm.html adsl.html bits.html overview.html; do
  sed -i -e '/uiDoSNRPage()/a\
<li><a href="javascript:uiDoVdslProfilePage()">Vdsl Profile</a></li>'  "${SRC}/usr/www/${OEMLINK}/html/de/internet/$file_n"
  sed -i -e 's/uiDoFeedbackPage()/uiDoVdslProfilePage/'  "${SRC}/usr/www/${OEMLINK}/html/de/internet/$file_n"
  done 

cat >> "${SRC}/usr/www/${OEMLINK}/html/de//internet/awatch.js" << EOF
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

sed -i -e '/uiPostAutodetect/d'  "${SRC}/usr/www/${OEMLINK}/html/de/wlan/wds.js"
sed -i -e '/uiPostAutodetect/d'  "${SRC}/usr/www/${OEMLINK}/html/de/wlan/wds.frm"
echo '<!--input type="hidden" name="sar:settings/vlan_encap" value="<? query sar:settings/vlan_encap ?>" id="uiPostVlanAktiv" disabled-->' >> "${SRC}/usr/www/${OEMLINK}/html/de/first/first_ISP_3.frm"
echo '<input type="hidden" name="sar:settings/vlan_id" value="<? query sar:settings/vlan_id ?>" id="uiPostVlanId" disabled>' >> "${SRC}/usr/www/${OEMLINK}/html/de/first/first_ISP_3.frm"

sed -i -e '/uiPostAnnex/a\
<Input type="hidden" name="sar:settings/DSLMode" value="<? query sar:settings/DSLMode ?>" id="uiPostDSLMode" disabled>' "${SRC}/usr/www/${OEMLINK}/html/de/internet/dslsnrset.frm"
sed -i -e '/uiPostSarDns1/a\
<!--input type="hidden" name="sar:settings/vlan_encap" value="<? query sar:settings/vlan_encap ?>" id="uiPostVlanAktiv" disabled>\
<input type="hidden" name="sar:settings/vlan_id" value="<? query sar:settings/vlan_id ?>" id="uiPostVlanId" disabled-->' "${SRC}/usr/www/${OEMLINK}/html/de/internet/internet_expert.frm"
sed -i -e '/InitSpeed();/a\
InitVlan();' "${SRC}/usr/www/${OEMLINK}/html/de/internet/kabelmodem.js"
exit 0

