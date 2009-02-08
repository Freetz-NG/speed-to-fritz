
#!/bin/sh
# assumption: $PWD is the colinux install dir
#clear
# get the settings from the installer
sleep 2
touch colinux.settings
. ./colinux.settings
cat ./colinux.settings
#sleep 5
# required binaries for initrd
echo  " * Unpacking utilities"
tar xf init.tar -C /
# work our magic
echo " * Initializing swap file: /dev/${CL_SWAP}"
mkswap /dev/${CL_SWAP}
if [ "$CL_FORMATIEREN" = "y" ]; then
echo " * Formatting root file system: /dev/${CL_ROOT}"
echo " This takes quite a wile depending on the size," 
echo " nothig is displayed wile formating and jurnaling takes place!"  
mke2fs -F -j /dev/${CL_ROOT} -O dir_index
mkdir  -p /freetz-colinux-setup2
echo "------------------------------------------------------------"
mount -t ext3 /dev/${CL_ROOT2} /freetz-colinux-setup2
echo "------------------------------------------------------------"
#sleep 5
fi
echo "============================================================"
echo " * Populating root file system with base image"
mkdir  -p /freetz-colinux-setup
echo "------------------------------------------------------------"
mount -t ext3 /dev/${CL_ROOT} /freetz-colinux-setup
echo "------------------------------------------------------------"
#mkdir  -p /mnt/and
#mount -t cofs 1 /mnt/and
mkdir  -p /freetz-colinux-setup/mnt/and
#sleep 5
echo "------------------------------------------------------------"
#tar pxf blackfin-root.tar -C /freetz-colinux-setup
tar xf  andlinux-configs.tar -C /freetz-colinux-setup
#if [ "$CL_FORMATIEREN" = "y" ] && ! [ -f "blackfin-root.tar" ]; then
if [ "$CL_FORMATIEREN" = "y" ]; then
    echo "A backup is going on,"
    echo "this again is quite time consuming, nothing is displayed until finished!" 
    cp -af  /freetz-colinux-setup2/* /freetz-colinux-setup/
    # make dev if not existant
    for i in 0 1 2 3 4
    do
	if ! test -f /freetz-colinux-setup2/dev/cobd$i ; then
    	    mknod /freetz-colinux-setup2/dev/cobd$i b 117 $i 
	fi
    done

fi
# make dev if not existant
for i in 0 1 2 3 4
do
  if ! test -f /freetz-colinux-setup/dev/cobd$i ; then
      mknod /freetz-colinux-setup/dev/cobd$i b 117 $i 
  fi
done

echo " * Configuring files and directories"
#sleep 5
#ls /freetz-colinux-setup
#cp passwd.exp /freetz-colinux-setup/
#chmod 777 /freetz-colinux-setup/passwd.exp
#----------------------------------------------------------------------------------------------
#mountpath=`cat ./colinux.settings | grep CL_COFSPFAD | cut -d = -f 2 | sed -e 's/\\\\/\\\\\\\\\\\\\\\\/g'`
mountpath=`cat ./colinux.settings | grep CL_COFSPFAD | cut -d = -f 2 | sed -e 's/\\\\/\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\/g'`
#echo "Mountpath: $mountpath"
cat <<EOSF >/freetz-colinux-setup/setup.sh
#!/bin/sh
NewUser="${CL_NEWUSER}"
#ls
# Generate ssh keys
[ -e /etc/ssh/ssh_host_dsa_key ] || ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -N ''
[ -e /etc/ssh/ssh_host_rsa_key ] || ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''

# Setup user accounts
if [ -e /lib/security/pam_smbpass.so ] && [ -e /etc/pam.d/common-password ] &&
   ! grep -qs pam_smbpass.so /etc/pam.d/common-password
then
	# have `passwd` update samba passwords as well
	echo 'password required /lib/security/pam_smbpass.so nullok use_authtok try_first_pass' >> /etc/pam.d/common-password
fi
root_pw="root"
useradd -m \${NewUser} -s /bin/bash -c "\${NewUser} development account,,," -G root
freetz_pw=\${NewUser}
#rm -f passwd.exp
sed -e "s/windowsPathPrefix = .*;/windowsPathPrefix = \\"\\$mountpath\\";/" < /usr/local/sbin/launcher.pl > /tmp/launcher.pl
mv -f /tmp/launcher.pl /usr/local/sbin/launcher.pl
chmod 755 /usr/local/sbin/launcher.pl
echo "#!/bin/sh" > /usr/local/sbin/firstboot.sh
echo "/usr/local/sbin/launcher.pl" > /etc/winterm
cat /usr/local/sbin/launcher.pl | grep "windowsPathPrefix ="
if [ -e /usr/local/sbin/launcher.pl ] && ! grep -qs "8081" /usr/local/sbin/launcher.pl; then
 sed -i -e 's| 81,| 8081,|' "/usr/local/sbin/launcher.pl"
 sleep 2
fi
if [ -e /etc/sudoers ]; then
    sed -i -e 's/#.*\%/\%/' "/etc/sudoers"
fi
if [ -e /etc/sudoers ] && ! grep -qs "\${NewUser}" /etc/sudoers; then
 echo "\${NewUser} ALL=(ALL) ALL" >> "/etc/sudoers" 
 sleep 2
fi
if [ -e /usr/bin/startwindowsterminalsession ]; then
    sed -i -e "/sux - /d" "/usr/bin/startwindowsterminalsession"
    echo "sux - \${NewUser} \$(cat /etc/winterm)" >> "/usr/bin/startwindowsterminalsession"
fi
User_uid=\$(id \${NewUser})
User_uid="\${User_uid:4:4}" 
echo "uid=\${User_uid}"
if [ -e /etc/fstab ]; then 
    sed -i -e "/mnt.win/d" "/etc/fstab"    
    echo "/dev/cofs0 /mnt/win cofs uid=\${User_uid},gid=0 0 0" >> /etc/fstab 
#    echo "/dev/cofs0 /mnt/win cofs defaults 0 0" >> /etc/fstab
fi

#remove entry
#ACTION=="add", SUBSYSTEM=="net", KERNEL=="eth*|ath*|wlan*|ra*|sta*"
if [ -e /etc/udev/rules.d/75-persistent-net-generator.rules ]; then 
 sed -i -e 's/eth..//' "/etc/udev/rules.d/75-persistent-net-generator.rules"
 echo " -- removed udev ethx"
 sleep 2
fi
cat <<EOF > /etc/udev/rules.d/70-persistent-net.rules
# This file maintains persistent names for network interfaces.
# See udev(7) for syntax.
#
# Entries are automatically added by the 75-persistent-net-generator.rules
# file; however you are also free to add your own entries. 
EOF

# Setup eth1 (tuntap)

rm /etc/network/interfaces
cat <<EOF >> /etc/network/interfaces
# Used by ifup(8) and ifdown(8). See the interfaces(5) manpage or
# /usr/share/doc/ifupdown/examples for more information.

auto lo eth0 eth1 eth2

iface lo inet loopback

iface eth0 inet dhcp

iface eth1 inet static
     address ${CL_LINIP}
     netmask 255.255.255.0
#     gateway 192.168.11.1

iface eth2 inet static
     address 192.168.178.19
     netmask 255.255.0.0
     gateway 192.168.178.1

#iface eth3 inet static
#     address 192.168.2.19
#     netmask 255.255.0.0
#     gateway 192.168.2.1

EOF
smbpasswd -a -s \${NewUser} << EOF
\${root_pw}
\${freetz_pw}
EOF
cat <<EOF > /etc/issue
Password of root is: \${root_pw}
set \${NewUser} password to: \${freetz_pw}
Use 'passwd' \${NewUser} to set \${freetz_pw}.
Please log in as root, change the password, and then update the /etc/issue file, to remove this info.
EOF
cat <<EOF >/setpw
#!/bin/sh
root_pw="root"
/passwd.exp root \${root_pw}
freetz_pw=\${NewUser}
/passwd.exp  \${NewUser} \${freetz_pw}
smbpasswd -a -s \${NewUser} << EOF
chmod 777 /setpw
EOSF
if [ "$CL_FORMATIEREN" = "y" ]; then

echo 	"- Clean files in /var/log (don't remove files! Set the size to zero.)"
for FILE in `ls /freetz-colinux-setup2/var/log` ; do 
 echo "$FILE"
 rm -rf /freetz-colinux-setup2/var/log/$FILE
 touch /freetz-colinux-setup2/var/log/$FILE
done

cat <<EOSF >/freetz-colinux-setup2/clean.sh
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
fi
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
chroot /freetz-colinux-setup /bin/bash /setup.sh
#chroot /freetz-colinux-setup /bin/bash /setpw
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

rm -f /freetz-colinux-setup/setup.sh
#umount /mnt/and
umount /freetz-colinux-setup
if [ "$CL_FORMATIEREN" = "y" ]; then
 echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
 chroot /freetz-colinux-setup2 /bin/bash /clean.sh
 echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
 rm -f /freetz-colinux-setup2/clean.sh
 umount /freetz-colinux-setup2
 
fi
cd /
sync
umount -a
umount /proc
sync

echo  " * All done, time to exit!"
sleep 10
reboot


