#!/bin/sh
# assumption: local dir (pwd) is the colinux install dir
# get the settings from the installer
sleep 2
# include settings written by installer
. ./colinux.settings
cat ./colinux.settings
#sleep 5
# Aditional required binaries, to meny bianrays lead to no space left while extakting
echo  " * Unpacking tarball utilities"
tar xf init.tar -C /
# work our magic
echo " * Initializing swap file: /dev/${CL_SWAP}"
mkswap /dev/${CL_SWAP}
if [ "$CL_FORMATIEREN" = "y" ]; then
echo
echo " * Formatting root file system: /dev/${CL_ROOT}"
echo " This takes quite a while depending on the size," 
echo " only '...' are displayed while formating."
echo

mke2fs -F -j /dev/${CL_ROOT} -O dir_index && touch /.formatiert &
echo -e -n .
while ! [ -f "/.formatiert" ]; do
    echo -e -n .
    sleep 1
done
sync
mkdir  -p /freetz-colinux-setup2
mount -t ext3 /dev/${CL_ROOT2} /freetz-colinux-setup2 || \
mount -t ext4 /dev/${CL_ROOT2} /freetz-colinux-setup2
type="2"
fi
echo " * Populating root file system with base image"
mkdir  -p /freetz-colinux-setup
mount -t ext3 /dev/${CL_ROOT} /freetz-colinux-setup || \
mount -t ext4 /dev/${CL_ROOT} /freetz-colinux-setup


tar xf  andlinux-configs.tar -C /freetz-colinux-setup$type
mkdir  -p /freetz-colinux-setup$type/mnt/and

echo " * Configuring files and directories"
#----------------------------------------------------------------------------------------------
mountpath=`cat ./colinux.settings | grep CL_COFSPFAD | cut -d = -f 2 | sed -e 's/\\\\/\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\/g'`
#echo "Mountpath: $mountpath"
cat <<EOSF >/freetz-colinux-setup$type/setup.sh
#!/bin/bash
exec 2> speedsetup.log
NewUser=$CL_NEWUSER
mountuser=$CL_SAMBAUSER
mountpassword=$CL_SAMBAUSERPW
NewUser_pw=$CL_NEWUSERPW
mountshare="$(echo $mountpath | sed -e 's|.*\\||')"
KERNEL_Version="$CL_KERNEL_VERSION"
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
grep -q '\${NewUser}' /etc/shadow || \
useradd -m \${NewUser} -s /bin/bash -c "\${NewUser} sudo admin account,,," -G root && echo "---------- added \${NewUser}"
sleep 1
User_uid=\$(id \${NewUser})
#User_uid:4:4 works only with bash
User_uid="\${User_uid:4:4}"
if [ -e /etc/ssh/sshd_config ]; then
    sed -i -e 's/PasswordAuthentication.*/PasswordAuthentication yes/' "/etc/ssh/sshd_config" 
    sed -i -e 's/PermitEmptyPasswords.*/PermitEmptyPasswords yes/' "/etc/ssh/sshd_config"
    sed -i -e 's/X11Forwarding.*/X11Forwarding yes/' "/etc/ssh/sshd_config"
    sed -i -e 's/PermitRootLogin.*/PermitRootLogin yes/' "/etc/ssh/sshd_config"
#    sed -i -e '/X11Forwarding yes/a\ 
#X11UseLocalhost yes' "/etc/ssh/sshd_config"
    echo "---------- added setup sshd_config"
    sleep 1
fi
#This is only on older andLinux versions in ues, we start via rc.local
#if [ -e /etc/inittab ]; then
#    sed -i -e 's|C0::respawn:.usr.bin.X11.startwindowsterminalsession|#C0::respawn:/usr/bin/X11/startwindowsterminalsession|' "/etc/inittab" 
#    echo "---------- removed respawn startwindowsterminalsession!"
#    sleep 1
#fi
#also only on some andlinux versions in use
rm -f /etc/init.d/launcher
#remove root password
if [ -e /etc/shadow ]; then
    sed -i -e 's/root:.*/root::12823:0:99999:7:::/' "/etc/shadow" 
    echo "---------- removed root password!"
    sleep 1
fi
if [ -e /etc/sudoers ]; then
    sed -i -e 's/#.*\%/\%/' "/etc/sudoers" 
fi
if [ -e /etc/sudoers ] && ! grep -qs "\${NewUser}" /etc/sudoers; then
 echo "\${NewUser} ALL=(ALL) ALL" >> "/etc/sudoers" 
    echo "---------- added \${NewUser} to /etc/sudoers"
    sleep 1
fi
chmod 440 /etc/sudoers
#on newer Linux systems
rm -f /etc/init/plymouth*
rm -f /etc/init/udev-fallback*
rm -f /etc/init/rsyslog*
chmod -R 777 /home
cat <<SETEOF >/setpw
#!/bin/sh
/passwd.exp  root root
/passwd.exp  \${NewUser} \${NewUser_pw}
SETEOF
chmod 777 /setpw
###rebuild moduldependency
echo "Kernelversion: \$KERNEL_Version"
/sbin/depmod -a \$KERNEL_Version
sync
EOSF
#<-- end setup.sh
chmod 777 /freetz-colinux-setup$type/setup.sh
chmod 777 /freetz-colinux-setup$type/clean.sh
sync
# make dev if not existant, did not find a way to remove out put of mknod
for i in 0 1 2 3 4 5 6 7 8 9
do
 mknod /freetz-colinux-setup$type/dev/cobd$i b 117 $i
done
rm -fr /freetz-colinux-setup$type/proc/*
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
chroot /freetz-colinux-setup$type /bin/bash /setup.sh
sleep 5
#chroot /freetz-colinux-setup /bin/bash /setpw #courses an error, do it later via rc.local
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
if [ "$CL_FORMATIEREN" = "y" ]; then
    echo "A backup is going on,this again is quite time consuming,"
    echo "'>' are added until finished!" 
    # cant get the followig line workig instead of cp
    #/freetz-colinux-setup/usr/bin/scp -r /freetz-colinux-setup2/* /freetz-colinux-setup/
    cp -af  /freetz-colinux-setup2/* /freetz-colinux-setup/ && touch /.copped &
    while ! [ -f "/.copped" ]; do
	echo -e -n ">"
	sleep 2
    done
fi
cd /
sync
umount -a
umount /proc
sync
echo  " * Passwords will be set at first boot."
echo  " * All done, time to exit!"
#sleep 10
reboot