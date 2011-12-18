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
 ##INDEX="./index"
 INDEX="./autobuild"
 LISTING="./listing"
 TMP="./temp"
 rm -f $TMP
 rm -f "$TMP"1
 rm -f "$INDEX"*
 rm -f $LISTING
#------------------------------------------
#------------------------------------------
USE_SNAP="n" # look down on label # USE_SNAP ------>
TESTING="n"
#------------------------------------------
#------------------------------------------
if  [ "$TESTING" == "y" ]; then
### -->!!!<--
 LINUX_VERSION="2.6.33.7"
 CO_SUBDIR="testing/kernel-$LINUX_VERSION"
 CO_SUBDIR2="packages"
 DVERSION="20100530"
 REVISION="-testing"
 TMP=$DVERSION
 export COLINUX_SHORT_VER="0.7.9"
 export COLINUX_LONG_VER="$COLINUX_SHORT_VER.$DVERSION"
 export COLINUX_VER="0.7.9-$DVERSION"
 #modulversion
 M_COLINUX_VER="0.7.9$REVISION-$DVERSION"
 #vmlinuxversion
 V_COLINUX_VER="0.7.9$REVISION-$DVERSION"
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
 cat $INDEX | grep 'devel-' | sed -e "s|\/\">.*$||" | sed -e "s|^.*devel-||" > $LISTING
 rm -f "$INDEX"*
 tac $LISTING > $TMP
 rm -f $LISTING
 read DVERSION < $TMP
#------------------------------------------------
# set a fix version
##DVERSION="20100915"
#------------------------------------------------
 echo "coVersion: $DVERSION"
 CO_SUBDIR2="devel-$DVERSION"
 wget "http://www.henrynestler.com/colinux/$CO_SUBDIR/$CO_SUBDIR2/readme.txt"
 #Subject: autobuild org.colinux.devel 20100523 20:24:41 r1442
 REVISION="-r$(cat readme.txt | grep 'Subject:' | sed -e "s|^.*r||")"
 [ "$REVISION" == "-r" ] && REVISION=""
 rm -f readme.txt
 #REVISION="-r1527"
 echo "Revision: $REVISION"
 LINUX_VERSION="2.6.33.7"
 export COLINUX_SHORT_VER="0.7.10"
 export COLINUX_LONG_VER="$COLINUX_SHORT_VER.$DVERSION"
 export COLINUX_VER="0.7.10-$DVERSION"
 M_COLINUX_VER="0.7.10$REVISION-$DVERSION"
 V_COLINUX_VER="0.7.10$REVISION-$DVERSION"
fi
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
    M_COLINUX_VER="0.7.10$REVISION-$DVERSION_PRI"
    export LONG_VER="$LINUX_VERSION-co-0.7.10$REVISION"
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
    V_COLINUX_VER="0.7.10$REVISION-$DVERSION_PRI"
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
if [ "$USE_SNAP" != "y" ]; then
 [ -f ./daemons-$COLINUX_VER.dbg.zip ] || wget "http://www.henrynestler.com/colinux/$CO_SUBDIR/$CO_SUBDIR2/daemons-$COLINUX_VER.dbg.zip"
 [ -f ./daemons-$COLINUX_VER.zip ] || wget "http://www.henrynestler.com/colinux/$CO_SUBDIR/$CO_SUBDIR2/daemons-$COLINUX_VER.zip"
 [ -f ./modules-$LINUX_VERSION-co-$COLINUX_VER.tgz ] || wget "http://www.henrynestler.com/colinux/$CO_SUBDIR/$CO_SUBDIR2/modules-$LINUX_VERSION-co-$M_COLINUX_VER.tgz" || get_older_modules
 [ -f ./vmlinux-$LINUX_VERSION-co-$COLINUX_VER.zip ] || wget "http://www.henrynestler.com/colinux/$CO_SUBDIR/$CO_SUBDIR2/vmlinux-$LINUX_VERSION-co-$V_COLINUX_VER.zip" || get_older_vmlinux
 [ -f ./modules-$LINUX_VERSION-co-$COLINUX_VER.tgz ] || mv -v "./modules-$LINUX_VERSION-co-$M_COLINUX_VER.tgz" ./modules-$LINUX_VERSION-co-$COLINUX_VER.tgz
 [ -f ./vmlinux-$LINUX_VERSION-co-$COLINUX_VER.zip ] || mv -v "./vmlinux-$LINUX_VERSION-co-$V_COLINUX_VER.zip" ./vmlinux-$LINUX_VERSION-co-$COLINUX_VER.zip
