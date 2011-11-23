@Echo off
:: Add a new TAP-Win32 virtual ethernet adapter if not allredy a second one is installed
if Exist NetCfgInstance1Id.txt del NetCfgInstance*Id.txt
if Exist connection1Name.txt del connection*Name.txt
..\getlanid.vbs /w
if not Exist connection2Name.txt tapcontrol.exe install OemWin2k.inf tap0801co
if Exist NetCfgInstance1Id.txt del NetCfgInstance*Id.txt
if Exist connection1Name.txt del connection*Name.txt
..\getlanid.vbs /w
set /p name=<connection2Name.txt
::FOR /F %%i in ('findstr  /i "name" connection1Name.txt')  do Set %%i 

if Exist connection3Name.txt echo More as two TAP adapters found, You should delete some of the additional adapters first!
if Exist connection3Name.txt goto pause1
echo Tap Adapter %name% renamed to TAPspeedLinux2 

netsh interface set interface name="%name%" newname="TAPspeedLinux2" 

if Exist NetCfgInstance1Id.txt del NetCfgInstance*Id.txt
if Exist connection1Name.txt del connection*Name.txt
:pause1
  
pause
