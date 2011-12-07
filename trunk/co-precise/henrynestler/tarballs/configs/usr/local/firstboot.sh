#!/bin/bash
echo "run firstboot.sh ..."
if [ -f /mnt/and/first.txt ] ; then

	# move to andLinux filesystem to avoid temporal side effects...
	cp -f /mnt/and/first.txt /tmp/firstboot.txt
	# convert to UNIX format, otherwise \r is remaining at the end of the parameters...
	/usr/bin/dos2unix /tmp/firstboot.txt

	# create login/password
	login=`cat /tmp/firstboot.txt | grep login | cut -d = -f 2`
	passwd=`cat /tmp/firstboot.txt | grep passwd | cut -d = -f 2 | sed -e "s/'/\\\\\\'/g"`

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
	rm -f /mnt/and/first.txt
	echo "Executed andLinux script reboot needed."
	sleep 10
	/sbin/reboot
fi
