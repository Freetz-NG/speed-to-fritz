#!/bin/bash -x

set -e

cd ${0%/*}

ANDLINUX_VER=$1
#COLINUX_VER=$(find upstream -name 'coLinux-*.exe' | LC_ALL=C sort | tail -n1 | sed 's:.*coLinux-\(.*\).exe:\1:')
COLINUX_VER=$(find upstream -name 'coLinux-*.src.tar.gz' | LC_ALL=C sort | tail -n1 | sed 's:.*coLinux-\(.*\).src.tar.gz:\1:')
VER="${COLINUX_VER%-*}"
#DATE="$(echo "${COLINUX_VER##*-}" | grep [0123456789])"
DATE="${COLINUX_VER##*-}"
echo "colinux version: $VER"
echo "colinux date: $DATE"

ALL_BASE=${PWD}
BASE=${ALL_BASE}/${ANDLINUX_VER}

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
tar zxf ../../upstream/coLinux-${COLINUX_VER}.src.tar.gz
mv colinux-${DATE} src
cd src
. bin/build-common.sh --get-vars
cd ..
mkdir bin
cd bin
7z x -y ../../../upstream/coLinux-${COLINUX_VER}.exe

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
#cp freetzLinux.exe ${BASE}/freetzLinux-${COLINUX_VER}-freetzLinux-base-${ANDLINUX_VER}.exe
makensis -DBFIN_LITE colinux.nsi
#cp freetzLinux.exe ${BASE}/freetzLinux-${COLINUX_VER}-freetzLinux-lite-${ANDLINUX_VER}.exe
mv freetzLinux.exe /mnt/win/upstream/freetzLinux-${ANDLINUX_VER}.exe
#mv freetzLinux.exe /and/freetzLinux-${ANDLINUX_VER}.exe
