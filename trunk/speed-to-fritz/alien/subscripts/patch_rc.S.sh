#!/bin/bash
 . ${include_modpatch}
#only in use with old firmwares
if [ ! -e "${1}"/etc/init.d/rc.init ]; then
    exit 0
fi

echo2 "  -- adjusting additional box specific settings in:"
echo2 "      /etc/init.d/rc.S"
 

if ! `cat "$1/etc/init.d/rc.S" | grep -q 'echo "<? setvariable var:isMini " >>/var/config.def'`; then
 sed -i -e "s/^.* var:isFon .*$/ echo \"<\? setvariable var:isFon 1 \?>\" >>\/var\/config.def\n\
 echo \"<\? setvariable var:isMini 0 \?>\" >>\/var\/config.def/" "$1/etc/init.d/rc.S"
fi
if ! `cat "$1/etc/init.d/rc.S" | grep -q 'echo "<? setvariable var:isMediaSrv . ?>" >>/var/config.def'`; then
 sed -i -e "s/^.* var:isFon .*$/ echo \"<\? setvariable var:isFon 1 \?>\" >>\/var\/config.def\n\
 echo \"<\? setvariable var:isMediaSrv 0 \?>\" >>\/var\/config.def/" "$1/etc/init.d/rc.S"
fi
if ! `cat "$1/etc/init.d/rc.S" | grep -q 'echo "<? setvariable var:isMediaCli . ?>" >>/var/config.def'`; then
 sed -i -e "s/^.* var:isFon .*$/ echo \"<\? setvariable var:isFon 1 \?>\" >>\/var\/config.def\n\
 echo \"<\? setvariable var:isMediaCli 0 \?>\" >>\/var\/config.def/" "$1/etc/init.d/rc.S"
fi
if ! `cat "$1/etc/init.d/rc.S" | grep -q 'echo "<? setvariable var:isKids . ?>" >>/var/config.def'`; then
 sed -i -e "s/^.* var:isFon .*$/ echo \"<\? setvariable var:isFon 1 \?>\" >>\/var\/config.def\n\
 echo \"<\? setvariable var:isKids 0 \?>\" >>\/var\/config.def/" "$1/etc/init.d/rc.S"
fi
if ! `cat "$1/etc/init.d/rc.S" | grep -q 'echo "<? setvariable var:isWlanWmm . ?>" >>/var/config.def'`; then
 sed -i -e "s/^.* var:isFon .*$/ echo \"<\? setvariable var:isFon 1 \?>\" >>\/var\/config.def\n\
 echo \"<\? setvariable var:isWlanWmm 0 \?>\" >>\/var\/config.def/" "$1/etc/init.d/rc.S"
fi
if ! `cat "$1/etc/init.d/rc.S" | grep -q 'echo "<? setvariable var:isWlanIptv . ?>" >>/var/config.def'`; then
 sed -i -e "s/^.* var:isFon .*$/ echo \"<\? setvariable var:isFon 1 \?>\" >>\/var\/config.def\n\
 echo \"<\? setvariable var:isWlanIptv 0 \?>\" >>\/var\/config.def/" "$1/etc/init.d/rc.S"
fi
if ! `cat "$1/etc/init.d/rc.S" | grep -q 'echo "<? setvariable var:isEco . ?>" >>/var/config.def'`; then
 sed -i -e "s/^.* var:isFon .*$/ echo \"<\? setvariable var:isFon 1 \?>\" >>\/var\/config.def\n\
 echo \"<\? setvariable var:isEco 0 \?>\" >>\/var\/config.def/" "$1/etc/init.d/rc.S"
fi
if ! `cat "$1/etc/init.d/rc.S" | grep -q 'echo "<? setvariable var:Release ... ?>" >>/var/config.def'`; then
 sed -i -e "s/^.* var:isFon .*$/ echo \"<\? setvariable var:isFon 1 \?>\" >>\/var\/config.def\n\
 echo \"<\? setvariable var:Release \'1\' \?>\" >>\/var\/config.def/" "$1/etc/init.d/rc.S"
fi
if ! `cat "$1/etc/init.d/rc.S" | grep -q 'echo "<? setvariable var:AccessoryUrl'`; then
 sed -i -e "s/^.* var:isFon .*$/ echo \"<\? setvariable var:isFon 1 \?>\" >>\/var\/config.def\n\
 echo \"<\? setvariable var:AccessoryUrl \'\${CONFIG_ACCESSORY_URL}\' \?>\" >>\/var\/config.def/" "$1/etc/init.d/rc.S"
fi

if  `cat "$1/etc/init.d/rc.S" | grep -q 'isIsdnNT .'`; then
 sed -i -e "s/isIsdnNT ./isIsdnNT ${CONFIG_IsdnNT}/" "$1/etc/init.d/rc.S"
