#!/bin/bash
version=$(cat ./version)
echo "$((++version))" >./version
echo "Skriptversion: $version"
echo "---------------------------------------------------------------------------------------------------------------"
#some files are changedd for use with andlinux
cp -f make-release.sh ../bfin-colinux/trunk/make-release.sh
cp -fr ./tarballs/* ../bfin-colinux/trunk/tarballs
cp -fr ./scripts/* ../bfin-colinux/trunk/scripts
cp -f ./colinux.nsi ../bfin-colinux/trunk/patches/colinux.nsi
cp -f ./iDl.ini ../bfin-colinux/trunk/patches/iDl.ini
cp ./install.txt ../bfin-colinux/trunk/and/install.txt
cp ./install.bat ../bfin-colinux/trunk/and/install.bat
cp ./menu.bat ../bfin-colinux/trunk/and/menu.bat
cp ./run.bat ../bfin-colinux/trunk/and/run.bat
cp ./7za.exe ../bfin-colinux/trunk/and/7za.exe
cp ./runonce.bat ../bfin-colinux/trunk/and/runonce.bat
cp ./srvstart.bat ../bfin-colinux/trunk/and/srvstart.bat
cp ./startup.bat ../bfin-colinux/trunk/and/startup.bat
cp ./addtap.bat ../bfin-colinux/trunk/and/netdriver/andtap.bat
cp ./srvstop.bat ../bfin-colinux/trunk/and/srvstop.bat
cp ./README.txt ../bfin-colinux/trunk/and/README.txt
cp ./scripts/andlinux.ico ../bfin-colinux/trunk/and/andlinux.ico
cp ./scripts/colinux.ico ../bfin-colinux/trunk/and/colinux.ico
cp ./scripts/start.ico ../bfin-colinux/trunk/and/start.ico
cp ./scripts/stop.ico ../bfin-colinux/trunk/and/stop.ico
ln -s $(pwd)/Launcher ../bfin-colinux/trunk/and
ln -s $(pwd)/pulseaudio ../bfin-colinux/trunk/and
cp ./getlanid.vbs ../bfin-colinux/trunk/and/getlanid.vbs
cp ./get-activ-ip-adr.vbs ../bfin-colinux/trunk/and/get-activ-ip-adr.vbs
cp ./settapip.bat ../bfin-colinux/trunk/and/settapip.bat
echo "---------------------------------------------------------------------------------------------------------------"
cd ../bfin-colinux/trunk
cd patches

cd ../and
rm ../upstream/coLinux-$COLINUX_EXE_VER.exe
7z a -sfx ../upstream/coLinux-$COLINUX_EXE_VER.exe .
cd ..

echo "Please wait ...... see logfile: $home/log"  

./make-release.sh $version $COLINUX_VER $COLINUX_SRC_VER $COLINUX_EXE_VER   > $home/log

echo 
echo
echo
echo "Results are in directory: ../bfin-colinux/trunk/$version"  
echo "Logfile: $home/log"
echo
cat $home/log | grep "warning:" | grep -vs "DetailPrint" | grep -vs "MessageBox" | grep -vs "check_error" | more
cat $home/log | grep "Error " | grep -vs "DetailPrint" | grep -vs "MessageBox" | grep -vs "check_error" | more
