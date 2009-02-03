;Cooperative Linux installer
;Written by NEBOR Regis
;Modified by Dan Aloni (c) 2004
;Modified 8/20/2004,2/4/2004 by George P Boutwell
;Modified 4/20/2008 by Henry Nestler

;-------------------------------------
;Modified 12/06/2008 by Johann Pascher

  !include "MUI.nsh"
  !include "x64.nsh"
  !include Sections.nsh
  !define ALL_USERS
  !include WriteEnvStr.nsh
  !include "coLinux_def.inc"
  !define PUBLISHER "freetzlinux.sourceforge.net"

  ;General
  Name "Cooperative Linux ${VERSION}"
  OutFile "freetzLinux.exe"

  ;ShowInstDetails show
  ;ShowUninstDetails show

  ;Folder selection page
  InstallDir "$PROGRAMFILES\andLinux"

  ;Get install folder from registry if available
  InstallDirRegKey HKCU "Software\andLinux" ""

  BrandingText "${PUBLISHER}"

  VIAddVersionKey ProductName "freetzLinux"
  VIAddVersionKey CompanyName "${PUBLISHER}"
  VIAddVersionKey ProductVersion "${VERSION}"
  VIAddVersionKey FileVersion "${VERSION}"
  VIAddVersionKey FileDescription "An optimized virtual Linux system for Windows"
  VIAddVersionKey LegalCopyright "Copyright @ 2004-2007 ${PUBLISHER}"
  VIProductVersion "${LONGVERSION}"

  !define MUI_ICON "scripts\andlinux.ico"
  !define MUI_ICON0 "scripts\colinux.ico"
  !define MUI_ICON1 "scripts\start.ico"
  !define MUI_ICON2 "scripts\sto.ico"
  SetCompressor lzma

  XPStyle on

; For priority Unpack
  ReserveFile "iDl.ini"
  ReserveFile "WinpcapRedir.ini"
  !insertmacro MUI_RESERVEFILE_INSTALLOPTIONS

;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING
  !define MUI_FINISHPAGE_NOAUTOCLOSE

;--------------------------------
;Pages

  !define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_BITMAP "header.bmp"
  !define MUI_SPECIALBITMAP "startlogo.bmp"

  !define MUI_COMPONENTSPAGE_SMALLDESC

  !define MUI_WELCOMEPAGE_TITLE "Welcome to the freetzLinux ${VERSION} Setup Wizard"
  !define MUI_WELCOMEPAGE_TEXT "This wizard will guide you through the update to freetzLinux, \
  Linux image is not included with this installation! \r\n\r\n \ 
  The image File base.drv must be placed in advance into the sub directory /Drives. \r\n\r\n \
  Any andLinux or coLinux image may be used. \r\n\r\n \
  It is recommended to do a andLinux installation in advance without reboot and start. \r\n\r\n \ 
  This installation is basically a Cooperative Linux ${VERSION} with some adaptions for Vista. \r\n\r\n \
  $_CLICK"

  !insertmacro MUI_PAGE_WELCOME

  !insertmacro MUI_PAGE_LICENSE "..\..\..\..\..\..\COPYING"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
;  Page custom WinpcapRedir WinpcapRedirLeave
;  Page custom StartDlImageFunc EndDlImageFunc
  Page custom PageFileSystem PageFileSystemLeave
  Page custom PageNetworking PageNetworkingLeave
  !insertmacro MUI_PAGE_INSTFILES

  !define MUI_FINISHPAGE_LINK "Visit the freetzLinux website"
  !define MUI_FINISHPAGE_LINK_LOCATION "freetzlinux.sourceforge.net"
  !define MUI_FINISHPAGE_SHOWREADME "README.TXT"

  !insertmacro MUI_PAGE_FINISH
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES

;--------------------------------
;Languages
 
  !insertmacro MUI_LANGUAGE "English"


;------------------------------------------------------------------------
;------------------------------------------------------------------------
;Custom Setup for image download

;Variables used to track user choice
  Var LOCATION
  Var RandomSeed

; StartDlImageFunc down for reference resolution

Function EndDlImageFunc
FunctionEnd

Function WinpcapRedirLeave
FunctionEnd

Function .onInit

  !insertmacro MUI_INSTALLOPTIONS_EXTRACT "iDl.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT "WinpcapRedir.ini"

FunctionEnd

;------------------------------------------------------------------------
;------------------------------------------------------------------------
;Installer Sections

SectionGroup "andLinux" SecGrpcoLinux

Section

  ;Check running 64 bit and block it (NSIS 2.21 and newer)
  ${If} ${RunningX64}
    MessageBox MB_OK "andLinux can't run on x64"
    DetailPrint "Abort on 64 bit"
    Abort
  ${EndIf}

  ;-------------------------------------------Uninstall with old driver--
  ;----------------------------------------------------------------------

  ;get the old install folder
  ReadRegStr $R2 HKCU "Software\andLinux" ""
  StrCmp $R2 "" no_old_linux_sys

  ;path without ""
  StrCpy $R1 $R2 1
  StrCmp $R1 '"' 0 +2
    StrCpy $R2 $R2 -1 1

  ;Check old daemon for removing driver
  IfFileExists "$R2\colinux-daemon.exe" 0 no_old_linux_sys

  ;Runs any monitor?
check_running_monitors:
  DetailPrint "Check running monitors"
  nsExec::ExecToStack '"$R2\colinux-daemon.exe" --status-driver'
  Pop $R0 # return value/error/timeout
  Pop $R1 # Log

  ;Remove, if no monitor is running
  Push $R1
  Push "current number of monitors: 0"
  Call StrStr
  Pop $R0
  Pop $R1
  IntCmp $R0 -1 0 remove_linux_sys remove_linux_sys

  ;remove anyway, if no can detect running status
  Push $R1
  Push "current number of monitors:"
  Call StrStr
  Pop $R0
  Pop $R1
  IntCmp $R0 -1 remove_linux_sys

  MessageBox MB_RETRYCANCEL|MB_ICONEXCLAMATION \
             "Any coLinux is running.$\nPlease stop it, before continue" \
             IDRETRY check_running_monitors
  DetailPrint "Abort"
  Abort

remove_linux_sys:
  DetailPrint "Uninstall old linux driver"
  nsExec::ExecToLog '"$R2\colinux-daemon.exe" --remove-driver'
  Pop $R0 # return value/error/timeout

no_old_linux_sys:

  ;------------------------------------------------------------REGISTRY--
  ;----------------------------------------------------------------------

  !define REGUNINSTAL "Software\Microsoft\Windows\CurrentVersion\Uninstall\andLinux"
  !define REGEVENTS "SYSTEM\CurrentControlSet\Services\Eventlog\Application\andLinux"

  WriteRegStr HKLM ${REGUNINSTAL} "DisplayName" "andLinux ${VERSION}"
  WriteRegStr HKLM ${REGUNINSTAL} "UninstallString" '"$INSTDIR\Uninstall.exe"'
  WriteRegStr HKLM ${REGUNINSTAL} "DisplayIcon" "$INSTDIR\colinux-daemon.exe,0"
  WriteRegDWORD HKLM ${REGUNINSTAL} "NoModify" "1"
  WriteRegDWORD HKLM ${REGUNINSTAL} "NoRepair" "1"

  ; plain text in event log view
  WriteRegStr HKLM ${REGEVENTS} "EventMessageFile" "$INSTDIR\colinux-daemon.exe"

