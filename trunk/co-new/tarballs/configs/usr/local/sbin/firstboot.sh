#include in rc.local
[ -f /mnt/and/.reboot ] && rm -f /mnt/and/.reboot && /setpw &&\
echo "We need a working internet connection on first boot!\n We do a reboot in 10 seconds!" && sleep 10 && /sbin/reboot
! [ -x /usr/bin/fping ] && (apt-get install fping)
! [ -x /usr/bin/sux ] && (apt-get install sux)
! [ -x /usr/bin/fping ] && echo "fping not installed!\n  We do again a reboot in 10 seconds!" && sleep 10 && /sbin/reboot
! [ -x /usr/bin/sux ] && echo "sux not installed!\n  We do again a reboot in 10 seconds!" && sleep 10 && /sbin/reboot
if [ -f /mnt/and/firstboot.txt ]; then
#get firstboot settings
for i in $(cat /mnt/and/firstboot.1.txt  | sed 's| |_|g' | sed 's|\\|\/|g' | sed "s/\r//") ; do
case $i in
 mountpath=*)
 mountpath=${i#*=}
 ;;
 login=*)
 username=${i#*=}
 ;;
 launcher=*)
 launcher=${i#*=}
 ;;
*)
 ;;
esac
done
#echo mountpath:$mountpath
#echo username:$username
#echo launcher:$launcher
 if [ "$launcher" = "yes" ] ; then
		# escape backslashes
		echo "%pathPrefixes = ( '/mnt/win/' => '$mountpath' );" > /etc/andlinux/launcher-conf.pl
		echo "1; # Perl libraries MUST return 1" >> /etc/andlinux/launcher-conf.pl
		echo "sux - $username /usr/local/sbin/launcher.pl" > /etc/andlinux/xsession_cmd
 fi
 rm -f /mnt/and/firstboot.txt
fi