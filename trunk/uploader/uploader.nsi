;NSIS Modern User Interface
;--------------------------------
; !include "MUI.nsh"
;Include Modern UI
  !include "MUI2.nsh"
  !include "x64.nsh"
  !include Sections.nsh
  !include nsDialogs.nsh
  !include LogicLib.nsh
  !define ALL_USERS
ShowInstDetails show
  Var FS_Dialog
  ;Var FS_PFAD_Text
  Var FS_PFAD_Value
  Var INST_SDAT_BTN1
  Var SUARCH
  Var OEM
  Var ANNEX
  Var CLEAR
  Var PUSH
;--------------------------------
;General
; Base names definition
!define APP_NAME "Firmware Uploader"
  ;Name and file
  Name "${APP_NAME}"
  OutFile "jpUploader.exe"
;--------------------------------

;--------------------------------
  ;Default installation folder
  ;InstallDir "$LOCALAPPDATA\jpUploader"
  InstallDir "$TEMP\jpUploader"
  ;Request application privileges for Windows Vista
  RequestExecutionLevel user

;--------------------------------
  ;Interface Settings
  !define MUI_ABORTWARNING

;--------------------------------
;Pages
  Page custom PageFileSelect PageFileSelectLeave
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
;--------------------------------
;Languages
 
  !insertmacro MUI_LANGUAGE "English"

;--------------------------------
Function .onInit
 ;       Call SetAVM
        StrCpy $ANNEX "annex=B"
        StrCpy $OEM "avm"
        StrCpy $CLEAR "no_clear"
        StrCpy $PUSH "no_pusch"
FunctionEnd

Section
  ;Check running 64 bit and block it (NSIS 2.21 and newer)
  ${If} ${RunningX64}
    MessageBox MB_OK "Upload can't run on x64"
    DetailPrint "Abort on 64 bit"
    Abort
  ${EndIf}
SectionEnd

;Installer Sections
;SectionGroup "Change Defaults" SecGrpUpload

;Section "Set OEM avm" SecAVM
;   Call setAVM
;SectionEnd

;Section "Set OEM avme" SecAVME
;     Call setAVME
;SectionEnd

Section "Clear mtd3/4" SecMTD
    StrCpy $CLEAR "clear"
SectionEnd

Section "Run FTP Upload" FTP_Upload
    StrCpy $PUSH "push"
SectionEnd

Section
  ; Unzip dictionary into dictionary subdirectory
    RMDir /r $INSTDIR\dictionary
    ;DetailPrint "File: $FS_PFAD_Value"
    untgz::extract "-j" "-d" "$INSTDIR\dictionary" "$FS_PFAD_Value"
    SetFileAttributes "$INSTDIR\dictionary\*.*" NORMAL
  IfFileExists "$INSTDIR\dictionary\.packages" 0 withoutFreetz
    DetailPrint "--------------------------------------------"
    DetailPrint "Included Freetz packages:"
    Push $0 # dir
    Push $1 #
    ClearErrors
    FileOpen $0 "$INSTDIR\dictionary\.packages" r
    IfErrors s_fail
    s_line:
    FileRead $0 $R0
    IfErrors s_done
      DetailPrint "$R0"
    GoTo s_line
    s_done:
    FileClose $0
    s_fail:
    Pop $1
    Pop $0
    DetailPrint "--------------------------------------------"
  WithoutFreetz:

