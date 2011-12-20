@echo off

echo compiling menu ...
call make_menu.bat andLinux.ico
move /Y menu.exe ..\xfce\

echo compiling clients ...
call make_client.bat Terminal xfce4-terminal ..\xfce\xfce4_terminal.ico
call make_client.bat Thunar thunar ..\xfce\thunar.ico
call make_client.bat Mousepad mousepad ..\xfce\mousepad.ico
move /Y and*.exe ..\xfce\
call make_client.bat Cmd "" andLinux.ico cmd
move /Y andCmd.exe ..\xfce\
call make_client.bat App "" andLinux.ico app
move /Y andApp.exe ..\xfce\
