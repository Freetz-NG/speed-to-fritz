#!/bin/bash
 . $include_modpatch
echo "-- Patching install webpages ..."

patch_flash_txt ()
{
#<--avm de all in one 110854
#all in one
if `cat "$1" | grep -q 'charset=utf-8' ` ; then
#110954 original text

#/usr/www/avm/html/tools/flash.html
#/usr/www/avm/html/tools/flash2.html

sed -i -e 's|Achtung: W.*$|Achtung: WÃ¤hrend des Firmware-Updates blinkt oder leuchtet die INFO-LED (oder T-DSL-LED) permanent. In dieser Zeit darf die Stromversorgung der Anlage <b>nicht</b> unterbrochen werden.<br><br>\
Wenn das Blinken der INFO-LED aufgehÃ¶rt hat oder die T-DSL-LED erloschen ist, kÃ¶nnen Sie den Speedport neu booten (Netzstecker ziehen).<br><br>\
Je nach Firmware sind die Netzwerkeinstellungen am PC anzupassen, oder erneut per DHCP zu beziehen (Restart der Netzwerkeinstellungen).<br>\
Die Adresse des Speedports kann entweder 192.168.178.1 oder 192.168.2.1 sein, die Eingabe von "Fritz.Box" ist nicht ausreichend, wenn sich die Adresse geÃ¤ndert hat.<br>\
Nach Reboot der Box muss diese resetet und auf WERKSEINSTELLUNG zurÃ¼ck gestellt werden. (Entweder Ã¼ber WebGUI oder angeschlossenem Telefon durch die Eingabe von #991*15901590*). <br><br>|' "$1"

sed -i -e 's|Dieser Vorgang kann bis zu|Der Updatevorgang kann bis zu|' "$1"


#/www/avm/html/tools/update_not_signed.html
#110954 original text

#<p class="mb10">Wenn Sie nicht freigegebene Firmware in der FRITZ!Box installieren, kann dies zum kompletten Funktionsverlust der FRITZ!Box fÃ¼hren. Weiterhin #verlieren Sie alle AnsprÃ¼che auf Support, Garantie und GewÃ¤hrleistung fÃ¼r Ihre FRITZ!Box.</p>
#<p class="mb10">Verwenden Sie ausschlieÃŸlich Firmware, die von AVM fÃ¼r dieses GerÃ¤t freigegeben ist. Nur dafÃ¼r kann AVM die volle UnterstÃ¼tzung der FunktionalitÃ¤t #Ihrer FRITZ!Box sicherstellen.</p>
#<p>Freigegebene Firmware-Dateien fÃ¼r Ihre FRITZ!Box sind:</p>
#<p>- von AVM erstellt und herausgegeben</p>
#<p>- fÃ¼r Ihr FRITZ!Box-Modell erstellt</p>
#<p class="mb20">- mindestens so aktuell, wie die auf der FRITZ!Box installierte Firmware</p>

sed -i -e "s|Die angegebene Datei enthÃ¤lt keine von AVM fÃ¼r dieses GerÃ¤t freigegebene Firmware.|Im Ernstfall kann immer noch per FTP unter einer der folgenden Adressen '192.168.178.1, 192.168.2.1, 192.168.1.1' auf die Box zugegriffen werden.|" "$1"

sed -i -e "s|Wenn Sie nicht freigegebene Firmware in der FRITZ!Box installieren,.*$|Wenn Sie fehlerhafte Firmware in der FRITZ.Box installieren, kann dies zum normalen Funktionsverlust der FRITZ!Box fÃ¼hren.</\p>\n\
<p class=\"mb10\">Verwenden Sie ausschlieÃŸlich Firmware, die fÃ¼r dieses GerÃ¤t und Modell erstellt wurde.<\/p>|" "$1"

sed -i -e 's|Update abbrechen (empfohlen)|Update abbrechen|' "$1"
sed -i -e 's|Update fortsetzen|Update fortsetzen (empfohlen)|' "$1"

sed -i -e "/Nur dafÃ¼r kann AVM die volle UnterstÃ¼tzung der FunktionalitÃ¤t/d" "$1"
sed -i -e "/Freigegebene Firmware-Dateien fÃ¼r Ihre FRITZ!Box sind:/d" "$1"
sed -i -e "/- von AVM erstellt und herausgegeben/d" "$1"
sed -i -e "/- fÃ¼r Ihr FRITZ!Box-Modell erstellt/d" "$1"
sed -i -e "/- mindestens so aktuell, wie die auf der FRITZ!Box installierte Firmware/d" "$1"

else
#tcom-->
#flash.html
sed -i -e 's|<p>Dieser Vorgang kann einige Minuten dauern. Bitte haben Sie Geduld.</p>|<p>Das Firmwareupdate wird durchgeführt, danach startet sich die Anlage neu.</p>\
<b>Achtung:</b> Während des Firmware-Updates blinkt oder leuchtet die INFO-LED\
( T-DSL-LED oder POWER-LED ) permanent. Wenn das Blinken oder Leuchten der LEDs\
aufgehört hat, können Sie den Speedport neu booten (Netzstecker ziehen).\
Je nach Firmware sind die Netzwerkeinstellungen\
am PC anzupassen, oder erneut per DHCP zu beziehen (Restart der\
Netzwerkeinstellungen). Die Adresse des Speedports kann entweder 192.168.178.1\
oder 192.168.2.1 sein, die Eingabe von "Fritz.Box" ist nicht ausreichend,\
wenn sich die Adresse geändert hat.\
Nach Reboot der Box muss diese Resetet und auf WERKSEINSTELLUNG\
zurück gestellt werden. (Entweder über WebGUI oder angeschlossenem Telefon\
durch die Eingabe von #991*15901590*).\
</p>|' "$1"
#restart.html
sed -i -e 's|<p>Die Anlage startet sich jetzt neu.</p>|<p>Das Firmwareupdate wird durchgeführt, danach startet sich die Anlage neu.</p>\
<b>Achtung:</b> Während des Firmware-Updates blinkt oder leuchtet die INFO-LED\
( T-DSL-LED oder POWER-LED ) permanent. Wenn das Blinken oder Leuchten der LEDs\
aufgehört hat, können Sie den Speedport neu booten (Netzstecker ziehen).\
Je nach Firmware sind die Netzwerkeinstellungen\
am PC anzupassen, oder erneut per DHCP zu beziehen (Restart der\
Netzwerkeinstellungen). Die Adresse des Speedports kann entweder 192.168.178.1\
oder 192.168.2.1 sein, die Eingabe von "Fritz.Box" ist nicht ausreichend,\
wenn sich die Adresse geändert hat.\
Nach Reboot der Box muss diese Resetet und auf WERKSEINSTELLUNG\
zurück gestellt werden. (Entweder über WebGUI oder angeschlossenem Telefon\
durch die Eingabe von #991*15901590*).|' "$1"

sed -i -e 's|<h2>Reboot durchführen</h2>|<h2>Update und Reboot durchführen</h2>\
<p>Das Firmwareupdate wird durchgeführt, danach startet sich die Anlage neu.</p>\
<p>Wird dabei der Strom abgeschltet sind reboots die Folge! Danach nur mehr Zugriff per FTP.</p>\
<p>Dieser Vorgang kann einige Minuten dauern. Bitte haben Sie Geduld.</p>|' "$1"

sed -i -e 's|Reboot wird durchgeführt|Update und Reboot wird durchgeführt|' "$1"

sed -i -e "/<p>Der Neustart dauert ungefähr eine Minute, bitte haben Sie einen Moment Geduld/d" "$1"
sed -i -e "/wurde nicht/d" "$1"

#update_not_signed.html
sed -i -e 's|Neustart</DIV>|OK</DIV>|' "$1"

sed -i -e "/Verwenden Sie ausschlie.lich vom Hersteller freigegebene Firmware/d" "$1"
sed -i -e "/die volle Unterst.tzung der Funktionalit.t des Ger.tes sicherstellen kann/d" "$1"
sed -i -e "/W.hlen Sie 'Neustart', um den aktuellen Firmwarestand beizubehalten. Die Anlage muss/d" "$1"
sed -i -e "/daf.r neu gestartet werden/d" "$1"


sed -i -e "s|^.*Hersteller freigegebene Firmware.*$|<span style=\"color:#cc0000\"><b>Achtung!</b><br>Im Ernstfall kann immer noch per FTP\n\
         unter einer der folgenden Adressen '192.168.178.1, 192.168.2.1, 192.168.1.1' auf die\n\
	 Box zugegriffen werden.</span></p>|" "$1"


sed -i -e 's|Die Nutzung von nicht durch den Hersteller freigegebener Firmware kann zum kompletten Funktionsverlust Ihres Gerätes|Wenn Sie fehlerhafte Firmware in der FRITZ!Box installieren, kann dies zum normalen\
Funktionsverlust der FRITZ!Box führen.</p>\
<p>Verwenden Sie ausschließlich Firmware, die für dieses Gerät erstellt wurde.</p>\
<p>Firmware-Dateien für Ihre FRITZ!Box sind:</p>\
<p>- für Ihr FRITZ!Box-Modell erstellt worden|' "$1"

sed -i -e "/führen. Es droht der Verlust sämtlicher Ansprüche auf Support, Garantie oder Gewährleistung für Ihr Gerät/d" "$1"
#<--tcom

#-->avm de
#/usr/www/avm/html/tools/flash.html
#/usr/www/avm/html/tools/flash2.html

sed -i -e "/Achtung: W/d" "$1" 

sed -i -e 's|Wenn das Blinken der INFO-LED aufgeh.rt hat, k.nnen Sie sich erneut an der Anlage anmelden.|Achtung: Während des Firmware-Updates blinkt oder leuchtet die INFO-LED (oder T-DSL-LED) permanent. In dieser Zeit darf die Stromversorgung der Anlage <b>nicht</b> unterbrochen werden.<br><br>\
Wenn das Blinken der INFO-LED aufgehört hat oder die T-DSL-LED erloschen ist, können Sie den Speedport neu booten (Netzstecker ziehen).<br><br>\
Je nach Firmware sind die Netzwerkeinstellungen am PC anzupassen, oder erneut per DHCP zu beziehen (Restart der Netzwerkeinstellungen).<br>\
Die Adresse des Speedports kann entweder 192.168.178.1 oder 192.168.2.1 sein, die Eingabe von "Fritz.Box" ist nicht ausreichend, wenn sich die Adresse geändert hat.<br>\
Nach Reboot der Box muss diese resetet und auf WERKSEINSTELLUNG zurück gestellt werden. (Entweder über WebGUI oder angeschlossenem Telefon durch die Eingabe von #991*15901590*). <br><br>|' "$1"

sed -i -e 's|Dieser Vorgang kann bis zu|Der Updatevorgang kann bis zu|' "$1"


#/www/avm/html/tools/update_not_signed.html
sed -i -e "/Nur daf.r kann AVM die volle Unterst.tzung der Funktionalit.t Ihrer /d" "$1"
sed -i -e "/Freigegebene Firmware-Dateien f.r Ihre FRITZ!Box sind/d" "$1"
sed -i -e "/Ihr FRITZ!Box-Modell erstellt/d" "$1"
sed -i -e "/mindestens so aktuell/d" "$1"
sed -i -e "/von AVM erstellt und herausgegeben/d" "$1"
#sed -i -e "/form name=.Restart./d" "$1" 
sed -i -e "s|Die angegebene Datei enth.lt keine von AVM f.r dieses Ger.t freigegebene Firmware.|Im Ernstfall kann immer noch per FTP unter einer der folgenden Adressen '192.168.178.1, 192.168.2.1, 192.168.1.1' auf die Box zugegriffen werden.|" "$1"

sed -i -e "s|^.*Wenn Sie nicht freigegebene Firmware in der FRITZ!Box installieren.*$|<p class=\"mb10\">Wenn Sie fehlerhafte Firmware in der FRITZ.Box installieren, kann dies zum normalen Funktionsverlust der FRITZ!Box führen.</\p>\n\
<p class=\"mb10\">Verwenden Sie ausschließlich Firmware, die für dieses Gerät und Modell erstellt wurde.<\/p>|" "$1"

sed -i -e 's|Update abbrechen (empfohlen)|Update abbrechen|' "$1"
sed -i -e 's|Update fortsetzen|Update fortsetzen (empfohlen)|' "$1"

fi
#update_not_signed_no_password
#sed -i -e 's|..tools.update_not_signed_no_password.html:9817..| Update|' u
sed -i -e 's|..tools.update_not_signed_no_password.html:7014..| Achtung: WÃ¤hrend des Firmware-Updates blinkt die INFO-LED permanent. In dieser Zeit darf die Stromversorgung der Anlage nicht ausgeschaltet werden.|' \
 -e 's|..tools.update_not_signed_no_password.html:8264..| Wenn das Blinken der INFO-LED aufgehÃ¶rt hat, kÃ¶nnen Sie den Speedport neu booten (Netzstecker ziehen). Normalerweise startet dieser selbstÃ¤ndig neu.|' \
 -e 's|..tools.update_not_signed_no_password.html:6152..| Je nach Firmware sind die Netzwerkeinstellungen am PC anzupassen, oder erneut per DHCP zu beziehen (Restart der Netzwerkeinstellungen).| '\
 -e 's|..tools.update_not_signed_no_password.html:7001..| Die IP Adresse des Speedports kann entweder 192.168.178.1 oder 192.168.2.1 sein, wenn sich die Adresse geÃ¤ndert hat die Eingabe von "Fritz.Box" ist nicht ausreichend.|' \
 -e 's|..tools.update_not_signed_no_password.html:4469..| Nach Reboot der Box sollte diese auf WERKSEINSTELLUNG zurÃ¼ck gestellt werden. (Entweder Ã¼ber WebGUI oder angeschlossenem Telefon durch die Eingabe von #991*15901590*). |' \
 -e 's|..tools.update_not_signed_no_password.html:7578..| Wurde die Option "clear mtd3 und mtd4" verwendet, ist kein erneuter Werksreset erforderlich.|' \
 -e 's|..tools.update_not_signed_no_password.html:8821..| Der Updatevorgang kann bis zu zehn Minuten dauern.|' "$1"
#-e 's|..txtNext..|Update fortsetzen|' "$1"


#<--avm de


#-->avm en


#/usr/www/avme/en/html/flash.html
sed -i -e 's|^.*LED stops flashing you can log on to the system again.|<div class="foredialog" style="text-align:center;">Transmitting the firmware to your system.<br>\
<br> This process may take several minutes.<br> Please be patient.<br>\
<br> ATTENTION: While the system is restarting the INFO- LED will flash or depending on the Speeporttype the DSL-LED or POWER-LED is permanent on.\
During this update process the system may <b>not</b> be disconnected from the power mains.<br><br>\
When INFO-LED stops or the POWER-LED starts flashing you may restart your Speedport after some time by disconnecting from the power mains again.\
<br> After loading new firmware the IP Address of the BOX may be changed, in most cases it will be 192.168.2.1 or 192.192.178.1<br>\
<br> If this is the case, make sure to reset the Speedpoert once more. The settings of the PC net card must be set to the new IP-Address or automatically set up via DHCP by restarting.<br>\
<br> First action should be to set FACTORY DEFAULT! (via phone: #991*15901590*)<br> This may again affect IP Settings of your box.\
T-com Default IP is: 192.168.2.1 AVM default IP: 192.168.178.1<br><br>|' "$1"
sed -i -e 's|Continue Update|Continue Update (Recommended)|' "$1"
sed -i -e 's|Cancel Update (Recommended)|Cancel Update|' "$1"

#/usr/www/avme/en/html/tools/update_not_signed.html
sed -i -e "/released for this device by AVM/d" "$1"
sed -i -e "/for your FRITZ!Box are/d" "$1"
sed -i -e "/generated and publicized by AVM/d" "$1"
sed -i -e "/generated for your FRITZ!Box model/d" "$1"
sed -i -e "/created for your FRITZ!Box model/d" "$1"
sed -i -e "/at least as up to date as the firmware/d" "$1"

sed -i -e 's|("uiReboot")|("uiInstall")|' "$1"

sed -i -e "/<b>Warning!/d" "$1"
sed -i -e "/non-released firmware/d" "$1"
sed -i -e "/guarantees and warranty/d" "$1"

sed -i -e 's|^.*can ensure the complete range of FRITZ!Box functions.</p>|<p class="mb10"><span style="color:#cc0000"><b>Attention!</b><br>If an extreme situation happens and the web interface is not reachable any more, you can still connect via FTP by using one of following IP Addresses: 192.168.178.1, 192.168.2.1, 192.168.1.1.</span></p>\
<p class="mb10">Only one of the suggested IP Addresses will be active at boot time as long as the power led is flashing, so you my have to tray one after the other.</p>\
<p class="mb10">If you install faulty firmware into the FRITZ!Box, it can result in the complete loss of FRITZ!Box functionality.</p>\
<p class="mb10">After loading new firmware the IP Address of the BOX may be changed, in most cases it will be 192.168.2.1 or 192.192.178.1</p>\
<p class="mb10">If this is the case the settings of the PC net card must be reset to the new one or automatically set up via DHCP by restarting.</p>\
<p class="mb10">Use only firmware that has been released for this device.</p>|' "$1"
#<--avm en
}

