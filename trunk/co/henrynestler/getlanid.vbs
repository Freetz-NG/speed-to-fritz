'*****************************************************
'     Script Name:  getlanid.vbs
'     Version:  0.5
'      Author:   (Johann.Pascher AT gmail.com)
'     Last Updated:  2009 02 09
'     Purpose: 
'              Queries the registry of the target system using WMI
'              searching for cards. If any card
'              is found, it displays the version of the associated driver,
'	     writes NetCfgInstanceId to file NetCfgInstanceId.txt,
'	     writes connectionName to file  connectionName.txt
'	     sets static IP and net mask.
' Arguments:
' 		[/h (help) w (write files) (or /s (ip settings )]
'		Driver Description String]   
'		["IP Address"] 
'		["Mask"] 
'		["Gateway"] 
'              If more arguments are specified they order of the 
'	     argument's must be as specified.
'              If run without arguments, defaults are used.
' Notes: 
'              getlanid.vbs [, /w (write files) (or /s (ip settings)]  ["Driver Description String"]  [IP Address]  [Mask]  [ Gateway]
'	     Parantheses mut be part of the parameters if space ist part of it.  
'Default: TAP-Win32 Adapter V8 (coLinux)
'			sets IP ti 192.168.11.1
'			sets Mask to 255.255.255.
' Example Command Line: 
'getlanid.vbs  /s "TAP-Win32 Adapter V8 (coLinux)"  "192.168.11.10" "255.255.255.0" "192.168.11.1"
' Legal: Public Domain.  Modify and redistribute freely.  No rights reserved.
'*****************************************************
Option Explicit
Dim objFSO, objFolder, objShell, objTextFile, objFile, oReg, objScriptExec, wshShell
Dim strIpConfig, strTmp, iNumArgs, iNumCount 
Dim strDirectory, strFile,  strFile2,  strFileI,  strFileN, strDriverDescArg, strComputer, strKeyPath, strKeyPath2
Dim strName, strNetCfgInstanceId, strNetCfgInstanceIdFound, strConnectionName, strStringGateway
Dim strService, strImagePath, strDriverVersion, strDriverDesc, strKeyPath3, subkey2, arrSubKeys
Dim arrSubKeys2, strStringIP, strStringMask, strValueName, strMediaSubType, quiet, subkey
Const HKEY_LOCAL_MACHINE = &H80000002
iNumArgs = WScript.Arguments.Count
quiet = ""
If (iNumArgs = 0) Then 
	strDriverDescArg = "TAP-Win32 Adapter V8 (coLinux)"
	strStringIP = "192.168.11.1"
	strStringMask = "255.255.255.0"
	strStringGateway = " "
	quiet = ""
ElseIf (iNumArgs = 1 ) Then
	quiet = WScript.Arguments.Item(0)
	strDriverDescArg = "TAP-Win32 Adapter V8 (coLinux)"
	strStringIP = "192.168.11.1"
	strStringMask = "255.255.255.0"
	strStringGateway = " "
ElseIf (iNumArgs = 2 ) Then
	quiet = WScript.Arguments.Item(0)
	strDriverDescArg = WScript.Arguments.Item(1)
	strStringIP = "192.168.11.1"
	strStringMask = "255.255.255.0"
	strStringGateway = " "
ElseIf (iNumArgs = 3 ) Then
	quiet = WScript.Arguments.Item(0)
	strDriverDescArg = WScript.Arguments.Item(1)
	strStringIP = WScript.Arguments.Item(2)
	strStringIP = "192.168.11.1"
	strStringGateway = " "
ElseIf (iNumArgs = 4 ) Then
	quiet = WScript.Arguments.Item(0)
	strDriverDescArg = WScript.Arguments.Item(1)
	strStringIP = WScript.Arguments.Item(2)
	strStringMask = WScript.Arguments.Item(3)
	strStringGateway = " "
ElseIf (iNumArgs = 5 ) Then
	quiet = WScript.Arguments.Item(0)
	strDriverDescArg = WScript.Arguments.Item(1)
	strStringIP = WScript.Arguments.Item(2)
	strStringMask = WScript.Arguments.Item(3)
	strStringGateway = WScript.Arguments.Item(4)
End If
if (quiet = "/h") Then
	Wscript.Echo "Usage:"   & vbCrLf &_
