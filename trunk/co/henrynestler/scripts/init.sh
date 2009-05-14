
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
if [ -e /usr/local/sbin/launcher.pl ] && ! grep -qs "2081" /usr/local/sbin/launcher.pl; then
 sed -i -e 's| 81,| 2081,|' "/usr/local/sbin/launcher.pl"
 sleep 2
fi
if [ -e /etc/ssh/sshd_config ]; then
    sed -i -e 's/PasswordAuthentication.*/PasswordAuthentication yes/' "/etc/ssh/sshd_config"
    sed -i -e 's/PermitEmptyPasswords.*/PermitEmptyPasswords yes/' "/etc/ssh/sshd_config"
    sed -i -e 's/X11Forwarding.*/X11Forwarding yes/' "/etc/ssh/sshd_config"
    sed -i -e 's/PermitRootLogin.*/PermitRootLogin yes/' "/etc/ssh/sshd_config"
#    sed -i -e '/X11Forwarding yes/a\
#X11UseLocalhost yes' "/etc/ssh/sshd_config"
fi
#######################################################################
# X : GDM (gnome , xfce)
# Enable XDMCP , Enable remote autologin , Disable local X server
#######################################################################
if [ -f /etc/gdm/gdm-cdd.conf ]
then
    # Configure GDM autologin
    sed -i -e "s/^AutomaticLoginEnable=.*/AutomaticLoginEnable=true/" \\
    -e "s/^AutomaticLogin=.*/AutomaticLogin=\${NewUser}/" \\
    -e "s/^TimedLoginEnable=.*/TimedLoginEnable=true/" \\
    -e "s/^TimedLogin=.*/TimedLogin=\${NewUser}/" \\
    -e "s/^TimedLoginDelay=.*/TimedLoginDelay=10/" \\
    -e "s/^Enable=.*/Enable=true/" \\
    -e "s/^AllowRemoteAutoLogin=.*/AllowRemoteAutoLogin=true/" \\
    -e "s/^0=Standard.*/0=inactive/" /etc/gdm/gdm-cdd.conf
else
 [ -f /usr/share/gdm/defaults.conf ] && cp /usr/share/gdm/defaults.conf /etc/gdm/gdm.conf
 if [ -f /etc/gdm/gdm.conf ]
 then
    # Configure GDM autologin
    sed -i -e "s/^AutomaticLoginEnable=.*/AutomaticLoginEnable=true/" \\
    -e "s/^AutomaticLogin=.*/AutomaticLogin=\${NewUser}/" \\
    -e "s/^TimedLoginEnable=.*/TimedLoginEnable=true/" \\
    -e "s/^TimedLogin=.*/TimedLogin=\${NewUser}/" \\
    -e "s/^TimedLoginDelay=.*/TimedLoginDelay=10/" \\
    -e "s/^Enable=.*/Enable=true/" \\
    -e "s/^AllowRemoteAutoLogin=.*/AllowRemoteAutoLogin=true/" \\
    -e "s/^0=Standard.*/0=inactive/" /etc/gdm/gdm.conf
 fi
fi
#######################################################################
# X : KDM (KDE)
# Enable XDMCP , Enable remote autologin , Disable local X server
#######################################################################
if [ -d /etc/default/kdm.d/ ]
then
cat >> /etc/default/kdm.d/live-autologin << EOF
AutoLoginDelay=10
AutoLoginAgain=true
LoginMode=DefaultRemote
EOF
fi
if [ -f /etc/kde3/kdm/kdmrc ]
then
    # Configure KDM autologin
    sed -i -r -e "s/^#?AutoLoginEnable=.*/AutoLoginEnable=true/" \\
    -e "s/^#?AutoLoginUser=.*/AutoLoginUser=\${NewUser}/" \\
    -e "s/^#?AutoReLogin=.*/AutoReLogin=true/" \\
    -e "s/^#?AutoLoginDelay=.*/AutoLoginDelay=10/" \\
    -e "s/^#?AutoLoginAgain=.*/AutoLoginAgain=true/" \\
    -e "s/^#?Enable=.*/Enable=true/" \\
    -e "s/^#?LoginMode=.*/LoginMode=DefaultRemote/" \\
    -e "s/^StaticServers=.*/StaticServers=#:0/" \\
    -e "s/^ReserveServers=.*/ReserveServers=#:1,:2,:3/" /etc/kde3/kdm/kdmrc