if [ -f $1/etc/htmltext_de.db ];then
#allin one variante ---->
#lengh of lines must be exact the same as teh original!!
#replacing text in binary file is rahter problematic!
let FileSize1="$(wc -c < "$1/etc/htmltext_de.db")"
sed -i -e '
s|<br>       Wenn das Blinken der INFO-LED aufgeh..rt hat, k..nnen Sie sich erneut an der Anlage anmelden.|\
<br> Die Box IP ist danach entweder 192.168.178.1 oder 192.168.2.1. PC Restart kann erforderlich sein. |
s|Die angegebene Datei enth..lt keine von AVM f..r dieses Ger..t freigegebene Firmware.|\
Im Ernstfall bei Reboots der Box: PC IP statish, Skriptoption "Clear mtd3 und mtd4"!|
s|Wenn Sie nicht freigegebene Firmware in der FRITZ!Box installieren, kann dies zum kompletten Funktionsverlust der FRITZ!Box f..hren. Weiterhin verlieren Sie alle Anspr..che auf Support, Garantie und Gew..hrleistung f..r Ihre FRITZ!Box.|\
Im Ernstfall kann immer noch mit einen gepatchten Recover (Windows) oder per FTP (Windows und LINUX) unter einer der folgenden Adressen auf die Box zugegriffen werden. (192.168.178.1, 192.168.2.1, 192.168.1.1)                          |
s|Verwenden Sie ausschlie..lich Firmware, die von AVM f..r dieses Ger..t freigegeben ist. Nur daf..r kann AVM die volle Unterst..tzung der Funktionalit..t Ihrer FRITZ!Box sicherstellen.|\
Je nach Firmware sind die Netzwerkeinstellungen am PC anzupassen, oder erneut per DHCP zu beziehen, -Restart der Netzwerkeinstellungen-. Die Adresse des Speedports kann entwerder   |
s|Freigegebene Firmware-Dateien f..r Ihre FRITZ!Box sind:|Die IPAdr. der Box ist: 192.168.178.1 oder 192.168.2.1.|
s|von AVM erstellt und herausgegeben|Nach Reboot ueber GUI die Box auf |
s|f..r Ihr FRITZ!Box-Modell erstellt|WERKSEINSTELLUNG zurÃ¼kstellen!   |
s|mindestens so aktuell, wie die auf der FRITZ!Box installierte Firmware|Oder mit angeschlossenem Telefon durch die Eingabe von #991*15901590*.|
s|abbrechen (empfohlen)|abbrechen            |
' "$1"/etc/htmltext_de.db
let FileSize2="$(wc -c < "$1/etc/htmltext_de.db")"
if  [ $FileSize1 -ne $FileSize2 ]; then
	echo "--------------Patch of htmltext_de.db went wrong!---------------"
	echo "Original Filesize=$FileSize1 Changed Filesize=$FileSize2"
	sleep 10