#WriteRegStr HKCR Folder\shell\andKonsole\command	"$INSTDIR\Launcher\andKonsole.exe" "%1"
#WriteRegStr HKCR Folder\shell\andKHomeFolder\command	"$INSTDIR\Launcher\andKHomeFolder.exe" "%1"
#WriteRegStr HKCR "*\shell\andKate\command" "$INSTDIR\Launcher\andKate.exe" "%1"

  ;---------------------------------------------------------------FILES--
  ;----------------------------------------------------------------------
  ; Our Files . If you adds something here, Remember to delete it in 
  ; the uninstall section

  SetOutPath "$INSTDIR"
  File "premaid\colinux-daemon.exe"
  File "premaid\linux.sys"
  File "premaid\README.txt"
  #File "premaid\news.txt"
  File "premaid\srvstart.bat"
  File "premaid\srvstop.bat"
  File "premaid\settapip.bat"
  File "premaid\getlanid.vbs"
  File "premaid\colinux-daemon.txt"
  File "premaid\vmlinux"
  File "premaid\vmlinux-modules.tar.gz"
  ; initrd installs modules vmlinux-modules.tar.gz over cofs31 on first start
  File "premaid\initrd.gz"

  ;Backup config file if present
  #IfFileExists "$INSTDIR\example.conf" 0 +2
    #CopyFiles /SILENT "$INSTDIR\example.conf" "$INSTDIR\example.conf.old"
  #File "premaid\example.conf"

  ; Remove kludge from older installations
  Delete "$INSTDIR\packet.dll"
  Delete "$INSTDIR\wpcap.dll"

  ;--------------------------------------------------------------/FILES--
  ;----------------------------------------------------------------------

  ;Store install folder
  WriteRegStr HKCU "Software\andLinux" "" "$INSTDIR"

  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"

SectionEnd

Section "Native Windows Linux Console (NT)" SecNTConsole
  File "premaid\colinux-console-nt.exe"
SectionEnd

Section "Cross-platform Linux Console (FLTK)" SecFLTKConsole
  File "premaid\colinux-console-fltk.exe"
SectionEnd

##Section "Install Launcher dirctory" SecLauncher

#SetOutPath "$INSTDIR\Launcher"

#  File "premaid\Launcher\andCmd.exe" 
#  File "premaid\Launcher\andKChart.exe"
#  File "premaid\Launcher\andKControl.exe"
#  File "premaid\Launcher\andKDVI.exe"
#  File "premaid\Launcher\andKFormula.exe"
#  File "premaid\Launcher\andKGhostView.exe"
#  File "premaid\Launcher\andKHomeFolder.exe"
#  File "premaid\Launcher\andKMail.exe"
#  File "premaid\Launcher\andKOrganizer.exe"
#  File "premaid\Launcher\andKPDF.exe"
#  File "premaid\Launcher\andKPlato.exe"
#  File "premaid\Launcher\andKPresenter.exe"
#  File "premaid\Launcher\andKSpread.exe"
#  File "premaid\Launcher\andKWord.exe"
#  File "premaid\Launcher\andKarbon.exe"
#  File "premaid\Launcher\andKate.exe"
#  File "premaid\Launcher\andKexi.exe"
#  File "premaid\Launcher\andKile.exe"
#  File "premaid\Launcher\andKivio.exe"
#  File "premaid\Launcher\andKonqueror.exe"
#  File "premaid\Launcher\andKonsole.exe"
#  File "premaid\Launcher\andKontact.exe"
#  File "premaid\Launcher\andKrita.exe"
#  File "premaid\Launcher\andKugar.exe"
#  File "premaid\Launcher\karbon.ico"
#  File "premaid\Launcher\kate.ico"
#  File "premaid\Launcher\kchart.ico"
#  File "premaid\Launcher\kcontrol.ico"
#  File "premaid\Launcher\kdvi.ico"
#  File "premaid\Launcher\kexi.ico"
#  File "premaid\Launcher\kformula.ico"
#  File "premaid\Launcher\kghostview.ico"
#  File "premaid\Launcher\khomefolder.ico"
#  File "premaid\Launcher\kile.ico"
#  File "premaid\Launcher\kivio.ico"
#  File "premaid\Launcher\kmail.ico"
#  File "premaid\Launcher\konqueror.ico"
#  File "premaid\Launcher\konsole.ico"
#  File "premaid\Launcher\kontact.ico"
#  File "premaid\Launcher\korganizer.ico"
#  File "premaid\Launcher\kpdf.ico"
#  File "premaid\Launcher\kplato.ico"
#  File "premaid\Launcher\kpresenter.ico"
#  File "premaid\Launcher\krita.ico"
#  File "premaid\Launcher\kspread.ico"
#  File "premaid\Launcher\kugar.ico"
#  File "premaid\Launcher\kword.ico"
#  File "premaid\Launcher\menu.exe"
#  File "premaid\Launcher\menu.txt"
#  File "premaid\Launcher\synaptic.ico"
#  File "premaid\Launcher\volume.ico"

#SectionEnd

Section "Virtual Ethernet Driver (coLinux TAP-Win32)" SeccoLinuxNet

  SetOutPath "$INSTDIR\tuntap"
  
  File "premaid\tuntap\addtap.bat"
  File "premaid\tuntap\deltapall.bat"
  File "premaid\tuntap\tap0901.cat"
  File "premaid\tuntap\tap0901.sys"
  File "premaid\tuntap\tapinstall.exe"
  File "premaid\tuntap\OemWin2k.inf"

  SetOutPath "$INSTDIR\netdriver"

  File "premaid\netdriver\OemWin2k.inf"
  File "premaid\netdriver\tap0801co.sys"
  File "premaid\netdriver\tapcontrol.exe"
  File "premaid\netdriver\tap.cat"

  SetOutPath "$INSTDIR"
  File "premaid\colinux-net-daemon.exe"
SectionEnd

Section "Virtual Network Daemon (SLiRP)" SeccoLinuxNetSLiRP
  File "premaid\colinux-slirp-net-daemon.exe"
SectionEnd

Section "Bridged Ethernet (WinPcap)" SeccoLinuxBridgedNet
  File "premaid\colinux-bridged-net-daemon.exe"
SectionEnd

Section "Kernel Bridged Ethernet (ndis)" SeccoLinuxNdisBridge
  File "premaid\colinux-ndis-net-daemon.exe"
SectionEnd

Section "Virtual Serial Device (ttyS)" SeccoLinuxSerial
  File "premaid\colinux-serial-daemon.exe"
SectionEnd

Section "Debugging" SeccoLinuxDebug
  File "premaid\colinux-debug-daemon.exe"
  File "premaid\debugging.txt"
SectionEnd

SectionGroupEnd

!include nsDialogs.nsh
!include LogicLib.nsh

Var FS_init
Var FS_Dialog
Var FS_RAM_Label
Var FS_RAM_Text
Var FS_RAM_Value
Var FS_SWAP_Label
Var FS_SWAP_Text
Var FS_SWAP_Value
Var FS_ROOT_Label
Var FS_ROOT_Text
Var FS_ROOT_Value

Function PageFileSystem
  ${If} $FS_init == ""
    StrCpy $FS_init "yes"
    StrCpy $FS_RAM_Value "512"
    StrCpy $FS_SWAP_Value "768"
    StrCpy $FS_ROOT_Value "20000"
  ${EndIf}

  Pop $R0

  !insertmacro MUI_HEADER_TEXT "Setup RAM and File System options" "(setup default 'settings.txt')"
  nsDialogs::Create /NOUNLOAD 1018
  Pop $FS_Dialog
  ${If} $FS_Dialog == error
    Abort
  ${EndIf}

  ${NSD_CreateLabel} 0 0% 60% 24u "How much RAM should andlinux use? (in MB)$\r$\n  (recommend: min = 256, optimal = 512+)"
  Pop $FS_RAM_Label
  ${NSD_CreateText} 60% 2% 25% 12u $FS_RAM_Value
  Pop $FS_RAM_Text

!ifndef BFIN_BASE

  ${NSD_CreateLabel} 0 25% 60% 24u "How much swap should andlinux use? (in MB)$\r$\n  (recommend: min = RAM, optimal = 1.5xRAM)"
  Pop $FS_SWAP_Label
  ${NSD_CreateText} 60% 27% 25% 12u $FS_SWAP_Value
  Pop $FS_SWAP_Text

  ${NSD_CreateLabel} 0 50% 60% 24u "File system resize? (in MB)$\r$\n  (recommend: Freetz: 20000, Speed2fritz: 4000)"
  Pop $FS_ROOT_Label
  ${NSD_CreateText} 60% 52% 25% 12u $FS_ROOT_Value
  Pop $FS_ROOT_Text

