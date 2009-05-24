#!/bin/bash
sdir=$(pwd)
apt-get install qemu
## start a iso with qemu
#qemu -cdrom binary.iso

# apt-get install live-helper
# apt-get install git-core
# git clone git://git.debian.net/git/debian-live/live-helper.git
# cd live-helper
# dpkg-buildpackage -rfakeroot -b -uc -us
# cd ..
## dpkg -i live-helper*.deb
#git clone git://git.debian.net/git/debian-live/live-initramfs.git
#cd live-initramfs
#dpkg-buildpackage -rfakeroot -b -uc -us
## You can let live-helper automatically use the latest snapshot of live-initramfs by configuring a third-party repository 
## in your live-system configuration. Assumed you have already created a configuration tree with lh_config
#echo "deb http://live.debian.net/debian/ ./" > config/chroot_sources/live-snapshots.chroot
#cp config/chroot_sources/live-snapshots.chroot config/chroot_sources/live-snapshots.binary
#wget http://live.debian.net/debian/archive-key.asc -O config/chroot_sources/live-snapshots.chroot.gpg
#cp config/chroot_sources/live-snapshots.chroot.gpg config/chroot_sources/live-snapshots.binary.gpg

exit
2.2.1. From the Debian repository

Simply install live-helper like any other package:

# apt-get install live-helper

or

# aptitude install live-helper

2.2.2. From source

live-helper is developed using the Git version control system.
On Debian systems, this is provided by the git-core package. To
check out the latest code, execute:

$ git clone git://git.debian.net/git/debian-live/live-helper.git

You can build and install your own Debian package by executing:

 $ cd live-helper
 $ dpkg-buildpackage -rfakeroot -b -uc -us
 $ cd ..
 # dpkg -i live-helper*.deb

You can also use a local version of live-helper without
installation:

# live-helper/helpers/lh_local

Subsequent calls to lh_-prefixed helpers in that shell
environment will then use the version located in the directory
you executed lh_local from.

You can also install live-helper directly to your system by
executing:

# make install

2.2.3. From 'snapshots'

If you do not wish to build or install live-helper from source,
you can use snapshots. These are built automatically from the
latest version in Git and are available on http://
live.debian.net/debian.

2.2.4. From Backports.org

Whilst live-helper and friends were not a part of the Debian
etch release, they will work on etch as well. You will need the
following programs:

 1. An etch backport of either debootstrap or cdebootstrap from
    backports.org

 2. The lenny or sid version of live-helper

2.2.4.1. Installing debootstrap or cdebootstrap from
backports.org

 1. Put this in your /etc/apt/sources.list:

    deb http://www.backports.org/debian etch-backports main

 2. Update the package indices

    apt-get update

 3. Either install debootstrap:

    apt-get install -t etch-backports debootstrap

    or install cdebootstrap:

    apt-get install -t etch-backports cdebootstrap


2.2.4.2. Installing live-helper on etch

It is not recommended that you use live-helper from
backports.org as it is likely to be out of date. The live-helper
package from lenny or sid can be installed on Etch (without
upgrading other packages, such as libc6; it's just shell
scripts).

 1. Install debootstrap or cdebootstrap from backports.org (as
    indicated above).

 2. Install live-helper from testing or unstable

    # apt-get install -t unstable live-helper


Of course you need the testing or unstable sources in /etc/apt/
sources.list for this.

2.3. live-initramfs

N.B. You do not need to install live-initramfs on your system to
create customised Debian Live systems. However, doing so will do
no harm.

2.3.1. Using a customised live-initramfs

