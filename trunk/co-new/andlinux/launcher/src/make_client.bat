@echo off

set APPNAME=%~1
set APPCOMMAND=%~2
set ICON=%~3

del client.c
copy client.c.part1 client.c > nul

IF "%4" == "cmd" (
	echo #define COMMAND_AS_ARG>> client.c
) ELSE (
	echo #undef COMMAND_AS_ARG>> client.c
	IF "%4" == "app" (
		echo #define USERDEF_APP>> client.c
	) ELSE (
		echo #undef USERDEF_APP>> client.c
	)
)

copy client.c+client.c.part2 client.c > nul
echo char *g_progName = "%APPNAME%";>> client.c
echo char *g_command = "%APPCOMMAND%";>> client.c
copy client.c+client.c.part3 client.c > nul

del client.rc
copy client.rc.part1 client.rc > nul
echo IDI_MAIN ICON %ICON%>> client.rc

make client > nul
move client.exe and%APPNAME%.exe

make clean > nul
