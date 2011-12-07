#include in rc.local
if [ -f /mnt/and/firstboot.txt ]; then
#get firstboot settings
for i in $(cat /mnt/and/firstboot.txt  | sed 's| |_|g' | sed 's|\\|\/|g' | sed "s/\r//") ; do
case $i in
mountpath*)
mountpath=${i#*=}
;;
login*)
username=${i#*=}
User_uid=$(id ${username})
#User_uid:4:4 works only with bash
#User_uid="${User_uid:4:4}"
;;
mountshare*)
mountshare=${i#*=}
;;
mountuser*)
mountuser=${i#*=}
;;
passwd*)
userpasswd=${i#*=}
;;
mountpassword*)
mountpassword=${i#*=}
;;
mounttype*)
mounttype=${i#*=}
;;
launcher*)
launcher=${i#*=}
;;
pulseaudio*)
pulseaudio=${i#*=}
;;
installdir*)
INSTALLDIR=${i#*=}
;;
*)
;;
esac
done

if [ $launcher = "yes" ] ; then
		# escape backslashes
		echo "%pathPrefixes = ( '/mnt/win/' => '$mountpath' );" > /etc/andlinux/launcher-conf.pl
		echo "1; # Perl libraries MUST return 1" >> /etc/andlinux/launcher-conf.pl
		echo "sux - $username /usr/local/sbin/launcher.pl" > /etc/andlinux/xsession_cmd
fi
/setpw
rm -f /mnt/and/firstboot.txt
/sbin/reboot
fi