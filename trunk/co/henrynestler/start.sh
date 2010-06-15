#!/bin/bash
#svn checkout svn+ssh://anonymous@blackfin.uclinux.org/svnroot/bfin-colinux ../bfin-colinux-ori 
# Attentin: passwort 3 x anonymous
# revision 11
#http://docs.blackfin.uclinux.org/doku.php?id=colinux:building-installer&s[]=colinux
# Remove left over Subversion directories
echo "-------------------------------------------------------------------------------------------------------------"
echo
if ! [ `id -u` -eq 0 ]; then
 clear
  echo
  echo "This script needs to be executed with 'su' privileges."
  echo 
  echo "Use ./s.sh instead!"
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  sleep 10
  exit 0
fi
echo "-------------------------------------------------------------------------------------------------------------"
echo "====================================================================================================="
echo "====================================================================================================="
echo "Checking for left over Subversion directories"
find ../ -type d -name .svn | xargs rm -rf
[ -d ../bfin-colinux/tags ] && rm -R ../bfin-colinux/tags
[ -d ../bfin-colinux/branches ] && rm -R ../bfin-colinux/branches
# backup
echo "Backup: ../bfin-colinux-ori"
[ -d ../bfin-colinux ] && rm -R ../bfin-colinux
mkdir ../bfin-colinux
echo "====================================================================================================="
[ -f ./bzip2-102-x86-win32.zip ] || wget "http://www.henrynestler.com/colinux/tools/bzip2-102-x86-win32.zip"
[ -f ./file-utils-mingw-bin-stripped.zip ] || wget "http://www.henrynestler.com/colinux/tools/file-utils-mingw-bin-stripped.zip"
[ -f ./netdriver-tap84.zip ] || wget "http://www.henrynestler.com/colinux/tools/netdriver-tap84.zip"
[ -f ./tap32-driver-v9.zip ] || wget "http://www.sixxs.net/archive/sixxs/aiccu/windows/tap32-driver-v9.zip"
echo "====================================================================================================="
 #get_latest_colinux
 INDEX="./index"
 LISTING="./listing"
 TMP="./temp"
 rm -f $TMP
 rm -f "$TMP"1
 rm -f "$INDEX"*
 rm -f $LISTING
#------------------------------------------
#------------------------------------------
TESTING="n"
#--------------------------------------
#------------------------------------------
if  [ "$TESTING" == "y" ]; then
### -->!!!<--
 LINUX_VERSION="2.6.33.4"
 CO_SUBDIR="testing/kernel-$LINUX_VERSION"
 CO_SUBDIR2="packages"
 DVERSION="20100530"
 REVISION="-testing"
 TMP=$DVERSION
 export COLINUX_VER="0.7.8-$DVERSION"
 #modulversion
 M_COLINUX_VER="0.7.8$REVISION-$DVERSION"
 #vmlinuxversion
 V_COLINUX_VER="0.7.8$REVISION-$DVERSION"
 [ -f ./vmlinux-$LINUX_VERSION-co-$COLINUX_VER.zip ] || wget "http://www.henrynestler.com/colinux/testing/kernel-2.6.33/packages/$DVERSION/vmlinux-$LINUX_VERSION-co-$V_COLINUX_VER.zip"
 [ -f ./modules-$LINUX_VERSION-co-$COLINUX_VER.tgz ] || wget "http://www.henrynestler.com/colinux/testing/kernel-2.6.33/packages/$DVERSION/modules-$LINUX_VERSION-co-$M_COLINUX_VER.tgz"
 [ -f ./modules-$LINUX_VERSION-co-$COLINUX_VER.tgz ] || mv -v "./modules-$LINUX_VERSION-co-$M_COLINUX_VER.tgz" ./modules-$LINUX_VERSION-co-$COLINUX_VER.tgz
 [ -f ./vmlinux-$LINUX_VERSION-co-$COLINUX_VER.zip ] || mv -v "./vmlinux-$LINUX_VERSION-co-$V_COLINUX_VER.zip" ./vmlinux-$LINUX_VERSION-co-$COLINUX_VER.zip
 [ -f ./daemons-$COLINUX_VER.dbg.zip ] || wget "http://www.henrynestler.com/colinux/testing/kernel-2.6.33/packages/$DVERSION/daemons-$COLINUX_VER.dbg.zip"
 [ -f ./daemons-$COLINUX_VER.zip ] || wget "http://www.henrynestler.com/colinux/testing/kernel-2.6.33/packages/$DVERSION/daemons-$COLINUX_VER.zip"
 cp -f version_test version 
