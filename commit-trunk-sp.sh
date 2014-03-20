#!/bin/bash
#place your comment for this uptade here:
comment="  * Different way of connecting to FTP if push option is now in use." 

echo "-------------------------------------------------------------------------------------------------------------"
if [ `id -u` -eq 0 ]; then
 clear
  echo
  echo "This script needs to be executed without 'su' privileges."
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  sleep 10 
  exit 0
fi
echo "Looking for new speed-to-fritz version, wait ..."
svn update https://svn.code.sf.net/p/freetzlinux/code/trunk trunk
echo "-------------------------------------------------------------------------------------------------------------"
sleep 2
#exit
#svn delete --force ./download_speed-to-fritz.sh
#svn delete --force ./patch.diff
#svn add * --force
#svn propedit svn:ignore trunk
cd trunk
#svn propedit svn:ignore ./speed-to-fritz/FBDIR
#svn propedit svn:ignore ./speed-to-fritz/FBDIR2
#svn propedit svn:ignore ./speed-to-fritz/FBDIRori
#svn propedit svn:ignore ./speed-to-fritz/SPDIR
#svn propedit svn:ignore ./speed-to-fritz/Firmware.new
#svn propedit svn:ignore ./speed-to-fritz/Firmware.orig
#svn propset svn:ignore *.log ./speed-to-fritz
#svn propset svn:ignore *.diff ./speed-to-fritz
#svn propset svn:ignore *.patch ./speed-to-fritz
#svn propset svn:ignore *.ut8.patch ./speed-to-fritz/alien/patches
#svn propset svn:ignore Firmware.conf ./speed-to-fritz
#svn propset svn:ignore Firmware.conf.old ./speed-to-fritz
#svn propset svn:ignore *.log .
#svn propset svn:ignore *.diff .
#sleep 10
#svn delete --force ./speed-to-fritz/conf/conf.in
#svn propset svn:ignore *.in ./speed-to-fritz/conf
#svn propset svn:ignore *.pyc dirname
#svn propedit svn:ignore dirname
#sleep 20
#svn delete --force ./Kernel-2.6.32
#svn delete --force ./speed-to-fritz/alien/subscripts/build_new_recover_firmware
#svn delete --force ./speed-to-fritz/500
#svn delete --force ./speed-to-fritz/0.patch
#svn delete --force ./speed-to-fritz/501
#svn delete --force ./speed-to-fritz/firmware.conf500
#svn delete --force ./speed-to-fritz/firmware.conf501
#svn delete --force ./speed-to-fritz/conf/W920/VDSL
#svn delete --force ./speed-to-fritz/recoversubscripts/ipsr.c
#svn delete --force ./speed-to-fritz/recoversubscripts/log
#svn delete --force ./wrtjp/wrtjp.5.1/bin/Release/start.bat
#svn delete --force ./uploader/Program-dialog1.cs
#svn delete --force ./uploader/release.exe
#svn delete --force ./speed-to-fritz/info.txt.r79
#svn delete --force ./speed-to-fritz/info.txt.mine
#svn delete --force ./speed-to-fritz/info.txt.r130
#svn delete --force ./speed-to-fritz/info.txt.r131
#svn delete --force ./speed-to-fritz/conf-920-freetz
#svn delete --force ./speed-to-fritz/start-920
#svn delete --force ./speed-to-fritz/modfw.sh
#svn delete --force ./speed-to-fritz/0r
#svn delete --force ./speed-to-fritz/kernel_7390.patch
#svn delete --force ./Config.in
#svn delete --force ./speed-to-fritz/tools/make/patches/110-allow-symlinks.squashfs3.patch
#svn delete --force ./speed-to-fritz/tools/make/patches/110-allow-symlinks.squashfs4.patch

#svn delete --force ./speed-to-fritz/tools/usr/lib/libfakeroot.la
#svn delete --force ./speed-to-fritz/tools/config
#svn delete --force ./speed-to-fritz/tools/mconf
#svn delete --force ./speed-to-fritz/alien/subscripts/add_freetz_type_patches.sh
#svn delete --force ./speed-to-fritz/alien/add_dect_7150.inc
#svn delete --force ./speed-to-fritz/alien/subscripts/time
#svn delete --force ./speed-to-fritz/alien/subscripts/501.init
#svn delete --force ./speed-to-fritz/alien/subscripts/701.init
#svn delete --force ./speed-to-fritz/alien/subscripts/900.init
#svn delete --force ./speed-to-fritz/alien/subscripts/add_dect.47.sh
#svn delete --force ./speed-to-fritz/alien/subscripts/inc_func_init
#svn delete --force ./speed-to-fritz/alien/subscripts/add_settings.sh
#svn delete --force ./speed-to-fritz/alien/patches/add_tam_en.47.patch
#svn delete --force ./speed-to-fritz/alien/patches/*ut8.patch
#svn delete --force ./speed-to-fritz/alien/patches/add_tamhelp_en.47.patch
#svn delete --force ./speed-to-fritz/subscripts2/copy_tr064_files
#svn delete --force ./speed-to-fritz/alien/subscripts/patch_oem.sh
#svn delete --force ./speed-to-fritz/subscripts2/patch_portroule
#svn delete --force ./speed-to-fritz/addon/tmp/modules/dsld/kdsldmod.ko
#svn delete --force ./speed-to-fritz/addon/tmp/modules/vinax/drv_vinax.ko
#svn delete --force ./speed-to-fritz/recoversubscripts/ipsr
#svn delete --force ./speed-to-fritz/win/curl.bat
#svn delete --force ./speed-to-fritz/win/log
#svn delete --force ./speed-to-fritz/win/push_FTP.zip
#svn delete --force ./speed-to-fritz/win/setDHCP.zip
#svn delete --force ./speed-to-fritz/win/set_branding.bat
#svn delete --force ./speed-to-fritz/win/setstaticIP192_168_178_19.zip
#svn delete --force ./speed-to-fritz/windows_skripts
#svn delete --force ./speed-to-fritz/freetz
#svn delete --force ./speed-to-fritz/freetz/7390-freetz.tar.gz
#svn delete --force ./speed-to-fritz/freetz/log
#svn delete --force ./co-precise
#svn revert 
svn status
##svn add * --force #adds also files beein within the ignore list.
#this should work better
#svn status | grep -v "^.[ \t]*\..*" | grep "^?" | awk '{print $2}' | xargs svn add
svn add * --force

svn diff > ../patch.diff
cat ../patch.diff
echo -n "   Execute Commit?'  (y/n)? "; read -n 1 -s YESNO; echo
([ "$YESNO" = "y" ] || [ "$YESNO" = "n" ]) || echo "wrong key!"
[ "$YESNO" = "y" ] &&   svn commit --message "${comment}"

sleep 10