#!/bin/bash
echo "-------------------------------------------------------------------------------------------------------------"
echo
if ! [ `id -u` -eq 0 ]; then
 clear
  echo
  echo "This script needs to be executed with 'su' privileges."
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  sleep 10
  exit 0
fi

#!/bin/sh
# Create, resize and optimize images
#-------------------------------------

#Mostly images are created from minimal distribution installation under Qemu.
#From Qemu-image should use the option "offset" for loop mount.

#Tips for cleanup the image:
#- Run :
#apt-get clean  # on Debian to remove all downloaded files.

#CO_SIZE=40000
CO_WD=`pwd`
cd `dirname $0`
CO_ROOT=`pwd`
cd $CO_ROOT
CO_IMAGE_NEW=/mnt/and/Drives/base.drv
#CO_IMAGE_OLD=/mnt/and/Drives/base.drv.old
CO_LOG=$CO_ROOT/log
cp /dev/null $CO_LOG >> $CO_LOG 2>&1

CO_MOUNT_NEW=$CO_ROOT/tmp/new
#CO_MOUNT_OLD=$CO_ROOT/tmp/old

umount $CO_MOUNT_NEW
#umount $CO_MOUNT_OLD
	
#- You should have an image file, here if not,
#- Create an new empty file.  This is the best to compress it very small.
#Use your favorite size as count. Blocksize is 1MB, the count=1024 in
#the example creates a file with size of 1GB. Increase the count for
#bigger images.

#For coLinux version >= 0.7.1 the old and new image files can live on "cofs"
#mounted file system.  That means, you can create the new image directly in
#our Windows filesystem (... of=/mmt/cofs-Windows/image.new ...).
	      
#- Create a filesystem on the new file

#  dd bs=1k count=$CO_SIZE if=/dev/zero of=$CO_IMAGE_NEW
#  mkfs.ext3 -J size=1 -F -m 0 $CO_IMAGE_NEW

if ! test -f $CO_MOUNT_NEW ; then
  mkdir -p $CO_MOUNT_NEW
fi
#if ! test -f $CO_MOUNT_OLD ; then
#  mkdir -p $CO_MOUNT_OLD
#fi

#- Mount new and (old) images
mount -o loop $CO_IMAGE_NEW $CO_MOUNT_NEW
#mount -o loop,ro $CO_IMAGE_OLD $CO_MOUNT_OLD

#Final clean the image:
echo 	"- Clean files in /var/log (don't remove files! Set the size to zero.)"

for FILE in `ls $CO_MOUNT_NEW/var/log` ; do 
 echo "$FILE"
 rm -f $CO_MOUNT_NEW/var/log/$FILE
 touch $CO_MOUNT_NEW/var/log/$FILE
done

cat <<EOSF >$CO_MOUNT_NEW/clean.sh
#!/bin/sh
rm -rd /lib/modules/*-co-*
rm -rd /boot
rm -f /var/log/*.gz
rm -f /var/run/*.pid
rm -f  /var/log/wtmp
rm -fr /tmp/*
rm -f /src/var/state/apt/lists/ayo.freshrpms.*
rm -f /src/var/cache/apt/*.bin

sudo apt-get autoremove -y
sudo apt-get autoclean -y
sudo apt-get clean -y
EOSF


echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
chroot $CO_MOUNT_NEW /bin/bash /clean.sh
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
rm -f $CO_MOUNT_NEW/clean.sh

 	
					    
#- Unmount images
							    
umount $CO_MOUNT_NEW
#umount $CO_MOUNT_OLD

sync
							    
#- Check and cleanup file system
						    
fsck.ext3 -f $CO_IMAGE_NEW
									
#- Disable time based "Check interval", set more mount counts
									
tune2fs -i 0 -c 60 $CO_IMAGE_NEW
									    
#CoLinux version 0.6.4 counts +2 per boot with initrd, the default 30/2
#would be very often check the file system on boot.
										
#- Compress this image
										
bzip2 <$CO_IMAGE_NEW >$CO_IMAGE_NEW.bz2
										    
#- Test the $CO_IMAGE_NEW on coLinux now.
#If it fails, repair it and repeat the steps from beginning
										        
			  