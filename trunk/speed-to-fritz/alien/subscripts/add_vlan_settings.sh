#!/bin/bash
# include modpatch function
. ${include_modpatch}
 echo "-- Adding vlan settings ..."
# remove WDS autodedect courses problems 
[ -f "${SRC}/usr/www/${OEMLINK}/html/de/wlan/wds.js" ] && sed -i -e '/uiPostAutodetect/d'  "${SRC}/usr/www/${OEMLINK}/html/de/wlan/wds.js"
[ -f "${SRC}/usr/www/${OEMLINK}/html/de/wlan/wds.frm" ] && sed -i -e '/uiPostAutodetect/d'  "${SRC}/usr/www/${OEMLINK}/html/de/wlan/wds.frm"
# vlan settings
echo '<!--input type="hidden" name="sar:settings/vlan_encap" value="<? query sar:settings/vlan_encap ?>" id="uiPostVlanAktiv" disabled-->' >> "${SRC}/usr/www/${OEMLINK}/html/de/first/first_ISP_3.frm"
echo '<input type="hidden" name="sar:settings/vlan_id" value="<? query sar:settings/vlan_id ?>" id="uiPostVlanId" disabled>' >> "${SRC}/usr/www/${OEMLINK}/html/de/first/first_ISP_3.frm"
[ -f "${SRC}/usr/www/${OEMLINK}/html/de/internet/dslsnrset.frm" ] && sed -i -e '/uiPostAnnex/a\
<Input type="hidden" name="sar:settings/DSLMode" value="<? query sar:settings/DSLMode ?>" id="uiPostDSLMode" disabled>' "${SRC}/usr/www/${OEMLINK}/html/de/internet/dslsnrset.frm"
[ -f "${SRC}/usr/www/${OEMLINK}/html/de/internet/internet_expert.frm" ] && sed -i -e '/uiPostSarDns1/a\
<!--input type="hidden" name="sar:settings/vlan_encap" value="<? query sar:settings/vlan_encap ?>" id="uiPostVlanAktiv" disabled>\
<input type="hidden" name="sar:settings/vlan_id" value="<? query sar:settings/vlan_id ?>" id="uiPostVlanId" disabled-->' "${SRC}/usr/www/${OEMLINK}/html/de/internet/internet_expert.frm"
[ -f "${SRC}/usr/www/${OEMLINK}/html/de/internet/kabelmodem.js" ] && sed -i -e '/InitSpeed();/a\
InitVlan();' "${SRC}/usr/www/${OEMLINK}/html/de/internet/kabelmodem.js"
exit 0

