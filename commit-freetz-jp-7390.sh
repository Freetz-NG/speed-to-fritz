#!/bin/bash
#place your comment for this uptade here:
comment="Added a private working copy off freetz"
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
#svn delete --force ./trunk/freetz-jp-7390
#svn delete --force ./trunk/freetz
#svn delete --force ./trunk/freetz-jp

svn cleanup
#svn add * --force

#svn revert 

echo "Looking for new trunk version, wait ..."
svn update https://freetzlinux.svn.sourceforge.net/svnroot/freetzlinux/trunk/freetz-jp-7390 freetz-jp-7390
cd freetz-jp-7390

#svn add * --force
svn status
svn diff > ../freet-jp-7390.diff
cat ../freet-jp-7390.diff
echo -n "   Execute Commit?'  (y/n)? "; read -n 1 -s YESNO; echo
([ "$YESNO" = "y" ] || [ "$YESNO" = "n" ]) || echo "wrong key!"
[ "$YESNO" = "y" ] &&   svn commit --message "${date} - ${comment}"

