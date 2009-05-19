#!/bin/bash
#get_latest_colinux_version
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
#-----------------------------------------------------
apt-get install dpkg-dev bison flex
mkdir ./colinux080
[ -f ./colinux-0.8.0-$DVERSION.src.tgz ] || wget "http://www.henrynestler.com/colinux/autobuild/devel-$DVERSION/colinux-0.8.0-$DVERSION.src.tgz"
cd ./colinux080
tar zxf ../colinux-0.8.0-$DVERSION.src.tgz
cd colinux-$DVERSION
./configure
make kernel
cd ../..
#####apt-get install autotools-dev fakeroot dh-make build-essential
mkdir ./aufs
cd ./aufs

## !!!!! etc/source.list add dep-src first !!!!!
sudo apt-get update
apt-get source aufs
cd aufs-0+20080719
sudo make KDIR=../../colinux080/build/linux-2.6.22.18-build -f local.mk

exit

# Automatically generated sources.list
# http://www.ubuntulinux.nl/source-o-matic
#
# If you get errors about missing keys, lookup the key in this file
# and run these commands (replace KEY with the key number)
#
# gpg --keyserver subkeys.pgp.net --recv KEY
# gpg --export --armor KEY | sudo apt-key add -

# Ubuntu supported packages (packages, GPG key: 437D05B5)
deb http://us.archive.ubuntu.com/ubuntu jaunty main restricted
deb http://us.archive.ubuntu.com/ubuntu jaunty-updates main restricted
deb http://security.ubuntu.com/ubuntu jaunty-security main restricted

deb-src http://us.archive.ubuntu.com/ubuntu jaunty main restricted
deb-src http://us.archive.ubuntu.com/ubuntu jaunty-updates main restricted
deb-src http://security.ubuntu.com/ubuntu jaunty-security main restricted

# Ubuntu community supported packages (packages, GPG key: 437D05B5)
deb http://us.archive.ubuntu.com/ubuntu jaunty universe multiverse
deb http://us.archive.ubuntu.com/ubuntu jaunty-updates universe multiverse
deb http://security.ubuntu.com/ubuntu jaunty-security universe multiverse

deb-src http://us.archive.ubuntu.com/ubuntu jaunty universe multiverse
deb-src http://us.archive.ubuntu.com/ubuntu jaunty-updates universe multiverse
deb-src http://security.ubuntu.com/ubuntu jaunty-security universe multiverse
