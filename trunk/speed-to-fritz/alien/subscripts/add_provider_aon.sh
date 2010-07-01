#!/bin/bash
# include modpatch function
. ${include_modpatch}
# menu options for ar7.cfg entrys
#"tcom_targetarch = yes;" und "vdsl_resalearch = yes;"
echo "-- Add AON as provider ..."
FILELIST="/html/de/first/provider.js /html/de/internet/authform.html /html/de/internet/authform.frm \
/html/de/first/first_ISP_0.html /html/de/first/first_ISP_0.frm /html/de/first/first_ISP_1.html /html/de/first/first_ISP_1.frm \
/html/de/first/first_ISP_2.html /html/de/first/first_ISP_2.frm /html/de/first/first_ISP_3.html /html/de/first/first_ISP_3.frm"
for FILE in $FILELIST; do
XFILE="${SRC}/usr/www/${OEMLINK}$FILE"
  if [ -f "$XFILE" ]; then
#    echo "$XFILE"
    grep -q "uiPostResalearch" "$XFILE" || sed -i -e 's/id="uiPostResalearch">/id="uiPostResalearch" disabled>/' "$XFILE"
    grep -q "uiPostResalearch" "$XFILE" || sed -i -e '/tcom_targetarch/a\
<input type="hidden" name="connection0:settings\/vdsl_resalearch" value="<? query connection0:settings\/vdsl_resalearch ?>" id="uiPostResalearch" disabled>' "$XFILE"
    grep -q "uiPostAontvArch" "$XFILE" || sed -i -e '/tcom_targetarch/a\
<input type="hidden" name="connection0:settings\/aontv_arch" value="<? query connection0:settings\/aontv_arch ?>" id="uiPostAontvArch" >' "$XFILE"
#<input type="hidden" name="connection0:settings\/aontv_arch" value="<? query connection0:settings\/aontv_arch ?>" id="uiPostAontvArch" disabled>' "$XFILE"
#"#    grep -q "szProvider== .AON." "$XFILE" || sed -i -e '/if neq .var:OEM freenet/i\
#if(szProvider== "AON") return szProvider;' "$XFILE"
    grep -q "id == .AON." "$XFILE" || sed -i -e '/return otherprovider;/i\
if (id == "AON") return "aon";' "$XFILE"
    grep -q "value=.AON" "$XFILE" ||     sed -i -e '/<option value="Inode">/i\
    <option value="AON">aon<\/option>' "$XFILE"
    grep -q "if(szProvider== .AON) return szProvider;" "$XFILE" || sed -i -e '/if(szProvider=="O2")return szProvider;/a\
if(szProvider== "AON") return szProvider;' "$XFILE"
    grep -q 'case "voip.aon.at": return "AON";' "$XFILE" || sed -i -e '/case "voip.inode.at": return "Inode";/a\
case "voip.aon.at": return "AON";' "$XFILE"
#    grep -q 'value=.AON' "$XFILE" || sed -i -e '/query box.settings.country.*043/a\
#<option value="AON">aon<\/option>' "$XFILE"
    grep -q "AON" "$XFILE" && echo2 "     Found provider AON in: $FILE"
    grep -q "Aontvarch" "$XFILE" && echo2 "     Found AON-tvarch in: $FILE"
    grep -q "uiPostAontvArch" "$XFILE" && echo2 "     Found AontvArch in: $FILE"
  fi
done

XFILE="${SRC}/usr/www/${OEMLINK}/html/de/first/first.frm"
[ -f "$XFILE" ] && ! grep -q "Aontvarch" "$XFILE" && sed -i -e '/TcomTargetarch/a\
<input type="hidden" name="var:Aontvarch" value="<? echo $var:Aontvarch ?>" id="uiAontvarch">' "$XFILE"
[ -f "$XFILE" ] && grep -q "Aontvarch" "$XFILE" && echo2 "     Found AON-Tvarch in: /html/de/first/first.frm"


