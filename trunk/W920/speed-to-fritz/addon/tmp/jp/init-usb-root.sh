#!/bin/sh

if [ $$ -ne 1 ]; then
	echo "$0: check /proc/sys/urlader/environment "
	echo "    for entry kernel_args and kernel_args1 to run this."
	echo
	echo "# echo kernel_args1 init=$0 > /proc/sys/urlader/environment"
	echo
	exit 1
fi


#- initial PATH and output redirection
	exec 2> /dev/console 1> /dev/console < /dev/console
	PATH='/bin:/sbin:/usr/bin:/usr/sbin'

#- setup
	mods=
	mods="$mods usbcore"
	mods="$mods scsi_mod sd_mod usb-storage"
	mods="$mods musb_hdrc"
	mods="$mods ext2"
	mods="$mods mbcache jbd ext3"
	mnt=/mnt
	rootfs="$mnt/rootfs"
	sleep=15

#- debug
	#set -x 

#- oldroot
	oldroot() {
		while umount /mnt 1> /dev/null 2>&1; do :; done
		while umount /proc 1> /dev/null 2>&1; do :; done
		echo "$my stay on current root filesystem"
		$debug exec /bin/busybox init
	}


my="- usb-root-init -"
echo "$my"


echo "$my init drivers ..."
	mount -t proc proc /proc
	echo "" > /proc/sys/kernel/hotplug
	if [ -n "$mods" ]; then
		for m in $mods; do 
			(
				set -x
				insmod $m 2> /dev/null
			)
		done
	fi


echo -n "$my search for the external storage with the new rootfs ..."
	rootfs_found=no
	olddev=
	while [ 0 -lt $sleep ]; do 
		[ $$ = 1 ] && sleep 1
		echo -n " $sleep ."
		for dev in /dev/sd[a-z][1-9]*; do
			olddev="$dev"
			[ -b "$dev" ] || continue
			dd if=$dev bs=1 count=1 1>/dev/null 2>&1 || continue
			while umount $mnt 2> /dev/null; do :; done
			mount -o ro $dev $mnt 2> /dev/null || continue
			echo -n " $dev "
			[ -d "$rootfs" ] || continue
			[ -x "$rootfs/etc/preinit" ] || continue
			[ -c "$rootfs/dev/console" ] || continue
			[ -c "$rootfs/dev/null" ] || continue
			[ -d "$rootfs/$mnt" ] || continue
			rootfs_found=yes
			break
		done
		umount $mnt 2> /dev/null
		[ "$rootfs_found" = yes ] && break
		sleep=$(( $sleep -1 ))
	done
echo " go"
[ $rootfs_found = no ] && oldroot



echo "$my preparing new filesystem"
	mount -o ro,noatime,nodiratime $dev $mnt

	m_inode="`ls -di $mnt/. | awk '{print $1}'`" 
	r_inode="`ls -di $rootfs/. | awk '{print $1}'`"
	[ $m_node -ne $r_node ] && {
		mount -o bind $rootfs $mnt
	}
	umount /proc


echo "$my init cross fingers - pivot & switch chroot ... "
	cd $mnt
	pivot_root . .$mnt
	
	[ -x ./etc/preinit ] && exec ./etc/preinit
	
	[ -x ./sbin/init ] && exec ./sbin/init


echo "$my weird things happen normally i am now dead jim"
	$debug exec /bin/busybox init # < ./dev/console 1>./dev/console 2>./dev/console

