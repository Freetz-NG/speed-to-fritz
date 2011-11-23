'On Error Resume Next


Option Explicit
Dim objFSO, objTextFile, objFile, iNumArgs, objWMIService, colItems, objItem, strIPs, strcomputer
Dim strFile

strcomputer = "."
Set objWMIService = GetObject("winmgmts:" _
    & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")

Set colItems = objWMIService.ExecQuery _
    ("Select * From Win32_NetworkAdapterConfiguration Where IPEnabled = True")
   
for each objItem in colItems
    If objItem.IPAddress(0) <> "0.0.0.0" And Left(objItem.IPAddress(0),3) <> "169" Then
     strIPs = strIPs & objItem.IPAddress(0) & " "
	End if 
next

iNumArgs = WScript.Arguments.Count
strFile = "co.txt"
If (iNumArgs > 0) Then 
	strFile = WScript.Arguments.Item(0)
End If
Set objFSO = CreateObject("Scripting.FileSystemObject")
If not objFSO.FileExists(strFile) Then
   Set objFile = objFSO.CreateTextFile(strFile)
   objFile.Close
End If
Set objTextFile = objFSO.OpenTextFile _
(strFile, 8, True)
objTextFile.WriteLine("DISPLAY=" & strIPs)
objTextFile.Close
set objFile = nothing
	
wscript.echo "DISPLAY=" & strIPs
WScript.Quit