XFILE="${SRC}/usr/www/${OEMLINK}/html/de/first/first_ISP_0.js"
[ -f "$XFILE" ] && ! grep -q "szProvider==.AON..{" "$XFILE" &&\
sed -i -e 's/szProvider=="KDG"){/szProvider=="KDG" ||/' "$XFILE"
[ -f "$XFILE" ] && ! grep -q "szProvider==.AON..{" "$XFILE" &&\
sed -i -e '/szProvider=="KDG" ||/a\
szProvider=="AON"){' "$XFILE"
[ -f "$XFILE" ] && ! grep -q "jslSetValue(.uiAontvarch" "$XFILE" ] &&\
sed -i -e '/if(jslGetValue( .uiPppProvider.)!=.TOnline.)/a\
jslSetValue("uiTcomTargetarch","0");\
if (jslGetValue( "uiPppProvider") != "AON")\
jslSetValue("uiAontvarch","0");\
if ( jslGetValue( "uiPppProvider") != "") {\
jslSetSelection("uiViewProvider", jslGetValue( "uiPppProvider"));' "$XFILE"

XFILE="${SRC}/usr/www/${OEMLINK}/html/de/first/first_ISP_1.js"
[ -f "$XFILE" ] && sed -i -e "/case \"AON\":$/,/break;$/d" "$XFILE"
[ -f "$XFILE" ] && ! grep -q "case \"AON\":$" "$XFILE" &&\
sed -i -e "/case \"DBD\":$/i\
case \"AON\":\\n\
if (jslGetChecked(\"uiViewTcomTargetarch\")==\"1\")\\n\
{\\n\
jslSetValue(\"uiEncaps\", \"dslencap_ether\");\\n\
jslSetValue(\"uiAontvarch\",\"1\");\\\
}\\n\
else\\n\
{\\n\
jslSetValue(\"uiEncaps\", \"dslencap_pppoa\");\\n\
jslSetValue(\"uiAontvarch\",\"0\");\\n\
}\\n\
break;" "$XFILE" && ! grep -q 'case "AON": OnAon();break;' "$XFILE" && sed -i -e '/default: OnSonst(); break;/i\
case "AON": OnAon();break;' "$XFILE"

[ -f "$XFILE" ] && ! grep -q 'if .provider .= "AON".' "$XFILE" &&\
sed -i -e '/if(provider=="DBD" || provider=="TNamibiaWimax"){/i\
if (provider != "AON")\
jslSetValue("uiAontvarch","0");' "$XFILE"

[ -f "$XFILE" ] && ! grep -q 'g_txtAonName' "$XFILE" &&\
sed -i -e '/var g_Variante = "<? echo $var:OEM ?>";/i\
var g_txtAonName = "Teilnehmererkennung";\
var g_txtAonKennwort = "Persoenliches Kennwort";\
var g_txtAonConfirmation = "{?txtConfirmPassword?}";' "$XFILE"

XFILE="${SRC}/usr/www/${OEMLINK}/html/de/first/first_ISP_3.js"

[ -f "$XFILE" ] && ! grep -q 'jslSetValue("uiPostResalearch", "1");' "$XFILE" &&\
sed -i -e '/jslCopyValue("uiPostTcomTargetarch", "uiTcomTargetarch");/a\
jslCopyValue("uiPostAontvArch", "uiAontvarch");\
if (GetFullProviderString(jslGetValue("uiPppUsername")) == "TOnline") {\
jslSetValue("uiPostTcomTargetarch", "1");\
}\
var OldResaleArch=jslGetValue("uiPostResalearch");\
if (IsUnitedInternet(GetFullProviderString(jslGetValue("uiPppUsername")))) {\
//vdsl && dslverbindung aktiv\
jslSetValue("uiPostResalearch", "1");\
}\
else {\
jslSetValue("uiPostResalearch", "0");\
}\
if (OldResaleArch!=jslGetValue("uiPostResalearch"))\
{\
jslEnable("uiPostResalearch");\
}' "$XFILE" &&\
sed -i -e '/jslSetValue("uiPostVPI", "8");/i\
jslEnable("uiPostEncaps");' "$XFILE" &&\
sed -i -e '/jslSetValue("uiPostEncaps", "dslencap_ether");/a\
jslEnable("uiPostEncaps");' "$XFILE" &&\
sed -i -e '/jslEnable("uiPostTcomTargetarch");/a\
jslEnable("uiPostAontvArch");' "$XFILE" &&\
sed -i -e '/jslCopyValue("uiPostVCI", "uiPppVCI");/a\
jslEnable("uiPostEncaps");' "$XFILE"


