@echo off
taskkill /F /IM xming.exe > nul
taskkill /F /IM menu.exe > nul
cd .\Launcher
start menu.exe
cd ..
::Next Line is not useabel with Revision 1464
set COLINUX_CONSOLE_FONT=Lucida Console:12
set COLINUX_CONSOLE_EXIT_ON_DETACH=1
:: Enable the following line by removing the "::" if you want to use all core CPUs.
set COLINUX_NO_CPU0_WORKAROUND=Y

start "andServer (coLinux)" /min colinux-daemon.exe -d -k @settings.txt