"	getlanid.vbs [/h, /w, or /s ][Dis.] [IP] [Mask] [Gateway] "   & vbCrLf &_
"	*****************************************************"   & vbCrLf &_
"	Script Name:  getlanid.vbs"   & vbCrLf &_
"	Version:  0.4"   & vbCrLf &_
"	Author:   (johann.pascher AT gmail.com)"   & vbCrLf &_
"	Last Updated:  01 December 08"   & vbCrLf &_
"	Purpose:"   & vbCrLf &_
"		Queries the registry of the target system using WMI"   & vbCrLf &_
"		searching for cards. If any card is found,"   & vbCrLf &_
"		it displays the version of the associated driver"   & vbCrLf &_
"		additionally it writes,"   & vbCrLf &_
"		'NetCfgInstanceId' to file NetCfgInstanceId.txt and"   & vbCrLf &_
"		'connectionName' to file  connectionName.txt"   & vbCrLf &_
"		and sets static IP, mask and gateway."   & vbCrLf &_
"		Admin rights are needed!"   & vbCrLf &_
"	Arguments:"   & vbCrLf &_
"		[/h (displays this help)"   & vbCrLf &_
"		/w (write connectionXName.txt, NetCfgInstanceXId)"   & vbCrLf &_  
"		or /s (set ip setting)]"   & vbCrLf &_
"		[Driver Description String]"   & vbCrLf &_
"		[IP Address]"   & vbCrLf &_
"		[Mask]"   & vbCrLf &_
"		[Gateway]"   & vbCrLf &_
"		If more arguments are specified they order"   & vbCrLf &_ 
"		of the arguments must be as shown."   & vbCrLf &_
"		If run without arguments, defaults are used."   & vbCrLf &_
"	Notes:"   & vbCrLf &_
"		['Driver Description String']"   & vbCrLf &_
"		Quotes must be used if space is part of the" & vbCrLf &_
"		Driver Description String."   & vbCrLf &_  
"	Default:"   & vbCrLf &_
"		TAP-Win32 Adapter V8 (coLinux)"   & vbCrLf &_
"		sets IP to: 192.168.11.1"   & vbCrLf &_
"		sets Mask to: 255.255.255.0"   & vbCrLf &_
"		sets Gateway to: -"   & vbCrLf &_
"	Example Command Line: "   & vbCrLf &_
"		getlanid.vbs /s ''TAP-Win32 Adapter V8 (coLinux)''"& vbCrLf &_
"		192.168.11.10 255.255.255.0 192.168.11.1"
Wscript.Quit
End If
strComputer = "."
iNumCount = 0
Set oReg=GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\default:StdRegProv")
strKeyPath = "SYSTEM\CurrentControlSet\Control\Network\{4D36E972-E325-11CE-BFC1-08002BE10318}"
oReg.EnumKey HKEY_LOCAL_MACHINE, strKeyPath, arrSubKeys
For Each subkey In arrSubKeys
	If subkey <> "Descriptions" Then
		oReg.GetDWORDValue HKEY_LOCAL_MACHINE,strKeyPath & "\" & subkey & "\" & "Connection" ,"MediaSubType",strMediaSubType
		'Get the name of the network connection
		oReg.GetStringValue HKEY_LOCAL_MACHINE,strKeyPath & "\" & subkey & "\" & "Connection" ,"Name",strName
		strKeyPath2 = "SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}"
		oReg.EnumKey HKEY_LOCAL_MACHINE, strKeyPath2, arrSubKeys2
		For Each subkey2 In arrSubKeys2
			oReg.GetStringValue HKEY_LOCAL_MACHINE,strKeyPath2 & "\" & subkey2 ,"NetCfgInstanceId",strNetCfgInstanceId
			If strNetCfgInstanceId = subkey Then
			      strNetCfgInstanceIdFound = strNetCfgInstanceId
				oReg.GetStringValue HKEY_LOCAL_MACHINE,strKeyPath2 & "\" & subkey2 ,"DriverDesc",strDriverDesc
				If strDriverDesc = strDriverDescArg Then
					oReg.GetStringValue HKEY_LOCAL_MACHINE,strKeyPath & "\" & subkey & "\" & "Connection" ,"Name",strConnectionName
					oReg.GetStringValue HKEY_LOCAL_MACHINE,strKeyPath2 & "\" & subkey2 ,"DriverVersion",strDriverVersion
					oReg.GetStringValue HKEY_LOCAL_MACHINE,strKeyPath2 & "\" & subkey2 & "\Ndi","Service",strService
					strKeyPath3 = "SYSTEM\CurrentControlSet\Services\" & strService
					oReg.GetStringValue HKEY_LOCAL_MACHINE,strKeyPath3 & "\","ImagePath",strImagePath
					'display Info
					if not ((quiet = "/w") or (quiet = "/s")) Then
						Wscript.Echo vbCrLf &_
						"Found card at: "  & vbCrLf &_
						vbTab & "HKLM\" & strKeyPath & "\" & subkey & "\" & "Connection" & vbCrLf & vbCrLf &_
						vbTab & "HKLM\" & strKeyPath2 & "\" & subkey2 & vbCrLf & vbCrLf &_
						vbTab & "ConnectionName:" & vbTab & strConnectionName & vbCrLf & vbCrLf &_
						vbTab & "NetCfgInstanceId" & ":" & vbTab & strNetCfgInstanceIdFound & vbCrLf & vbCrLf &_
						vbTab & "DriverVersion" & ":" & vbTab & strDriverVersion & vbCrLf & vbCrLf &_
						vbTab & "Service" & ":" & vbTab & strService & vbCrLf & vbCrLf &_
						vbTab & "ImagePath" & ":" & vbTab & strImagePath
					End If
					if (quiet = "/w" ) Then
						iNumCount = iNumCount+1
						'write connectionName to file 
						strFileN = "connection" & iNumCount & "Name.txt"
						Set objFSO = CreateObject("Scripting.FileSystemObject")
						If not objFSO.FileExists(strFileN) Then
							Set objFile = objFSO.CreateTextFile(strFileN)
						End If
						set objFile = nothing
						Set objTextFile = objFSO.OpenTextFile _
						(strFileN, 2, True)
						objTextFile.WriteLine(strConnectionName)
						objTextFile.Close	
					'write NetCfgInstanceId to file 
						strFileI = "NetCfgInstance" & iNumCount & "Id.txt"
						Set objFSO = CreateObject("Scripting.FileSystemObject")
						If not objFSO.FileExists(strFileI) Then
							Set objFile = objFSO.CreateTextFile(strFileI)
						End If
						set objFile = nothing
						Set objTextFile = objFSO.OpenTextFile _
						(strFileI, 2, True)
						objTextFile.WriteLine(strNetCfgInstanceIdFound)
						objTextFile.Close