[ -f "$XFILE" ] && ! grep -q 'jslSetValue("uiPostVciSepVcc", "36");' "$XFILE" &&\
sed -i -e '/}\/\/switch/i\
case "AON":\
{\
\/\/jslCopyValue("uiPostTcomTargetarch", "uiTcomTargetarch");\
if (jslGetValue("uiAontvarch")=="1")\
{\
jslSetValue("uiPostUseSepVcc", "1");\
jslSetValue("uiPostEncapsSepVcc", "dslencap_ether");\
jslSetValue("uiPostVpiSepVcc", "8");\
jslSetValue("uiPostVciSepVcc", "36");\
jslEnable("uiPostUseSepVcc");\
jslEnable("uiPostEncapsSepVcc");\
jslEnable("uiPostVpiSepVcc");\
jslEnable("uiPostVciSepVcc");\
}\
jslSetValue("uiPostEncaps", "dslencap_pppoa");\
jslSetValue("uiPostVPI", "8");\
jslSetValue("uiPostVCI", "48");\
//jslEnable("uiPostTcomTargetarch");\
jslEnable("uiPostEncaps");\
jslEnable("uiPostVPI");\
jslEnable("uiPostVCI");\
break;\
}' "$XFILE"


[ -f "$XFILE" ] && ! grep -q 'function uiDoReboot()' "$XFILE" &&\
sed -i -e '/<\/script>/i\
function uiDoReboot() {\
document.getElementById("uiPostVarName").name = "logic:command\/reboot";\
jslSetValue("uiPostVarName", "..\/gateway\/commands\/saveconfig.html");\
var oldGetPage = jslGetValue("uiPostGetPage");\
jslSetValue("uiPostGetPage", "..\/html\/reboot.html");\
\/\/document.getElementById("uiPostForm").submit();\
jslFormSubmit("uiPostForm");\
}' "$XFILE"
XFILE="${SRC}/usr/www/${OEMLINK}/html/de/internet/authform.frm"
[ -f "$XFILE" ] && ! grep -q "uiPostVarName" "$XFILE" &&\
cat <<EOF2 >>"$XFILE"
<input type="hidden" id="uiPostVarName" name="">
EOF2

XFILE="${SRC}/usr/www/${OEMLINK}/html/de/internet/authform.js"

#[ -f "$XFILE" ] && ! grep -q '' "$XFILE" &&\
#sed -i -e '//i\
#' "$XFILE"
#' "$XFILE"

[ -f "$XFILE" ] && ! grep -q 'vdsl && dslverbindung aktiv' "$XFILE" &&\
! grep -q "jslSetValue..uiPostResalearch., .1"  "$XFILE" &&\
sed -i -e '/else if (provider == "1u1")/{n;d}' "$XFILE"
[ -f "$XFILE" ] && ! grep -q 'vdsl && dslverbindung aktiv' "$XFILE" &&\
! grep -q "jslSetValue..uiPostResalearch., .1"  "$XFILE" &&\
sed -i -e '/else if (provider == "1u1")/a\
{\
\/\/vdsl && dslverbindung aktiv\
if(jslGetChecked("uiViewAnschlussDsl") || g_expertMode != "1")\
jslSetValue("uiPostResalearch", "1");\
else\
jslSetValue("uiPostResalearch", "0");\
jslEnable("uiPostResalearch");' "$XFILE"



[ -f "$XFILE" ] && ! grep -q "function uiDoReboot() {" "$XFILE" &&\
cat <<EOSF1 >>"$XFILE"
function uiDoReboot() {
document.getElementById("uiPostVarName").name = "logic:command/reboot";
jslSetValue("uiPostVarName", "../gateway/commands/saveconfig.html");
var oldGetPage = jslGetValue("uiPostGetPage");
jslSetValue("uiPostGetPage", "../html/reboot.html");
//document.getElementById("uiPostForm").submit();
jslFormSubmit("uiPostForm");
}
EOSF1
sed -i -e 's/function OnAon()/function OldOnAon()/' "$XFILE"
[ -f "$XFILE" ] && ! grep -q "function OnAon() {" "$XFILE" &&\
cat <<EOSF3 >>"$XFILE"
function OnAon(){
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
//jslSetChecked("uiViewDslPppPPPoE", true);
jslSetValue("uiPostVPI", "8");
jslSetValue("uiPostVCI", "36");
}
else
{
jslSetValue("uiEncaps", "dslencap_pppoa");
//jslSetChecked("uiViewDslPppPPPoA2",true);
jslSetValue("uiPostVPI", "8");
jslSetValue("uiPostVCI", "48");
}
jslEnable("uiPostVPI");
jslEnable("uiPostVCI");
}
EOSF3

