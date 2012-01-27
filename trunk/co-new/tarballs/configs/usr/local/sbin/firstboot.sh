#included in rc.local
if [ -f /mnt/and/.reboot ]; then
  if [ -f /mnt/and/firstboot.1.txt ]; then
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
  #sleep 5
  if [ "$launcher" = "yes" ]; then
	# escape backslashes
	echo "%pathPrefixes = ( '/mnt/win/' => '$mountpath' );" > /etc/andlinux/launcher-conf.pl
	echo "1; # Perl libraries MUST return 1" >> /etc/andlinux/launcher-conf.pl
	echo "sux - $username /usr/local/sbin/launcher.pl" > /etc/andlinux/xsession_cmd
        echo " * Added KDE Launcher settings"
  fi
 fi
 /setpw
 rm -f /mnt/and/.reboot
 echo "We need a working internet connection on first boot!\n We do a reboot in 10 seconds!"
 sleep 10
 /sbin/reboot
fi
#echo " * Check rsyslog ..."
[ -x /usr/sbin/rsyslogd ] && (ifup -a; apt-get remove rsyslog -y; apt-get autoremove -y)
#echo " * Check fping ..."
! [ -x /usr/bin/fping ] && (ifup -a; apt-get install fping)
#echo " * Check sux ..."
! [ -x /usr/bin/sux ] && (ifup -a; apt-get install sux)
! [ -x /usr/bin/fping ] && echo "fping not installed!\n  We do again a reboot in 10 seconds!" && sleep 10 && /sbin/reboot
! [ -x /usr/bin/sux ] && echo "sux not installed!\n  We do again a reboot in 10 seconds!" && sleep 10 && /sbin/reboot
echo " * Continue ..."
# No exit 0 here file is included, don't remove last line with echo