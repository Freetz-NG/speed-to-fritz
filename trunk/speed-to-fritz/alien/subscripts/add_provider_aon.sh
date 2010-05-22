#!/bin/bash
# include modpatch function
. ${include_modpatch}
FILELIST="/html/de/first/provider.js /html/de/internet/authform.html /html/de/internet/authform.frm"

for FILE in $FILELIST; do
  if [ -f "${SRC}/usr/www/${OEMLINK}/$FILE" ]; then 
    if  ! [ grep -q "AON" "${SRC}/usr/www/${OEMLINK}/$FILE" ];then
	sed -i -e '/<? if neq $var:OEM freenet `/i\
if(szProvider== "AON") return szProvider;' "${SRC}/usr/www/${OEMLINK}/$FILE"
	sed -i -e '/return otherprovider;/i\
if (id == "AON") return "aon";' "${SRC}/usr/www/${OEMLINK}/$FILE"
	sed -i -e '/<option value="Inode">/i\
<option value="AON">AON Telekom Austria</option>' "${SRC}/usr/www/${OEMLINK}/$FILE"
	sed -i -e '/tcom_targetarch/a\
<input type="hidden" name="connection0:settings\/aontv_arch" value="<? query connection0:settings\/aontv_arch ?>" id="uiPostAontvArch">' "${SRC}/usr/www/${OEMLINK}/$FILE"
    grep -q "aontv_arch" "${SRC}/usr/www/${OEMLINK}/$FILE" && echo "-- Added provider AON-TV to: $FILE" 
    grep -q "AON" "${SRC}/usr/www/${OEMLINK}/$FILE" && echo "-- Added provider AON to: $FILE" 
    fi
  fi
done
if  ! [ grep -q "uiDoReboot()" "${SRC}/usr/www/${OEMLINK}/html/de/internet/authform.js" ];then
cat <<EOSF >>"${SRC}/usr/www/${OEMLINK}/html/de/internet/authform.js"
function uiDoReboot() {
document.getElementById("uiPostVarName").name = "logic:command/reboot";
jslSetValue("uiPostVarName", "../gateway/commands/saveconfig.html");
var oldGetPage = jslGetValue("uiPostGetPage");
jslSetValue("uiPostGetPage", "../html/reboot.html");
//document.getElementById("uiPostForm").submit();
jslFormSubmit("uiPostForm");
}
EOSF
fi
if  ! [ grep -q "function OnAon()" "${SRC}/usr/www/${OEMLINK}/html/de/internet/authform.js" ];then
cat <<EOF >>"${SRC}/usr/www/${OEMLINK}/html/de/internet/authform.frm"
<input type="hidden" id="uiPostVarName" name="">
EOF
cat <<EOSF >>"${SRC}/usr/www/${OEMLINK}/html/de/internet/authform.js"
function OnAon() {
jslDisplay("UserPrefix", false);
jslDisplay("UserPostfix", false);
SetSpanText("LabelName", g_txtAonName);
SetSpanText("LabelKennwort", g_txtAonKennwort);
SetSpanText("LabelKennwort2", g_txtAonConfirmation);
jslSetChecked("uiViewTcomTargetarch", jslGetValue("uiPostAontvArch") == "1");
SetSpanText("uiViewIpTvTxt","AON-TV");
if (jslGetValue("uiPostAontvArch") == "1")
{
jslSetValue("uiEncaps", "dslencap_ether");
jslSetValue("uiPostVPI", "8");
jslSetValue("uiPostVCI", "36");
}
else
{
jslSetValue("uiEncaps", "dslencap_pppoa");
jslSetValue("uiPostVPI", "8");
jslSetValue("uiPostVCI", "48");
}
jslEnable("uiPostVPI");
jslEnable("uiPostVCI");
}
EOSF
sed -i -e '/case "TNamibiaWimax": OnTNamibiaWimax(); break;/a\
case "AON": OnAon();break;' "${SRC}/usr/www/${OEMLINK}/html/de/internet/authform.js"
sed -i -e "s!jslDisplay(.uiTcomTargetArchOption.,id == .TOnline.);!jslDisplay('uiTcomTargetArchOption',id == \"TOnline\"||id==\"AON\");!" "${SRC}/usr/www/${OEMLINK}/html/de/internet/authform.js"
sed -i -e '/} else if (ProviderId=="O2") {/i\
} else if (ProviderId=="AON") {\
OnAon();' "${SRC}/usr/www/${OEMLINK}/html/de/internet/authform.js"
sed -i -e '/else if(provider == "congstar"){/i\
else if(provider == "AON"){\
jslSetValue("uiPostAontvArch",jslGetChecked("uiViewTcomTargetarch")?"1":"0");\
}' "${SRC}/usr/www/${OEMLINK}/html/de/internet/authform.js"
sed -i -e '/if (provider != "TNamibiaWimax")/i\
if (provider != "AON")\
jslSetValue("uiPostAontvArch","0");' "${SRC}/usr/www/${OEMLINK}/html/de/internet/authform.js"
sed -i -e '/var g_txtSonstName = "{?txtUsername_js?} ";/i\
var g_txtAonName = "Teilnehmererkennung";\
var g_txtAonKennwort = "Persnliches Kennwort";\
var g_txtAonConfirmation = "{?txtConfirmPassword?}";' "${SRC}/usr/www/${OEMLINK}/html/de/internet/authform.js"
fi
exit 0
