#!/bin/bash
#place your comment for this uptade here:
comment="commit all"




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

svn co https://freetzlinux.svn.sourceforge.net/svnroot/freetzlinux svn
#svn co https://freetzlinux.svn.sourceforge.net/svnroot/freetzlinux/trunk trunk
#svn update https://freetzlinux.svn.sourceforge.net/svnroot/freetzlinux/trunk trunk
cd svn
svn add * --force
#svn delete --force /co/henrynestler/index.html
#svn revert /co/henrynestler/index.html
#svn add speed-to-fritz
svn status
svn diff > ../patch.diff
cat ../patch.diff
svn commit --message "${date} - ${comment}"

sleep 5
