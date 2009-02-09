::Example:
::getlanid.vbs /h
::cscript.exe getlanid.vbs /s  "TAP-Win32 Adapter V8 (coLinux)" "192.168.11.1" "255.255.255.0" 
::getlanid.vbs /s  "TAP-Win32 Adapter V8 (coLinux)" "192.168.11.20" "255.255.255.0" "192.168.11.1"
::getlanid.vbs /s "TAP-Win32 Adapter V8 (coLinux)" 192.168.11.1 255.255.255.0

netsh interface set interface name="LAN-Verbindung" newname="LAN1" 
netsh interface set interface name="LAN-Verbindung 1" newname="LAN2" 
netsh interface set interface name="LAN-Verbindung 2" newname="LAN3" 
netsh interface set interface name="LAN-Verbindung 3" newname="LAN4" 
netsh interface set interface name="LAN-Verbindung 4" newname="LAN5" 

getlanid.vbs /w
::getlanid.vbs /s %1 %2


::pause