#!/bin/bash
echo 	"- Clean *.log files (don't remove files! Set the size to zero.)"
rm -vr /home/*/.cache/*
rm -vr /root/.cache/*
chmod 777 /home
chmod 777 /root
DIRS="$(ls -d */ | grep -v 'mnt')"
#echo "Directorys: $DIRS"
find $DIRS -name \*.log  -type f -print
echo "---------------------"
DIRI="$(find $DIRS  -name \*.log  -type f -print)"
for FILE in $DIRI; do
 echo "" > $FILE
 echo "${FILE}"
done
echo "---------------------"
DIRI="$(find /home /root  \( -name \*history\* -o -name \*messages\* \) -type f -print)"
for FILE in $DIRI; do
 echo "" > $FILE
 echo "${FILE}"
done
echo "---------------------"
DIRI="$(ls /var/log/ )"
for FILE in $DIRI; do
 [ -f /var/log/$FILE ] && echo "" > /var/log/$FILE && echo "${FILE}"
done
echo "---------------------"
apt-get remove ubuntu-minimal -y
#bug -- rsyslog blocks cpu
apt-get remove rsyslog -y
rm -f /etc/init/rsyslog*
rm -f /etc/init/plymouth*
rm -f /etc/init/udev-fallback*

rm -r /lib/modules/*-co-* 2> /dev/null
[ -d /mnt/boot ] && rm -r /boot/* 2> /dev/null
rm -f /var/log/*.gz.*
rm -f /*.log
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

#disable presistant entrys for net
rm -f /etc/udev/rules.d/*.rules
sed -i "s/write_rule /#write_rule /g" /lib/udev/write_net_rules
for i in 0 1 2 3 4 5 6 7 8 9
do
 mknod /dev/cobd$i b 117 $i 2> /dev/null
done
echo " * Initializing ..."
swapoff /dev/1 2> /dev/null
mkswap /dev/1 2> /dev/null
swapon /dev/1 2> /dev/null

echo "zero space - be patient ..."
dd if=/dev/zero of=file.z
cat /dev/zero > file.z
echo "remove temp file patient ..."
rm -v file.z