!endif

  nsDialogs::Show
FunctionEnd
Function PageFileSystemLeave
  ${NSD_GetText} $FS_RAM_Text $FS_RAM_Value
  ${NSD_GetText} $FS_SWAP_Text $FS_SWAP_Value
  ${NSD_GetText} $FS_ROOT_Text $FS_ROOT_Value
FunctionEnd

Var NW_init
Var NW_Dialog
Var NW_Label
Var NW_WinIP_Label
Var NW_WinIP_Text
Var NW_WinIP_Value
Var NW_LinIP_Label
Var NW_LinIP_Text
Var NW_LinIP_Value
Var NW_COM_Label
Var NW_COM_Text
Var NW_COM_Value
Var NW_USER_Label
Var NW_USER_Text
Var NW_USER_Value
Var NW_COFSPFAD_Label
Var NW_COFSPFAD_Text
Var NW_COFSPFAD_Value
Var INST_SDAT_BTN1
Var FS_FORMATIEREN_Value

Function PageNetworking

;--------------------------------------------------------------------------------------------
    DetailPrint "Read settings.txt shared directory"
    Push $0 # dir
    Push $1 #  
    ClearErrors
    FileOpen $0 "$INSTDIR\settings.txt" r
    IfErrors s_fail
    s_line:
    FileRead $0 $R0
    IfErrors s_done
      StrCpy $1 $R0 6
      ${IF} $1 == "cofs0="
      StrCpy $NW_COFSPFAD_Value $R0 -1 6
     ${ELSE}
    ${ENDIF}
    GoTo s_line
    s_done:
    FileClose $0
    s_fail:
    Pop $1
    Pop $0
;--------------------------------------------------------------------------------------------

  ${If} $NW_init == ""
    StrCpy $NW_init "yes"
    StrCpy $NW_WinIP_Value "192.168.11.1"
    StrCpy $NW_LinIP_Value "192.168.11.150"
    StrCpy $NW_COM_Value "COM1"
    StrCpy $NW_USER_Value "freetz"
    StrCpy $FS_FORMATIEREN_Value "n"
  ${EndIf}

  !insertmacro MUI_HEADER_TEXT "Setup Networking and Serial options" "(setup default 'settings.txt')"
  nsDialogs::Create /NOUNLOAD 1018
  Pop $NW_Dialog
  ${If} $NW_Dialog == error
    Abort
  ${EndIf}

  ${NSD_CreateLabel} 0 0% 100% 24u "Configure the network settings of the private TAP network tunnel for communication between Windows and andLinux.  The default values are fine."
  Pop $NW_Label

  ${NSD_CreateLabel} 0 20% 50% 12u "Windows IP Address"
  Pop $NW_WinIP_Label
  ${NSD_CreateText} 50% 20% 40% 12u $NW_WinIP_Value
  Pop $NW_WinIP_Text

  ${NSD_CreateLabel} 0 35% 50% 12u "Linux IP Address"
  Pop $NW_LinIP_Label
  ${NSD_CreateText} 50% 35% 40% 12u $NW_LinIP_Value
  Pop $NW_LinIP_Text

  ${NSD_CreateLabel} 0 50% 50% 12u "COFS (DOS8.3 names, eg: C:\)"
  Pop $NW_COFSPFAD_Label
  ${NSD_CreateDirRequest} 50% 50% 40% 12u $NW_COFSPFAD_Value
  Pop $NW_COFSPFAD_Text

  ;; Only looking inside a folder
  ${NSD_CreateBrowseButton} 90% 50% 25 12u "..."
  Pop $INST_SDAT_BTN1
  nsDialogs::SetUserData /NOUNLOAD $INST_SDAT_BTN1 $NW_COFSPFAD_Value
		
  GetFunctionAddress $0 FolderBrowseButton
  nsDialogs::OnClick /NOUNLOAD $INST_SDAT_BTN1 $0
  #DirRequest
  ${NSD_CreateText} 50% 50% 40% 12u $NW_COFSPFAD_Value
  Pop $NW_COFSPFAD_Text

!ifndef BFIN_BASE

  ${NSD_CreateLabel} 0 65% 50% 12u "Linux new user name"
  Pop $NW_USER_Label
  ${NSD_CreateText} 50% 65% 40% 12u $NW_USER_Value
  Pop $NW_USER_Text

  ${NSD_CreateLabel} 0 80% 50% 12u "Serial Port Settings (Optional)"
  Pop $NW_COM_Label
  ${NSD_CreateText} 50% 80% 40% 12u $NW_COM_Value
  Pop $NW_COM_Text

!endif


  nsDialogs::Show

FunctionEnd

Function FolderBrowseButton
  nsDialogs::SelectFolderDialog /NOUNLOAD "Select COFS (DOS8.3 names only, eg: C:\)" $NW_COFSPFAD_Value 
  Pop $2
  ${If} $2 != ""
   SendMessage $NW_COFSPFAD_Text ${WM_SETTEXT} 0 STR:$2
  ${EndIf}
FunctionEnd


Function PageNetworkingLeave
  ${NSD_GetText} $NW_WinIP_Text $NW_WinIP_Value
  ${NSD_GetText} $NW_LinIP_Text $NW_LinIP_Value
  ${NSD_GetText} $NW_COFSPFAD_Text $NW_COFSPFAD_Value
  ${NSD_GetText} $NW_COM_Text $NW_COM_Value
  ${NSD_GetText} $NW_USER_Text $NW_USER_Value
FunctionEnd

Section -CreateConfigFile
  SetOutPath -
  #IfFileExists "settings.txt" check_config write_config
  #check_config:
  #MessageBox MB_YESNO|MB_DEFBUTTON2|MB_ICONQUESTION "You already have a configuration file.  Do you wish to replace it with your new settings?$\r$\n$\r$\nExisting file: $INSTDIR\settings.txt" /SD IDNO IDNO skip_config
  #write_config:
  FileOpen $0 "settings.txt" w
  FileWrite $0 "# This is a default config generated by the freetzLinux installer.$\r$\n"
  FileWrite $0 "# For more informationion, please see these original sources:$\r$\n"
  FileWrite $0 "#   example.conf $\r$\n"
  FileWrite $0 "#   colinux-daemon.txt$\r$\n"
  FileWrite $0 "#   http://www.colinux.org/$\r$\n"
  FileWrite $0 "#   http://wiki.ip-phone-forum.de/freetzlinux:network$\r$\n"
  FileWrite $0 "$\r$\n"
  FileWrite $0 "exec0=Xming\Xming.exe :0 -dpi 85 -ac -clipboard -notrayicon -c -multiwindow -reset -terminate -unixkill -logfile Xming.log -xkbmodel pc105 -xkblayout se $\r$\n"
  FileWrite $0 "#exec1=pulseaudio\pulseaudio.exe $\r$\n"
  FileWrite $0 "# Please do not change unless you understand these settings$\r$\n"
  FileWrite $0 "kernel=vmlinux$\r$\n"
  FileWrite $0 "#base.drv is the complete compressed ubuntu or any other linux$\r$\n"
  FileWrite $0 "cobd0=Drives\base.drv$\r$\n"
  FileWrite $0 "cobd1=Drives\swap.drv$\r$\n"
  FileWrite $0 "root=/dev/cobd0$\r$\n"
  #FileWrite $0 "ro$\r$\n"
  FileWrite $0 "initrd=initrd.gz$\r$\n"
  FileWrite $0 "$\r$\n"
  FileWrite $0 "# These cofs lines control what paths will be available to coLinux$\r$\n"
  FileWrite $0 "# They take the form of: cofs#=<path>$\r$\n"
  FileWrite $0 "cofs0=$NW_COFSPFAD_Value$\r$\n"
  FileWrite $0 "$\r$\n"
  FileWrite $0 "# How much RAM will coLinux reserve for itself$\r$\n"
  FileWrite $0 "mem=$FS_RAM_Value$\r$\n"
  FileWrite $0 "$\r$\n"
  FileWrite $0 "# Networking configuration (including port forwarding options)$\r$\n"
  FileWrite $0 "# http://colinux.wikia.com/wiki/Network$\r$\n"
  FileWrite $0 "# eth0=slirp,,tcp:22:22/tcp:333:22/tcp:10000:10000/udp:69:69$\r$\n"
  FileWrite $0 "eth0=slirp$\r$\n"
  FileWrite $0 "# eth0=pcap-bridge needs Win-Pcap installed, in your Windows network neighbourhood you may then bridge TAP with any physical card.$\r$\n"
  FileWrite $0 "# Ubuntu must be updated as well, then: apt-get install pump, so eth0 is usable with dhcp, ping via LAN possible, but not via WLAN if not bridged.$\r$\n"
  FileWrite $0 "#eth0=pcap-bridge$\r$\n"
  FileWrite $0 '#eth0=tuntap,"HostTAP",$\r$\n'
  FileWrite $0 'eth1=tuntap$\r$\n'
  FileWrite $0 '#eth1=tuntap,"BridgedTAP",$\r$\n'
  FileWrite $0 "$\r$\n"
  FileWrite $0 "cocon=120x40$\r$\n"
  FileWrite $0 "# Serial configuration$\r$\n"
  FileWrite $0 'ttys0=$NW_COM_Value,"baud=38400 parity=N data=8 stop=1 xon=off odsr=off octs=off idsr=off to=on rts=on dtr=on"$\r$\n'
  FileClose $0
  #skip_config:

   WriteRegStr HKLM SOFTWARE\andLinux\Launcher "IP" "$NW_LinIP_Value" 
   WriteRegDWORD HKLM SOFTWARE\andLinux\Launcher "Port" "8081" 
   WriteRegStr HKLM SYSTEM\CurrentControlSet\Control\BackupRestore\FilesNotToBackup "andLinux" "$INSTDIR\Drives\*" 


