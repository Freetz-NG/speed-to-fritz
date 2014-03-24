#!/bin/bash
#place your comment for this uptade here:
comment="* Update Config.in and build recover"




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
echo "-------------------------------------------------------------------------------------------------------------"
date=$(date +%Y%m%d-%H%M)
echo "this file has to be invoced in the directory where the trunk directoy is localy located."
#svn delete --force ./download_speed-to-fritz.sh
#svn revert 
#svn add * --force

#svn status
#svn diff > ../patch.diff
#cat ../patch.diff
cd trunk
echo "user is jpascher or your admin name on sorcefrog net, you also have to know your password!"
echo -n "   Execute Commit?'  (y/n)? "; read -n 1 -s YESNO; echo
([ "$YESNO" = "y" ] || [ "$YESNO" = "n" ]) || echo "wrong key!"
[ "$YESNO" = "y" ] &&   svn commit --message "${date} - ${comment}"
cd ..

