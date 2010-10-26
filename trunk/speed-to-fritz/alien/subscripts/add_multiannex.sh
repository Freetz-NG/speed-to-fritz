#!/bin/bash
#--> multiannex
if [ "${FORCE_DSL_MULTI_ANNEX}" = "y" ]; then
  #disableable kernel_args option
  sed -i -e 's/"$annex_param"/"$noannexparam"/' "${SRC}"/etc/init.d/rc.conf
  grep -q '"$noannexparam"' "${SRC}"/etc/init.d/rc.conf && echo "-- kernel_args annex option is disabeled!"
  #Make Tab Einstellungen visibel in every case 
  for file_n in atm.html adsl.html bits.html overview.html; do
	sed -i -e 's|$var:Annex .|A B|'  "${SRC}/usr/www/${OEMLINK}/html/de/internet/$file_n"
	sed -i -e 's|<? query box:settings/expertmode/activated ?>|1|'  "${SRC}/usr/www/${OEMLINK}/html/de/internet/$file_n"
	# with Firmware-Version 54.04.99-15852 names are changed 
	# dslsnrset.* labor_dsl*
	### sed -i -e 's|uiDoLaborDSLPage()|uiDoSNRPage()|'  "${SRC}/usr/www/${OEMLINK}/html/de/internet/$file_n"
  done 
  for file_n in /html/de/first/basic_first.js /html/de/first/basic_first.frm /html/de/help/hilfe_internet_dslsnrset.html; do
    if [ -f "${SRC_2}/usr/www/${OEML2}/$file_n" ] && ! [ -f "${SRC}/usr/www/${OEMLINK}/$file_n" ]; then
     cp -fdrp "${SRC_2}/usr/www/${OEML2}/$file_n" "${SRC}/usr/www/${OEMLINK}/$file_n" && echo2 "    copy from 2nd AVM firmware: $file_n"
    fi
  done
 sed -i -e 's/export CONFIG_ANNEX="A"/export CONFIG_ANNEX="B"/' "${SRC}"/etc/init.d/rc.conf
 sed -i -e 's/CONFIG_DSL_MULTI_ANNEX="n"/CONFIG_DSL_MULTI_ANNEX="y"/' "${SRC}"/etc/init.d/rc.conf
 sed -i -e "s/isMultiAnnex=0/isMultiAnnex=1/g" "${SRC}"/etc/init.d/rc.S
 ! [ -f "${SRC}/usr/www/${OEMLINK}/html/de/internet/dslsnrset.js" ] && modpatch "${SRC}/${USRWWW}" "$P_DIR/add_dslsnrjs_de.patch"
 if  `grep -q 'MultiAnnex' "${SRC}/usr/www/${OEMLINK}/html/de/internet/dslsnrset.js"`; then
  echo "-- multi Annex is in use, because 1st firmware is a multiannex."
 else

  echo "-- adding Annex selection to dslsnrset pages ..."
  [ -f "${SRC}/usr/www/${OEMLINK}/html/de/internet/dslsnrset.frm" ] && rm -f "${SRC}/usr/www/${OEMLINK}/html/de/internet/dslsnrset.frm"
  [ -f "${SRC}/usr/www/${OEMLINK}/html/de/internet/dslsnrset.html" ] && rm -f "${SRC}/usr/www/${OEMLINK}/html/de/internet/dslsnrset.html"
  [ "$avm_Lang" = "de" ] && modpatch "${SRC}/${USRWWW}" "$P_DIR/add_dslsnrset_de.patch"
  [ "$avm_Lang" != "de" ] && modpatch "${SRC}/${USRWWW}" "$P_DIR/add_dslsnrset_en.patch"
  echo "-- adding multiannex pages ..."
  if ! [-f "${SRC}/usr/www/${OEMLINK}/html/de/first/basic_first_Annex.html"]; then
  # Sprachdatenbank fehlt
  #    if  [-f "${DST}/usr/www/avme/html/de/first/basic_first_Annex.html"]; then
  #	for ext in "frm js html"; do
  #	    [ -f "${DST}/usr/www/avme/html/de/first/basic_first_Annex.$ext" ] && cp -fv "${DST}/usr/www/avne/html/de/first/basic_first_Annex.$ext" "${SRC}/usr/www/${OEMLINK}/html/de/first/basic_first_Annex.$ext"
  #	done
  #    else
	[ -f "${SRC}/usr/www/${OEMLINK}/html/de/first/basic_first_Annex.frm" ] && rm -f "${SRC}/usr/www/${OEMLINK}/html/de/first/basic_first_Annex.frm"
	[ -f "${SRC}/usr/www/${OEMLINK}/html/de/first/basic_first_Annex.js" ] && rm -f "${SRC}/usr/www/${OEMLINK}/html/de/first/basic_first_Annex.js"
	[ "$avm_Lang" = "de" ] && modpatch "${SRC}/${USRWWW}" "$P_DIR/add_first_annex_de.patch"
	[ "$avm_Lang" != "de" ] && modpatch "${SRC}/${USRWWW}" "$P_DIR/add_first_annex_en.patch"
  #    fi
  fi
  if ! `grep -q 'ar7cfg.dslglobalconfig.Annex' "${SRC}"/etc/init.d/rc.conf`; then
     sed -i -e '/export ANNEX=.cat .CONFIG_ENVIRONMENT_PATH.annex./d' "${SRC}"/etc/init.d/rc.conf
     sed -i -e '/"$annex_param"/a\
if [ "${CONFIG_DSL_MULTI_ANNEX}" = "y" ] ; then\
LOADANNEX=`echo ar7cfg.dslglobalconfig.Annex | ar7cfgctl -s 2>\/dev\/null | sed s\/\\\\"\/\/g` ; # annex aus userselection?\
if [ -z "${LOADANNEX}" ] ; then\
export ANNEX=`cat $CONFIG_ENVIRONMENT_PATH\/annex` ; # annex aus /proc nehmen, nicht von Config!\
else\
export ANNEX=${LOADANNEX} ; # annex aus userselection\
fi\
else\
export ANNEX=`cat $CONFIG_ENVIRONMENT_PATH\/annex` \
fi' "${SRC}"/etc/init.d/rc.conf
  fi
  # for savety in some Firmwares needed
  if ! `grep -q 'export CONFIG_DSL_MULTI_ANNEX' "${SRC}"/etc/init.d/rc.conf`; then
      sed -i -e '/export CONFIG_ANNEX="B"/a\
export CONFIG_DSL_MULTI_ANNEX="y"' "${SRC}"/etc/init.d/rc.conf
  fi
  if ! `grep -q 'var.isMultiAnnex' "${SRC}"/etc/init.d/rc.S`; then
      sed -i -e '/setvariable var:FirmwareVersion/a\
isMultiAnnex=1\
echo "<? setvariable var:isMultiAnnex  XcommaX$isMultiAnnexXcommaX  ?>" >>${CONFIG_DEF}' "${SRC}"/etc/init.d/rc.S
  sed -i -e "s/XcommaX/'/g" "${SRC}"/etc/init.d/rc.S
  fi
  # do it this way so it also works with 7170 firmwares
  if ! `grep -q 'MultiAnnex' "${SRC}/usr/www/${OEMLINK}/html/de/internet/dslsnrset.js"`; then
  sed -i -e '/function uiDoSave/a\
bAnnexConfirm=false;\
annex = jslGetValue("uiPostAnnex");\
if (jslGetChecked("uiViewAnnexA") && annex!="A") {\
if (confirm(g_mldChangeAnnexQuestion)) {\
jslSetValue("uiPostAnnex", "A");\
jslEnable("uiPostAnnex");\
bAnnexConfirm=true;\
}\
}\
if (jslGetChecked("uiViewAnnexB") && annex!="B") {\
if (confirm(g_mldChangeAnnexQuestion)) {\
jslSetValue("uiPostAnnex", "B");\
jslEnable("uiPostAnnex");\
bAnnexConfirm=true;\
}\
}\
function uiDoHelp() {\
jslPopHelp("hilfe_internet_dslsnrset");\
}'  "${SRC}/usr/www/${OEMLINK}/html/de/internet/dslsnrset.js"
  sed -i -e "s/^0$/bAnnexConfirm/"  "${SRC}/usr/www/${OEMLINK}/html/de/internet/dslsnrset.js"
  sed -i -e '/function uiDoOnLoad/a\
InitAnnex();'  "${SRC}/usr/www/${OEMLINK}/html/de/internet/dslsnrset.js"
  sed -i -e '/function InitMode/i\
var g_oem = "<? query env:status/OEM ?>";\
var g_mldChangeAnnex = "Change Annex";\
var g_mldChangeOver = "Annex Changed";\
g_mldChangeAnnexQuestion=g_mldChangeAnnex;\
function InitAnnex()\
{\
annex = jslGetValue("uiPostAnnex");\
if (annex=="A")\
uiSetAnnex(0);\
else if (annex=="B")\
uiSetAnnex(1);\
}\
function uiSetAnnex(n)\
{\
jslSetChecked("uiViewAnnexA", n==0);\
jslSetChecked("uiViewAnnexB", n==1);\
}'  "${SRC}/usr/www/${OEMLINK}/html/de/internet/dslsnrset.js"
  fi
  if [ "$avm_Lang" = "de" ]; then
   sed -i -e 's/Change Annex/Sie haben die ADSL-Leitungskonfiguration geändert. Eine falsche Einstellung kann dazu führen, dass keine DSL-Verbindung mehr zustande kommt. Damit die Änderung wirksam wird muss die Box neugestartet werden. Sind Sie sicher, dass die Änderung vorgenommen werden soll?/' "${SRC}/usr/www/${OEMLINK}/html/de/internet/dslsnrset.js"
  else
   sed -i -e 's/Change Annex/You did change the DSL wire configuration. A worong setting will lead to a loss off connection. Reboot is neede that the changes can be but to ation, shold that be done?/'  "${SRC}/usr/www/${OEMLINK}/html/de/internet/dslsnrset.js"
  fi
  Unicode_ut8="n"
  `cat "${SRC}"/usr/www/${OEMLINK}/html/index.html | grep -q 'charset=utf-8' ` && Unicode_ut8="y"
  ##file_nLIST="/html/de/internet/dslsnrset.frm html/de/internet/dslsnrset.html html/de/first/basic_first_Annex.js /html/de/first/basic_first_Annex.frm /html/de/first/basic_first_Annex.html"
  ##file_nLIST="$file_nLIST html/de/system/timeZone.js html/de/system/timeZone.frm html/de/system/timeZone.html"
  file_nLIST="/html/de/internet/dslsnrset.html html/de/first/basic_first_Annex.html html/de/internet/dslsnrset.js"
  for file_n in $file_nLIST; do
    file_nname="${SRC}/usr/www/${OEMLINK}${file_n}"
    if [ "$Unicode_ut8" = "y" ] && [ "$avm_Lang" = "de" ]; then
     [ -f ${file_nname} ] && iconv --from-code=ISO-8859-1 --to-code=UTF-8 "${file_nname}" > ${file_nname}.ut8
     rm -f ${file_nname}
     [ -f ${file_nname}.ut8 ] && mv ${file_nname}.ut8 ${file_nname} && echo2 "     $file_n changed to ut8"
    fi
  done
 fi # <-- ? 1st firmware multiannex
fi # <-- Multiannex 
