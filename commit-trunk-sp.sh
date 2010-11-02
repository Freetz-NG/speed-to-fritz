#!/bin/bash
#place your comment for this uptade here:
comment="  * Fix set all providers warning"


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
svn update https://freetzlinux.svn.sourceforge.net/svnroot/freetzlinux/trunk trunk
echo "-------------------------------------------------------------------------------------------------------------"
#insert comment into "info.txt"
if SVN_VERSION="$(svnversion . )"; then
 let "SVN_VERSION=$(echo ${SVN_VERSION##*:} | tr -d '[:alpha:]') + 1"
 #echo "Subversion=$SVN_VERSION"
fi
date=$(date +%Y%m%d-%H%M)
#DSTI="./trunk/speed-to-fritz/info.txt"
#grep -q "${comment}" ${DSTI} || sed -i -e "/### --- START --- ###/a\
#${date}-r-$SVN_VERSION\n    - ${comment}" "${DSTI}"
DSTISP2FR="./trunk/speed-to-fritz"
DSTI="$DSTISP2FR/sp-to-fritz.sh"
Year=$(date +%y)
Month=$(date +%m)
Day=$(date +%d) 
sed -i -e "s/Tag=\"..\"; Monat=\"..\"; Jahr=\"..\"/Tag=\"${Day}\"; Monat=\"${Month}\"; Jahr=\"${Year}\"/" "${DSTI}"
echo "-------------------------------------------------------------------------------------------------------------"
sleep 2
#exit
sed -i -e '/ Subversion Log:/,$d' "$DSTISP2FR/info.txt"
echo " Subversion Log:" >>"$DSTISP2FR/info.txt"
echo "------------------------------------------------------------------" >>"$DSTISP2FR/info.txt"


#svn delete --force ./download_speed-to-fritz.sh
#svn delete --force ./patch.diff
#svn add * --force
#svn propedit svn:ignore trunk
cd trunk
#sleep 20
#svn delete --force ./speed-to-fritz/alien/subscripts/br
#svn delete --force ./speed-to-fritz/alien/subscripts/build_new_recover_firmware

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
#svn delete --force ./speed-to-fritz/tools/usr/lib/libfakeroot.la
#svn delete --force ./speed-to-fritz/tools/conf
#svn delete --force ./speed-to-fritz/tools/mconf
#svn delete --force ./speed-to-fritz/alien/subscripts/add_freetz_type_patches.sh
#svn delete --force ./speed-to-fritz/alien/add_dect_7150.inc
svn delete --force ./speed-to-fritz/alien/subscripts/time
#svn delete --force ./speed-to-fritz/alien/subscripts/501.init
#svn delete --force ./speed-to-fritz/alien/subscripts/701.init
#svn delete --force ./speed-to-fritz/alien/subscripts/900.init
#svn delete --force ./speed-to-fritz/alien/subscripts/add_dect.47.sh
#svn delete --force ./speed-to-fritz/alien/subscripts/inc_func_init
#svn delete --force ./speed-to-fritz/alien/subscripts/add_settings.sh
#svn delete --force ./speed-to-fritz/alien/patches/add_tam_en.47.patch
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

#svn revert 

svn add * --force

svn status
svn diff > ../patch.diff
cat ../patch.diff
echo -n "   Execute Commit?'  (y/n)? "; read -n 1 -s YESNO; echo
([ "$YESNO" = "y" ] || [ "$YESNO" = "n" ]) || echo "wrong key!"
[ "$YESNO" = "y" ] &&   svn commit --message "${date} - ${comment}"
#[ "$YESNO" = "y" ] && sed -i -e "s/svn diff .*$/svn diff -r $SVN_VERSION  > \.\.\/$SVN_VERSION-to-local.diff/" -e "s/cat  \.\..*$/cat  \.\.\/$SVN_VERSION-to-local.diff/" "./diff.sh"

sleep 10