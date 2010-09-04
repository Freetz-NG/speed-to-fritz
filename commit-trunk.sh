#!/bin/bash
#place your comment for this uptade here:
comment="* Fix start-freetz.sh 
	http://www.ip-phone-forum.de/showpost.php?p=1600194&postcount=1"




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
#svn delete --force ./patch.diff
#svn delete --force ./trunk/patch.diff
#svn delete --force ./trunk/sp-to-fritz.sh
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
[ "$YESNO" = "y" ] &&   svn commit --message "${date} - ${comment}"

