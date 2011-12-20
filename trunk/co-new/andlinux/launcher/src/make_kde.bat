@echo off

echo compiling menu ...
call make_menu.bat kmenu.ico
move /Y menu.exe ..\kde\

echo compiling clients ...
call make_client.bat Konsole konsole ..\kde\konsole.ico
call make_client.bat Dolphin dolphin ..\kde\dolphin.ico
call make_client.bat Kate "kate --use" ..\kde\kate.ico

call make_client.bat Kile kile ..\kde\kile.ico
call make_client.bat Okular okular ..\kde\okular.ico
call make_client.bat GwenView gwenview ..\kde\gwenview.ico

call make_client.bat Konqueror konqueror ..\kde\konqueror.ico
call make_client.bat KMail kmail ..\kde\kmail.ico
call make_client.bat KOrganizer korganizer ..\kde\korganizer.ico
call make_client.bat Kontact kontact ..\kde\kontact.ico

call make_client.bat KWord kword ..\kde\kword.ico
call make_client.bat KSpread kspread ..\kde\kspread.ico
call make_client.bat KPresenter kpresenter ..\kde\kpresenter.ico
call make_client.bat Kexi kexi ..\kde\kexi.ico
call make_client.bat Kivio kivio ..\kde\kivio.ico
call make_client.bat Karbon karbon ..\kde\karbon.ico
call make_client.bat Krita krita ..\kde\krita.ico
call make_client.bat KPlato kplato ..\kde\kplato.ico
call make_client.bat KChart kchart ..\kde\kchart.ico
rem call make_client.bat KFormula kformula ..\kde\kformula.ico
call make_client.bat Kugar kugar ..\kde\kugar.ico

call make_client.bat SystemSettings systemsettings ..\kde\systemsettings.ico
call make_client.bat KSysGuard ksysguard ..\kde\ksysguard.ico
move /Y and*.exe ..\kde\

call make_client.bat Cmd "" andLinux.ico cmd
move /Y andCmd.exe ..\kde\
call make_client.bat App "" andLinux.ico app
move /Y andApp.exe ..\kde\
