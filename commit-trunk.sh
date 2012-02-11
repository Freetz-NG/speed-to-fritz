#!/bin/bash
#place your comment for this uptade here:
comment="* Added script for generating firmware link list
	Fix: AVM changed php download of labor firmware."




echo "-------------------------------------------------------------------------------------------------------------"
if [ `id -u` -eq 0 ]; then
 clear
  echo
  echo "This script needs to be executed without 'su' privileges."
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  sleep 10
  exit 0
fi
svn update https://freetzlinux.svn.sourceforge.net/svnroot/freetzlinux/trunk trunk
echo "-------------------------------------------------------------------------------------------------------------"
date=$(date +%Y%m%d-%H%M)

#svn delete --force ./download_speed-to-fritz.sh
#svn delete --force ./diff.sh
#svn delete --force ./get_SRC2_ver.patch
#svn delete --force ./log
#svn delete --force ./getversion.patch
#svn delete --force ./getprodukt.patch
#svn delete --force ./includefunctions.patch
#svn delete --force ./trunk/backup
#svn delete --force ./trunk/co-new/tarballs/configs/usr/bin
#svn delete --force ./trunk/co-new/replace/stop.ico
#svn delete --force ./trunk/co-new/replace/andlinux.ico
#svn delete --force ./trunk/co-new/patches/Bild.bmp
#svn delete --force ./trunk/co-new/patches/header.bmp
#svn delete --force ./trunk/Kernel-2.6.32
#svn delete --force ./trunk/patch_recover

#svn delete --force ./trunk/patch.diff
#svn delete --force ./trunk/co-new/logo
#svn add * --force
#svn propedit svn:ignore trunk
#svn propedit svn:ignore .

#svn revert
svn add * --force

svn status
svn diff > ../patch.diff
cat ../patch.diff
echo -n "   Execute Commit?'  (y/n)? "; read -n 1 -s YESNO; echo
([ "$YESNO" = "y" ] || [ "$YESNO" = "n" ]) || echo "wrong key!"
[ "$YESNO" = "y" ] &&   svn commit --message "${comment}"

sleep 10