fi
#<----all variante
#en variante ---->
#lengh of lines must be exact the same as teh original!!
#replacing text in binary file is rahter problematic!
if [ -e "$1/etc/htmltext_en.db" ];then
let FileSize1="$(wc -c < "$1/etc/htmltext_en.db")"
sed -i -e '
s|When the .INFO. LED stops flashing you can log on to the system again.|\
Box IP is: 192.168.178.1 oder 192.168.2.1. PC Restart may be needed. | 
s|The specified file does not contain firmware released for this device by AVM.|\
If box is rebooting: Set static IPs, and script option "Clear mtd3 and mtd4"| 
s|If you install non-released firmware in the FRITZ!Box, it can result in the complete loss of FRITZ!Box functionality. Further, you will lose all claims to support, guarantees and warranty for your FRITZ.Box.|\
If you cant get to the webintreface any more, you can use a patched recover tool, or FTP (Windows or LINUX) one of the following Addresses should work. (192.168.178.1, 192.168.2.1, 192.168.1.1)             | 
s|Only use firmware that has been released for this device by AVM. Only for such firmware AVM can ensure the complete range of FRITZ!Box functions.|\
Depending on the Firmware you must adjust the network settings on your PC to the new address or renew DHCP, by resetting network adapter.       |
s|The firmware files released for your FRITZ.Box are.|\
Box IP Address: 192.168.178.1 or 192.168.2.1.     |
s|generated and publicized by AVM|\
Set Box after reboot to:      | 
s|created for your FRITZ!Box model|\
FACTORY DEFAULT                | 
s|at least as up to date as the firmware installed on the FRITZ.Box|\
Or with a connected phone, by typing in: #991*15901590*.        | 
s|Cancel Update (Recommended)|\
        Cancel Update     | 
