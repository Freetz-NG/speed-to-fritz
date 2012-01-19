#!/bin/bash -x
if ! [ `id -u` -eq 0 ]; then
 clear
  echo
  echo "This script needs to be executed with 'su' privileges."
  echo 
  echo "Use ./m.sh instead!"
  sleep 10
  exit 0
fi

set -e
cd ${0%/*}
echo
! [ -f ./COLINUX_VER ] && echo "run start.sh first!" && sleep 30 && exit 0
LINUX_VERSION=$(cat ./LINUX_VERSION)
COLINUX_VER=$(cat ./COLINUX_VER)
COLINUX_SHORT_VER=$(cat ./COLINUX_SHORT_VER)
COLINUX_SRC_VER=$(cat ./COLINUX_SRC_VER)
COLINUX_EXE_VER=$(cat ./COLINUX_EXE_VER)
USE_SNAP=$(cat ./USE_SNAP)
DVERSION=$(cat ./DVERSION)
SPEEDLINUX_VER=$(cat ./version)
echo
! [ "$COLINUX_VER" ] && echo "run start.sh first!" && sleep 30 && exit 0
echo "$((++SPEEDLINUX_VER))" >./version
echo "Skriptversion: $SPEEDLINUX_VER"
VER_SRC="${COLINUX_SRC_VER%-*}"
#DATE_SRC="$(echo "${COLINUX_SRC_VER##*-}" | grep [0123456789])"
DATE_SRC="${COLINUX_SRC_VER##*-}"
echo "colinux old version: $VER_SRC"
echo "colinux old date: $DATE_SRC"
echo "COLINUX_EXE_VER: $COLINUX_EXE_VER"
echo "COLINUX_SRC_VER: $COLINUX_SRC_VER"
ALL_BASE=${PWD}
BASE=${ALL_BASE}/${SPEEDLINUX_VER}

# Create our working tree
cd ${ALL_BASE}
rm -rf ${BASE}
mkdir -p ${BASE}/coLinux

# Make tarballs
cd ${ALL_BASE}/tarballs
# some configs 
tar cf andlinux-configs.tar -C configs .
# root inititialisation 1st istallsystem
tar cf init.tar -C init .

# Extract the CoLinux src and binary packages
cd ${BASE}/coLinux
tar zxf ${ALL_BASE}/dl/coLinux-${COLINUX_SRC_VER}.src.tar.gz
mv colinux-${DATE_SRC} src
rm ./src/src/colinux/os/winnt/user/install/colinux.nsi
cp -f ${ALL_BASE}/patches/colinux.nsi ./src/src/colinux/os/winnt/user/install/colinux.nsi
cp -f ${ALL_BASE}/patches/iDl.ini ./src/src/colinux/os/winnt/user/install/iDl.ini
cp -f ${ALL_BASE}/patches/Bild.bmp ./src/src/colinux/os/winnt/user/install/Bild.bmp
cp -f ${ALL_BASE}/patches/header.bmp ./src/src/colinux/os/winnt/user/install/header.bmp
cd src
. bin/build-common.sh --get-vars
cd ..
mkdir bin
cd bin
7z x -y ${ALL_BASE}/dl/coLinux-${COLINUX_EXE_VER}.exe
#--------------------------------------------------------------------->>
if [ "$USE_SNAP" != "y" ]; then
 7z x -y  $ALL_BASE/dl/file-utils-mingw-bin-stripped.zip
 rm URL.txt
 rm mkSparse.exe
 rm spSize.exe
 7z x -y  $ALL_BASE/dl/vmlinux-$LINUX_VERSION-co-$COLINUX_VER.zip
 7z x -y  $ALL_BASE/dl/daemons-$COLINUX_VER.zip
 chmod 777 ./vmlinux
 cp $ALL_BASE/dl/modules-$LINUX_VERSION-co-$COLINUX_VER.tgz vmlinux-modules.tar.gz
 7z x -y  $ALL_BASE/dl/netdriver-tap84.zip
 mkdir -p ./netdriver
 mv OemWin2k.inf ./netdriver/OemWin2k.inf
 mv README.TXT ./netdriver/README.TXT
 mv tap.cat ./netdriver/tap.cat
 mv tap0801co.sys ./netdriver/tap0801co.sys
 mv tapcontrol.exe ./netdriver/tapcontrol.exe
fi
# adititional driver
7z x -y  $ALL_BASE/dl/tap-driver-32_64.zip
mv ./tap-driver-32_64/32-bit ./tuntap
rm -r ./tap-driver-32_64
#set mediastatus
sed -i -e 's|MediaStatus,          Default,   0, "0"|MediaStatus,          Default,   0, "1"|g' ./netdriver/OemWin2k.inf
sed -i -e 's|MediaStatus,          Default,   0, "0"|MediaStatus,          Default,   0, "1"|g' ./tuntap/OemWin2k.inf
echo "====================================================================================================="

# In use for generating modul dependencyes, this must be the path within modules-*.tgz
tar zxf ./vmlinux-modules.tar.gz
LONG_VER=$(ls lib/modules)
echo $LONG_VER > LONG_VER
rm -fR lib
echo "Modulversion in use: $LONG_VER"
7z x -y $ALL_BASE/dl/devel-coLinux-${COLINUX_EXE_VER}.exe
cp $ALL_BASE/replace/* .
ln -s ${ALL_BASE}/Launcher ./
ln -s ${ALL_BASE}/pulseaudio ./
#---------------------------------------------------------------------<<
# Apply our customizations to initrd
cd ${BASE}
mkdir initrd
gunzip coLinux/bin/initrd.gz
sudo mount -o loop coLinux/bin/initrd initrd
for p in ${ALL_BASE}/patches/*.patch ; do
	[ -e "${p}" ] || continue
	patch -p1 < "${p}"
done
sudo umount initrd
gzip -9 coLinux/bin/initrd
rmdir initrd

# Build the installer
COLINUX_LONG_VER="$COLINUX_SHORT_VER.$COLINUX_SRC_VER"
COLINUX_VER="$COLINUX_SHORT_VER-$DVERSION"
COLINUX_INSTALL=${BASE}/coLinux/src/src/colinux/os/winnt/user/install
sed -i -e "s/!define KERNEL_VERSION.*$/!define KERNEL_VERSION \"$LONG_VER\"/" ${COLINUX_INSTALL}/colinux_def.sh
sed -i -e "s/!define VERSION.*$/!define VERSION \"$COLINUX_SHORT_VER\"/" ${COLINUX_INSTALL}/colinux_def.sh
sed -i -e "s/!define LONGVERSION.*$/!define LONGVERSION \"$COLINUX_LONG_VER\"/" ${COLINUX_INSTALL}/colinux_def.sh
sed -i -e "s/!define PRE_VERSION.*$/!define SPEEDLINUX_VER \"$SPEEDLINUX_VER\"/" ${COLINUX_INSTALL}/colinux_def.sh

cd ${BASE}/coLinux/src
sh ${COLINUX_INSTALL}/colinux_def.sh
ln -s ${BASE}/coLinux/bin ${COLINUX_INSTALL}/premaid
ln -s ${ALL_BASE}/scripts ${COLINUX_INSTALL}/
ln -s ${ALL_BASE}/tarballs ${COLINUX_INSTALL}/
ln -s ${ALL_BASE}/upstream ${COLINUX_INSTALL}/
cd ${COLINUX_INSTALL}

makensis colinux.nsi
rm -f ${ALL_BASE}/tarballs/*.tar
mv speedLinux.exe /mnt/win/upstream/speedLinux-${SPEEDLINUX_VER}.exe

rm -fr ${ALL_BASE}/$SPEEDLINUX_VER
sleep 1