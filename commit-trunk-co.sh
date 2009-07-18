#!/bin/bash
#place your comment for this uptade here:
comment="freetzlinux Intaller: fix IP settings in /etc/profile (cleanup)"




echo "-------------------------------------------------------------------------------------------------------------"
echo
if [ `id -u` -eq 0 ]; then
 clear
  echo
  echo "This script needs to be executed without 'su' privileges."
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  sleep 10
  exit 0
fi
echo "-------------------------------------------------------------------------------------------------------------"

svn update https://freetzlinux.svn.sourceforge.net/svnroot/freetzlinux/trunk trunk
cd trunk
#svn delete --force ./co/henrynestler/upload-file.sh
#svn delete --force ./co/henrynestler/s
#svn delete --force ./co/bfin-colinux-ori/trunk/upstream/WinPcap_4_0_2.exe
#svn delete --force ./co/bfin-colinux-ori/trunk/upstream/log
#svn delete --force ./co/bfin-colinux-ori/trunk/upstream/Xming-6-9-0-31-setup.exe
#svn delete --force ./co/bfin-colinux-ori/trunk/upstream/coLinux-0.7.3-src.tar.gz
#svn delete --force ./co/bfin-colinux-ori/trunk/upstream/coLinux-0.7.3.exe
#svn delete --force ./co/bfin-colinux-ori/trunk/upstream/putty-0.60-installer.exe
#svn delete --force ./co/bfin-colinux-ori/trunk/scripts/init.sh
#svn delete --force ./co/bfin-colinux-ori/trunk/tarballs/configs
#svn delete --force ./co/bfin-colinux-ori/trunk/make-release.sh

#svn revert 
svn add * --force
svn status
svn diff > ../patch.diff
cat ../patch.diff
echo -n "   Execute Commit?'  (y/n)? "; read -n 1 -s YESNO; echo
([ "$YESNO" = "y" ] || [ "$YESNO" = "n" ]) || echo "wrong key!"
[ "$YESNO" = "y" ] &&   svn commit --message "${date} - ${comment}"

