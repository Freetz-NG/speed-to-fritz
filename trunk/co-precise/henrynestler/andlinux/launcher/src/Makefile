all: client menu

client:
	brc32 -r -IC:\Programme\BCC55\Include client.rc
	bcc32 -c -IC:\Programme\BCC55\Include client.c
	ilink32 -Gn -Tpe -aa -x -LC:\Programme\BCC55\Lib -LC:\Programme\BCC55\Lib\PSDK c0w32.obj client.obj, client.exe,, cw32.lib shell32.lib user32.lib kernel32.lib ws2_32.lib advapi32.lib,, client.res

menu:
	brc32 -r -IC:\Programme\BCC55\Include menu.rc
	bcc32 -c -IC:\Programme\BCC55\Include menu.c
	ilink32 -Gn -Tpe -aa -x -LC:\Programme\BCC55\Lib -LC:\Programme\BCC55\Lib\PSDK c0w32.obj menu.obj, menu.exe,, cw32.lib shell32.lib user32.lib kernel32.lib ws2_32.lib advapi32.lib gdi32.lib comctl32.lib,, menu.res

clean:
	-@if exist *.obj del *.obj >nul
	-@if exist *.res del *.res >nul
	-@if exist *.tds del *.tds >nul