fi
#http://www.henrynestler.com/colinux/autobuild/devel-20110606/daemons-0.7.10-20110606.dbg.zip
#http://www.henrynestler.com/colinux/autobuild/devel-20110606/daemons-0.7.10-20110606.zip
#http://www.henrynestler.com/colinux/autobuild/devel-20110606/vmlinux-2.6.33.7-co-0.7.10-r1586-20110606.zip
#http://www.henrynestler.com/colinux/autobuild/devel-20110606/modules-2.6.33.7-co-0.7.10-r1586-20110606.tgz

#patches werden nur fuers skript gebraucht, muessen nicht neu geladen werden
#[ -f ./linux-2.6.26.8-co-20100524.patch.gz ] || wget "http://www.henrynestler.com/colinux/testing/devel-0.7.10/20100524-Snapshot/kernel-patches/linux-2.6.26.8-co-20100524.patch.gz"
#[ -f ./patches-$LINUX_VERSION-$COLINUX_VER.tar.gz ] || wget "http://www.henrynestler.com/colinux/$CO_SUBDIR/$CO_SUBDIR2/patches-$LINUX_VERSION-$COLINUX_VER.tar.gz"
echo "___---___"
#sleep 50
rm -f $TMP
rm -f "$TMP"1
echo "====================================================================================================="
echo "====================================================================================================="
export home=$(pwd)
#Downloaddir for staff that is always needed
DL_DIR="$home/../bfin-colinux-ori/trunk/upstream"
cd $DL_DIR
# use devel.exe - only in use for supplying initrd.gz or if snapshot is used
#--------------------------------------------------------------------
# USE_SNAP ------>
DEVEL_VER="20110409"
#http://www.henrynestler.com/colinux/testing/devel-0.7.9/20100702-Snapshot/devel-coLinux-20100702.exe
#http://www.henrynestler.com/colinux/testing/devel-0.7.9/20110205-Snapshot/devel-coLinux-20110205.exe
#http://www.henrynestler.com/colinux/testing/devel-0.7.9/20110409-Snapshot/devel-coLinux-20110409.exe
#--------------------------------------------------------------------
[ -f devel-coLinux-${DEVEL_VER}.exe ] || wget "http://www.henrynestler.com/colinux/testing/devel-0.7.9/${DEVEL_VER}-Snapshot/devel-coLinux-${DEVEL_VER}.exe"
[ -f devel-coLinux-${DEVEL_VER}.exe ] && cp ./devel-coLinux-${DEVEL_VER}.exe ./coLinux-${DEVEL_VER}.exe
# USE_SNAP <------
#### -> This would be the old stabile
###[ -f coLinux-0.7.3.exe ] || wget "http://www.henrynestler.com/colinux/releases/0.7.3/coLinux-0.7.3.exe"
###[ -f coLinux-0.7.3-src.tgz ] || wget "http://www.henrynestler.com/colinux/releases/0.7.3/coLinux-0.7.3-src.tgz"
#### <-
[ -f Xming-mesa-6-9-0-31-setup.exe ] || wget "http://downloads.sourceforge.net/xming/Xming-mesa-6-9-0-31-setup.exe?use_mirror=" --output-document="Xming-mesa-6-9-0-31-setup.exe"
#[ -f Xming-fonts-7-3-0-33-setup.exe ] || wget "http://downloads.sourceforge.net/xming/Xming-fonts-7-3-0-33-setup.exe?use_mirror="
[ -f WinPcap_4_0_2.exe ] || wget "http://www.winpcap.org/install/bin/WinPcap_4_0_2.exe"
[ -f putty-0.60-installer.exe ] || wget "http://the.earth.li/~sgtatham/putty/0.60/x86/putty-0.60-installer.exe"
cd $home
export COLINUX_SRC_VER="$(find -name 'colinux-*.src.tgz' | LC_ALL=C sort | tail -n1 | sed 's:.*colinux-\(.*\).src.tgz:\1:')"
cp -v ./colinux-$COLINUX_SRC_VER.src.tgz $DL_DIR/coLinux-${COLINUX_SRC_VER}.src.tar.gz
cp -af ../bfin-colinux-ori/* ../bfin-colinux
cd ../bfin-colinux/trunk
#export COLINUX_EXE_VER="$(find upstream -name 'devel-coLinux-*.exe' | LC_ALL=C sort | tail -n1 | sed 's:.*coLinux-\(.*\).exe:\1:')"
export COLINUX_EXE_VER=${DEVEL_VER}

echo "Old colinux exe version: $COLINUX_EXE_VER"
[ -d and ] && rm -R and
mkdir and
cd and
#--get initrd.gz or all if snapshot is used
7z x -y ../upstream/devel-coLinux-${DEVEL_VER}.exe
COLINUX_PATCHVER="0.7.3"
[ -e ../patches/colinux-$COLINUX_PATCHVER-initrd-hook.patch ] && cp ../patches/colinux-$COLINUX_PATCHVER-initrd-hook.patch ../patches/colinux-$COLINUX_VER-initrd-hook.patch
[ -e ../patches/colinux-$COLINUX_PATCHVER-initrd-hook.patch ] && rm ../patches/colinux-$COLINUX_PATCHVER-initrd-hook.patch
[ -e ../patches/colinux-$COLINUX_PATCHVER-installer.patch ] && rm ../patches/colinux-$COLINUX_PATCHVER-installer.patch
# get new versions
echo "====================================================================================================="
if [ "$USE_SNAP" != "y" ]; then
 7z x -y  $home/file-utils-mingw-bin-stripped.zip
 rm URL.txt
 rm mkSparse.exe
 rm spSize.exe
 7z x -y  $home/vmlinux-$LINUX_VERSION-co-$COLINUX_VER.zip
 7z x -y  $home/daemons-$COLINUX_VER.zip
 chmod 777 ./vmlinux
 cp $home/modules-$LINUX_VERSION-co-$COLINUX_VER.tgz vmlinux-modules.tar.gz
 7z x -y  $home/netdriver-tap84.zip
 mkdir -p ./netdriver
 mv OemWin2k.inf ./netdriver/OemWin2k.inf
 mv README.TXT ./netdriver/README.TXT
 mv tap.cat ./netdriver/tap.cat
 mv tap0801co.sys ./netdriver/tap0801co.sys
 mv tapcontrol.exe ./netdriver/tapcontrol.exe
fi
# adititional driver
7z x -y  $home/tap32-driver-v9.zip
#set mediastatus
sed -i -e 's|MediaStatus,          Default,   0, "0"|MediaStatus,          Default,   0, "1"|g' ./netdriver/OemWin2k.inf
sed -i -e 's|MediaStatus,          Default,   0, "0"|MediaStatus,          Default,   0, "1"|g' ./tuntap/OemWin2k.inf
echo "====================================================================================================="
cd $home
# In use for generating modul dependencyes, this must be the path within modules-*.tgz
tar zxf ../bfin-colinux/trunk/and/vmlinux-modules.tar.gz
export LONG_VER=$(ls lib/modules)
rm -fR lib
#export LONG_VER="$LINUX_VERSION-co-0.7.10$REVISION"
echo "Modulversion in use: $LONG_VER"
./build-and-installer.sh
#./pack.sh
if  [ "$TESTING" == "y" ]; then
 cp -f version version_test
else
 cp -f version version_normal
fi
echo "Info:"
echo "For transfering images bigger as usual one must do it this way:"
echo "ssh -t jpascher,speedlinux@shell.sourceforge.net create"
echo "sf-help aufrufen und Port und Adressen nachsehen die dann in WinSCP fuer die Verbindung verwendet werden."
sleep 5