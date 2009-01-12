::Example:
::getlanid.vbs /h
getlanid.vbs /w
::cscript.exe getlanid.vbs /s  "TAP-Win32 Adapter V8 (coLinux)" "192.168.11.1" "255.255.255.0" 

::getlanid.vbs /s  "TAP-Win32 Adapter V8 (coLinux)" "192.168.11.20" "255.255.255.0" "192.168.11.1"

::getlanid.vbs /s "TAP-Win32 Adapter V8 (coLinux)" 192.168.11.1 255.255.255.0
getlanid.vbs /s %1 %2


::pause