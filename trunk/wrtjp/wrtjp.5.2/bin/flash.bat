echo "flash bootloader ..."

wrtjp.5.2 -flash:custom /bypass /skipdetect /silent /window:90000000 /start:90000000 /length:10000
pause
::More info see startw.bat