SectionEnd

Section "Shortcuts" Shortcuts
  SetOutPath -
  File scripts\stop.ico  
  CreateShortCut "C:\Users\Public\Desktop\svrstop.lnk" "$INSTDIR\srvstop.bat" "" "$INSTDIR\stop.ico"
  CreateShortCut "C:\Users\Public\Desktop\startup.lnk" "$INSTDIR\startup.bat" "" "$INSTDIR\andlinux.ico"
  File scripts\start.ico
  CreateShortCut "C:\Users\Public\Desktop\srvstart.lnk" "$INSTDIR\srvstart.bat" "" "$INSTDIR\start.ico"
  File scripts\andlinux.ico
  File scripts\colinux.ico
  CreateDirectory "$SMPROGRAMS\andLinux"
#  CreateShortCut "$SMPROGRAMS\andLinux\Documentation.lnk" "http://docs.andlinux.uclinux.org/doku.php?id=colinux" "" "$INSTDIR\colinux.ico"
  CreateShortCut "$SMPROGRAMS\andLinux\Documentation.lnk" "http://wiki.ip-phone-forum.de/skript:andlinux" "" "$INSTDIR\andlinux.ico"
  CreateShortCut "$SMPROGRAMS\andLinux\andLinux Console (fltk).lnk" "$INSTDIR\colinux-console-fltk.exe" "-a 0"
  CreateShortCut "$SMPROGRAMS\andLinux\andLinux Console (nt).lnk" "$INSTDIR\colinux-console-nt.exe" "-a 0"
  CreateShortCut "$SMPROGRAMS\andLinux\Uninstall.lnk" "$INSTDIR\Uninstall.exe"
#  CreateDirectory "$SMPROGRAMS\andLinux\Non-Service"
#  CreateShortCut "$SMPROGRAMS\andLinux\Non-Service\andLinux.lnk" "$INSTDIR\colinux-daemon.exe" "@settings.txt" "" "" SW_SHOWMINIMIZED
#  CreateShortCut "$SMPROGRAMS\andLinux\Non-Service\andLinux (single).lnk" "$INSTDIR\colinux-daemon.exe" "@settings.txt single" "" "" SW_SHOWMINIMIZED
#  CreateShortCut "$SMPROGRAMS\andLinux\Non-Service\andLinux (rescue).lnk" "$INSTDIR\colinux-daemon.exe" "@settings.txt init=/bin/sh rw" "" "" SW_SHOWMINIMIZED
#  CreateDirectory "$SMPROGRAMS\andLinux\Service"
  CreateShortCut "$SMPROGRAMS\andLinux\Service\demon start.lnk" "$INSTDIR\colinux-daemon.exe" "--install-service andLinux @settings.txt"
  CreateShortCut "$SMPROGRAMS\andLinux\Service\demon stop.lnk" "$INSTDIR\colinux-daemon.exe" "--remove-service andLinux"
  CreateShortCut "$SMPROGRAMS\andLinux\Service\svr Start.lnk" "net" "start andLinux"
  CreateShortCut "$SMPROGRAMS\andLinux\Service\svr Stop.lnk" "net" "stop andLinux"
  CreateShortCut "$SMPROGRAMS\andLinux\Service\XmingStart.lnk" "$INSTDIR\Xming\Xming.exe" ":0 -dpi 85 -clipboard -notrayicon -c -multiwindow -reset -terminate -unixkill -logfile Xming.log" ""

  ; we tell it to use explorer as a direct path link makes the system try
  ; to see if the path exists in the first place
#  CreateShortCut "$SMPROGRAMS\andLinux\uclinux home (Samba).lnk" "explorer" "\\$NW_LinIP_Value\$NW_USER_Value"

  
  Push $R0
  ClearErrors
  ReadRegStr $R0 HKLM SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PuTTY_is1 InstallLocation
  IfErrors 0 have_putty
  IfFileExists "C:\Program Files\PuTTY\putty.exe" 0 have_putty
  StrCpy $R0 "C:\Program Files\PuTTY\"
  have_putty:
  DetailPrint "Found PuTTY installed at $R0"
  CreateShortCut "$SMPROGRAMS\andLinux\PuTTY root@andLinux.lnk" "$R0putty.exe" "-X root@$NW_LinIP_Value"
  CreateShortCut "$SMPROGRAMS\andLinux\PuTTY freetz@andLinux.lnk" "$R0putty.exe" "-X $NW_USER_Value@$NW_LinIP_Value"
  Pop $R0
SectionEnd
Section "Putty" Putty
  File /oname=putty-installer.exe upstream\putty-*-installer.exe
  ExecWait putty-installer.exe
  Delete putty-installer.exe
SectionEnd

Section "WinPcap" WinPcap
  File /oname=WinPcap.exe upstream\WinPcap_*.exe
  ExecWait WinPcap.exe
  Delete WinPcap.exe
SectionEnd

Section "XMing" XMing
  File /oname=Xming-setup.exe upstream\Xming-*-setup.exe
  ExecWait Xming-setup.exe
  Delete Xming-setup.exe
SectionEnd

# Defines must sync with entries in file iDl.ini
!define IDL_NOTHING 1
!define IDL_ARCHLINUX 2
!define IDL_DEBIAN 3
!define IDL_FEDORA 4
!define IDL_GENTOO 5
!define IDL_UBUNTU 6
!define IDL_LOCATION 7