### -->!!!<--
else
 cp -f version_normal version 
 CO_SUBDIR="autobuild"
 wget --no-remove-listing "http://www.henrynestler.com/colinux/$CO_SUBDIR" 
 cat $INDEX.html | grep 'devel-' | sed -e "s|\/\">.*$||" | sed -e "s|^.*devel-||" > $LISTING
 rm -f "$INDEX"*
 tac $LISTING > $TMP
 rm -f $LISTING
 read DVERSION < $TMP
#------------------------------------------------
# set a fix version
#DVERSION="20100606"
DVERSION="20100614"
#------------------------------------------------
 echo "coVersion: $DVERSION"
 CO_SUBDIR2="devel-$DVERSION"
 wget "http://www.henrynestler.com/colinux/$CO_SUBDIR/$CO_SUBDIR2/readme.txt"
 #Subject: autobuild org.colinux.devel 20100523 20:24:41 r1442
 REVISION="-r$(cat readme.txt | grep 'Subject:' | sed -e "s|^.*r||")"
 [ "$REVISION" == "-r" ] && REVISION=""
 rm -f readme.txt
 #REVISION="-r1446"
 echo "Revision: $REVISION"
 LINUX_VERSION="2.6.33.5"
 export COLINUX_VER="0.7.8-$DVERSION"
 M_COLINUX_VER="0.7.8$REVISION-$DVERSION"
 V_COLINUX_VER="0.7.8$REVISION-$DVERSION"
fi
# In use for generating modul dependencyes, this must be the path within modules-*.tgz
export LONG_VER="$LINUX_VERSION-co-0.7.8$REVISION"
sleep 1
sed -i -e "/$DVERSION/d" $TMP
cp $TMP "$TMP"1 
function get_older_modules()
{
while ! [ -e "./modules-$LINUX_VERSION-co-$COLINUX_VER.tgz" ]
do
    read DVERSION_PRI < ./$TMP
    echo "Zeile: $DVERSION_PRI"
    sed -i -e "/$DVERSION_PRI/d" "$TMP"
    CO_SUBDIR2="devel-$DVERSION_PRI"
    wget "http://www.henrynestler.com/colinux/$CO_SUBDIR/$CO_SUBDIR2/readme.txt"
    REVISION="-r$(cat readme.txt | grep 'Subject:' | sed -e "s|^.*r||")"
    [ "$REVISION" == "-r" ] && REVISION=""
    rm -f readme.txt
    echo "Revision: $REVISION"
    M_COLINUX_VER="0.7.8$REVISION-$DVERSION_PRI"
    export LONG_VER="$LINUX_VERSION-co-0.7.8$REVISION"
    wget "http://www.henrynestler.com/colinux/$CO_SUBDIR/devel-$DVERSION_PRI/modules-$LINUX_VERSION-co-$M_COLINUX_VER.tgz" \
    && mv "./modules-$LINUX_VERSION-co-$M_COLINUX_VER.tgz" "./modules-$LINUX_VERSION-co-$COLINUX_VER.tgz" \
    && return 0
done
}
function get_older_vmlinux()
{
while ! [ -e "./vmlinux-$LINUX_VERSION-co-$COLINUX_VER.zip" ]
do
    read DVERSION_PRI < "$TMP"1
    echo "Zeile: $DVERSION_PRI"
    sed -i -e "/$DVERSION_PRI/d" "$TMP"1 
    CO_SUBDIR2="devel-$DVERSION_PRI"
    wget "http://www.henrynestler.com/colinux/$CO_SUBDIR/$CO_SUBDIR2/readme.txt"
    REVISION="-r$(cat readme.txt | grep 'Subject:' | sed -e "s|^.*r||")"
    [ "$REVISION" == "-r" ] && REVISION=""
    rm -f readme.txt
    echo "Revision: $REVISION"
    V_COLINUX_VER="0.7.8$REVISION-$DVERSION_PRI"
    wget "http://www.henrynestler.com/colinux/$CO_SUBDIR/devel-$DVERSION_PRI/vmlinux-$LINUX_VERSION-co-$V_COLINUX_VER.zip" \
    && mv "./vmlinux-$LINUX_VERSION-co-$V_COLINUX_VER.zip" "./vmlinux-$LINUX_VERSION-co-$COLINUX_VER.zip" \
    && return 0
done
}
if  [ "$TESTING" != "y" ]; then
 # Source is only in use for installer version my be an older one
 [ -f ./colinux-$COLINUX_VER.src.tgz ] || wget "http://www.henrynestler.com/colinux/$CO_SUBDIR/$CO_SUBDIR2/colinux-$COLINUX_VER.src.tgz"
