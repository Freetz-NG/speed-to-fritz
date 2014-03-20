#!/bin/bash
#place your comment for this uptade here:
comment="* Update SVN paths"




echo "-------------------------------------------------------------------------------------------------------------"
if [ `id -u` -eq 0 ]; then
 clear
  echo
  echo "This script needs to be executed without 'su' privileges."
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  sleep 10
  exit 0
fi
#svn up https://svn.code.sf.net/p/freetzlinux/code/trunk trunk
svn checkout --username=jpascher svn+ssh://jpascher@svn.code.sf.net/p/freetzlinux/code code
echo "-------------------------------------------------------------------------------------------------------------"
date=$(date +%Y%m%d-%H%M)
#echo "This file has to be invoced in the directory where the trunk directoy is localy located."
cd code
#svn delete --force ./download_speed-to-fritz.sh
#svn delete --force download_sp2fr_w920.ah
#svn delete --force download_sp2fr_w920.sh
#svn delete --force commit-freetz-jp-7390.sh
#svn delete --force commit-trunk-W920.sh


#svn revert 
#svn add * --force

#svn status
#svn diff > ../patch.diff
#cat ../patch.diff
echo "User is jpascher or your admin name on sorcefrog net, you also have to know your password!"
echo -n "   Execute Commit?'  (y/n)? "; read -n 1 -s YESNO; echo
([ "$YESNO" = "y" ] || [ "$YESNO" = "n" ]) || echo "wrong key!"
[ "$YESNO" = "y" ] &&   svn commit --message "${date} - ${comment}"
cd ..
sleep 200