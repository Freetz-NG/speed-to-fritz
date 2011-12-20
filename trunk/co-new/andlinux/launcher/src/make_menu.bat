@echo off

set ICON=%~1

del menu.rc
copy menu.rc.part1 menu.rc > nul
echo IDI_MAIN ICON %ICON%>> menu.rc

make menu > nul
make clean > nul
