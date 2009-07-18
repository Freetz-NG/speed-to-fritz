#!/bin/bash
#place your comment for this uptade here:
comment="./download_speed-to-fritz.sh added again, becaus doku would\
    need to be to changed if the name is changed"




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
#insert comment into "info.txt"
if SVN_VERSION="$(svnversion . )"; then
 let "SVN_VERSION=$(echo ${SVN_VERSION##*:} | tr -d '[:alpha:]') + 1"
 #echo "Subversion=$SVN_VERSION"
fi
date=$(date +%Y%m%d-%H%M)

#svn delete --force ./download_speed-to-fritz.sh
svn delete --force ./diff.sh
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

