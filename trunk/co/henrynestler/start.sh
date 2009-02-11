#!/bin/bash
#svn checkout svn+ssh://anonymous@blackfin.uclinux.org/svnroot/bfin-colinux ../bfin-colinux-ori 
# Attentin: passwort 3 x anonymous
# revision 11
#http://docs.blackfin.uclinux.org/doku.php?id=colinux:building-installer&s[]=colinux
# Remove left over Subversion directories
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
wget --no-remove-listing "http://www.henrynestler.com/colinux/autobuild" 
cat $INDEX.html | grep 'devel-' | sed -e "s|\/\">.*$||" | sed -e "s|^.*devel-||" > $LISTING
rm -f "$INDEX"*
tac $LISTING > $TMP
rm -f $LISTING
read DVERSION < $TMP
echo "coVersion: $DVERSION"
sed -i -e "/$DVERSION/d" $TMP
cp $TMP "$TMP"1 
function get_older_modules()
{
while ! [ -e "./modules-2.6.22.18-co-0.8.0-$DVERSION.tgz" ]
do
    read DVERSION_PRI < ./$TMP
    echo "Zeile: $DVERSION_PRI"
    sed -i -e "/$DVERSION_PRI/d" "$TMP" 
    wget "http://www.henrynestler.com/colinux/autobuild/devel-$DVERSION_PRI/modules-2.6.22.18-co-0.8.0-$DVERSION_PRI.tgz" \
    && mv "./modules-2.6.22.18-co-0.8.0-$DVERSION_PRI.tgz" "./modules-2.6.22.18-co-0.8.0-$DVERSION.tgz" \
    && return 0
done
}
function get_older_vmlinux()
{
while ! [ -e "./vmlinux-2.6.22.18-co-0.8.0-$DVERSION.zip" ]
do
    read DVERSION_PRI < "$TMP"1
    echo "Zeile: $DVERSION_PRI"
    sed -i -e "/$DVERSION_PRI/d" "$TMP"1 
    wget "http://www.henrynestler.com/colinux/autobuild/devel-$DVERSION_PRI/vmlinux-2.6.22.18-co-0.8.0-$DVERSION_PRI.zip" \
    && mv "./vmlinux-2.6.22.18-co-0.8.0-$DVERSION_PRI.zip" "./vmlinux-2.6.22.18-co-0.8.0-$DVERSION.zip" \
    && return 0
done
}
[ -f ./colinux-0.8.0-$DVERSION.src.tgz ] || wget "http://www.henrynestler.com/colinux/autobuild/devel-$DVERSION/colinux-0.8.0-$DVERSION.src.tgz"
[ -f ./daemons-0.8.0-$DVERSION.dbg.zip ] || wget "http://www.henrynestler.com/colinux/autobuild/devel-$DVERSION/daemons-0.8.0-$DVERSION.dbg.zip"
[ -f ./daemons-0.8.0-$DVERSION.zip ] || wget "http://www.henrynestler.com/colinux/autobuild/devel-$DVERSION/daemons-0.8.0-$DVERSION.zip"
[ -f ./modules-2.6.22.18-co-0.8.0-$DVERSION.tgz ] || wget "http://www.henrynestler.com/colinux/autobuild/devel-$DVERSION/modules-2.6.22.18-co-0.8.0-$DVERSION.tgz" || get_older_modules
[ -f ./vmlinux-2.6.22.18-co-0.8.0-$DVERSION.zip ] || wget "http://www.henrynestler.com/colinux/autobuild/devel-$DVERSION/vmlinux-2.6.22.18-co-0.8.0-$DVERSION.zip" || get_older_vmlinux
rm -f $TMP
rm -f "$TMP"1
echo "====================================================================================================="
echo "====================================================================================================="
export home=$(pwd)
export COLINUX_VER=$(find -name 'colinux-*.src.tgz' | LC_ALL=C sort | tail -n1 | sed 's:.*colinux-\(.*\).src.tgz:\1:')
echo "New colinux version: $COLINUX_VER"
cd ../bfin-colinux-ori/trunk/upstream
[ -f coLinux-0.7.3.exe ] || wget "http://www.henrynestler.com/colinux/releases/0.7.3/coLinux-0.7.3.exe"
#[ -f coLinux-0.7.3-src.tgz ] || wget "http://www.henrynestler.com/colinux/releases/0.7.3/coLinux-0.7.3-src.tgz"
[ -f Xming-6-9-0-31-setup.exe ] || wget "http://downloads.sourceforge.net/xming/Xming-6-9-0-31-setup.exe?use_mirror="
#[ -f Xming-fonts-7-3-0-33-setup.exe ] || wget "http://downloads.sourceforge.net/xming/Xming-fonts-7-3-0-33-setup.exe?use_mirror="
[ -f WinPcap_4_0_2.exe ] || wget "http://www.winpcap.org/install/bin/WinPcap_4_0_2.exe"
[ -f putty-0.60-installer.exe ] || wget "http://the.earth.li/~sgtatham/putty/0.60/x86/putty-0.60-installer.exe"
cd $home
cp -af ../bfin-colinux-ori/* ../bfin-colinux
cd ../bfin-colinux/trunk
export COLINUX_OLDVER=$(find upstream -name 'coLinux-*.exe' | LC_ALL=C sort | tail -n1 | sed 's:.*coLinux-\(.*\).exe:\1:')
echo "Old colinux version: $COLINUX_OLDVER"
[ -d and ] && rm -R and
mkdir and
cd and
#--initrd.gz and colinux-daemon.txt are not includese with new releas so we need them from the old package
7z x -y ../upstream/coLinux-$COLINUX_OLDVER.exe
#
[ -e ../patches/colinux-$COLINUX_OLDVER-initrd-hook.patch ] && cp ../patches/colinux-$COLINUX_OLDVER-initrd-hook.patch ../patches/colinux-$COLINUX_VER-initrd-hook.patch
[ -e ../patches/colinux-$COLINUX_OLDVER-initrd-hook.patch ] && rm ../patches/colinux-$COLINUX_OLDVER-initrd-hook.patch
[ -e ../patches/colinux-$COLINUX_OLDVER-installer.patch ] &&rm ../patches/colinux-$COLINUX_OLDVER-installer.patch
# get new versions
cd $home
echo "====================================================================================================="
and="../bfin-colinux/trunk/and"

echo "---------------------------------------------------------------------------------------------"
cp ./colinux-$COLINUX_VER.src.tgz ../bfin-colinux/trunk/upstream/coLinux-${COLINUX_VER}.src.tar.gz


7z x -y  vmlinux-2.6.22.18-co-$COLINUX_VER.zip
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
cp modules-2.6.22.18-co-$COLINUX_VER.tgz $and/vmlinux-modules.tar.gz
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