Section "-Root Filesystem image Download" SeccoLinuxImage

   ;----------------------------------------------------------
   ; Random sourceforge download
    ;Read a value from an InstallOptions INI file and set the filenames

    !insertmacro MUI_INSTALLOPTIONS_READ $R1 "iDl.ini" "Field ${IDL_NOTHING}" "State"
    StrCmp $R1 "1" End

    !insertmacro MUI_INSTALLOPTIONS_READ $R1 "iDl.ini" "Field ${IDL_ARCHLINUX}" "State"
    StrCpy $R0 "ArchLinux-2007.08-2-ext3-256m.7z"
    StrCmp $R1 "1" tryDownload

    !insertmacro MUI_INSTALLOPTIONS_READ $R1 "iDl.ini" "Field ${IDL_DEBIAN}" "State"
    StrCpy $R0 "Debian-4.0r0-etch.ext3.1gb.bz2"
    StrCmp $R1 "1" tryDownload

    !insertmacro MUI_INSTALLOPTIONS_READ $R1 "iDl.ini" "Field ${IDL_FEDORA}" "State"
    StrCpy $R0 "Fedora-7-20070906.exe"
    StrCmp $R1 "1" tryDownload

    !insertmacro MUI_INSTALLOPTIONS_READ $R1 "iDl.ini" "Field ${IDL_GENTOO}" "State"
    StrCpy $R0 "Gentoo-colinux-i686-2007-03-03.7z"
    StrCmp $R1 "1" tryDownload

    !insertmacro MUI_INSTALLOPTIONS_READ $R1 "iDl.ini" "Field ${IDL_UBUNTU}" "State"
    StrCpy $R0 "Ubuntu-6.06.1.ext3.1gb.bz2"
    StrCmp $R1 "1" tryDownload
    GoTo End

    tryDownload:
    StrCpy $R1 "colinux" ; project

    !insertmacro MUI_INSTALLOPTIONS_READ $LOCATION "iDl.ini" "Field ${IDL_LOCATION}" "State"
    StrCmp $LOCATION "SourceForge defaults" SFdefault  ;This is the preferred way and counts the stats
    StrCmp $LOCATION "Asia" Asia
    StrCmp $LOCATION "Australia" Australia
    StrCmp $LOCATION "Europe" Europe
    StrCmp $LOCATION "North America" NorthAmerica
    StrCmp $LOCATION "South America" SouthAmerica

    ;Random:
    ;MessageBox MB_OK "Random"
    	Push "http://belnet.dl.sourceforge.net/sourceforge/$R1/$R0"	;Europe
	Push "http://heanet.dl.sourceforge.net/sourceforge/$R1/$R0"	;Europe
	Push "http://easynews.dl.sourceforge.net/sourceforge/$R1/$R0"	;NorthAmerica
	Push "http://twtelecom.dl.sourceforge.net/sourceforge/$R1/$R0"	;?? NorthAmerika
	Push "http://flow.dl.sourceforge.net/sourceforge/$R1/$R0"	;??
	Push "http://aleron.dl.sourceforge.net/sourceforge/$R1/$R0"	;?? NorthAmerika
	Push "http://umn.dl.sourceforge.net/sourceforge/$R1/$R0"	;NorthAmerika
        Push "http://jaist.dl.sourceforge.net/sourceforge/$R1/$R0"	;Asia
        Push "http://optusnet.dl.sourceforge.net/sourceforge/$R1/$R0"	;Australia
	Push "http://mesh.dl.sourceforge.net/sourceforge/$R1/$R0"	;Europe
	Push 10
    Goto DownloadRandom
    Asia:
    ;MessageBox MB_OK "Asia"
        Push "http://jaist.dl.sourceforge.net/sourceforge/$R1/$R0"
        Push "http://nchc.dl.sourceforge.net/sourceforge/$R1/$R0"
        Push "http://keihanna.dl.sourceforge.net/sourceforge/$R1/$R0"  ;??
        Push 3
    Goto DownloadRandom
    Australia:
        Push "http://optusnet.dl.sourceforge.net/sourceforge/$R1/$R0"
        Push 1
    Goto DownloadRandom
    Europe:
    ;MessageBox MB_OK "Europe"
        Push "http://belnet.dl.sourceforge.net/sourceforge/$R1/$R0"
        Push "http://puzzle.dl.sourceforge.net/sourceforge/$R1/$R0"
	Push "http://switch.dl.sourceforge.net/sourceforge/$R1/$R0"
	Push "http://mesh.dl.sourceforge.net/sourceforge/$R1/$R0"
	Push "http://ohv.dl.sourceforge.net/sourceforge/$R1/$R0"
	Push "http://heanet.dl.sourceforge.net/sourceforge/$R1/$R0"
	Push "http://surfnet.dl.sourceforge.net/sourceforge/$R1/$R0"
	Push "http://kent.dl.sourceforge.net/sourceforge/$R1/$R0"
	Push "http://cesnet.dl.sourceforge.net/sourceforge/$R1/$R0"  ;??
	Push 9
    Goto DownloadRandom
    NorthAmerica:
    ;MessageBox MB_OK "NorthAmerica"
        Push "http://easynews.dl.sourceforge.net/sourceforge/$R1/$R0"
        Push "http://superb-west.dl.sourceforge.net/sourceforge/$R1/$R0"
        Push "http://superb-east.dl.sourceforge.net/sourceforge/$R1/$R0"
        Push "http://umn.dl.sourceforge.net/sourceforge/$R1/$R0"
        Push "http://twtelecom.dl.sourceforge.net/sourceforge/$R1/$R0"  ;??
        Push "http://aleron.dl.sourceforge.net/sourceforge/$R1/$R0"  ;??
        Push "http://unc.dl.sourceforge.net/sourceforge/$R1/$R0"  ;??
        Push 7
    Goto DownloadRandom
    SouthAmerica:
        Push "http://ufpr.dl.sourceforge.net/sourceforge/$R1/$R0"
        Push 1
    Goto DownloadRandom
    SFdefault:
        Push "http://downloads.sourceforge.net/$R1/$R0?download"
        Push 1

    DownloadRandom:
    	Push "$INSTDIR\$R0"
	Call DownloadFromRandomMirror
	Pop $0

    End:
    
SectionEnd

Function StartDlImageFunc

  SectionGetFlags ${SeccoLinuxImage} $R0
  IntOp $R0 $R0 & ${SF_SELECTED}
  IntCmp $R0 ${SF_SELECTED} "" ImageEnd ImageEnd

  !insertmacro MUI_HEADER_TEXT "Obtain a coLinux root file system image" "Choose a location"
  !insertmacro MUI_INSTALLOPTIONS_DISPLAY "iDl.ini"

  ImageEnd:

FunctionEnd

Function WinpcapRedir
  SectionGetFlags ${SeccoLinuxBridgedNet} $R0
  IntOp $R0 $R0 & ${SF_SELECTED}
  IntCmp $R0 ${SF_SELECTED} "" WinpcapEnd WinpcapEnd
  !insertmacro MUI_HEADER_TEXT "Get WinPCAP" "Install Bridged Ethernet WinPCAP dependency"
  !insertmacro MUI_INSTALLOPTIONS_DISPLAY "WinpcapRedir.ini"
  WinpcapEnd:
FunctionEnd

;--------------------
;Post-install section

Section -post

;---- Directly from OpenVPN install script , some minor mods

  SectionGetFlags ${SeccoLinuxNet} $R0
  IntOp $R0 $R0 & ${SF_SELECTED}
  IntCmp $R0 ${SF_SELECTED} "" notap notap
    ; TAP install/update was selected.
    ; Should we install or update?
    ; If tapcontrol error occurred, $5 will
    ; be nonzero.
    IntOp $5 0 & 0
    nsExec::ExecToStack '"$INSTDIR\netdriver\tapcontrol.exe" hwids TAP0801co'
    Pop $R0 # return value/error/timeout
            # leave Log in stack
    IntOp $5 $5 | $R0
    DetailPrint "tapcontrol hwids returned: $R0"

    ; If tapcontrol output string contains "TAP" we assume
    ; that TAP device has been previously installed,
    ; therefore we will update, not install.
    Push "TAP"
    Call StrStr
    Pop $R0

    IntCmp $5 0 +1 tapcontrol_check_error tapcontrol_check_error
    IntCmp $R0 -1 tapinstall

 ;tapupdate:
    #MessageBox MB_YESNO|MB_ICONQUESTION|MB_DEFBUTTON2 "You already have a TAP driver installed, do you wish to rewrite TAP driver? (If IP settings are chanched you must reinstall)" /SD IDNO IDNO notap

    DetailPrint "TAP-Win32 UPDATE (please confirm Windows-Logo-Test)"
    nsExec::ExecToLog '"$INSTDIR\netdriver\tapcontrol.exe" remove TAP0801co'
    Pop $R0 # return value/error/timeout
    IntOp $5 $5 | $R0
    DetailPrint "tapcontrol remove returned: $R0"

 tapinstall:
    DetailPrint "TAP-Win32 INSTALL (please confirm Windows-Logo-Test)"
    nsExec::ExecToLog '"$INSTDIR\netdriver\tapcontrol.exe" install \
		       "$INSTDIR\netdriver\OemWin2k.inf" TAP0801co'
    Pop $R0 # return value/error/timeout
    IntOp $5 $5 | $R0
    DetailPrint "tapcontrol install returned: $R0"

    #second instance
