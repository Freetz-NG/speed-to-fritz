#!/bin/bash
#place your comment for this uptade here:
comment=" update co-installer, minor fixes in relation with xming start."

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
echo "Looking for new trunk version, wait ..."
svn update https://freetzlinux.svn.sourceforge.net/svnroot/freetzlinux/trunk trunk
cd trunk
svn delete --force ./co-new/replace/startup.bat

#svn revert
#svn add * --force
svn status
svn diff > ../patch.diff
cat ../patch.diff
echo -n "   Execute Commit?'  (y/n)? "; read -n 1 -s YESNO; echo
([ "$YESNO" = "y" ] || [ "$YESNO" = "n" ]) || echo "wrong key!"
[ "$YESNO" = "y" ] &&   svn commit --message ${comment}"

