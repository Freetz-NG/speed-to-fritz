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
CO_SUBDIR="autobuild"
### -->!!!<--
#CO_SUBDIR="testing/kernel-2.6.26"
#http://www.henrynestler.com/colinux/testing/kernel-2.6.26/packages/
#http://www.henrynestler.com/colinux/autobuild/devel-20090926/
### -->!!!<--
wget --no-remove-listing "http://www.henrynestler.com/colinux/$CO_SUBDIR" 
cat $INDEX.html | grep 'devel-' | sed -e "s|\/\">.*$||" | sed -e "s|^.*devel-||" > $LISTING
rm -f "$INDEX"*
tac $LISTING > $TMP
rm -f $LISTING
read DVERSION < $TMP
echo "coVersion: $DVERSION"
LINUX_VERSION="2.6.25.20"
CO_SUBDIR2="devel-$DVERSION"
### -->!!!<--
#LINUX_VERSION="2.6.26"
#DVERSION="20091104"
#CO_SUBDIR2="packages"
### -->!!!<--
export COLINUX_VER="0.8.0-$DVERSION"
sleep 3
sed -i -e "/$DVERSION/d" $TMP
cp $TMP "$TMP"1 
function get_older_modules()
{
while ! [ -e "./modules-$LINUX_VERSION-co-$COLINUX_VER.tgz" ]
do
    read DVERSION_PRI < ./$TMP
    echo "Zeile: $DVERSION_PRI"
    sed -i -e "/$DVERSION_PRI/d" "$TMP" 
    wget "http://www.henrynestler.com/colinux/$CO_SUBDIR/devel-$DVERSION/modules-$LINUX_VERSION-co-0.8.0-$DVERSION_PRI.tgz" \
    && mv "./modules-$LINUX_VERSION-co-0.8.0-$DVERSION_PRI.tgz" "./modules-$LINUX_VERSION-co-$COLINUX_VER.tgz" \
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
    wget "http://www.henrynestler.com/colinux/$CO_SUBDIR/devel-$DVERSION/vmlinux-$LINUX_VERSION-co-0.8.0-$DVERSION_PRI.zip" \
    && mv "./vmlinux-$LINUX_VERSION-co-0.8.0-$DVERSION_PRI.zip" "./vmlinux-$LINUX_VERSION-co-$COLINUX_VER.zip" \
    && return 0
done
}
[ -f ./colinux-$COLINUX_VER.src.tgz ] || wget "http://www.henrynestler.com/colinux/$CO_SUBDIR/$CO_SUBDIR2/colinux-$COLINUX_VER.src.tgz"
#sleep 10
[ -f ./daemons-$COLINUX_VER.dbg.zip ] || wget "http://www.henrynestler.com/colinux/$CO_SUBDIR/$CO_SUBDIR2/daemons-$COLINUX_VER.dbg.zip"
[ -f ./daemons-$COLINUX_VER.zip ] || wget "http://www.henrynestler.com/colinux/$CO_SUBDIR/$CO_SUBDIR2/daemons-$COLINUX_VER.zip"
[ -f ./modules-$LINUX_VERSION-co-$COLINUX_VER.tgz ] || wget "http://www.henrynestler.com/colinux/$CO_SUBDIR/$CO_SUBDIR2/modules-$LINUX_VERSION-co-$COLINUX_VER.tgz" || get_older_modules
[ -f ./vmlinux-$LINUX_VERSION-co-$COLINUX_VER.zip ] || wget "http://www.henrynestler.com/colinux/$CO_SUBDIR/$CO_SUBDIR2/vmlinux-$LINUX_VERSION-co-$COLINUX_VER.zip" || get_older_vmlinux
#[ -f ./patches-$LINUX_VERSION-$COLINUX_VER.tar.gz ] || wget "http://www.henrynestler.com/colinux/$CO_SUBDIR/$CO_SUBDIR2/patches-$LINUX_VERSION-$COLINUX_VER.tar.gz"

      
rm -f $TMP
rm -f "$TMP"1
echo "====================================================================================================="
echo "====================================================================================================="
export home=$(pwd)
cd ../bfin-colinux-ori/trunk/upstream
# use devel only in us if some files would be missing in last release
[ -f coLinux-20090927.exe ] || wget "http://www.henrynestler.com/colinux/testing/devel-0.8.0/20090927-Snapshot/devel-coLinux-20090927.exe"
[ -f devel-coLinux-20090927.exe ] && mv ./devel-coLinux-20090927.exe ./coLinux-20090927.exe
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
#--initrd.gz and colinux-daemon.txt are not includese with new releas so we need them from the old package
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