#    DetailPrint "TAP-Win32 INSTALL 2nd (please confirm Windows-Logo-Test)"
#    nsExec::ExecToLog '"$INSTDIR\netdriver\tapcontrol.exe" install \
#		       "$INSTDIR\netdriver\OemWin2k.inf" TAP0801co'
#    Pop $R0 # return value/error/timeout
#    IntOp $5 $5 | $R0
#    DetailPrint "tapcontrol install returned: $R0"


    ; netsh deals in "adapters".  devcon (tapcontrol) deals in "hwids".  neither
    ; displays the other info, so there is no easy way to translate between the
    ; two.  
    DetailPrint "Setting up network for coLinux TAP"
    nsExec::ExecToLog '"settapip.bat" "TAP-Win32 Adapter V8 (coLinux)" "$NW_WinIP_Value"'
    ;this part is not needed if the line above works well -->
    Pop $R0 # return value/error/timeout
    Push $0 # fd
    Push $1 # str line scratch
    ClearErrors
    FileOpen $0 "$INSTDIR\connectionName.txt" r
    IfErrors ip_fail
    FileRead $0 $R0
    IfErrors ip_done
    StrCpy $1 $R0 -2
    nsExec::ExecToLog 'netsh.exe interface ip set address "$1" static "$NW_WinIP_Value" 255.255.255.0'
#    nsExec::ExecToLog 'netsh.exe interface ip set address "HostTAP" static "$NW_WinIP_Value" 255.255.255.0'
    Pop $R0 # return value/error/timeout
#    nsExec::ExecToLog 'netsh.exe interface ip set address "BridgedTAP" static 192.168.178.19  255.255.255.0'
    ip_done:
    FileClose $0
    ip_fail:
    #Delete "$INSTDIR\connectionName.txt"
    Pop $1
    Pop $0
    ;<---

 tapcontrol_check_error:
    IntCmp $5 +1 notap
    MessageBox MB_OK "An error occurred installing the TAP-Win32 device driver."

 notap:

    ; Store CoLinux installation path into evironment variable
    Push COLINUX
    Push $INSTDIR
    Call WriteEnvStr

    nsExec::ExecToStack '"$INSTDIR\colinux-daemon.exe" --remove-driver'
    Pop $R0 # return value/error/timeout
    Pop $R1 # Log
    nsExec::ExecToLog '"$INSTDIR\colinux-daemon.exe" --install-driver'
    Pop $R0 # return value/error/timeout
SectionEnd

!ifndef BFIN_BASE
Section -post
  SetOutPath -
  ; Much faster to run mkFile than to use `dd` in coLinux
    StrCpy $FS_FORMATIEREN_Value "n"

  File scripts\mkFile.exe
  CreateDirectory "$INSTDIR\Drives"

  IfFileExists "$INSTDIR\Drives\base.drv" 0 do_initbase
  MessageBox MB_YESNO|MB_ICONQUESTION|MB_DEFBUTTON2 "You already have a root file.  Do you wish to resize and backup it?$\r$\n$\r$\nRoot file: $INSTDIR\Drives\base.drv$\r$\n$\r$\n (This will take much time dont close windows yourself)" /SD IDNO IDNO root_made

  IfFileExists "$INSTDIR\Drives\base.drv.old" 0 do_rename
  MessageBox MB_YESNO|MB_ICONQUESTION|MB_DEFBUTTON2 "You already have a backup root file.  Do you wish to overwrite it?$\r$\n$\r$\nOld root file: $INSTDIR\Drives\base.drv.old" /SD IDNO IDNO do_initbase
  Delete "$INSTDIR\Drives\base.drv.old"
  do_rename:
  rename "$INSTDIR\Drives\base.drv" "$INSTDIR\Drives\base.drv.old"
  do_initbase:
  DetailPrint "Creating root system file"
  StrCpy $FS_FORMATIEREN_Value "y"
  nsExec::ExecToLog 'mkFile -m Drives\base.drv $FS_ROOT_Value'
  Pop $R0
  IntCmp $R0 0 root_made
   MessageBox MB_OK|MB_ICONSTOP "Unable to create the rootfs file.  Are you out of space?$\r$\n$\r$\nSwap file: $INSTDIR\Drives\base.drv"
   Delete $INSTDIR\Drives\swap.drv
   Abort
  root_made:

  IfFileExists "$INSTDIR\Drives\swap.drv" check_swap write_swap
  check_swap:
#  MessageBox MB_YESNO|MB_ICONQUESTION|MB_DEFBUTTON2 "You already have a swap file.  Do you wish to resize it?$\r$\n$\r$\nSwap file: $INSTDIR\Drives\swap.drv" /SD IDNO IDNO swap_made
  Delete "$INSTDIR\Drives\swap.drv"
  write_swap:
  DetailPrint "Creating swap file"
  nsExec::ExecToLog 'mkFile -m Drives\swap.drv $FS_SWAP_Value'
  Pop $R0
  IntCmp $R0 0 swap_made
  MessageBox MB_OK|MB_ICONSTOP "Unable to create the swap file file exists!.  Are you out of space?$\r$\n$\r$\nSwap file: $INSTDIR\Drives\swap.drv"
  Abort
 swap_made:

  DetailPrint "Passing install settings to coLinux"
  FileOpen $0 "colinux.settings" w
  FileWrite $0 "CL_SWAP=cobd1$\n"
  FileWrite $0 "CL_ROOT=cobd0$\n"
  FileWrite $0 "CL_ROOT2=cobd2$\n"
  FileWrite $0 "CL_RAM_SIZE=$FS_RAM_Value$\n"
  FileWrite $0 "CL_FORMATIEREN=$FS_FORMATIEREN_Value$\n"
  FileWrite $0 "CL_SWAP_SIZE=$FS_SWAP_Value$\n"
  FileWrite $0 "CL_ROOT_SIZE=$FS_ROOT_Value$\n"
  FileWrite $0 "CL_WINIP=$NW_WinIP_Value$\n"
  FileWrite $0 "CL_LINIP=$NW_LinIP_Value$\n"
  FileWrite $0 "CL_COFSPFAD=$NW_COFSPFAD_Value$\n"
  FileWrite $0 "CL_COM=$NW_COM_Value$\n"
  FileWrite $0 "CL_NEWUSER=$NW_USER_Value$\n"
  FileClose $0

  File tarballs\init.tar
  File tarballs\andlinux-configs.tar
 # File tarballs\andlinux-root.tar
  File scripts\init.sh
  File scripts\passwd.exp
  Delete $INSTDIR\firstboot.txt

  DetailPrint "Initializing file system images (this may take a bit)"
  nsExec::ExecToLog 'cmd /C set COLINUX_CONSOLE_EXIT_ON_DETACH=1 & \
                     colinux-daemon.exe -k -v 1 \
                         kernel=vmlinux \
                         initrd=initrd.gz \
                         cofs0=. \
                         cobd0=Drives\base.drv \
                         cobd1=Drives\swap.drv \
                         cobd2=Drives\base.drv.old \
                         COLINUX_SETUP=yes \
                         COLINUX_SETUP_FS=cofs0 \
                         COLINUX_SETUP_EXEC=init.sh'
  Pop $R0
  IntCmp $R0 0 imgs_setup
  MessageBox MB_OK|MB_ICONSTOP "Initialization of file systems failed.  Please report this."
  Abort
  imgs_setup:
  Delete passwd.exp
  Delete init.sh
  Delete andlinux-root.tar
  Delete andlinux-configs.tar
  Delete init.tar

  Delete colinux.settings

