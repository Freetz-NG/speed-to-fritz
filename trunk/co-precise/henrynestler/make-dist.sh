#!/bin/sh
echo "Make Distribution ----->"
! [ -f /mnt/win/and/Drives/base_1.vdi ] && echo "A copy of the Drives/base.vdi must be present in the same directory named base_1.vdi" && sleep 5 && exit 0
VER="karmic" # this works
VER="oneiric" # problems with udev
VER="jaunty"
VER="lucid" # problems with udev
VER="precise"

apt-get install debootstrap
! [ -l /usr/share/debootstrap/scripts/$VER ] || (cd /usr/share/debootstrap/scripts; ln -s gutsy $VER)
sudo apt-get install schroot
umount /cobd3
umount /image
[ -d "/image" ] || mkdir /image
sudo mount -o loop -t ext3  /dev/cobd5 /image
rm -fr /image/*
sudo debootstrap --verbose --variant=buildd --arch i386  $VER /image http://old-releases.ubuntu.com/ubuntu/
schroot -l
cp /etc/hosts /image/etc/hosts
cp /etc/network/interfaces /image/etc/network/interfaces
cp /etc/rc.local /image/etc/rc.local
cp /etc/profile /image/etc/profile
cat <<EOF >> /image/etc/apt/sources.list
# Ubuntu supported packages (packages, GPG key: 437D05B5)
deb http://gb.archive.ubuntu.com/ubuntu/ natty main restricted
deb http://gb.archive.ubuntu.com/ubuntu/ natty-updates main restricted
deb http://security.ubuntu.com/ubuntu/ natty-security main restricted

# Ubuntu community supported packages (packages, GPG key: 437D05B5)
deb http://gb.archive.ubuntu.com/ubuntu/ natty universe multiverse
deb http://gbe.archive.ubuntu.com/ubuntu/ natty-updates universe multiverse
deb http://security.ubuntu.com/ubuntu/ natty-security universe multiverse
EOF
#cp /etc/apt/sources.list /image/etc/apt/sources.list
sed -i "s/natty/$VER/g" /image/etc/apt/sources.list
cat <<EOF > /image/etc/fstab
# /etc/fstab: static file system information.
#
# <file system>	<mount point>	<type>	<options>		<dump>	<pass>
proc		/proc		proc	defaults		0	0
/dev/cobd0      /               ext3    defaults                1       1
EOF
#cp /etc/fstab /image/etc/network/fstab
#----------------------------------------------------------------------------------------------------------
##clean
cat <<EOSF >/setup-clean.sh
#!/bin/bash
mkdir /mnt/and
#https://help.ubuntu.com/community/DebootstrapChroot
#[ you may use aptitude, install mc and vim ... ]
apt-get install ubuntu-minimal
apt-get install fping pump synaptic konsole -y
# make dev if not existant
for i in 0 1 2 3 4 5 6 7 8 9
do
  if ! test -f /image/dev/cobd$i ; then
      mknod /image/dev/cobd$i b 117 $i 
  fi
done
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
echo "please wait until zerro file termiants with out of space!"
dd if=/dev/zero of=file.z
#cat /dev/zero > file.z
rm file.z
EOSF
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
echo "run /setup-clean.sh once you have changed root !"
sleep 5
schroot -c ${VER}_i386 -u root
#chroot /image /bin/bash /setup-clean.sh
#cd /
sync
#umount -a
#umount /proc
#sync
echo "-----> Make Distribution End <-----"
sleep 5
exit 0
