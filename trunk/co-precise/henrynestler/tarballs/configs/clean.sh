#!/bin/bash
echo 	"- Clean files in /var/log (don't remove files! Set the size to zero.)"
DIRS="$(ls -d */ | grep -v 'mnt')"
echo "Directorys: $DIRS"
DIRI="$(find $DIRS \( -name *.log  -o -name dmesg* -o -name messages \) -type f -print)"
for FILE in $DIRI; do
 echo "" > $FILE
 echo "${FILE}"
done
echo "---------------------"
DIRI="$(find home root \( -name history -o -name messages \) -type f -print)"
for FILE in $DIRI; do
 echo "" > $FILE
 echo "${FILE}"
done
rm -rd /lib/modules/*-co-*
rm -rd /boot
rm -f /var/log/*.gz
rm -f /var/run/*.pid
rm -f  /var/log/wtmp
rm -fr /tmp/*
rm -f /src/var/state/apt/lists/ayo.freshrpms.*
rm -f /src/var/cache/apt/*.bin
rm -f /var/cache/apt/archives/*.deb
mkdir -p /var/cache/apt/archives/partial
sudo apt-get autoremove -y
sudo apt-get autoclean -y
sudo apt-get clean -y
dd if=/dev/zero of=file.z
#cat /dev/zero > file.z
rm -v file.z
