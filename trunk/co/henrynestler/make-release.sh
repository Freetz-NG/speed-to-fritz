#!/bin/bash -x
# USED
## ${PWD}/patches/colinux.nsi
## ${PWD}/upstream/coLinux-${$3}.src.tar.gz
## ${PWD}/upstream/coLinux-${$4}.exe
set -e

cd ${0%/*}

SPEEDLINUX_VER=$1
#COLINUX_VER=$(find upstream -name 'coLinux-*.exe' | LC_ALL=C sort | tail -n1 | sed 's:.*coLinux-\(.*\).exe:\1:')
#COLINUX_SRC_VER=$(find upstream -name 'coLinux-*.src.tar.gz' | LC_ALL=C sort | tail -n1 | sed 's:.*coLinux-\(.*\).src.tar.gz:\1:')
COLINUX_VER=$2
COLINUX_SRC_VER=$3
COLINUX_EXE_VER=$4

VER_SRC="${COLINUX_SRC_VER%-*}"
#DATE_SRC="$(echo "${COLINUX_SRC_VER##*-}" | grep [0123456789])"
DATE_SRC="${COLINUX_SRC_VER##*-}"
echo "colinux old version: $VER_SRC"
echo "colinux old date: $DATE_SRC"

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
# root filesystem not coppyed
#if [ ! -e blackfin-root.tar ] ; then
#	echo "Missing root filesystem image: blackfin-root.tar"
#	exit 1
#fi

# Extract the CoLinux src and binary packages
cd ${BASE}/coLinux
tar zxf ${ALL_BASE}/upstream/coLinux-${COLINUX_SRC_VER}.src.tar.gz
mv colinux-${DATE_SRC} src
rm ./src/src/colinux/os/winnt/user/install/colinux.nsi
mv -f ${ALL_BASE}/patches/colinux.nsi ./src/src/colinux/os/winnt/user/install/colinux.nsi
cd src
. bin/build-common.sh --get-vars
cd ..
mkdir bin
cd bin
7z x -y ${ALL_BASE}/upstream/coLinux-${COLINUX_EXE_VER}.exe

# Apply our customizations
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
COLINUX_INSTALL=${BASE}/coLinux/src/src/colinux/os/winnt/user/install
sed -i -e "s/!define KERNEL_VERSION ..KERNEL_VERSION./!define KERNEL_VERSION \"$LONG_VER\"/" ${COLINUX_INSTALL}/colinux_def.sh
cd ${BASE}/coLinux/src
sh ${COLINUX_INSTALL}/colinux_def.sh
ln -s ${BASE}/coLinux/bin ${COLINUX_INSTALL}/premaid
#rm -f ${COLINUX_INSTALL}/header.bmp
#rm -f ${COLINUX_INSTALL}/startlogo.bmp
#ln -s ${ALL_BASE}/header.bmp ${COLINUX_INSTALL}/header.bmp
#ln -s ${ALL_BASE}/startlogo.bmp ${COLINUX_INSTALL}/startlogo.bmp

ln -s ${ALL_BASE}/scripts ${COLINUX_INSTALL}/
ln -s ${ALL_BASE}/tarballs ${COLINUX_INSTALL}/
ln -s ${ALL_BASE}/upstream ${COLINUX_INSTALL}/
cd ${COLINUX_INSTALL}

#makensis -DBFIN_BASE colinux.nsi
makensis -DBFIN_LITE colinux.nsi
mv speedLinux.exe /mnt/win/upstream/speedLinux-${SPEEDLINUX_VER}.exe