[ -f "$XFILE" ] && ! grep -q "uiViewIpTvTxt" "$XFILE" ] &&\
sed -i -e 'if (jslGetValue("uiPostAontvArch") == "1")/i\
jslSetChecked("uiViewTcomTargetarch", jslGetValue("uiPostAontvArch") == "1");\
SetSpanText("uiViewIpTvTxt","AON-TV");' "$XFILE"
[ -f "$XFILE" ] && ! grep -q 'case "AON": OnAon();break;' "$XFILE" &&\
sed -i -e '/case "TNamibiaWimax": OnTNamibiaWimax(); break;/a\
case "AON": OnAon();break;' "$XFILE"
[ -f "$XFILE" ] && ! grep -q '} else if (ProviderId=="AON") {' "$XFILE" &&\
sed -i -e '/} else if (ProviderId=="O2") {/i\
} else if (ProviderId=="AON") {\
OnAon();' "$XFILE"
[ -f "$XFILE" ] && ! grep -q 'else if(provider == "AON"){' "$XFILE" &&\
sed -i -e '/else if(provider == "congstar"){/i\
else if(provider == "AON"){\
jslSetValue("uiPostAontvArch",jslGetChecked("uiViewTcomTargetarch")?"1":"0");\
}' "$XFILE"
[ -f "$XFILE" ] && ! grep -q "^if (provider != .AON.)" "$XFILE" &&\
sed -i -e '/if (provider != "TNamibiaWimax")/i\
if (provider != "AON")\
jslSetValue("uiPostAontvArch","0");' "$XFILE"
[ -f "$XFILE" ] && ! grep -q 'var g_txtAonName' "$XFILE" &&\
sed -i -e '/var g_txtSonstName = "{?txtUsername_js?} ";/i\
var g_txtAonName = "Teilnehmererkennung";\
var g_txtAonKennwort = "Persoenliches Kennwort";\
var g_txtAonConfirmation = "{?txtConfirmPassword?}";' "$XFILE"

von="case .AON.: OnAon();break;"
bis="if (id==.Inode"
alt="jslDisplay('uiTcomTargetArchOption.*);"
neu="jslDisplay('uiTcomTargetArchOption',id == \"TOnline\" || id == \"AON\" );"
[ -f "$XFILE" ] &&\
sed -i -e "/\($von\)/,/\($bis\)/ { /$von/b; /$bis/b; s/$alt/$neu/ }" "$XFILE"
von="if (g_usePstn == .0.) {"
bis="}"
alt="jslEnable(\"uiPostRtpPrio\");"
add="jslSetValue(\"uiPostUseSepVcc\", \"1\");"
[ -f "$XFILE" ] &&\
sed -i -e "/\($von\)/,/\($bis\)/ { /$von/b; /$bis/b; s/$alt/$alt\n$add/ }" "$XFILE"
alt="jslSetValue(\"uiPostEncapsSepVcc\", \"dslencap_pppoe\");"
add="jslEnable(\"uiPostUseSepVcc\");"
[ -f "$XFILE" ] &&\
sed -i -e "/\($von\)/,/\($bis\)/ { /$von/b; /$bis/b; s/$alt/$alt\n$add/ }" "$XFILE"


sed -i -e 's/SetSpanText("uiViewIpTvTxt",".*");/SetSpanText("uiViewIpTvTxt","Internet-TV via VLANs");/' "$XFILE"
XFILE="${SRC}/usr/www/${OEMLINK}/html/de/internet/authform.html"
sed -i -e "s/for=.uiViewTcomTargetarch.*$/for=\"uiViewTcomTargetarch\"><span id=\"uiViewIpTvTxt\">Internet-TV via VLANs<\/span><\/label><\/p/" "$XFILE"

rpl_avme_avm()
{
	for file_n in $1; do
	if [ -f "$file_n" ]; then
	 grep -q '<? if eq $var:OEM avme `' "$file_n" && echo2 "  enabled all 'avme' options in file: ${file_n##*/}"
	 sed -i -e 's/<? if eq $var:OEM avme `/<? if eq 1 1 `/' "$file_n"
	fi
	done
}
if [ "${OEM}" = "avm" ]; then
  rpl_avme_avm "$(find "${SRC}/usr/www/${OEMLINK}" -name *.html)" 
  rpl_avme_avm "$(find "${SRC}/usr/www/${OEMLINK}" -name *.frm)" 
fi

exit 0