#sleep 10
fi

[ -f ./daemons-$COLINUX_VER.dbg.zip ] || wget "http://www.henrynestler.com/colinux/$CO_SUBDIR/$CO_SUBDIR2/daemons-$COLINUX_VER.dbg.zip"
[ -f ./daemons-$COLINUX_VER.zip ] || wget "http://www.henrynestler.com/colinux/$CO_SUBDIR/$CO_SUBDIR2/daemons-$COLINUX_VER.zip"
[ -f ./modules-$LINUX_VERSION-co-$COLINUX_VER.tgz ] || wget "http://www.henrynestler.com/colinux/$CO_SUBDIR/$CO_SUBDIR2/modules-$LINUX_VERSION-co-$M_COLINUX_VER.tgz" || get_older_modules
[ -f ./vmlinux-$LINUX_VERSION-co-$COLINUX_VER.zip ] || wget "http://www.henrynestler.com/colinux/$CO_SUBDIR/$CO_SUBDIR2/vmlinux-$LINUX_VERSION-co-$V_COLINUX_VER.zip" || get_older_vmlinux
[ -f ./modules-$LINUX_VERSION-co-$COLINUX_VER.tgz ] || mv -v "./modules-$LINUX_VERSION-co-$M_COLINUX_VER.tgz" ./modules-$LINUX_VERSION-co-$COLINUX_VER.tgz
[ -f ./vmlinux-$LINUX_VERSION-co-$COLINUX_VER.zip ] || mv -v "./vmlinux-$LINUX_VERSION-co-$V_COLINUX_VER.zip" ./vmlinux-$LINUX_VERSION-co-$COLINUX_VER.zip
#patches werden nur fuers skript gebraucht, muessen nicht neu geladen werden
#[ -f ./linux-2.6.26.8-co-20100524.patch.gz ] || wget "http://www.henrynestler.com/colinux/testing/devel-0.7.8/20100524-Snapshot/kernel-patches/linux-2.6.26.8-co-20100524.patch.gz"
#[ -f ./patches-$LINUX_VERSION-$COLINUX_VER.tar.gz ] || wget "http://www.henrynestler.com/colinux/$CO_SUBDIR/$CO_SUBDIR2/patches-$LINUX_VERSION-$COLINUX_VER.tar.gz"
echo "___ ---___"
#sleep 50
rm -f $TMP
rm -f "$TMP"1
echo "====================================================================================================="
echo "====================================================================================================="
export home=$(pwd)
cd ../bfin-colinux-ori/trunk/upstream
# use devel.exe - only in use for supplying initrd.gz
#--------------------------------------------------------------------
DEVEL_VER="20100612"
#--------------------------------------------------------------------
[ -f coLinux-${DEVEL_VER}.exe ] || wget "http://www.henrynestler.com/colinux/testing/devel-0.7.8/${DEVEL_VER}-Snapshot/devel-coLinux-${DEVEL_VER}.exe"
[ -f devel-coLinux-${DEVEL_VER}.exe ] && mv ./devel-coLinux-${DEVEL_VER}.exe ./coLinux-${DEVEL_VER}.exe
#this would be the old stabile
###[ -f coLinux-0.7.3.exe ] || wget "http://www.henrynestler.com/colinux/releases/0.7.3/coLinux-0.7.3.exe"
#[ -f coLinux-0.7.3-src.tgz ] || wget "http://www.henrynestler.com/colinux/releases/0.7.3/coLinux-0.7.3-src.tgz"
[ -f Xming-mesa-6-9-0-31-setup.exe ] || wget "http://downloads.sourceforge.net/xming/Xming-mesa-6-9-0-31-setup.exe?use_mirror="
#[ -f Xming-fonts-7-3-0-33-setup.exe ] || wget "http://downloads.sourceforge.net/xming/Xming-fonts-7-3-0-33-setup.exe?use_mirror="
[ -f WinPcap_4_0_2.exe ] || wget "http://www.winpcap.org/install/bin/WinPcap_4_0_2.exe"
[ -f putty-0.60-installer.exe ] || wget "http://the.earth.li/~sgtatham/putty/0.60/x86/putty-0.60-installer.exe"
cd $home
cp -af ../bfin-colinux-ori/* ../bfin-colinux
cd ../bfin-colinux/trunk
export COLINUX_EXE_VER=$(find upstream -name 'coLinux-*.exe' | LC_ALL=C sort | tail -n1 | sed 's:.*coLinux-\(.*\).exe:\1:')
echo "Old colinux exe version: $COLINUX_EXE_VER"
[ -d and ] && rm -R and
mkdir and
cd and
#--initrd.gz and colinux-daemon.txt are not includese with demons.zip 
7z x -y ../upstream/coLinux-$COLINUX_EXE_VER.exe
#
COLINUX_PATCHVER="0.7.3"
[ -e ../patches/colinux-$COLINUX_PATCHVER-initrd-hook.patch ] && cp ../patches/colinux-$COLINUX_PATCHVER-initrd-hook.patch ../patches/colinux-$COLINUX_VER-initrd-hook.patch
[ -e ../patches/colinux-$COLINUX_PATCHVER-initrd-hook.patch ] && rm ../patches/colinux-$COLINUX_PATCHVER-initrd-hook.patch
[ -e ../patches/colinux-$COLINUX_PATCHVER-installer.patch ] &&rm ../patches/colinux-$COLINUX_PATCHVER-installer.patch
# get new versions
cd $home
echo "====================================================================================================="
and="../bfin-colinux/trunk/and"

echo "---------------------------------------------------------------------------------------------"
export COLINUX_VER1=$(find -name 'colinux-*.src.tgz' | LC_ALL=C sort | tail -n1 | sed 's:.*colinux-\(.*\).src.tgz:\1:')
cp -v ./colinux-$COLINUX_VER1.src.tgz ../bfin-colinux/trunk/upstream/coLinux-${COLINUX_VER1}.src.tar.gz


7z x -y  vmlinux-$LINUX_VERSION-co-$COLINUX_VER.zip
7z x -y  daemons-$COLINUX_VER.zip
7z x -y  netdriver-tap84.zip
7z x -y  tap32-driver-v9.zip 
7z x -y  file-utils-mingw-bin-stripped.zip
mv ./tuntap $and

mv colinux-bridged-net-daemon.exe $and/colinux-bridged-net-daemon.exe
mv colinux-console-fltk.exe $and/colinux-console-fltk.exe
mv colinux-console-nt.exe $and/colinux-console-nt.exe
mv colinux-daemon.exe $and/colinux-daemon.exe
mv colinux-debug-daemon.exe $and/colinux-debug-daemon.exe
mv colinux-ndis-net-daemon.exe $and/colinux-ndis-net-daemon.exe
mv colinux-net-daemon.exe $and/colinux-net-daemon.exe
mv colinux-serial-daemon.exe $and/colinux-serial-daemon.exe
mv colinux-slirp-net-daemon.exe $and/colinux-slirp-net-daemon.exe 
mv linux.sys $and/linux.sys
mv mkFile.exe $and/mkFile.exe

#chmod 777 ./vmlinux

cp -f vmlinux $and/vmlinux
mkdir -p $and/netdriver
cp modules-$LINUX_VERSION-co-$COLINUX_VER.tgz $and/vmlinux-modules.tar.gz
#[ -f ./patches-$LINUX_VERSION-$COLINUX_VER.tar.gz ] && cp patches-$LINUX_VERSION-$COLINUX_VER.tar.gz $and/patches.tar.gz
mv OemWin2k.inf $and/netdriver/OemWin2k.inf
mv README.TXT $and/netdriver/README.TXT
mv tap.cat $and/netdriver/tap.cat
mv tap0801co.sys $and/netdriver/tap0801co.sys
mv tapcontrol.exe $and/netdriver/tapcontrol.exe
rm URL.txt
rm mkSparse.exe
rm spSize.exe
rm vmlinux
echo "====================================================================================================="
./build-and-installer.sh
sleep 10
#./pack.sh
if  [ "$TESTING" == "y" ]; then
 cp -f version version_test
else
 cp -f version version_normal
fi