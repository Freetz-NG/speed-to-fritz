#!/bin/bash
#place your comment for this uptade here:
comment="Freetz: fix rtc again, tools/device_tabel.txt"




echo "-------------------------------------------------------------------------------------------------------------"
if [ `id -u` -eq 0 ]; then
 clear
  echo
  echo "This script needs to be executed without 'su' privileges."
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  sleep 10
  exit 0
fi
echo "-------------------------------------------------------------------------------------------------------------"
#svn co https://freetzlinux.svn.sourceforge.net/svnroot/freetzlinux/trunk trunk
#svn update https://freetzlinux.svn.sourceforge.net/svnroot/freetzlinux/trunk trunk
cd trunk

#svn add * --force
#svn delete --force ./speed-to-fritz/ftp192
#svn revert 
#svn add speed-to-fritz
svn status  > ../patch.diff
echo "-------------------------------------------------------------------------------------------------------------"
svn diff  >> ../patch.diff
cat ../patch.diff
echo -n "   All done' ? "; read -n 1 -s YESNO; echo

