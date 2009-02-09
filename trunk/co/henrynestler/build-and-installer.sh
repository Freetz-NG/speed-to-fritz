#!/bin/bash
version=$(cat ./version)
echo "$((++version))" >./version
echo "Skriptversion: $version"
echo "---------------------------------------------------------------------------------------------------------------"
#some files are changedd for use with andlinux
cp -f make-release.sh ../bfin-colinux/trunk/make-release.sh
cp -fr ./tarballs/* ../bfin-colinux/trunk/tarballs
cp -fr ./scripts/* ../bfin-colinux/trunk/scripts
[ -d ../bfin-colinux/trunk/patches/1 ] || mkdir ../bfin-colinux/trunk/patches/1
[ -d ../bfin-colinux/trunk/patches/2 ] || mkdir ../bfin-colinux/trunk/patches/2
cp -f ./colinux.nsi ../bfin-colinux/trunk/patches/2/colinux.nsi
cp ./srvstart.bat ../bfin-colinux/trunk/and/srvstart.bat
cp ./addtap.bat ../bfin-colinux/trunk/and/netdriver/andtap.bat
cp ./srvstop.bat ../bfin-colinux/trunk/and/srvstop.bat
cp ./README.txt ../bfin-colinux/trunk/and/README.txt
#ln -s $(pwd)/Launcher ../bfin-colinux/trunk/and
sed -i -e 's|MediaStatus,          Default,   0, "0"|MediaStatus,          Default,   0, "1"|g' ../bfin-colinux/trunk/and/netdriver/OemWin2k.inf
sed -i -e 's|MediaStatus,          Default,   0, "0"|MediaStatus,          Default,   0, "1"|g' ../bfin-colinux/trunk/and/tuntap/OemWin2k.inf
cp ./getlanid.vbs ../bfin-colinux/trunk/and/getlanid.vbs
cp ./settapip.bat ../bfin-colinux/trunk/and/settapip.bat
echo "---------------------------------------------------------------------------------------------------------------"
cd ../bfin-colinux/trunk


COLINUX_VER=$(find upstream -name 'coLinux-*.src.tar.gz' | LC_ALL=C sort | tail -n1 | sed 's:.*coLinux-\(.*\).src.tar.gz:\1:')
VER="${COLINUX_VER%-*}"
DATE="${COLINUX_VER##*-}"
echo "colinux version: $VER"
echo "colinux date: $DATE"
tar zxf ./upstream/coLinux-${COLINUX_VER}.src.tar.gz
cp ./colinux-${DATE}/src/colinux/os/winnt/user/install/colinux.nsi ./patches/1/colinux.nsi
#----------------------------------------------------------------
#----------------------------------------------------------------
cd patches
#./0makediff.sh
VERZEICHNISS1="./1" #original
VERZEICHNISS2="./2" #changed
DESTPATH_UND_NAME="colinux/coLinux/src/src/colinux/os/winnt/user/install"
PATCHFILE_NAME="colinux-${COLINUX_VER}-installer.patch"
#----------------------------------------------------------------
echo " -- generate $PATCHFILE_NAME"
diff -Naur "$VERZEICHNISS1" "$VERZEICHNISS2" > ./$PATCHFILE_NAME
sed -i -e "s|$VERZEICHNISS1|$DESTPATH_UND_NAME|g" ./$PATCHFILE_NAME
sed -i -e "s|$VERZEICHNISS2|$DESTPATH_UND_NAME|g" ./$PATCHFILE_NAME
sed -i -e "/diff/d" ./$PATCHFILE_NAME
#----------------------------------------------------------------
#----------------------------------------------------------------

cd ../and
#rm ../upstream/coLinux-$COLINUX_VER.exe
7z a -sfx ../upstream/coLinux-$COLINUX_VER.exe .
cd ..

echo "Please wait ...... see logfile: $home/log"  
./make-release.sh $version > $home/log

#rm ./upstream/coLinux-$COLINUX_VER.exe
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
