#!/bin/bash
sdir=$(pwd)
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
[ -f $sdir/initrd1.img ] || echo "First extract the initrd1.img from the debian live iso (gnome , xfce , or kde iso) to $sdir, use 7zip within windows or mount the iso file first."

#7z x -y ./xxx
cp  ./initrd1.img ./initrdco/initrd.gz
cd ./initrdco
gunzip ./initrd.gz
#4.
cpio -ivmd -F ./initrd
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
pwd
#update /lib/modules/
[ -f $sdir/modules-2.6.22.18-co-0.8.0-$DVERSION.tgz ] || echo "run start.sh once to get the needed source"
echo "$sdir"
tar -xf $sdir/modules-2.6.22.18-co-0.8.0-$DVERSION.tgz
rm -rf ./lib/modules/2.6.22*
mkdir -p ./lib/modules/2.6.22.18-co-0.8.0/kernel/extra/aufs ./lib/modules/2.6.22.18-co-0.8.0/kernel/extra/squashfs
[ -f $sdir/aufs/aufs-0+20080719/fs/aufs/aufs.ko ] || echo "run bulid-aufs.co.sh once to get the needed source"
cp $sdir/aufs/aufs-0+20080719/fs/aufs/aufs.ko ./lib/modules/2.6.22.18-co-0.8.0/kernel/extra/aufs/
cp "$(find ./lib/modules -name squashfs.ko)" ./lib/modules/2.6.22.18-co-0.8.0/kernel/extra/squashfs/
#compress initrd.img 
find . | cpio -o -H newc | gzip -9 > $sdir/initrdco.img
echo  "--->  $sdir/initrdco.img"
