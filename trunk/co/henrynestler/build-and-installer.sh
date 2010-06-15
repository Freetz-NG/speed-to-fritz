#!/bin/bash
version=$(cat ./version)
echo "$((++version))" >./version
echo "Skriptversion: $version"
echo "---------------------------------------------------------------------------------------------------------------"
#some files are changedd for use with andlinux
cp -f make-release.sh ../bfin-colinux/trunk/make-release.sh
cp -fr ./tarballs/* ../bfin-colinux/trunk/tarballs
cp -fr ./scripts/* ../bfin-colinux/trunk/scripts
#[ -d ../bfin-colinux/trunk/patches/1 ] || mkdir ../bfin-colinux/trunk/patches/1
#[ -d ../bfin-colinux/trunk/patches/2 ] || mkdir ../bfin-colinux/trunk/patches/2
cp -f ./colinux.nsi ../bfin-colinux/trunk/patches/colinux.nsi
#cp ./header.bmp ../bfin-colinux/trunk/header.bmp
#cp ./startlogo.bmp ../bfin-colinux/trunk/startlogo.bmp
cp ./install.txt ../bfin-colinux/trunk/and/install.txt
cp ./install.bat ../bfin-colinux/trunk/and/install.bat
cp ./run.bat ../bfin-colinux/trunk/and/run.bat
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
#this files are from the older firmware
#cp ./initrd.gz ../bfin-colinux/trunk/and/initrd.gz
#cp colinux-daemon.txt ../bfin-colinux/trunk/and/colinux-daemon.txt

ln -s $(pwd)/Launcher ../bfin-colinux/trunk/and
sed -i -e 's|MediaStatus,          Default,   0, "0"|MediaStatus,          Default,   0, "1"|g' ../bfin-colinux/trunk/and/netdriver/OemWin2k.inf
sed -i -e 's|MediaStatus,          Default,   0, "0"|MediaStatus,          Default,   0, "1"|g' ../bfin-colinux/trunk/and/tuntap/OemWin2k.inf
cp ./getlanid.vbs ../bfin-colinux/trunk/and/getlanid.vbs
cp ./settapip.bat ../bfin-colinux/trunk/and/settapip.bat
echo "---------------------------------------------------------------------------------------------------------------"
cd ../bfin-colinux/trunk
COLINUX_SRC_VER=$(find upstream -name 'coLinux-*.src.tar.gz' | LC_ALL=C sort | tail -n1 | sed 's:.*coLinux-\(.*\).src.tar.gz:\1:')

#VER_SRC="${COLINUX_SRC_VER%-*}"
#DATE_SRC="${COLINUX_SRC_VER##*-}"
#echo "colinux src.tar.gz version: $VER_SRC"
#echo "colinux src.tar.gz date: $DATE_SRC"
##tar zxf ./upstream/coLinux-${COLINUX_SRC_VER}.src.tar.gz
##cp ./colinux-${DATE_SRC}/src/colinux/os/winnt/user/install/colinux.nsi ./patches/1/colinux.nsi
#----------------------------------------------------------------
#----------------------------------------------------------------
cd patches
#VERZEICHNISS1="./1" #original
#VERZEICHNISS2="./2" #changed
#DESTPATH_UND_NAME="colinux/coLinux/src/src/colinux/os/winnt/user/install"
#PATCHFILE_NAME="colinux-${COLINUX_VER}-installer.patch"
#----------------------------------------------------------------
##echo " -- generate $PATCHFILE_NAME"
#diff -Naur "$VERZEICHNISS1" "$VERZEICHNISS2" > ./$PATCHFILE_NAME
#sed -i -e "s|$VERZEICHNISS1|$DESTPATH_UND_NAME|g" ./$PATCHFILE_NAME
#sed -i -e "s|$VERZEICHNISS2|$DESTPATH_UND_NAME|g" ./$PATCHFILE_NAME
#sed -i -e "/diff/d" ./$PATCHFILE_NAME
#----------------------------------------------------------------
#----------------------------------------------------------------

cd ../and


rm ../upstream/coLinux-$COLINUX_EXE_VER.exe
7z a -sfx ../upstream/coLinux-$COLINUX_EXE_VER.exe .
cd ..

echo "Please wait ...... see logfile: $home/log"  

./make-release.sh $version $COLINUX_VER $COLINUX_SRC_VER $COLINUX_EXE_VER   > $home/log

#rm ./upstream/coLinux-$COLINUX_EXE_VER.exe
#rm ./tarballs/andlinux-configs.tar
#rm ./tarballs/init.tar


echo 
echo
echo
echo "Results are in directory: ../bfin-colinux/trunk/$version"  
echo "Logfile: $home/log"
echo
cat $home/log | grep "warning:" | grep -vs "DetailPrint" | grep -vs "MessageBox" | grep -vs "check_error" | more
cat $home/log | grep "Error " | grep -vs "DetailPrint" | grep -vs "MessageBox" | grep -vs "check_error" | more