IfFileExists "$INSTDIR\dictionary\install" 0 printNoInstall
    ;DetailPrint "Read install"
    ;DetailPrint "--------------------------------------------"
    Push "$INSTDIR\dictionary\install"
    StrCpy $SUARCH "AnnexA"
    Push $SUARCH
    Call FileSearch
    Pop $0 #Number of times found throughout
    Pop $1 #Number of lines found on
    StrCmp $0 0 +2
    DetailPrint "'$SUARCH' was found in the file $0 times on $1 lines."
    ${If} $1 != "0"
          StrCpy $ANNEX "annex=A"
    ${EndIf}
    DetailPrint "--------------------------------------------"
    Push "$INSTDIR\dictionary\install"
    StrCpy $SUARCH "echo kernel_args annex=A"
    Push $SUARCH
    Call FileSearch
    Pop $0 #Number of times found throughout
    Pop $1 #Number of lines found on
    StrCmp $0 0 +2
    DetailPrint "'$SUARCH' was found in the file $0 times on $1 lines."
    ${If} $1 != "0"
          StrCpy $ANNEX "annex=A"
    ${EndIf}
   ;DetailPrint "--------------------------------------------"
    Push "$INSTDIR\dictionary\install"
    StrCpy $SUARCH "echo firmware_version avme "
    Push $SUARCH
    Call FileSearch
    Pop $0 #Number of times found throughout
    Pop $1 #Number of lines found on
    StrCmp $0 0 +2
    StrCpy $OEM "avme"
    ;DetailPrint "'avme' was found in the file $0 times on $1 lines."
   ;DetailPrint "--------------------------------------------"
    ${If} $1 == "0"
    Push "$INSTDIR\dictionary\install"
    StrCpy $SUARCH "echo firmware_version avm "
    Push $SUARCH
    Call FileSearch
    Pop $0 #Number of times found throughout
    Pop $1 #Number of lines found on
    StrCmp $0 0 +2
    StrCpy $OEM "avm"
    ;DetailPrint "'avm' was found in the file $0 times on $1 lines."
   ;DetailPrint "--------------------------------------------"
    ${EndIf}
    ${If} $1 == "0"
    StrCpy $SUARCH "for i in  avm "
    Push "$INSTDIR\dictionary\install"
    Push $SUARCH
    Call FileSearch
    Pop $0 #Number of times found throughout
    Pop $1 #Number of lines found on
    StrCmp $0 0 +2
    StrCpy $OEM "avm"
    ;DetailPrint "'avm' was found in the file $0 times on $1 lines."
    ${EndIf}
    ${If} $1 == "0"
   ;DetailPrint "--------------------------------------------"
    StrCpy $SUARCH "for i in  avme "
    Push "$INSTDIR\dictionary\install"
    Push $SUARCH
    Call FileSearch
    Pop $0 #Number of times found throughout
    Pop $1 #Number of lines found on
    StrCmp $0 0 +2
    StrCpy $OEM "avme"
    ;DetailPrint "'avme' was found in the file $0 times on $1 lines."
   ;DetailPrint "--------------------------------------------"
    ${EndIf}
    ${If} $1 == "0"
    StrCpy $SUARCH "for i in  tcom "
    Push "$INSTDIR\dictionary\install"
    Push $SUARCH
    Call FileSearch
    Pop $0 #Number of times found throughout
    Pop $1 #Number of lines found on
    StrCpy $OEM "tcom"
    StrCmp $0 0 +2
   DetailPrint "--------------------------------------------"
   ${EndIf}
   DetailPrint "Firmware version $OEM was found, $0 times on $1 lines."
   goto InstallExist
printNoInstall:
   DetailPrint "Settings could not be read, defaults are in use!"
InstallExist:
  Delete $INSTDIR\FTP_Upload.exe
   MessageBox MB_OK "--> Switch Router Power Line Off And On Again (Reboot), Klick 'OK' Button Within Three Seconds.\
--> If it did not work the first time repeat router reboot.  Attention: In some cases static PC LAN IP settings are needed \
(IP: 192.168.178.2 Mask: 255.255.0.0).\
There is no need to restart this tool, transfer will start as soon as adam FTP IP 192.168.178.1 or 192.168.2.1 is reachable."
  File /oname=$INSTDIR\FTP_Upload.exe FTP_uploader\bin\Release\ftp.exe
  ;nsExec::ExecToLog '"$INSTDIR\FTP_Upload.exe" "-x" "$OEM" "$ANNEX" "$CLEAR" "$PUSH"'
    ExecWait '"$INSTDIR\FTP_Upload.exe" "-x" "$OEM" "$ANNEX" "$CLEAR" "$PUSH"'
  ; Delete temporary files
  ;Delete $INSTDIR\FTP_Upload.ex
  ;RMDir /r $INSTDIR\dictionary

SectionEnd