'						strFile2 = "connectionName.txt"
'						Set objFSO = CreateObject("Scripting.FileSystemObject")
'						If not objFSO.FileExists(strFile2) Then
'							Set objFile = objFSO.CreateTextFile(strFile2)
'						End If
'						set objFile = nothing
'						Set objTextFile = objFSO.OpenTextFile _
'						(strFile2, 2, True)
'						objTextFile.WriteLine(strConnectionName)
'						objTextFile.Close	
'						'write NetCfgInstanceId to file 
'						strFile2 = "NetCfgInstanceId.txt"
'						Set objFSO = CreateObject("Scripting.FileSystemObject")
'						If not objFSO.FileExists(strFile2) Then
'							Set objFile = objFSO.CreateTextFile(strFile2)
'						End If
'						set objFile = nothing
'						Set objTextFile = objFSO.OpenTextFile _
'						(strFile2, 2, True)
'						objTextFile.WriteLine(strNetCfgInstanceIdFound)
'						objTextFile.Close
					End if
					if (quiet = "/s" ) Then
						Set objShell = CreateObject("WScript.Shell")
						strTmp = "netsh interface ip set address "  & Chr(34) & Chr(34) & Chr(34) & strConnectionName & Chr(34) & Chr(34) & Chr(34) & " static " & strStringIP & " " & strStringMask & " " & strStringGateway
						'WScript.Echo strTmp
						Set objScriptExec = objShell.Exec (strTmp)						
						strIpConfig = objScriptExec.StdOut.ReadAll
						if (Len(strIpConfig) > 3) Then
						End if
					End if
				End If
			End If
		Next
	End If
Next
'if (quiet = "/w" ) Then
	'Wscript.Echo "numcount: "  & iNumCount
'	Set objFSO = CreateObject("Scripting.FileSystemObject")
'	strFileN = "connection" & iNumCount & "Name.txt"
'	Set objTextFile = objFSO.GetFile(strFileN)
'	If objFSO.FileExists(strFileN) Then
'		objTextFile.Delete
'	End If
'	Set objFSO = CreateObject("Scripting.FileSystemObject")
'	strFileI = "NetCfgInstance" & iNumCount & "Id.txt"
'	Set objTextFile = objFSO.GetFile(strFileI)
'	If objFSO.FileExists(strFileI) Then
'		objTextFile.Delete
'	End If
'End If						
WScript.Quit