#  done_init:
SectionEnd
!endif

;--------------------------------
;Descriptions

  LangString DESC_SecGrpcoLinux ${LANG_ENGLISH} "Install or upgrade coLinux. Install coLinux basics, driver, Linux kernel, Linux modules and docs"
  LangString DESC_SecNTConsole ${LANG_ENGLISH} "Native Windows (NT) coLinux console views Linux console in an NT DOS Command-line console"
  LangString DESC_SecFLTKConsole ${LANG_ENGLISH} "FLTK Cross-platform coLinux console to view Linux console and manage coLinux from a GUI program"
#  LangString DESC_SecLauncher ${LANG_ENGLISH} "Adds Launcher menu Cross-platform coLinux console to view Linux console and manage coLinux from a GUI program"
  LangString DESC_SeccoLinuxNet ${LANG_ENGLISH} "TAP Virtual Ethernet Driver as private network link between Linux and Windows"
  LangString DESC_SeccoLinuxNetSLiRP ${LANG_ENGLISH} "SLiRP Ethernet Driver as virtual Gateway for outgoings TCP and UDP connections - Simplest to use"
  LangString DESC_SeccoLinuxBridgedNet ${LANG_ENGLISH} "Bridge Ethernet support allows to join the coLinux machine to an existing network via libPcap"
  LangString DESC_SeccoLinuxNdisBridge ${LANG_ENGLISH} "Kernel Bridge Ethernet connects coLinux to an existing network via a fast kernel ndis driver."
  LangString DESC_SeccoLinuxSerial ${LANG_ENGLISH} "Virtual Serial Driver allows to use serial Devices between Linux and Windows"
  LangString DESC_SeccoLinuxDebug ${LANG_ENGLISH} "Debugging allows to create extensive debug log for troubleshooting problems"
  LangString DESC_SecImage ${LANG_ENGLISH} "Download an image from sourceforge. Also provide useful links on how to use it"
  LangString DESC_Shortcuts ${LANG_ENGLISH} "Standard useful start menu shortcuts.  They're useful."
  LangString DESC_Putty ${LANG_ENGLISH} "Free implementation of Telnet and SSH to work with coLinux."
  LangString DESC_WinPcap ${LANG_ENGLISH} "Allow coLinux to access the network."
  LangString DESC_XMing ${LANG_ENGLISH} "Display graphical programs under coLinux in your Windows environment."

  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecGrpcoLinux} $(DESC_SecGrpcoLinux)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecNTConsole} $(DESC_SecNTConsole)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecFLTKConsole} $(DESC_SecFLTKConsole)
#    !insertmacro MUI_DESCRIPTION_TEXT ${SecLauncher} $(DESC_SecLauncher)
    !insertmacro MUI_DESCRIPTION_TEXT ${SeccoLinuxNet} $(DESC_SeccoLinuxNet)
    !insertmacro MUI_DESCRIPTION_TEXT ${SeccoLinuxNetSLiRP} $(DESC_SeccoLinuxNetSLiRP)
    !insertmacro MUI_DESCRIPTION_TEXT ${SeccoLinuxBridgedNet} $(DESC_SeccoLinuxBridgedNet)
    !insertmacro MUI_DESCRIPTION_TEXT ${SeccoLinuxNdisBridge} $(DESC_SeccoLinuxNdisBridge)
    !insertmacro MUI_DESCRIPTION_TEXT ${SeccoLinuxSerial} $(DESC_SeccoLinuxSerial)
    !insertmacro MUI_DESCRIPTION_TEXT ${SeccoLinuxDebug} $(DESC_SeccoLinuxDebug)
    !insertmacro MUI_DESCRIPTION_TEXT ${SeccoLinuxImage} $(DESC_SecImage)
    !insertmacro MUI_DESCRIPTION_TEXT ${Shortcuts} $(DESC_Shortcuts)
    !insertmacro MUI_DESCRIPTION_TEXT ${Putty} $(DESC_Putty)
    !insertmacro MUI_DESCRIPTION_TEXT ${WinPcap} $(DESC_WinPcap)
    !insertmacro MUI_DESCRIPTION_TEXT ${XMing} $(DESC_XMing)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
;Uninstaller Section
;--------------------------------

Section "Uninstall"

  DetailPrint "andlinux REMOVE"
  nsExec::ExecToLog '"$INSTDIR\unins000.exe" /SP- /NORESTART'
  Pop $R0 # return value/error/timeout
  DetailPrint "Andlinux remove returned: $R0"

  MessageBox MB_OK|MB_ICONSTOP "First Uninstall done, go on with the next part!"



  DetailPrint "TAP-Win32 REMOVE"
  nsExec::ExecToLog '"$INSTDIR\netdriver\tapcontrol.exe" remove TAP0801co'
  Pop $R0 # return value/error/timeout
  DetailPrint "tapcontrol remove returned: $R0"

  nsExec::ExecToLog '"$INSTDIR\colinux-daemon.exe" --remove-driver'
  Pop $R0 # return value/error/timeout

  ;---------------------------------------------------------------FILES--
  ;----------------------------------------------------------------------
  ;
  Delete "$INSTDIR\colinux-console-fltk.exe"
  Delete "$INSTDIR\colinux-console-nt.exe"
  Delete "$INSTDIR\colinux-debug-daemon.exe"
  Delete "$INSTDIR\colinux-serial-daemon.exe"
  Delete "$INSTDIR\colinux-slirp-net-daemon.exe"
  Delete "$INSTDIR\colinux-daemon.exe"
  Delete "$INSTDIR\colinux-net-daemon.exe"
  Delete "$INSTDIR\colinux-bridged-net-daemon.exe"
  Delete "$INSTDIR\colinux-ndis-net-daemon.exe"
  Delete "$INSTDIR\linux.sys"
  Delete "$INSTDIR\vmlinux"
  Delete "$INSTDIR\initrd.gz"
  Delete "$INSTDIR\vmlinux-modules.tar.gz"
  Delete "$INSTDIR\README.txt"
  Delete "$INSTDIR\news.txt"
  Delete "$INSTDIR\cofs.txt"
  Delete "$INSTDIR\colinux-daemon.txt"
  Delete "$INSTDIR\debugging.txt"
  Delete "$INSTDIR\example.conf"

  Delete "$INSTDIR\netdriver\OemWin2k.inf"
  Delete "$INSTDIR\netdriver\tap0801co.sys"
  Delete "$INSTDIR\netdriver\tapcontrol.exe"
  Delete "$INSTDIR\netdriver\tap.cat"

  Delete "$INSTDIR\mkFile.exe"
  Delete "$INSTDIR\andlinux.ico"
  Delete "$INSTDIR\colinux.ico"
  Delete "$INSTDIR\stop.ico"
  Delete "$INSTDIR\start.ico"
  RMDir /r "$SMPROGRAMS\andLinux"
  MessageBox MB_YESNO|MB_ICONQUESTION|MB_DEFBUTTON2 \
    "Do you wish to delete your file system images and configuration files as well?" \
    /SD IDNO IDNO no_delete
  RMDir /r "$INSTDIR"
  no_delete:

  ;--------------------------------------------------------------/FILES--
  ;----------------------------------------------------------------------

  Delete "$INSTDIR\Uninstall.exe"
  RMDir "$INSTDIR\netdriver"
  RMDir "$INSTDIR"

  # remove the variable
  Push COLINUX
  Call un.DeleteEnvStr

  ; Cleanup registry
  DeleteRegKey HKLM ${REGUNINSTAL}
  DeleteRegKey HKLM ${REGEVENTS}
  DeleteRegKey HKCU "Software\andLinux"
  ;DeleteRegKey HKLM "SOFTWARE\andLinux\Launcher"
  ;DeleteRegKey HKLM "SYSTEM\CurrentControlSet\Control\BackupRestore\FilesNotToBackup"
SectionEnd

# Functions #######################################

