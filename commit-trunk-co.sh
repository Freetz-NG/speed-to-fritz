#!/bin/bash
#place your comment for this uptade here:
comment="colinux update to 090124"




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

#svn co https://freetzlinux.svn.sourceforge.net/svnroot/freetzlinux/trunk trunk
#svn update https://freetzlinux.svn.sourceforge.net/svnroot/freetzlinux/trunk trunk
cd trunk
svn add * --force
#svn delete --force ./co/henrynestler/upload-file.sh
#svn revert 
#svn add speed-to-fritz
svn status
svn diff > ../patch.diff
cat ../patch.diff
echo -n "   Execute Commit?'  (y/n)? "; read -n 1 -s YESNO; echo
([ "$YESNO" = "y" ] || [ "$YESNO" = "n" ]) || echo "wrong key!"
[ "$YESNO" = "y" ] &&   svn commit --message "${date} - ${comment}"