fi
if  `cat "$1/etc/init.d/rc.S" | grep -q 'isIsdnTE .'`; then
 sed -i -e "s/isIsdnTE ./isIsdnTE ${CONFIG_IsdnTE}/" "$1/etc/init.d/rc.S"
fi
if  `cat "$1/etc/init.d/rc.S" | grep -q 'isPots .'`; then
 sed -i -e "s/isPots ./isPots ${CONFIG_Pots}/" "$1/etc/init.d/rc.S"
fi
if  `cat "$1/etc/init.d/rc.S" | grep -q 'isUsbHost .'`; then
 sed -i -e "s/isUsbHost ./isUsbHost ${CONFIG_UsbHost}/" "$1/etc/init.d/rc.S"
fi
if  `cat "$1/etc/init.d/rc.S" | grep -q 'isUsb .'`; then
 sed -i -e "s/isUsb ./isUsb ${CONFIG_Usb}/" "$1/etc/init.d/rc.S"
fi
if  `cat "$1/etc/init.d/rc.S" | grep -q 'isUsbStorage .'`; then
 sed -i -e "s/isUsbStorage ./isUsbStorage ${CONFIG_UsbStorage}/" "$1/etc/init.d/rc.S"
fi
if  `cat "$1/etc/init.d/rc.S" | grep -q 'isUsbWlan .'`; then
 sed -i -e "s/isUsbWlan ./isUsbWlan ${CONFIG_UsbWlan}/" "$1/etc/init.d/rc.S"
fi
if  `cat "$1/etc/init.d/rc.S" | grep -q 'isUsbPrint .'`; then
 sed -i -e "s/isUsbPrint ./isUsbPrint ${CONFIG_UsbPrint}/" "$1/etc/init.d/rc.S"
fi
if  `cat "$1/etc/init.d/rc.S" | grep -q 'isDebug .'`; then
 sed -i -e "s/isDebug ./isDebug ${CONFIG_Debug}/" "$1/etc/init.d/rc.S"
fi
 
if ! `cat "$1/etc/init.d/rc.S" | grep -q 'if \[ "\$CONFIG_KIDS"'`; then
	sed -i -e "s/^.* var:isKids 0 .*$/if [ \"\$CONFIG_KIDS\" = \"y\" ] ; then\n\
 echo \"<\? setvariable var:isKids 1 \?>\" >>\/var\/config.def\n\
else\n\
 echo \"<\? setvariable var:isKids 0 \?>\" >>\/var\/config.def\n\
fi/" "$1/etc/init.d/rc.S"
fi


if ! `cat "$1/etc/init.d/rc.S" | grep -q 'if \[ "\$CONFIG_WLAN_WDS"'`; then
	sed -i -e "s/^.* var:isWlanWds 0 .*$/if [ \"\$CONFIG_WLAN_WDS\" = \"y\" ] ; then\n\
 echo \"<\? setvariable var:isWlanWds 1 \?>\" >>\/var\/config.def\n\
else\n\
 echo \"<\? setvariable var:isWlanWds 0 \?>\" >>\/var\/config.def\n\
fi/" "$1/etc/init.d/rc.S"
fi

if ! `cat "$1/etc/init.d/rc.S" | grep -q 'if \[ "\$CONFIG_WLAN_GREEN"'`; then
	sed -i -e "s/^.* var:isWlanGreen 0 .*$/if [ \"\$CONFIG_WLAN_GREEN\" = \"y\" ] ; then\n\
 echo \"<\? setvariable var:isWlanGreen 1 \?>\" >>\/var\/config.def\n\
else\n\
 echo \"<\? setvariable var:isWlanGreen 0 \?>\" >>\/var\/config.def\n\
fi/" "$1/etc/init.d/rc.S"
fi

if ! `cat "$1/etc/init.d/rc.S" | grep -q 'if \[ "\$CONFIG_WLAN_WMM"'`; then
	sed -i -e "s/^.* var:isWlanWmm 0 .*$/if [ \"\$CONFIG_WLAN_WMM\" = \"y\" ] ; then\n\
 echo \"<\? setvariable var:isWlanWmm 1 \?>\" >>\/var\/config.def\n\
else\n\
 echo \"<\? setvariable var:isWlanWmm 0 \?>\" >>\/var\/config.def\n\
fi/" "$1/etc/init.d/rc.S"
fi
if ! `cat "$1/etc/init.d/rc.S" | grep -q 'if \[ "\$CONFIG_WLAN_IPTV"'`; then
	sed -i -e "s/^.* var:isWlanIptv 0 .*$/if [ \"\$CONFIG_WLAN_IPTV\" = \"y\" ] ; then\n\
 echo \"<\? setvariable var:isWlanIptv 1 \?>\" >>\/var\/config.def\n\
else\n\
 echo \"<\? setvariable var:isWlanIptv 0 \?>\" >>\/var\/config.def\n\
fi/" "$1/etc/init.d/rc.S"
fi