;====================================================
; StrStr - Finds a given string in another given string.
;          Returns -1 if not found and the pos if found.
;   Input: head of the stack - string to find
;          second in the stack - string to find in
;   Output: head of the stack
;====================================================
Function StrStr
  Push $0
  Exch
  Pop $0 ; $0 now have the string to find
  Push $1
  Exch 2
  Pop $1 ; $1 now have the string to find in
  Exch
  Push $2
  Push $3
  Push $4
  Push $5

  StrCpy $2 -1
  StrLen $3 $0
  StrLen $4 $1
  IntOp $4 $4 - $3

  StrStr_loop:
    IntOp $2 $2 + 1
    IntCmp $2 $4 0 0 StrStrReturn_notFound
    StrCpy $5 $1 $3 $2
    StrCmp $5 $0 StrStr_done StrStr_loop

  StrStrReturn_notFound:
    StrCpy $2 -1

  StrStr_done:
    Pop $5
    Pop $4
    Pop $3
    Exch $2
    Exch 2
    Pop $0
    Pop $1
FunctionEnd

###################################################
#
# Downloads a file from a list of mirrors
# (the fist mirror is selected at random)
#
# Usage:
# 	Push Mirror1
# 	Push [Mirror2]
# 	...
# 	Push [Mirror10]
#	Push NumMirrors		# 10 Max
#	Push FileName
#	Call DownloadFromRandomMirror
#	Pop Return
#
#	Returns the NSISdl result
Function DownloadFromRandomMirror
	Exch $R1 #File name
	Exch
	Exch $R0 #Number of Mirros
	Push $0
	Exch 3
	Pop $0	#Mirror 1
	IntCmpU "2" $R0 0 0 +4
		Push $1
		Exch 4
		Pop $1	#Mirror 2
	IntCmpU "3" $R0 0 0 +4
		Push $2
		Exch 5
		Pop $2	#Mirror 3
	IntCmpU "4" $R0 0 0 +4
		Push $3
		Exch 6
		Pop $3	#Mirror 4
	IntCmpU "5" $R0 0 0 +4
		Push $4
		Exch 7
		Pop $4	#Mirror 5
	IntCmpU "6" $R0 0 0 +4
		Push $5
		Exch 8
		Pop $5	#Mirror 6
	IntCmpU "7" $R0 0 0 +4
		Push $6
		Exch 9
		Pop $6	#Mirror 7
	IntCmpU "8" $R0 0 0 +4
		Push $7
		Exch 10
		Pop $7	#Mirror 8
	IntCmpU "9" $R0 0 0 +4
		Push $8
		Exch 11
		Pop $8	#Mirror 9
	IntCmpU "10" $R0 0 0 +4
		Push $9
		Exch 12
		Pop $9	#Mirror 10
	Push $R4
	Push $R2
	Push $R3
	Push $R5
	Push $R6

	# If you don't want a random mirror, replace this block with:
	# StrCpy $R3 "0"
	# -----------------------------------------------------------
	StrCmp $RandomSeed "" 0 +2
		StrCpy $RandomSeed $HWNDPARENT  #init RandomSeed

	Push $RandomSeed
	Push $R0
	Call LimitedRandomNumber
	Pop $R3
	Pop $RandomSeed
	# -----------------------------------------------------------

	StrCpy $R5 "0"
MirrorsStart:
	IntOp $R5 $R5 + "1"
	StrCmp $R3 "0" 0 +3
		StrCpy $R2 $0
		Goto MirrorsEnd
	StrCmp $R3 "1" 0 +3
		StrCpy $R2 $1
		Goto MirrorsEnd
	StrCmp $R3 "2" 0 +3
		StrCpy $R2 $2
		Goto MirrorsEnd
	StrCmp $R3 "3" 0 +3
		StrCpy $R2 $3
		Goto MirrorsEnd
	StrCmp $R3 "4" 0 +3
		StrCpy $R2 $4
		Goto MirrorsEnd
	StrCmp $R3 "5" 0 +3
		StrCpy $R2 $5
		Goto MirrorsEnd
	StrCmp $R3 "6" 0 +3
		StrCpy $R2 $6
		Goto MirrorsEnd
	StrCmp $R3 "7" 0 +3
		StrCpy $R2 $7
		Goto MirrorsEnd
	StrCmp $R3 "8" 0 +3
		StrCpy $R2 $8
		Goto MirrorsEnd
	StrCmp $R3 "9" 0 +3
		StrCpy $R2 $9
		Goto MirrorsEnd
	StrCmp $R3 "10" 0 +3
		StrCpy $R2 $10
		Goto MirrorsEnd

MirrorsEnd:
	IntOp $R6 $R3 + "1"
	DetailPrint "Downloading from mirror $R6: $R2"

	NSISdl::download "$R2" "$R1"
	Pop $R4
	StrCmp $R4 "success" Success
	StrCmp $R4 "cancel" DownloadCanceled
	IntCmp $R5 $R0 NoSuccess
	DetailPrint "Download failed (error $R4), trying with other mirror"
	IntOp $R3 $R3 + "1"
	IntCmp $R3 $R0 0 MirrorsStart
	StrCpy $R3 "0"
	Goto MirrorsStart

DownloadCanceled:
	DetailPrint "Download Canceled: $R2"
	Goto End
NoSuccess:
	DetailPrint "Download Failed: $R1"
	Goto End
Success:
	DetailPrint "Download completed."
End:
	Pop $R6
	Pop $R5
	Pop $R3
	Pop $R2
	Push $R4
	Exch
	Pop $R4
	Exch 2
	Pop $R1
	Exch 2
	Pop $0
	Exch

	IntCmpU "2" $R0 0 0 +4
		Exch 2
		Pop $1
		Exch
	IntCmpU "3" $R0 0 0 +4
		Exch 2
		Pop $2
		Exch
	IntCmpU "4" $R0 0 0 +4
		Exch 2
		Pop $3
		Exch
	IntCmpU "5" $R0 0 0 +4
		Exch 2
		Pop $4
		Exch
	IntCmpU "6" $R0 0 0 +4
		Exch 2
		Pop $5
		Exch
	IntCmpU "7" $R0 0 0 +4
		Exch 2
		Pop $6
		Exch
	IntCmpU "8" $R0 0 0 +4
		Exch 2
		Pop $7
		Exch
	IntCmpU "9" $R0 0 0 +4
		Exch 2
		Pop $8
		Exch
	IntCmpU "10" $R0 0 0 +4
		Exch 2
		Pop $9
		Exch
	Pop $R0
FunctionEnd

###############################################################
#
# Returns a random number
#
# Usage:
# 	Push Seed (or previously generated number)
#	Call RandomNumber
#	Pop Generated Random Number
Function RandomNumber
	Exch $R0

	IntOp $R0 $R0 * "13"
	IntOp $R0 $R0 + "3"
	IntOp $R0 $R0 % "1048576" # Values goes from 0 to 1048576 (2^20)

	Exch $R0
FunctionEnd

####################################################
#
# Returns a random number between 0 and Max-1
#
# Usage:
# 	Push Seed (or previously generated number)
#	Push MaxValue
#	Call RandomNumber
#	Pop Generated Random Number
#	Pop NewSeed
Function LimitedRandomNumber
	Exch $R0
	Exch
	Exch $R1
	Push $R2
	Push $R3

	StrLen $R2 $R0
	Push $R1
RandLoop:
	Call RandomNumber
	Pop $R1	#Random Number
	IntCmp $R1 $R0 0 NewRnd
	StrLen $R3 $R1
	IntOp $R3 $R3 - $R2
	IntOp $R3 $R3 / "2"
	StrCpy $R3 $R1 $R2 $R3
	IntCmp $R3 $R0 0 RndEnd
NewRnd:
	Push $R1
	Goto RandLoop
RndEnd:
	StrCpy $R0 $R3
	IntOp $R0 $R0 + "0" #removes initial 0's
	Pop $R3
	Pop $R2
	Exch $R1
	Exch
	Exch $R0
FunctionEnd