;SectionGroupEnd
;--------------------------------
;Descriptions

  ;Language strings
;  LangString DESC_avm ${LANG_ENGLISH} "This will set the environment variable to avm, if the variable could not be determined by searching through the install file of the selected firmware."
;  LangString DESC_avme ${LANG_ENGLISH} "This will set the environment variable to avme, if the variable could not be determined by searching through the install file of the selected firmware."
  LangString DESC_mtd ${LANG_ENGLISH} "This will set the environment variables to default."
  LangString DESC_Upload ${LANG_ENGLISH} "This will upload the selecet firmware."
;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
 ;   !insertmacro MUI_DESCRIPTION_TEXT ${SecAVM} $(DESC_avm)
  ;  !insertmacro MUI_DESCRIPTION_TEXT ${SecAVME} $(DESC_avme)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecMTD} $(DESC_mtd)
    !insertmacro MUI_DESCRIPTION_TEXT ${FTP_Upload} $(DESC_Upload)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

;Function .onSelChange
 ;       ;If the Application section is checked, check the OCX section as well
 ;       !insertmacro SectionFlagIsSet ${SecAVM} ${SF_SELECTED} "" end1
 ;       !insertmacro UnselectSection ${SecAVME}
 ;   end1:
 ;       !insertmacro SectionFlagIsSet ${SecAVME} ${SF_SELECTED} "" end2
 ;       !insertmacro UnselectSection ${SecAVM}
 ;   end2:
;FunctionEnd

;Function SetAVM
;         !insertmacro UnselectSection ${SecAVME}
;         !insertmacro SelectSection ${SecAVM}
;FunctionEnd
;Function SetAVME
;        !insertmacro UnselectSection ${SecAVM}
;         !insertmacro SelectSection ${SecAVME}
;FunctionEnd

Function PageFileSelect
  ReadRegStr "$FS_PFAD_Value" HKCU "Software\Uploader" ""
  Pop $R0
  !insertmacro MUI_HEADER_TEXT "1. Switch on Router" "Router must be connected to the PC via LAN patch wire. Best would be to put a$\r$\n HUB or SWITCH between Router and PC or turn media sensing off on the PC Net-card."
  nsDialogs::Create /NOUNLOAD 1018
  Pop $FS_Dialog
  ${If} $FS_Dialog == error
    Abort
  ${EndIf}
  ${NSD_CreateLabel} 0 0% 60% 24u "2. Browse directory and select a suitable firmware$\r$\n    Don't select a kernel.image"
  ; Only looking for firmware file
  ${NSD_CreateBrowseButton} 90% 20% 25 12u "..."
  Pop $INST_SDAT_BTN1
  nsDialogs::SetUserData /NOUNLOAD $INST_SDAT_BTN1 $FS_PFAD_Value
  GetFunctionAddress $0 FileBrowseButton
  nsDialogs::OnClick /NOUNLOAD $INST_SDAT_BTN1 $0
  ${NSD_CreateText} 0% 20% 90% 12u $FS_PFAD_Value
  Pop $FS_PFAD_Value
  Push $FS_PFAD_Value
  Pop $R7
  nsDialogs::Show
FunctionEnd

Function PageFileSelectLeave
  ${NSD_GetText} $R7 $FS_PFAD_Value
FunctionEnd

Function FileBrowseButton
	Push "0xA01800" ;flags (see below) separated by commas [,]
	Push "Open" ;use "Open" or "Save" - CaSe sensitive!
	Push "Firmware Files (*.image)|*.image" ;file type 1
	Push "All Files (*.*)|*.*" ;file type 2
	Push "Select firmware file to install" ;dialog title
	Call FileRequest
	Pop $0
        ${If} $0 != ""
              ;SendMessage $FS_PFAD_Text ${WM_SETTEXT} 0 STR:$0
              SendMessage $FS_PFAD_Value ${WM_SETTEXT} 0 STR:$0
              DeleteRegKey HKCU "Software\Uploader"
              WriteRegStr HKCU "Software\Uploader" "" "$0"
        ${EndIf}
FunctionEnd

