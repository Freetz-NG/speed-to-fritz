#!/bin/sh
#found this later -- some explanation here:
#http://www.tekcited.net/colinux-create-an-ubuntu-image-from-scratch/
echo "Make Distribution ----->"
! [ -f /mnt/and/Drives/base_1.vdi ] && echo "A copy of the Drives/base.vdi must be present in the same directory named base_1.vdi" && sleep 5 && exit 0
VER="karmic" # this works
VER="jaunty"
VER="lucid" # problems with udev
VER="oneiric"
VER="precise"
apt-get update
apt-get upgrade
apt-get install debootstrap
sudo apt-get install schroot
! [ -e /usr/share/debootstrap/scripts/$VER ] || (cd /usr/share/debootstrap/scripts; ln -s gutsy $VER)
umount /cobd5
umount /image
[ -d "/image" ] || mkdir /image
sudo mount -o loop -t ext3  /dev/cobd5 /image
echo "remove old content ..."
rm -fr /image/*
sudo debootstrap --verbose --variant=buildd --arch i386  $VER /image http://us.archive.ubuntu.com/ubuntu/
cp /clean.sh /image/clean.sh
cp /etc/hosts /image/etc/hosts
cp /etc/network/interfaces /image/etc/network/interfaces
cp /etc/rc.local /image/etc/rc.local
cp /etc/profile /image/etc/profile
cp /etc/mount_all /image/etc/mount_all

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
cat <<EOSF >/image/setup-minimal.sh
#!/bin/bash
mkdir /mnt/and
chmod 777 /root
chmod 777 /home
#upstart jobs verhindern
##dpkg-divert --local --rename --add /sbin/initctl
##ln -s /bin/true /sbin/initctl
#https://help.ubuntu.com/community/DebootstrapChroot
#[ you may use aptitude, install mc and vim ... ]
apt-get install ubuntu-minimal
apt-get update
#apt-get upgrade
apt-get install fping sudo
apt-get install pump
apt-get install synaptic
apt-get install mc
apt-get install sux
apt-get install ssh
apt-get install scite
apt-get install sudo

apt-get install xfce4-panel
apt-get install xfce4-terminal
apt-get install xfce4-taskmanager
apt-get install xfce4-utils
apt-get install xfce4-settings
apt-get install thunar
apt-get install xfce4-notes
apt-get install xfce4-volumed
apt-get install xfce4-appfinder
apt-get install xfce4-artwork

#bug -- rsyslog blocks cpu
rm -f /etc/init/plymouth*
rm -f /etc/init/udev-fallback*
rm -f /etc/init/rsyslog*
#disable presistant entrys for net
rm -f /etc/udev/rules.d/*.rules
sed -i "s/write_rule /#write_rule /g" /lib/udev/write_net_rules
EOSF
chmod 777 /image/setup-minimal.sh
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
echo "run now: /setup-minimal.sh and /clean.sh with chroot!"
sleep 2
echo "We start chroot now!"
sleep 2
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
#http://wiki.ubuntuusers.de/schroot
cat <<EOSF >/etc/schroot/chroot.d/${VER}_i386.conf
[${VER}_i386]
description=Ubuntu ${VER} for i386
location=/image
type=directory
users=freetz
EOSF
#----
schroot -c ${VER}_i386 -u root -- /setup-minimal.sh
sync

schroot -c ${VER}_i386 -u root -- /clean.sh
sync

schroot -c ${VER}_i386 -u root
sync
echo "-----> Make Distribution End <-----"
sleep 5
exit 0
