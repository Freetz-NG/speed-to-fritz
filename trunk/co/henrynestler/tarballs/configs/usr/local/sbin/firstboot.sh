#!/bin/bash
if [ -f /mnt/and/firstboot.txt ] ; then
	# move to andLinux filesystem to avoid temporal side effects...
	cp -f /mnt/and/firstboot.txt /tmp/firstboot.txt
	# convert to UNIX format, otherwise \r is remaining at the end of the parameters...
	/usr/bin/dos2unix /tmp/firstboot.txt

	# create login/password
	login=`cat /tmp/firstboot.txt | grep login | cut -d = -f 2`
	passwd=`cat /tmp/firstboot.txt | grep passwd | cut -d = -f 2 | sed -e "s/'/\\\\\\'/g"`
	# make the login choice foolproof
	if [ `grep -c "$login" /etc/passwd` -ne 0 ] ; then
		login="cobuntu"
		passwd="rescue"
	fi
	/usr/sbin/useradd -m -p `perl -e "print crypt('$passwd', 'aL')"` -U -G admin,lpadmin -s /bin/bash $login

	# remove possibly existing old /mnt/win mount point
	if [ `grep -c "/mnt/win" /etc/fstab` -ne 0 ] ; then
		if [ `mount | grep -c "/mnt/win"` -ne 0 ] ; then
			umount /mnt/win
		fi
		grep -v "/mnt/win" /etc/fstab > /tmp/fstab
		mv -f /etc/fstab /etc/fstab.old
		mv -f /tmp/fstab /etc/fstab
		chmod 644 /etc/fstab
	fi

	# add new /mnt/win mount point
	mounttype=`cat /tmp/firstboot.txt | grep mounttype | cut -d = -f 2`
	mkdir -p /mnt/win
	if [ $mounttype = "cofs" ] ; then
		echo "/dev/cofs0 /mnt/win cofs defaults,uid=$login,gid=$login,dmask=0755,fmask=0755 0 0" >> /etc/fstab
		pushd /home/$login
		ln -s /mnt/win/ windows
		popd
	elif [ $mounttype = "samba" ] ; then
		mountshare=`cat /tmp/firstboot.txt | grep mountshare | cut -d = -f 2`
		# fstab entry doesn't work because mounting is done too early (network unavailable)
		sed -e "s/# __ANDLINUX_AUTOGEN_MARKER_MOUNT__/mount -t cifs -o credentials=\/etc\/smbpasswd,iocharset=iso8859-1,uid=$login,gid=$login,dir_mode=0755,file_mode=0755 \/\/192.168.11.1\/$mountshare \/mnt\/win/" < /etc/rc.local > /tmp/rc.local
		mv -f /tmp/rc.local /etc/rc.local
		chmod 755 /etc/rc.local
		mountuser=`cat /tmp/firstboot.txt | grep mountuser | cut -d = -f 2`
		mountpassword=`cat /tmp/firstboot.txt | grep mountpassword | cut -d = -f 2`
		if [ -f /etc/smbpasswd ] ; then
			mv -f /etc/smbpasswd /etc/smbpasswd.old
		fi
		echo "username=$mountuser" > /etc/smbpasswd
		echo "password=$mountpassword" >> /etc/smbpasswd
		chmod 600 /etc/smbpasswd
		pushd /home/$login
		ln -s /mnt/win/ windows
		popd
	fi

	# check for and adapt launcher script
	launcher=`cat /tmp/firstboot.txt | grep launcher | cut -d = -f 2`
	if [ $launcher = "yes" ] ; then
		# escape backslashes
		mountpath=`cat /tmp/firstboot.txt | grep mountpath | cut -d = -f 2 | sed -e 's/\\\\/\\\\\\\\/g'`
		echo "%pathPrefixes = ( '/mnt/win/' => '$mountpath' );" > /etc/andlinux/launcher-conf.pl
		echo "1; # Perl libraries MUST return 1" >> /etc/andlinux/launcher-conf.pl
		echo "sux - $login /usr/local/sbin/launcher.pl" > /etc/andlinux/xsession_cmd
	else
		echo "sux - $login /usr/bin/xfce4-panel" > /etc/andlinux/xsession_cmd
		mkdir -p /home/$login/.config/xfce4/
		cp -r /root/.config/xfce4/panel/ /home/$login/.config/xfce4/
		chown -R $login:$login /home/$login/.config/
	fi

	# remove firstboot.txt
	rm -f /mnt/and/firstboot.txt

	/sbin/reboot
fi