Function FileRequest
Exch $0 ;title
Exch 4
Exch $R5 ;flag
Exch 3
Exch $R4 ;Save/Open
Exch 2
Exch $2 ;sort type 2
Exch
Exch $1 ;sort type 1
Push $3
Push $4
Push $5 ;type 1 / 1
Push $6 ;tupe 1 / 2
Push $7 ;type 2 / 1
Push $8 ;type 2 / 2
Push $9
Push $R0 ;len 1 / 1
Push $R1 ;len 1 / 2
Push $R2 ;len 2 / 1
Push $R3 ;len 2 / 2

StrCmp $R5 "" 0 +2
 StrCpy $R5 0xA01800

StrCpy $9 $0 ;title

StrCpy $3 0
loop1:
 IntOp $3 $3 - 1
  StrCpy $4 $2 1 $3
 StrCmp $4 "" error
 StrCmp $4 "|" 0 loop1
StrCpy $5 $2 $3
 IntOp $3 $3 + 1
StrCpy $6 $2 "" $3

StrCpy $3 0
loop2:
 IntOp $3 $3 - 1
  StrCpy $4 $1 1 $3
 StrCmp $4 "" error
 StrCmp $4 "|" 0 loop2
StrCpy $7 $1 $3
 IntOp $3 $3 + 1
StrCpy $8 $1 "" $3

StrLen $R0 $5
 IntOp $R0 $R0 + 1
StrLen $R1 $6
 IntOp $R1 $R1 + 1
StrLen $R2 $7
 IntOp $R2 $R2 + 1
StrLen $R3 $8
 IntOp $R3 $R3 + 1

 StrCpy $4 '(&l4, i, i 0, i, i 0, i 0, i 0, t, i ${NSIS_MAX_STRLEN}, t, i ${NSIS_MAX_STRLEN}, t, t, i, &i2, &i2, t, i 0, i 0, i 0) i'

 System::Call '*(&t$R0 "$5" , &t$R1 "$6", &t$R2 "$7", &t$R3 "$8", &i1 0) i.r0'

 System::Call '*$4(, $HWNDPARENT,, r0,,,,"",,"",, i 0, "$9", $R5,,,,,,) .r1'

 System::Call 'comdlg32::Get$R4FileNameA(i r1) i .r2'
 System::Call '*$1$4(,,,,,,,.r3)'
 System::Free $1
 System::Free $0

StrCmp $2 0 0 +2
error:
 StrCpy $3 error
StrCpy $0 $3

Pop $R3
Pop $R2
Pop $R1
Pop $R0
Pop $9
Pop $8
Pop $7
Pop $6
Pop $5
Pop $4
Pop $3
Pop $1
Pop $2
Pop $R4
Pop $R5
Exch $0
FunctionEnd

Function FileSearch
Exch $R0 ;search for
Exch
Exch $R1 ;input file
Push $R2
Push $R3
Push $R4
Push $R5
Push $R6
Push $R7
Push $R8
Push $R9
  StrLen $R4 $R0
  StrCpy $R7 0
  StrCpy $R8 0
  ClearErrors
  FileOpen $R2 $R1 r
  IfErrors Done
  LoopRead:
    ClearErrors
    FileRead $R2 $R3
    IfErrors DoneRead
    IntOp $R7 $R7 + 1
    StrCpy $R5 -1
    StrCpy $R9 0
    LoopParse:
      IntOp $R5 $R5 + 1
      StrCpy $R6 $R3 $R4 $R5
      StrCmp $R6 "" 0 +4
        StrCmp $R9 1 LoopRead
          IntOp $R7 $R7 - 1
          Goto LoopRead
      StrCmp $R6 $R0 0 LoopParse
        StrCpy $R9 1
        IntOp $R8 $R8 + 1
        Goto LoopParse
  DoneRead:
    FileClose $R2
  Done:
    StrCpy $R0 $R8
    StrCpy $R1 $R7
Pop $R9
Pop $R8
Pop $R7
Pop $R6
Pop $R5
Pop $R4
Pop $R3
Pop $R2
Exch $R1 ;number of lines found on
Exch
Exch $R0 ;output count found
FunctionEnd