if ! `cat "$1/etc/init.d/rc.S" | grep -q 'if \[ "\$CONFIG_ECO"'`; then
	sed -i -e "s/^.* var:isEco 0 .*$/if [ \"\$CONFIG_ECO\" = \"y\" ] ; then\n\
 echo \"<\? setvariable var:isEco 1 \?>\" >>\/var\/config.def\n\
else\n\
 echo \"<\? setvariable var:isEco 0 \?>\" >>\/var\/config.def\n\
fi/" "$1/etc/init.d/rc.S"
fi


echo2 "  -- adjusting box specific settings in:"
echo2 "      /etc/init.d/rc.S"

if ! `cat "$1/etc/init.d/rc.S" | grep -q 'if \[ "\$CONFIG_ATA"'`; then
	sed -i -e "/^.* var:isAtaFull 0 .*$/d" "$1/etc/init.d/rc.S"
	sed -i -e "s/^.* var:isAta 0 .*$/if [ \"\$CONFIG_ATA\" = \"y\" ] ; then\n\
 echo \"<? setvariable var:isAta 1 ?>\" >>\/var\/config.def\n\
 if [ \"\$CONFIG_ATA_FULL\" = \"y\" ] ; then\n\
 echo \"<? setvariable var:isAtaFull 1 ?>\" >>\/var\/config.def\n\
 else\n\
 echo \"<? setvariable var:isAtaFull 0 ?>\" >>\/var\/config.def\n\
 fi\n\
else\n\
 echo \"<? setvariable var:isAta 0 ?>\" >>\/var\/config.def\n\
 echo \"<? setvariable var:isAtaFull 0 ?>\" >>\/var\/config.def\n\
fi/" "$1/etc/init.d/rc.S"
fi

if ! `cat "$1/etc/init.d/rc.S" | grep -q 'if \[ "\$CONFIG_MAILER"'`; then
	sed -i -e "s/^.* var:isMailer 0 .*$/if [ \"\$CONFIG_MAILER\" = \"y\" ] ; then\n\
 echo \"<\? setvariable var:isMailer 1 \?>\" >>\/var\/config.def\n\
else\n\
 echo \"<\? setvariable var:isMailer 0 \?>\" >>\/var\/config.def\n\
fi/" "$1/etc/init.d/rc.S"
fi

if ! `cat "$1/etc/init.d/rc.S" | grep -q 'if \[ "\$CONFIG_UPNP"'`; then
	sed -i -e "s/^.* var:isUpnp 0 .*$/if [ \"\$CONFIG_UPNP\" = \"y\" ] ; then\n\
 echo \"<\? setvariable var:isUpnp 1 \?>\" >>\/var\/config.def\n\
else\n\
 echo \"<\? setvariable var:isUpnp 0 \?>\" >>\/var\/config.def\n\
fi/" "$1/etc/init.d/rc.S"
fi 

if ! `cat "$1/etc/init.d/rc.S" | grep -q 'if \[ "\$CONFIG_STOREUSRCFG"'`; then
	sed -i -e "s/^.* var:isStoreUsrCfg .*$/if [ \"\$CONFIG_STOREUSRCFG\" = \"y\" ] ; then\n\
 echo \"<\? setvariable var:isStoreUsrCfg 1 \?>\" >>\/var\/config.def\n\
else\n\
 echo \"<\? setvariable var:isStoreUsrCfg 0 \?>\" >>\/var\/config.def\n\
fi/" "$1/etc/init.d/rc.S"
fi

if ! `cat "$1/etc/init.d/rc.S" | grep -q 'if \[ "\$CONFIG_TR069"'`; then
	sed -i -e "s/^.* var:isTr069 0 .*$/if [ \"\$CONFIG_TR069\" = \"y\" ] ; then\n\
 echo \"<\? setvariable var:isTr069 1 \?>\" >>\/var\/config.def\n\
else\n\
 echo \"<\? setvariable var:isTr069 0 \?>\" >>\/var\/config.def\n\
fi/" "$1/etc/init.d/rc.S"
fi


if ! `cat "$1/etc/init.d/rc.S" | grep -q 'if \[ "\$CONFIG_DECT"'`; then
	sed -i -e "s/^.* var:isDect 0 .*$/if [ \"\$CONFIG_DECT\" = \"y\" ] ; then\n\
 echo \"<\? setvariable var:isDect 1 \?>\" >>\/var\/config.def\n\
else\n\
 echo \"<\? setvariable var:isDect 0 \?>\" >>\/var\/config.def\n\
fi/" "$1/etc/init.d/rc.S"
fi


exit 0

