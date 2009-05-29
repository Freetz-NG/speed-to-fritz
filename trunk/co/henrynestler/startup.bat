@echo off
taskkill /F /IM xming.exe
taskkill /F /IM menu.exe
cd .\Launcher
start menu.exe
cd ..
set COLINUX_CONSOLE_FONT=Lucida Console:14
set COLINUX_CONSOLE_EXIT_ON_DETACH=1

start "andServer (coLinux)" /min colinux-daemon.exe -d -k @settings.txt
