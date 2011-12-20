@echo off
taskkill /F /IM xming.exe 1> nul 2> nul
::taskkill /F /IM menu.exe 1> nul 2> nul
::cd .\Launcher
::start menu.exe
::cd ..
set COLINUX_CONSOLE_FONT=Lucida Console:12
set COLINUX_CONSOLE_EXIT_ON_DETACH=1
:: Enable the following line by removing the "::" if you want to use all core 2 of the CPU.
set COLINUX_NO_CPU0_WORKAROUND=Y
:: Temporary copy settings.txt
set coParameter="%TEMP%\coParameter.txt"
del "%coParameter%"
for /f "delims=*" %%i in ('findstr /b /i /v "DISPLAY" "settings.txt"') do echo %%i>>"%coParameter%"
::Get local active IPs
cscript.exe get-activ-ip-adr.vbs %coParameter%
start "speedServer (coLinux)" /min colinux-daemon.exe -d -k @%coParameter%
::pause