To modify the code you can follow the process below. Please
ensure you are familiar with the terms mentioned in
Section 1.1.1, ?Terms?.

 1. Checkout the live-initramfs source

    $ git clone git://git.debian.net/git/debian-live/live-initramfs.git

 2. Make changes to your local copy

    And beware that if you want to add your pre-init script in
    live-bottom, you should name it without dashes '-', e.g:
    call it "81new_feature" and not "81new-feature".

 3. Build a live-initramfs .deb

    You must build either on your target distribution or in a
    chroot containing your target platform: this means if your
    target is lenny then you should build against lenny. You can
    use a personal builder such as pbuilder to automate building
    packages in chroot. To build directly on the target
    platform, use dpkg-buildpackage (provided by the dpkg-dev
    package):

  $ git clone git://git.debian.net/git/debian-live/live-initramfs.git

    $ cd live-initramfs
    $ dpkg-buildpackage -rfakeroot -b -uc -us

 4. Use the generated live-initramfs .deb

    As live-initramfs is installed by the build system,
    installing the package in the host system is not sufficient:
    you should treat the generated .deb like another custom
    package. Please see Section 5.1.4, ?Installing modified or
    third-party packages? for more information. You should pay
    particular attention to Section 5.1.4.3, ?Custom packages
    and APT?.

2.3.2. Using a live-initramfs snapshots

You can let live-helper automatically use the latest snapshot of
live-initramfs by configuring a third-party repository in your
live-system configuration. Assumed you have already created a
configuration tree with lh_config

##build initrd
[ -d ./makeinit ] || mkdir ./makeinit
cd ./makeinit
##info on cent os:
##http://blog.gbraad.nl/2009/03/manually-installing-centos-52-on.html
rm -fr ./initrdco
mkdir ./initrdco

#1. initrd.img 
#Let's extract the initrd
#1. extract the initrd.img from the debian live iso (gnome , xfce , or kde iso) to ~/

#7z x -y ./xxx
cp  ./initrd1.img ./initrdco/initrd.gz
cd ./initrdco
gunzip ./initrd.gz
#4.
cpio -ivmd -F ./initrd
rm ./initrd

cat <<EOSF >./scripts/live-bottom/99hook
#!/bin/sh
#set -e
# initramfs-tools header
PREREQ=""
prereqs()
{
	echo "\${PREREQ}"
}
case "\${1}" in
	prereqs)
		prereqs
		exit 0
		;;
esac
# live-initramfs header
if [ -z "\${HOOK}" ]
then
	exit 0
fi
. /scripts/live-functions
log_begin_msg "Executing custom hook script"
# live-initramfs script
mkdir /live/cofsshare
mount -t cofs 31 /live/cofsshare
cp /live/cofsshare/"\${HOOK}" /root/
chmod 0755 /root/"\${HOOK}"
/root/"\${HOOK}"
#rm -f /root/"\${HOOK}"
umount /live/cofsshare
rm -rf /live/cofsshare
log_end_msg
EOSF
#get_latest_colinux_versiono
INDEX="./index"
LISTING="./listing"
TMP="./temp"
rm -f $TMP
rm -f "$INDEX"*
rm -f $LISTING
wget --no-remove-listing "http://www.henrynestler.com/colinux/autobuild" 
cat $INDEX.html | grep 'devel-' | sed -e "s|\/\">.*$||" | sed -e "s|^.*devel-||" > $LISTING
rm -f "$INDEX"*
tac $LISTING > $TMP
rm -f $LISTING
read DVERSION < $TMP
echo "coVersion: $DVERSION"
rm -f $TMP
#-----------------------------------------------------
pwd
#update /lib/modules/
[ -f $sdir/modules-2.6.22.18-co-0.8.0-$DVERSION.tgz ] || echo "run start.sh once to get the needed source"
echo "$sdir"
rm -rf ./lib/modules/2.6.*
tar -xf $sdir/modules-2.6.22.18-co-0.8.0-$DVERSION.tgz
mkdir -p ./lib/modules/2.6.22.18-co-0.8.0/kernel/extra/aufs ./lib/modules/2.6.22.18-co-0.8.0/kernel/extra/squashfs
[ -f $sdir/aufs/aufs-0+20080719/fs/aufs/aufs.ko ] || echo "run bulid-aufs.co.sh once to get the needed source"
cp $sdir/aufs/aufs-0+20080719/fs/aufs/aufs.ko ./lib/modules/2.6.22.18-co-0.8.0/kernel/extra/aufs/
cp "$(find ./lib/modules -name squashfs.ko)" ./lib/modules/2.6.22.18-co-0.8.0/kernel/extra/squashfs/
#compress initrd.img 
find . | cpio -o -H newc | gzip -9 > $sdir/initrdco.img
echo  "--->  $sdir/initrdco.img"
