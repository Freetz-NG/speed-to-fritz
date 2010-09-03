#!/bin/bash
 . $include_modpatch
	
echo "-- adding 'LAN 2-4' ..."

echo2 "  -- patching files:"
echo2 "      /usr/www/$OEM/html/de/home/home.html"
sed -i -e 's|^.*txt006 .*$|\t\t\t\t\t\t\t<td style="width:207px"><? echo $var:txt038 ?></td>\n\t\t\t\t\t\t</tr>\n\t\t\t\t\t\t<tr>\
\t\t\t\t\t\t\t<td><script type="text/javascript">document.write(StateLed("<\? query eth1:status/carrier ?>"));</script></td>\
\t\t\t\t\t\t\t<td><? echo $var:txt039 ?></td>\n\t\t\t\t\t\t</tr>\n\t\t\t\t\t\t<tr>\
\t\t\t\t\t\t\t<td><script type="text/javascript">document.write(StateLed("<? query eth2:status/carrier ?>"));</script></td>\
\t\t\t\t\t\t\t<td><? echo $var:txt040 ?></td>\n\t\t\t\t\t\t</tr>\n\t\t\t\t\t\t<tr>\
\t\t\t\t\t\t\t<td><script type="text/javascript">document.write(StateLed("<? query eth3:status/carrier ?>"));</script></td>\
\t\t\t\t\t\t\t<td><? echo $var:txt041 ?></td>|' "$1"/usr/www/$OEM/html/de/home/home.html

echo2 "      /usr/www/$OEM/html/de/help/hilfe_status.html"
sed -i -e 's|^.*"TOP">LAN</td>$|\t\t\t\t<td valign="TOP">LAN 1</td>|' "$1"/usr/www/$OEM/html/de/help/hilfe_status.html
sed -i -e 's|^.*&quot;LAN&quot;.*$|\t\t\t\t<td valign="TOP">Zeigt an, ob Computer am Netzwerkanschluss &quot;LAN 1&quot; der FRITZ!Box angeschlossen sind\.</td>\
\t\t\t</tr>\n\t\t\t<tr>\n\t\t\t\t<td valign="TOP">LAN 2</td>\
\t\t\t\t<td valign="TOP">Zeigt an, ob Computer am Netzwerkanschluss &quot;LAN 2&quot; der FRITZ!Box angeschlossen sind\.</td>\
\t\t\t</tr>\n\t\t\t<tr>\n\t\t\t\t<td valign="TOP">LAN 3</td>\
\t\t\t\t<td valign="TOP">Zeigt an, ob Computer am Netzwerkanschluss &quot;LAN 3&quot; der FRITZ!Box angeschlossen sind\.</td>\
\t\t\t</tr>\n\t\t\t<tr>\n\t\t\t\t<td valign="TOP">LAN 4</td>\n\
\t\t\t\t<td valign=\"TOP\">Zeigt an, ob Computer am Netzwerkanschluss &quot;LAN 4&quot; der FRITZ!Box angeschlossen sind\.</td>|' "$1"/usr/www/$OEM/html/de/help/hilfe_status.html
			
echo2 "  -- changing 'LAN' to 'LAN 1' in:"
echo2 "      /usr/www/$OEM/html/de/help/hilfe_internetdual.html"
sed -i -e "s/'LAN'/'LAN 1'/" "$1"/usr/www/$OEM/html/de/help/hilfe_internetdual.html
		
echo2 "      /usr/www/$OEM/html/de/internet/internet_expert.js"
sed -i -e 's|var g_mldLan1[\t]*= "LAN";|var g_mldLan1\t\t\t= "LAN 1";|' "$1"/usr/www/$OEM/html/de/internet/internet_expert.js
sed -i -e 's|var g_mldLan2[\t]*= "";|var g_mldLan2\t\t\t= "LAN 2, LAN 3, LAN 4";|' "$1"/usr/www/$OEM/html/de/internet/internet_expert.js

echo2 "      /usr/www/$OEM/html/de/internet/internet_expert.inc"
sed -i -e "s/'Internetzugang über LAN'/'Internetzugang über LAN 1'/" "$1"/usr/www/$OEM/html/de/internet/internet_expert.inc
sed -i -e 's|"Internetzugang über LAN"|"Internetzugang über LAN 1"|' "$1"/usr/www/$OEM/html/de/internet/internet_expert.inc

echo2 "      /usr/www/$OEM/html/de/system/netipadr.js"
sed -i -e 's|"Internetzugang über LAN"|"Internetzugang über LAN 1"|' "$1"/usr/www/$OEM/html/de/system/netipadr.js

echo2 "      /usr/www/$OEM/html/de/first/first_ISP_1_dual.inc"
sed -i -e "s/'Internetzugang über LAN'/'Internetzugang über LAN 1'/" "$1"/usr/www/$OEM/html/de/first/first_ISP_1_dual.inc

exit 0