' "$1"/etc/htmltext_en.db
let FileSize2="$(wc -c < "$1/etc/htmltext_en.db")"
if  [ $FileSize1 -ne $FileSize2 ]; then
	echo "--------------Patch of htmltext_en.db went wrong!---------------"
	echo "Original Filesize=$FileSize1 Changed Filesize=$FileSize2"
	sleep 10
fi
fi
#<---- en variante
fi
#addon source toolsdir is different if original t-com firmware is patched
Lang="${avm_Lang}"
[ "$ORI" = "y" ] && Lang="tcom"



for OEMDIR in ${OEMLIST}; do
  export HTML="$OEMDIR/html"
 for html in ${HTML} ${HTML}/de ; do
  for FILE in downgrade.html flash.html flash2.html update_not_signed.html update_not_signed_no_password.html restart.html update_result.html; do
      DSTI="${1}"/usr/www/${html}/${FILE}
      if [ -f ${DSTI} ] ; then
       echo2 "      patch update page (${Lang}) ${html}/${FILE}..."
	patch_flash_txt	${DSTI}
      fi
      DSTI="${1}"/usr/www/${html}/tools/$FILE
      if [ -f ${DSTI} ] ; then
       echo2 "      patch update page (${Lang}) ${html}/tools/${FILE}..."
	patch_flash_txt ${DSTI}
      fi
  done
 done
done

exit 0




