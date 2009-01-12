#!/bin/bash -x

set -e

cd ${0%/*}

BLACKFIN_VER=$1
COLINUX_VER=$(find upstream -name 'coLinux-*.exe' | LC_ALL=C sort | tail -n1 | sed 's:.*coLinux-\(.*\).exe:\1:')

ALL_BASE=${PWD}
BASE=${ALL_BASE}/${BLACKFIN_VER}

# Create our working tree
cd ${ALL_BASE}
rm -rf ${BASE}
mkdir -p ${BASE}/coLinux

# Make tarballs
cd ${ALL_BASE}/tarballs
tar cf blackfin-configs.tar -C configs .
tar cf init.tar -C init .
if [ ! -e blackfin-root.tar ] ; then
	echo "Missing root filesystem image: blackfin-root.tar"
	exit 1
fi

# Extract the CoLinux src and binary packages
cd ${BASE}/coLinux
tar zxf ../../upstream/coLinux-${COLINUX_VER}-src.tar.gz
mv coLinux-${COLINUX_VER} src
cd src
. bin/build-common.sh --get-vars
cd ..
mkdir bin
cd bin
7z x ../../../upstream/coLinux-${COLINUX_VER}.exe > /dev/null

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
ln -s ${ALL_BASE}/scripts ${COLINUX_INSTALL}/
ln -s ${ALL_BASE}/tarballs ${COLINUX_INSTALL}/
ln -s ${ALL_BASE}/upstream ${COLINUX_INSTALL}/
cd ${COLINUX_INSTALL}

makensis -DBFIN_BASE colinux.nsi
cp coLinux.exe ${BASE}/coLinux-${COLINUX_VER}-blackfin-base-${BLACKFIN_VER}.exe
makensis -DBFIN_LITE colinux.nsi
cp coLinux.exe ${BASE}/coLinux-${COLINUX_VER}-blackfin-lite-${BLACKFIN_VER}.exe
