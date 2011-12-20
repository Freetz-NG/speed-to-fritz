::Example:
::cscript.exe getlanid.vbs /h
::cscript.exe getlanid.vbs /s "TAP-Win32 Adapter V8 (coLinux)" "192.168.11.1" "255.255.255.0" 
::cscript.exe getlanid.vbs /s "TAP-Win32 Adapter V8 (coLinux)" "192.168.11.20" "255.255.255.0" "192.168.11.1"
::cscript.exe getlanid.vbs /s "TAP-Win32 Adapter V8 (coLinux)" 192.168.11.1 255.255.255.0
:: Undo settings if a older version was in use
::if exist netz.txt netsh.exe -f netz.txt
netsh.exe interface dump > netz.txt
::netsh int ip reset resetlog.txt
::No need to change the name but to keep it compatibel with older versions i stay with the name LAN1
netsh interface set interface name="LAN-Verbindung" newname="LAN1" >nul
::netsh interface set interface name="LAN-Verbindung 1" newname="LAN2" >nul
::netsh interface set interface name="LAN-Verbindung 2" newname="LAN3" >nul
::netsh interface set interface name="LAN-Verbindung 3" newname="LAN4" >nul
::netsh interface set interface name="LAN-Verbindung 4" newname="LAN5" >nul

:: Find the name of "TAP-Win32 Adapter V8 (coLinux)" Adapter and write the name to connection1Name.txt
:: Only the name is needed by the installer to set up the correct IP for the TAP adpter.
cscript.exe getlanid.vbs /w
:: Set IP this way first because in some cases the later instance of netsh called from inside the instllet fails.
:: To keep it compatibel this is done twice, would need to make sure it works for XP also without setting it with netsh
cscript.exe getlanid.vbs /s %1 %2

::pause