elif [ -f /etc/kde4/kdm/kdmrc ]
then
    # Configure KDM-KDE4 autologin
    sed -i -r -e "s/^#?AutoLoginEnable=.*/AutoLoginEnable=true/" \\
    -e "s/^#?AutoLoginUser=.*/AutoLoginUser=\$NewUser/" \\
    -e "s/^#?AutoReLogin=.*/AutoReLogin=true/" \\
    -e "s/^#?AutoLoginDelay=.*/AutoLoginDelay=10/" \\
    -e "s/^#?AutoLoginAgain=.*/AutoLoginAgain=true/" \\
    -e "s/^#?Enable=.*/Enable=true/" \\
    -e "s/^#?LoginMode=.*/LoginMode=DefaultRemote/" \\
    -e "s/^StaticServers=.*/StaticServers=#:0/" \\
    -e "s/^ReserveServers=.*/ReserveServers=#:1,:2,:3/" /etc/kde4/kdm/kdmrc
fi
#######################################################################
# X : KDM (KDE)
# Enable any host for  XDMCP 
#######################################################################
if [ -f /etc/kde3/kdm/Xaccess ]
then
 # allow any host XDMCP
 sed -i -r -e "/window/c \*	#any host can get a login window" /etc/kde3/kdm/Xaccess
fi
if [ -f /etc/kde4/kdm/Xaccess ]
then
 # allow any host XDMCP
 sed -i -r -e "/window/c \*	#any host can get a login window" /etc/kde4/kdm/Xaccess
fi
#######################################################################
# Network
# nameserver in resolv.conf  
# fixme : seems too early (resolv.conf don't exist at this moment
#######################################################################
if [ -f /etc/resolv.conf ]
then
 # pulse audio client  ; default-server =
 echo "nameserver 203.95.1.2" >>/etc/resolv.conf
fi
#######################################################################
# Sound
# pulseaudio client configuation
#######################################################################
if [ -f /etc/pulse/client.conf ]
then
 # pulse audio client  ; default-server =
 sed -i -r -e "/default-server/c \default-server = 192.168.0.1" /etc/pulse/client.conf
fi
#######################################################################
# Sound
# pulseaudio support ALSA
# libpulse0 libasound2-plugins libgstreamer-plugins-pulse0.10-0
#######################################################################
cat >> /etc/asound.conf << EOF
pcm.!default {
    type pulse
}

ctl.!default {
    type pulse
}

pcm.pulse {
    type pulse
}

ctl.pulse {
    type pulse
}
EOF
#remove root password
if [ -e /etc/shadow ]; then
    sed -i -e 's/root:.*/root::12823:0:99999:7:::/' "/etc/shadow"
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
 echo " -- removed udev eth"
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
     address 192.168.178.10
     netmask 255.255.0.0
     gateway 192.168.178.1

#iface eth3 inet static
#     address 192.168.2.10
#     netmask 255.255.0.0
#     gateway 192.168.2.1

EOF
smbpasswd -a -s \${NewUser} << EOF
\${root_pw}
\${freetz_pw}
EOF
cat <<EOF > /etc/issue
Password of root is not set!
set \${NewUser} password to: \${freetz_pw}
Use 'passwd' \${NewUser} to set \${freetz_pw}.
Please log in as root or use 'sudo su', change the password, and then update the /etc/issue file, to remove this info.
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

##rm -f /freetz-colinux-setup/setup.sh
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


