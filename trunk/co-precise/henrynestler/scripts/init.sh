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
echo " This takes quite a while depending on the size," 
echo " nothig is displayed while formating and jurnaling takes place!"  
mke2fs -F -j /dev/${CL_ROOT} -O dir_index
mkdir  -p /freetz-colinux-setup2
echo "------------------------------------------------------------"
mount -t ext3 /dev/${CL_ROOT2} /freetz-colinux-setup2 || \
mount -t ext4 /dev/${CL_ROOT} /freetz-colinux-setup
echo "------------------------------------------------------------"
#sleep 5
fi
echo "============================================================"
echo " * Populating root file system with base image"
mkdir  -p /freetz-colinux-setup
echo "------------------------------------------------------------"
mount -t ext3 /dev/${CL_ROOT} /freetz-colinux-setup || \
mount -t ext4 /dev/${CL_ROOT} /freetz-colinux-setup
echo "------------------------------------------------------------"
#mkdir  -p /mnt/and
#mount -t cofs 1 /mnt/and
mkdir  -p /freetz-colinux-setup/mnt/and
#sleep 5
echo "------------------------------------------------------------"
tar xf  andlinux-configs.tar -C /freetz-colinux-setup
if [ "$CL_FORMATIEREN" = "y" ]; then
    echo "A backup is going on,"
    echo "this again is quite time consuming, nothing is displayed until finished!" 
    cp -af  /freetz-colinux-setup2/* /freetz-colinux-setup/
    # make dev if not existant
    for i in 0 1 2 3 4 5 6 7 8 9
    do
	if ! [ -f /freetz-colinux-setup2/dev/cobd$i ]; then
    	    mknod /freetz-colinux-setup2/dev/cobd$i b 117 $i 
	fi
    done

fi
echo " * Configuring files and directories"
#----------------------------------------------------------------------------------------------
mountpath=`cat ./colinux.settings | grep CL_COFSPFAD | cut -d = -f 2 | sed -e 's/\\\\/\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\/g'`
#echo "Mountpath: $mountpath"
cat <<EOSF >/freetz-colinux-setup/setup.sh
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
rm -f /etc/init/plymouth*
rm -f /etc/init/udev-fallback*
cat <<SETEOF >/setpw
#!/bin/sh
/passwd.exp  root root
/passwd.exp  \${NewUser} \${NewUser_pw}
SETEOF
chmod 777 /setpw
[ -f /etc/rc.local ] || echo "#!/bin/sh" >> /etc/rc.local
grep -q '#!.bin.sh' /etc/rc.local || echo "#!/bin/sh" >> /etc/rc.local
sed -i -e "/#!.bin.sh/a\\
rm -f \\/mnt\\/and\\/firstboot.txt #####\\n\\
\\/setpw #####\\n\\
sed -i -e \\'\\/#####\\/d\\' \/etc\/rc.local" /etc/rc.local
grep -q 'exit' /etc/rc.local || echo "exit 0" >> /etc/rc.local
###rebuild moduldependency
echo "Kernelversion: \$KERNEL_Version"
/sbin/depmod -a \$KERNEL_Version
sync
EOSF
#<-- end setup.sh
if [ "$CL_FORMATIEREN" = "y" ]; then
echo 	"- Clean files in /var/log (don't remove files! Set the size to zero.)"
for FILE in `ls /freetz-colinux-setup2/var/log` ; do 
 echo "$FILE"
 rm -rf /freetz-colinux-setup2/var/log/$FILE
 touch /freetz-colinux-setup2/var/log/$FILE
done
cat <<EOSF >/freetz-colinux-setup2/clean.sh
#!/bin/bash
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
sleep 5
#chroot /freetz-colinux-setup /bin/bash /setpw #courses an error, do it later via rc.local
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
echo  " * Passwords will be set at first boot."
echo  " * All done, time to exit!"
sleep 10
reboot