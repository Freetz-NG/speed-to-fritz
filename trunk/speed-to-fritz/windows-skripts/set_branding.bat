@echo off
::COLOR 02
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: pushconfig waits for Speedport's ping replay after reboot to          
:: automatically set branding via ftp (adam2)        
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Note:
::   1. There is NO guarantee that it works with all Windows versions,
::	    only tested with Vista up to now. 
::   2. You need the 'ping' command from Windows (tested on Vista).
::      package (please uninstall or change path so Windows
::      version is found first), because some versions have no timeout.
::   3. Setup you PC netcard to static settings: 
::      IP: 192.160.178.19
::      MASK: 255.255.0.0
::      GW: 192.168.178.1
::---------------------------------------------------------------------------------------------------------------
::---------------------------------------------------------------------------------------------------------------
:pushconfig
:: Set this to "tcom" if you are flashing back the original TCOM kernel 
:: Some englsh and multilingual Version use OEM "avme", most other Firmwares use "avm"
set OEM=tcom
::Your adam FTP IP address
set IP=192.168.178.1
::---------------------------------------------------------------------------------------------------------------
::---------------------------------------------------------------------------------------------------------------
::---------------------------------------------------------------------------------------------------------------
:START
::---------------------------------------------------------------------------------------------------
echo open %IP%>ftp.txt
echo user adam2 adam2>>ftp.txt
echo debug>>ftp.txt
echo binary>>ftp.txt
echo hash>>ftp.txt
echo quote SETENV firmware_version %OEM%>>ftp.txt
echo quote SETENV autoload yes>>ftp.txt
echo quote SETENV my_ipaddress 192.168.178.1>>ftp.txt
echo quit>>ftp.txt
echo ********************************************************************************
echo.
echo --- Set branding to %OEM% ---
echo.
echo --------------------------------------------------------------------------------
echo PC LAN settings:
netsh interface ip dump | FIND "192.168.178" | FIND /V "192.168.178.1 " | FIND /V "192.168.2.1 " 
echo --------------------------------------------------------------------------------
IF %errorlevel% EQU 0 GOTO :configfound
echo  No suitable local PC LAN address found!
echo  Your LAN Card must be set to static IP settings:
echo  ADRESS: 192.168.178.19 MASK: 255.255.0.0 GW: 192.168.178.1
echo  No WLANs are supported, use "setstatcIP192_168_178_19.bat" to set PC LAN!
echo --------------------------------------------------------------------------------
pause
:configfound
echo.
echo  Check the following setting, if you want something different, edit this file.
echo.
echo    OEM: %OEM%
echo --------------------------------------------------------------------------------
echo.
echo.
echo.
echo You should now reboot your box. Waiting for box to shut down for restart ...
echo --------------------------------------------------------------------------------
:ping1
	ping -n 1 %ip% >nul
	:: while 1
	IF NOT %errorlevel% EQU 0 GOTO ping2
	(Set /P i=.) < NUL
	ping -n 1 %ip% >nul
	IF NOT %errorlevel% EQU 0 GOTO ping2
GOTO ping1
:ping2
	::while 0
	ping -n 1 %ip% >nul
	IF %errorlevel% EQU 0 GOTO done
	(Set /P i=,) < NUL
	GOTO ping2
:done
echo.
echo Box is back up again or timeout happend. Initiating Adam2 FTP ...
echo --------------------------------------------------------------------------------
echo.
echo.
ftp -n -s:ftp.txt>log.txt 
type log.txt | FIND /V /i "quote" | FIND /V /i "quit" | FIND /V /i "USER" | FIND /V /i "PASS" | FIND /V "command successful"
type log.txt | FIND "command successful" >nul
IF %errorlevel% EQU 0 GOTO :altIP
GOTO :exit0
:altIP
echo Once more with alternativ BOX IP ...
echo --------------------------------------------------------------------------------
echo.
echo.
set IP=192.168.2.1
IF %errorlevel% EQU 0 GOTO :exit0
	echo --------------------------------------------------------------------------------
	echo Connection could not be established, check your PC LAN settings again!
	echo "setstatcIP192_168_178_19.bat" should do the static settings you need.
	echo Dont use anything in between the box and the PC only a single LAN connectin,
	echo Box LAN1 -> PC LAN (Hubs in beteen my work, but make sure there is no 
	echo other equiptment on the net).
	echo --------------------------------------------------------------------------------
pause
::exit0
exit 0
