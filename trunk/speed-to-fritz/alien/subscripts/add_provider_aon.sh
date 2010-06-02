#!/bin/bash
# include modpatch function
. ${include_modpatch}
FILELIST="/html/de/first/provider.js /html/de/internet/authform.html /html/de/internet/authform.frm /html/de/first/first_ISP_3.frm"
for FILE in $FILELIST; do
XFILE="${SRC}/usr/www/${OEMLINK}/$FILE"
  if [ -f "$XFILE" ]; then
    grep -q "uiPostAontvArch" "$XFILE" || sed -i -e '/tcom_targetarch/a\
<input type="hidden" name="connection0:settings\/aontv_arch" value="<? query connection0:settings\/aontv_arch ?>" id="uiPostAontvArch">' "$XFILE"
    grep -q "szProvider== .AON." "$XFILE" || sed -i -e '/if neq .var:OEM freenet/i\
if(szProvider== "AON") return szProvider;' "$XFILE"
    grep -q "id == .AON." "$XFILE" || sed -i -e '/return otherprovider;/i\
if (id == "AON") return "aon";' "$XFILE"
    grep -q "value=.AON" "$XFILE" || sed -i -e '/<option value="Inode">/i\
<option value="AON">AON</option>' "$XFILE"
    grep -q "aontv_arch" "$XFILE" && echo "-- Found provider AON-TV in: $FILE"
    grep -q "AON" "$XFILE" && echo "-- Found provider AON in: $FILE"
  fi
done
grep -q "function uiDoReboot()" "${SRC}/usr/www/${OEMLINK}/html/de/internet/authform.js" ||\
cat <<EOSF1 >>"${SRC}/usr/www/${OEMLINK}/html/de/internet/authform.js"
function uiDoReboot() {
document.getElementById("uiPostVarName").name = "logic:command/reboot";
jslSetValue("uiPostVarName", "../gateway/commands/saveconfig.html");
var oldGetPage = jslGetValue("uiPostGetPage");
jslSetValue("uiPostGetPage", "../html/reboot.html");
//document.getElementById("uiPostForm").submit();
jslFormSubmit("uiPostForm");
}
EOSF1
grep -q "uiPostVarName" "${SRC}/usr/www/${OEMLINK}/html/de/internet/authform.frm" ||\
cat <<EOF2 >>"${SRC}/usr/www/${OEMLINK}/html/de/internet/authform.frm"
<input type="hidden" id="uiPostVarName" name="">
EOF2
grep -q "OnAon" "${SRC}/usr/www/${OEMLINK}/html/de/internet/authform.js" ||\
cat <<EOSF3 >>"${SRC}/usr/www/${OEMLINK}/html/de/internet/authform.js"
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
jslSetChecked("uiViewDslPppPPPoE", true);
jslSetValue("uiPostVPI", "8");
jslSetValue("uiPostVCI", "36");
}
else
{
jslSetValue("uiEncaps", "dslencap_pppoa");
jslSetChecked("uiViewDslPppPPPoA2",true);
jslSetValue("uiPostVPI", "8");
jslSetValue("uiPostVCI", "48");
}
jslEnable("uiPostVPI");
jslEnable("uiPostVCI");
}
EOSF3
FFILEN="${SRC}/usr/www/${OEMLINK}/html/de/internet/authform.js"
grep -q "uiViewIpTvTxt" "$FFILEN" ] ||\
sed -i -e 'if (jslGetValue("uiPostAontvArch") == "1")/i\
jslSetChecked("uiViewTcomTargetarch", jslGetValue("uiPostAontvArch") == "1");\
SetSpanText("uiViewIpTvTxt","AON-TV");' "$FFILEN"
grep -q "AON" "$FFILEN" ] ||\
sed -i -e '/case "TNamibiaWimax": OnTNamibiaWimax(); break;/a\
case "AON": OnAon();break;'\
-e '/} else if (ProviderId=="O2") {/i\
} else if (ProviderId=="AON") {\
OnAon();'\
-e '/else if(provider == "congstar"){/i\
else if(provider == "AON"){\
jslSetValue("uiPostAontvArch",jslGetChecked("uiViewTcomTargetarch")?"1":"0");\
}'\
-e '/if (provider != "TNamibiaWimax")/i\
if (provider != "AON")\
jslSetValue("uiPostAontvArch","0");'\
-e '/var g_txtSonstName = "{?txtUsername_js?} ";/i\
var g_txtAonName = "Teilnehmererkennung";\
var g_txtAonKennwort = "Persoenliches Kennwort";\
var g_txtAonConfirmation = "{?txtConfirmPassword?}";'"$FFILEN"

FFILEN="${SRC}/usr/www/${OEMLINK}/html/de/first/first_ISP_1.js"

grep -q "OnAon" "$FFILEN" ||\
cat <<EOSF4 >>"$FFILEN"
function OnAon() {
jslDisplay("UserPrefix", false);
jslDisplay("UserPostfix", false);
SetSpanText("LabelName", g_txtAonName);
SetSpanText("LabelKennwort", g_txtAonKennwort);
SetSpanText("LabelKennwort2", g_txtAonConfirmation);
jslSetChecked("uiViewTcomTargetarch", jslGetValue("uiAontvarch") == "1");
SetSpanText("uiViewIpTvTxt","AON-TV");
}
EOSF4
sed -i -e "/case \"AON\":/,/break;/d" "$FFILEN"
grep -q "AON" "$FFILEN" ] ||\
sed -i -e '/case "DBD":/a\
case "AON":\
if (jslGetChecked("uiViewTcomTargetarch")=="1")\
{\
jslSetValue("uiEncaps", "dslencap_ether");\
jslSetValue("uiAontvarch","1");
}\
else\
{\
jslSetValue("uiEncaps", "dslencap_pppoa");\
jslSetValue("uiAontvarch","0");\
}\
break;'"$FFILEN"

exit 0
#"tcom_targetarch = yes;" und "vdsl_resalearch = yes;"