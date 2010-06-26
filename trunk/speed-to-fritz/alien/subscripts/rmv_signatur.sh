#!/bin/bash
#########################################################################
# Don't check signature of firmware                                     #
#########################################################################
 . $include_modpatch
echo "-- Applying 'check signature' patch ..."
for DIR in ${OEMLIST}; do
# if [ "$DIR" = "avme" ] ; then
#  html="$avm_Lang/html"
# else
  html="html"
# fi
    DSTI="${1}"/usr/www/${DIR}/${html}/de/home/home.js
    if [ -f ${DSTI} ] ; then
	 echo2 "-- Patching file:"
	 echo2 "      /usr/www/$html/de/home/home.js ..."
	sed -i -e 's|var signed =.*$|var signed = "1";|g' "${DSTI}"
	if ! `cat "${DSTI}" | grep -q 'signed_firmware ?>'` ; then
	 echo2 "-- Signature removed in ${DIR}/$html/de/home/home.js"
	else
	 echo2 "-- Signature NOT removed in ${DIR}/$html/de/home/home.js"
	fi

    fi
    #remove LABOR comment
    if [ -f $1/usr/www/${DIR}/${html}/de/home/home.html ] ; then
	sed -i -e "/http:\/\/www.avm.de\/labor/d" "$1"/usr/www/${DIR}/${html}/de/home/home.html
	sed -i -e "/nichtsigniert/d" "$1"/usr/www/${DIR}/${html}/de/home/home.html
    fi
    #17675
    if [ -f $1/usr/www/${DIR}/home/home.lua ] ; then
	sed -i -e "s/box.query(.box:status.signed_firmware.)/1/" $1/usr/www/${DIR}/home/home.lua
	sed -i -e "s/if (g_coninf_data.FirmwareSigned==.1.)/if (\"1\"==\"1\")/" $1/usr/www/${DIR}/home/home.lua
    fi
done
# just for safty 
if [ -f "$1/sbin/ar7login" ] ; then
 sed -i -e 's|TELNET|\x00\x00\x00\x00\x00\x00|' "${1}/sbin/ar7login"
 #sed -i -e 's|TELNET|\x00ELNET|' "${1}/sbin/ar7login"
 sed -i -e 's|/var/flash/fw_attrib|/var/flash/jp_attrib|' "${1}/sbin/ar7login"
fi
